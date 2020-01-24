Roar = {}

function OnPackageStart()
    CreateTimer(function()
        CheckZombiesRoar()
        CheckZombiePursuit()
    end, 5000)
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

function CheckZombiesRoar()
    for _,n in pairs(GetStreamedNPC()) do
        local x, y, z = GetNPCLocation(n)
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

function CheckZombiePursuit()
    for _,n in pairs(GetStreamedNPC()) do
        local px, py, pz = GetPlayerLocation(GetPlayerId())
        local x, y, z = GetNPCLocation(n)
        if GetDistance3D(x, y, z, px, py, pz) > 2000 then
            CallRemoteEvent("Survival:Zombie:EndPursuitEngage", n, GetTerrainHeight(x,y,99999.9))
            return
        end
        CallRemoteEvent("Survival:Zombie:PursuitEngage", n)
    end
end

AddRemoteEvent("Survival:Zombie:PursuitEngageSound", function(npc)
    local x, y, z = GetNPCLocation(npc) 
    CreateSound3D("client/zombie/sounds/effect_2.mp3", x,y,z, 2000)
end)