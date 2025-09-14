-- Arena Generator for Fighting Game
-- Creates dynamic fighting arenas with different themes and layouts

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local ArenaGenerator = {}

-- Arena themes and configurations
ArenaGenerator.Arenas = {
    ANCIENT_TEMPLE = {
        name = "Ancient Temple",
        size = Vector3.new(100, 10, 100),
        spawnHeight = 15,
        theme = {
            primaryColor = Color3.fromRGB(139, 119, 101),
            accentColor = Color3.fromRGB(205, 175, 149),
            material = Enum.Material.Sandstone
        },
        lighting = {
            ambient = Color3.fromRGB(100, 80, 60),
            brightness = 2,
            clockTime = 14,
            fogEnd = 200,
            fogColor = Color3.fromRGB(255, 200, 150)
        },
        decorations = {
            "pillars", "torches", "ancient_runes", "stone_steps"
        }
    },
    
    NEON_CYBERPUNK = {
        name = "Neon Arena",
        size = Vector3.new(80, 8, 80),
        spawnHeight = 12,
        theme = {
            primaryColor = Color3.fromRGB(20, 20, 30),
            accentColor = Color3.fromRGB(0, 255, 255),
            material = Enum.Material.Neon
        },
        lighting = {
            ambient = Color3.fromRGB(50, 50, 100),
            brightness = 1,
            clockTime = 0,
            fogEnd = 100,
            fogColor = Color3.fromRGB(100, 0, 200)
        },
        decorations = {
            "neon_strips", "holograms", "cyber_pillars", "data_streams"
        }
    },
    
    VOLCANIC_CRATER = {
        name = "Volcanic Crater",
        size = Vector3.new(120, 15, 120),
        spawnHeight = 20,
        theme = {
            primaryColor = Color3.fromRGB(60, 30, 30),
            accentColor = Color3.fromRGB(255, 100, 0),
            material = Enum.Material.Rock
        },
        lighting = {
            ambient = Color3.fromRGB(150, 50, 0),
            brightness = 3,
            clockTime = 18,
            fogEnd = 150,
            fogColor = Color3.fromRGB(255, 100, 50)
        },
        decorations = {
            "lava_pools", "rock_formations", "steam_vents", "ember_effects"
        }
    },
    
    ICE_FORTRESS = {
        name = "Ice Fortress",
        size = Vector3.new(90, 12, 90),
        spawnHeight = 16,
        theme = {
            primaryColor = Color3.fromRGB(200, 230, 255),
            accentColor = Color3.fromRGB(100, 150, 255),
            material = Enum.Material.Ice
        },
        lighting = {
            ambient = Color3.fromRGB(150, 180, 255),
            brightness = 1.5,
            clockTime = 12,
            fogEnd = 300,
            fogColor = Color3.fromRGB(200, 220, 255)
        },
        decorations = {
            "ice_spikes", "frozen_waterfalls", "crystal_formations", "snowfall"
        }
    },
    
    FLOATING_PLATFORMS = {
        name = "Sky Temple",
        size = Vector3.new(70, 5, 70),
        spawnHeight = 500,
        theme = {
            primaryColor = Color3.fromRGB(255, 255, 255),
            accentColor = Color3.fromRGB(255, 215, 0),
            material = Enum.Material.Marble
        },
        lighting = {
            ambient = Color3.fromRGB(200, 200, 255),
            brightness = 2,
            clockTime = 10,
            fogEnd = 1000,
            fogColor = Color3.fromRGB(135, 206, 235)
        },
        decorations = {
            "floating_rocks", "cloud_effects", "golden_trim", "wind_effects"
        }
    }
}

-- Generate main arena platform
function ArenaGenerator.createArenaPlatform(arenaData, position)
    local platform = Instance.new("Part")
    platform.Name = "ArenaPlatform"
    platform.Size = arenaData.size
    platform.Position = position
    platform.Anchored = true
    platform.Material = arenaData.theme.material
    platform.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    
    -- Add platform details
    local decal = Instance.new("Decal")
    decal.Texture = "rbxasset://textures/face.png" -- Replace with arena-specific texture
    decal.Face = Enum.NormalId.Top
    decal.Parent = platform
    
    return platform
end

