AddEvent("OnPlayerDeath", function(player)
    SetPlayerRespawnTime(player, 60000 * 1)

    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    character.is_dead = 1
    character.health = 0
    UpdatePlayerDatabase(player)
    
    -- reset radiation
    character.in_radiation = false
    character.radiation_value = 0
    character.radiation_zone = nil
    SetPlayerPropertyValue(player, '_radiationStock', character.radiation_value, true)

    local x,y,z = GetPlayerLocation(player)
    for _,storage in pairs(GetStoragesByCharacterId(character.id)) do
        SpawnLootbox(x,y,z, "", storage)
        ClearStorage(storage)
    end

    CallRemoteEvent(player, "Survival:GlobalUI:SetDeathScreen", "true")
end)

function SetDeadPlayer(player)
    SetPlayerHealth(player, 0)
end

AddCommand("kill", function(player)
    SetDeadPlayer(player)
end)