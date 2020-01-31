PlayersBagOutfit = {}

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

    if PlayersBagOutfit[character.id] ~= nil then
        DestroyObject(PlayersBagOutfit[character.id])
        PlayersBagOutfit[character.id] = nil
    end
    local bagStorage = GetBagByCharacterId(character.id)
    if bagStorage ~= nil then
        local bagTemplate = InventoryItems[bagStorage.id_bag]
        local bagGameobject = CreateObject(bagTemplate.modelId, 0, 0, 0)
        PlayersBagOutfit[character.id] = bagGameobject
        SetObjectAttached(bagGameobject, ATTACH_PLAYER, player, bagTemplate.x, bagTemplate.y, bagTemplate.z, bagTemplate.rx, bagTemplate.ry, bagTemplate.rz, "spine_01")
    end
    -- Attach the bag
    --local bagGameobject = CreateObject(bag.template.modelId, 0, 0, 0)
    --bag.attachedObject = bagGameobject
    --print("attached: "..bag.attachedObject)
    --SetObjectAttached(bagGameobject, ATTACH_PLAYER, player, 
    --    bag.template.x, bag.template.y, bag.template.z, bag.template.rx, bag.template.ry, bag.template.rz, "spine_01")
end