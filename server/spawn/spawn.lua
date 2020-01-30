CharactersData = {}
BloodGroups = {"AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"}
FoodDrinkSleepRatio = 1

function OnPackageStart()
    CreateTimer(function()
        for _,player in pairs(GetAllPlayers()) do
            AjustFood(player, -1)
        end
    end, 100000 / FoodDrinkSleepRatio)

    CreateTimer(function()
        for _,player in pairs(GetAllPlayers()) do
            AjustDrink(player, -1)
        end
    end, 80000 / FoodDrinkSleepRatio)

    CreateTimer(function()
        for _,player in pairs(GetAllPlayers()) do
            AjustSleep(player, -1)
        end
    end, 140000 / FoodDrinkSleepRatio)


    -- Save timer
    CreateTimer(function()
        for _,player in pairs(GetAllPlayers()) do
            UpdatePlayerDatabase(player)
        end
    end, 60000 * 5)
end
AddEvent("OnPackageStart", OnPackageStart)

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
            SetPlayerPropertyValue(player, 'characterID', character.id, true)
            --RequestPlayIntroCinematic(player)
            EquipPlayerCharacterWeapons(player)
            SetPlayerOutfit(player)

            -- setup drink food sleep
            SetPlayerPropertyValue(player, '_foodStock', character.food, true)
            SetPlayerPropertyValue(player, '_drinkStock', character.drink, true)
            SetPlayerPropertyValue(player, '_sleepStock', character.sleep, true)
            
            SetPlayerHealth(player, character.health)

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
                weapons= jsondecode(mariadb_get_value_index(1, 9)),
                outfit=jsondecode(mariadb_get_value_index(1, 10)),
                food=mariadb_get_value_index_int(1, 11),
                drink=mariadb_get_value_index_int(1, 12),
                sleep=mariadb_get_value_index_int(1, 13),
                health=mariadb_get_value_index_int(1, 14)
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
                weapons={},
                outfit={},
                food=100,
                drink=100,
                sleep=100,
                health=100
            }, function(character)
                InitStorageForCharacter(character, 30, function(characterStorage)
                    callback(character)
                end)
            end)
        end
    end)
end

function InsertPlayerDatabase(character, callback)
    local query = mariadb_prepare(sql, "INSERT INTO `tbl_character` (`steamid`, `location_x`, `location_y`, `location_z`, `location_h`, `clothing_id`, `blood_group`, `weapons`, `outfit`, `food`, `drink`, `sleep`, `health`)" ..
        "VALUES ('?', '?', '?', '?', '?', '?', '?', '?', '?', '?', '?', '?', '?');",
        character.steamid, character.location_x, character.location_y, character.location_z, character.location_h, character.clothing_id, character.blood_group, jsonencode(character.weapons), jsonencode(character.outfit),
        character.food, character.drink, character.sleep, character.health)
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
    character.health = GetPlayerHealth(player)

    local query = mariadb_prepare(sql, "UPDATE `tbl_character` SET location_x='?', location_y='?', location_z='?', location_h='?', clothing_id='?', blood_group='?', weapons='?', outfit='?', food='?', drink='?', sleep='?', health='?' WHERE id_character='?';",
        character.location_x, character.location_y, character.location_z, character.location_h, character.clothing_id, character.blood_group,
        jsonencode(GetPlayerWeaponsList(player)), jsonencode(character.outfit), character.food, character.drink, character.sleep, character.health, tonumber(character.id))
    mariadb_query(sql, query, function()
        print("character updated id: ".. character.id)
    end)
end

function AjustFood(player, ajustment)
    if ajustment == 0 then
        return
    end
    
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character == nil then
        return
    end

    if ajustment > 0 then
        SetPlayerAnimation(player, "DRINKING")
    end

    character.food = character.food + ajustment

    if character.food < 0 then
        character.food = 0
    end
    if character.food > 100 then
        character.food = 100
    end

    SetPlayerPropertyValue(player, '_foodStock', character.food, true)
end

function AjustDrink(player, ajustment)
    if ajustment == 0 then
        return
    end

    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character == nil then
        return
    end

    if ajustment > 0 then
        SetPlayerAnimation(player, "DRINKING")
    end

    character.drink = character.drink + ajustment

    if character.drink < 0 then
        character.drink = 0
    end
    if character.drink > 100 then
        character.drink = 100
    end

    SetPlayerPropertyValue(player, '_drinkStock', character.drink, true)
end

function AjustSleep(player, ajustment)
    if ajustment == 0 then
        return
    end
    
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character == nil then
        return
    end

    character.sleep = character.sleep + ajustment

    if character.sleep < 0 then
        character.sleep = 0
    end
    if character.sleep > 100 then
        character.sleep = 100
    end

    SetPlayerPropertyValue(player, '_sleepStock', character.sleep, true)
end

function RequestUseBasicItem(player, storage, template, uid, itemId)
    if not template.is_food then
        return
    end
    
    AjustFood(player, template.food_value)
    AjustDrink(player, template.drink_value)
    AjustSleep(player, template.sleep_value)

    UpdatePlayerDatabase(player)
    RemoveItem(player, storage.id, uid)
end
AddEvent("Survival:Inventory:UseItem", RequestUseBasicItem)
