local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('pp2-blackjack:server:partyTerminated',function (amount)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if amount > 0 then
    Player.Functions.AddMoney("cash", amount, "pp2-blackjack-win")
    QBCore.Functions.Notify(src, "You won this round $" .. amount)
  end
end)

RegisterNetEvent('pp2-blackjack:server:partyStarted',function (amount)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if amount > 0 then
    Player.Functions.RemoveMoney("cash", amount, "pp2-blackjack-start")
  end
end)
