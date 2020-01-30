InventoryItems = {}

InventoryItems["water"] = {
    name="Bouteille d'eau",
    dimensions={w=1,h=2},
    is_food=true,
    food_value=0,
    drink_value=30,
    sleep_value=0,
    desc="Une simple bouteille d'eau"
}
InventoryItems["apple"] = {
    name="Pomme",
    dimensions={w=1,h=1},
    is_food=true,
    food_value=20,
    drink_value=0,
    sleep_value=0,
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
    is_food=true,
    food_value=40,
    drink_value=0,
    sleep_value=0,
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

-------------- BLOOD ---------------
InventoryItems["blood_test"] = {
    name="Kit de test groupe sanguin",
    dimensions={w=3,h=2},
    desc="Un kit de test pour savoir votre groupe sanguin"
}
InventoryItems["bloog_bag_oplus"] = {
    name="Poche de sang (O+)",
    is_blood_bag=true,
    blood_bag_type="O+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (O+)"
}
InventoryItems["bloog_bag_ominus"] = {
    name="Poche de sang (O-)",
    is_blood_bag=true,
    blood_bag_type="O-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (O-)"
}
InventoryItems["bloog_bag_bplus"] = {
    name="Poche de sang (B+)",
    is_blood_bag=true,
    blood_bag_type="B+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (B+)"
}
InventoryItems["bloog_bag_bminus"] = {
    name="Poche de sang (B-)",
    is_blood_bag=true,
    blood_bag_type="B-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (B-)"
}
InventoryItems["bloog_bag_aplus"] = {
    name="Poche de sang (A+)",
    is_blood_bag=true,
    blood_bag_type="A+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (A+)"
}
InventoryItems["bloog_bag_aminus"] = {
    name="Poche de sang (A-)",
    is_blood_bag=true,
    blood_bag_type="A-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (A-)"
}
InventoryItems["bloog_bag_abplus"] = {
    name="Poche de sang (AB+)",
    is_blood_bag=true,
    blood_bag_type="AB+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (AB+)"
}
InventoryItems["bloog_bag_abminus"] = {
    name="Poche de sang (AB-)",
    is_blood_bag=true,
    blood_bag_type="AB-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (AB-)"
}

--------- WEAPONS ----------
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
InventoryItems["shotgun_1"] = {
    is_weapon=true,
    id_weapon=7,
    name="Fusil a pompe",
    dimensions={w=8,h=2},
    desc="Utilise des balles de .9mm"
}
InventoryItems["ammo_12_mm"] = {
    is_weapon=false,
    is_ammo=true,
    ammo_weapons={7},
    ammo_size=10,
    name="Cartouche .12mm",
    dimensions={w=2,h=1},
    desc="Cartouche pour Fusil a pompe"
}

--------- OUTFITS ----------
InventoryItems["green_pant"] = {
    name="Pantalon Vert",
    dimensions={w=2,h=4},
    desc="Un pantalon vert",
    outfit_type="pant",
    is_outfit=true
}
InventoryItems["red_pant"] = {
    name="Pantalon Rouge",
    dimensions={w=2,h=4},
    desc="Un pantalon rouge",
    outfit_type="pant",
    is_outfit=true
}
InventoryItems["black_tshirt"] = {
    name="Tshirt Noir",
    dimensions={w=3,h=3},
    desc="Un tshirt noir",
    outfit_type="top",
    is_outfit=true
}
InventoryItems["blue_tshirt"] = {
    name="Tshirt Bleu",
    dimensions={w=3,h=3},
    desc="Un tshirt bleu",
    outfit_type="top",
    is_outfit=true
}