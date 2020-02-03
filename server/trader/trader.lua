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
    for _,trader in pairs(TraderLocations) do
        if GetDistance3D(x, y, z, trader.x, trader.y, trader.z) < 200 then
            print("test")
        end
    end
end
AddRemoteEvent("Survival:Trader:RequestOpenTrader", RequestOpenTrader)