AddCommand("goto", function(player, other)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.admin_level == 0 then
        return
    end

    local x,y,z = GetPlayerLocation(other)
    SetPlayerLocation(player, x,y,z + 100)
end)

AddCommand("bring", function(player, other)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.admin_level == 0 then
        return
    end

    local x,y,z = GetPlayerLocation(player)
    SetPlayerLocation(other, x,y,z + 100)
end)

AddCommand("kick", function(player, other)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.admin_level == 0 then
        return
    end

    AddPlayerChatAll("<span color=\"#b300ff\">[Admin] "..GetPlayerName(player).."</> kick "..GetPlayerName(other).."")
    KickPlayer(other, "Vous avez été kick par "..GetPlayerName(player))
end)

AddCommand("ann", function(player, ...)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.admin_level == 0 then
        return
    end

    local message = table.concat({...}, " ") 
    
    for _,p in pairs(GetAllPlayers()) do
        CallRemoteEvent(p, "Survival:GlobalUI:AddAnnounce", GetPlayerName(player), message)
    end
end)