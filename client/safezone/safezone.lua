RadioSoundsPlayed = {}

AddEvent("OnObjectStreamIn", function(object)
    CheckRadio(object)
    CheckCampfire(object)
end)

AddEvent("OnObjectStreamOut", function(object)
   
end)

function CheckRadio(object)
    if GetObjectPropertyValue(object, "_radioMusicId") ~= nil and RadioSoundsPlayed[GetObjectPropertyValue(object, "_radioMusicId")] == nil then
        local soundId = GetObjectPropertyValue(object, "_radioMusicId")
        RadioSoundsPlayed[soundId] = true
        local x,y,z = GetObjectLocation(object)
        SetSoundVolume(CreateSound3D("client/safezone/sounds/music_"..GetObjectPropertyValue(object, "_radioMusicId")..".mp3", x,y,z, 5000), 0.15)
        Delay(60000 * 6, function()
            RadioSoundsPlayed[soundId] = nil
        end)
    end
end

function CheckCampfire(object)
    if GetObjectPropertyValue(object, "_isCampfire") ~= nil then
        local x,y,z = GetObjectLocation(object)
        local emitter = GetWorld():SpawnEmitterAtLocation(UParticleSystem.LoadFromAsset("/Game/Explosions/Particles/P_LoopingFire1c_MV"), FVector(x, y, z), FRotator(0, 0, 0), FVector(0.5, 0.5, 5.0))
        local actor = GetObjectActor(object)
        light = actor:AddComponent(UPointLightComponent.Class())
        light:SetIntensity(10000 * 10)
        light:SetLightColor(FLinearColor(0.83137, 0.48235, 0.08235, 1.0), false)
        light:SetRelativeRotation(FRotator(90.0, 0.0, 0.0))

        CreateTimer(function()
            light:SetIntensity(10000 * Random(10, 15))
        end, 200)
    end
end

function WaypointSafezone(x,y,z)
    local safezoneWaypoint = CreateWaypoint(x,y,z,"Safezone")
    Delay(60000 * 5, function()
        DestroyWaypoint(safezoneWaypoint)
    end)
end
AddRemoteEvent("Night:Survival:Safezone:WaypointSafezone", WaypointSafezone)