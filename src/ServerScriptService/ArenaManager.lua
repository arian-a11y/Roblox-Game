-- Arena Manager - Integrates all arena systems
-- Controls arena generation, interactive elements, and camera management

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Wait for modules to load
local ArenaGenerator = require(script.Parent:WaitForChild("ArenaGenerator"))
local InteractiveElements = require(ReplicatedStorage:WaitForChild("InteractiveElements"))

local ArenaManager = {}

-- Current arena data
local currentArena = nil
local arenaElements = {}

-- Arena configurations with interactive elements
ArenaManager.ArenaConfigs = {
    ANCIENT_TEMPLE = {
        interactiveElements = {
            {type = "DestructiblePillar", count = 6, spread = 30},
            {type = "PowerUpPlatform", powerTypes = {"STRENGTH", "HEALTH"}, count = 2},
            {type = "TeleporterPair", count = 1}
        }
    },
    
    NEON_CYBERPUNK = {
        interactiveElements = {
            {type = "PowerUpPlatform", powerTypes = {"SPEED", "COMBO"}, count = 3},
            {type = "MovingPlatform", count = 2},
            {type = "TeleporterPair", count = 2}
        }
    },
    
    VOLCANIC_CRATER = {
        interactiveElements = {
            {type = "LavaGeyser", count = 4, spread = 40},
            {type = "DestructiblePillar", count = 4, spread = 25},
            {type = "PowerUpPlatform", powerTypes = {"HEALTH"}, count = 2}
        }
    },
    
    ICE_FORTRESS = {
        interactiveElements = {
            {type = "IcePatch", count = 6, spread = 35},
            {type = "PowerUpPlatform", powerTypes = {"SPEED", "STRENGTH"}, count = 2},
            {type = "MovingPlatform", count = 1}
        }
    },
    
    FLOATING_PLATFORMS = {
        interactiveElements = {
            {type = "MovingPlatform", count = 4},
            {type = "PowerUpPlatform", powerTypes = {"COMBO", "STRENGTH"}, count = 3},
            {type = "TeleporterPair", count = 2}
        }
    }
}

-- Generate complete arena with all systems
function ArenaManager.generateCompleteArena(arenaType, position)
    position = position or Vector3.new(0, 50, 0)
    
    print("Generating complete arena: " .. arenaType)
    
    -- Clear any existing arena
    ArenaManager.clearCurrentArena()
    
    -- Generate base arena
    currentArena = ArenaGenerator.generateArena(arenaType, position)
    if not currentArena then
        warn("Failed to generate arena: " .. arenaType)
        return nil
    end
    
    -- Add interactive elements
    local config = ArenaManager.ArenaConfigs[arenaType]
    if config and config.interactiveElements then
        ArenaManager.addInteractiveElements(currentArena, config.interactiveElements)
    end
    
    -- Setup camera reveal sequence (handled client-side)
    -- Note: Camera control is handled by client-side scripts
    
    print("Complete arena generated successfully!")
    return currentArena
end

