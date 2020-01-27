function OnPackageStart()
    GlobalUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(GlobalUI, 0.0, 0.0)
    SetWebAnchors(GlobalUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(GlobalUI, WEB_HITINVISIBLE)

    LoadWebFile(GlobalUI, "http://asset/"..GetPackageName().."/client/globalui/ui/globalui.html")
end
AddEvent("OnPackageStart", OnPackageStart)

function CreateNotification(hexa, title, content, timeout)
    if GlobalUI == nil then
        return
    end
    
    SetSoundVolume(CreateSound("client/globalui/notif_1.mp3"), 0.1)
    ExecuteWebJS(GlobalUI, "appendNewCard(\""..hexa.."\", \""..title.."\", \""..content.."\", "..timeout..")")
end
AddRemoteEvent("Survival:GlobalUI:CreateNotification", CreateNotification)