AddCommand("infos", function(player)
    local playersCount = tablelength(GetAllPlayers())

    AddPlayerChat(player, "Joueurs en ligne: " .. playersCount)
end)

AddRemoteEvent("Survival:Scoreboard:RequestPlayersList", function(player)
    CallRemoteEvent(player, "Survival:Scoreboard:ClearPlayerList")
    for _,p in pairs(GetAllPlayers()) do

        CallRemoteEvent(player, "Survival:Scoreboard:AddPlayerList", jsonencode({
            id = p,
            name = GetPlayerName(p)
        }))
    end
end)