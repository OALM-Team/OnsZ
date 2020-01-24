InventoryUI = nil

function OnKeyPress(key)
    if not IsCtrlPressed() and key == "F2" then
        OpenInventoryUI()
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OpenInventoryUI(text, timeout)
    if InventoryUI ~= nil then
        
        return
    end
    InventoryUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(InventoryUI, 0.0, 0.0)
    SetWebAnchors(InventoryUI, 0.0, 0.0, 1.0, 1.0)
    SetInputMode(1)
    ShowMouseCursor(true)

    LoadWebFile(InventoryUI, "http://asset/"..GetPackageName().."/client/inventory/ui/inventory.html")
end

function RequestInventoryData()
    if InventoryUI == nil then
        return
    end

    CallRemoteEvent("Survival:Inventory:ClientRequestInventoryData")
    --ExecuteWebJS(InventoryUI, "getInventoryItemsConfig("..jsonencode(InventoryItems)..")")
end
AddEvent("Survival:Inventory:RequestInventoryData", RequestInventoryData)

function ReceiveInventoryDataConfig(data)
    if InventoryUI == nil then
        return
    end
    print(data);
    ExecuteWebJS(InventoryUI, "getInventoryItemsConfig("..data..")")
end
AddRemoteEvent("Survival:Inventory:ReceiveInventoryDataConfig", ReceiveInventoryDataConfig)