-- Add interactive elements to arena
function ArenaManager.addInteractiveElements(arena, elementConfigs)
    arenaElements = {}
    local platform = arena.platform
    local platformPos = platform.Position
    local platformSize = platform.Size
    
    for _, elementConfig in pairs(elementConfigs) do
        local elementType = elementConfig.type
        local count = elementConfig.count or 1
        local spread = elementConfig.spread or 20
        
        if elementType == "DestructiblePillar" then
            for i = 1, count do
                local angle = (i - 1) * (math.pi * 2 / count)
                local distance = spread
                local elementPos = platformPos + Vector3.new(
                    math.cos(angle) * distance,
                    platformSize.Y/2 + 12.5, -- Half pillar height
                    math.sin(angle) * distance
                )
                
                local pillar = InteractiveElements.createDestructiblePillar(elementPos, arena.arenaData.theme)
                table.insert(arenaElements, pillar)
            end
            
        elseif elementType == "PowerUpPlatform" then
            local powerTypes = elementConfig.powerTypes or {"HEALTH"}
            for i = 1, count do
                local angle = math.random() * math.pi * 2
                local distance = math.random(15, spread)
                local elementPos = platformPos + Vector3.new(
                    math.cos(angle) * distance,
                    platformSize.Y/2 + 3, -- Platform height
                    math.sin(angle) * distance
                )
                
                local powerType = powerTypes[math.random(1, #powerTypes)]
                local powerPlatform = InteractiveElements.createPowerUpPlatform(elementPos, powerType)
                table.insert(arenaElements, powerPlatform)
            end
            
        elseif elementType == "LavaGeyser" then
            for i = 1, count do
                local angle = math.random() * math.pi * 2
                local distance = math.random(10, spread)
                local elementPos = platformPos + Vector3.new(
                    math.cos(angle) * distance,
                    platformSize.Y/2 + 0.5,
                    math.sin(angle) * distance
                )
                
                local geyser = InteractiveElements.createLavaGeyser(elementPos)
                table.insert(arenaElements, geyser)
            end
            
        elseif elementType == "IcePatch" then
            for i = 1, count do
                local angle = math.random() * math.pi * 2
                local distance = math.random(8, spread)
                local elementPos = platformPos + Vector3.new(
                    math.cos(angle) * distance,
                    platformSize.Y/2 + 0.25,
                    math.sin(angle) * distance
                )
                
                local icePatch = InteractiveElements.createIcePatch(elementPos, Vector3.new(12, 0.5, 12))
                table.insert(arenaElements, icePatch)
            end
            
        elseif elementType == "MovingPlatform" then
            for i = 1, count do
                local startPos = platformPos + Vector3.new(
                    math.random(-30, 30),
                    platformSize.Y/2 + 10,
                    math.random(-30, 30)
                )
                local endPos = platformPos + Vector3.new(
                    math.random(-30, 30),
                    platformSize.Y/2 + 10,
                    math.random(-30, 30)
                )
                
                local movingPlatform = InteractiveElements.createMovingPlatform(startPos, endPos, 6)
                table.insert(arenaElements, movingPlatform)
            end
            
        elseif elementType == "TeleporterPair" then
            for i = 1, count do
                local pos1 = platformPos + Vector3.new(
                    math.random(-25, 25),
                    platformSize.Y/2 + 1,
                    math.random(-25, 25)
                )
                local pos2 = platformPos + Vector3.new(
                    math.random(-25, 25),
                    platformSize.Y/2 + 1,
                    math.random(-25, 25)
                )
                
                local teleporters = InteractiveElements.createTeleporter(pos1, pos2)
                for _, teleporter in pairs(teleporters) do
                    table.insert(arenaElements, teleporter)
                end
            end
        end
    end
    
    print("Added " .. #arenaElements .. " interactive elements to arena")
end

-- Clear current arena and all elements
function ArenaManager.clearCurrentArena()
    -- Clear interactive elements
    for _, element in pairs(arenaElements) do
        if element and element.Parent then
            element:Destroy()
        end
    end
    arenaElements = {}
    
    -- Clear base arena
    ArenaGenerator.clearArena()
    currentArena = nil
    
    print("Arena cleared")
end

-- Get random arena for quick generation
function ArenaManager.generateRandomArena(position)
    local arenaType = ArenaGenerator.getRandomArena()
    return ArenaManager.generateCompleteArena(arenaType, position)
end

-- Arena cycling for matches
function ArenaManager.cycleToNextArena()
    local arenaTypes = {}
    for arenaType, _ in pairs(ArenaManager.ArenaConfigs) do
        table.insert(arenaTypes, arenaType)
    end
    
    local nextArena = arenaTypes[math.random(1, #arenaTypes)]
    return ArenaManager.generateCompleteArena(nextArena)
end

-- Get current arena info
function ArenaManager.getCurrentArenaInfo()
    if not currentArena then
        return nil
    end
    
    return {
        name = currentArena.name,
        platform = currentArena.platform,
        spawnPoints = currentArena.spawnPoints,
        elementCount = #arenaElements,
        arenaData = currentArena.arenaData
    }
end

-- Arena-specific event handlers
function ArenaManager.onPlayerSpawned(player)
    if not currentArena or not currentArena.spawnPoints then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Find available spawn point
    local spawnPoint = currentArena.spawnPoints[1] -- Default to first spawn
    for i, spawn in pairs(currentArena.spawnPoints) do
        if spawn.Name:find(tostring(player.UserId)) or spawn.Name:find("Player" .. i) then
            spawnPoint = spawn
            break
        end
    end
    
    -- Teleport player to spawn
    if spawnPoint then
        character.HumanoidRootPart.CFrame = spawnPoint.CFrame + Vector3.new(0, 5, 0)
        print("Spawned " .. player.Name .. " at " .. spawnPoint.Name)
    end
end

-- Arena match management
function ArenaManager.startMatch(players)
    if not currentArena then
        ArenaManager.generateRandomArena()
    end
    
    -- Position players at spawn points
    for i, player in pairs(players) do
        if i <= #currentArena.spawnPoints then
            ArenaManager.onPlayerSpawned(player)
        end
    end
    
    -- Initialize camera for local player
    local localPlayer = Players.LocalPlayer
    if localPlayer.PlayerScripts:FindFirstChild("CameraController") then
        local CameraController = require(localPlayer.PlayerScripts.CameraController)
        CameraController.initialize()
        CameraController.setMode("FOLLOW")
    end
    
    print("Match started in " .. currentArena.name)
end

-- Arena preset configurations
ArenaManager.Presets = {
    TOURNAMENT = {
        arenaType = "ANCIENT_TEMPLE",
        music = "Battle",
        timeLimit = 300, -- 5 minutes
        suddenDeath = true
    },
    
    TRAINING = {
        arenaType = "FLOATING_PLATFORMS",
        music = "Menu",
        timeLimit = nil,
        suddenDeath = false
    },
    
    CASUAL = {
        arenaType = "RANDOM",
        music = "Battle",
        timeLimit = 180, -- 3 minutes
        suddenDeath = false
    }
}

function ArenaManager.loadPreset(presetName)
    local preset = ArenaManager.Presets[presetName]
    if not preset then
        warn("Unknown preset: " .. presetName)
        return
    end
    
    local arenaType = preset.arenaType
    if arenaType == "RANDOM" then
        arenaType = ArenaGenerator.getRandomArena()
    end
    
    ArenaManager.generateCompleteArena(arenaType)
    
    -- Apply preset settings
    if preset.music then
        local AudioManager = require(ReplicatedStorage:WaitForChild("AudioManager"))
        AudioManager.playMusic(preset.music, 2)
    end
    
    print("Loaded preset: " .. presetName .. " with arena: " .. arenaType)
end

-- Connect player events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Wait for character to fully load
        ArenaManager.onPlayerSpawned(player)
    end)
end)

print("Arena Manager loaded successfully!")

return ArenaManager