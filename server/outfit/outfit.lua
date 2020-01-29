function RequestUseOutfit(player, storage, template, uid, itemId)
    if not template.is_outfit then
        return
    end
    
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    table.insert(character.outfit, {type=template.outfit_type, itemId=itemId})
    SetPlayerOutfit(player)
    UpdatePlayerDatabase(player)
end
AddEvent("Survival:Inventory:UseItem", RequestUseOutfit)