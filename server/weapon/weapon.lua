function RequestUseWeaponItem(player, storage, template, uid)
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

function RequestLoadAmmo(player, storage, template, uid)
    local weaponToReloadSlot = nil
    for _,possibleWeapon in pairs(template.ammo_weapons) do
        if FindWeaponInHands(player, possibleWeapon) ~= -1 then
            weaponToReloadSlot = FindWeaponInHands(player, possibleWeapon)
            break
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

    if TryAddItemToCharacter(player, templateId) then
        SetPlayerWeapon(player, 1, 1, true, GetPlayerEquippedWeaponSlot(player), false)
    end
end
AddRemoteEvent("Survival:Weapon:StoreCurrentWeapon", StoreCurrentWeapon)