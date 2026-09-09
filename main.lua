local DEFAULT_CONFIG = {
    AutoPickup = false,
    PickupDelay = 0.10,
    PickupMaxRadius = 0,
    VacuumNearby = true,
    VacuumRadius = 14,
    ReturnToStart = true,
    PickupRarities = {
        ["Mythic"] = true,
        ["Legendary"] = true,
        ["Elite"] = true,
        ["Rare"] = true,
        ["Uncommon"] = true,
        ["Common"] = true,
    },
    AutoSellOnFull = false,
    ReturnAfterSell = true,
    SellByRarity = true,
    ProtectByName = true,
    SellRarities = {
        ["Common"] = true,
    },
    ProtectedItems = {
        ["Idol of Hatred"] = true,
        ["Totem of Hatred"] = true,
        ["Stone Accord"] = true,
    },
    EnableWalkSpeed = false,
    WalkSpeed = 24,
    WalkSpeedKeybind = "None",
    Fly = false,
    FlySpeed = 50,
    FlyKeybind = "F",
    Noclip = false,
    NoclipKeybind = "N",
}

local VALUABLE_TRELLO_ITEMS = {
    "Accursed Robes",
    "Arcane Rune",
    "Armageddon",
    "Auroran Lance",
    "Biome Blade",
    "Bladecrest Oathsword",
    "Blessed Carapace",
    "Blood Pact",
    "Brain of Confusion",
    "Breaker Blade",
    "Brimlash",
    "Broken Biome Blade",
    "Burdenmail",
    "Butcherer",
    "Carnage",
    "Chaos Stone",
    "Cobalt Kunai",
    "Collared Tunic",
    "Crimson Cowl",
    "Cursed Hammer",
    "Cyst Worm",
    "Dark Amulet",
    "Deadlight",
    "Deadweight",
    "Desecrated Carapace",
    "DPS Meter",
    "Dread's Decree",
    "Ebon Cloak",
    "Elegy Of The Tides",
    "Ember Cloak",
    "Emberedge",
    "Enchanted Sword",
    "Enhancement Tome (Affinity III)",
    "Enhancement Tome (Affinity IV)",
    "Enhancement Tome (Affinity V)",
    "Enhancement Tome (Haste II)",
    "Enhancement Tome (Haste III)",
    "Enhancement Tome (Longevity III)",
    "Enhancement Tome (Luck I)",
    "Enhancement Tome (Luck III)",
    "Enhancement Tome (Mystic III)",
    "Enhancement Tome (Mystic IV)",
    "Enhancement Tome (Mystic V)",
    "Enhancement Tome (Protection)",
    "Enhancement Tome (Sharpness III)",
    "Enhancement Tome (Sharpness IV)",
    "Enhancement Tome (Sharpness V)",
    "Evasion Scarf",
    "Experimental Chemist",
    "Extraterrestrial Transmitter",
    "Fabled Crown",
    "Festered Shield",
    "Fire Tongue",
    "Flare Bolt",
    "Fork Of Doom",
    "Frost Dancer",
    "Furystone",
    "Gem Crusher",
    "Gladiator's Locket",
    "Gloomhook",
    "Goblin Scepter",
    "Greatsword",
    "Hellspiller",
    "Hexed Wraithblade",
    "Imp Staff",
    "Infernal Plate",
    "Inferno Fork",
    "Influx Waver",
    "Keblade",
    "Lifeform Analyzer",
    "Lucky Coin",
    "Magma Stone",
    "Malignant Bane",
    "Melting Pot",
    "Midnight Fractal",
    "Mindbreaker",
    "Mourning Wake",
    "Mournmight",
    "Nazar",
    "Necronomical Scroll",
    "Necronomical Skull",
    "Night Weave",
    "Nimbus Rod",
    "Occult Skull Crown",
    "Pale Vanguard",
    "Philosopher's Stone",
    "Pillarfall",
    "Putrid Scent",
    "Pygmy Necklace",
    "Radar",
    "Rage Pelt",
    "Rover Drive",
    "Sanctifying Luminousness",
    "Sanguine Garb",
    "Sanguine Vestments",
    "Scourge Of Disease",
    "Seraphim",
    "Shadowbeam Staff",
    "Shadowflame Knife",
    "Shatterpoint",
    "Shiny Stone",
    "Shrouded Tanto",
    "Silver Aegis",
    "Sorcerer's Mantle",
    "Soul Shroud",
    "Soul Silencer",
    "Sovereign",
    "Staff Of The False Sun",
    "Staff Of Voidmending",
    "Storm Ruler",
    "Suniron",
    "Surgecloth",
    "Suspicious Boulder",
    "Testament's Edge",
    "The Angry Mask",
    "The Convergence",
    "The Dice",
    "The Laughing Mask",
    "The Sleeping Mask",
    "The Weeping Mask",
    "The Weightless Crown",
    "Tidal Anchor",
    "Titan Glove",
    "Tribal Visage",
    "Unyielding Darkness",
    "Venom Fang",
    "Viperpoint",
    "Voidlance",
    "Weeping Sore",
    "Witchlight",
    "Withersting"
}

