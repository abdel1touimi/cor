local QBCore = exports['qb-core']:GetCoreObject()
local Result = nil
local NUI_status = false

RegisterNetEvent('kwk-lockpick:client:openLockpick', function(callback)
    local seconds = math.random(9,12)
    local circles = math.random(2,4)
    local success = exports['qb-lock']:StartLockPickCircle(circles, seconds, callback)
    if success then
        callback(true)
        QBCore.Functions.Notify("Lock Opened", "success")
    end
end)

function StartLockPickCircle(circles, seconds, callback)
    Result = nil
    NUI_status = true
    SendNUIMessage({
        action = 'start',
        value = circles,
		time = seconds,
    })
    while NUI_status do
        Wait(5)
        SetNuiFocus(NUI_status, false)
    end
    Wait(100)
    SetNuiFocus(false, false)
    lockpickCallback = callback
    return Result
end

RegisterNUICallback('fail', function()
        ClearPedTasks(PlayerPedId())
        Result = false
        Wait(100)
        NUI_status = false
        --print('fail')
end)

RegisterNUICallback('success', function()
	Result = true
	Wait(100)
	NUI_status = false
    SetNuiFocus(false, false)
    return Result
end)
