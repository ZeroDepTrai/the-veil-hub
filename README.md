# The Veil | Utility Hub

High-performance automation and utility hub for **The Veil** (Roblox) built on the **Obsidian UI Library**.

## 🚀 Loadstring

Run this script directly in your Roblox executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeroDepTrai/the-veil-hub/main/main.lua"))()
```

## ⚡ Features

### 1. Auto-Pickup Trinkets
- **Fast Teleport & Ground Snapping**: Snaps player 1.2 studs above ground drops, maintaining proximity $\le 10$ studs for server-side pickup approval.
- **AoE Proximity Vacuum**: Sweeps up all drops within 14 studs at once without teleporting multiple times.
- **Rarity Filter**: Select specific drop rarities to collect (`Common`, `Uncommon`, `Rare`, `Elite`, `Legendary`, `Mythic`).
- **Capacity Protection**: Monitors backpack capacity (`X/150`). Triggers Auto-Sell or pauses safely when full.
- **Blacklist Unpickable Drops**: Automatically ignores items you already own (unique gear) or obstructed items so farming never halts.
- **Return to Start**: Teleports you back to your starting spot when stopped.

### 2. Auto-Sell System
- **300 Trello Dumped Items**: Complete catalog of weapons, gear, and accessories from the official Trello datamine in a searchable dropdown.
- **Multi-Rarity Filter**: Filter sales by rarity (`Common`, `Uncommon`, `Rare`, `Elite`, `Legendary`, `Mythic`).
- **Flexible Match Modes**:
  - `Match Any (Rarity OR Name)`
  - `Match Both (Rarity AND Name)`
- **One-Click Presets**:
  - *Quick Select Common Junk Trinkets*: Selects `Old Amulet`, `Old Ring`, `Goblet`, `Amulet`, `Ring`, `Aglet`, `Ragged Cloth`, `Thin Hide`, `Rags`, `Cowl`, `Whoopie Cushion`.
  - *Select Current Inventory Tools*: Scans backpack and auto-selects all items with valid `SellPrice`.
  - *Clear Selection*: Clears selected items list.
- **Auto-Sell on Full**: Automatically teleports to Clement, sells matching items, and resumes farming.
- **Manual Sell Now Button**: Instantly triggers a sell transaction at Clement's stall.

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