local TRELLO_ITEMS = {
    "Accursed Robes",
    "Adventurer's Apparel",
    "Aegis Banner",
    "Aglet",
    "Amulet",
    "Anklet Of The Wind",
    "Arcane Rune",
    "Armageddon",
    "Auroran Lance",
    "Balloon",
    "Band Of Efficiency",
    "Band Of Regeneration",
    "Band Of Stamina",
    "Bare Blade",
    "Barethread",
    "Basher",
    "Biome Blade",
    "Black Belt",
    "Blacksmith's Kit",
    "Bladecrest Oathsword",
    "Blessed Carapace",
    "Blood Pact",
    "Bone Gauntlet",
    "Bonesaber",
    "Brain of Confusion",
    "Breaker Blade",
    "Brewery Staff",
    "Brimlash",
    "Broken Biome Blade",
    "Burdenmail",
    "Butcherer",
    "Candlewick",
    "Carnage",
    "Catapult",
    "Chaos Stone",
    "Cloud In A Bottle",
    "Cobalt Kunai",
    "Collared Tunic",
    "Cowl",
    "Crescent Vigil",
    "Crimson Cowl",
    "Crusader Cuirass",
    "Cursed Hammer",
    "Cyst Worm",
    "DPS Meter",
    "Dagger",
    "Dark Amulet",
    "Deadlight",
    "Deadweight",
    "Desecrated Carapace",
    "Diamond",
    "Diamond Staff",
    "Dread's Decree",
    "Ebon Cloak",
    "Elegy Of The Tides",
    "Ember Cloak",
    "Emberedge",
    "Emerald",
    "Emerald Staff",
    "Enchanted Sword",
    "Enhancement Tome (Acuity)",
    "Enhancement Tome (Affinity I)",
    "Enhancement Tome (Affinity II)",
    "Enhancement Tome (Affinity III)",
    "Enhancement Tome (Affinity IV)",
    "Enhancement Tome (Affinity V)",
    "Enhancement Tome (Attune I)",
    "Enhancement Tome (Attune II)",
    "Enhancement Tome (Bane of the Hive)",
    "Enhancement Tome (Bleed Immunity)",
    "Enhancement Tome (Blind Protection)",
    "Enhancement Tome (Bounce I)",
    "Enhancement Tome (Bounce II)",
    "Enhancement Tome (Dominion)",
    "Enhancement Tome (Fire Protection)",
    "Enhancement Tome (Fleet I)",
    "Enhancement Tome (Fleet II)",
    "Enhancement Tome (Haste I)",
    "Enhancement Tome (Haste II)",
    "Enhancement Tome (Haste III)",
    "Enhancement Tome (Ice Immunity)",
    "Enhancement Tome (Knockback I)",
    "Enhancement Tome (Knockback II)",
    "Enhancement Tome (Lightning Immunity)",
    "Enhancement Tome (Longevity I)",
    "Enhancement Tome (Longevity II)",
    "Enhancement Tome (Longevity III)",
    "Enhancement Tome (Luck I)",
    "Enhancement Tome (Luck II)",
    "Enhancement Tome (Luck III)",
    "Enhancement Tome (Mystic I)",
    "Enhancement Tome (Mystic II)",
    "Enhancement Tome (Mystic III)",
    "Enhancement Tome (Mystic IV)",
    "Enhancement Tome (Mystic V)",
    "Enhancement Tome (Poison Immunity)",
    "Enhancement Tome (Protection)",
    "Enhancement Tome (Rejuvenating I)",
    "Enhancement Tome (Rejuvenating II)",
    "Enhancement Tome (Rot Immunity)",
    "Enhancement Tome (Sharpness I)",
    "Enhancement Tome (Sharpness II)",
    "Enhancement Tome (Sharpness III)",
    "Enhancement Tome (Sharpness IV)",
    "Enhancement Tome (Sharpness V)",
    "Enhancement Tome (Slowness Protection)",
    "Enhancement Tome (Smite)",
    "Enhancement Tome (Stun Protection)",
    "Enhancement Tome (Thorns)",
    "Evasion Scarf",
    "Experimental Chemist",
    "Extraterrestrial Transmitter",
    "Fabled Crown",
    "Festered Meat",
    "Festered Shield",
    "Fighter Gi",
    "Fire Tongue",
    "Firebrand Bone",
    "Firework",
    "Fissure's Agility",
    "Fissure's Protection",
    "Flare Bolt",
    "Flask of Grace",
    "Flesh Knuckles",
    "Flint Cutlass",
    "Floaty",
    "Fork Of Doom",
    "Formal Attire",
    "Formal Finery",
    "Frigid Mallet",
    "Frost Dancer",
    "Furystone",
    "Gem Crusher",
    "Gentleman's Fedora",
    "Geode Dagger",
    "Giant Lollipop",
    "Gilded Diamond Timepiece",
    "Gladiator's Locket",
    "Gloomhook",
    "Goblet",
    "Goblin Scepter",
    "Golden Beetle",
    "Greatsword",
    "Hardened Cloak",
    "Health Potion",
    "Heavy Scale",
    "Hellspiller",
    "Hermes Boots",
    "Hexed Wraithblade",
    "Hiveling Arm",
    "Hoarapace",
    "Ice Bolt",
    "Icepiercer",
    "Idol of Hatred",
    "Imp Staff",
    "Infernal Plate",
    "Inferno Fork",
    "Influx Waver",
    "Ivory Shell",
    "Jolly Striper",
    "Jumbo Firework",
    "Keblade",
    "Kiribachi",
    "Lifeform Analyzer",
    "Lucky Coin",
    "Magical Harp",
    "Magma Stone",
    "Malignant Bane",
    "Mana Flower",
    "Melting Pot",
    "Miasmic Blight",
    "Midnight Fractal",
    "Mindbreaker",
    "Mourning Wake",
    "Mournmight",
    "Muramasa",
    "Navy Tuskblade",
    "Nazar",
    "Necronomical Scroll",
    "Necronomical Skull",
    "Night Raiment",
    "Night Weave",
    "Nightcall Potion",
    "Nimble Ward",
    "Nimbus Rod",
    "Noble Longsword",
    "Occult Skull Crown",
    "Old Amulet",
    "Old Ring",
    "Pale Vanguard",
    "Philosopher's Stone",
    "Pillarfall",
    "Portable Harmonic Fleshling",
    "Power Glove",
    "Prosthetic Arm",
    "Putrid Scent",
    "Pygmy Necklace",
    "Quicksilver",
    "Radar",
    "Rage Pelt",
    "Ragged Cloth",
    "Rags",
    "Ranger Tunic",
    "Rapier",
    "Recall Potion",
    "Regeneration Potion",
    "Rimeblade",
    "Ring",
    "Rosespike Staff",
    "Rot Polyp Wand",
    "Rotting Greaves",
    "Rover Drive",
    "Ruby",
    "Ruby Staff",
    "Runner's Handbook",
    "Runner's Outfit",
    "Sahara Slicer",
    "Sanctifying Luminousness",
    "Sanguine Dirk",
    "Sanguine Garb",
    "Sanguine Vestments",
    "Sapphire",
    "Sapphire Staff",
    "Scourge Of Disease",
    "Seraphim",
    "Shackles",
    "Shades",
    "Shadowbeam Staff",
    "Shadowflame Knife",
    "Shatterpoint",
    "Shiny Stone",
    "Shrouded Tanto",
    "Silver Aegis",
    "Sky Garments",
    "Sky Scepter",
    "Smiley Bomb",
    "Sorcerer's Mantle",
    "Soul Shroud",
    "Soul Silencer",
    "Sovereign",
    "Spear",
    "Spider Silk",
    "Splintered Dagger",
    "Spore Sac",
    "Staff Of Sparkling",
    "Staff Of The False Sun",
    "Staff Of Voidmending",
    "Stamina Regeneration Potion",
    "Starfury",
    "Stone Accord",
    "Storm Ruler",
    "Suit",
    "Summon Rune",
    "Suniron",
    "Surgecloth",
    "Suspicious Boulder",
    "Suspicious Looking Tentacle",
    "Swiftness Potion",
    "Sword",
    "Testament's Edge",
    "The Angry Mask",
    "The Convergence",
    "The Dice",
    "The Laughing Mask",
    "The Sleeping Mask",
    "The Spellweaver",
    "The Weeping Mask",
    "The Weightless Crown",
    "Thick Cloak",
    "Thick Point",
    "Thief's Gear",
    "Thin Hide",
    "Thornvine",
    "Tidal Anchor",
    "Tidebreaker",
    "Titan Glove",
    "Topaz",
    "Topaz Staff",
    "Tophat",
    "Totem of Hatred",
    "Tribal Visage",
    "Trumpet",
    "Unformed Fang",
    "Unyielding Darkness",
    "Vampiric Talisman",
    "Veering Wind",
    "Veil's Aberration",
    "Venom Fang",
    "Verdant Thorn",
    "Viperpoint",
    "Voidlance",
    "Wanderer's Blade",
    "Water Bolt",
    "Weeping Sore",
    "Whoopie Cushion",
    "Willow Lantern",
    "Wind Blade",
    "Witchlight",
    "Withersting",
    "Wrath Potion"
}

