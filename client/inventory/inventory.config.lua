InventoryItems = {}

InventoryItems["water"] = {
    name="Bouteille d'eau",
    pickup_model=666,
    pickup_scale=1,
    dimensions={w=1,h=2},
    is_food=true,
    food_value=0,
    drink_value=30,
    sleep_value=0,
    desc="Une simple bouteille d'eau"
}
InventoryItems["apple"] = {
    name="Pomme",
    pickup_model=1644,
    pickup_scale=1,
    dimensions={w=1,h=1},
    is_food=true,
    food_value=20,
    drink_value=0,
    sleep_value=0,
    desc="Une pomme juteuse"
}
InventoryItems["pickaxe"] = {
    name="Pioche",
    pickup_model=1644,
    pickup_scale=1,
    dimensions={w=4,h=4},
    desc="Une pioche classique"
}
InventoryItems["sandwish"] = {
    name="Sandwish",
    dimensions={w=3,h=1},
    pickup_model=1272,
    pickup_scale=1,
    is_food=true,
    food_value=40,
    drink_value=0,
    sleep_value=0,
    desc="Pas sûr qu'il soit toujours bon"
}
InventoryItems["torchlight"] = {
    name="Lampe torche",
    pickup_model=1270,
    pickup_scale=1,
    dimensions={w=2,h=2},
    desc="Pour voir dans le noir"
}
InventoryItems["gas"] = {
    name="Bidon d'essence",
    pickup_model=507,
    pickup_scale=1,
    dimensions={w=2,h=2},
    desc="Permet de remettre du carburant dans un véhicule"
}
InventoryItems["capsule_1"] = {
    name="Capsule Nuka",
    dimensions={w=1,h=1},
    desc="C'est la monnaie courante sur cette île en absence de monnaies comme l'euros"
}
InventoryItems["rad_pill"] = {
    name="Pilule anti-radiation",
    dimensions={w=2,h=1},
    pickup_model=811,
    pickup_scale=1,
    desc="Permet de réduire votre taux de radiation"
}
InventoryItems["bag_1"] = {
    name="Petit sac",
    pickup_model=1281,
    pickup_scale=1,
    is_bag=true,
    slots=40,
    dimensions={w=3,h=3},
    desc="Permet de stocker plus d'objets sur vous (40 places)",
    modelId=1281, x=-2, y=-20, z=0 , rx=-180, ry=80, rz=-90
}

-------------- BLOOD ---------------
InventoryItems["blood_test"] = {
    name="Kit de test groupe sanguin",
    dimensions={w=3,h=2},
    pickup_model=809,
    pickup_scale=1,
    desc="Un kit de test pour savoir votre groupe sanguin"
}
InventoryItems["bloog_bag_oplus"] = {
    name="Poche de sang (O+)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="O+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (O+)"
}
InventoryItems["bloog_bag_ominus"] = {
    name="Poche de sang (O-)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="O-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (O-)"
}
InventoryItems["bloog_bag_bplus"] = {
    name="Poche de sang (B+)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="B+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (B+)"
}
InventoryItems["bloog_bag_bminus"] = {
    name="Poche de sang (B-)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="B-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (B-)"
}
InventoryItems["bloog_bag_aplus"] = {
    name="Poche de sang (A+)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="A+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (A+)"
}
InventoryItems["bloog_bag_aminus"] = {
    name="Poche de sang (A-)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="A-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (A-)"
}
InventoryItems["bloog_bag_abplus"] = {
    name="Poche de sang (AB+)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="AB+",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (AB+)"
}
InventoryItems["bloog_bag_abminus"] = {
    name="Poche de sang (AB-)",
    is_blood_bag=true,
    pickup_model=1678,
    pickup_scale=1,
    blood_bag_type="AB-",
    dimensions={w=1,h=2},
    desc="Permet de faire une transfusion de sang (AB-)"
}

--------- WEAPONS ----------
InventoryItems["deagle"] = {
    is_weapon=true,
    id_weapon=2,
    pickup_model=4,
    pickup_scale=1,
    name="Desert Eagle",
    dimensions={w=4,h=3},
    desc="Utilise des balles de .50 Action Express"
}
InventoryItems["ammo_50_ae"] = {
    is_weapon=false,
    is_ammo=true,
    pickup_model=23,
    pickup_scale=1,
    ammo_weapons={2},
    ammo_size=8,
    name="Cartouche .50 Action Express",
    dimensions={w=2,h=1},
    desc="Cartouche pour Desert Deagle"
}
InventoryItems["glock"] = {
    is_weapon=true,
    id_weapon=4,
    pickup_model=6,
    pickup_scale=1,
    name="Glock",
    dimensions={w=4,h=3},
    desc="Utilise des balles de .9mm"
}
InventoryItems["ammo_9_mm"] = {
    is_weapon=false,
    is_ammo=true,
    pickup_model=23,
    pickup_scale=1,
    ammo_weapons={4,10},
    ammo_size=14,
    name="Cartouche .9mm",
    dimensions={w=2,h=1},
    desc="Cartouche pour Glock, UMP"
}
InventoryItems["shotgun_1"] = {
    is_weapon=true,
    id_weapon=7,
    pickup_model=8,
    pickup_scale=1,
    name="Fusil a pompe",
    dimensions={w=8,h=2},
    desc="Utilise des balles de .9mm"
}
InventoryItems["ammo_12_mm"] = {
    is_weapon=false,
    is_ammo=true,
    pickup_model=23,
    pickup_scale=1,
    ammo_weapons={7},
    ammo_size=10,
    name="Cartouche .12mm",
    dimensions={w=2,h=1},
    desc="Cartouche pour Fusil a pompe"
}
InventoryItems["ump"] = {
    is_weapon=true,
    id_weapon=10,
    pickup_model=12,
    pickup_scale=1,
    name="UMP",
    dimensions={w=6,h=3},
    desc="Utilise des balles de .9mm"
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