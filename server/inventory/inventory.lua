Storages = {}
StorageGridConfig = nil

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


AddCommand("additem", function(player, item)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.admin_level == 0 then
        return
    end
    TryAddItemToCharacter(player, item)
end)

function ClientRequestInventoryData(player)
    for k, configItem in pairs(InventoryItems) do
        CallRemoteEvent(player, "Survival:Inventory:ReceiveInventoryDataConfig", k, jsonencode(configItem))
    end

    RefreshOutfitInventory(player)

    for _, storage in pairs(GetStoragesByCharacterId(GetPlayerPropertyValue(player, 'characterID'))) do
        SendStorageConfig(player, storage.id)
    end

    CallEvent("Survival:Inventory:AfterClientRequestInventoryData", player)
end
AddRemoteEvent("Survival:Inventory:ClientRequestInventoryData", ClientRequestInventoryData)

function RefreshOutfitInventory(player)
    CallRemoteEvent(player, "Survival:Inventory:ResetEquipment")
    for k, outfitItem in pairs(CharactersData[tostring(GetPlayerSteamId(player))].outfit) do
        CallRemoteEvent(player, "Survival:Inventory:ReceiveEquipment", jsonencode(outfitItem))
    end
    for _, storage in pairs(GetStoragesByCharacterId(GetPlayerPropertyValue(player, 'characterID'))) do
        if storage.id_bag ~= "" and storage.id_bag ~= nil then
            CallRemoteEvent(player, "Survival:Inventory:ReceiveEquipment", jsonencode({
                type="bag",
                itemId=storage.id_bag
            }))
        end
    end
end

function GetStoragesByCharacterId(characterId)
    local characterStorages = {}
    for _, storage in pairs(Storages) do
        if storage.id_character == characterId then
            table.insert(characterStorages, storage)
        end
    end
    return characterStorages
end

function GetBagByCharacterId(characterId)
    for _, storage in pairs(Storages) do
        if storage.id_character == characterId and storage.id_bag ~= nil and storage.id_bag ~= "" then
            return storage
        end
    end
    return nil
end

function ClearStorage(storage)
    storage.items = {}
    UpdateStorage(storage)
end

function SendStorageConfig(player, storageId) 
    local storage = Storages[storageId]
    CallRemoteEvent(player, "Survival:Inventory:ReceiveInventoryStorageConfig", storage.id, storage.name, storage.slots)
    for _, item in pairs(storage.items) do
        CallRemoteEvent(player, "Survival:Inventory:ReceiveInventoryItem", storage.id, item.uid, item.itemId, item.slot)
    end

    if storage.id_bag ~= "" and storage.id_bag ~= nil then
        CallRemoteEvent(player, "Survival:Inventory:ReceiveEquipment", jsonencode({
            type="bag",
            itemId=storage.id_bag
        }))
    end
end

function FindItemInStorage(storageId, uid)
    local storage = Storages[storageId]
    for _, item in pairs(storage.items) do
        if item.uid == uid then
            return item
        end
    end
    return nil
end

function FindItemKeyInStorage(storageId, uid)
    local storage = Storages[storageId]
    for k, item in pairs(storage.items) do
        if item.uid == uid then
            return k
        end
    end
    return nil
end

math.randomseed(os.time())
function uuid()
    math.random(); math.random(); math.random()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and  math.random(0, 0xf) or  math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

function TryAddItemToCharacter(player, itemId, excludeStorage)
    if excludeStorage == nil then
        excludeStorage = -1
    end
    local characterStoragesList = GetStoragesByCharacterId(GetPlayerPropertyValue(player, 'characterID'))
    for _,storage in pairs(characterStoragesList) do
        if storage.id ~= excludeStorage then
            local item = AddItem(storage.id, itemId, player)
            if item ~= nil then
                return true, item
            end
        end
    end
    return false, nil
end

function AddItem(storageId, itemId, player)
    local storage = Storages[storageId]
    local availableSlots = GetAvailableSlots(storageId)
    local fitSlot = nil
    for _,s in pairs(availableSlots) do
        if CanFitInThisSlot(storageId, itemId, s, -1) then
            fitSlot = s
            break
        end
    end
    if fitSlot == nil then
        if player ~= nil then
            CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Pas assez d'espace dans "..storage.name, "Faite du rangement ou libérer de la place dans votre inventaire", 10000, 2)
        end
        return nil
    end
    print("add item to slot: ".. fitSlot)
    local createdItem = {
        uid = uuid(),
        itemId = itemId,
        slot = fitSlot
    }
    table.insert(storage.items, createdItem)
    UpdateStorage(storage)
    if player ~= nil then
        local template = InventoryItems[itemId]
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#05ed4e", "Nouvelle objet", template.name.." est désormais dans votre inventaire", 5000, 1)
        CallRemoteEvent(player, "Survival:Inventory:ReceiveInventoryItem", storage.id, createdItem.uid, createdItem.itemId, createdItem.slot)
    end
    return createdItem
