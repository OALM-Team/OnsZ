CinematicUI = nil
IntroMusic = nil
AmbianceMusic = nil

function OnPackageStart()
    
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerSpawn()
   
end
AddEvent('OnPlayerSpawn', OnPlayerSpawn)

function PlayIntroCinematic()
    StartCameraFade(1.0, 0.0, 120, "#000000")
    IntroMusic = CreateSound("client/cinematic/sounds/ambiance_1.mp3")
    SetSoundVolume(IntroMusic, 0.2)
    EnableFirstPersonCamera(true)
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    Delay(7000, function()
        OpenCinematicUI("intro_text", 8000)
        StartCameraFade(1.0, 0.0, 20, "#000000")
        Delay(10000, function()
            EnableFirstPersonCamera(false)
            SetIgnoreLookInput(false)
            SetIgnoreMoveInput(false)
        end)
    end)
    
end
AddRemoteEvent("Survival:Cinematic:PlayIntroCinematic", PlayIntroCinematic)

function StopIntroMusic()
    if IntroMusic == nil then
        return
    end
    DestroySound(IntroMusic)
    if AmbianceMusic ~= nil then
        return
    end
    AmbianceMusic = CreateSound("client/cinematic/sounds/ambiance_2.mp3")
    OpenCinematicUI("out_bunker_text", 7000)
end
AddRemoteEvent("Survival:Cinematic:StopIntroMusic", StopIntroMusic)

function OpenCinematicUI(text, timeout)
    if CinematicUI ~= nil then
        CinematicGetText(text)
        return
    end
    CinematicUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(CinematicUI, 0.0, 0.0)
    SetWebAnchors(CinematicUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(CinematicUI, WEB_HITINVISIBLE)

    LoadWebFile(CinematicUI, "http://asset/"..GetPackageName().."/client/cinematic/ui/cinematic.html?text="..text)
    Delay(timeout, function()
        CloseCinematicUI()
    end)
end

function CloseCinematicUI()
    ExecuteWebJS(CinematicUI, "fadeOut()")
    Delay(2000, function()
        DestroyWebUI(CinematicUI)
        CinematicUI = nil
    end)
end

function CinematicGetText(textId)
    local text = CinematicTexts[textId]
    ExecuteWebJS(CinematicUI, "setText(\""..text.."\")")
end
AddEvent("Survival:Cinematic:GetText", CinematicGetText)