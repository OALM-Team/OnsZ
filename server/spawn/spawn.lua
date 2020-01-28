CharactersData = {}
BloodGroups = {"AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"}

function OnPlayerJoin(player)
    SetPlayerSpawnLocation(player, 45767, 48163, 2265, 90.0)
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

function OnPlayerQuit(player)
    UpdatePlayerDatabase(player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnPlayerSpawn(player)
    Delay(2000, function()
        RegisterPlayerDatabase(player, function(character)
            print("character enter in game id: "..character.id)
            CallRemoteEvent(player, "Survival:Player:SetPlayerClothing", player, character.clothing_id)
            SetPlayerPropertyValue(player, 'clothingID', character.clothing_id, true)
            SetPlayerPropertyValue(player, 'characterID', character.id, true)
            --RequestPlayIntroCinematic(player)
            EquipPlayerCharacterWeapons(player)
            LoadStoragesForCharacter(character, function()
                SetPlayerLocation(player, character.location_x, character.location_y, character.location_z, character.location_h)
            end)
        end)
    end)
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)

function RegisterPlayerDatabase(player, callback)
    LoadPlayerFromDatabase(player, function(character)
        CharactersData[character.steamid] = character
        callback(character)
    end)
end

function LoadPlayerFromDatabase(player, callback)
    local query = mariadb_prepare(sql, "SELECT * FROM `tbl_character` WHERE steamid='?';", tostring(GetPlayerSteamId(player)))
    mariadb_query(sql, query, function()
        if mariadb_get_row_count() > 0 then
            local result = mariadb_get_assoc(1)
            local character = {
				id = mariadb_get_value_index_int(1, 1),
				steamid = mariadb_get_value_index(1, 2),
				location_x = mariadb_get_value_index_float(1, 3),
				location_y = mariadb_get_value_index_float(1, 4),
				location_z = mariadb_get_value_index_float(1, 5),
                location_h = mariadb_get_value_index_float(1, 6),
                clothing_id = mariadb_get_value_index_int(1, 7),
                blood_group = mariadb_get_value_index(1, 8),
                weapons= jsondecode(mariadb_get_value_index(1, 9))
            }
            print("found existing character: "..character.id)
            callback(character)
        else
            local x,y,z = GetPlayerLocation(player)
            local h = GetPlayerHeading(player)
            InsertPlayerDatabase({
				id = -1,
				steamid = tostring(GetPlayerSteamId(player)),
				location_x = x,
				location_y = y,
				location_z = z,
                location_h = h,
                clothing_id = 19,
                blood_group = BloodGroups[math.random(1, tablelength(BloodGroups))],
                weapons={}
            }, function(character)
                InitStorageForCharacter(character, 30, function(characterStorage)
                    callback(character)
                end)
            end)
        end
    end)
end

function InsertPlayerDatabase(character, callback)
    local query = mariadb_prepare(sql, "INSERT INTO `tbl_character` (`steamid`, `location_x`, `location_y`, `location_z`, `location_h`, `clothing_id`, `blood_group`, `weapons`)" ..
        "VALUES ('?', '?', '?', '?', '?', '?', '?', '?');",
        character.steamid, character.location_x, character.location_y, character.location_z, character.location_h, character.clothing_id, character.blood_group, jsonencode(character.weapons))
    mariadb_query(sql, query, function()
        local id = mariadb_get_insert_id()
        character.id = id
        print("new character id: " .. id)
        callback(character)
    end)
end

function UpdatePlayerDatabase(player) 
    local character = CharactersData[tostring(GetPlayerSteamId(player))]

    -- set locations
    local x,y,z = GetPlayerLocation(player)
    local h = GetPlayerHeading(player)
    character.location_x = x
    character.location_y = y
    character.location_z = z
    character.location_h = h

    local query = mariadb_prepare(sql, "UPDATE `tbl_character` SET location_x='?', location_y='?', location_z='?', location_h='?', clothing_id='?', blood_group='?', weapons='?' WHERE id_character='?';",
        character.location_x, character.location_y, character.location_z, character.location_h, character.clothing_id, character.blood_group,
        jsonencode(GetPlayerWeaponsList(player)) ,tonumber(character.id))
    mariadb_query(sql, query, function()
        print("character updated id: ".. character.id)
    end)
end