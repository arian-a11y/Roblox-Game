-- Visual Effects Manager
-- Handles particle effects, screen shake, and combat visuals

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CombatUtils = require(ReplicatedStorage:WaitForChild("CombatUtils"))

local EffectManager = {}

-- Create particle effect at position
function EffectManager.createHitEffect(position, effectType, comboCount)
    local effectData = CombatUtils.EffectData[effectType]
    if not effectData then return end
    
    -- Create particle emitter
    local part = Instance.new("Part")
    part.Name = "HitEffect"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = part
    
    -- Create particles
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Color = ColorSequence.new(effectData.color)
    particles.Size = NumberSequence.new(effectData.size)
    particles.Lifetime = NumberRange.new(0.3, effectData.duration)
    particles.Rate = effectData.particleCount * 10
    particles.Speed = NumberRange.new(5, 15)
    particles.SpreadAngle = Vector2.new(45, 45)
    
    -- Enhanced effects for combos
    if comboCount and comboCount >= 3 then
        particles.Size = NumberSequence.new(effectData.size * (1 + comboCount * 0.1))
        particles.Speed = NumberRange.new(8, 20)
        particles.Color = ColorSequence.new(CombatUtils.EffectData.ComboHit.color)
    end
    
    -- Emit particles
    particles:Emit(effectData.particleCount)
    
    -- Clean up after effect
    game:GetService("Debris"):AddItem(part, effectData.duration + 1)
end

-- Create special move effect
function EffectManager.createSpecialEffect(position, moveType)
    local specialData = CombatUtils.EffectData.SpecialMove[moveType]
    if not specialData then return end
    
    -- Create main effect part
    local part = Instance.new("Part")
    part.Name = moveType .. "Effect"
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.ForceField
    part.BrickColor = BrickColor.new(specialData.color)
    part.Size = Vector3.new(specialData.size, specialData.size, specialData.size)
    part.Position = position
    part.Shape = Enum.PartType.Ball
    part.Parent = workspace
    
    -- Create glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Parent = part
    pointLight.Color = specialData.color
    pointLight.Brightness = 2
    pointLight.Range = specialData.size * 2
    
    -- Create particles
    local attachment = Instance.new("Attachment")
    attachment.Parent = part
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Color = ColorSequence.new(specialData.color)
    particles.Size = NumberSequence.new(specialData.size * 0.5)
    particles.Lifetime = NumberRange.new(0.5, specialData.duration)
    particles.Rate = specialData.particleCount * 5
    particles.Speed = NumberRange.new(10, 25)
    particles.SpreadAngle = Vector2.new(90, 90)
    
    -- Animate the effect
    local expandTween = TweenService:Create(
        part,
        TweenInfo.new(specialData.duration * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(specialData.size * 2, specialData.size * 2, specialData.size * 2)}
    )
    
    local fadeTween = TweenService:Create(
        part,
        TweenInfo.new(specialData.duration * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}
    )
    
    -- Play animation sequence
    expandTween:Play()
    particles:Emit(specialData.particleCount)
    
    expandTween.Completed:Connect(function()
        fadeTween:Play()
    end)
    
    -- Clean up
    game:GetService("Debris"):AddItem(part, specialData.duration + 1)
end

-- Screen shake effect
function EffectManager.createScreenShake(player, intensity, duration)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Create camera shake by manipulating humanoid camera offset
    local originalOffset = humanoid.CameraOffset
    local shakeAmount = intensity or 2
    local shakeDuration = duration or 0.5
    
    local startTime = tick()
    local connection
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= shakeDuration then
            humanoid.CameraOffset = originalOffset
            connection:Disconnect()
            return
        end
        
        local progress = elapsed / shakeDuration
        local currentIntensity = shakeAmount * (1 - progress)
        
        local randomX = (math.random() - 0.5) * currentIntensity
        local randomY = (math.random() - 0.5) * currentIntensity
        local randomZ = (math.random() - 0.5) * currentIntensity
        
        humanoid.CameraOffset = originalOffset + Vector3.new(randomX, randomY, randomZ)
    end)
end

-- Damage number display
function EffectManager.createDamageNumber(position, damage, damageType)
    local part = Instance.new("Part")
    part.Name = "DamageNumber"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(4, 2, 0.1)
    part.Position = position + Vector3.new(0, 5, 0)
    part.Parent = workspace
    
    local gui = Instance.new("BillboardGui")
    gui.Parent = part
    gui.Size = UDim2.new(2, 0, 1, 0)
    gui.StudsOffset = Vector3.new(0, 2, 0)
    
    local label = Instance.new("TextLabel")
    label.Parent = gui
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "-" .. damage
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    
    -- Color based on damage type
    if damageType == "special" then
        label.TextColor3 = Color3.fromRGB(255, 215, 0)  -- Gold
    elseif damageType == "heavy" then
        label.TextColor3 = Color3.fromRGB(255, 100, 100)  -- Red
    else
        label.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White
    end
    
    -- Animate damage number
    local riseTween = TweenService:Create(
        gui,
        TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {StudsOffset = Vector3.new(0, 8, 0)}
    )
    
    local fadeTween = TweenService:Create(
        label,
        TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {TextTransparency = 1}
    )
    
    riseTween:Play()
    fadeTween:Play()
    
    -- Clean up
    game:GetService("Debris"):AddItem(part, 1.5)
end

-- Combo rank display
function EffectManager.createComboDisplay(player, comboCount, comboRank)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local position = character.HumanoidRootPart.Position
    
    local part = Instance.new("Part")
    part.Name = "ComboDisplay"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(6, 3, 0.1)
    part.Position = position + Vector3.new(0, 8, 0)
    part.Parent = workspace
    
    local gui = Instance.new("BillboardGui")
    gui.Parent = part
    gui.Size = UDim2.new(2, 0, 1, 0)
    
    local comboLabel = Instance.new("TextLabel")
    comboLabel.Parent = gui
    comboLabel.Size = UDim2.new(1, 0, 0.6, 0)
    comboLabel.Position = UDim2.new(0, 0, 0, 0)
    comboLabel.BackgroundTransparency = 1
    comboLabel.Text = comboCount .. " HIT COMBO!"
    comboLabel.TextScaled = true
    comboLabel.Font = Enum.Font.GothamBold
    comboLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    if comboRank then
        local rankLabel = Instance.new("TextLabel")
        rankLabel.Parent = gui
        rankLabel.Size = UDim2.new(1, 0, 0.4, 0)
        rankLabel.Position = UDim2.new(0, 0, 0.6, 0)
        rankLabel.BackgroundTransparency = 1
        rankLabel.Text = comboRank
        rankLabel.TextScaled = true
        rankLabel.Font = Enum.Font.GothamBold
        
        local _, rankColor = CombatUtils.getComboRank(comboCount)
        rankLabel.TextColor3 = rankColor or Color3.fromRGB(255, 255, 255)
    end
    
    -- Animate combo display
    local scaleTween = TweenService:Create(
        gui,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(3, 0, 1.5, 0)}
    )
    
    local fadeTween = TweenService:Create(
        gui,
        TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = UDim2.new(1, 0, 0.5, 0)}
    )
    
    scaleTween:Play()
    wait(0.5)
    fadeTween:Play()
    
    -- Clean up
    game:GetService("Debris"):AddItem(part, 2.0)
end

return EffectManager