end

function RequestThrowItem(player, storageId, itemId)
    local storage = Storages[storageId]
    local item = FindItemInStorage(storageId, itemId)
    if item == nil then
        return
    end
    local template = InventoryItems[item.itemId]
    local itemKey = FindItemKeyInStorage(storageId, itemId)
    table.remove(storage.items, itemKey)
    UpdateStorage(storage)
    if player ~= nil then
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ffc003", "Au sol", template.name.." est désormais au sol", 5000, 2)
        CallRemoteEvent(player, "Survival:Inventory:RemoveItem", storage.id, itemId)

        local x,y,z = GetPlayerLocation(player)
        SpawnDropItem(x,y,z,item.itemId,item)
    end
end
AddRemoteEvent("Survival:Inventory:ServerRequestThrowItem", RequestThrowItem)

function RemoveItem(player, storageId, itemId)
    local storage = Storages[storageId]
    local item = FindItemInStorage(storageId, itemId)
    if item == nil then
        return
    end
    local template = InventoryItems[item.itemId]
    local itemKey = FindItemKeyInStorage(storageId, itemId)
    table.remove(storage.items, itemKey)
    UpdateStorage(storage)
    if player ~= nil then
        CallRemoteEvent(player, "Survival:Inventory:RemoveItem", storage.id, itemId)
    end
end

function GetPlayerByStorageId(storageId)
    return 1
end

function ServerRequestChangeSlotItem(player, storageId, uid, toSlot)
    local storage = Storages[storageId]
    local item = FindItemInStorage(storageId, uid)
    if item == nil then
        return
    end
    if not CanFitInThisSlot(storageId, item.itemId, tonumber(toSlot), item.uid) then
        print("item cant fit in this slot, cancel the move")
        return
    end
    item.slot = tonumber(toSlot);
    UpdateStorage(storage)
    --print(jsonencode(GetUnavailableSlots(storageId, -1)))
    print("item moved to slot: "..item.slot)
end
AddRemoteEvent("Survival:Inventory:ServerRequestChangeSlotItem", ServerRequestChangeSlotItem)

function ServerRequestChangeInventorySlotItem(player, storageId, toStorageId, uid, toSlot)
    local storage = Storages[storageId]
    local toStorage = Storages[toStorageId]
    local item = FindItemInStorage(storageId, uid)
    if item == nil then
        return
    end
    if not CanFitInThisSlot(toStorageId, item.itemId, tonumber(toSlot), item.uid) then
        print("item cant fit in this slot, cancel the move")
        return
    end
    
    local itemKey = FindItemKeyInStorage(storageId, uid)
    table.remove(storage.items, itemKey)

    item.slot = tonumber(toSlot);
    table.insert(toStorage.items, item)

    UpdateStorage(toStorage)
    UpdateStorage(storage)

    if player ~= nil then
        local template = InventoryItems[item.itemId]
        if toStorage.id_character ~= storage.id_character then
            if toStorage.id_character == GetPlayerPropertyValue(player, 'characterID') then
                CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#05ed4e", "Nouvelle objet", template.name.." est désormais dans votre inventaire", 5000, 1)
            else
                CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ffc003", "Déposer", template.name.." est désormais dans le conteneur", 5000, 2)
            end
        end
    end

    --print(jsonencode(GetUnavailableSlots(storageId, -1)))
    print("item moved to another inventory to slot: "..item.slot)
end
AddRemoteEvent("Survival:Inventory:ServerRequestChangeInventorySlotItem", ServerRequestChangeInventorySlotItem)

function InitStorageGridConfig()
    if StorageGridConfig ~= nil then
        return
    end
    StorageGridConfig={}
    local i = 0
    for y = 0, 100 do
        for x = 0, 7 do
            StorageGridConfig[i] = {
                slotId = i,
                x = x,
                y = y
            }
            i = i + 1
        end
    end
end
InitStorageGridConfig()

function FindSlotByPosition(x,y)
    for k,slot in pairs(StorageGridConfig) do
        if slot.x == x and slot.y == y then
            return slot
        end
    end
    return nil
end

function GetSlotInDirection(slot, direction, offset)
    local posXY = StorageGridConfig[slot]
    local found = nil
    if posXY ~= nil then
        if direction == "bottom" then
            found = FindSlotByPosition(posXY.x, posXY.y + offset)
        elseif direction == "top" then
            found = FindSlotByPosition(posXY.x, posXY.y - offset)
        elseif direction == "right" then
            found = FindSlotByPosition(posXY.x + offset, posXY.y)
        elseif direction == "left" then
            found = FindSlotByPosition(posXY.x - offset, posXY.y)
        end
    end
    return found
