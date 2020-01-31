local noclipers = {}

function noclip(ply)
    local character = CharactersData[tostring(GetPlayerSteamId(ply))]
    if character.admin_level == 0 then
        return
    end

    if (noclipers[tostring(ply)]==nil) then
        noclipers[tostring(ply)] = true
   CallRemoteEvent(ply, "Setnoclip" , true )
    else
        if (noclipers[tostring(ply)]==true) then
            noclipers[tostring(ply)] = false
            CallRemoteEvent(ply, "Setnoclip" , false )
        else
            noclipers[tostring(ply)] = true
             CallRemoteEvent(ply, "Setnoclip" , true )
        end
    end
end

AddRemoteEvent("Setnoclipserver", function(ply,bool)
    noclipers[tostring(ply)] = bool
  end)

AddCommand("noclip", noclip)

function tp_noc(ply,x,y,z)
    SetPlayerLocation(ply, x, y, z)
end

AddRemoteEvent("tp_noc", tp_noc )