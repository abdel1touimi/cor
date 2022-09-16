local QBCore = exports['qb-core']:GetCoreObject()

local bmxID = 1131912276
local models = {
    'bmx',
}
local attachedBMX = false;

exports['qb-target']:AddTargetModel(models, {
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

local function attachBMXToPlayer(bmxEntity)
  AttachEntityToEntity(bmxEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), 0.08, -0.25, 0.0, 10.0, 10.0, 90.0, false, false, false, false, 2, true)
  attachedBMX = bmxEntity
end

RegisterNetEvent('pp2-pickupbmx:client:fetchBMX', function(bmxEntity)
  local playerPed = PlayerPedId()
  local hasItem = QBCore.Functions.HasItem('bmx')
  if not hasItem then
    local colorPrimary, colorSecondary = GetVehicleColours(bmxEntity)
    local perl, wheel = GetVehicleExtraColours(bmxEntity)
    local plate = GetVehicleNumberPlateText(bmxEntity)
    NetworkRequestControlOfEntity(bmxEntity)
    LoadThaAnim('anim@mp_snowball')
    TaskPlayAnim(playerPed, 'anim@mp_snowball', 'pickup_snowball', 8.0, 8.0, -1, 48, 1, false, false, false)
    TriggerServerEvent('pp2-pickupbmx:server:StoreBMX', 'bmx', colorPrimary, colorSecondary, perl, plate)
    Wait(1000)
    if Config.EnableAttach then
      attachBMXToPlayer(bmxEntity)
    else
      DeleteEntity(bmxEntity)
    end
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
  if attachedBMX and Config.EnableAttach then
    DeleteEntity(attachedBMX)
    attachedBMX = false
  end
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
