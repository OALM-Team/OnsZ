InventoryUI = nil

function OnKeyPress(key)
    if not IsCtrlPressed() and key == "F2" then
        if InventoryUI == nil then
            OpenInventoryUI()
        else
            CloseInventoryUI()
        end
    end
    if IsCtrlPressed() and key == "G" then
        CallRemoteEvent("Survival:Weapon:StoreCurrentWeapon")
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OpenInventoryUI()
    if InventoryUI ~= nil then
        --CloseInventoryUI()
        return
    end
    InventoryUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(InventoryUI, 0.0, 0.0)
    SetWebAnchors(InventoryUI, 0.0, 0.0, 1.0, 1.0)
    SetInputMode(1)
    SetIgnoreLookInput(true)
    ShowMouseCursor(true)

    LoadWebFile(InventoryUI, "http://asset/"..GetPackageName().."/client/inventory/ui/inventory.html")
end
AddRemoteEvent("Survival:Inventory:ClientOpenInventoryUI", OpenInventoryUI)

function CloseInventoryUI()
    if InventoryUI == nil then
        return
    end
    DestroyWebUI(InventoryUI)
    SetInputMode(0)
    SetIgnoreLookInput(false)
    ShowMouseCursor(false)

    InventoryUI = nil
end
AddRemoteEvent("Survival:Inventory:ClientCloseInventoryUI", CloseInventoryUI)

function RequestInventoryData()
    if InventoryUI == nil then
        return
    end

    CallRemoteEvent("Survival:Inventory:ClientRequestInventoryData")
end
AddEvent("Survival:Inventory:RequestInventoryData", RequestInventoryData)

function ReceiveInventoryDataConfig(key, data)
    if InventoryUI == nil then
        return
    end
    ExecuteWebJS(InventoryUI, "addInventoryItemsConfig(\""..key.."\", "..data..")")
end
AddRemoteEvent("Survival:Inventory:ReceiveInventoryDataConfig", ReceiveInventoryDataConfig)

function ReceiveInventoryStorageConfig(id, name, slots)
    if InventoryUI == nil then
        return
    end
    ExecuteWebJS(InventoryUI, "drawInventorySpace(\""..id.."\", \""..name.."\", "..slots..")")
end
AddRemoteEvent("Survival:Inventory:ReceiveInventoryStorageConfig", ReceiveInventoryStorageConfig)

function ReceiveInventoryItem(storageId, uid, itemId, slot)
    if InventoryUI == nil then
        return
    end
    ExecuteWebJS(InventoryUI, "addItem(\""..storageId.."\", \""..uid.."\", "..slot..", \""..itemId.."\")")
end
AddRemoteEvent("Survival:Inventory:ReceiveInventoryItem", ReceiveInventoryItem)

function RequestChangeItemSlot(storageId, uid, toSlot)
    if PlayerIsFreezed then
        CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
        return
    end

    CallRemoteEvent("Survival:Inventory:ServerRequestChangeSlotItem", storageId, uid, toSlot)
end
AddEvent("Survival:Inventory:RequestChangeSlotItem", RequestChangeItemSlot)

function RequestChangeInventorySlotItem(storageId, toStorageId, uid, toSlot)
    if PlayerIsFreezed then
        CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
        return
    end

    CallRemoteEvent("Survival:Inventory:ServerRequestChangeInventorySlotItem", storageId, toStorageId, uid, toSlot)
end
AddEvent("Survival:Inventory:RequestChangeInventorySlotItem", RequestChangeInventorySlotItem)

function RequestThrowItem(storageId, uid)
    if PlayerIsFreezed then
        CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
        return
    end

    CallRemoteEvent("Survival:Inventory:ServerRequestThrowItem", storageId, uid)
end
AddEvent("Survival:Inventory:RequestThrowItem", RequestThrowItem)

function RequestUseItem(storageId, uid)
    if PlayerIsFreezed then
        CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
        return
    end

    CallRemoteEvent("Survival:Inventory:ServerRequestUseItem", storageId, uid)
end
AddEvent("Survival:Inventory:RequestUseItem", RequestUseItem)

function RemoveItem(storageId, uid)
    if InventoryUI == nil then
        return
    end
    ExecuteWebJS(InventoryUI, "removeItem(\""..storageId.."\", \""..uid.."\")")
end
AddRemoteEvent("Survival:Inventory:RemoveItem", RemoveItem)

function ReceiveEquipment(data)
    if InventoryUI == nil then
        return
    end
    ExecuteWebJS(InventoryUI, "receiveEquipment("..data..")")
end
AddRemoteEvent("Survival:Inventory:ReceiveEquipment", ReceiveEquipment)

function ResetEquipment()
    if InventoryUI == nil then
        return
    end
    ExecuteWebJS(InventoryUI, "resetEquipment()")
end
AddRemoteEvent("Survival:Inventory:ResetEquipment", ResetEquipment)

function RequestUnequipOutfit(typeOutfit)
    if PlayerIsFreezed then
        CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
        return
    end
    
    CallRemoteEvent("Survival:Inventory:ServerRequestUnequipOutfit", typeOutfit)
end
AddEvent("Survival:Inventory:RequestUnequipOutfit", RequestUnequipOutfit)