-- Create boundary walls
function ArenaGenerator.createBoundaryWalls(platform, arenaData)
    local size = arenaData.size
    local position = platform.Position
    local wallHeight = 20
    local wallThickness = 2
    
    -- Create 4 walls
    local walls = {}
    
    -- North wall
    local northWall = Instance.new("Part")
    northWall.Name = "NorthWall"
    northWall.Size = Vector3.new(size.X + wallThickness * 2, wallHeight, wallThickness)
    northWall.Position = position + Vector3.new(0, wallHeight/2 + size.Y/2, size.Z/2 + wallThickness/2)
    northWall.Anchored = true
    northWall.Material = arenaData.theme.material
    northWall.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
    northWall.Parent = workspace
    table.insert(walls, northWall)
    
    -- South wall
    local southWall = northWall:Clone()
    southWall.Name = "SouthWall"
    southWall.Position = position + Vector3.new(0, wallHeight/2 + size.Y/2, -size.Z/2 - wallThickness/2)
    southWall.Parent = workspace
    table.insert(walls, southWall)
    
    -- East wall
    local eastWall = Instance.new("Part")
    eastWall.Name = "EastWall"
    eastWall.Size = Vector3.new(wallThickness, wallHeight, size.Z)
    eastWall.Position = position + Vector3.new(size.X/2 + wallThickness/2, wallHeight/2 + size.Y/2, 0)
    eastWall.Anchored = true
    eastWall.Material = arenaData.theme.material
    eastWall.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
    eastWall.Parent = workspace
    table.insert(walls, eastWall)
    
    -- West wall
    local westWall = eastWall:Clone()
    westWall.Name = "WestWall"
    westWall.Position = position + Vector3.new(-size.X/2 - wallThickness/2, wallHeight/2 + size.Y/2, 0)
    westWall.Parent = workspace
    table.insert(walls, westWall)
    
    return walls
end

-- Create arena decorations based on theme
function ArenaGenerator.createDecorations(platform, arenaData)
    local decorations = {}
    local position = platform.Position
    local size = arenaData.size
    
    for _, decorationType in pairs(arenaData.decorations) do
        if decorationType == "pillars" then
            -- Create temple pillars
            for i = 1, 8 do
                local angle = (i - 1) * (math.pi * 2 / 8)
                local radius = math.min(size.X, size.Z) * 0.3
                local pillarPos = position + Vector3.new(
                    math.cos(angle) * radius,
                    size.Y/2 + 15,
                    math.sin(angle) * radius
                )
                
                local pillar = Instance.new("Part")
                pillar.Name = "Pillar" .. i
                pillar.Size = Vector3.new(6, 30, 6)
                pillar.Position = pillarPos
                pillar.Anchored = true
                pillar.Material = Enum.Material.Sandstone
                pillar.BrickColor = BrickColor.new(arenaData.theme.accentColor)
                pillar.Shape = Enum.PartType.Cylinder
                pillar.Parent = workspace
                table.insert(decorations, pillar)
            end
            
        elseif decorationType == "neon_strips" then
            -- Create neon lighting strips
            for i = 1, 4 do
                local stripLength = size.X * 0.8
                local strip = Instance.new("Part")
                strip.Name = "NeonStrip" .. i
                strip.Size = Vector3.new(stripLength, 1, 2)
                strip.Position = position + Vector3.new(0, size.Y/2 + 0.5, (i-2.5) * 10)
                strip.Anchored = true
                strip.Material = Enum.Material.Neon
                strip.BrickColor = BrickColor.new(arenaData.theme.accentColor)
                strip.Parent = workspace
                
                -- Add pulsing effect
                local light = Instance.new("PointLight")
                light.Color = arenaData.theme.accentColor
                light.Brightness = 2
                light.Range = 20
                light.Parent = strip
                
                table.insert(decorations, strip)
            end
            
        elseif decorationType == "lava_pools" then
            -- Create lava pools
            for i = 1, 6 do
                local poolRadius = math.random(8, 15)
                local angle = math.random() * math.pi * 2
                local distance = math.random(15, size.X/3)
                local poolPos = position + Vector3.new(
                    math.cos(angle) * distance,
                    size.Y/2 + 0.5,
                    math.sin(angle) * distance
                )
                
                local pool = Instance.new("Part")
                pool.Name = "LavaPool" .. i
                pool.Size = Vector3.new(poolRadius, 1, poolRadius)
                pool.Position = poolPos
                pool.Anchored = true
                pool.Material = Enum.Material.Neon
                pool.BrickColor = BrickColor.new(Color3.fromRGB(255, 100, 0))
                pool.Shape = Enum.PartType.Cylinder
                pool.Parent = workspace
                
                -- Add heat effect
                local fire = Instance.new("Fire")
                fire.Size = poolRadius / 2
                fire.Heat = 15
                fire.Parent = pool
                
                table.insert(decorations, pool)
            end
            
        elseif decorationType == "ice_spikes" then
            -- Create ice spike formations
            for i = 1, 12 do
                local spikeHeight = math.random(10, 25)
                local angle = math.random() * math.pi * 2
                local distance = math.random(20, size.X/2.5)
                local spikePos = position + Vector3.new(
                    math.cos(angle) * distance,
                    size.Y/2 + spikeHeight/2,
                    math.sin(angle) * distance
                )
                
                local spike = Instance.new("Part")
                spike.Name = "IceSpike" .. i
                spike.Size = Vector3.new(3, spikeHeight, 3)
                spike.Position = spikePos
                spike.Anchored = true
                spike.Material = Enum.Material.Ice
                spike.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
                spike.Shape = Enum.PartType.Block
                spike.Parent = workspace
                
                -- Make spikes slightly transparent
                spike.Transparency = 0.3
                
                table.insert(decorations, spike)
            end
            
        elseif decorationType == "floating_rocks" then
            -- Create floating platforms around main arena
            for i = 1, 8 do
                local rockSize = Vector3.new(
                    math.random(10, 20),
                    math.random(3, 8),
                    math.random(10, 20)
                )
                local angle = (i - 1) * (math.pi * 2 / 8)
                local distance = size.X * 0.8
                local height = math.random(-10, 10)
                local rockPos = position + Vector3.new(
                    math.cos(angle) * distance,
                    height,
                    math.sin(angle) * distance
                )
                
                local rock = Instance.new("Part")
                rock.Name = "FloatingRock" .. i
                rock.Size = rockSize
                rock.Position = rockPos
                rock.Anchored = true
                rock.Material = Enum.Material.Rock
                rock.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
                rock.Parent = workspace
                
                -- Add floating animation
                local floatTween = TweenService:Create(
                    rock,
                    TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {Position = rockPos + Vector3.new(0, 5, 0)}
                )
                floatTween:Play()
                
                table.insert(decorations, rock)
            end
        end
    end
    
    return decorations
