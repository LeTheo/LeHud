 
PlayerData = {}
vehActive = false
hudActive = false

 

Citizen.CreateThread(function()
  while true do
    local data = false
    if hudActive then
      for i=0, 5 do
        if IsVehicleDoorFullyOpen(vehActive, i) == 1 then
          data = true
        end
      end
      BrokenDor = data
      Citizen.Wait(900)
    else
      Citizen.Wait(4231)
    end
  end
end)
local beltstatus = false
RegisterNetEvent('hud:belt')
AddEventHandler('hud:belt', function(belt) 
        beltstatus = belt
end)				 

function checkPlayerInVehicle()
	SetTimeout(1500, checkPlayerInVehicle)
	local Ped = GetPlayerPed(-1)
	vehActive = IsPedInAnyVehicle(Ped)

	if vehActive then
		local pedSeat = GetPedInVehicleSeat(GetVehiclePedIsUsing(Ped), -1)
		if pedSeat == Ped and not hudActive then
			SendNUIMessage({ action = "carHUD", value = true })
            hudActive = true
		end
	elseif hudActive then
        SendNUIMessage({ action = "carHUD", value = false })
        hudActive = false
	end
end
GetVehFuel = function(Veh)
  return GetVehicleFuelLevel(Veh)-- exports["LegacyFuel"]:GetFuel(Veh)
end
    
function checkPlayerVehicleSpeed()
	SetTimeout(100, checkPlayerVehicleSpeed)
	local Ped = GetPlayerPed(-1)
    if vehActive and hudActive then
        PedCar = GetVehiclePedIsUsing(PlayerPedId())
        carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
        local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(GetVehiclePedIsUsing(GetPlayerPed(-1)))
        local vehicleLight
        if vehicleLights == 1 and vehicleHighlights == 0 then
            vehicleLight = true
        elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
            vehicleLight = true
        else
            vehicleLight = false
        end
        SendNUIMessage({
        action = "carData",
        carSpeed = carSpeed,
        engine = GetVehicleBodyHealth(GetVehiclePedIsUsing(Ped)),
        doors = BrokenDor,
        lights = vehicleLight,
        seatbelt = beltstatus,
        fuel = string.format("%.2f",GetVehFuel(GetVehiclePedIsUsing(PlayerPedId())))
        })
    end
end
SetTimeout(2500, checkPlayerInVehicle)
SetTimeout(2500, checkPlayerVehicleSpeed)

RegisterNetEvent('HudPlayerLoad')
AddEventHandler('HudPlayerLoad', function(source)

  PlayerLoadHud = true
  
  Citizen.CreateThread(function()
    Citizen.Wait(1000)
    TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
      TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
      TriggerEvent('esx_status:getStatus', 'stress', function(stress)
        local hunger = hunger.getPercent()
        local thirst = thirst.getPercent()
        local stress = stress.getPercent()
        SendNUIMessage({ action = "setHunger", hunger = hunger })
        SendNUIMessage({ action = "setThirst", thirst = thirst })
        SendNUIMessage({ action = "setStress", stress = stress })
      end)
      end)
    end)
end)

RegisterNetEvent("esx_status:onTick")
AddEventHandler("esx_status:onTick", function(data)
  for _,v in pairs(data) do
    if v.name == "hunger" then
    SendNUIMessage({ action = "setHunger", hunger = math.ceil(v.percent) })
    elseif v.name == "thirst" then
    SendNUIMessage({ action = "setThirst", thirst = math.ceil(v.percent) })
    elseif v.name == "stress" then
    SendNUIMessage({ action = "setStress", stress = math.ceil(v.percent) })
    end
  end
end)

RegisterNetEvent('esx_status:update')
AddEventHandler('esx_status:update', function(data)
  for _,v in pairs(data) do
    if v.name == "hunger" then
        SendNUIMessage({ action = "setHunger", hunger = math.ceil(v.percent) })
       elseif v.name == "thirst" then
        SendNUIMessage({ action = "setThirst", thirst = math.ceil(v.percent) })
       elseif v.name == "stress" then
        SendNUIMessage({ action = "setStress", stress = math.ceil(v.percent) })
    end
  end
end)



CreateThread(function()
	while true do
		Wait(1500)
		local playerPed  = PlayerPedId()
		local Health = (GetEntityHealth(playerPed)-100)
		local armor = GetPedArmour(playerPed)
        SendNUIMessage({ action = "setStatus", health = Health, armor = armor })
	end
end)

end)

local lastStreet = nil
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(2000)
    local pos = GetEntityCoords(PlayerPedId())
    local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local zoneLabel = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z));
    SendNUIMessage({ action = "setStreet", strt1 = zoneLabel, strt2 = GetStreetNameFromHashKey(var1) })
  end
end)


local isStamina = false
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1500)
    local playerPed = PlayerId()
    local oxygen = GetPlayerSprintStaminaRemaining(playerPed)
    if lastOxygen ~= oxygen then
      if not isStamina then SendNUIMessage({ action = "staminaShow", value = true }) end
      isStamina = true
      -- Stamina
      if not IsEntityInWater(player) then
        oxygen = 100 - GetPlayerSprintStaminaRemaining(playerPed)
      end
      -- Oxygen
      if IsEntityInWater(player) then
        oxygen = GetPlayerUnderwaterTimeRemaining(playerPed) * 10
      end
      SendNUIMessage({ action = "setstamina", value = math.ceil(oxygen) })
      lastOxygen = GetPlayerSprintStaminaRemaining(playerPed)
    else
      isStamina = false
      SendNUIMessage({ action = "staminaShow", value = false })
      Citizen.Wait(2000)
    end
  end
end)




local canopenUI = false  
 
    --[[ RegisterCommand('strs', function(source, args, rawCommand)
         canopenUI = not canopenUI
    end, false)]]
	
RegisterNetEvent('hud:allowUI')
AddEventHandler('hud:allowUI', function(data)
  canopenUI = not canopenUI
end)

AddEventHandler('playerSpawned', function()
   canopenUI = true
end)

local pauseActive = false
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(20)
  
		  if not canopenUI then 
			SendNUIMessage({ action = "show", value = false })
				pauseActive = true
			else
			if IsPauseMenuActive() and not pauseActive then
				pauseActive = true
				SendNUIMessage({ action = "show", value = false })
			  end
			  if not IsPauseMenuActive() and pauseActive then
				pauseActive = false
				SendNUIMessage({ action = "show", value = true })
			  end
		  end
	end
 end) 
   
TriggerEvent("HudPlayerLoad")



Citizen.CreateThread(function()
    while true do
       
		if IsPedInAnyVehicle(PlayerPedId(), true) then
			DisplayRadar(true)
		else
			DisplayRadar(false)	
		end	 
        Citizen.Wait(500)
    end
end)