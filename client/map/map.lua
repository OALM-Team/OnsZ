MapUI = nil
MapState = false

function OnPackageStart()
    MapUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(MapUI, 0.0, 0.0)
    SetWebAnchors(MapUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(MapUI, WEB_HITINVISIBLE)

    LoadWebFile(MapUI, "http://asset/"..GetPackageName().."/client/map/ui/map.html")

    CreateTimer(function()
        local x,y,z = GetPlayerLocation()
        local _, h = GetCameraRotation()
        h = h + 90
        if (h < 0) then
			h = h + 360
        end
        
        ExecuteWebJS(MapUI, "setPlayerLocation("..x..", "..y..", 0)")
        --if not MapState then
        --    ExecuteWebJS(MapUI, "setPlayerLocation("..x..", "..y..", "..h..")")
        --else
       -- end
        
    end, 50)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnKeyPress(key)
    if not IsCtrlPressed() and key == "M" then
        if MapState then
            ExecuteWebJS(MapUI, "SwitchMode('mini')")
            MapState = false
            SetInputMode(0)
            SetIgnoreLookInput(false)
            ShowMouseCursor(false)
            SetWebVisibility(MapUI, WEB_HITINVISIBLE)
        else
            ExecuteWebJS(MapUI, "SwitchMode('big')")
            MapState = true
            SetInputMode(1)
            SetIgnoreLookInput(true)
            ShowMouseCursor(true)
            SetWebVisibility(MapUI, WEB_VISIBLE)
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)