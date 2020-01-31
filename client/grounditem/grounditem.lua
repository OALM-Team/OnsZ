function OnKeyPress(key)
    if key == "E" and not IsPlayerReloading() then
        if PlayerIsFreezed then
            CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
            return
        end
		CallRemoteEvent("Survival:GroundItem:ConfirmPickup")
	end
end
AddEvent("OnKeyPress", OnKeyPress)