-- Server-side combat system manager
-- MASSIVE EXPANSION: Advanced combat system with weapon systems, AI, physics, and complex mechanics

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local PathfindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")
local Debris = game:GetService("Debris")

-- Import combat utilities
local CombatUtils = require(ReplicatedStorage:WaitForChild("CombatUtils"))

-- Advanced combat system module
local CombatSystem = {}

-- Advanced physics and mathematical constants
local GRAVITY_CONSTANT = 196.2 -- Roblox's gravity
local AIR_RESISTANCE = 0.98
local GROUND_FRICTION = 0.85
local WALL_BOUNCE_COEFFICIENT = 0.6
local COMBO_PHYSICS_MULTIPLIER = 1.15
local KNOCKBACK_DAMPENING = 0.9
local MOMENTUM_CONSERVATION = 0.95

-- Weapon system constants
local WEAPON_DURABILITY_MAX = 1000
local WEAPON_REPAIR_RATE = 10
local WEAPON_CRITICAL_CHANCE = 0.15
local WEAPON_ELEMENTAL_DAMAGE_MULTIPLIER = 1.3
local WEAPON_ENCHANTMENT_POWER = 2.0

-- AI system constants
local AI_REACTION_TIME = 0.3
local AI_PREDICTION_ACCURACY = 0.7
local AI_LEARNING_RATE = 0.05
local AI_MEMORY_CAPACITY = 100
local AI_DIFFICULTY_SCALING = {
    EASY = 0.5,
    MEDIUM = 0.75,
    HARD = 1.0,
    EXTREME = 1.5,
    NIGHTMARE = 2.0
}

-- Advanced combat states
local COMBAT_STATES = {
    IDLE = "IDLE",
    ATTACKING = "ATTACKING",
    DEFENDING = "DEFENDING",
    STUNNED = "STUNNED",
    LAUNCHING = "LAUNCHING",
    AIRBORNE = "AIRBORNE",
    RECOVERING = "RECOVERING",
    CHANNELING = "CHANNELING",
    TRANSFORMING = "TRANSFORMING",
    ULTIMATE = "ULTIMATE"
}

-- Elemental damage types
local ELEMENTAL_TYPES = {
    FIRE = {
        name = "Fire",
        color = Color3.fromRGB(255, 100, 0),
        statusEffect = "BURNING",
        weakness = "WATER",
        strength = "ICE",
        damageOverTime = 5,
        duration = 3
    },
    ICE = {
        name = "Ice",
        color = Color3.fromRGB(100, 200, 255),
        statusEffect = "FROZEN",
        weakness = "FIRE",
        strength = "WATER",
        damageOverTime = 2,
        duration = 5,
        slowEffect = 0.5
    },
    LIGHTNING = {
        name = "Lightning",
        color = Color3.fromRGB(255, 255, 100),
        statusEffect = "PARALYZED",
        weakness = "EARTH",
        strength = "WATER",
        damageOverTime = 8,
        duration = 2,
        stunChance = 0.3
    },
    POISON = {
        name = "Poison",
        color = Color3.fromRGB(100, 255, 100),
        statusEffect = "POISONED",
        weakness = "LIGHT",
        strength = "PHYSICAL",
        damageOverTime = 3,
        duration = 8,
        healReduction = 0.5
    },
    DARK = {
        name = "Dark",
        color = Color3.fromRGB(50, 0, 50),
        statusEffect = "CURSED",
        weakness = "LIGHT",
        strength = "POISON",
        damageOverTime = 4,
        duration = 6,
        accuracyReduction = 0.3
    },
    LIGHT = {
        name = "Light",
        color = Color3.fromRGB(255, 255, 200),
        statusEffect = "BLESSED",
        weakness = "DARK",
        strength = "DARK",
        healOverTime = 3,
        duration = 5,
        damageBonus = 1.2
    }
}

-- Weapon archetypes and data
local WEAPON_ARCHETYPES = {
    SWORD = {
        name = "Sword",
        baseDamage = 25,
        attackSpeed = 1.0,
        range = 8,
        durability = 800,
        criticalChance = 0.15,
        specialAbilities = {"SLASH_WAVE", "BLADE_DANCE", "SWORD_BARRIER"},
        elementalAffinity = {"FIRE", "LIGHTNING"},
        comboExtension = 2,
        knockbackPower = 1.2
    },
    HAMMER = {
        name = "Hammer",
        baseDamage = 40,
        attackSpeed = 0.7,
        range = 6,
        durability = 1200,
        criticalChance = 0.25,
        specialAbilities = {"GROUND_SLAM", "METEOR_STRIKE", "SEISMIC_WAVE"},
        elementalAffinity = {"EARTH", "FIRE"},
        comboExtension = 1,
        knockbackPower = 2.0,
        armorPiercing = 0.3
    },
    STAFF = {
        name = "Staff",
        baseDamage = 20,
        attackSpeed = 1.2,
        range = 12,
        durability = 600,
        criticalChance = 0.1,
        specialAbilities = {"MANA_BLAST", "ELEMENTAL_STORM", "ENERGY_SHIELD"},
        elementalAffinity = {"ICE", "LIGHTNING", "FIRE"},
        comboExtension = 3,
        knockbackPower = 0.8,
        magicalDamage = true
    },
    BOW = {
        name = "Bow",
        baseDamage = 30,
        attackSpeed = 0.9,
        range = 50,
        durability = 500,
        criticalChance = 0.3,
        specialAbilities = {"MULTI_SHOT", "PIERCING_ARROW", "EXPLOSIVE_ARROW"},
        elementalAffinity = {"POISON", "ICE"},
        comboExtension = 0,
        knockbackPower = 1.0,
        projectileBased = true
    },
    GAUNTLETS = {
        name = "Gauntlets",
        baseDamage = 15,
        attackSpeed = 1.5,
        range = 4,
        durability = 1000,
        criticalChance = 0.2,
        specialAbilities = {"RAPID_PUNCH", "ENERGY_FIST", "COMBO_MASTERY"},
        elementalAffinity = {"LIGHTNING", "FIRE"},
        comboExtension = 4,
        knockbackPower = 0.6,
        comboBonus = 1.5
    }
}

-- AI behavior patterns
local AI_BEHAVIORS = {
    AGGRESSIVE = {
        attackFrequency = 0.8,
        blockingTendency = 0.2,
        comboFocus = 0.9,
        specialMoveUsage = 0.7,
        riskTaking = 0.9,
        adaptationRate = 0.3
    },
    DEFENSIVE = {
        attackFrequency = 0.4,
        blockingTendency = 0.8,
        comboFocus = 0.3,
        specialMoveUsage = 0.4,
        riskTaking = 0.2,
        adaptationRate = 0.5
    },
    BALANCED = {
        attackFrequency = 0.6,
        blockingTendency = 0.5,
        comboFocus = 0.6,
        specialMoveUsage = 0.5,
        riskTaking = 0.5,
        adaptationRate = 0.4
    },
    TACTICAL = {
        attackFrequency = 0.5,
        blockingTendency = 0.6,
        comboFocus = 0.8,
        specialMoveUsage = 0.8,
        riskTaking = 0.3,
        adaptationRate = 0.7
    },
    BERSERKER = {
        attackFrequency = 1.0,
        blockingTendency = 0.1,
        comboFocus = 1.0,
        specialMoveUsage = 0.9,
        riskTaking = 1.0,
        adaptationRate = 0.2
    }
}

-- Create RemoteEvents for client-server communication
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

-- Basic combat events
local punchEvent = Instance.new("RemoteEvent")
punchEvent.Name = "PunchEvent"
punchEvent.Parent = remoteEvents

local heavyPunchEvent = Instance.new("RemoteEvent")
heavyPunchEvent.Name = "HeavyPunchEvent"
heavyPunchEvent.Parent = remoteEvents

local specialMoveEvent = Instance.new("RemoteEvent")
specialMoveEvent.Name = "SpecialMoveEvent"
specialMoveEvent.Parent = remoteEvents

