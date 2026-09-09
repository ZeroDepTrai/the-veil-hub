# The Veil | Utility Hub

High-performance automation and utility hub for **The Veil** (Roblox) built on the **Obsidian UI Library**.

## 🚀 Loadstring

Run this script directly in your Roblox executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeroDepTrai/the-veil-hub/main/main.lua?" .. tick()))()
```

## ⚡ Features

### 1. Auto-Pickup Trinkets
- **Fast Teleport & Ground Snapping**: Snaps player 1.2 studs above ground drops, maintaining proximity $\le 10$ studs for server-side pickup approval.
- **AoE Proximity Vacuum**: Sweeps up all drops within 14 studs at once without teleporting multiple times.
- **Rarity Filter**: Select specific drop rarities to collect (`Common`, `Uncommon`, `Rare`, `Elite`, `Legendary`, `Mythic`).
- **Capacity Protection**: Monitors backpack capacity (`X/150`). Triggers Auto-Sell or pauses safely when full.
- **Blacklist Unpickable Drops**: Automatically ignores items you already own (unique gear) or obstructed items so farming never halts.
- **Built-in Sanity Recovery**: Automatically monitors sanity. If sanity drops below 20 (< 20), immediately teleports to spawn/The Glade town to recover sanity back to 90+, preventing death at 0 sanity. Fully built-in with zero configuration required.
- **Return to Start**: Teleports you back to your starting spot when stopped.

### 2. Auto-Sell & Item Blacklist (Protection List)
- **Item Blacklist ("Do Not Sell")**: Items checked in the blacklist dropdown will **NEVER be sold**, preserving your weapons, potions, gems, and gear even when their rarity matches the sell filter.
- **300 Trello Catalog Items**: Complete searchable catalog of weapons, gear, and accessories from the official Trello datamine.
- **Multi-Rarity Sell Filter**: Choose which rarities to sell (`Common`, `Uncommon`, `Rare`, `Elite`, `Legendary`, `Mythic`).
- **One-Click Protection Presets**:
  - *Protect Current Inventory Tools*: Scans your backpack and adds all current gear/tools to the blacklist so they are never sold.
  - *Protect All Rare / Elite / Legendary*: Instantly adds all high-tier weapons and items from the Trello catalog to the blacklist.
  - *Clear Blacklist*: Resets all protected items.
- **Auto-Sell on Full**: Automatically teleports to Merchant Clement when inventory reaches capacity ($\ge 148/150$), sells eligible items, and returns to farm.
- **Manual Sell Now Button**: Instantly triggers a sell run at Clement's stall on demand.

### 3. World & Quest Teleports
- **Active Quest Waypoint**: Teleports directly to the active objective marker (`QuestWaypointAnchor`).
- **Nearest Quest NPC**: Teleports to closest NPC quest marker (`QuestMarkers`).
- **All World NPCs Dropdown**: Search and teleport to any of the 80 NPCs across the world (`Clement, Merchant`, `Calvin, Potion Specialist`, `Fraser`, `Buford`, `Dante`, etc.).
- **The Glade Town**: Instant teleport to Town center.
- **Sky Safe Altitude**: Emergency escape 200 studs into the air.

### 4. UI Settings
- Toggle UI Visibility: **`RightShift`** (customizable in UI Settings).
- Obsidian ThemeManager & SaveManager config saving.
- Double-click Unload button.

## ⚙️ Configuration

Settings can be changed live through the Obsidian GUI or configured at the top of `main.lua` before execution.
