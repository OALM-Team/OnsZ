LastRadiationSoundPlayed = nil

function OnPackageStart()
    CreateTimer(function()
        ShowHealthHUD(false)
        RefreshLifeAndArmor()
    end, 300)

    ShowHealthHUD(false)

    GlobalUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(GlobalUI, 0.0, 0.0)
    SetWebAnchors(GlobalUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(GlobalUI, WEB_HITINVISIBLE)

    LoadWebFile(GlobalUI, "http://asset/"..GetPackageName().."/client/globalui/ui/globalui.html")
end
AddEvent("OnPackageStart", OnPackageStart)

function CreateNotification(hexa, title, content, timeout, type)
    if GlobalUI == nil then
        return
    end
    
    SetSoundVolume(CreateSound("client/globalui/notif_"..type..".mp3"), 0.1)
    ExecuteWebJS(GlobalUI, "appendNewCard(\""..hexa.."\", \""..title.."\", \""..content.."\", "..timeout..")")
end
AddRemoteEvent("Survival:GlobalUI:CreateNotification", CreateNotification)

function RefreshLifeAndArmor()
    ExecuteWebJS(GlobalUI, "refreshLifeAndArmor("..GetPlayerHealth()..", "..GetPlayerArmor()..")")
    ExecuteWebJS(GlobalUI, "refreshFoodDrinkSleep("..GetPlayerPropertyValue(GetPlayerId(), "_foodStock")..", "..GetPlayerPropertyValue(GetPlayerId(), "_drinkStock")..", "..GetPlayerPropertyValue(GetPlayerId(), "_sleepStock")..")")

    -- radiation
    if GetPlayerPropertyValue(GetPlayerId(), "_radiationStock") > 0 then
        if LastRadiationSoundPlayed == nil then
            LastRadiationSoundPlayed = CreateSound("client/globalui/radiation_1.mp3")
            SetSoundVolume(LastRadiationSoundPlayed, 0.3)
            Delay(80000, function()
                LastRadiationSoundPlayed = nil
            end)
        end
    else
        if LastRadiationSoundPlayed ~= nil then
            DestroySound(LastRadiationSoundPlayed)
        end
    end
    ExecuteWebJS(GlobalUI, "refreshRadiation("..GetPlayerPropertyValue(GetPlayerId(), "_radiationStock")..")")
end


function SetDeathScreen(state)
    if GlobalUI == nil then
        return
    end
    
    if state == "true" then
        SetSoundVolume(CreateSound("client/globalui/flatline_death.mp3"), 0.2)
    end
    ExecuteWebJS(GlobalUI, "showDeathscreen(\""..state.."\")")
end
AddRemoteEvent("Survival:GlobalUI:SetDeathScreen", SetDeathScreen)

function AddProgressBar(id, text, color, duration)
    if GlobalUI == nil then
        return
    end

    ExecuteWebJS(GlobalUI, "addProgressBar('"..id.."', '"..text.."', '"..color.."', "..duration..")")
end
AddRemoteEvent("Survival:GlobalUI:AddProgressBar", AddProgressBar)

function AddAnnounce(playerName, content)
    if GlobalUI == nil then
        return
    end

    SetSoundVolume(CreateSound("client/globalui/notif_1.mp3"), 0.1)
    ExecuteWebJS(GlobalUI, "addAnnounce(\""..playerName.."\", \""..content.."\")")
end
AddRemoteEvent("Survival:GlobalUI:AddAnnounce", AddAnnounce)