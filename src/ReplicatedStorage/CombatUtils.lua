-- Shared combat utilities and constants
-- This ModuleScript contains shared functions and data used by both client and server

local CombatUtils = {}

-- Combat constants
CombatUtils.MAX_HEALTH = 100
CombatUtils.BASE_PUNCH_DAMAGE = 10
CombatUtils.HEAVY_PUNCH_DAMAGE = 18
CombatUtils.BLOCK_DAMAGE_REDUCTION = 0.7
CombatUtils.PARRY_WINDOW = 0.3  -- Perfect parry timing window
CombatUtils.PARRY_DAMAGE_REFLECTION = 0.5  -- Damage reflected on perfect parry
CombatUtils.PUNCH_COOLDOWN = 0.5
CombatUtils.HEAVY_COOLDOWN = 1.2
CombatUtils.PUNCH_RANGE = 20
CombatUtils.COMBO_MULTIPLIER = 1.1

-- Combo system constants
CombatUtils.COMBO_WINDOW = 3.0  -- Time window to continue combo (seconds)
CombatUtils.MAX_COMBO_COUNT = 10
CombatUtils.COMBO_DAMAGE_BONUS = 0.15  -- 15% per combo hit
CombatUtils.COMBO_RESET_TIME = 2.0  -- Time before combo resets

-- Stamina system
CombatUtils.MAX_STAMINA = 100
CombatUtils.STAMINA_REGEN_RATE = 20  -- Stamina per second
CombatUtils.DODGE_STAMINA_COST = 25
CombatUtils.SPECIAL_STAMINA_COST = 40
CombatUtils.BLOCK_STAMINA_COST = 5

-- Special moves
CombatUtils.SPECIAL_MOVES = {
    UPPERCUT = {
        damage = 25,
        cooldown = 5.0,
        range = 15,
        comboRequirement = 3,
        staminaCost = 30
    },
    SPINNING_KICK = {
        damage = 30,
        cooldown = 7.0,
        range = 25,
        comboRequirement = 5,
        staminaCost = 40
    },
    DEVASTATOR = {
        damage = 50,
        cooldown = 15.0,
        range = 20,
        comboRequirement = 8,
        staminaCost = 60
    }
}

-- Enhanced damage calculation with combo system
function CombatUtils.calculateDamage(baseDamage, isBlocking, comboCount, attackType)
    local damage = baseDamage
    
    -- Apply combo multiplier (exponential growth)
    if comboCount > 0 then
        local comboBonus = math.min(comboCount * CombatUtils.COMBO_DAMAGE_BONUS, 2.0) -- Cap at 200% bonus
        damage = damage * (1 + comboBonus)
    end
    
    -- Special attack type modifiers
    if attackType == "heavy" then
        damage = damage * 1.5
    elseif attackType == "special" then
        damage = damage * 2.0
    end
    
    -- Apply blocking reduction
    if isBlocking then
        damage = damage * (1 - CombatUtils.BLOCK_DAMAGE_REDUCTION)
    end
    
    return math.floor(damage)
end

-- Combo system functions
function CombatUtils.updateCombo(currentCombo, lastHitTime, currentTime)
    local timeSinceLastHit = currentTime - (lastHitTime or 0)
    
    -- Reset combo if too much time has passed
    if timeSinceLastHit > CombatUtils.COMBO_WINDOW then
        return 0
    end
    
    -- Increment combo (with max limit)
    return math.min(currentCombo + 1, CombatUtils.MAX_COMBO_COUNT)
end

function CombatUtils.getComboMultiplier(comboCount)
    if comboCount <= 0 then
        return 1.0
    end
    return 1 + (comboCount * CombatUtils.COMBO_DAMAGE_BONUS)
end

function CombatUtils.isComboBreaker(attackType, comboCount)
    -- Heavy attacks and blocks can break combos
    if attackType == "heavy" or attackType == "block" then
        return true
    end
    
    -- High combos have a chance to be broken
    if comboCount >= 7 then
        return math.random() < 0.3  -- 30% chance to break
    end
    
    return false
end

-- Special move validation
function CombatUtils.canUseSpecialMove(moveType, comboCount, lastSpecialTime, currentTime, stamina)
    local move = CombatUtils.SPECIAL_MOVES[moveType]
    if not move then
        return false, "Unknown special move"
    end
    
    -- Check combo requirement
    if comboCount < move.comboRequirement then
        return false, "Insufficient combo count"
    end
    
    -- Check cooldown
    local timeSinceLastSpecial = currentTime - (lastSpecialTime or 0)
    if timeSinceLastSpecial < move.cooldown then
        return false, "Special move on cooldown"
    end
    
    -- Check stamina
    if stamina < move.staminaCost then
        return false, "Insufficient stamina"
    end
    
    return true, "Can use special move"
end

