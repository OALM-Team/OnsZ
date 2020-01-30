function RequestUseOutfit(player, storage, template, uid, itemId)
    if not template.is_outfit then
        return
    end

    local outfitItem = GetOutfitPlayerByType(player, template.outfit_type)
    if outfitItem ~= nil then  
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Impossible", "Vous avez déjà quelque chose sur cette emplacement", 10000, 2)
        return
    end
    
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    table.insert(character.outfit, {type=template.outfit_type, itemId=itemId})
    SetPlayerOutfit(player)
    UpdatePlayerDatabase(player)
    RemoveItem(player, storage.id, uid)
    RefreshOutfitInventory(player)

    for _,p in pairs(GetAllPlayers()) do
        CallRemoteEvent(p, "Survival:Player:RefreshPlayerOutfit", player)
    end
end
AddEvent("Survival:Inventory:UseItem", RequestUseOutfit)

function SetPlayerOutfit(player)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    SetPlayerPropertyValue(player, "_outfitPantId", nil, true)
    SetPlayerPropertyValue(player, "_outfitTopId", nil, true)

    for _,outfit in pairs(character.outfit) do
        if outfit.type == "pant" then
            SetPlayerPropertyValue(player, "_outfitPantId", outfit.itemId, true)
        elseif outfit.type == "top" then
            SetPlayerPropertyValue(player, "_outfitTopId", outfit.itemId, true)
        end
    end
    for _,p in pairs(GetAllPlayers()) do
        CallRemoteEvent(p, "Survival:Player:RefreshPlayerOutfit", player)
    end
end