end

function GetItemSlotsClaimed(storageId, itemId, slot)
    local template = InventoryItems[itemId]
    local position = StorageGridConfig[slot]
    local claimedSlots = {}
    table.insert(claimedSlots, slot)
    local currentSlot = slot
    for y = 0, template.dimensions.h - 1 do
        for x = 1, template.dimensions.w - 1 do
            if GetSlotInDirection(currentSlot, "right", x) ~= nil then
                table.insert(claimedSlots, GetSlotInDirection(currentSlot, "right", x).slotId)
            else
                break
            end
        end
        
        if GetSlotInDirection(currentSlot, "bottom", 1) == nil then
            break 
        end
        currentSlot = GetSlotInDirection(currentSlot, "bottom", 1).slotId
        if template.dimensions.h - 1 ~= y then
            table.insert(claimedSlots, currentSlot)
        end
    end
    return claimedSlots
end

function GetUnavailableSlots(storageId, uid)
    local slots = {}
    local storage = Storages[storageId]
    for _,item in pairs(storage.items) do
        local pass = false
        if uid ~= -1 then
            if uid == item.uid then
                pass = true
            end
        end
        if not pass then
            local claimed = GetItemSlotsClaimed(storageId, item.itemId, item.slot)
            for _, s in pairs(claimed) do
                table.insert(slots, s)
            end
        end
    end
    return slots
end

function GetAvailableSlots(storageId)
    local slots = {}
    local storage = Storages[storageId]
    for i = 0, storage.slots - 1 do
        if IsSlotAvailable(storageId, i) then
            table.insert(slots, i)
        end
    end
    return slots
end

function IsSlotAvailable(storageId, slot, uid)
    local storage = Storages[storageId]
    local slotUnavailable = GetUnavailableSlots(storageId, uid)
    for _,s in pairs(slotUnavailable) do
        if s == slot then
            return false
        end
    end
    return true
end

function CheckExistSlot(storageId, slot) 
    local storage = Storages[storageId]
    if slot > storage.slots - 1 or slot < 0 then
        return false
    end
    return true
end

function CanFitInThisSlot(storageId, itemId, slot, uid)
    local slotUnavailable = GetUnavailableSlots(storageId, uid)
    local slotNeeded = GetItemSlotsClaimed(storageId, itemId, slot)
    for _, s in pairs(slotNeeded) do
        if IsSlotAvailable(storageId, s, uid) == false then
            return false
        end
        if CheckExistSlot(storageId, s) == false then
            return false
        end
    end
    local template = InventoryItems[itemId]
    if(tablelength(slotNeeded) ~= (template.dimensions.w * template.dimensions.h)) then
        return false
    end
    return true
end

function InitStorageForCharacter(character, slots, callback)
    local query = mariadb_prepare(sql, "INSERT INTO `tbl_storage` (`name`, `id_character`, `slots`, `data`)" ..
        "VALUES ('?', '?', '?', '?');", "inventaire", character.id, slots, "[]")
    mariadb_query(sql, query, function()
        local id = mariadb_get_insert_id()
        local characterStorage = {
            id = tostring(id),
            name = "inventaire",
            id_character = character.id,
            slots = slots,
            items = {},
            type = "character"
        }
        Storages[characterStorage.id] = characterStorage
        print("new storage character id: " .. id)
        callback(characterStorage)
    end)
end

function LoadStoragesForCharacter(character, callback)
    local query = mariadb_prepare(sql, "SELECT * FROM `tbl_storage` WHERE id_character='?';", character.id)
    mariadb_query(sql, query, function()
        for i=1,mariadb_get_row_count() do
			local result = mariadb_get_assoc(i)
			
			local storage = {
				id = tostring(mariadb_get_value_index_int(i, 1)),
                name = mariadb_get_value_index(i, 2),
                id_character = mariadb_get_value_index_int(i, 3),
                id_bag = mariadb_get_value_index(i, 4),
                slots = mariadb_get_value_index_int(i, 5),
                items = jsondecode(mariadb_get_value_index(i, 6)),
                type = "character"
            }
            Storages[storage.id] = storage
			print("loaded storage id: " .. storage.id)
        end
        callback()
    end)
end

function UpdateStorage(storage)
    if storage.type == "character" then
        local query = mariadb_prepare(sql, "UPDATE `tbl_storage` SET data='?' WHERE id_storage='?';",
            jsonencode(storage.items), tonumber(storage.id))
        mariadb_query(sql, query, function()
            print("storage updated")
        end)
    end
end

function ServerRequestUseItem(player, storageId, uid)
    local storage = Storages[storageId]
    local item = FindItemInStorage(storageId, uid)
    if item == nil then
        return
    end
    local template = InventoryItems[item.itemId]
    
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.is_dead == 1 then
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Action impossible", "Vous êtes mort", 5000, 2)
        return
    end
    CallEvent("Survival:Inventory:UseItem", player, storage, template, uid, item.itemId)
