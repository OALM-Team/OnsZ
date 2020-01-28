RadioSoundsPlayed = {}

AddEvent("OnObjectStreamIn", function(object)
    CheckRadio(object)
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