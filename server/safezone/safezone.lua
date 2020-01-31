SafeZoneRadio = {
    {x=92786,y=92518,z=1839,music="1"}
}

SafeBoneFire= {
    {x=91987,y=93571,z=1628,intensity=1000}
}

function OnPackageStart()
    CreateTimer(function()
        for _,player in pairs(GetAllPlayers()) do
            local x,y,z = GetPlayerLocation(player)
            for _, bonefire in pairs(SafeBoneFire) do
                if GetDistance3D(x, y, z, bonefire.x, bonefire.y, bonefire.z) < 400 then
                    if GetPlayerHealth(player) < 100 then
                        SetPlayerHealth(player, GetPlayerHealth(player) +1)
                    end
                end
            end
        end
    end, 3000)

    for _,radio in pairs(SafeZoneRadio) do
        local o = CreateObject(1173, radio.x, radio.y, radio.z)
        SetObjectPropertyValue(o, "_radioMusicId", "1", true)
        SetObjectPropertyValue(o, "_isRadio", true, true)
    end

    for _,fire in pairs(SafeBoneFire) do
        local o = CreateObject(1284, fire.x, fire.y, fire.z)
        SetObjectPropertyValue(o, "_isCampfire", true, true)
    end
end
AddEvent("OnPackageStart", OnPackageStart)

function IndicateNearbySafezone(player)
    CallRemoteEvent(player, "Night:Survival:Safezone:WaypointSafezone", 91987, 93571, 1628)
end