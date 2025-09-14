-- Game Initializer - Automatically sets up the fighting game when server starts
-- This script runs when the server starts and creates the initial arena

local Players = game:GetService("Players")

-- Wait for all modules to load with safety checks
local ArenaManagerScript = script.Parent:FindFirstChild("ArenaManager")
if not ArenaManagerScript then
    error("ArenaManager script not found in ServerScriptService!")
end
local ArenaManager = require(ArenaManagerScript)

local CombatSystemScript = script.Parent:FindFirstChild("CombatSystem")
if CombatSystemScript then
    require(CombatSystemScript) -- Just load it, don't need to store
end

print("=== ROBLOX FIGHTING GAME INITIALIZING ===")

-- Initialize the game
local function initializeGame()
    print("Setting up initial arena...")
    
    -- Generate a random arena to start with
    local initialArena = ArenaManager.generateRandomArena(Vector3.new(0, 50, 0))
    
    if initialArena then
        print("✓ Arena generated successfully: " .. initialArena.name)
        
        -- Set up arena for any players who join
        local function onPlayerAdded(player)
            print("Player joined: " .. player.Name)
            
            -- Wait for character to spawn
            player.CharacterAdded:Connect(function(character)
                wait(2) -- Give time for character to fully load
                
                -- Teleport player to arena spawn point
                ArenaManager.onPlayerSpawned(player)
                
                print("✓ " .. player.Name .. " spawned in arena")
            end)
        end
        
        -- Connect to future players
        Players.PlayerAdded:Connect(onPlayerAdded)
        
        -- Handle players already in game
        for _, player in pairs(Players:GetPlayers()) do
            onPlayerAdded(player)
        end
        
        print("✓ Player spawning system initialized")
        
    else
        warn("✗ Failed to generate initial arena!")
    end
end

-- Start game after short delay to ensure all scripts are loaded
wait(2)
initializeGame()

print("=== GAME INITIALIZATION COMPLETE ===")
print("Players can now join and fight!")

-- Optional: Arena cycling every 5 minutes
spawn(function()
    while true do
        wait(300) -- 5 minutes
        
        -- Only cycle if there are players
        if #Players:GetPlayers() > 0 then
            print("Cycling to new arena...")
            ArenaManager.cycleToNextArena()
        end
    end
end)