local WORLD_NPCS = {
    ["A Florian"] = Vector3.new(-17.9, 40.9, 68),
    ["Adam"] = Vector3.new(195.9, 182.5, -3),
    ["Ambrose"] = Vector3.new(115.5, 169.6, -55.8),
    ["Atmere"] = Vector3.new(116, 202.8, 21.3),
    ["Aurora Wisp"] = Vector3.new(249.2, 1442.4, -264.2),
    ["Ayra"] = Vector3.new(324.5, 22.9, -199.3),
    ["Beevor"] = Vector3.new(105.8, 169.6, -60.4),
    ["Binder Of Mourns"] = Vector3.new(-23, 183.6, -120),
    ["Blacksmith's Kit (Crypt)"] = Vector3.new(-468, 72, -1348),
    ["Blacksmith's Kit (The Glade)"] = Vector3.new(76.1, 174.3, -158.3),
    ["Blanche"] = Vector3.new(247.7, 11.9, -312.3),
    ["Bobby, Blacksmith"] = Vector3.new(-461.7, 68.4, -1373.9),
    ["Bones McGee"] = Vector3.new(14.3, 196.3, 62.1),
    ["Brian"] = Vector3.new(-91.8, 186.3, 57.6),
    ["Briar"] = Vector3.new(-131, 9.3, 20.6),
    ["Buford"] = Vector3.new(45.2, 180.3, 149.5),
    ["Cadogan"] = Vector3.new(-15.2, 170.7, 91.2),
    ["Calvin, Potion Specialist"] = Vector3.new(12.9, 168.9, -226.9),
    ["Clement, Merchant"] = Vector3.new(242.5, 185.5, 1),
    ["Crypt Obelisk"] = Vector3.new(-1201.4, 37.4, -2016.9),
    ["Dagger (Crypt)"] = Vector3.new(-464.4, 72.2, -1385.2),
    ["Dagger (The Glade)"] = Vector3.new(66.2, 175, -190.2),
    ["Dante"] = Vector3.new(53, 179.5, 173.8),
    ["Dark Shores"] = Vector3.new(-21, 192.8, -105.4),
    ["David, Merchant"] = Vector3.new(-527.6, 73.4, -1485.8),
    ["Dimitri"] = Vector3.new(83.4, 179.3, 148),
    ["Eadgyth, Grand Arbiter Of Refinement and Supreme Authority Of Impeccable Taste"] = Vector3.new(92.3, 169.6, -78.4),
    ["Egg"] = Vector3.new(339.2, 14.8, -286.8),
    ["Eldigan"] = Vector3.new(-27.2, 177.2, -100),
    ["Elian"] = Vector3.new(38.5, 45.9, 84.7),
    ["Emilie"] = Vector3.new(81.2, 179.5, 162.1),
    ["Formal Attire"] = Vector3.new(273.5, 189, 1),
    ["Formal Finery"] = Vector3.new(-130.9, 189.5, 4.9),
    ["Francesca"] = Vector3.new(-15.1, 177.3, -118.6),
    ["Fraser"] = Vector3.new(41.4, 179.3, 165.3),
    ["Fritz"] = Vector3.new(299.1, 12.9, -254.7),
    ["Gilmore"] = Vector3.new(-110.1, 182.6, 9.4),
    ["Glade Obelisk"] = Vector3.new(-88.8, 191.4, -118.8),
    ["Goblin Tinkerer"] = Vector3.new(19.9, 22.7, -95),
    ["Greatsword (Crypt)"] = Vector3.new(-468.6, 72.4, -1385.6),
    ["Greatsword (The Glade)"] = Vector3.new(71.2, 176, -189.6),
    ["Havelock"] = Vector3.new(13.1, 174.7, -96.4),
    ["Heavy Scale (Crypt)"] = Vector3.new(-473, 72, -1384.5),
    ["Heavy Scale (The Glade)"] = Vector3.new(87.5, 174.3, -185.6),
    ["Isabel"] = Vector3.new(31.8, 172.3, 72.3),
    ["Isaiah"] = Vector3.new(306.9, 12.9, -344.9),
    ["Jemima"] = Vector3.new(-453.3, 72.4, -1524.9),
    ["Jenova"] = Vector3.new(-29, 176.2, 29.2),
    ["Jonathan, Blacksmith"] = Vector3.new(83.5, 171.1, -181),
    ["Kaladin"] = Vector3.new(55.1, 195.3, 162.1),
    ["Kelsier"] = Vector3.new(-25.8, 170.8, 102.8),
    ["Lachesis"] = Vector3.new(67.6, 181.7, 172.5),
    ["Lantern (Crypt)"] = Vector3.new(-462.6, 71.4, -1385.1),
    ["Lantern (The Glade)"] = Vector3.new(70.3, 173.9, -180.2),
    ["Lasting Memories"] = Vector3.new(55.3, 201.7, 174.6),
    ["Layle"] = Vector3.new(85.8, 169, -43.3),
    ["Layton"] = Vector3.new(269.6, 11.9, -341.1),
    ["Malachi"] = Vector3.new(99.8, 169.4, -69.7),
    ["Marcus"] = Vector3.new(210.7, 182.6, 33.7),
    ["Maximillian"] = Vector3.new(66.5, 179.5, 142.3),
    ["Maxwell, The Guide"] = Vector3.new(-17.9, 186.9, -31.1),
    ["Mystery Monster"] = Vector3.new(-23.2, 183.6, -92.6),
    ["Ogma"] = Vector3.new(-202.3, 12, -335.4),
    ["Pubert, Illegal Potion Dealer"] = Vector3.new(-584.7, 104.4, -1638.9),
    ["Rapier (Crypt)"] = Vector3.new(-465, 70.7, -1381.5),
    ["Rapier (The Glade)"] = Vector3.new(74.1, 175.5, -189.2),
    ["Remus"] = Vector3.new(166.9, 20.9, -299.8),
    ["Rough Waters"] = Vector3.new(-24.6, 183.6, -111.1),
    ["Runner's Outfit (Crypt)"] = Vector3.new(-512.5, 77, -1477.5),
    ["Runner's Outfit (The Glade)"] = Vector3.new(117, 176.6, 38.7),
    ["Rupert"] = Vector3.new(70.5, 169.6, -73.5),
    ["Saffron"] = Vector3.new(92.1, 170, -47.2),
    ["Sapphron"] = Vector3.new(-1355, 41.4, -626.5),
    ["Sergei"] = Vector3.new(76.2, 169.6, -78.2),
    ["Shimmer Obelisk"] = Vector3.new(-1344.2, 37.1, -284.3),
    ["Sir Glade"] = Vector3.new(98.4, 192.2, 90.9),
    ["Smiling Bag"] = Vector3.new(110.8, 173.1, -52.1),
    ["Sonion, Stylist"] = Vector3.new(-114.7, 190.7, 2.2),
    ["Spear (Crypt)"] = Vector3.new(-469.5, 71.9, -1383.1),
    ["Spear (The Glade)"] = Vector3.new(76.4, 175, -189.2),
    ["Staff Of Sparkling"] = Vector3.new(10.9, 171.7, -213),
    ["Stuart"] = Vector3.new(-155.8, 189.5, -42),
    ["Suit"] = Vector3.new(83.1, 173, -84.1),
    ["Swift"] = Vector3.new(117, 184.8, 36),
    ["Sword (Crypt)"] = Vector3.new(-466.3, 71.7, -1385),
    ["Sword (The Glade)"] = Vector3.new(68.5, 175.5, -190.4),
    ["The Blooming Grotto"] = Vector3.new(80.2, 201.7, 164.3),
    ["The Crazy Man of The Glade"] = Vector3.new(-223.6, 193.2, 11.2),
    ["The Glade Mines Gatekeeper"] = Vector3.new(301, 16.9, -372),
    ["The Wisp"] = Vector3.new(-5694.4, 12.1, -234.5),
    ["Thick Cloak"] = Vector3.new(245, 189, 8.5),
    ["Thomas"] = Vector3.new(-355.5, 67.4, -1573.6),
    ["Viola"] = Vector3.new(57.1, 179.5, 161.3),
    ["Vorax"] = Vector3.new(-627, 74.5, -1456),
    ["Yapin"] = Vector3.new(47.4, 179.5, 160.2),
    ["Ywain"] = Vector3.new(-504, 79.4, -1332.5)
}

