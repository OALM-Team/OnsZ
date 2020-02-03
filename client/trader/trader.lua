function OnKeyPress(key)
    if key == "E" and not IsPlayerReloading() then
        if PlayerIsFreezed then
            CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
            return
        end
        
        CreateNotification("#ff0051", "Action impossible", "Pas encore disponible", 5000, 2)
		--CallRemoteEvent("Survival:Trader:RequestOpenTrader")
	end
end
AddEvent("OnKeyPress", OnKeyPress)