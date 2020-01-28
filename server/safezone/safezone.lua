SafeZoneRadio = {
    --{x=92786,y=92518,z=1839,music="1"}
}

function OnPackageStart()
    for _,radio in pairs(SafeZoneRadio) do
        local o = CreateObject(1173, radio.x, radio.y, radio.z)
        SetObjectPropertyValue(o, "_radioMusicId", "1", true)
        SetObjectPropertyValue(o, "_isRadio", true, true)
    end
end
AddEvent("OnPackageStart", OnPackageStart)