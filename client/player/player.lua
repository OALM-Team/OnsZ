function RefreshPlayerOutfit(player)
    UpdatePlayerOutfit(player)
end
AddRemoteEvent("Survival:Player:RefreshPlayerOutfit", RefreshPlayerOutfit)

AddEvent("OnPlayerNetworkUpdatePropertyValue", function(player, name, value)
  if name == "_outfitPantId" or name == "_outfitTopId" then
    --SetPlayerClothingPreset(player, value)
    UpdatePlayerOutfit(player)
  end
end)

AddEvent("OnPlayerStreamIn", function(player)
  UpdatePlayerOutfit(player)
end)

function UpdatePlayerOutfit(player)
  local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")

  -- pant
  if GetPlayerPropertyValue(player, "_outfitPantId") then
    local pantTemplate = OutfitsTemplate[GetPlayerPropertyValue(player, "_outfitPantId")]
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
    SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pantTemplate.model))
    local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
    DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(pantTemplate.color.r,pantTemplate.color.g,pantTemplate.color.b, 1.0))
    SkeletalMeshComponent:SetRelativeScale3D(FVector(1.0, 1.01, 1.0))
    SkeletalMeshComponent:SetRelativeRotation(FRotator(0.0, 0.0, 0.0))
    SkeletalMeshComponent:SetRelativeLocation(FVector(0.0, 0.0, 0.0))
  else
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
    SkeletalMeshComponent:SetSkeletalMesh(nil)
  end
  
  if GetPlayerPropertyValue(player, "_outfitTopId") then
    local topTemplate = OutfitsTemplate[GetPlayerPropertyValue(player, "_outfitTopId")]
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
    SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(topTemplate.model))
    local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
    DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(topTemplate.color.r,topTemplate.color.g,topTemplate.color.b, 1.0))
    SkeletalMeshComponent:SetRelativeScale3D(FVector(1.0, 1.01, 1.0))
    SkeletalMeshComponent:SetRelativeRotation(FRotator(0.0, 0.0, 0.0))
    SkeletalMeshComponent:SetRelativeLocation(FVector(0.0, 0.0, 0.0))
  else
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
    SkeletalMeshComponent:SetSkeletalMesh(nil)
  end
    
  -- shoes
  SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing5")
	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR"))
end