local blockEvent = Instance.new("RemoteEvent")
blockEvent.Name = "BlockEvent"
blockEvent.Parent = remoteEvents

local damageEvent = Instance.new("RemoteEvent")
damageEvent.Name = "DamageEvent"
damageEvent.Parent = remoteEvents

local comboEvent = Instance.new("RemoteEvent")
comboEvent.Name = "ComboEvent"
comboEvent.Parent = remoteEvents

-- Advanced combat events
local weaponEquipEvent = Instance.new("RemoteEvent")
weaponEquipEvent.Name = "WeaponEquipEvent"
weaponEquipEvent.Parent = remoteEvents

local elementalAttackEvent = Instance.new("RemoteEvent")
elementalAttackEvent.Name = "ElementalAttackEvent"
elementalAttackEvent.Parent = remoteEvents

local transformationEvent = Instance.new("RemoteEvent")
transformationEvent.Name = "TransformationEvent"
transformationEvent.Parent = remoteEvents

local ultimateAbilityEvent = Instance.new("RemoteEvent")
ultimateAbilityEvent.Name = "UltimateAbilityEvent"
ultimateAbilityEvent.Parent = remoteEvents

local statusEffectEvent = Instance.new("RemoteEvent")
statusEffectEvent.Name = "StatusEffectEvent"
statusEffectEvent.Parent = remoteEvents

local environmentalInteractionEvent = Instance.new("RemoteEvent")
environmentalInteractionEvent.Name = "EnvironmentalInteractionEvent"
environmentalInteractionEvent.Parent = remoteEvents

-- Player data storage with advanced combat statistics
local playerData = {}
local aiEntities = {}
local environmentalHazards = {}
local combatArenas = {}

-- Advanced physics system for combat
local function calculateKnockback(attacker, target, attackPower, direction)
    local baseKnockback = attackPower * 10
    local mass = target.Character.Humanoid.MassData.TotalMass or 1
    local knockbackForce = baseKnockback / math.sqrt(mass)
    
    local targetPos = target.Character.HumanoidRootPart.Position
    local attackerPos = attacker.Character.HumanoidRootPart.Position
    local knockbackDirection = direction or (targetPos - attackerPos).Unit
    
    return knockbackDirection * knockbackForce
end

local function applyPhysicsBasedKnockback(character, force, duration)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
    bodyVelocity.Velocity = Vector3.new(force.X, 0, force.Z)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Apply upward force for dramatic effect
    if force.Magnitude > 50 then
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
        bodyPosition.Position = humanoidRootPart.Position + Vector3.new(0, force.Magnitude / 10, 0)
        bodyPosition.D = 500
        bodyPosition.P = 3000
        bodyPosition.Parent = humanoidRootPart
        
        spawn(function()
            wait(0.2)
            if bodyPosition.Parent then
                bodyPosition:Destroy()
            end
        end)
    end
    
    Debris:AddItem(bodyVelocity, duration or 0.5)
end

-- Advanced damage calculation system
local function calculateAdvancedDamage(attacker, target, baseDamage, attackType, weapon, elementalType)
    local damage = baseDamage
    local attackerData = playerData[attacker]
    local targetData = playerData[target]
    
    if not attackerData or not targetData then
        return damage
    end
    
    -- Weapon damage modification
    if weapon then
        damage = damage * (weapon.damageMultiplier or 1.0)
        
        -- Critical hit calculation
        if math.random() < (weapon.criticalChance or 0) then
            damage = damage * 2
            -- TODO: Add critical hit visual effect
        end
        
        -- Durability affects damage
        local durabilityRatio = weapon.currentDurability / weapon.maxDurability
        damage = damage * (0.5 + 0.5 * durabilityRatio)
    end
    
    -- Elemental damage calculation
    if elementalType then
        local elementalData = ELEMENTAL_TYPES[elementalType]
        if elementalData then
            damage = damage * WEAPON_ELEMENTAL_DAMAGE_MULTIPLIER
            
            -- Apply elemental weaknesses/strengths
            if targetData.activeElements then
                for _, activeElement in pairs(targetData.activeElements) do
                    if elementalData.strength == activeElement then
                        damage = damage * 1.5
                    elseif elementalData.weakness == activeElement then
                        damage = damage * 0.5
                    end
                end
            end
        end
    end
    
    -- Combo multiplier with diminishing returns
    if attackerData.comboCount > 0 then
        local comboMultiplier = 1 + (attackerData.comboCount * 0.1)
        comboMultiplier = math.min(comboMultiplier, 3.0) -- Cap at 300%
        damage = damage * comboMultiplier
    end
    
    -- Defense calculation
    local defense = targetData.defense or 0
    local damageReduction = defense / (defense + 100) -- Soft cap formula
    damage = damage * (1 - damageReduction)
    
    -- Apply blocking reduction
    if targetData.isBlocking then
        damage = damage * (1 - CombatUtils.BLOCK_DAMAGE_REDUCTION)
        
        -- Perfect block check
        if targetData.perfectBlockWindow and 
           tick() - targetData.perfectBlockWindow < CombatUtils.PARRY_WINDOW then
            damage = 0
            return damage, true -- Perfect block occurred
        end
    end
    
    -- Random variance
    damage = damage * (0.9 + math.random() * 0.2) -- ±10% variance
    
    return math.floor(damage), false
end

-- Advanced combo system with branching paths
local function processComboSystem(attacker, target, attackType)
    local attackerData = playerData[attacker]
    if not attackerData then return end
    
    local currentTime = tick()
    
    -- Check combo timing
    if attackerData.lastHitTime and 
       currentTime - attackerData.lastHitTime > CombatUtils.COMBO_WINDOW then
        attackerData.comboCount = 0
        attackerData.comboSequence = {}
    end
    
    -- Add to combo sequence
    table.insert(attackerData.comboSequence, {
        type = attackType,
        time = currentTime,
        target = target
    })
    
    -- Limit sequence length
    while #attackerData.comboSequence > 10 do
        table.remove(attackerData.comboSequence, 1)
    end
    
    -- Increment combo count
    attackerData.comboCount = attackerData.comboCount + 1
    attackerData.lastHitTime = currentTime
    
    -- Check for special combo patterns
    checkComboPatterns(attacker, attackerData.comboSequence)
    
    -- Broadcast combo update
    local comboRank, comboColor = CombatUtils.getComboRank(attackerData.comboCount)
    if comboRank then
        comboEvent:FireAllClients(attacker.Name, attackerData.comboCount, comboRank)
    end
end

