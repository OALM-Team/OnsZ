AddEvent("OnPlayerDeath", function(player)
    SetPlayerRespawnTime(player, 60000 * 1)

    CallRemoteEvent(player, "Survival:Player:FreezePlayer")
    CallRemoteEvent(player, "Survival:GlobalUI:AddProgressBar", "respawn", "Réapparition", "#ba0000", 60)

    local x,y,z = GetPlayerLocation(player)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    character.is_dead = 1
    character.health = 0
    character.outfit = {}
    RequestUnequipBag(player, true)
    SetPlayerOutfit(player)

    -- drop weapons
    for _,weapon in pairs(character.weapons) do
        if weapon.weaponId ~= 1 then
            SpawnDropItem(x,y,z, GetWeaponTemplateIdByWeaponId(weapon.weaponId))
        end
    end
    character.weapons = {}

    UpdatePlayerDatabase(player)
    
    -- reset radiation
    character.in_radiation = false
    character.radiation_value = 0
    character.radiation_zone = nil
    SetPlayerPropertyValue(player, '_radiationStock', character.radiation_value, true)

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