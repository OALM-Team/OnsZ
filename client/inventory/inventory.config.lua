InventoryItems = {}

InventoryItems["water"] = {
    name="Bouteille d'eau",
    dimensions={w=1,h=2},
    desc="Une simple bouteille d'eau"
}
InventoryItems["apple"] = {
    name="Pomme",
    dimensions={w=1,h=1},
    desc="Une pomme juteuse"
}
InventoryItems["pickaxe"] = {
    name="Pioche",
    dimensions={w=4,h=4},
    desc="Une pioche classique"
}
InventoryItems["sandwish"] = {
    name="Sandwish",
    dimensions={w=3,h=1},
    desc="Pas sûr qu'il soit toujours bon"
}
InventoryItems["torchlight"] = {
    name="Lampe torche",
    dimensions={w=2,h=2},
    desc="Pour voir dans le noir"
}
InventoryItems["gas"] = {
    name="Bidon d'essence",
    dimensions={w=2,h=2},
    desc="Permet de remettre du carburant dans un véhicule"
}
InventoryItems["bloog_bag_oplus"] = {
    name="Poche de sang (O+)",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (O+)"
}

InventoryItems["deagle"] = {
    is_weapon=true,
    id_weapon=2,
    name="Desert Eagle",
    dimensions={w=4,h=3},
    desc="Utilise des balles de .50 Action Express"
}
InventoryItems["ammo_50_ae"] = {
    is_weapon=false,
    is_ammo=true,
    ammo_weapons={2},
    ammo_size=8,
    name="Cartouche .50 Action Express",
    dimensions={w=2,h=1},
    desc="Cartouche pour Desert Deagle"
}
InventoryItems["glock"] = {
    is_weapon=true,
    id_weapon=4,
    name="Glock",
    dimensions={w=4,h=3},
    desc="Utilise des balles de .9mm"
}
InventoryItems["ammo_9_mm"] = {
    is_weapon=false,
    is_ammo=true,
    ammo_weapons={4},
    ammo_size=14,
    name="Cartouche .9mm",
    dimensions={w=2,h=1},
    desc="Cartouche pour Glock"
}