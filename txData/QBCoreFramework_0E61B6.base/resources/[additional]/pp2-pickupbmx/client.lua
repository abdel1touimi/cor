local QBCore = exports['qb-core']:GetCoreObject()

local bmxID = 1131912276
local bmxModel = 'bmx'
local attachedBMX = false;

exports['qb-target']:AddTargetModel(bmxModel, {
	options = {
		{
      targeticon = 'fas fa-bicycle', 
      icon = 'fas fa-bicycle',
      action = function(entity)
        if IsPedAPlayer(entity) then return false end
        TriggerEvent('pp2-pickupbmx:client:fetchBMX', entity)
      end,
      type = 'client',
			label = "Pickup BMX",
		},
	},
	distance = 2.0,
})

local function LoadThaAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    return true
end

local function RemoveBmxFromScene(entity)
  NetworkRegisterEntityAsNetworked(entity)
  Wait(100)
  NetworkRequestControlOfEntity(entity)
  SetEntityAsMissionEntity(entity)
  Wait(100)
  DeleteEntity(entity)
end

RegisterNetEvent('pp2-pickupbmx:client:fetchBMX', function(bmxEntity)
  local playerPed = PlayerPedId()
  local hasItem = QBCore.Functions.HasItem('bmx')
  if not hasItem then
    local colorPrimary, colorSecondary = GetVehicleColours(bmxEntity)
    local perl, wheel = GetVehicleExtraColours(bmxEntity)
    local plate = GetVehicleNumberPlateText(bmxEntity)
    LoadThaAnim('anim@mp_snowball')
    TaskPlayAnim(playerPed, 'anim@mp_snowball', 'pickup_snowball', 8.0, 8.0, -1, 48, 1, false, false, false)
    TriggerServerEvent('pp2-pickupbmx:server:StoreBMX', 'bmx', colorPrimary, colorSecondary, perl, plate)
    RemoveBmxFromScene(bmxEntity)
    Wait(1000)
  else
    QBCore.Functions.Notify('You already have a bike on you.', 'error', 5000)
  end
end)

RegisterNetEvent('pp2-pickupbmx:client:placeBMX', function(prim,sec,perl,plate)
  local playerPed = PlayerPedId()
  local forward = GetEntityForwardVector(playerPed)
  local coords = GetEntityCoords(playerPed) + forward * 1
  LoadThaAnim('anim@mp_snowball')
  TaskPlayAnim(playerPed, 'anim@mp_snowball', 'pickup_snowball', 8.0, 8.0, -1, 48, 1, false, false, false)
  Wait(1000)
  while not HasModelLoaded(bmxID) do
    RequestModel(bmxID)
    Citizen.Wait(10)
  end
  if HasModelLoaded(bmxID) then
    local createdbmx = CreateVehicle(bmxID, coords, 1.0, true, true)
    if createdbmx ~= 0 then
      SetVehicleColours(createdbmx, prim, sec)
      SetVehicleExtraColours(createdbmx, perl, 0)
      SetVehicleNumberPlateText(createdbmx, plate)
      SetEntityHeading(createdbmx, GetEntityHeading(playerPed))
    end
  end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  local playerPed = PlayerPedId()
	while true do
		Wait(100)
		if Config.EnableAttach then
      local hasItem = QBCore.Functions.HasItem('bmx')
      if hasItem and not attachedBMX then
        while not HasModelLoaded(bmxID) do
          RequestModel(bmxID)
          Citizen.Wait(10)
        end
        local forward = GetEntityForwardVector(playerPed)
        local coords = GetEntityCoords(playerPed) + forward * 1
        local createdbmx = CreateVehicle(bmxID, coords, 1.0, true, true)
        AttachEntityToEntity(createdbmx, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), 0.08, -0.25, 0.0, 10.0, 10.0, 90.0, false, false, false, false, 2, true)
        attachedBMX = createdbmx
      elseif not hasItem and attachedBMX then
        RemoveBmxFromScene(attachedBMX)
        attachedBMX = false
      end
    end
	end
end)
