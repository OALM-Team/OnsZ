GroundItems = {}

AddCommand("test", function(player)
    local x,y,z = GetPlayerLocation(player)
    SpawnDropItem(x,y,z,"bag_1")
end)

function SpawnDropItem(x,y,z, itemId, itemObj)
    local x = x + math.random(-120,120)
    local y = y + math.random(-120,120)
    
    local itemTemplate = InventoryItems[itemId]
    local pickupModel = 509
    local pickupScale = 0.5

    if itemObj ~= nil then
        itemObj ={
            uid =  uuid(),
            itemId = itemObj.itemId
        }
    else
        itemObj = {
            uid = uuid(),
            itemId = itemId
        }
    end

    if itemTemplate.pickup_model ~= nil and itemTemplate.pickup_model ~= -1 then
        pickupModel = itemTemplate.pickup_model
        pickupScale = itemTemplate.pickup_scale
    end

    local pickup = CreatePickup(pickupModel, x, y, z - 70)
    SetPickupScale(pickup, pickupScale, pickupScale, pickupScale)
    SetPickupPropertyValue(pickup, "loc_x", x, true)
    SetPickupPropertyValue(pickup, "loc_y", y, true)
    SetPickupPropertyValue(pickup, "loc_z", z - 70, true)
    local text = CreateText3D(itemTemplate.name.." [E]", 15.0, x, y, z, 0,0,0)
    SetText3DAttached(text, 3,pickup,0,0,70)

    GroundItems[pickup] = {
        pickup = pickup,
        itemId = itemId,
        text = text,
        x = x,
        y = y,
        z = z,
        item = {
            uid = itemObj.uid,
            itemId = itemObj.itemId
        }
    }

    Delay(60000 * 1, function()
        if GroundItems[pickup] ~= nil then
            DeleteGroundItem(GroundItems[pickup])
        end
    end)
end

AddRemoteEvent("Survival:GroundItem:ConfirmPickup", function(player)
    local x,y,z = GetPlayerLocation(player)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]

    if character.is_dead == 1 then
        return
    end

    for _,groundItem in pairs(GroundItems) do
        if GetDistance3D(x, y, z, groundItem.x, groundItem.y, groundItem.z) < 130 then
            local success, item = TryAddItemToCharacter(player, groundItem.itemId)
            if success then
                if groundItem.item ~= nil then
                    item.uid = groundItem.item.uid
                    SaveCharacterStorages(character)
                end
                DeleteGroundItem(groundItem)
            end
            return
        end
    end
end)

function DeleteGroundItem(groundItem)
    if groundItem.pickup ~= nil then
        DestroyPickup(groundItem.pickup)
        DestroyText3D(groundItem.text)
        GroundItems[groundItem.pickup] = nil
        groundItem.text = nil
        groundItem.pickup = nil
    end
end