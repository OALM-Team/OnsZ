function RequestUseBandageItem(player, storage, template, uid, itemId)
    if itemId ~= "bandage" then
        return
    end
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if GetPlayerHealth(player) == 100 then
        return
    end
    RemoveItem(player, storage.id, uid)
    
    CallRemoteEvent(player, "Survival:Player:FreezePlayer")
    CallRemoteEvent(player, "Survival:GlobalUI:AddProgressBar", "use_bandage", "Bandage", "#17b802", 5)
    SetPlayerAnimation(player, "LOCKDOOR")
    Delay(5000, function()
        CallRemoteEvent(player, "Survival:Player:UnFreezePlayer")
        SetPlayerAnimation(player, "STOP")
        SetPlayerHealth(player, GetPlayerHealth(player) + 10)
        if GetPlayerHealth(player) > 100 then
            SetPlayerHealth(player, 100)
        end
        UpdatePlayerDatabase(player)
    end)
end
AddEvent("Survival:Inventory:UseItem", RequestUseBandageItem)

function ServerRequestTearItem(player, inventoryId, uid)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    RemoveItem(player, inventoryId, uid)
    CallRemoteEvent(player, "Survival:Player:FreezePlayer")
    CallRemoteEvent(player, "Survival:GlobalUI:AddProgressBar", "tear_item", "Faire des bandages", "#17b802", 5)
    SetPlayerAnimation(player, "LOCKDOOR")
    Delay(5000, function()
        local x,y,z = GetPlayerLocation(player)
        CallRemoteEvent(player, "Survival:Player:UnFreezePlayer")
        SetPlayerAnimation(player, "STOP")

        if not TryAddItemToCharacter(player, "bandage") then
            SpawnDropItem(x,y,z, "bandage")
        end
        if not TryAddItemToCharacter(player, "bandage") then
            SpawnDropItem(x,y,z, "bandage")
        end
    end)
end
AddRemoteEvent("Survival:Inventory:ServerRequestTearItem", ServerRequestTearItem)

AddCommand("useanim", function(player, anim)
    SetPlayerAnimation(player, anim)
end)