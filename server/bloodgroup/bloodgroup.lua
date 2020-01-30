BloodGroups = {"AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"}

function RequestUseBloodTestItem(player, storage, template, uid, itemId)
    if itemId ~= "blood_test" then
        return
    end
    
    local character = CharactersData[tostring(GetPlayerSteamId(player))]

    CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#05ed4e", "Résultat du test", "Votre groupe sanguin est <b>"..character.blood_group.."</b>", 20000, 1)
    RemoveItem(player, storage.id, uid)
end
AddEvent("Survival:Inventory:UseItem", RequestUseBloodTestItem)

function RequestUseBloodBagItem(player, storage, template, uid, itemId)
    if not template.is_blood_bag then
        return
    end
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    local compatibleRhesus = CheckItemCompatibleRhesus(template.blood_bag_type, character.blood_group)

    CallRemoteEvent(player, "Survival:Player:FreezePlayer")
    CallRemoteEvent(player, "Survival:GlobalUI:AddProgressBar", "blood_bag_heal", "Transfusion du sang", "#ba0000", 30)

    SetPlayerAnimation(player, "CHECK_EQUIPMENT2")
    Delay(5000, function()
        SetPlayerAnimation(player, "CHECK_EQUIPMENT2")
    end)
    Delay(10000, function()
        SetPlayerAnimation(player, "CHECK_EQUIPMENT2")
    end)
    Delay(15000, function()
        SetPlayerAnimation(player, "CHECK_EQUIPMENT2")
    end)
    Delay(20000, function()
        SetPlayerAnimation(player, "CHECK_EQUIPMENT2")
    end)
    Delay(25000, function()
        SetPlayerAnimation(player, "CHECK_EQUIPMENT2")
    end)

    Delay(30000, function()
        if compatibleRhesus then
            SetPlayerAnimation(player, "STOP")
            SetPlayerHealth(player, 100)
            CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#05ed4e", "Soin", "Vous vous sentez mieux désormais", 10000, 1)
        else
            SetPlayerAnimation(player, "VOMIT")
            CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ff0051", "Soin", "Vous êtes pris de malaises peut être que le ce sang n'est pas compatible avec votre groupe sanguin", 10000, 2)
            SetPlayerHealth(player, GetPlayerHealth(player) - 50)
        end
        RemoveItem(player, storage.id, uid)
        UpdatePlayerDatabase(player)
        CallRemoteEvent(player, "Survival:Player:UnFreezePlayer")
    end)
end
AddEvent("Survival:Inventory:UseItem", RequestUseBloodBagItem)

function CheckItemCompatibleRhesus(fromRhesus, rhesus)
    if rhesus == "O+" then
        if fromRhesus == "O+" or fromRhesus == "O-" then
            return true
        end
    elseif rhesus == "O-" then
        if fromRhesus == "O-" then
            return true
        end
    elseif rhesus == "B+" then
        if fromRhesus == "O+" or fromRhesus == "O-" or fromRhesus == "B+" or fromRhesus == "B-" then
            return true
        end
    elseif rhesus == "B-" then
        if fromRhesus == "O-" or fromRhesus == "B-" then
            return true
        end
    elseif rhesus == "A+" then
        if fromRhesus == "O-" or fromRhesus == "O+" or fromRhesus == "A-" or fromRhesus == "A+" then
            return true
        end  
    elseif rhesus == "A-" then
        if fromRhesus == "O-" or fromRhesus == "A-" then
            return true
        end   
    elseif rhesus == "AB+" then
        return true    
    elseif rhesus == "AB-" then
        if fromRhesus == "AB-" or fromRhesus == "B-" or fromRhesus == "A-" or fromRhesus == "O-" then
            return true
        end   
    end

    return false
end