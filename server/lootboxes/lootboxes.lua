Lootboxes = {}

function OnPackageStart()
    SpawnLootbox(45964, 48031, 2265, "basic")
end
AddEvent("OnPackageStart", OnPackageStart)

function SpawnLootbox(x,y,z,type)
    local storage = {
        id = uuid(),
        name = "Caisse",
        id_character = -1,
        slots = 30,
        items = {
            {
                uid = uuid(),
                itemId = "water",
                slot = 0
            }
        },
        type = "box"
    }
    local lootbox = {
        id = storage.id,
        x = x,
        y = y,
        z = z,
        storage = storage
    }
    Storages[storage.id] = storage
    Lootboxes[lootbox.id] = lootbox
    print("New lootbox spawned: "..lootbox.id)
end

AddCommand("openlootbox", function(player, id)
    local lootbox = Lootboxes[id]
    CallRemoteEvent(player, "Survival:Inventory:ClientOpenInventoryUI")
    Delay(1000, function()
        SendStorageConfig(player, lootbox.id)
    end)
end)
