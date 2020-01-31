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