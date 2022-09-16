local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isLoggedIn = LocalPlayer.state.isLoggedIn
local playerPed = PlayerPedId()
local peds = {}
local playerPot = 0
local actualBet = 0

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
        local playerData = QBCore.Functions.GetPlayerData()
        if (playerData.money.cash < 100) then
          QBCore.Functions.Notify("You're Broke GET OUT!", 'error')
        end
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

local function deletePeds()
  if not next(peds) then return end
  for i = 1, #peds do
    DeletePed(peds[i])
  end
end

local function sendCloseNui()
  SetNuiFocus(false, false)
  SendNUIMessage({
      action = "closeBlackJackTable"
  })
end

RegisterNetEvent('pp2-blackjack:client:OpenMenu', function()
  local playerData = QBCore.Functions.GetPlayerData()
  SetNuiFocus(true, true)
  SendNUIMessage({
      action = "openBlackJackTable",
      playerMaxPot = playerData.money.cash
  })
end)

RegisterNUICallback('close', function(data, cb)
  sendCloseNui()
  if playerPot ~= nil and playerPot > 0 then
    TriggerServerEvent("pp2-blackjack:server:partyTerminated", playerPot)
    PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
  else
    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
  end
  playerPot = 0
  actualBet = 0
  cb("ok")
end)

RegisterNUICallback('start', function(data, cb)
  local amount = tonumber(data.amount)
  local playerData = QBCore.Functions.GetPlayerData()
  if amount ~= nil and amount > 0 and amount <= playerData.money.cash then
    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    SendNUIMessage({
        action = "startParty",
        amount = amount,
    })
    playerPot = amount
    TriggerServerEvent("pp2-blackjack:server:partyStarted", amount)
    cb("ok")
  end
  cb(nil)
end)

RegisterNUICallback('deal', function(data, cb)
  local bet = tonumber(data.bet)
  if bet ~= nil and bet > 0 and bet <= playerPot then
    playerPot = playerPot - bet
    actualBet = bet
  else
    sendCloseNui()
    QBCore.Functions.Notify("You're a cheater GET OUT!", 'error')
  end
  cb(nil)
end)

RegisterNUICallback('doubledown', function(data, cb)
  if actualBet > 0 and actualBet <= playerPot then
    playerPot = playerPot - actualBet
    actualBet = actualBet + actualBet
  else
    sendCloseNui()
    QBCore.Functions.Notify("You're a cheater GET OUT!", 'error')
  end
  cb(nil)
end)

RegisterNUICallback('lost', function(data, cb)
  actualBet = 0
  cb(nil)
end)

RegisterNUICallback('win', function(data, cb)
  playerPot = playerPot + (actualBet * 2)
  actualBet = 0
  cb(nil)
end)

RegisterNUICallback('blackjackwin', function(data, cb)
  playerPot = playerPot + (actualBet * 2.5)
  actualBet = 0
  cb(nil)
end)

RegisterNUICallback('draw', function(data, cb)
  playerPot = playerPot + actualBet
  actualBet = 0
  cb(nil)
end)

AddEventHandler('onResourceStop', function(resource)
  if resource ~= GetCurrentResourceName() then return end
  deletePeds()
end)

CreateThread(function()
  initPeds()
end)
