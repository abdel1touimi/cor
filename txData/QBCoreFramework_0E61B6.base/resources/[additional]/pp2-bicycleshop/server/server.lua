local QBCore = exports['qb-core']:GetCoreObject()

local function GeneratePlate()
  local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
  local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
  if result then
      return GeneratePlate()
  else
      return plate:upper()
  end
end

local function addBicycleToPlayer(pData, cid, model, plate, src, modelPrice, cashSource)
  MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
    pData.PlayerData.license,
    cid,
    model,
    GetHashKey(model),
    '{}',
    plate,
    'pillboxgarage',
    0
  })
  TriggerClientEvent('QBCore:Notify', src, 'Nice Bike :)', 'success')
  pData.Functions.RemoveMoney(cashSource, modelPrice, 'bicycle-bought')
  TriggerClientEvent('pp2-bicycleshop:client:buyBicycle', src, model, plate)
end


-- Buy public cycle outright
RegisterNetEvent('pp2-bicycleshop:server:buyBicycle', function(options)
  local src = source
  model = options.model
  local pData = QBCore.Functions.GetPlayer(src)
  local cid = pData.PlayerData.citizenid
  local cash = pData.PlayerData.money['cash']
  local bank = pData.PlayerData.money['bank']
  local modelPrice = Config.Bicycles[model]['price']
  local plate = GeneratePlate()
  if cash > tonumber(modelPrice) then
    addBicycleToPlayer(pData, cid, model, plate, src, modelPrice, 'cash')
  elseif bank > tonumber(modelPrice) then
    addBicycleToPlayer(pData, cid, model, plate, src, modelPrice, 'bank')
  else
      TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
  end
end)
