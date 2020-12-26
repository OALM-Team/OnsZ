Spaceships = {}

VectorPressed = { forward=false, back=false, right=false, left=false, up=false, down=false }

AddEvent("OnObjectStreamIn", function(object)
    if GetObjectPropertyValue(object, "_isSpaceShip") ~= nil then
        
        local ObjectActor = GetObjectActor(object)
        ObjectActor:SetActorEnableCollision(true)
        GetObjectStaticMeshComponent(object):SetMobility(EComponentMobility.Movable)
        GetObjectStaticMeshComponent(object):SetCollisionEnabled(ECollisionEnabled.QueryAndPhysics)
        --GetObjectStaticMeshComponent(object):SetEnableGravity(true)
        GetObjectStaticMeshComponent(object):SetSimulatePhysics(true)
        
        Spaceships[object] = {
            f=0, s=0, z=15
        }
    end
end)

AddEvent("OnKeyPress", function(key)
    if key == "Z" then
        VectorPressed.forward = true
    end
    if key == "S" then
        VectorPressed.back = true
    end
    if key == "D" then
        VectorPressed.right = true
    end
    if key == "Q" then
        VectorPressed.left = true
    end
    if key == "Left Shift" then
        VectorPressed.up = true
    end
    if key == "Left Ctrl" then
        VectorPressed.down = true
    end
end)


AddEvent("OnKeyRelease", function(key)
    if key == "Z" then
        VectorPressed.forward = false
    end
    if key == "S" then
        VectorPressed.back = false
    end
    if key == "D" then
        VectorPressed.right = false
    end
    if key == "Q" then
        VectorPressed.left = false
    end
    if key == "Left Shift" then
        VectorPressed.up = false
    end
    if key == "Left Ctrl" then
        VectorPressed.down = false
    end
end)

AddEvent("OnGameTick", function(delta)
    for _, object in pairs(GetStreamedObjects()) do
        if GetObjectPropertyValue(object, "_isSpaceShip") ~= nil then
            local PlayerActor = GetPlayerActor(GetPlayerId())
            local ObjectActor = GetObjectActor(object)

            local ship = Spaceships[object]
            
            local spaceshipRotation = GetObjectStaticMeshComponent(object):GetRelativeLocation()
            if GetObjectPropertyValue(object, "_spaceshipDriver") == GetPlayerId() then
                -- forward
                if VectorPressed.forward then
                    if ship.f < 6000 then
                        ship.f = ship.f + 5
                    end
                elseif ship.f > 0 then
                    ship.f = ship.f - 1
                end

                -- back
                if VectorPressed.back then
                    ship.f = ship.f - 5
                elseif ship.f < 0 then
                    ship.f = ship.f + 1
                end

                -- up
                if VectorPressed.up then
                    if ship.z < 6000 then
                        ship.z = ship.z + 5
                    end
                elseif ship.z > 0 then
                    ship.z = ship.z - 7
                end

                -- down
                if VectorPressed.down then
                    ship.z = ship.z - 5
                elseif ship.z < 0 then
                    ship.z = ship.z + 7
                end
            end
            AddPlayerChat(ship.f .. " - " .. ship.s .. " - " .. ship.z)
            --1= cote
            --2=avant
            --3=haut
            GetObjectStaticMeshComponent(object):SetPhysicsLinearVelocity(FVector(ship.s,ship.f,ship.z), false, "None")
            PlayerActor:SetActorEnableCollision(false)
            PlayerActor:SetActorHiddenInGame(true)
            local spaceshipLocation = GetObjectStaticMeshComponent(object):GetRelativeLocation()
            PlayerActor:SetActorLocation(FVector(spaceshipLocation.X, spaceshipLocation.Y + 330, spaceshipLocation.Z + 320), false)
            PlayerActor:SetActorRotation(GetObjectStaticMeshComponent(object):GetRelativeRotation())
            SetCameraLocation(spaceshipLocation.X, spaceshipLocation.Y - 1400, spaceshipLocation.Z + 800, true)
            SetCameraFoV(130)
        end
    end
end)