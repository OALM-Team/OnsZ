TraderUI = nil
CurrentTraderId = nil
CurrentTraderConfig = nil

function OnKeyPress(key)
    if key == "E" and not IsPlayerReloading() then
        if PlayerIsFreezed then
            CreateNotification("#ff0051", "Action impossible", "Impossible de faire ça pour le moment", 5000, 2)
            return
        end
        
        if TraderUI == nil then
            CallRemoteEvent("Survival:Trader:RequestOpenTrader")
        else
            CloseTraderUI()
        end
        --CreateNotification("#ff0051", "Action impossible", "Pas encore disponible", 5000, 2)
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function OpenTraderUI(traderId)
    if TraderUI ~= nil then
        return
    end
    CurrentTraderId = traderId
    CurrentTraderConfig = TraderLocations[traderId]
    TraderUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(TraderUI, 0.0, 0.0)
    SetWebAnchors(TraderUI, 0.0, 0.0, 1.0, 1.0)
    SetInputMode(1)
    SetIgnoreLookInput(true)
    ShowMouseCursor(true)

    LoadWebFile(TraderUI, "http://asset/"..GetPackageName().."/client/trader/ui/trader.html")
end
AddRemoteEvent("Survival:Trader:OpenTraderUI", OpenTraderUI)

function CloseTraderUI()
    if TraderUI == nil then
        return
    end
    DestroyWebUI(TraderUI)
    SetInputMode(0)
    SetIgnoreLookInput(false)
    ShowMouseCursor(false)

    TraderUI = nil
end

function RequestTraderConfig()
    if TraderUI == nil then
        return
    end
    for _,item in pairs(CurrentTraderConfig.shop) do
        local template = InventoryItems[item.itemId]
        ExecuteWebJS(TraderUI, "addItem(\""..item.itemId.."\", \""..template.name.."\", \""..template.desc.."\", "..item.price..")")
    end
end
AddEvent("Survival:Trader:RequestTraderConfig", RequestTraderConfig)

function RequestTraderBuy(itemId)
    if TraderUI == nil then
        return
    end
    CallRemoteEvent("Survival:Trader:ServerRequestTraderBuy", itemId, CurrentTraderId)
end
AddEvent("Survival:Trader:RequestTraderBuy", RequestTraderBuy)