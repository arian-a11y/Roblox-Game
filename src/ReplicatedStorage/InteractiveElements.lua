-- Interactive Arena Elements
-- Adds destructible objects, environmental hazards, and interactive features

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InteractiveElements = {}

-- Destructible Objects
function InteractiveElements.createDestructiblePillar(position, arenaTheme)
    local pillar = Instance.new("Part")
    pillar.Name = "DestructiblePillar"
    pillar.Size = Vector3.new(8, 25, 8)
    pillar.Position = position
    pillar.Anchored = true
    pillar.Material = arenaTheme.material or Enum.Material.Sandstone
    pillar.BrickColor = BrickColor.new(arenaTheme.primaryColor)
    pillar.Parent = workspace
    
    -- Add health attribute
    pillar:SetAttribute("Health", 150)
    pillar:SetAttribute("MaxHealth", 150)
    
    -- Create hit detection
    local function onTouched(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            local currentHealth = pillar:GetAttribute("Health")
            pillar:SetAttribute("Health", currentHealth - 25)
            
            -- Visual damage effect
            local damageEffect = Instance.new("Explosion")
            damageEffect.Position = hit.Position
            damageEffect.BlastRadius = 10
            damageEffect.BlastPressure = 0
            damageEffect.Parent = workspace
            
            if pillar:GetAttribute("Health") <= 0 then
                InteractiveElements.destroyPillar(pillar)
            end
        end
    end
    
    pillar.Touched:Connect(onTouched)
    
    return pillar
end

function InteractiveElements.destroyPillar(pillar)
    -- Create destruction effect
    local explosion = Instance.new("Explosion")
    explosion.Position = pillar.Position
    explosion.BlastRadius = 30
    explosion.BlastPressure = 500000
    explosion.Parent = workspace
    
    -- Create debris
    for i = 1, 8 do
        local debris = Instance.new("Part")
        debris.Name = "PillarDebris"
        debris.Size = Vector3.new(
            math.random(2, 4),
            math.random(2, 6),
            math.random(2, 4)
        )
        debris.Position = pillar.Position + Vector3.new(
            math.random(-10, 10),
            math.random(0, 10),
            math.random(-10, 10)
        )
        debris.Material = pillar.Material
        debris.BrickColor = pillar.BrickColor
        debris.Parent = workspace
        
        -- Add physics
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-50, 50),
            math.random(20, 60),
            math.random(-50, 50)
        )
        bodyVelocity.Parent = debris
        
        -- Clean up debris after 10 seconds
        Debris:AddItem(debris, 10)
        Debris:AddItem(bodyVelocity, 2)
    end
    
    pillar:Destroy()
end

-- Environmental Hazards
function InteractiveElements.createLavaGeyser(position)
    local geyser = Instance.new("Part")
    geyser.Name = "LavaGeyser"
    geyser.Size = Vector3.new(8, 1, 8)
    geyser.Position = position
    geyser.Anchored = true
    geyser.Material = Enum.Material.Rock
    geyser.BrickColor = BrickColor.new("Really red")
    geyser.Shape = Enum.PartType.Cylinder
    geyser.Parent = workspace
    
    -- Add warning effect
    local warning = Instance.new("PointLight")
    warning.Color = Color3.fromRGB(255, 100, 0)
    warning.Brightness = 0
    warning.Range = 20
    warning.Parent = geyser
    
    -- Geyser activation cycle
    local function activateGeyser()
        -- Warning phase (2 seconds)
        local warningTween = TweenService:Create(
            warning,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Brightness = 3}
        )
        warningTween:Play()
        
        wait(4) -- Warning time
        warningTween:Cancel()
        warning.Brightness = 0
        
        -- Eruption phase
        local lavaColumn = Instance.new("Part")
        lavaColumn.Name = "LavaColumn"
        lavaColumn.Size = Vector3.new(8, 40, 8)
        lavaColumn.Position = position + Vector3.new(0, 20, 0)
        lavaColumn.Anchored = true
        lavaColumn.Material = Enum.Material.Neon
        lavaColumn.BrickColor = BrickColor.new("Neon orange")
        lavaColumn.Shape = Enum.PartType.Cylinder
        lavaColumn.Parent = workspace
        
        -- Add fire effect
        local fire = Instance.new("Fire")
        fire.Size = 15
        fire.Heat = 20
        fire.Parent = lavaColumn
        
        -- Damage players who touch lava
        local function onLavaTouch(hit)
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:TakeDamage(30)
                
                -- Add burn effect
                local burnEffect = Instance.new("Fire")
                burnEffect.Size = 5
                burnEffect.Heat = 10
                burnEffect.Parent = hit.Parent:FindFirstChild("Torso") or hit.Parent:FindFirstChild("UpperTorso")
                
                Debris:AddItem(burnEffect, 3)
            end
        end
        
        lavaColumn.Touched:Connect(onLavaTouch)
        
        -- Remove lava column after 3 seconds
        Debris:AddItem(lavaColumn, 3)
    end
    
    -- Start geyser cycle
    spawn(function()
        while geyser.Parent do
            wait(math.random(8, 15)) -- Random interval between eruptions
            activateGeyser()
        end
    end)
    
    return geyser
