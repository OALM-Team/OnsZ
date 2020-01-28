Lootboxes = {}

function OnPackageStart()
    RefreshLoots()
    CreateTimer(function()
        RefreshLoots()
    end, 60000)
    CreateTimer(function()
        for k,lootbox in pairs(Lootboxes) do
            if tablelength(lootbox.storage.items) == 0 then
                DeleteLootbox(lootbox)
            end
        end
    end, 1000)
end
AddEvent("OnPackageStart", OnPackageStart)

function IsAlreadySpawn(x,y,z)
    for _,box in pairs(Lootboxes) do
        if box.x == x and box.y == y and box.z == z then
            return true
        end
    end
    return false
end

function RefreshLoots()
    for _,spawn in pairs(LootboxesLootsSpawn) do
        if not IsAlreadySpawn(spawn.x, spawn.y, spawn.z - 100) then
            SpawnLootbox(spawn.x, spawn.y, spawn.z, spawn.type)
        end
    end
end

function DeleteLootbox(lootbox)
    for _,p in pairs(GetPlayersInRange3D(lootbox.x, lootbox.y, lootbox.z, 200)) do
        CallRemoteEvent(p, "Survival:Inventory:ClientCloseInventoryUI")
    end
    DestroyObject(lootbox.gameobject)
    Lootboxes[lootbox.id] = nil
end

function SpawnLootbox(x,y,z,type)
    -- create storage
    local storage = {
        id = uuid(),
        name = "Caisse",
        id_character = -1,
        slots = 30,
        items = GenerateLootsByType(type),
        type = "box"
    }

    -- create lootbox
    local lootbox = {
        id = storage.id,
        x = x,
        y = y,
        z = z - 100,
        storage = storage,
        gameobject = CreateObject(981, x, y, z - 100)
    }
    SetObjectPropertyValue(lootbox.gameobject, "_storageState", false, true)
    SetObjectPropertyValue(lootbox.gameobject, "_lootboxId", lootbox.id, true)
    SetObjectPropertyValue(lootbox.gameobject, "_isLootbox", true, true)

    Storages[storage.id] = storage
    Lootboxes[lootbox.id] = lootbox

    print("New lootbox spawned: "..lootbox.id)
    return lootbox
end

function GenerateLootsByType(type)
    local lootsPossible = LootboxesLootsType[type][math.random(1, tablelength(LootboxesLootsType[type]))]
    local items = {}
    for _,l in pairs(lootsPossible) do
        local id = uuid()
        table.insert(items, {
            uid = id,
            itemId = l.itemId,
            slot = l.slot
        })
    end
    return items
end

function OpenLootbox(player, lootboxId)
    local lootbox = Lootboxes[lootboxId]
    SetPlayerAnimation(player, "CHECK_EQUIPMENT")
    CallRemoteEvent(player, "Survival:Inventory:ClientOpenInventoryUI")
    Delay(500, function()
        SendStorageConfig(player, lootbox.id)
    end)
end

AddCommand("spawnlootbox", function(player, type)
    local x,y,z = GetPlayerLocation(player)
    SpawnLootbox(x, y, z, type)
end)


AddRemoteEvent("Survival:Lootboxes:OpenLootbox", function(player, lootboxId)
    local lootbox = Lootboxes[lootboxId]
    if lootbox == nil then
        return
    end
    OpenLootbox(player, lootboxId)
end)