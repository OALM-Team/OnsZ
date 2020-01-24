function OnPackageStart()
    
end
AddEvent("OnPackageStart", OnPackageStart)


function RequestPlayIntroCinematic(player)
    CallRemoteEvent(player, "Survival:Cinematic:PlayIntroCinematic")
    SetPlayerAnimation(player, "LAY01")
    Delay(17000, function()
        SetPlayerAnimation(player, "CHECK_EQUIPMENT")
    end)
end
AddCommand("startc", RequestPlayIntroCinematic)