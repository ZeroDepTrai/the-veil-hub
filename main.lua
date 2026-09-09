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
    SellByName = false,
    SellMatchMode = "Match Any (Rarity OR Name)",
    SellRarities = {
        ["Common"] = true,
    },
    SellItems = {
        ["Old Amulet"] = true,
        ["Old Ring"] = true,
        ["Goblet"] = true,
        ["Amulet"] = true,
        ["Ring"] = true,
        ["Aglet"] = true,
        ["Ragged Cloth"] = true,
        ["Thin Hide"] = true,
        ["Rags"] = true,
        ["Cowl"] = true,
        ["Whoopie Cushion"] = true,
    }
}

local COMMON_JUNK_TRINKETS = {
    ["Old Amulet"] = true,
    ["Old Ring"] = true,
    ["Goblet"] = true,
    ["Amulet"] = true,
    ["Ring"] = true,
    ["Aglet"] = true,
    ["Ragged Cloth"] = true,
    ["Thin Hide"] = true,
    ["Rags"] = true,
    ["Cowl"] = true,
    ["Whoopie Cushion"] = true,
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
    "Cơ Chế Ép Cường Hóa (Rules & Formulas)",
    "Cobalt Kunai",
    "Collared Tunic",
    "Cowl",
    "Crescent Vigil",
    "Crimson Cowl",
    "Crusader Cuirass",
    "Cursed Hammer",
    "Cyst Worm",
    "Dagger",
    "Dark Amulet",
    "Deadlight",
    "Deadweight",
    "Desecrated Carapace",
    "Diamond",
    "Diamond Staff",
    "DPS Meter",
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

_G.__VeilHubLibrary = Library
_G.__VeilHubUnload = function()
    _G.__VeilHubRunning = false
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

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetDropPart(d)
    return d and (d.PrimaryPart or d:FindFirstChild("Handle") or d:FindFirstChildWhichIsA("BasePart"))
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

    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(targetPos, 1)
    end)

    local finalPos = targetPos + Vector3.new(0, 1.2, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(finalPos)
    return true
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

    local merchant = FindMerchant()
    if not merchant then
        Library:Notify("Merchant Clement not found on map!", 4)
        IsSelling = false
        return false
    end

    local merchantPos = merchant:GetPivot().Position
    local resumeCFrame = hrp.CFrame

    SafeTeleport(merchantPos + Vector3.new(0, 0, 4))
    task.wait(0.3)

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then
        IsSelling = false
        return false
    end

    local allowedRarities = Options.SellRarities.Value or {}
    local allowedItems = Options.SellItems.Value or {}
    local byRarity = Toggles.SellByRarity.Value
    local byName = Toggles.SellByName.Value
    local matchMode = Options.SellMatchMode.Value

    local toolsToSell = {}
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") and tool.Name ~= "Bag" then
            local sp = tool:FindFirstChild("SellPrice")
            if sp and sp.Value > 0 then
                local rarityObj = tool:FindFirstChild("Rarity")
                local rarity = rarityObj and rarityObj.Value or "Common"
                local matchesRarity = allowedRarities[rarity] == true
                local matchesName = allowedItems[tool.Name] == true

                local shouldSell = false
                if byRarity and byName then
                    if matchMode == "Match Both (Rarity AND Name)" then
                        shouldSell = matchesRarity and matchesName
                    else
                        shouldSell = matchesRarity or matchesName
                    end
                elseif byRarity then
                    shouldSell = matchesRarity
                elseif byName then
                    shouldSell = matchesName
                end

                if shouldSell then
                    table.insert(toolsToSell, tool)
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
                local p = GetDropPart(nearby)
                if p and (centerPos - p.Position).Magnitude <= maxDist then
                    InteractPromptEvent:FireServer("PickupDrop", nearby)
                    count = count + 1
                end
            end
        end
    end
    return count
end

local function CollectSingleDrop(drop)
    local hrp = GetRootPart()
    if not hrp then return false end

    local targetPart = GetDropPart(drop)
    if not targetPart then return false end

    local targetPos = targetPart.Position
    SafeTeleport(targetPos)

    local delayTime = Options.PickupDelay.Value or 0.10
    if delayTime > 0 then
        task.wait(delayTime)
    end

    local argVal = drop:FindFirstChild("Argument") and drop.Argument.Value or "PickupDrop"
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
                    local p = GetDropPart(d)
                    if p then
                        local dist = (centerPos - p.Position).Magnitude
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

SellLeft:AddToggle("SellByName", {
    Text = "Filter by Item Name",
    Default = DEFAULT_CONFIG.SellByName,
    Tooltip = "Enables selling items matching the specific Trello name list",
})

SellLeft:AddDropdown("SellMatchMode", {
    Values = { "Match Any (Rarity OR Name)", "Match Both (Rarity AND Name)" },
    Default = DEFAULT_CONFIG.SellMatchMode,
    Multi = false,
    Text = "Filter Mode",
    Tooltip = "Choose whether both conditions or either condition applies",
})

SellLeft:AddDropdown("SellRarities", {
    Values = { "Mythic", "Legendary", "Elite", "Rare", "Uncommon", "Common" },
    Default = DEFAULT_CONFIG.SellRarities,
    Multi = true,
    Text = "Allowed Sell Rarities",
    Tooltip = "Select rarities to sell to merchant",
})

SellLeft:AddDivider()

SellLeft:AddButton({
    Text = "Sell Filtered Items Now (Clement)",
    Func = function()
        PerformSellRoutine()
    end,
    DoubleClick = false,
    Tooltip = "Immediately executes merchant selling run",
})

local SellRight = Tabs.Sell:AddRightGroupbox("Trello Item Filter")

SellRight:AddDropdown("SellItems", {
    Values = TRELLO_ITEMS,
    Default = DEFAULT_CONFIG.SellItems,
    Multi = true,
    Searchable = true,
    Text = "Specific Items to Sell",
    Tooltip = "Search and select items dumped from Trello",
})

SellRight:AddButton({
    Text = "Quick Select Common Junk Trinkets",
    Func = function()
        Options.SellItems:SetValue(COMMON_JUNK_TRINKETS)
        Library:Notify("Selected common junk trinkets!", 3)
    end,
    DoubleClick = false,
    Tooltip = "Checks Old Amulet, Old Ring, Goblet, Amulet, Ring, etc.",
})

SellRight:AddButton({
    Text = "Select Current Inventory Tools",
    Func = function()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return end
        local current = Options.SellItems.Value or {}
        local added = 0
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name ~= "Bag" then
                local sp = t:FindFirstChild("SellPrice")
                if sp and sp.Value > 0 then
                    current[t.Name] = true
                    added = added + 1
                end
            end
        end
        Options.SellItems:SetValue(current)
        Library:Notify(string.format("Selected %d inventory items!", added), 3)
    end,
    DoubleClick = false,
    Tooltip = "Scans backpack and selects all sellable items",
})

SellRight:AddButton({
    Text = "Clear Item Selection",
    Func = function()
        Options.SellItems:SetValue({})
        Library:Notify("Cleared item selection.", 2)
    end,
    DoubleClick = false,
    Tooltip = "Unchecks all items in the list",
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

local TpRight = Tabs.Teleports:AddRightGroupbox("NPCs and Locations")

local npcList = {}
local npcsFolder = Workspace:FindFirstChild("NPCs")
if npcsFolder then
    for _, n in ipairs(npcsFolder:GetChildren()) do
        if not table.find(npcList, n.Name) then
            table.insert(npcList, n.Name)
        end
    end
    table.sort(npcList)
end
if #npcList == 0 then
    npcList = { "Clement, Merchant", "Calvin, Potion Specialist", "Fraser", "Buford", "Dante" }
end

TpRight:AddDropdown("TargetNPC", {
    Values = npcList,
    Default = "Clement, Merchant",
    Multi = false,
    Searchable = true,
    Text = "World NPC",
    Tooltip = "Search and pick any NPC on map to teleport",
})

TpRight:AddButton({
    Text = "Teleport to Selected NPC",
    Func = function()
        local name = Options.TargetNPC.Value
        local npc = npcsFolder and npcsFolder:FindFirstChild(name)
        if npc then
            SafeTeleport(npc:GetPivot().Position + Vector3.new(0, 0, 4))
            Library:Notify("Teleported to " .. name .. "!", 3)
        else
            Library:Notify("NPC not found.", 3)
        end
    end,
    DoubleClick = false,
    Tooltip = "Teleport immediately to the chosen NPC",
})

TpRight:AddDivider()

TpRight:AddButton({
    Text = "Teleport to The Glade Town",
    Func = function()
        SafeTeleport(Vector3.new(238, 186, 0))
        Library:Notify("Teleported to The Glade!", 3)
    end,
    DoubleClick = false,
    Tooltip = "Teleport to Town center",
})

TpRight:AddButton({
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

local SettingsLeft = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

SettingsLeft:AddLabel("Menu Bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu Keybind" })

Library.ToggleKeybind = Options.MenuKeybind

SettingsLeft:AddButton({
    Text = "Unload Script",
    Func = function()
        _G.__VeilHubRunning = false
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
    GetFilteredDrops = GetFilteredDrops
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

task.spawn(function()
    local lastStatUpdate = 0
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
                    Library:Notify("Inventory full (150/150)! Sell items or enable Auto-Sell.", 4)
                    Toggles.AutoPickup:SetValue(false)
                end
            else
                local matches = GetFilteredDrops()
                if #matches > 0 then
                    local target = matches[1]
                    if StatusLabel then StatusLabel:SetText("Status: Collecting " .. target.Name) end
                    CollectSingleDrop(target)
                else
                    if StatusLabel then StatusLabel:SetText("Status: Waiting for Matching Drops") end
                    task.wait(0.5)
                end
            end
        end
        task.wait()
    end
end)

Library:Notify("The Veil Utility Hub Loaded Successfully! Press RightShift to Toggle.", 5)
