function RequestUseWeaponItem(player, storage, template, uid, itemId)
    if template.is_ammo then
        RequestLoadAmmo(player, storage, template, uid)
        return
    end
    if not template.is_weapon then
        return
    end
    local availableSlot = CheckAvailableWeaponSlot(player)
    if availableSlot == -1 then
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Pas de place", template.name.." ne peut pas être équipé car vous n'avez plus de place dans vos mains", 5000, 2)
        return
    end
    SetPlayerWeapon(player, template.id_weapon, 0, true, availableSlot)
    RemoveItem(player, storage.id, uid)
    
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    character.weapons = GetPlayerWeaponsList(player)

    UpdatePlayerDatabase(player)
    CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#05ed4e", "Arme équipée", template.name.." est désormais équipé sur vous", 2500, 1)
end
AddEvent("Survival:Inventory:UseItem", RequestUseWeaponItem)

function CheckAvailableWeaponSlot(player)
    if GetPlayerWeapon(player, 1) == 1 then
        return 1
    end
    if GetPlayerWeapon(player, 2) == 1 then
        return 2
    end
    if GetPlayerWeapon(player, 3) == 1 then
        return 3
    end
    return -1
end

function FindWeaponInHands(player, weaponId)
    if GetPlayerWeapon(player, 1) == weaponId then
        return 1
    end
    if GetPlayerWeapon(player, 2) == weaponId then
        return 2
    end
    if GetPlayerWeapon(player, 3) == weaponId then
        return 3
    end
    return -1
end

function GetPlayerWeaponsList(player)
    local list = {}
    local weaponId1, ammo1, ammoMagazine1 = GetPlayerWeapon(player, 1)
    local weaponId2, ammo2, ammoMagazine2 = GetPlayerWeapon(player, 2)
    local weaponId3, ammo3, ammoMagazine3 = GetPlayerWeapon(player, 3)
    if ammoMagazine1 == nil then
        ammoMagazine1 = 0
    end
    if ammoMagazine2 == nil then
        ammoMagazine2 = 0
    end
    if ammoMagazine3 == nil then
        ammoMagazine3 = 0
    end
    table.insert(list, {weaponId=weaponId1, ammo=ammo1+ammoMagazine1})
    table.insert(list, {weaponId=weaponId2, ammo=ammo2+ammoMagazine2})
    table.insert(list, {weaponId=weaponId3, ammo=ammo3+ammoMagazine3})
    return list
end

function RequestLoadAmmo(player, storage, template, uid, weaponSlot)
    local weaponToReloadSlot = nil
    for _,possibleWeapon in pairs(template.ammo_weapons) do
        if FindWeaponInHands(player, possibleWeapon) ~= -1 then
            if FindWeaponInHands(player, possibleWeapon) == weaponSlot then
                weaponToReloadSlot = FindWeaponInHands(player, possibleWeapon)
                break
            end
        end
    end
    if weaponToReloadSlot == nil then
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Rechargement impossible", "Aucune arme compatible", 5000, 2)
        return
    end
    local weaponId, ammo, ammoMagazine = GetPlayerWeapon(player, weaponToReloadSlot)
    SetPlayerWeapon(player, weaponId, ammo + template.ammo_size, true, weaponToReloadSlot, false)
    RemoveItem(player, storage.id, uid)
    CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#05ed4e", "Rechargement du chargeur", template.name.." a désormais "..(ammo + template.ammo_size).." munition(s) de disponible", 2500, 1)
    UpdatePlayerDatabase(player)
end

function GetWeaponTemplateIdByWeaponId(weaponId)
    for k,template in pairs(InventoryItems) do
        if template.is_weapon and template.id_weapon == weaponId then
            return k
        end
    end
    return nil
end

function StoreCurrentWeapon(player)
    local weaponId, ammo, ammoMagazine = GetPlayerWeapon(player, GetPlayerEquippedWeaponSlot(player))
    if weaponId == 1 then
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Rangement impossible", "Aucune arme dans votre main", 5000, 2)
        return
    end
    
    local templateId = GetWeaponTemplateIdByWeaponId(weaponId)
    local template = InventoryItems[templateId]
    if template == nil then
        return
    end

    local _, ammo, _ = GetPlayerWeapon(player, GetPlayerEquippedWeaponSlot(player))
    local ammoTemplate = InventoryItems[template.ammo]
    for i = 0, ammo, ammoTemplate.ammo_size do
        if i + ammoTemplate.ammo_size <= ammo then
            if not TryAddItemToCharacter(player, template.ammo) then
                local x,y,z = GetPlayerLocation(player)
                SpawnDropItem(x,y,z, template.ammo)
            end
        end
    end

    if TryAddItemToCharacter(player, templateId) then
        SetPlayerWeapon(player, 1, 1, true, GetPlayerEquippedWeaponSlot(player), false)
    else
        local x,y,z = GetPlayerLocation(player)
        SpawnDropItem(x,y,z, templateId)
        SetPlayerWeapon(player, 1, 1, true, GetPlayerEquippedWeaponSlot(player), false)
    end
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    character.weapons = GetPlayerWeaponsList(player)
    UpdatePlayerDatabase(player)
end
AddRemoteEvent("Survival:Weapon:StoreCurrentWeapon", StoreCurrentWeapon)

function EquipPlayerCharacterWeapons(player) 
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character == nil then
        return
    end
    local i = 1
    for _,w in pairs(character.weapons) do
        if w.weaponId ~=1 then
            SetPlayerWeapon(player, w.weaponId, w.ammo, true, i, true)
        end
        i = i + 1
    end
end

function ServerRequestUseAmmo(player, slot, inventoryId, uid)
    local storage = Storages[inventoryId]
    local item = FindItemInStorage(storage.id, uid)
    if item == nil then
        return
    end
    local template = InventoryItems[item.itemId]
    RequestLoadAmmo(player, storage, template, uid, slot)
end
AddRemoteEvent("Survival:Inventory:ServerRequestUseAmmo", ServerRequestUseAmmo)
