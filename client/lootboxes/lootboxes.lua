Lootboxes = {}

function OnPackageStart()
    CreateTimer(function()
        local px, py, pz = GetPlayerLocation(GetPlayerId())
        for _,lootbox in pairs(Lootboxes) do
            if GetObjectLocation(lootbox.object) ~= false then
                local ox, oy, oz = GetObjectLocation(lootbox.object)
                if not lootbox.nearbyState then
                    if GetDistance3D(px, py, pz, ox, oy, oz) < 200 then
                        DisplayNearbyState(lootbox)
                    end
                else
                    if GetDistance3D(px, py, pz, ox, oy, oz) > 200 then
                        UnDisplayNearbyState(lootbox)
                    end
                end
            end
        end
    end, 500)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnKeyPress(key)
    if not IsCtrlPressed() and key == "E" then
        TryOpenNearbyLootbox()
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function TryOpenNearbyLootbox()
    for _,lootbox in pairs(Lootboxes) do
        if lootbox.nearbyState then
            SetSoundVolume(CreateSound("client/lootboxes/open_box_1.mp3"), 0.1)
            CallRemoteEvent("Survival:Lootboxes:OpenLootbox", GetObjectPropertyValue(lootbox.object, "_lootboxId"))
        end
    end
end

AddEvent("OnObjectNetworkUpdatePropertyValue", function(object, name, value)
    if name == "_isLootbox" and value then
        Lootboxes[object] = {
            nearbyState = false,
            object = object,
            textActor = nil
        }
        Lootboxes[object].textActor:SetText("Inspecter [E]")
        Lootboxes[object].textActor:SetTextRenderColor(FLinearColor(0.0, 1, 0.0, 1.0))
        Lootboxes[object].textActor:SetRelativeRotation(FRotator(90, 90, 0))
        Lootboxes[object].textActor:SetRelativeLocation(FVector(-20, 45, 40))
    end
end)

AddEvent("OnObjectStreamIn", function(object)
    if GetObjectPropertyValue(object, "_isLootbox") then
        Lootboxes[object] = {
            nearbyState = false,
            object = object,
            textActor = nil
        }
    end
end)

AddEvent("OnObjectStreamOut", function(object)
    if Lootboxes[object] ~= nil then
        UnDisplayNearbyState(Lootboxes[object])
        Lootboxes[object] = nil
    end
end)

function UnDisplayNearbyState(lootbox)
    lootbox.nearbyState = false
    local actor = GetObjectActor(lootbox.object)
    SetObjectOutline(lootbox.object, false)
    if lootbox.textActor ~= nil then
        lootbox.textActor:Destroy()
        lootbox.textActor = nil
    end
end

function DisplayNearbyState(lootbox)
    lootbox.nearbyState = true
    local actor = GetObjectActor(lootbox.object)
    SetObjectOutline(lootbox.object, true)
    lootbox.textActor = actor:AddComponent(UTextRenderComponent.Class())
    lootbox.textActor:SetText("Inspecter [E]")
    lootbox.textActor:SetTextRenderColor(FLinearColor(0.0, 1, 0.0, 1.0))
    lootbox.textActor:SetRelativeRotation(FRotator(90, 90, 0))
    lootbox.textActor:SetRelativeLocation(FVector(-20, 45, 40))
end