end

-- Apply lighting settings
function ArenaGenerator.setupLighting(arenaData)
    local lighting = arenaData.lighting
    
    Lighting.Ambient = lighting.ambient
    Lighting.Brightness = lighting.brightness
    Lighting.ClockTime = lighting.clockTime
    Lighting.FogEnd = lighting.fogEnd
    Lighting.FogColor = lighting.fogColor
    
    -- Add atmospheric effects
    if not Lighting:FindFirstChild("Atmosphere") then
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Density = 0.3
        atmosphere.Offset = 0.25
        atmosphere.Color = lighting.fogColor
        atmosphere.Decay = lighting.fogColor
        atmosphere.Glare = 0.2
        atmosphere.Haze = 1.3
        atmosphere.Parent = Lighting
    end
end

-- Create spawn points
function ArenaGenerator.createSpawnPoints(platform, arenaData)
    local spawnPoints = {}
    local position = platform.Position
    local spawnHeight = position.Y + arenaData.size.Y/2 + arenaData.spawnHeight
    
    -- Player 1 spawn (left side)
    local spawn1 = Instance.new("SpawnLocation")
    spawn1.Name = "Player1Spawn"
    spawn1.Size = Vector3.new(6, 1, 6)
    spawn1.Position = Vector3.new(position.X - 25, spawnHeight, position.Z)
    spawn1.Anchored = true
    spawn1.BrickColor = BrickColor.new("Bright blue")
    spawn1.Material = Enum.Material.ForceField
    spawn1.TopSurface = Enum.SurfaceType.Smooth
    spawn1.Parent = workspace
    table.insert(spawnPoints, spawn1)
    
    -- Player 2 spawn (right side)
    local spawn2 = spawn1:Clone()
    spawn2.Name = "Player2Spawn"
    spawn2.Position = Vector3.new(position.X + 25, spawnHeight, position.Z)
    spawn2.BrickColor = BrickColor.new("Bright red")
    spawn2.Parent = workspace
    table.insert(spawnPoints, spawn2)
    
    return spawnPoints
end

-- Generate complete arena
function ArenaGenerator.generateArena(arenaType, centerPosition)
    local arenaData = ArenaGenerator.Arenas[arenaType]
    if not arenaData then
        warn("Unknown arena type: " .. tostring(arenaType))
        return nil
    end
    
    centerPosition = centerPosition or Vector3.new(0, 50, 0)
    
    print("Generating " .. arenaData.name .. " arena...")
    
    -- Clear existing arena
    ArenaGenerator.clearArena()
    
    -- Create main platform
    local platform = ArenaGenerator.createArenaPlatform(arenaData, centerPosition)
    
    -- Create boundary walls
    local walls = ArenaGenerator.createBoundaryWalls(platform, arenaData)
    
    -- Add decorations
    local decorations = ArenaGenerator.createDecorations(platform, arenaData)
    
    -- Setup lighting
    ArenaGenerator.setupLighting(arenaData)
    
    -- Create spawn points
    local spawnPoints = ArenaGenerator.createSpawnPoints(platform, arenaData)
    
    -- Create arena container
    local arena = {
        name = arenaData.name,
        platform = platform,
        walls = walls,
        decorations = decorations,
        spawnPoints = spawnPoints,
        arenaData = arenaData
    }
    
    print(arenaData.name .. " arena generated successfully!")
    return arena
end

-- Clear existing arena
function ArenaGenerator.clearArena()
    -- Remove old arena parts
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("Arena") or obj.Name:find("Wall") or 
           obj.Name:find("Pillar") or obj.Name:find("NeonStrip") or 
           obj.Name:find("LavaPool") or obj.Name:find("IceSpike") or 
           obj.Name:find("FloatingRock") or obj.Name:find("Spawn") then
            obj:Destroy()
        end
    end
end

-- Quick arena selection
function ArenaGenerator.getRandomArena()
    local arenaTypes = {}
    for arenaType, _ in pairs(ArenaGenerator.Arenas) do
        table.insert(arenaTypes, arenaType)
    end
    return arenaTypes[math.random(1, #arenaTypes)]
end

return ArenaGenerator