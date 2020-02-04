ScoreboardUI = nil

function OnPackageStart()
    CreateTimer(function()
        CallRemoteEvent("Survival:Scoreboard:RequestPlayersList")
    end, 5000)

    ScoreboardUI = CreateWebUI(0, 0, 0, 0, 5, 50)
    SetWebAlignment(ScoreboardUI, 0.0, 0.0)
    SetWebAnchors(ScoreboardUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(ScoreboardUI, WEB_HITINVISIBLE)

    LoadWebFile(ScoreboardUI, "http://asset/"..GetPackageName().."/client/scoreboard/ui/scoreboard.html")
end
AddEvent("OnPackageStart", OnPackageStart)

AddRemoteEvent("Survival:Scoreboard:ClearPlayerList", function()
    ExecuteWebJS(ScoreboardUI, "clearPlayerList()")
end)

AddRemoteEvent("Survival:Scoreboard:AddPlayerList", function(data)
    ExecuteWebJS(ScoreboardUI, "addPlayerList("..data..")")
end)

AddEvent("OnKeyPress", function(key)
    if key == "Tab" then
        ExecuteWebJS(ScoreboardUI, "setScoreboardState(1)")
    end
end)

AddEvent("OnKeyRelease", function(key)
    if key == "Tab" then
        ExecuteWebJS(ScoreboardUI, "setScoreboardState(0)")
    end
end)