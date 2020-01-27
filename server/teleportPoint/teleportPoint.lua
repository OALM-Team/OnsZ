function OnPackageStart()
    for _,point in pairs(TeleportPoint.Points) do
        local pickup = CreatePickup(2, point.loc.x, point.loc.y, point.loc.z)
        TeleportPoint.Pickups[pickup] = point
        SetPickupScale(pickup, 0.3, 0.3, 0.3)
    end
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerPickupHit(player, pickup)
    local point = TeleportPoint.Pickups[pickup]
    if point == nil then
        return
    end
    SetPlayerLocation(player, point.to.x, point.to.y, point.to.z)
    if point.event ~= nil then
        CallEvent(point.event, player)
    end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)

function GetOutSafeBunker(player)
    CallRemoteEvent(player, "Survival:Cinematic:StopIntroMusic")
    CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ffc003", "Déplacement", "Vous êtes sortis du bunker, houra !", 5000)
end
AddEvent("Survival:Player:GetOutSafeBunker", GetOutSafeBunker)