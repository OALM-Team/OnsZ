AddEvent("OnPackageStart", function()
    for _,trader in pairs(TraderLocations) do
        local npc=CreateNPC(trader.x, trader.y, trader.z, trader.h)
        SetNPCHealth(npc, 999999999)
        SetNPCPropertyValue(npc, "model_id", 26, true)
        CreateText3D(trader.text.text, 16, trader.text.x, trader.text.y, trader.text.z, 0,0,0)
    end
end)

function RequestOpenTrader(player)
    local x,y,z = GetPlayerLocation(player)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]

    if character.is_dead == 1 then
        return
    end
    for k,trader in pairs(TraderLocations) do
        if GetDistance3D(x, y, z, trader.x, trader.y, trader.z) < 200 then
            CallRemoteEvent(player, "Survival:Trader:OpenTraderUI", k)
        end
    end
end
AddRemoteEvent("Survival:Trader:RequestOpenTrader", RequestOpenTrader)

function ServerRequestTraderBuy(player, itemId, traderId)
    local character = CharactersData[tostring(GetPlayerSteamId(player))]
    if character.is_dead == 1 then
        return
    end
    local trader = TraderLocations[traderId]
    local shopItem = nil
    for _,i in pairs(trader.shop) do
        if i.itemId == itemId then
            shopItem = i
            break
        end
    end
    if shopItem == nil then
        return
    end

    local capsuleCount = GetItemCountInStorages(player, "capsule_1")
    if capsuleCount < shopItem.price then
        CallRemoteEvent(player, "Survival:GlobalUI:CreateNotification", "#ffc003", "Impossible", "Vous n'avez pas assez de capsule(s) pour ça", 5000, 2)
        return
    end

    RemoveMultipleItemsInStorages(player, "capsule_1", shopItem.price)
    if not TryAddItemToCharacter(player, shopItem.itemId) then
        local x,y,z = GetPlayerLocation(player)
        SpawnDropItem(x,y,z, shopItem.itemId)
    end
end
AddRemoteEvent("Survival:Trader:ServerRequestTraderBuy", ServerRequestTraderBuy)