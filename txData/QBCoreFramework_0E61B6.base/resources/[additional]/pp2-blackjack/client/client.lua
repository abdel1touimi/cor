local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isLoggedIn = LocalPlayer.state.isLoggedIn
local playerPed = PlayerPedId()
local peds = {}

local function addPed(options)
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
    label = options.label,
    targeticon = options.icon, 
    icon = 'fa-solid fa-play',
    action = function(entity)
        if IsPedAPlayer(entity) then return false end
        TriggerEvent('pp2-blackjack:client:OpenMenu')
    end,
  }
  exports['qb-target']:AddTargetEntity(ped, {
    options = {opts},
    distance = 3.0
  })

  return ped
end

local function initPeds()
  for i = 1, #Config.BlackJackCardDealers do
    local cardDealer = Config.BlackJackCardDealers[i]
    peds[#peds+1] = addPed(cardDealer, i)
  end
end

RegisterNetEvent('pp2-blackjack:client:OpenMenu', function()
  SetNuiFocus(true, true)
  SendNUIMessage({
      action = "openBlackJackTable"
  })
end)

RegisterNUICallback('close', function(_, cb)
  SetNuiFocus(false, false)
  SendNUIMessage({
      action = "closeBlackJackTable"
  })
end)

CreateThread(function()
  initPeds()
end)
