Roar = {}

function OnPackageStart()
    CreateTimer(function()
        CheckZombiesRoar()
        CheckZombiePursuit()
    end, 5000)

    CreateTimer(function()
        --FixTerrainHeightNpc()
    end, 500)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnNPCNetworkUpdatePropertyValue", function(npc, property, model)
	if property == "model_id" then
		SetNPCClothingPreset(npc, tonumber(model))
	end
end)

AddEvent("OnNPCStreamIn", function(npc)
	local model = GetNPCPropertyValue(npc, "model_id")
	if model ~= nil and model ~= "" then
		SetNPCClothingPreset(npc, tonumber(model))
	end
end)

function FixTerrainHeightNpc()
    for _,n in pairs(GetStreamedNPC()) do
        local x, y, z = GetNPCLocation(n)
        local isAlive = GetNPCPropertyValue(n, "_isAlive")
        if isAlive then
            CallRemoteEvent("Survival:Zombie:FixTerrainHeightNpc", n, x,y, GetTerrainHeight(x,y,99999.9))
        end
    end
end

function CheckZombiesRoar()
    for _,n in pairs(GetStreamedNPC()) do
        local x, y, z = GetNPCLocation(n)
        local isAlive = GetNPCPropertyValue(n, "_isAlive")
        if isAlive then
            if Roar[n] ~= nil then
                SetSound3DLocation(Roar[n], x,y,z)
                return
            end
            Roar[n] = CreateSound3D("client/zombie/sounds/effect_1.mp3", x,y,z, 2000)
            Delay(120000, function()
                Roar[n] = nil
            end)
        end
    end
end

function CheckZombiePursuit()
    for _,n in pairs(GetStreamedNPC()) do
        local px, py, pz = GetPlayerLocation(GetPlayerId())
        local x, y, z = GetNPCLocation(n)
        if GetDistance3D(x, y, z, px, py, pz) > 2500 then
            CallRemoteEvent("Survival:Zombie:EndPursuitEngage", n, GetTerrainHeight(x,y,99999.9))
            return
        end
        CallRemoteEvent("Survival:Zombie:PursuitEngage", n, GetTerrainHeight(x,y,99999.9))
    end
end

AddRemoteEvent("Survival:Zombie:PursuitEngageSound", function(npc)
    local x, y, z = GetNPCLocation(npc) 
    CreateSound3D("client/zombie/sounds/effect_2.mp3", x,y,z, 2000)
end)

AddRemoteEvent("Survival:Zombie:HitByZombie", function()
    InvokeDamageFX(500)
    SetSoundVolume(CreateSound("client/zombie/sounds/player_hit_"..Random(1,3)..".mp3"), 0.7)
end)

AddRemoteEvent("Survival:Zombie:Death", function(zombieId, x,y,z)
    if Roar[zombieId] ~= nil then
        DestroySound(Roar[zombieId])
    end
    CreateSound3D("client/zombie/sounds/death_1.mp3", x,y,z, 2000)
end)