function OnPlayerJoin(player)
    SetPlayerPropertyValue(player, 'clothingID', 19, true)
    SetPlayerSpawnLocation(player, 45767, 48163, 2265, 90.0)
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

function OnPlayerSpawn(player)
    Delay(2000, function()
        SetPlayerLocation(player, 45767, 48163, 2265, 90.0)
        CallRemoteEvent(player, "Survival:Player:SetPlayerClothing", player, 19)
        SetPlayerPropertyValue(player, 'clothingID', 19, true)
        RequestPlayIntroCinematic(player)
    end)
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)