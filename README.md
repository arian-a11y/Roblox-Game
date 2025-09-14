# Roblox Fighting Game

A competitive fighting game built in Roblox with advanced combat mechanics, player progression, and match systems.

## Features

- **Combat System**: Real-time fighting with punches, kicks, blocks, and combos
- **Health Management**: Dynamic health bars and damage calculation
- **Player Controls**: Smooth movement and responsive input handling
- **Match System**: Round-based gameplay with win conditions
- **User Interface**: Clean HUD with health bars, combo counters, and game state displays

## Project Structure

```
├── src/
│   ├── ServerScriptService/
│   │   ├── CombatSystem.lua          # Server-side combat logic
│   │   ├── MatchManager.lua          # Game state and match management
│   │   └── PlayerManager.lua         # Player data and spawning
│   ├── StarterPlayerScripts/
│   │   ├── CombatInput.lua           # Client input handling
│   │   ├── UIManager.lua             # User interface management
│   │   └── CameraController.lua      # Camera system for fighting
│   └── ReplicatedStorage/
│       ├── CombatUtils.lua           # Shared combat utilities
│       ├── GameEvents.lua            # RemoteEvents for client-server communication
│       └── PlayerData.lua            # Shared player data structures
├── gui/                              # UI elements and designs
├── models/                           # 3D models and parts
├── sounds/                           # Audio files and sound effects
└── default.project.json              # Rojo project configuration
```

## Getting Started

### Prerequisites

1. **Roblox Studio** - Download from [roblox.com/create](https://www.roblox.com/create)
2. **VS Code** with extensions:
   - Rojo (evaera.vscode-rojo)
   - Luau Language Server (johnnymorganz.luau-lsp)
   - Roblox LSP (nightrains.robloxlsp)
3. **Rojo** - Install from [rojo.space](https://rojo.space/)

### Setup Instructions

1. **Clone/Open the project** in VS Code
2. **Install Rojo** if not already installed
3. **Start Rojo server**:
   ```bash
   rojo serve
   ```
4. **Open Roblox Studio** and connect to the Rojo server
5. **Start developing** - changes in VS Code will sync to Studio

### Development Workflow

1. Write code in VS Code using the Luau language
2. Test in Roblox Studio with live sync via Rojo
3. Use the built-in testing tools for combat mechanics
4. Publish to Roblox when ready

## Combat System Overview

### Basic Controls
- **Mouse1**: Light attack
- **Mouse2**: Heavy attack  
- **F**: Block
- **Q**: Dodge
- **E**: Special move
- **WASD**: Movement
- **Space**: Jump

### Combat Mechanics
- **Combo System**: Chain attacks for increased damage
- **Block/Parry**: Defensive mechanics with timing windows
- **Health System**: 100 HP with regeneration outside combat
- **Stamina**: Limited resource for special moves and dodging

### Game Modes
- **1v1 Duels**: Classic fighting matches
- **Tournament**: Bracket-style competitions
- **Training**: Practice mode with dummies
- **Spectator**: Watch ongoing matches

## Scripts Overview

### Server Scripts
- **CombatSystem.lua**: Handles damage calculation, hit detection, and combat validation
- **MatchManager.lua**: Manages game states, rounds, and win conditions  
- **PlayerManager.lua**: Player spawning, data management, and team assignment

### Client Scripts
- **CombatInput.lua**: Captures and processes player input for combat
- **UIManager.lua**: Updates health bars, combo counters, and game UI
- **CameraController.lua**: Manages camera positioning and movement for optimal fighting view

### Shared Scripts
- **CombatUtils.lua**: Common functions for damage calculation and combat logic
- **GameEvents.lua**: RemoteEvents for client-server communication
- **PlayerData.lua**: Data structures for player stats and game state

## Contributing

1. Follow Roblox scripting best practices
2. Test all changes thoroughly in Studio
3. Comment your code clearly
4. Use proper ModuleScript structure for reusable code

## License

This project is for educational and development purposes.

---

**Happy Fighting!** 🥊