function OnPackageStart()
  
end
AddEvent("OnPackageStart", OnPackageStart)

AddCommand("testship", function(player)
    local ship = SpawnShip(player)

end)

function SpawnShip(player)
    local shipObject = CreateObject(73, 0, 0, 0)
    SetObjectPropertyValue(shipObject, "_isSpaceShip", true, true)
    SetObjectPropertyValue(shipObject, "_spaceshipDriver", player, true)
    local x,y,z = GetPlayerLocation(player)
    SetObjectLocation(shipObject, x, y, z+100)
    SetPlayerAnimation(player, "SIT02")

    return shipObject
end