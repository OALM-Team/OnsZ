VehiclesOnMap = {}
VehiclesSpawns = {
	{x=128270,y=80650,z=1566,h=-140, vehicles={1,4,5,7,11,12,19,22,25}},
	{x=139946,y=193993,z=1282,h=-178, vehicles={1,4,5,7,11,12,19,22,25}},
	{x=215887,y=163008,z=-1305,h=173, vehicles={1,4,5,7,11,12,19,22,25}},
	{x=93226,y=92255,z=1914,h=90, vehicles={1,4,5,7,11,12,19,22,25}}
}

AddCommand("v", function(player, model)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.admin_level == 0 then
        return
    end
    if (model == nil) then
		return AddPlayerChat(player, "Usage: /v <model>")
	end

	model = tonumber(model)

	if (model < 1 or model > 25) then
		return AddPlayerChat(player, "Vehicle model "..model.." does not exist.")
	end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	local vehicle = CreateVehicle(model, x, y, z, h)
	if (vehicle == false) then
		return AddPlayerChat(player, "Failed to spawn your vehicle")
	end

	SetVehicleLicensePlate(vehicle, "OnsZ BETA")
	AttachVehicleNitro(vehicle, true)

	if (model == 8) then
		-- Set Ambulance blue color and license plate text
		SetVehicleColor(vehicle, RGB(0.0, 60.0, 240.0))
		SetVehicleLicensePlate(vehicle, "EMS-02")
	end

    -- Set us in the driver seat
	SetPlayerInVehicle(player, vehicle)

	AddPlayerChat(player, "Vehicle spawned! (New ID: "..vehicle..")")
end)

AddCommand("getloc", function(player)
	local x,y,z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)
	AddPlayerChat(player, "x="..x..", y="..y..", z="..z..", h="..h)
end)

function OnPackageStart()
    CreateTimer(function()
        CheckVehicleSpawn()
	end, 60000*10)
	
	CreateTimer(function()
        CheckFuel()
	end, 35000)
	--end, 1000)
	
	CreateTimer(function()
        CheckEngines()
    end, 300)
end
AddEvent("OnPackageStart", OnPackageStart)

function CheckVehicleSpawn()
	for _,spawn in pairs(VehiclesSpawns) do
		if Random(1, 5) == 1 then
			SpawnVehicle(spawn.vehicles[Random(1, tablelength(spawn.vehicles))], spawn)
		end
	end
end

function SpawnVehicle(vehicleTypeId, position)
	for _, v in pairs(GetAllVehicles()) do
		local vx,vy,vz = GetVehicleLocation(v)
		if GetDistance3D(position.x, position.y, position.z, vx, vy, vz) < 5000 then
			return
		end
	end
	
	local vehicle = CreateVehicle(vehicleTypeId, position.x, position.y, position.z, position.h)
	
	local id = uuid()
	SetVehicleColor(vehicle, RGB(Random(0,255), Random(0,255), Random(0,255)))
	SetVehicleLicensePlate(vehicle, "OnsZ BETA")
	SetVehiclePropertyValue(vehicle, "_fuel", Random(15, 50), true)
	SetVehiclePropertyValue(vehicle, "id", id, true)
	VehiclesOnMap[id] = vehicle
end

function CheckFuel()
	for _, v in pairs(GetAllVehicles()) do
		if GetPlayerName(GetVehicleDriver(v)) ~= false and GetVehicleDriver(v) ~= "false" and GetVehicleEngineState(v) then
			local fuel = GetVehiclePropertyValue(v, "_fuel")
			fuel = fuel - 1
			if fuel < 0 then
				fuel = 0
			end
			SetVehiclePropertyValue(v, "_fuel", fuel, true)
		end
	end
end

function CheckEngines()
	for _, v in pairs(GetAllVehicles()) do
		local fuel = GetVehiclePropertyValue(v, "_fuel")
		if fuel <= 0 then
			StopVehicleEngine(v)
		end
	end
end

function RequestUseGasItem(player, storage, template, uid, itemId)
    if itemId ~= "gas" then
        return
    end
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
	local veh, _ = GetNearestVehicle(player)
	if veh == 0 then
		CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Action impossible", "Pas de véhicule à proximité", 5000, 2)
        return
    end

    local x,y,z = GetPlayerLocation(player)
    local vehX, vehY, vehZ = GetVehicleLocation(veh)
    
    if GetDistance2D(x, y, vehX, vehY) > 250 then
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Action impossible", "Pas de véhicule à proximité", 5000, 2)
        return
    end

    SetPlayerAnimation(player, "FISHING")
    CallRemoteEvent(player, "Survival:Player:FreezePlayer")
    StopVehicleEngine(veh)
	CallRemoteEvent(player, "Survival:GlobalUI:AddProgressBar", "blood_bag_heal", "Faire le plein", "#914339", 10)
	
    Delay(10000, function()
        RemoveItem(player, storage.id, uid)
        SetVehiclePropertyValue(veh, "_fuel", 100)
        CallRemoteEvent(player, "Survival:Player:UnFreezePlayer")
        SetPlayerAnimation(player, "STOP")
        StartVehicleEngine(veh)
    end)
end
AddEvent("Survival:Inventory:UseItem", RequestUseGasItem)

function GetNearestVehicle(player)
	local vehicles = GetStreamedVehiclesForPlayer(player)
	local found = 0
	local nearest_dist = 999999.9
	local x, y, z = GetPlayerLocation(player)

	for _,v in pairs(vehicles) do
		local x2, y2, z2 = GetVehicleLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < nearest_dist then
			nearest_dist = dist
			found = v
		end
	end
	return found, nearest_dist
end