-- Distance calculation helper
function CombatUtils.getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Check if player is in range for attack
function CombatUtils.isInAttackRange(attacker, target)
    if not attacker.Character or not target.Character then
        return false
    end
    
    local attackerPos = attacker.Character:FindFirstChild("HumanoidRootPart")
    local targetPos = target.Character:FindFirstChild("HumanoidRootPart")
    
    if not attackerPos or not targetPos then
        return false
    end
    
    return CombatUtils.getDistance(attackerPos.Position, targetPos.Position) <= CombatUtils.PUNCH_RANGE
end

-- Enhanced combat action validation
function CombatUtils.validateCombatAction(player, actionType, lastActionTime, comboCount)
    local currentTime = tick()
    local timeSinceLastAction = currentTime - (lastActionTime or 0)
    
    -- Check action-specific cooldowns
    if actionType == "punch" and timeSinceLastAction < CombatUtils.PUNCH_COOLDOWN then
        return false, "Punch on cooldown"
    elseif actionType == "heavy" and timeSinceLastAction < CombatUtils.HEAVY_COOLDOWN then
        return false, "Heavy attack on cooldown"
    end
    
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then
        return false, "Invalid character"
    end
    
    if player.Character.Humanoid.Health <= 0 then
        return false, "Player is defeated"
    end
    
    -- Prevent spam attacks during high combos
    if comboCount and comboCount > 5 and timeSinceLastAction < 0.3 then
        return false, "Combo too fast"
    end
    
    return true, "Valid action"
end

-- Combat state management
function CombatUtils.createCombatState()
    return {
        health = CombatUtils.MAX_HEALTH,
        maxHealth = CombatUtils.MAX_HEALTH,
        stamina = CombatUtils.MAX_STAMINA,
        maxStamina = CombatUtils.MAX_STAMINA,
        comboCount = 0,
        lastHitTime = 0,
        lastActionTime = 0,
        lastSpecialTime = 0,
        lastBlockTime = 0,
        isBlocking = false,
        isPerfectParry = false
    }
end

-- Stamina system functions
function CombatUtils.updateStamina(currentStamina, deltaTime, isRegenerating)
    if isRegenerating then
        return math.min(CombatUtils.MAX_STAMINA, currentStamina + (CombatUtils.STAMINA_REGEN_RATE * deltaTime))
    end
    return currentStamina
end

function CombatUtils.canUseStamina(currentStamina, cost)
    return currentStamina >= cost
end

-- Enhanced defense system
function CombatUtils.checkPerfectParry(blockStartTime, attackTime)
    local timingWindow = math.abs(attackTime - blockStartTime)
    return timingWindow <= CombatUtils.PARRY_WINDOW
end

function CombatUtils.calculateBlockDamage(damage, isBlocking, isPerfectParry)
    if isPerfectParry then
        return 0, damage * CombatUtils.PARRY_DAMAGE_REFLECTION  -- No damage taken, reflect some back
    elseif isBlocking then
        return damage * (1 - CombatUtils.BLOCK_DAMAGE_REDUCTION), 0
    else
        return damage, 0
    end
end

-- Enhanced visual effect data
CombatUtils.EffectData = {
    Punch = {
        particleCount = 10,
        color = Color3.fromRGB(255, 100, 100),
        duration = 0.5,
        size = 2
    },
    HeavyPunch = {
        particleCount = 20,
        color = Color3.fromRGB(255, 50, 50),
        duration = 0.8,
        size = 4
    },
    Block = {
        particleCount = 5,
        color = Color3.fromRGB(100, 100, 255),
        duration = 0.3,
        size = 1.5
    },
    ComboHit = {
        particleCount = 15,
        color = Color3.fromRGB(255, 215, 0),
        duration = 0.6,
        size = 3
    },
    SpecialMove = {
        UPPERCUT = {
            particleCount = 30,
            color = Color3.fromRGB(255, 165, 0),
            duration = 1.0,
            size = 6
        },
        SPINNING_KICK = {
            particleCount = 25,
            color = Color3.fromRGB(138, 43, 226),
            duration = 1.2,
            size = 5
        },
        DEVASTATOR = {
            particleCount = 50,
            color = Color3.fromRGB(220, 20, 60),
            duration = 1.5,
            size = 8
        }
    }
}

-- Combo rank system
CombatUtils.ComboRanks = {
    {min = 3, name = "NICE!", color = Color3.fromRGB(255, 255, 0)},
    {min = 5, name = "GREAT!", color = Color3.fromRGB(255, 165, 0)},
    {min = 7, name = "EXCELLENT!", color = Color3.fromRGB(255, 69, 0)},
    {min = 10, name = "LEGENDARY!", color = Color3.fromRGB(255, 0, 0)}
}

function CombatUtils.getComboRank(comboCount)
    for i = #CombatUtils.ComboRanks, 1, -1 do
        local rank = CombatUtils.ComboRanks[i]
        if comboCount >= rank.min then
            return rank.name, rank.color
        end
    end
    return nil, nil
end

return CombatUtils