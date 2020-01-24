Zombies = {}

function OnPackageStart()
    CreateZombie(45171, 43042, 3335)
end
AddEvent("OnPackageStart", OnPackageStart)

function CreateZombie(x,y,z)
    local zombie = {
        npc = CreateNPC(x,y,z,80),
        pursuitPlayer = nil
    }
    Zombies[zombie.npc] = zombie
    SetNPCPropertyValue(zombie.npc, "model_id", 21, true)
end

function PursuitEngage(player, npc)
    local zombie = Zombies[npc]
    
    if zombie.pursuitPlayer ~= nil and zombie.pursuitPlayer ~= player then
        local nx, ny, nz = GetNPCLocation(zombie.npc)
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
    
    SetNPCFollowPlayer(zombie.npc, player, 300)
end
AddRemoteEvent("Survival:Zombie:PursuitEngage", PursuitEngage)

function EndPursuitEngage(player, npc, th)
    local zombie = Zombies[npc]
    if zombie.pursuitPlayer ~= player then
        return
    end
    local x, y, z = GetNPCLocation(zombie.npc)
    SetNPCTargetLocation(zombie.npc, x,y,th)
    zombie.pursuitPlayer = nil
end
AddRemoteEvent("Survival:Zombie:EndPursuitEngage", EndPursuitEngage)