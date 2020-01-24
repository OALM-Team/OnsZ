CurrentWeather = 1

function OnPlayerSpawn(player)
    Delay(2000, function()
        CallRemoteEvent(player, "Survival:Weather:SetNight")
    end)
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)