local WORLD_NPC_NAMES = {
    "A Florian",
    "Adam",
    "Ambrose",
    "Atmere",
    "Aurora Wisp",
    "Ayra",
    "Beevor",
    "Binder Of Mourns",
    "Blacksmith's Kit (Crypt)",
    "Blacksmith's Kit (The Glade)",
    "Blanche",
    "Bobby, Blacksmith",
    "Bones McGee",
    "Brian",
    "Briar",
    "Buford",
    "Cadogan",
    "Calvin, Potion Specialist",
    "Clement, Merchant",
    "Crypt Obelisk",
    "Dagger (Crypt)",
    "Dagger (The Glade)",
    "Dante",
    "Dark Shores",
    "David, Merchant",
    "Dimitri",
    "Eadgyth, Grand Arbiter Of Refinement and Supreme Authority Of Impeccable Taste",
    "Egg",
    "Eldigan",
    "Elian",
    "Emilie",
    "Formal Attire",
    "Formal Finery",
    "Francesca",
    "Fraser",
    "Fritz",
    "Gilmore",
    "Glade Obelisk",
    "Goblin Tinkerer",
    "Greatsword (Crypt)",
    "Greatsword (The Glade)",
    "Havelock",
    "Heavy Scale (Crypt)",
    "Heavy Scale (The Glade)",
    "Isabel",
    "Isaiah",
    "Jemima",
    "Jenova",
    "Jonathan, Blacksmith",
    "Kaladin",
    "Kelsier",
    "Lachesis",
    "Lantern (Crypt)",
    "Lantern (The Glade)",
    "Lasting Memories",
    "Layle",
    "Layton",
    "Malachi",
    "Marcus",
    "Maximillian",
    "Maxwell, The Guide",
    "Mystery Monster",
    "Ogma",
    "Pubert, Illegal Potion Dealer",
    "Rapier (Crypt)",
    "Rapier (The Glade)",
    "Remus",
    "Rough Waters",
    "Runner's Outfit (Crypt)",
    "Runner's Outfit (The Glade)",
    "Rupert",
    "Saffron",
    "Sapphron",
    "Sergei",
    "Shimmer Obelisk",
    "Sir Glade",
    "Smiling Bag",
    "Sonion, Stylist",
    "Spear (Crypt)",
    "Spear (The Glade)",
    "Staff Of Sparkling",
    "Stuart",
    "Suit",
    "Swift",
    "Sword (Crypt)",
    "Sword (The Glade)",
    "The Blooming Grotto",
    "The Crazy Man of The Glade",
    "The Glade Mines Gatekeeper",
    "The Wisp",
    "Thick Cloak",
    "Thomas",
    "Viola",
    "Vorax",
    "Yapin",
    "Ywain"
}

local MAP_STREAM_SECTORS = {
    Vector3.new(242.5, 185.5, 1),
    Vector3.new(70.5, 175, -80),
    Vector3.new(-25, 180, -100),
    Vector3.new(-120, 190, 0),
    Vector3.new(-470, 72, -1380),
    Vector3.new(-530, 75, -1490),
    Vector3.new(-585, 105, -1640),
    Vector3.new(-1200, 38, -2016),
    Vector3.new(-1350, 42, -626),
    Vector3.new(250, 1442, -264),
    Vector3.new(-5694, 12, -235),
    Vector3.new(300, 20, -300),
}

if _G.__VeilHubUnload then
    pcall(_G.__VeilHubUnload)
end

_G.__VeilHubRunning = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local InteractPromptEvent = Remotes:WaitForChild("InteractPromptEvent")
local SellItemsEvent = Remotes:WaitForChild("SellItemsEvent")
local MerchantSellMode = Remotes:WaitForChild("MerchantSellMode")

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local FlyBodyVelocity = nil
local FlyBodyGyro = nil

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function StopFlying()
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    if FlyBodyGyro then
        FlyBodyGyro:Destroy()
        FlyBodyGyro = nil
    end
    local hum = GetHumanoid()
    if hum then
        hum.PlatformStand = false
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
end

local function StartFlying()
    local hrp = GetRootPart()
    local hum = GetHumanoid()
    if not hrp then return end

    StopFlying()

    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Name = "__FlyBV"
    FlyBodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    FlyBodyVelocity.Velocity = Vector3.zero
    FlyBodyVelocity.Parent = hrp

    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.Name = "__FlyBG"
    FlyBodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    FlyBodyGyro.P = 10000
    FlyBodyGyro.CFrame = hrp.CFrame
    FlyBodyGyro.Parent = hrp

    if hum then
        hum.PlatformStand = true
    end
end

_G.__VeilHubLibrary = Library
_G.__VeilHubUnload = function()
    _G.__VeilHubRunning = false
    StopFlying()
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = 17
    end
    Library:Unload()
end

local Options = Library.Options
local Toggles = Library.Toggles

local SessionPickedCount = 0
local InitialFarmCFrame = nil
local IsSelling = false
local IgnoredDrops = {}

local StatusLabel = nil
local MapDropsLabel = nil
local FilterMatchesLabel = nil
local SessionPickedLabel = nil

local function GetDropPosition(d)
    if not d then return nil end
    local p = d.PrimaryPart or d:FindFirstChild("Handle") or d:FindFirstChildWhichIsA("BasePart")
    if p then return p.Position end
    local piv = d:GetPivot()
    if piv and piv.Position ~= Vector3.zero then
        return piv.Position
    end
    return nil
end

local function GetBackpackCount()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return 0 end
    local count = 0
    for _, item in ipairs(bp:GetChildren()) do
        if item:IsA("Tool") then
            count = count + 1
        end
    end
    return count
end

local function SafeTeleport(targetPos)
    local hrp = GetRootPart()
    if not hrp then return false end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(targetPos, 2)
    end)

    local safePos = targetPos + Vector3.new(0, 2.5, 0)
    hrp.CFrame = CFrame.new(safePos)

    local platform = Instance.new("Part")
    platform.Name = "__SafePlatform"
    platform.Size = Vector3.new(10, 1, 10)
    platform.CFrame = CFrame.new(targetPos - Vector3.new(0, 0.5, 0))
    platform.Anchored = true
    platform.Transparency = 1
    platform.CanCollide = true
    platform.Parent = Workspace

    task.delay(0.5, function()
        if platform and platform.Parent then
            platform:Destroy()
        end
    end)

    return true