end
AddRemoteEvent("Survival:Inventory:ServerRequestUseItem", ServerRequestUseItem)

function GetOutfitPlayerByType(player, outfitType)
    for k, outfitItem in pairs(CharactersData[tostring(GetPlayerSteamId(player))].outfit) do
        if outfitItem.type == outfitType then
            return outfitItem
        end
    end
    return nil
end

function RemoveOutfitPlayerByType(player, outfitType)
    for k, outfitItem in pairs(CharactersData[tostring(GetPlayerSteamId(player))].outfit) do
        if outfitItem.type == outfitType then
            table.remove(CharactersData[tostring(GetPlayerSteamId(player))].outfit, k)
        end
    end
end

function ServerRequestUnequipOutfit(player, outfitType)
    if outfitType == "bag" then
        RequestUnequipBag(player)
        return
    end

    local outfitItem = GetOutfitPlayerByType(player, outfitType)
    if outfitItem == nil then
        return
    end

    if TryAddItemToCharacter(player, outfitItem.itemId) then
        RemoveOutfitPlayerByType(player, outfitType)
        RefreshOutfitInventory(player)
        UpdatePlayerDatabase(player)
        SetPlayerOutfit(player)
    end
end
AddRemoteEvent("Survival:Inventory:ServerRequestUnequipOutfit", ServerRequestUnequipOutfit)

function RequestUnequipBag(player, drop)
    if drop == nil then
        drop = false
    end
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    local bag = GetBagByCharacterId(character.id)
    if bag == nil then
        return
    end
    local x,y,z = GetPlayerLocation(player)
    for _,itemBag in pairs(bag.items) do
        SpawnDropItem(x,y,z,itemBag.itemId,itemBag)
    end
    DeleteStorageForCharacter(character, bag.id, function()
        if not drop then
            if not TryAddItemToCharacter(player, bag.id_bag, bag.id) then
                SpawnDropItem(x,y,z,bag.id_bag,nil)
            end
        else
            SpawnDropItem(x,y,z,bag.id_bag,nil)
        end
        Storages[bag.id] = nil
        CallRemoteEvent(player, "Survival:Inventory:ClientCloseInventoryUI")
        SetPlayerOutfit(player)
    end)
end

function RequestUseBagItem(player, storage, template, uid, itemId)
    if not template.is_bag then
        return
    end
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if GetBagByCharacterId(character.id) == nil then
        InsertStorageForCharacter(character, template.name, itemId, template.slots, function(newStorage)
            RemoveItem(player, storage.id, uid)
            SendStorageConfig(player, newStorage.id)
            SetPlayerOutfit(player)
        end)
    else 
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Impossible", "Vous avez déjà un sac sur vous", 10000, 2)
    end
end
AddEvent("Survival:Inventory:UseItem", RequestUseBagItem)

function InsertStorageForCharacter(character, name, id_bag, slots, callback)
    local query = mariadb_prepare(sql, "INSERT INTO `tbl_storage` (`name`, `id_character`, `id_bag`, `slots`, `data`)" ..
        "VALUES ('?', '?', '?', '?', '?');", name, character.id, id_bag, slots, "[]")
    mariadb_query(sql, query, function()
        local id = mariadb_get_insert_id()
        local characterStorage = {
            id = tostring(id),
            name = name,
            id_character = character.id,
            id_bag = id_bag,
            slots = slots,
            items = {},
            type = "character"
        }
        Storages[characterStorage.id] = characterStorage
        print("new bag storage character id: " .. id)
        callback(characterStorage)
    end)
end

function DeleteStorageForCharacter(character, id, callback)
    local query = mariadb_prepare(sql, "DELETE FROM `tbl_storage` WHERE id_character='?' AND id_storage='?'",
        character.id, tonumber(id))
    mariadb_query(sql, query, function()
        print("delete bag storage character id: " .. id)
        callback()
    end)
end

function SaveCharacterStorages(character)
    for _,storage in pairs(GetStoragesByCharacterId(character.id)) do
        UpdateStorage(storage)
    end
end

function GetItemCountInStorages(player, itemId)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    local i = 0
    for k,storage in pairs(GetStoragesByCharacterId(character.id)) do
        for _,item in pairs(storage.items) do
            if item.itemId == itemId then
                i = i + 1
            end
        end
    end
    return i
end

function RemoveMultipleItemsInStorages(player, itemId, count)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    local i = 0
    for k,storage in pairs(GetStoragesByCharacterId(character.id)) do
        for _,item in pairs(storage.items) do
            if item.itemId == itemId then
                i = i + 1
                RemoveItem(player, storage.id, item.uid)
                if i == count then
                    return
                end
            end
        end
    end
end