-- Advanced combo pattern recognition
function checkComboPatterns(player, sequence)
    if #sequence < 3 then return end
    
    local recent = {}
    for i = math.max(1, #sequence - 5), #sequence do
        table.insert(recent, sequence[i].type)
    end
    
    -- Pattern: Light-Light-Heavy = Power Strike
    if #recent >= 3 and recent[#recent-2] == "light" and 
       recent[#recent-1] == "light" and recent[#recent] == "heavy" then
        triggerComboSpecial(player, "POWER_STRIKE")
    end
    
    -- Pattern: Heavy-Block-Heavy = Counter Attack
    if #recent >= 3 and recent[#recent-2] == "heavy" and 
       recent[#recent-1] == "block" and recent[#recent] == "heavy" then
        triggerComboSpecial(player, "COUNTER_ATTACK")
    end
    
    -- Pattern: Light-Heavy-Light-Heavy = Rhythm Combo
    if #recent >= 4 and recent[#recent-3] == "light" and 
       recent[#recent-2] == "heavy" and recent[#recent-1] == "light" and 
       recent[#recent] == "heavy" then
        triggerComboSpecial(player, "RHYTHM_COMBO")
    end
    
    -- Pattern: Special-Special = Ultimate Combo
    if #recent >= 2 and recent[#recent-1] == "special" and 
       recent[#recent] == "special" then
        triggerComboSpecial(player, "ULTIMATE_COMBO")
    end
end

-- Trigger special combo abilities
function triggerComboSpecial(player, comboType)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    if comboType == "POWER_STRIKE" then
        playerCombatData.nextAttackDamage = (playerCombatData.nextAttackDamage or 1) * 2
        print(player.Name .. " triggered Power Strike! Next attack deals double damage!")
        
    elseif comboType == "COUNTER_ATTACK" then
        playerCombatData.counterAttackWindow = tick() + 3
        print(player.Name .. " triggered Counter Attack! Next attack is unblockable!")
        
    elseif comboType == "RHYTHM_COMBO" then
        playerCombatData.attackSpeedBonus = 2.0
        playerCombatData.attackSpeedBonusEnd = tick() + 5
        print(player.Name .. " triggered Rhythm Combo! Attack speed doubled!")
        
    elseif comboType == "ULTIMATE_COMBO" then
        playerCombatData.ultimateCharge = (playerCombatData.ultimateCharge or 0) + 25
        print(player.Name .. " triggered Ultimate Combo! Ultimate charge increased!")
    end
end

-- Advanced AI system for NPCs
local function createAIEntity(name, difficulty, behavior, position)
    local aiData = {
        name = name,
        difficulty = difficulty,
        behavior = AI_BEHAVIORS[behavior] or AI_BEHAVIORS.BALANCED,
        position = position,
        health = 100,
        stamina = 100,
        comboCount = 0,
        lastAction = 0,
        target = nil,
        memory = {},
        learningData = {},
        state = COMBAT_STATES.IDLE,
        patternRecognition = {},
        reactionTime = AI_REACTION_TIME / AI_DIFFICULTY_SCALING[difficulty]
    }
    
    -- Create AI character model
    local character = Instance.new("Model")
    character.Name = name
    character.Parent = workspace
    
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = character
    
    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 5, 1)
    rootPart.Position = position
    rootPart.Anchored = false
    rootPart.CanCollide = true
    rootPart.BrickColor = BrickColor.new("Really red")
    rootPart.Parent = character
    
    local rootJoint = Instance.new("Motor6D")
    rootJoint.Name = "RootJoint"
    rootJoint.Parent = rootPart
    
    aiData.character = character
    aiData.humanoid = humanoid
    aiData.rootPart = rootPart
    
    aiEntities[name] = aiData
    return aiData
end

-- AI decision making system
local function processAIDecision(aiEntity)
    if not aiEntity or not aiEntity.character or not aiEntity.character.Parent then
        return
    end
    
    local currentTime = tick()
    if currentTime - aiEntity.lastAction < aiEntity.reactionTime then
        return
    end
    
    -- Find target
    if not aiEntity.target or not aiEntity.target.Character then
        aiEntity.target = findClosestPlayer(aiEntity.character)
    end
    
    if not aiEntity.target then
        aiEntity.state = COMBAT_STATES.IDLE
        return
    end
    
    local distance = (aiEntity.rootPart.Position - aiEntity.target.Character.HumanoidRootPart.Position).Magnitude
    
    -- Decision making based on behavior and situation
    local behavior = aiEntity.behavior
    local decision = "none"
    
    if distance <= CombatUtils.PUNCH_RANGE then
        -- Close combat decisions
        if aiEntity.health < 30 and math.random() < behavior.blockingTendency then
            decision = "block"
        elseif math.random() < behavior.attackFrequency then
            if math.random() < 0.3 and aiEntity.comboCount >= 3 then
                decision = "special"
            elseif math.random() < 0.6 then
                decision = "light"
            else
                decision = "heavy"
            end
        end
    elseif distance <= 30 then
        -- Medium range decisions
        decision = "approach"
    else
        -- Long range decisions
        decision = "move_closer"
    end
    
    -- Execute decision
    executeAIAction(aiEntity, decision)
    aiEntity.lastAction = currentTime
end

-- Execute AI actions
function executeAIAction(aiEntity, action)
    if not aiEntity or not aiEntity.target then return end
    
    if action == "light" then
        -- Simulate light punch
        local damage = calculateAdvancedDamage(
            {Character = aiEntity.character}, 
            aiEntity.target, 
            CombatUtils.BASE_PUNCH_DAMAGE, 
            "light"
        )
        
        applyDamageToPlayer(aiEntity.target, damage, "AI Light Punch")
        aiEntity.comboCount = aiEntity.comboCount + 1
        
    elseif action == "heavy" then
        -- Simulate heavy punch
        local damage = calculateAdvancedDamage(
            {Character = aiEntity.character}, 
            aiEntity.target, 
            CombatUtils.HEAVY_PUNCH_DAMAGE, 
            "heavy"
        )
        
        applyDamageToPlayer(aiEntity.target, damage, "AI Heavy Punch")
        
        -- Apply knockback
        local knockback = calculateKnockback(
            {Character = aiEntity.character}, 
            aiEntity.target, 
            2.0
        )
        applyPhysicsBasedKnockback(aiEntity.target.Character, knockback, 0.8)
        
    elseif action == "block" then
        aiEntity.state = COMBAT_STATES.DEFENDING
        
        spawn(function()
            wait(math.random(1, 3))
            if aiEntity.state == COMBAT_STATES.DEFENDING then
                aiEntity.state = COMBAT_STATES.IDLE
            end
        end)
        
    elseif action == "approach" then
        -- Move towards target
        local direction = (aiEntity.target.Character.HumanoidRootPart.Position - aiEntity.rootPart.Position).Unit
        aiEntity.humanoid:MoveTo(aiEntity.rootPart.Position + direction * 10)
    end
end

-- Find closest player to AI
function findClosestPlayer(aiCharacter)
    local aiPosition = aiCharacter.HumanoidRootPart.Position
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (aiPosition - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer
end

-- Apply damage with visual and sound effects
function applyDamageToPlayer(player, damage, source)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    playerCombatData.health = math.max(0, playerCombatData.health - damage)
    
    -- Create damage effect
    createDamageEffect(player.Character, damage)
    
    -- Play damage sound
    playDamageSound(player.Character, damage)
    
    -- Check for knockout
    if playerCombatData.health <= 0 then
        handlePlayerKnockout(player)
    end
    
    -- Update clients
    damageEvent:FireAllClients(player, playerCombatData.health, damage, source)
end

-- Create visual damage effects
function createDamageEffect(character, damage)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local effect = Instance.new("Explosion")
    effect.Position = character.HumanoidRootPart.Position
    effect.BlastRadius = 0
    effect.BlastPressure = 0
    effect.Visible = false
    effect.Parent = workspace
    
    -- Create damage number display
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.new(0, 100, 0, 50)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.Parent = character.HumanoidRootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "-" .. damage
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = gui
    
    -- Animate damage number
    local tween = TweenService:Create(
        gui,
        TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {StudsOffset = Vector3.new(0, 8, 0)}
    )
    tween:Play()
    
    local fadeTween = TweenService:Create(
        label,
        TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 1}
    )
    fadeTween:Play()
    
    Debris:AddItem(gui, 2)
end

-- Play appropriate damage sound
function playDamageSound(character, damage)
    if not character then return end
    
    local sound = Instance.new("Sound")
    sound.Volume = math.min(damage / 50, 1)
    
    if damage > 30 then
        sound.SoundId = "rbxasset://sounds/impact_generic.mp3"
        sound.Pitch = 0.8
    elseif damage > 15 then
        sound.SoundId = "rbxasset://sounds/impact_generic.mp3"
        sound.Pitch = 1.0
    else
        sound.SoundId = "rbxasset://sounds/impact_generic.mp3"
        sound.Pitch = 1.2
    end
    
    sound.Parent = character.HumanoidRootPart
    sound:Play()
    
    Debris:AddItem(sound, 3)
end

-- Handle player knockout
function handlePlayerKnockout(player)
    local character = player.Character
    if not character then return end
    
    -- Ragdoll effect
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
        
        -- Apply knockout force
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(
                math.random(-20, 20),
                20,
                math.random(-20, 20)
            )
            bodyVelocity.Parent = rootPart
            
            Debris:AddItem(bodyVelocity, 1)
        end
        
        -- Respawn after delay
        spawn(function()
            wait(5)
            if player.Character then
                humanoid.PlatformStand = false
                playerData[player] = CombatUtils.createCombatState()
            end
        end)
    end
    
    print(player.Name .. " has been knocked out!")
end

-- Initialize player data when they join
local function onPlayerAdded(player)
    playerData[player] = CombatUtils.createCombatState()
    playerData[player].player = player
    playerData[player].comboSequence = {}
    playerData[player].activeElements = {}
    playerData[player].statusEffects = {}
    playerData[player].equippedWeapon = nil
    playerData[player].ultimateCharge = 0
    playerData[player].defense = 0
    playerData[player].state = COMBAT_STATES.IDLE
    
    print("Combat data initialized for " .. player.Name)
end

-- Clean up when player leaves
local function onPlayerRemoving(player)
    playerData[player] = nil
end

-- Handle light punch attacks with advanced mechanics
local function onPunchEvent(player, targetPlayer, attackType)
    if not playerData[player] or not playerData[targetPlayer] then return end
    if not CombatUtils.isInAttackRange(player, targetPlayer) then return end
    
    local currentTime = tick()
    local playerCombatData = playerData[player]
    
    -- Validate action
    local isValid, message = CombatUtils.validateCombatAction(
        player, 
        "punch", 
        playerCombatData.lastActionTime, 
        playerCombatData.comboCount
    )
    
    if not isValid then
        warn(player.Name .. ": " .. message)
        return
    end
    
    -- Apply attack speed bonus if active
    local attackSpeed = 1.0
    if playerCombatData.attackSpeedBonusEnd and 
       currentTime < playerCombatData.attackSpeedBonusEnd then
        attackSpeed = playerCombatData.attackSpeedBonus or 1.0
    end
    
    -- Calculate damage with all modifiers
    local baseDamage = CombatUtils.BASE_PUNCH_DAMAGE
    if playerCombatData.nextAttackDamage then
        baseDamage = baseDamage * playerCombatData.nextAttackDamage
        playerCombatData.nextAttackDamage = nil
    end
    
    local finalDamage, isBlocked = calculateAdvancedDamage(
        player,
        targetPlayer,
        baseDamage,
        "light",
        playerCombatData.equippedWeapon
    )
    
    -- Apply damage
    applyDamageToPlayer(targetPlayer, finalDamage, "light punch")
    
    -- Update combat state
    playerCombatData.lastActionTime = currentTime
    playerCombatData.state = COMBAT_STATES.ATTACKING
    
    -- Process combo system
    if not isBlocked then
        processComboSystem(player, targetPlayer, "light")
    end
    
    -- Apply knockback
    local knockback = calculateKnockback(player, targetPlayer, 1.0)
    applyPhysicsBasedKnockback(targetPlayer.Character, knockback, 0.3)
    
    print(player.Name .. " light punched " .. targetPlayer.Name .. " for " .. finalDamage .. " damage")
end

-- Handle heavy punch attacks with enhanced mechanics
local function onHeavyPunchEvent(player, targetPlayer, attackType)
    if not playerData[player] or not playerData[targetPlayer] then return end
    if not CombatUtils.isInAttackRange(player, targetPlayer) then return end
    
    local currentTime = tick()
    local playerCombatData = playerData[player]
    
    local isValid, message = CombatUtils.validateCombatAction(
        player, 
        "heavy", 
        playerCombatData.lastActionTime, 
        playerCombatData.comboCount
    )
    
    if not isValid then
        warn(player.Name .. ": " .. message)
        return
    end
    
    -- Calculate enhanced heavy damage
    local baseDamage = CombatUtils.HEAVY_PUNCH_DAMAGE
    if playerCombatData.nextAttackDamage then
        baseDamage = baseDamage * playerCombatData.nextAttackDamage
        playerCombatData.nextAttackDamage = nil
    end
    
    local finalDamage, isBlocked = calculateAdvancedDamage(
        player,
        targetPlayer,
        baseDamage,
        "heavy",
        playerCombatData.equippedWeapon
    )
    
    -- Apply damage
    applyDamageToPlayer(targetPlayer, finalDamage, "heavy punch")
    
    -- Heavy attacks can break through blocks
    if playerData[targetPlayer].isBlocking and 
       not playerData[targetPlayer].perfectBlockWindow then
        finalDamage = finalDamage * 0.7 -- Reduced but not negated
    end
    
    -- Update combat state
    playerCombatData.lastActionTime = currentTime
    playerCombatData.state = COMBAT_STATES.ATTACKING
    
    -- Heavy attacks can break combos or continue them
    if CombatUtils.isComboBreaker("heavy", playerCombatData.comboCount) then
        playerCombatData.comboCount = 0
    else
        processComboSystem(player, targetPlayer, "heavy")
    end
    
    -- Apply stronger knockback
    local knockback = calculateKnockback(player, targetPlayer, 2.5)
    applyPhysicsBasedKnockback(targetPlayer.Character, knockback, 0.8)
    
    print(player.Name .. " heavy punched " .. targetPlayer.Name .. " for " .. finalDamage .. " damage")
end

-- Handle special move attacks with advanced systems
local function onSpecialMoveEvent(player, targetPlayer, moveType)
    if not playerData[player] or not playerData[targetPlayer] then return end
    if not CombatUtils.isInAttackRange(player, targetPlayer) then return end
    
    local currentTime = tick()
    local playerCombatData = playerData[player]
    
    local canUse, message = CombatUtils.canUseSpecialMove(
        moveType,
        playerCombatData.comboCount,
        playerCombatData.lastSpecialTime,
        currentTime,
        playerCombatData.stamina
    )
    
    if not canUse then
        warn(player.Name .. ": " .. message)
        return
    end
    
    local specialData = CombatUtils.SPECIAL_MOVES[moveType]
    if not specialData then return end
    
    -- Calculate special move damage
    local finalDamage = calculateAdvancedDamage(
        player,
        targetPlayer,
        specialData.damage,
        "special",
        playerCombatData.equippedWeapon
    )
    
    -- Apply damage
    applyDamageToPlayer(targetPlayer, finalDamage, moveType)
    
    -- Update player state
    playerCombatData.lastSpecialTime = currentTime
    playerCombatData.lastActionTime = currentTime
    playerCombatData.stamina = playerCombatData.stamina - specialData.staminaCost
    playerCombatData.state = COMBAT_STATES.CHANNELING
    
    -- Special move effects
    createSpecialMoveEffect(player.Character, targetPlayer.Character, moveType)
    
    -- Special moves have unique properties
    if moveType == "UPPERCUT" then
        -- Launch target into air
        local launchForce = Vector3.new(0, 50, 0)
        applyPhysicsBasedKnockback(targetPlayer.Character, launchForce, 1.0)
        playerData[targetPlayer].state = COMBAT_STATES.AIRBORNE
        
    elseif moveType == "SPINNING_KICK" then
        -- Area damage
        dealAreaDamage(player, targetPlayer.Character.HumanoidRootPart.Position, 15, finalDamage * 0.5)
        
    elseif moveType == "DEVASTATOR" then
        -- Armor piercing damage
        finalDamage = finalDamage * 1.5
        
        -- Screen shake effect
        for _, client in pairs(Players:GetPlayers()) do
            if client.Character and 
               (client.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude < 100 then
                -- TODO: Trigger screen shake on client
            end
        end
    end
    
    -- Special moves reset combo but may trigger ultimate charge
    playerCombatData.comboCount = 0
    playerCombatData.ultimateCharge = (playerCombatData.ultimateCharge or 0) + 10
    
    print(player.Name .. " used " .. moveType .. " on " .. targetPlayer.Name .. " for " .. finalDamage .. " damage!")
end

-- Area damage system
function dealAreaDamage(attacker, center, radius, damage)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= attacker and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - center).Magnitude
            if distance <= radius then
                local scaledDamage = damage * (1 - distance / radius) -- Damage falloff
                applyDamageToPlayer(player, scaledDamage, "Area Attack")
            end
        end
    end
end

-- Create special move visual effects
function createSpecialMoveEffect(attackerCharacter, targetCharacter, moveType)
    if not attackerCharacter or not targetCharacter then return end
    
    local effectData = CombatUtils.EffectData.SpecialMove[moveType]
    if not effectData then return end
    
    -- Create particle effect
    local attachment = Instance.new("Attachment")
    attachment.Parent = targetCharacter.HumanoidRootPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particles.Lifetime = NumberRange.new(0.5, 1.5)
    particles.Rate = effectData.particleCount
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(5, 15)
    particles.Color = ColorSequence.new(effectData.color)
    particles.Size = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, effectData.size),
        NumberSequenceKeypoint.new(1, 0)
    }
    particles.Parent = attachment
    
    -- Remove effect after duration
    Debris:AddItem(attachment, effectData.duration)
end

-- Handle blocking with perfect parry system
local function onBlockEvent(player, isBlocking)
    if not playerData[player] then return end
    
    local playerCombatData = playerData[player]
    playerCombatData.isBlocking = isBlocking
    
    if isBlocking then
        playerCombatData.perfectBlockWindow = tick()
        playerCombatData.state = COMBAT_STATES.DEFENDING
        print(player.Name .. " started blocking")
    else
        playerCombatData.perfectBlockWindow = nil
        playerCombatData.state = COMBAT_STATES.IDLE
        print(player.Name .. " stopped blocking")
    end
end

-- Weapon system implementation
local function onWeaponEquipEvent(player, weaponType)
    if not playerData[player] then return end
    
    local weaponArchetype = WEAPON_ARCHETYPES[weaponType]
    if not weaponArchetype then return end
    
    -- Create weapon instance
    local weapon = {
        type = weaponType,
        baseDamage = weaponArchetype.baseDamage,
        attackSpeed = weaponArchetype.attackSpeed,
        range = weaponArchetype.range,
        currentDurability = weaponArchetype.durability,
        maxDurability = weaponArchetype.durability,
        criticalChance = weaponArchetype.criticalChance,
        specialAbilities = weaponArchetype.specialAbilities,
        elementalAffinity = weaponArchetype.elementalAffinity,
        damageMultiplier = 1.0,
        enchantments = {}
    }
    
    playerData[player].equippedWeapon = weapon
    
    -- Create visual weapon model
    createWeaponModel(player, weapon)
    
    print(player.Name .. " equipped " .. weaponType)
end

-- Create weapon visual model
function createWeaponModel(player, weapon)
    local character = player.Character
    if not character then return end
    
    local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
    if not rightHand then return end
    
    -- Remove existing weapon
    local existingWeapon = rightHand:FindFirstChild("Weapon")
    if existingWeapon then
        existingWeapon:Destroy()
    end
    
    -- Create new weapon model
    local weaponModel = Instance.new("Part")
    weaponModel.Name = "Weapon"
    weaponModel.Size = Vector3.new(0.5, 4, 0.5)
    weaponModel.Anchored = false
    weaponModel.CanCollide = false
    
    -- Set weapon appearance based on type
    if weapon.type == "SWORD" then
        weaponModel.BrickColor = BrickColor.new("Really black")
        weaponModel.Material = Enum.Material.Metal
    elseif weapon.type == "HAMMER" then
        weaponModel.Size = Vector3.new(1, 3, 1)
        weaponModel.BrickColor = BrickColor.new("Brown")
        weaponModel.Material = Enum.Material.Wood
    elseif weapon.type == "STAFF" then
        weaponModel.Size = Vector3.new(0.3, 5, 0.3)
        weaponModel.BrickColor = BrickColor.new("Bright blue")
        weaponModel.Material = Enum.Material.Neon
    end
    
    weaponModel.Parent = rightHand
    
    -- Attach weapon to hand
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = rightHand
    weld.Part1 = weaponModel
    weld.Parent = weaponModel
end

-- Elemental damage system
local function onElementalAttackEvent(player, targetPlayer, elementalType)
    if not playerData[player] or not playerData[targetPlayer] then return end
    if not ELEMENTAL_TYPES[elementalType] then return end
    
    local elementalData = ELEMENTAL_TYPES[elementalType]
    local playerCombatData = playerData[player]
    local targetCombatData = playerData[targetPlayer]
    
    -- Calculate elemental damage
    local baseDamage = 20
    local finalDamage = calculateAdvancedDamage(
        player,
        targetPlayer,
        baseDamage,
        "elemental",
        playerCombatData.equippedWeapon,
        elementalType
    )
    
    -- Apply damage
    applyDamageToPlayer(targetPlayer, finalDamage, elementalData.name .. " Attack")
    
    -- Apply status effect
    applyStatusEffect(targetPlayer, elementalData.statusEffect, elementalData)
    
    -- Create elemental effect
    createElementalEffect(targetPlayer.Character, elementalData)
    
    print(player.Name .. " used " .. elementalData.name .. " attack on " .. targetPlayer.Name)
end

-- Status effect system
function applyStatusEffect(player, effectType, elementalData)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    -- Remove existing effect of same type
    for i, effect in ipairs(playerCombatData.statusEffects) do
        if effect.type == effectType then
            table.remove(playerCombatData.statusEffects, i)
            break
        end
    end
    
    -- Add new status effect
    local statusEffect = {
        type = effectType,
        duration = elementalData.duration,
        damageOverTime = elementalData.damageOverTime,
        healOverTime = elementalData.healOverTime,
        startTime = tick(),
        elementalData = elementalData
    }
    
    table.insert(playerCombatData.statusEffects, statusEffect)
    
    -- Notify clients
    statusEffectEvent:FireAllClients(player, effectType, elementalData.duration)
    
    print(player.Name .. " is now affected by " .. effectType)
end

-- Process status effects over time
function processStatusEffects()
    for player, combatData in pairs(playerData) do
        for i = #combatData.statusEffects, 1, -1 do
            local effect = combatData.statusEffects[i]
            local currentTime = tick()
            
            -- Check if effect has expired
            if currentTime - effect.startTime >= effect.duration then
                table.remove(combatData.statusEffects, i)
                print(player.Name .. "'s " .. effect.type .. " effect has expired")
            else
                -- Apply effect
                if effect.damageOverTime and effect.damageOverTime > 0 then
                    applyDamageToPlayer(player, effect.damageOverTime, effect.type)
                end
                
                if effect.healOverTime and effect.healOverTime > 0 then
                    combatData.health = math.min(combatData.maxHealth, combatData.health + effect.healOverTime)
                    damageEvent:FireAllClients(player, combatData.health, -effect.healOverTime, "Healing")
                end
            end
        end
    end
end

-- Create elemental visual effects
function createElementalEffect(character, elementalData)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = character.HumanoidRootPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxasset://textures/particles/fire_main.dds"
    particles.Lifetime = NumberRange.new(1, 3)
    particles.Rate = 30
    particles.SpreadAngle = Vector2.new(30, 30)
    particles.Speed = NumberRange.new(2, 8)
    particles.Color = ColorSequence.new(elementalData.color)
    particles.Size = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 2),
        NumberSequenceKeypoint.new(1, 0)
    }
    particles.Parent = attachment
    
    Debris:AddItem(attachment, elementalData.duration)
end

-- Ultimate ability system
local function onUltimateAbilityEvent(player, ultimateType)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    -- Check ultimate charge
    if (playerCombatData.ultimateCharge or 0) < 100 then
        warn(player.Name .. " doesn't have enough ultimate charge")
        return
    end
    
    -- Consume ultimate charge
    playerCombatData.ultimateCharge = 0
    playerCombatData.state = COMBAT_STATES.ULTIMATE
    
    -- Execute ultimate ability
    if ultimateType == "BERSERKER_RAGE" then
        -- Temporary damage and speed boost
        playerCombatData.damageMultiplier = 3.0
        playerCombatData.attackSpeedBonus = 2.0
        playerCombatData.ultimateEnd = tick() + 10
        
    elseif ultimateType == "HEALING_AURA" then
        -- Full heal and temporary invincibility
        playerCombatData.health = playerCombatData.maxHealth
        playerCombatData.invulnerable = true
        playerCombatData.ultimateEnd = tick() + 5
        
    elseif ultimateType == "ELEMENTAL_STORM" then
        -- Area elemental damage
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local distance = (otherPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                    if distance <= 50 then
                        applyDamageToPlayer(otherPlayer, 75, "Elemental Storm")
                        applyStatusEffect(otherPlayer, "BURNING", ELEMENTAL_TYPES.FIRE)
                    end
                end
            end
        end
    end
    
    print(player.Name .. " activated ultimate ability: " .. ultimateType)
end

-- Environmental interaction system
local function onEnvironmentalInteractionEvent(player, interactionType, targetObject)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    if interactionType == "WALL_BOUNCE" then
        -- Player bounces off wall with enhanced momentum
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bounceForce = Vector3.new(math.random(-30, 30), 20, math.random(-30, 30))
            applyPhysicsBasedKnockback(character, bounceForce, 1.0)
        end
        
    elseif interactionType == "GROUND_SLAM" then
        -- Player slams into ground, creating shockwave
        dealAreaDamage(player, player.Character.HumanoidRootPart.Position, 20, 30)
        
    elseif interactionType == "OBJECT_THROW" then
        -- Player throws environmental object
        if targetObject and targetObject.Parent then
            local projectile = targetObject:Clone()
            projectile.Parent = workspace
            
            -- Apply throwing physics
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = player.Character.HumanoidRootPart.CFrame.LookVector * 50
            bodyVelocity.Parent = projectile
            
            Debris:AddItem(bodyVelocity, 2)
            Debris:AddItem(projectile, 10)
        end
    end
end

-- Main game loop for combat systems
spawn(function()
    while true do
        wait(1) -- Update every second
        
        -- Process status effects
        processStatusEffects()
        
        -- Update stamina regeneration
        for player, combatData in pairs(playerData) do
            if combatData.stamina < combatData.maxStamina then
                combatData.stamina = math.min(
                    combatData.maxStamina,
                    combatData.stamina + CombatUtils.STAMINA_REGEN_RATE
                )
            end
            
            -- Check ultimate ability timeouts
            if combatData.ultimateEnd and tick() > combatData.ultimateEnd then
                combatData.damageMultiplier = 1.0
                combatData.attackSpeedBonus = 1.0
                combatData.invulnerable = false
                combatData.ultimateEnd = nil
                combatData.state = COMBAT_STATES.IDLE
            end
        end
        
        -- Process AI entities
        for _, aiEntity in pairs(aiEntities) do
            processAIDecision(aiEntity)
        end
    end
end)

-- Connect events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
punchEvent.OnServerEvent:Connect(onPunchEvent)
heavyPunchEvent.OnServerEvent:Connect(onHeavyPunchEvent)
specialMoveEvent.OnServerEvent:Connect(onSpecialMoveEvent)
blockEvent.OnServerEvent:Connect(onBlockEvent)
weaponEquipEvent.OnServerEvent:Connect(onWeaponEquipEvent)
elementalAttackEvent.OnServerEvent:Connect(onElementalAttackEvent)
ultimateAbilityEvent.OnServerEvent:Connect(onUltimateAbilityEvent)
environmentalInteractionEvent.OnServerEvent:Connect(onEnvironmentalInteractionEvent)

-- Combat system management functions
CombatSystem.createAI = createAIEntity
CombatSystem.getPlayerData = function(player) return playerData[player] end
CombatSystem.getAllPlayerData = function() return playerData end
CombatSystem.getAIEntities = function() return aiEntities end

-- Initialize some AI entities for testing
spawn(function()
    wait(5) -- Wait for game to load
    createAIEntity("TrainingBot1", "MEDIUM", "BALANCED", Vector3.new(10, 5, 10))
    createAIEntity("TrainingBot2", "HARD", "AGGRESSIVE", Vector3.new(-10, 5, -10))
    createAIEntity("TrainingBot3", "EASY", "DEFENSIVE", Vector3.new(0, 5, 20))
end)

-- Advanced transformation system
local TRANSFORMATION_STATES = {
    NORMAL = {
        name = "Normal",
        damageMultiplier = 1.0,
        speedMultiplier = 1.0,
        defenseMultiplier = 1.0,
        duration = 0,
        visualEffect = "None"
    },
    BERSERK = {
        name = "Berserk",
        damageMultiplier = 2.5,
        speedMultiplier = 1.8,
        defenseMultiplier = 0.7,
        duration = 15,
        visualEffect = "RedAura",
        requirements = {comboCount = 15, healthBelow = 50}
    },
    ELEMENTAL_FUSION = {
        name = "Elemental Fusion",
        damageMultiplier = 1.8,
        speedMultiplier = 1.5,
        defenseMultiplier = 1.3,
        duration = 20,
        visualEffect = "ElementalAura",
        requirements = {ultimateCharge = 75, elementalMastery = 50}
    },
    SHADOW_FORM = {
        name = "Shadow Form",
        damageMultiplier = 1.5,
        speedMultiplier = 2.5,
        defenseMultiplier = 0.5,
        duration = 12,
        visualEffect = "ShadowAura",
        requirements = {stealth = 100, darkness = "ACTIVE"}
    },
    TITAN_MODE = {
        name = "Titan Mode",
        damageMultiplier = 3.0,
        speedMultiplier = 0.8,
        defenseMultiplier = 2.0,
        duration = 25,
        visualEffect = "GoldAura",
        requirements = {level = 50, titanEnergy = 100}
    }
}

-- Advanced combo system with frame data
local COMBO_FRAME_DATA = {
    LIGHT_PUNCH = {
        startup = 3,
        active = 2,
        recovery = 8,
        advantage = 2,
        disadvantage = -2,
        damage = 12,
        hitstun = 15,
        blockstun = 8
    },
    HEAVY_PUNCH = {
        startup = 8,
        active = 4,
        recovery = 18,
        advantage = 5,
        disadvantage = -8,
        damage = 28,
        hitstun = 25,
        blockstun = 15
    },
    UPPERCUT = {
        startup = 12,
        active = 6,
        recovery = 25,
        advantage = 8,
        disadvantage = -15,
        damage = 45,
        hitstun = 35,
        blockstun = 20,
        launcher = true
    },
    SPINNING_KICK = {
        startup = 15,
        active = 8,
        recovery = 22,
        advantage = 3,
        disadvantage = -12,
        damage = 35,
        hitstun = 28,
        blockstun = 18,
        areaOfEffect = true
    }
}

-- Advanced hitbox system
local function createAdvancedHitbox(character, moveData, direction)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local hitbox = Instance.new("Part")
    hitbox.Name = "Hitbox"
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = 0.8
    hitbox.BrickColor = BrickColor.new("Really red")
    hitbox.Material = Enum.Material.ForceField
    
    -- Calculate hitbox size and position based on move
    local baseSize = Vector3.new(4, 6, 4)
    if moveData.areaOfEffect then
        baseSize = baseSize * 2
    end
    
    hitbox.Size = baseSize
    hitbox.CFrame = rootPart.CFrame + (direction * 3)
    hitbox.Parent = workspace
    
    -- Store hitbox data
    local hitboxData = {
        part = hitbox,
        owner = character,
        moveData = moveData,
        activeFrames = moveData.active,
        currentFrame = 0,
        hitTargets = {}
    }
    
    return hitboxData
end

-- Advanced frame data processing
local function processFrameData(player, moveType)
    local playerData = playerData[player]
    if not playerData then return end
    
    local frameData = COMBO_FRAME_DATA[moveType]
    if not frameData then return end
    
    playerData.currentMove = {
        type = moveType,
        frameData = frameData,
        currentFrame = 0,
        phase = "STARTUP" -- STARTUP, ACTIVE, RECOVERY
    }
    
    -- Process frame by frame
    spawn(function()
        -- Startup frames
        for frame = 1, frameData.startup do
            playerData.currentMove.currentFrame = frame
            wait(1/60) -- 60 FPS
        end
        
        -- Active frames
        playerData.currentMove.phase = "ACTIVE"
        local hitbox = createAdvancedHitbox(
            player.Character, 
            frameData, 
            player.Character.HumanoidRootPart.CFrame.LookVector
        )
        
        for frame = 1, frameData.active do
            playerData.currentMove.currentFrame = frameData.startup + frame
            if hitbox then
                processHitboxCollision(hitbox)
            end
            wait(1/60)
        end
        
        -- Cleanup hitbox
        if hitbox and hitbox.part then
            hitbox.part:Destroy()
        end
        
        -- Recovery frames
        playerData.currentMove.phase = "RECOVERY"
        for frame = 1, frameData.recovery do
            playerData.currentMove.currentFrame = frameData.startup + frameData.active + frame
            wait(1/60)
        end
        
        -- Move complete
        playerData.currentMove = nil
        playerData.state = COMBAT_STATES.IDLE
    end)
end

-- Advanced hitbox collision detection
function processHitboxCollision(hitboxData)
    if not hitboxData or not hitboxData.part then return end
    
    local hitbox = hitboxData.part
    local owner = hitboxData.owner
    
    -- Check collision with all players
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character ~= owner and 
           player.Character:FindFirstChild("HumanoidRootPart") then
            
            local targetRoot = player.Character.HumanoidRootPart
            local distance = (hitbox.Position - targetRoot.Position).Magnitude
            
            -- Check if within hitbox range
            if distance <= (hitbox.Size.Magnitude / 2) and 
               not table.find(hitboxData.hitTargets, player) then
                
                -- Add to hit targets to prevent multi-hitting
                table.insert(hitboxData.hitTargets, player)
                
                -- Apply damage and effects
                local damage = hitboxData.moveData.damage
                applyDamageToPlayer(player, damage, hitboxData.moveData.type or "Unknown")
                
                -- Apply hitstun
                applyHitstun(player, hitboxData.moveData.hitstun)
                
                -- Apply launcher effect
                if hitboxData.moveData.launcher then
                    applyLauncher(player, owner)
                end
            end
        end
    end
end

-- Hitstun system
function applyHitstun(player, hitstunFrames)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    playerCombatData.hitstun = hitstunFrames
    playerCombatData.state = COMBAT_STATES.STUNNED
    
    -- Disable movement during hitstun
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = true
    end
    
    -- Process hitstun frame by frame
    spawn(function()
        for frame = 1, hitstunFrames do
            if playerCombatData.hitstun and playerCombatData.hitstun > 0 then
                playerCombatData.hitstun = playerCombatData.hitstun - 1
                wait(1/60)
            else
                break
            end
        end
        
        -- End hitstun
        playerCombatData.hitstun = 0
        playerCombatData.state = COMBAT_STATES.IDLE
        
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = false
        end
    end)
end

-- Launcher system for juggle combos
function applyLauncher(player, attacker)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local launchForce = Vector3.new(0, 100, 0)
    applyPhysicsBasedKnockback(character, launchForce, 1.5)
    
    local playerCombatData = playerData[player]
    if playerCombatData then
        playerCombatData.state = COMBAT_STATES.AIRBORNE
        playerCombatData.airborneTime = tick()
        playerCombatData.launcher = attacker
    end
end

-- Advanced air combo system
local function processAirCombo(player, target)
    local targetData = playerData[target]
    if not targetData or targetData.state ~= COMBAT_STATES.AIRBORNE then return false end
    
    local airTime = tick() - (targetData.airborneTime or 0)
    if airTime > 3.0 then return false end -- Air combo window expired
    
    -- Air combo damage scaling
    local airComboCount = targetData.airComboCount or 0
    airComboCount = airComboCount + 1
    targetData.airComboCount = airComboCount
    
    local damageScaling = math.max(0.3, 1 - (airComboCount * 0.15))
    return damageScaling
end

-- Wall bounce system
function checkWallBounce(character, knockbackDirection)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local raycast = workspace:Raycast(
        rootPart.Position,
        knockbackDirection * 10,
        RaycastParams.new()
    )
    
    if raycast and raycast.Distance < 8 then
        -- Wall bounce
        local bounceDirection = knockbackDirection:Reflect(raycast.Normal)
        applyPhysicsBasedKnockback(character, bounceDirection * 30, 1.0)
        
        -- Wall bounce recovery frames
        local player = Players:GetPlayerFromCharacter(character)
        if player and playerData[player] then
            playerData[player].wallBounceRecovery = 30 -- frames
        end
        
        return true
    end
    
    return false
end

-- Ground bounce system
function checkGroundBounce(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local raycast = workspace:Raycast(
        rootPart.Position,
        Vector3.new(0, -10, 0),
        RaycastParams.new()
    )
    
    if raycast and raycast.Distance < 3 then
        -- Ground bounce
        applyPhysicsBasedKnockback(character, Vector3.new(0, 25, 0), 0.5)
        
        local player = Players:GetPlayerFromCharacter(character)
        if player and playerData[player] then
            playerData[player].groundBounceCount = (playerData[player].groundBounceCount or 0) + 1
        end
        
        return true
    end
    
    return false
end

-- Advanced canceling system
local CANCEL_SYSTEM = {
    LIGHT_PUNCH = {
        canCancelInto = {"HEAVY_PUNCH", "SPECIAL_MOVE", "BLOCK"},
        cancelWindows = {
            {startFrame = 8, endFrame = 12},
            {startFrame = 15, endFrame = 18}
        }
    },
    HEAVY_PUNCH = {
        canCancelInto = {"SPECIAL_MOVE", "ULTIMATE"},
        cancelWindows = {
            {startFrame = 20, endFrame = 25}
        }
    },
    SPECIAL_MOVE = {
        canCancelInto = {"ULTIMATE", "DASH"},
        cancelWindows = {
            {startFrame = 30, endFrame = 35}
        }
    }
}

-- Check if move can be canceled
function checkMoveCancel(player, currentMove, newMove)
    local playerCombatData = playerData[player]
    if not playerCombatData or not currentMove then return false end
    
    local cancelData = CANCEL_SYSTEM[currentMove]
    if not cancelData then return false end
    
    -- Check if new move is allowed
    if not table.find(cancelData.canCancelInto, newMove) then return false end
    
    -- Check cancel windows
    local currentFrame = playerCombatData.currentMove.currentFrame
    for _, window in pairs(cancelData.cancelWindows) do
        if currentFrame >= window.startFrame and currentFrame <= window.endFrame then
            return true
        end
    end
    
    return false
end

-- Advanced meter system
local METER_SYSTEM = {
    MAX_METER = 1000,
    METER_GAIN = {
        GIVE_DAMAGE = 15,
        TAKE_DAMAGE = 25,
        BLOCK = 5,
        PERFECT_BLOCK = 20,
        COMBO_HIT = 10,
        SPECIAL_MOVE = -250,
        ULTIMATE = -500
    }
}

-- Update meter for player
function updateMeter(player, action, amount)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    local meterGain = METER_SYSTEM.METER_GAIN[action] or 0
    if amount then
        meterGain = meterGain * amount
    end
    
    playerCombatData.meter = math.max(0, 
        math.min(METER_SYSTEM.MAX_METER, 
        (playerCombatData.meter or 0) + meterGain))
    
    -- Notify clients of meter change
    local meterEvent = remoteEvents:FindFirstChild("MeterUpdateEvent")
    if not meterEvent then
        meterEvent = Instance.new("RemoteEvent")
        meterEvent.Name = "MeterUpdateEvent"
        meterEvent.Parent = remoteEvents
    end
    
    meterEvent:FireAllClients(player, playerCombatData.meter)
end

-- Advanced guard system with guard crush
local GUARD_SYSTEM = {
    MAX_GUARD_HEALTH = 100,
    GUARD_REGEN_RATE = 2,
    GUARD_DAMAGE = {
        LIGHT = 5,
        HEAVY = 15,
        SPECIAL = 25,
        ULTIMATE = 50
    },
    GUARD_CRUSH_STUN = 120 -- frames
}

-- Process guard damage
function processGuardDamage(player, attackType)
    local playerCombatData = playerData[player]
    if not playerCombatData then return false end
    
    if not playerCombatData.isBlocking then return false end
    
    local guardDamage = GUARD_SYSTEM.GUARD_DAMAGE[attackType] or 0
    playerCombatData.guardHealth = math.max(0, 
        (playerCombatData.guardHealth or GUARD_SYSTEM.MAX_GUARD_HEALTH) - guardDamage)
    
    -- Check for guard crush
    if playerCombatData.guardHealth <= 0 then
        applyGuardCrush(player)
        return false -- Guard broken, attack connects
    end
    
    return true -- Attack blocked
end

-- Apply guard crush
function applyGuardCrush(player)
    local playerCombatData = playerData[player]
    if not playerCombatData then return end
    
    playerCombatData.isBlocking = false
    playerCombatData.guardHealth = 0
    playerCombatData.state = COMBAT_STATES.STUNNED
    
    -- Apply guard crush stun
    applyHitstun(player, GUARD_SYSTEM.GUARD_CRUSH_STUN)
    
    print(player.Name .. "'s guard has been crushed!")
end

-- Counter hit system
function checkCounterHit(attacker, target)
    local targetData = playerData[target]
    if not targetData then return false end
    
    -- Counter hit occurs when hitting during startup or recovery
    if targetData.currentMove and 
       (targetData.currentMove.phase == "STARTUP" or 
        targetData.currentMove.phase == "RECOVERY") then
        return true
    end
    
    return false
end

-- Apply counter hit bonus
function applyCounterHitBonus(damage, hitstun)
    return math.floor(damage * 1.25), math.floor(hitstun * 1.5)
end

-- Throw system
local THROW_SYSTEM = {
    RANGE = 4,
    STARTUP = 5,
    DAMAGE = 40,
    THROW_IMMUNITY_FRAMES = 10
}

function attemptThrow(attacker, target)
    local attackerData = playerData[attacker]
    local targetData = playerData[target]
    
    if not attackerData or not targetData then return false end
    
    -- Check range
    if not CombatUtils.isInAttackRange(attacker, target, THROW_SYSTEM.RANGE) then
        return false
    end
    
    -- Check if target is throwable
    if targetData.state == COMBAT_STATES.AIRBORNE or
       targetData.throwImmunity and 
       tick() - targetData.throwImmunity < (THROW_SYSTEM.THROW_IMMUNITY_FRAMES / 60) then
        return false
    end
    
    -- Check for throw tech (both players throwing at same time)
    if targetData.attemptingThrow and 
       math.abs(attackerData.throwStartTime - targetData.throwStartTime) < 0.1 then
        -- Throw tech - both players pushed apart
        local direction = (target.Character.HumanoidRootPart.Position - 
                          attacker.Character.HumanoidRootPart.Position).Unit
        applyPhysicsBasedKnockback(attacker.Character, -direction * 20, 0.5)
        applyPhysicsBasedKnockback(target.Character, direction * 20, 0.5)
        
        attackerData.attemptingThrow = false
        targetData.attemptingThrow = false
        
        return false
    end
    
    -- Execute throw
    executeThrow(attacker, target)
    return true
end

function executeThrow(attacker, target)
    local attackerData = playerData[attacker]
    local targetData = playerData[target]
    
    -- Set throw states
    attackerData.state = COMBAT_STATES.ATTACKING
    targetData.state = COMBAT_STATES.STUNNED
    
    -- Position target for throw animation
    local attackerChar = attacker.Character
    local targetChar = target.Character
    
    if attackerChar and targetChar then
        local throwPosition = attackerChar.HumanoidRootPart.CFrame + 
                             attackerChar.HumanoidRootPart.CFrame.LookVector * 2
        targetChar.HumanoidRootPart.CFrame = throwPosition
        
        -- Apply throw damage
        applyDamageToPlayer(target, THROW_SYSTEM.DAMAGE, "Throw")
        
        -- Launch target
        spawn(function()
            wait(0.5) -- Throw animation time
            local launchDirection = attackerChar.HumanoidRootPart.CFrame.LookVector
            applyPhysicsBasedKnockback(targetChar, launchDirection * 40 + Vector3.new(0, 25, 0), 1.0)
            
            -- Grant throw immunity
            targetData.throwImmunity = tick()
            targetData.state = COMBAT_STATES.AIRBORNE
            attackerData.state = COMBAT_STATES.IDLE
        end)
    end
end

-- Reset system for neutral game
function resetToNeutral()
    for player, combatData in pairs(playerData) do
        if combatData.state ~= COMBAT_STATES.IDLE then
            combatData.state = COMBAT_STATES.IDLE
            combatData.comboCount = 0
            combatData.airComboCount = 0
            combatData.currentMove = nil
            combatData.hitstun = 0
            
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.PlatformStand = false
            end
        end
    end
end

-- Advanced training mode with frame display
local TRAINING_MODE = {
    enabled = false,
    frameDisplay = true,
    hitboxDisplay = true,
    damageDisplay = true,
    inputDisplay = true
}

function toggleTrainingMode(enabled)
    TRAINING_MODE.enabled = enabled
    
    if enabled then
        print("Training mode enabled - Advanced frame data and hitbox visualization active")
    else
        print("Training mode disabled")
    end
end

-- Netcode and rollback system simulation
local NETCODE_SYSTEM = {
    maxRollbackFrames = 8,
    inputDelay = 2,
    frameHistory = {},
    inputHistory = {}
}

function saveGameState(frame)
    if not NETCODE_SYSTEM.frameHistory[frame] then
        NETCODE_SYSTEM.frameHistory[frame] = {}
    end
    
    -- Save player states
    for player, combatData in pairs(playerData) do
        NETCODE_SYSTEM.frameHistory[frame][player] = {
            health = combatData.health,
            position = player.Character and player.Character.HumanoidRootPart.Position or Vector3.new(),
            state = combatData.state,
            meter = combatData.meter,
            comboCount = combatData.comboCount
        }
    end
    
    -- Cleanup old frames
    for oldFrame, _ in pairs(NETCODE_SYSTEM.frameHistory) do
        if frame - oldFrame > NETCODE_SYSTEM.maxRollbackFrames then
            NETCODE_SYSTEM.frameHistory[oldFrame] = nil
        end
    end
end

-- Tournament mode with advanced match management
local TOURNAMENT_MODE = {
    active = false,
    brackets = {},
    currentMatches = {},
    spectators = {},
    broadcastMode = false
}

function initializeTournament(players)
    TOURNAMENT_MODE.active = true
    TOURNAMENT_MODE.brackets = createTournamentBracket(players)
    
    print("Tournament initialized with " .. #players .. " players")
end

function createTournamentBracket(players)
    local bracket = {}
    local numPlayers = #players
    
    -- Create first round matchups
    for i = 1, numPlayers, 2 do
        if players[i + 1] then
            table.insert(bracket, {
                player1 = players[i],
                player2 = players[i + 1],
                winner = nil,
                round = 1
            })
        end
    end
    
    return bracket
end

print("Advanced Combat System loaded successfully with AI, weapons, elements, physics, frame data, and tournament features!")

return CombatSystem