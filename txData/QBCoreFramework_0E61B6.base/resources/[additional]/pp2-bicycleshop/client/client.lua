local QBCore = exports['qb-core']:GetCoreObject()

local blips = {}
local peds = {}
local tempShop = 1

local function addBlip(options)
  if not options.coords or type(options.coords) ~= 'table' and type(options.coords) ~= 'vector3' then return error(('addBlip() expected coords in a vector3 or table but received %s'):format(options.coords)) end
  local blip = AddBlipForCoord(options.coords.x, options.coords.y, options.coords.z)
  SetBlipSprite(blip, options.sprite or 1)
  SetBlipDisplay(blip, options.display or 4)
  SetBlipScale(blip, options.scale or 1.0)
  SetBlipColour(blip, options.colour or 1)
  SetBlipAsShortRange(blip, options.shortRange or false)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(options.title or 'No Title Given')
  EndTextCommandSetBlipName(blip)

  return blip
end

local function deleteBlips()
  if not next(blips) then return end
  for i = 1, #blips do
    local blip = blips[i]
    if DoesBlipExist(blip) then
      RemoveBlip(blip)
    end
  end
  blips = {}
end


local function addPed(options, pedIndex)
  options.model = type(options.model) == 'string' and joaat(options.model) or options.model
  RequestModel(options.model)
  while not HasModelLoaded(options.model) do
    Wait(100)
  end

  local ped = CreatePed(0, options.model, options.coords.x, options.coords.y, options.coords.z, options.coords.w, false, false)
  FreezeEntityPosition(ped, true)
  SetEntityInvincible(ped, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  TaskStartScenarioInPlace(ped, options.scenario, true, true)

  local opts = {
    label = 'Open bicycles menu',
    targeticon = 'fas fa-bicycle', 
    icon = 'fas fa-bicycle',
    action = function(entity)
        if IsPedAPlayer(entity) then return false end
        TriggerEvent('pp2-bicycleshop:client:showBicycleOptions', pedIndex)
    end,
  }
  exports['qb-target']:AddTargetEntity(ped, {
    options = {opts},
    distance = 2.0
  })

  return ped
end

local function deletePeds()
  if not next(peds) then return end
  for i = 1, #peds do
    DeletePed(peds[i])
  end
end

local function initShops()
  for i = 1, #Config.BicycleShop do
    local shop = Config.BicycleShop[i]
    if shop.showBlip then
      blips[#blips+1] = addBlip({
        coords = shop.coords,
        sprite = shop.blipData.sprite,
        display = shop.blipData.display,
        scale = shop.blipData.scale,
        colour = shop.blipData.colour,
        shortRange = true,
        title = shop.blipData.title
      })
    end
    peds[#peds+1] = addPed(shop.ped, i)
  end
end

RegisterNetEvent('pp2-bicycleshop:client:showBicycleOptions', function(shopIndex)
  tempShop = shopIndex
  local vehMenu = {
    {
        header = 'Close',
        icon = "fa-solid fa-angle-left",
    }
  }
  for k, v in pairs(Config.Bicycles) do
          vehMenu[#vehMenu + 1] = {
              header = v.name,
              txt = 'Price : $' .. v.price,
              icon = "fa-solid fa-bicycle",
              params = {
                  isServer = true,
                  event = 'pp2-bicycleshop:server:buyBicycle',
                  args = {
                    model = v.model
                  }
              }
          }
  end
  exports['qb-menu']:openMenu(vehMenu)
end)

RegisterNetEvent('pp2-bicycleshop:client:buyBicycle', function(vehicle, plate)
  QBCore.Functions.TriggerCallback(
    'QBCore:Server:SpawnVehicle',
    function(netId)
      local veh = NetToVeh(netId)
      exports['LegacyFuel']:SetFuel(veh, 100)
      SetVehicleNumberPlateText(veh, plate)
      SetEntityHeading(veh, Config.BicycleShop[tempShop]["VehicleSpawn"].w)
      TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
      TriggerServerEvent("qb-vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(veh))
    end,
    vehicle,
    Config.BicycleShop[tempShop]["VehicleSpawn"],
    true
  )
end)

AddEventHandler('onResourceStop', function(resource)
  if resource ~= GetCurrentResourceName() then return end
  deleteBlips()
  deletePeds()
end)

CreateThread(function()
  initShops()
end)
