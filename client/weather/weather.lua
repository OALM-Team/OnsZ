function SetNight()
    SetFogDensity(10.0)
    SetSunShine(0)
    SetWeather(10)
end
AddRemoteEvent("Survival:Weather:SetNight", SetNight)