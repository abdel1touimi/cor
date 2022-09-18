local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('pp2-pickupbmx:server:StoreBMX', function(bmxitem, prim, sec, perl, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bmx = {}
    bmx.prim = prim
    bmx.sec = sec
    bmx.perl = perl
    bmx.plate = plate
    Player.Functions.AddItem(bmxitem, 1, nil, bmx)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[bmxitem], 'add')
end)

QBCore.Functions.CreateUseableItem("bmx", function(source, item)
  local Player = QBCore.Functions.GetPlayer(source)
  if Player.Functions.RemoveItem(item.name, 1, item.slot) then
    TriggerClientEvent('pp2-pickupbmx:client:placeBMX', source, item.info.prim,item.info.sec,item.info.perl,item.info.plate)
  end
end)
