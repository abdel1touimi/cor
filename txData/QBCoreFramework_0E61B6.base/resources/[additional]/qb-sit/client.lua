local QBCore = exports['qb-core']:GetCoreObject()
local debugProps, sitting, lastPos, currentSitCoords, currentScenario, occupied = {}
local disableControls = false
local currentObj = nil
local currentObjData = nil

exports('sitting', function()
    return sitting
end)

Citizen.CreateThread(function()
	local waitT = 1
	while true do
		Citizen.Wait(waitT)
		if sitting then
			waitT = 1
			local playerPed = PlayerPedId()
			helpText(Config.GetUpText)
			if not IsPedUsingScenario(playerPed, currentScenario) then
				wakeup()
			end
			if IsControlPressed(0, Config.GetUpKey) and IsInputDisabled(0) and IsPedOnFoot(playerPed) then
				wakeup()		
			end
		else 
			waitT = 500
		end
	end
end)

Citizen.CreateThread(function()
	local Sitables = Config.InteractablesModels

	for _, v in pairs(Config.Interactables) do
		local model = GetHashKey(v)
		table.insert(Sitables, model)
	end
	Citizen.Wait(100)
	exports['qb-target']:AddTargetModel(Sitables, {
			options = {
				{
					icon = "fas fa-chair",
					label = "Use",
					action = function(entity)
						if IsPedAPlayer(entity) then return false end
						TriggerEvent('qb-Sit:Sit', entity)
					end,
				},
			},
			distance = Config.MaxDistance
    })
end)

RegisterNetEvent("qb-Sit:Sit", function(entity)
	local playerPed = PlayerPedId()

	if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
		wakeup()
	end

	if disableControls then
		DisableControlAction(1, 37, true)
	end

	local object, distance = entity, #(GetEntityCoords(playerPed) - GetEntityCoords(entity))

	if distance and distance < 1.4 then
		local hash = GetEntityModel(object)
		local HashFound = false
		for k,v in pairs(Config.Sitable) do
			if GetHashKey(k) == hash then
				sit(object, k, v)
				HashFound = true
				break
			end
		end
		if not HashFound then
			for i = 1, #Config.SitableModels do
				if GetEntityModel(object) == Config.SitableModels[i].model then
					HashFound = true
					sit(object, i, Config.SitableModels[i])
				end
			end
		end
	end
end)


function wakeup()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(PlayerPedId())

	TaskStartScenarioAtPosition(playerPed, currentScenario, 0.0, 0.0, 0.0, 180.0, 2, true, false)
	while IsPedUsingScenario(PlayerPedId(), currentScenario) do
		Citizen.Wait(100)
	end
	ClearPedTasks(playerPed)

	FreezeEntityPosition(playerPed, false)
	if not currentObjData.isAlreadyFreezed then
		FreezeEntityPosition(currentObj, false)
	end
	TriggerServerEvent('qb-sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
	sitting = false
	disableControls = false
end

function sit(object, modelName, data)
	if not HasEntityClearLosToEntity(PlayerPedId(), object, 17) and not data.isAlreadyFreezed then
		return
	end
	disableControls = true
	currentObj = object
	currentObjData = data

	if not data.isAlreadyFreezed then
		FreezeEntityPosition(object, true)
		PlaceObjectOnGroundProperly(object)
	end
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(PlayerPedId())
	local objectCoords = pos.x .. pos.y .. pos.z

	QBCore.Functions.TriggerCallback('qb-sit:getPlace', function(occupied)
		if occupied then
			QBCore.Functions.Notify('Chair is being used.', 'error')
		else
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('qb-sit:takePlace', objectCoords)
			
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, false)

			Citizen.Wait(2500)
			if GetEntitySpeed(PlayerPedId()) > 0 then
				ClearPedTasks(PlayerPedId())
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
			end

			sitting = true
		end
	end, objectCoords)
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
