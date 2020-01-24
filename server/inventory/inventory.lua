function ClientRequestInventoryData(player)
    CallRemoteEvent(player, "Survival:Inventory:ReceiveInventoryDataConfig", jsonencode(InventoryItems))
end
AddRemoteEvent("Survival:Inventory:ClientRequestInventoryData", ClientRequestInventoryData)