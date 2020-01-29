function SetNight()
    SetFogDensity(10.0)
    SetSunShine(10)
    SetWeather(1)
    SetTime(3)
    --SetWeather(10)
end
AddRemoteEvent("Survival:Weather:SetNight", SetNight)