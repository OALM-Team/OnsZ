function SetPlayerClothing(player, clothingId)
    if (clothingId ~= nil and clothingId ~= 0) then
      SetPlayerClothingPreset(player, clothingId)
    end
end
AddRemoteEvent("Survival:Player:SetPlayerClothing", SetPlayerClothing)

AddEvent("OnPlayerNetworkUpdatePropertyValue", function(player, name, value)
  if name == "clothingID" then
    SetPlayerClothingPreset(player, value)
  end
end)