end

local function StreamEntireMap()
    for _, sector in ipairs(MAP_STREAM_SECTORS) do
        if not _G.__VeilHubRunning then break end
        pcall(function()
            LocalPlayer:RequestStreamAroundAsync(sector, 1)
        end)
    end
end

local function GetSanity()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local mg = pg and pg:FindFirstChild("MainGui")
    local sb = mg and mg:FindFirstChild("SanityBar")
    local sc = sb and sb:FindFirstChild("SanityCount")
    if sc and sc.Text then
        local cur = string.match(sc.Text, "(%d+)")
        if cur then
            return tonumber(cur) or 100
        end
    end
    return 100
end

local function FindMerchant()
    local npcs = Workspace:FindFirstChild("NPCs")
    if npcs then
        local clement = npcs:FindFirstChild("Clement, Merchant")
        if clement then return clement end
        for _, n in ipairs(npcs:GetChildren()) do
            if string.find(n.Name, "Clement") or string.find(n.Name, "Merchant") then
                return n
            end
        end
    end
    return nil
end

local function PerformSellRoutine()
    if IsSelling then return false end
    IsSelling = true

    local hrp = GetRootPart()
    if not hrp then
        IsSelling = false
        return false
    end

    local merchantPos = Vector3.new(242.5, 185.5, 1)
    local merchant = FindMerchant()
    if merchant then
        merchantPos = merchant:GetPivot().Position
    end

    local resumeCFrame = hrp.CFrame

    SafeTeleport(merchantPos + Vector3.new(0, 0, 4))
    task.wait(0.3)

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then
        IsSelling = false
        return false
    end

    local allowedRarities = Options.SellRarities.Value or {}
    local protectedItems = Options.ProtectedItems.Value or {}
    local byRarity = Toggles.SellByRarity.Value
    local protectByName = Toggles.ProtectByName.Value

    local toolsToSell = {}
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") and tool.Name ~= "Bag" then
            local sp = tool:FindFirstChild("SellPrice")
            if sp and sp.Value > 0 then
                local isProtected = false
                if protectByName then
                    if protectedItems[tool.Name] == true then
                        isProtected = true
                    elseif (tool.Name == "Idol of Hatred" or tool.Name == "Totem of Hatred") and (protectedItems["Idol of Hatred"] or protectedItems["Totem of Hatred"]) then
                        isProtected = true
                    end
                end

                if not isProtected then
                    local rarityObj = tool:FindFirstChild("Rarity")
                    local rarity = rarityObj and rarityObj.Value or "Common"
                    local matchesRarity = allowedRarities[rarity] == true

                    local shouldSell = false
                    if byRarity then
                        shouldSell = matchesRarity
                    else
                        shouldSell = true
                    end

                    if shouldSell then
                        table.insert(toolsToSell, tool)
                    end
                end
            end
        end
    end

    if #toolsToSell == 0 then
        Library:Notify("No backpack items matched sell criteria.", 3)
        if Toggles.ReturnAfterSell.Value then
            hrp.CFrame = resumeCFrame
        end
        IsSelling = false
        return false
    end

    if not merchant then
        merchant = FindMerchant()
    end

    MerchantSellMode:Fire(true, merchant)
    task.wait(0.15)
    SellItemsEvent:FireServer(toolsToSell)
    task.wait(0.35)

    Library:Notify(string.format("Successfully sold %d items at Clement!", #toolsToSell), 4)

    if Toggles.ReturnAfterSell.Value then
        task.wait(0.15)
        SafeTeleport(resumeCFrame.Position)
    end

    IsSelling = false
    return true
end

local function VacuumNearbyDrops(centerPos, maxDist)
    local dropsFolder = Workspace:FindFirstChild("Drops")
    if not dropsFolder then return 0 end
    local allowed = Options.PickupRarities.Value or {}
    local count = 0
    for _, nearby in ipairs(dropsFolder:GetChildren()) do
        local exp = IgnoredDrops[nearby]
        if (not exp or tick() >= exp) and nearby:FindFirstChild("Argument") and nearby.Argument.Value == "PickupDrop" then
            local r = nearby:GetAttribute("Rarity") or "Common"
            if allowed[r] then
                local pPos = GetDropPosition(nearby)
                if pPos and (centerPos - pPos).Magnitude <= maxDist then
                    InteractPromptEvent:FireServer("PickupDrop", nearby)
                    count = count + 1
                end
            end
        end
    end
    return count
end

local function CollectSingleDrop(drop)
    if GetSanity() < 20 then
        return false
    end

    local hrp = GetRootPart()
    if not hrp then return false end

    local targetPos = GetDropPosition(drop)
    if not targetPos then return false end

    SafeTeleport(targetPos)

    local delayTime = Options.PickupDelay.Value or 0.10
    if delayTime > 0 then
        task.wait(delayTime)
    end

    local argVal = "PickupDrop"
    local argObj = drop:FindFirstChild("Argument")
    if argObj and argObj.Value then
        argVal = argObj.Value
    end

    InteractPromptEvent:FireServer(argVal, drop)

    if Toggles.VacuumNearby and Toggles.VacuumNearby.Value then
        VacuumNearbyDrops(targetPos, Options.VacuumRadius and Options.VacuumRadius.Value or 14)
    end

    local collected = false
    for _ = 1, 10 do
        task.wait(0.04)
        if not drop:IsDescendantOf(Workspace) then
            collected = true
            break
        end
        InteractPromptEvent:FireServer(argVal, drop)
    end

    if collected then
        SessionPickedCount = SessionPickedCount + 1
        if SessionPickedLabel then
            SessionPickedLabel:SetText("Items Picked: " .. SessionPickedCount)
        end
        if Toggles.VacuumNearby and Toggles.VacuumNearby.Value then
            task.wait(0.03)
            VacuumNearbyDrops(targetPos, Options.VacuumRadius and Options.VacuumRadius.Value or 14)
        end
    else
        IgnoredDrops[drop] = tick() + 45
    end

    return collected
end

local function GetFilteredDrops()
    local dropsFolder = Workspace:FindFirstChild("Drops")
    if not dropsFolder then return {}, 0 end

    local allowed = Options.PickupRarities.Value or {}
    local hrp = GetRootPart()
    local centerPos = (hrp and hrp.Position) or Vector3.zero
    local maxRadius = Options.PickupMaxRadius and Options.PickupMaxRadius.Value or 0

    local allCount = 0
    local filtered = {}
    local now = tick()

    for _, d in ipairs(dropsFolder:GetChildren()) do
        if d:FindFirstChild("Argument") and d.Argument.Value == "PickupDrop" then
            allCount = allCount + 1
            local exp = IgnoredDrops[d]
            if not exp or now >= exp then
                local r = d:GetAttribute("Rarity") or "Common"
                if allowed[r] then
                    local pPos = GetDropPosition(d)
                    if pPos then
                        local dist = (centerPos - pPos).Magnitude
                        if maxRadius == 0 or dist <= maxRadius then
                            table.insert(filtered, { drop = d, dist = dist })
                        end
                    end
                end
            end
        end
    end

    table.sort(filtered, function(a, b) return a.dist < b.dist end)

    local res = {}
    for _, item in ipairs(filtered) do
        table.insert(res, item.drop)
    end
    return res, allCount
end

local function TeleportToActiveQuestWaypoint()
    local anchor = Workspace.CurrentCamera:FindFirstChild("QuestWaypointAnchor")
    if anchor and anchor:IsA("BasePart") then
        SafeTeleport(anchor.Position)
        Library:Notify("Teleported to Active Quest Objective!", 3)
        return true
    end
    Library:Notify("No active QuestWaypointAnchor found.", 3)
    return false
end

local function TeleportToNearestQuestMarker()
    local qmFolder = Workspace:FindFirstChild("QuestMarkers")
    if not qmFolder or #qmFolder:GetChildren() == 0 then
        Library:Notify("No NPC Quest Markers found in world.", 3)
        return false
    end

    local hrp = GetRootPart()
    local myPos = (hrp and hrp.Position) or Vector3.zero

    local closestMarker = nil
    local minDist = math.huge

    for _, m in ipairs(qmFolder:GetChildren()) do
        local p = m:IsA("BasePart") and m.Position or m:GetPivot().Position
        local d = (myPos - p).Magnitude
        if d < minDist then
            minDist = d
            closestMarker = m
        end
    end

    if closestMarker then
        local p = closestMarker:IsA("BasePart") and closestMarker.Position or closestMarker:GetPivot().Position
        SafeTeleport(p)
        Library:Notify(string.format("Teleported to Quest NPC (%.1f studs away)!", minDist), 3)
        return true
    end
    return false
end

local Window = Library:CreateWindow({
    Title = "The Veil | Utility Hub",
    Footer = "Obsidian UI | Trello Datamine",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Farm = Window:AddTab("Auto Pickup", "package"),
    Sell = Window:AddTab("Auto Sell", "coins"),
    Movement = Window:AddTab("Movement", "zap"),
    Teleports = Window:AddTab("Teleports", "map-pin"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local FarmLeft = Tabs.Farm:AddLeftGroupbox("Trinket Farm")

FarmLeft:AddToggle("AutoPickup", {
    Text = "Enable Auto Pickup",
    Default = DEFAULT_CONFIG.AutoPickup,
    Tooltip = "Teleports across map to pick up trinket drops",
})

FarmLeft:AddSlider("PickupDelay", {
    Text = "Pickup Delay",
    Default = DEFAULT_CONFIG.PickupDelay,
    Min = 0.02,
    Max = 1.0,
    Rounding = 2,
    Suffix = "s",
    Tooltip = "Delay between landing and firing pickup remote",
})

FarmLeft:AddToggle("VacuumNearby", {
    Text = "Vacuum Nearby Drops (AoE)",
    Default = DEFAULT_CONFIG.VacuumNearby,
    Tooltip = "Picks up all drops in range at once without extra teleports",
})

FarmLeft:AddSlider("VacuumRadius", {
    Text = "Vacuum Radius",
    Default = DEFAULT_CONFIG.VacuumRadius,
    Min = 6,
    Max = 20,
    Rounding = 0,
    Suffix = " studs",
    Tooltip = "Radius to sweep nearby drops in one stop",
})

FarmLeft:AddSlider("PickupMaxRadius", {
    Text = "Farming Radius",
    Default = DEFAULT_CONFIG.PickupMaxRadius,
    Min = 0,
    Max = 3000,
    Rounding = 0,
    Suffix = " studs",
    Tooltip = "0 = Full map unlimited range",
})

FarmLeft:AddToggle("ReturnToStart", {
    Text = "Return to Start on Stop",
    Default = DEFAULT_CONFIG.ReturnToStart,
    Tooltip = "Returns character to start coordinate when farming stops",
})

local FarmRight = Tabs.Farm:AddRightGroupbox("Rarity Filter and Stats")

FarmRight:AddDropdown("PickupRarities", {
    Values = { "Mythic", "Legendary", "Elite", "Rare", "Uncommon", "Common" },
    Default = DEFAULT_CONFIG.PickupRarities,
    Multi = true,
    Text = "Target Rarities",
    Tooltip = "Select rarities to pick up",
})
Options.PickupRarities:SetValue(DEFAULT_CONFIG.PickupRarities)

StatusLabel = FarmRight:AddLabel("Status: Idle", true)
MapDropsLabel = FarmRight:AddLabel("Total Drops on Map: 0")
FilterMatchesLabel = FarmRight:AddLabel("Matching Filter: 0")
SessionPickedLabel = FarmRight:AddLabel("Items Picked: 0")

FarmRight:AddButton({
    Text = "Refresh Drop Counts",
    Func = function()
        local matches, total = GetFilteredDrops()
        if MapDropsLabel then MapDropsLabel:SetText("Total Drops on Map: " .. total) end
        if FilterMatchesLabel then FilterMatchesLabel:SetText("Matching Filter: " .. #matches) end
    end,
    DoubleClick = false,
    Tooltip = "Updates drop scanner counts immediately",
})

FarmRight:AddButton({
    Text = "Pre-Stream Entire Map",
    Func = function()
        Library:Notify("Scanning and pre-streaming entire map...", 2)
        task.spawn(function()
            StreamEntireMap()
            task.wait(0.5)
            local matches, total = GetFilteredDrops()
            if MapDropsLabel then MapDropsLabel:SetText("Total Drops on Map: " .. total) end
            if FilterMatchesLabel then FilterMatchesLabel:SetText("Matching Filter: " .. #matches) end
            Library:Notify(string.format("Map streamed! Found %d total drops (%d matching).", total, #matches), 3)
        end)
    end,
    DoubleClick = false,
    Tooltip = "Requests server to stream all world sectors into client memory",
})

local SellLeft = Tabs.Sell:AddLeftGroupbox("Merchant Auto-Sell")

SellLeft:AddToggle("AutoSellOnFull", {
    Text = "Auto-Sell When Bag Full",
    Default = DEFAULT_CONFIG.AutoSellOnFull,
    Tooltip = "Automatically teleports to Clement when inventory is full",
})

SellLeft:AddToggle("ReturnAfterSell", {
    Text = "Return to Farm After Selling",
    Default = DEFAULT_CONFIG.ReturnAfterSell,
    Tooltip = "Teleports back to farming position after transaction",
})

SellLeft:AddToggle("SellByRarity", {
    Text = "Filter by Rarity",
    Default = DEFAULT_CONFIG.SellByRarity,
    Tooltip = "Enables selling items that match selected rarities",
})

SellLeft:AddToggle("ProtectByName", {
    Text = "Enable Blacklist Protection",
    Default = DEFAULT_CONFIG.ProtectByName,
    Tooltip = "Protects selected items so they are NEVER sold",
})

SellLeft:AddDropdown("SellRarities", {
    Values = { "Mythic", "Legendary", "Elite", "Rare", "Uncommon", "Common" },
    Default = DEFAULT_CONFIG.SellRarities,
    Multi = true,
    Text = "Allowed Sell Rarities",
    Tooltip = "Select rarities to sell to merchant",
})
Options.SellRarities:SetValue(DEFAULT_CONFIG.SellRarities)

SellLeft:AddDivider()

SellLeft:AddButton({
    Text = "Sell Items Now (Clement)",
    Func = function()
        PerformSellRoutine()
    end,
    DoubleClick = false,
    Tooltip = "Immediately executes merchant selling run",
})

local SellRight = Tabs.Sell:AddRightGroupbox("Item Blacklist (Do Not Sell)")

SellRight:AddDropdown("ProtectedItems", {
    Values = TRELLO_ITEMS,
    Default = DEFAULT_CONFIG.ProtectedItems,
    Multi = true,
    Searchable = true,
    Text = "Protected Items (Do Not Sell)",
    Tooltip = "Search and select items you want to KEEP. They will never be sold.",
})
Options.ProtectedItems:SetValue(DEFAULT_CONFIG.ProtectedItems)

SellRight:AddButton({
    Text = "Protect Current Inventory Tools",
    Func = function()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return end
        local current = Options.ProtectedItems.Value or {}
        local count = 0
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name ~= "Bag" then
                if not current[t.Name] then
                    current[t.Name] = true
                    count = count + 1
                end
            end
        end
        Options.ProtectedItems:SetValue(current)
        Library:Notify(string.format("Protected %d inventory tools from being sold!", count), 3)
    end,
    DoubleClick = false,
    Tooltip = "Scans backpack and marks all existing tools as protected",
})

SellRight:AddButton({
    Text = "Protect All Rare / Elite / Legendary",
    Func = function()
        local current = Options.ProtectedItems.Value or {}
        local count = 0
        for _, item in ipairs(VALUABLE_TRELLO_ITEMS) do
            if not current[item] then
                current[item] = true
                count = count + 1
            end
        end
        Options.ProtectedItems:SetValue(current)
        Library:Notify(string.format("Protected %d high-tier Trello items!", count), 3)
    end,
    DoubleClick = false,
    Tooltip = "Adds all Rare, Elite, Legendary, and Mythic catalog items to blacklist",
})

SellRight:AddButton({
    Text = "Clear Blacklist",
    Func = function()
        Options.ProtectedItems:SetValue({})
        Library:Notify("Cleared protected items blacklist.", 2)
    end,
    DoubleClick = false,
    Tooltip = "Unchecks all items in the protected list",
})

local MoveLeft = Tabs.Movement:AddLeftGroupbox("WalkSpeed")

MoveLeft:AddToggle("EnableWalkSpeed", {
    Text = "Enable Custom WalkSpeed",
    Default = DEFAULT_CONFIG.EnableWalkSpeed,
    Tooltip = "Overrides player walking speed",
}):AddKeyPicker("WalkSpeedKeybind", {
    Default = DEFAULT_CONFIG.WalkSpeedKeybind,
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "WalkSpeed Keybind",
    NoUI = false,
})

MoveLeft:AddSlider("WalkSpeed", {
    Text = "WalkSpeed",
    Default = DEFAULT_CONFIG.WalkSpeed,
    Min = 16,
    Max = 150,
    Rounding = 0,
    Suffix = " studs/s",
    Tooltip = "Character move speed (Default game speed is 17)",
})

local MoveRight = Tabs.Movement:AddRightGroupbox("Flight and Noclip")

MoveRight:AddToggle("Fly", {
    Text = "Enable Fly",
    Default = DEFAULT_CONFIG.Fly,
    Tooltip = "Fly freely across map using WASD + Space + Shift",
}):AddKeyPicker("FlyKeybind", {
    Default = DEFAULT_CONFIG.FlyKeybind,
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Fly Keybind",
    NoUI = false,
})

MoveRight:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = DEFAULT_CONFIG.FlySpeed,
    Min = 10,
    Max = 250,
    Rounding = 0,
    Suffix = " studs/s",
    Tooltip = "Flight movement velocity",
})

MoveRight:AddDivider()

MoveRight:AddToggle("Noclip", {
    Text = "Enable Noclip",
    Default = DEFAULT_CONFIG.Noclip,
    Tooltip = "Pass through terrain, walls, and obstacles",
}):AddKeyPicker("NoclipKeybind", {
    Default = DEFAULT_CONFIG.NoclipKeybind,
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Noclip Keybind",
    NoUI = false,
})

local TpLeft = Tabs.Teleports:AddLeftGroupbox("Quest Teleports")

TpLeft:AddButton({
    Text = "Teleport to Active Quest Objective",
    Func = function()
        TeleportToActiveQuestWaypoint()
    end,
    DoubleClick = false,
    Tooltip = "Teleports directly to QuestWaypointAnchor",
})

TpLeft:AddButton({
    Text = "Teleport to Nearest Quest NPC",
    Func = function()
        TeleportToNearestQuestMarker()
    end,
    DoubleClick = false,
    Tooltip = "Teleports to closest marker in QuestMarkers",
})

TpLeft:AddDivider()

TpLeft:AddButton({
    Text = "Teleport to The Glade Town",
    Func = function()
        SafeTeleport(Vector3.new(238, 186, 0))
        Library:Notify("Teleported to The Glade!", 3)
    end,
    DoubleClick = false,
    Tooltip = "Teleport to Town center",
})

TpLeft:AddButton({
    Text = "Teleport to Sky Safe Altitude",
    Func = function()
        local hrp = GetRootPart()
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
            Library:Notify("Teleported 200 studs upwards!", 3)
        end
    end,
    DoubleClick = false,
    Tooltip = "Teleports player high into sky to avoid danger",
})

local TpRight = Tabs.Teleports:AddRightGroupbox("World NPCs and Locations (96)")

TpRight:AddDropdown("TargetNPC", {
    Values = WORLD_NPC_NAMES,
    Default = "Clement, Merchant",
    Multi = false,
    Searchable = true,
    Text = "World NPC",
    Tooltip = "Search and select any of the 96 world NPCs / Vendors / Obelisks",
})

TpRight:AddButton({
    Text = "Teleport to Selected NPC",
    Func = function()
        local name = Options.TargetNPC.Value
        local cachedPos = WORLD_NPCS[name]
        local npcsFolder = Workspace:FindFirstChild("NPCs")
        local livePos = nil
        if npcsFolder then
            local liveNpc = npcsFolder:FindFirstChild(name)
            if liveNpc then
                livePos = liveNpc:GetPivot().Position
            end
        end
        local finalPos = livePos or cachedPos
        if finalPos then
            SafeTeleport(finalPos + Vector3.new(0, 0, 4))
            Library:Notify("Teleported to " .. name .. "!", 3)
        else
            Library:Notify("NPC coordinate not found.", 3)
        end
    end,
    DoubleClick = false,
    Tooltip = "Bypasses StreamingEnabled and teleports directly to NPC",
})

local SettingsLeft = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

SettingsLeft:AddLabel("Menu Bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu Keybind" })

Library.ToggleKeybind = Options.MenuKeybind

SettingsLeft:AddButton({
    Text = "Unload Script",
    Func = function()
        _G.__VeilHubRunning = false
        StopFlying()
        local hum = GetHumanoid()
        if hum then
            hum.WalkSpeed = 17
        end
        Library:Unload()
    end,
    DoubleClick = true,
    Tooltip = "Double click to completely unload UI and stop scripts",
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("TheVeilHub")
SaveManager:SetFolder("TheVeilHub/game")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

_G.VeilHub = {
    Library = Library,
    PerformSellRoutine = PerformSellRoutine,
    SafeTeleport = SafeTeleport,
    TeleportToActiveQuestWaypoint = TeleportToActiveQuestWaypoint,
    TeleportToNearestQuestMarker = TeleportToNearestQuestMarker,
    CollectSingleDrop = CollectSingleDrop,
    GetFilteredDrops = GetFilteredDrops,
    StreamEntireMap = StreamEntireMap,
    StartFlying = StartFlying,
    StopFlying = StopFlying,
}

Toggles.AutoPickup:OnChanged(function()
    if Toggles.AutoPickup.Value then
        local hrp = GetRootPart()
        InitialFarmCFrame = hrp and hrp.CFrame
        if StatusLabel then StatusLabel:SetText("Status: Farming Active") end
    else
        if StatusLabel then StatusLabel:SetText("Status: Idle") end
        if Toggles.ReturnToStart.Value and InitialFarmCFrame then
            local hrp = GetRootPart()
            if hrp then
                hrp.CFrame = InitialFarmCFrame
            end
        end
    end
end)

Toggles.Fly:OnChanged(function()
    if Toggles.Fly.Value then
        StartFlying()
        Library:Notify("Fly enabled (WASD + Space + Shift)", 2)
    else
        StopFlying()
        Library:Notify("Fly disabled", 2)
    end
end)

Toggles.Noclip:OnChanged(function()
    if Toggles.Noclip.Value then
        Library:Notify("Noclip enabled", 2)
    else
        Library:Notify("Noclip disabled", 2)
    end
end)

Toggles.EnableWalkSpeed:OnChanged(function()
    if not Toggles.EnableWalkSpeed.Value then
        local hum = GetHumanoid()
        if hum then
            hum.WalkSpeed = 17
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not _G.__VeilHubRunning then return end
    if Toggles.Fly and Toggles.Fly.Value then
        local hrp = GetRootPart()
        local cam = Workspace.CurrentCamera
        if hrp and cam and FlyBodyVelocity and FlyBodyVelocity.Parent == hrp then
            local camCF = cam.CFrame
            local flySpeed = Options.FlySpeed and Options.FlySpeed.Value or 50
            local moveDir = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                FlyBodyVelocity.Velocity = moveDir.Unit * flySpeed
            else
                FlyBodyVelocity.Velocity = Vector3.zero
            end

            if FlyBodyGyro and FlyBodyGyro.Parent == hrp then
                FlyBodyGyro.CFrame = camCF
            end
        elseif not FlyBodyVelocity or FlyBodyVelocity.Parent ~= hrp then
            StartFlying()
        end
    end
end)

RunService.Stepped:Connect(function()
    if not _G.__VeilHubRunning then return end
    if Toggles.Noclip and Toggles.Noclip.Value then
        local char = GetCharacter()
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not _G.__VeilHubRunning then return end
    if Toggles.EnableWalkSpeed and Toggles.EnableWalkSpeed.Value then
        local hum = GetHumanoid()
        if hum and Options.WalkSpeed then
            local targetSpeed = Options.WalkSpeed.Value
            if hum.WalkSpeed ~= targetSpeed then
                hum.WalkSpeed = targetSpeed
            end
        end
    end
end)

task.spawn(function()
    local lastStatUpdate = 0
    local lastMapStream = 0
    while _G.__VeilHubRunning do
        local now = tick()
        if now - lastStatUpdate >= 2 then
            lastStatUpdate = now
            pcall(function()
                local matches, total = GetFilteredDrops()
                if MapDropsLabel then MapDropsLabel:SetText("Total Drops on Map: " .. total) end
                if FilterMatchesLabel then FilterMatchesLabel:SetText("Matching Filter: " .. #matches) end
            end)
        end

        if Toggles.AutoPickup and Toggles.AutoPickup.Value and not IsSelling then
            if now - lastMapStream >= 40 then
                lastMapStream = now
                task.spawn(StreamEntireMap)
            end

            local curSanity = GetSanity()
            if curSanity < 20 then
                if StatusLabel then StatusLabel:SetText("Status: Critical Sanity (" .. curSanity .. "/100)! Recovering...") end
                Library:Notify("Sanity critical (" .. curSanity .. "/100)! Retreating to spawn to recover...", 4)

                local safePos = (InitialFarmCFrame and InitialFarmCFrame.Position) or Vector3.new(238, 186, 0)
                SafeTeleport(safePos)

                local waitCount = 0
                while _G.__VeilHubRunning and Toggles.AutoPickup.Value do
                    task.wait(1)
                    waitCount = waitCount + 1
                    local s = GetSanity()
                    if s >= 90 then
                        Library:Notify("Sanity recovered (" .. s .. "/100)! Resuming auto-pickup.", 3)
                        if StatusLabel then StatusLabel:SetText("Status: Farming Active") end
                        break
                    else
                        if waitCount >= 6 and s <= 22 then
                            SafeTeleport(Vector3.new(238, 186, 0))
                        else
                            local hrp = GetRootPart()
                            if hrp and (hrp.Position - safePos).Magnitude > 15 then
                                SafeTeleport(safePos)
                            end
                        end
                        if StatusLabel then StatusLabel:SetText("Status: Recovering Sanity (" .. s .. "/100)...") end
                    end
                end
            else
                local bpCount = GetBackpackCount()
                if bpCount >= 148 then
                    if Toggles.AutoSellOnFull and Toggles.AutoSellOnFull.Value then
                        if StatusLabel then StatusLabel:SetText("Status: Inventory Full! Auto-Selling...") end
                        Library:Notify("Inventory full (" .. bpCount .. "/150). Auto-selling at Clement...", 3)
                        PerformSellRoutine()
                        local newCount = GetBackpackCount()
                        if newCount >= 148 then
                            if StatusLabel then StatusLabel:SetText("Status: Paused (Inventory Still Full)") end
                            Library:Notify("Auto-Pickup paused: No items were sold. Inventory full!", 5)
                            Toggles.AutoPickup:SetValue(false)
                        else
                            if StatusLabel then StatusLabel:SetText("Status: Farming Resumed") end
                        end
                    else
                        if StatusLabel then StatusLabel:SetText("Status: Paused (Inventory Full)") end
                        Library:Notify("Inventory full! Enable Auto-Sell or clear inventory to continue.", 5)
                        Toggles.AutoPickup:SetValue(false)
                    end
                else
                    local matches = GetFilteredDrops()
                    if #matches > 0 then
                        local target = matches[1]
                        if StatusLabel then StatusLabel:SetText("Status: Collecting " .. target.Name) end
                        CollectSingleDrop(target)
                    else
                        if StatusLabel then StatusLabel:SetText("Status: Streaming Map for Drops...") end
                        StreamEntireMap()
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait()
    end
end)

Library:Notify("The Veil Utility Hub Loaded Successfully! Press RightShift to Toggle.", 5)