end

function InteractiveElements.createIcePatch(position, size)
    local icePatch = Instance.new("Part")
    icePatch.Name = "IcePatch"
    icePatch.Size = size or Vector3.new(15, 0.5, 15)
    icePatch.Position = position
    icePatch.Anchored = true
    icePatch.Material = Enum.Material.Ice
    icePatch.BrickColor = BrickColor.new("Pastel Blue")
    icePatch.Transparency = 0.3
    icePatch.Parent = workspace
    
    -- Add slippery effect
    local function onIceTouch(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid and humanoid.Parent:FindFirstChild("HumanoidRootPart") then
            local rootPart = humanoid.Parent.HumanoidRootPart
            
            -- Apply sliding force
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
            bodyVelocity.Velocity = rootPart.AssemblyLinearVelocity * 2
            bodyVelocity.Parent = rootPart
            
            -- Slow down after 2 seconds
            Debris:AddItem(bodyVelocity, 2)
            
            -- Add ice particles
            local attachment = Instance.new("Attachment")
            attachment.Parent = rootPart
            
            local particles = Instance.new("ParticleEmitter")
            particles.Parent = attachment
            particles.Color = ColorSequence.new(Color3.fromRGB(200, 230, 255))
            particles.Size = NumberSequence.new(1)
            particles.Lifetime = NumberRange.new(0.5, 1)
            particles.Rate = 50
            particles.Speed = NumberRange.new(5, 10)
            particles.SpreadAngle = Vector2.new(45, 45)
            particles.Parent = attachment
            
            particles:Emit(20)
            Debris:AddItem(attachment, 2)
        end
    end
    
    icePatch.Touched:Connect(onIceTouch)
    
    return icePatch
end

-- Power-Up Platforms
function InteractiveElements.createPowerUpPlatform(position, powerType)
    local platform = Instance.new("Part")
    platform.Name = "PowerUpPlatform"
    platform.Size = Vector3.new(6, 2, 6)
    platform.Position = position
    platform.Anchored = true
    platform.Material = Enum.Material.ForceField
    platform.Shape = Enum.PartType.Cylinder
    platform.Parent = workspace
    
    -- Set platform color based on power type
    local powerColors = {
        STRENGTH = Color3.fromRGB(255, 100, 100),
        SPEED = Color3.fromRGB(100, 255, 100),
        HEALTH = Color3.fromRGB(100, 100, 255),
        COMBO = Color3.fromRGB(255, 215, 0)
    }
    
    platform.BrickColor = BrickColor.new(powerColors[powerType] or Color3.fromRGB(255, 255, 255))
    
    -- Add glowing effect
    local light = Instance.new("PointLight")
    light.Color = powerColors[powerType] or Color3.fromRGB(255, 255, 255)
    light.Brightness = 2
    light.Range = 15
    light.Parent = platform
    
    -- Add floating animation
    local originalPosition = position
    local floatTween = TweenService:Create(
        platform,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = originalPosition + Vector3.new(0, 3, 0)}
    )
    floatTween:Play()
    
    -- Add power-up collection
    local function onPowerUpTouch(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            -- Apply power-up effect
            InteractiveElements.applyPowerUp(humanoid.Parent, powerType)
            
            -- Remove platform temporarily
            platform.Transparency = 1
            platform.CanCollide = false
            light.Enabled = false
            
            -- Respawn after 30 seconds
            wait(30)
            platform.Transparency = 0
            platform.CanCollide = true
            light.Enabled = true
        end
    end
    
    platform.Touched:Connect(onPowerUpTouch)
    
    return platform
end

function InteractiveElements.applyPowerUp(character, powerType)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Create power-up effect
    local effect = Instance.new("Explosion")
    effect.Position = character:FindFirstChild("HumanoidRootPart").Position
    effect.BlastRadius = 20
    effect.BlastPressure = 0
    effect.Visible = false
    effect.Parent = workspace
    
    if powerType == "STRENGTH" then
        -- Increase damage for 20 seconds
        character:SetAttribute("StrengthBoost", true)
        wait(20)
        character:SetAttribute("StrengthBoost", false)
        
    elseif powerType == "SPEED" then
        -- Increase speed for 15 seconds
        humanoid.WalkSpeed = humanoid.WalkSpeed * 1.5
        wait(15)
        humanoid.WalkSpeed = humanoid.WalkSpeed / 1.5
        
    elseif powerType == "HEALTH" then
        -- Restore health
        humanoid.Health = math.min(humanoid.Health + 50, humanoid.MaxHealth)
        
    elseif powerType == "COMBO" then
        -- Reset combo cooldowns
        character:SetAttribute("ComboReset", true)
        wait(1)
        character:SetAttribute("ComboReset", false)
    end
end

-- Moving Platforms
function InteractiveElements.createMovingPlatform(startPos, endPos, moveTime)
    local platform = Instance.new("Part")
    platform.Name = "MovingPlatform"
    platform.Size = Vector3.new(12, 2, 12)
    platform.Position = startPos
    platform.Anchored = true
    platform.Material = Enum.Material.Metal
    platform.BrickColor = BrickColor.new("Dark stone grey")
    platform.Parent = workspace
    
    -- Add platform details
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(100, 255, 100)
    light.Brightness = 1
    light.Range = 10
    light.Parent = platform
    
    -- Moving animation
    local function movePlatform()
        local moveToEnd = TweenService:Create(
            platform,
            TweenInfo.new(moveTime, Enum.EasingStyle.Linear),
            {Position = endPos}
        )
        
        local moveToStart = TweenService:Create(
            platform,
            TweenInfo.new(moveTime, Enum.EasingStyle.Linear),
            {Position = startPos}
        )
        
        moveToEnd:Play()
        moveToEnd.Completed:Connect(function()
            wait(2) -- Pause at end
            moveToStart:Play()
            moveToStart.Completed:Connect(function()
                wait(2) -- Pause at start
                movePlatform() -- Restart cycle
            end)
        end)
    end
    
    movePlatform()
    
    return platform
end

-- Teleporter Pads
function InteractiveElements.createTeleporter(position1, position2)
    local function createPad(position, targetPosition)
        local pad = Instance.new("Part")
        pad.Name = "TeleporterPad"
        pad.Size = Vector3.new(8, 1, 8)
        pad.Position = position
        pad.Anchored = true
        pad.Material = Enum.Material.Neon
        pad.BrickColor = BrickColor.new("Bright violet")
        pad.Shape = Enum.PartType.Cylinder
        pad.Parent = workspace
        
        -- Add teleporter effect
        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 0, 255)
        light.Brightness = 3
        light.Range = 20
        light.Parent = pad
        
        -- Pulsing animation
        local pulseTween = TweenService:Create(
            light,
            TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Brightness = 1}
        )
        pulseTween:Play()
        
        -- Teleportation function
        local function onTeleporterTouch(hit)
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid and humanoid.Parent:FindFirstChild("HumanoidRootPart") then
                local rootPart = humanoid.Parent.HumanoidRootPart
                
                -- Teleport effect
                local teleportEffect = Instance.new("Explosion")
                teleportEffect.Position = rootPart.Position
                teleportEffect.BlastRadius = 15
                teleportEffect.BlastPressure = 0
                teleportEffect.Visible = false
                teleportEffect.Parent = workspace
                
                -- Teleport player
                rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
                
                -- Arrival effect
                local arrivalEffect = Instance.new("Explosion")
                arrivalEffect.Position = rootPart.Position
                arrivalEffect.BlastRadius = 15
                arrivalEffect.BlastPressure = 0
                arrivalEffect.Visible = false
                arrivalEffect.Parent = workspace
            end
        end
        
        pad.Touched:Connect(onTeleporterTouch)
        
        return pad
    end
    
    local pad1 = createPad(position1, position2)
    local pad2 = createPad(position2, position1)
    
    return {pad1, pad2}
end

return InteractiveElements