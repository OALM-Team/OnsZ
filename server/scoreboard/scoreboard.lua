AddCommand("infos", function(player)
    local playersCount = tablelength(GetAllPlayers())

    AddPlayerChat(player, "Joueurs en ligne: " .. playersCount)
end)