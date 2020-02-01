function OnPackageStart()
    
    CreateTimer(function()
        CheckPlayersInRadiationZone()
    end, 10000)

    CreateTimer(function()
        IncreaseRadiationValue()
    end, 1000)
end
AddEvent("OnPackageStart", OnPackageStart)

function CheckPlayersInRadiationZone()
    for _,p in pairs(GetAllPlayers()) do
        local character = CharactersData[tostring(GetPlayerSteamId(p))]
        
        if character ~= nil and character.is_dead == 0 then
            local x,y,z = GetPlayerLocation(p)
            local inZone = false
            for kz,zone in pairs(RadiationZone) do
                if not inZone then
                    if not PlayerHasProtection(p) then
                        local dist = GetDistance3D(x, y, z, zone.x, zone.y, zone.z)
                        if dist < zone.radius then
                            character.in_radiation = true
                            character.radiation_zone = kz
                            inZone = true
                        end
                    end
                end
            end

            -- not in any zone
            if not inZone then
                character.in_radiation = false
                character.radiation_zone = nil
            end
        end
    end
end

function IncreaseRadiationValue()
    for _,p in pairs(GetAllPlayers()) do
        local character = CharactersData[tostring(GetPlayerSteamId(p))]
        if character ~= nil and character.is_dead == 0 then
            if character.in_radiation then
                character.radiation_value = character.radiation_value + RadiationZone[character.radiation_zone].intensity
                if character.radiation_value > 100 then
                    character.radiation_value = 100
                end
                SetPlayerPropertyValue(p, '_radiationStock', character.radiation_value, true)
                
            elseif character.radiation_value > 0 then
                character.radiation_value = character.radiation_value - 1
                SetPlayerPropertyValue(p, '_radiationStock', character.radiation_value, true)
            end

            if character.radiation_value > 20 then
                SetPlayerHealth(p, GetPlayerHealth(p) - 0.1)
            elseif character.radiation_value > 50 then
                SetPlayerHealth(p, GetPlayerHealth(p) - 0.15)
            elseif character.radiation_value > 80 then
                SetPlayerHealth(p, GetPlayerHealth(p) - 0.20)
            end
        end
    end
end

function RequestUseRadPillItem(player, storage, template, uid, itemId)
    if itemId ~= "rad_pill" then
        return
    end
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.radiation_value > 0 then
        character.radiation_value = character.radiation_value - 30
        if character.radiation_value < 0 then
            character.radiation_value = 0
        end
        SetPlayerPropertyValue(player, '_radiationStock', character.radiation_value, true)
        RemoveItem(player, storage.id, uid)
    end
    
end
AddEvent("Survival:Inventory:UseItem", RequestUseRadPillItem)

function PlayerHasProtection(player)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]

    for _,outfit in pairs(character.outfit) do
        if outfit.type == "mask" then
            if outfit.itemId == "mask_biohazard" then
                return true
            end
        end
    end
    return false
end