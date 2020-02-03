Zombies = {}

function OnPackageStart()
    RefreshZombieSpawns()

    CreateTimer(function()
        RefreshZombieSpawns()
    end, 60000 * 5)

    CreateTimer(function()
        CheckZombiesHit()
    end, 500)
end
AddEvent("OnPackageStart", OnPackageStart)

function RefreshZombieSpawns()
    for _,spawn in pairs(ZombieSpawns) do
        for i = math.random(1, spawn.max), spawn.max do
            if tablelength(GetZombiesBySpawn(spawn.id)) < spawn.max then
                local x,y,z = GetRandomPositionForZombieInZone(spawn)
                CreateZombie(x, y, z, spawn.id)
            end
        end 
    end
end

function GetRandomPositionForZombieInZone(spawn)
    local x = spawn.x + math.random(-(spawn.radius / 2), (spawn.radius / 2))
    local y = spawn.y + math.random(-(spawn.radius / 2), (spawn.radius / 2))
    local z = spawn.z
    return x,y,z
end

function GetZombiesBySpawn(spawnId)
    local zombieSpawn = {}
    for _,z in pairs(Zombies) do
        if z.spawnId == spawnId then
            table.insert(zombieSpawn, z)
        end
    end
    return zombieSpawn
end

function CheckZombiesHit()
    for _,z in pairs(Zombies) do
        if z.pursuitPlayer ~= nil and z.isAlive then
            local nx, ny, nz = GetNPCLocation(z.npc)
            local px, py, pz = GetPlayerLocation(z.pursuitPlayer)

            if GetDistance3D(nx, ny, nz, px, py, pz) < 150 then
                if z.lastHit < GetTickCount() then
                    z.lastHit = GetTickCount() + 4000
                    SetNPCAnimation(z.npc, "THROW", false)
                    Delay(1500, function()
                        if(z.pursuitPlayer ~= nil) then
                            local nx, ny, nz = GetNPCLocation(z.npc)
                            local px, py, pz = GetPlayerLocation(z.pursuitPlayer)
                        
                            if GetDistance3D(nx, ny, nz, px, py, pz) < 150 then
                                CallRemoteEvent(z.pursuitPlayer, "Survival:Zombie:HitByZombie")
                                SetPlayerHealth(z.pursuitPlayer, GetPlayerHealth(z.pursuitPlayer) - 25)
                            end
                        end
                    end)
                end
            end
        end
    end
end

function CreateZombie(x,y,z, spawnId)
    local zombie = {
        id = uuid(),
        npc = CreateNPC(x,y,z,math.random(0, 180)),
        pursuitPlayer = nil,
        spawnId = spawnId,
        lastHit = GetTickCount(),
        isAlive = true,
        randomMoveTimer = nil
    }
    --zombie.randomMoveTimer = CreateTimer(function()
    --    if zombie.pursuitPlayer == nil and zombie.isAlive then
    --        local nx, ny, nz = GetNPCLocation(zombie.npc)
    --        SetNPCTargetLocation(zombie.npc, nx + math.random(-500, 500), ny + math.random(-500, 500), nz, 200)
    --    end
    --end, math.random(10000, 15000))
    Zombies[zombie.npc] = zombie
    SetNPCRespawnTime(zombie.npc, 60000 * 5)
    SetNPCPropertyValue(zombie.npc, "is_zombie", true, true)
    SetNPCPropertyValue(zombie.npc, "model_id", 21, true)
    SetNPCPropertyValue(zombie.npc, "_isAlive", true, true)
    print("new zombie spawned: "..zombie.id)
end

function PursuitEngage(player, npc)
    local zombie = Zombies[npc]
    local nx, ny, nz = GetNPCLocation(zombie.npc)
    if not zombie.isAlive then
        return
    end
    
    if zombie.pursuitPlayer ~= nil and zombie.pursuitPlayer ~= player then
        local px, py, pz = GetPlayerLocation(player)
        local px2, py2, pz2 = GetPlayerLocation(zombie.pursuitPlayer)
        if GetDistance3D(nx, ny, nz, px, py, pz) > GetDistance3D(nx, ny, nz, px2, py2, pz2) then
            return
        end
    end

    if zombie.pursuitPlayer ~= player then
        CallRemoteEvent(player, "Survival:Zombie:PursuitEngageSound", zombie.npc)
    end

    zombie.pursuitPlayer = player

    Delay(30000, function()
        zombie.pursuitPlayer = nil
        local nx, ny, nz = GetNPCLocation(zombie.npc)
        EndPursuitEngage(player, npc, nz)
    end)
    --SetNPCLocation(zombie.npc, nx, ny,th)
    
    SetNPCFollowPlayer(zombie.npc, player, 300)
end
AddRemoteEvent("Survival:Zombie:PursuitEngage", PursuitEngage)

function EndPursuitEngage(player, npc, th)
    local zombie = Zombies[npc]
    if zombie.isAlive then
        if zombie.pursuitPlayer ~= player then
            return
        end
    end
    local x, y, z = GetNPCLocation(zombie.npc)
    SetNPCTargetLocation(zombie.npc, x,y,th)
    zombie.pursuitPlayer = nil
end
AddRemoteEvent("Survival:Zombie:EndPursuitEngage", EndPursuitEngage)

AddEvent("OnNPCDamage", function(npc, damagetype, amount)
    local zombie = Zombies[npc]
    if zombie == nil then
        return
    end
    if damagetype == 1 then
        local x, y, z = GetNPCLocation(zombie.npc)
        for _,p in pairs(GetPlayersInRange3D(x, y, z, 5000)) do
            PursuitEngage(p, npc)
            return
        end
    end
end)

AddEvent("OnNPCDeath", function(npc, player)
    local zombie = Zombies[npc]
    if zombie == nil then
        return
    end
    zombie.isAlive = false
    SetNPCPropertyValue(zombie.npc, "_isAlive", false, true)
    local x, y, z = GetNPCLocation(zombie.npc)
    for _,p in pairs(GetPlayersInRange3D(x, y, z, 2000)) do
        CallRemoteEvent(p, "Survival:Zombie:Death", zombie.npc, x,y,z)
    end
    if math.random(1, 5) == 1 then
        local lootbox = SpawnLootbox(x,y,z,"zombie_1")
        lootbox.storage.items = {}
    end
    Delay(60000 * 5, function()
        DestroyNPC(zombie.npc)
        Zombies[npc] = nil
    end)
end)

AddRemoteEvent("Survival:Zombie:FixTerrainHeightNpc", function(npc, x,y,th)
    local zombie = Zombies[npc]
    if zombie == nil then
        return
    end

    if not zombie.isAlive then
        return
    end

    SetNPCTargetLocation(zombie.npc, x,y,th)
    if zombie.pursuitPlayer ~= nil then
        SetNPCFollowPlayer(zombie.npc, zombie.pursuitPlayer, 300)
    end
end)