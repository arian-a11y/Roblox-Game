-- Server-side combat system manager
-- Handles player combat validation and state management

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Import combat utilities
local CombatUtils = require(ReplicatedStorage:WaitForChild("CombatUtils"))

-- Create RemoteEvents for client-server communication
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

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

-- Player data storage
local playerData = {}

-- Initialize player data when they join
local function onPlayerAdded(player)
    playerData[player] = CombatUtils.createCombatState()
    playerData[player].player = player
end

-- Clean up when player leaves
local function onPlayerRemoving(player)
    playerData[player] = nil
end

-- Handle light punch attacks
local function onPunchEvent(player, targetPlayer, attackType)
    if not playerData[player] or not playerData[targetPlayer] then return end
    if not CombatUtils.isInAttackRange(player, targetPlayer) then return end
    
    local currentTime = tick()
    local isValid, message = CombatUtils.validateCombatAction(
        player, 
        "punch", 
        playerData[player].lastActionTime, 
        playerData[player].comboCount
    )
    
    if not isValid then
        warn(player.Name .. ": " .. message)
        return
    end
    
    -- Calculate damage
    local baseDamage = CombatUtils.BASE_PUNCH_DAMAGE
    local finalDamage = CombatUtils.calculateDamage(
        baseDamage,
        playerData[targetPlayer].isBlocking,
        playerData[player].comboCount,
        "light"
    )
    
    -- Apply damage
    playerData[targetPlayer].health = math.max(0, playerData[targetPlayer].health - finalDamage)
    playerData[player].lastActionTime = currentTime
    
    -- Update combo system
    if not playerData[targetPlayer].isBlocking then
        playerData[player].comboCount = CombatUtils.updateCombo(
            playerData[player].comboCount,
            playerData[player].lastHitTime,
            currentTime
        )
        playerData[player].lastHitTime = currentTime
        
        -- Check for combo rank
        local comboRank, comboColor = CombatUtils.getComboRank(playerData[player].comboCount)
        if comboRank then
            comboEvent:FireAllClients(player.Name, playerData[player].comboCount, comboRank)
        end
    else
        playerData[player].comboCount = 0
    end
    
    -- Send damage update to all clients
    damageEvent:FireAllClients(targetPlayer, playerData[targetPlayer].health, finalDamage, "light punch")
    
    print(player.Name .. " light punched " .. targetPlayer.Name .. " for " .. finalDamage .. " damage (Combo: " .. playerData[player].comboCount .. ")")
end

-- Handle heavy punch attacks
local function onHeavyPunchEvent(player, targetPlayer, attackType)
    if not playerData[player] or not playerData[targetPlayer] then return end
    if not CombatUtils.isInAttackRange(player, targetPlayer) then return end
    
    local currentTime = tick()
    local isValid, message = CombatUtils.validateCombatAction(
        player, 
        "heavy", 
        playerData[player].lastActionTime, 
        playerData[player].comboCount
    )
    
    if not isValid then
        warn(player.Name .. ": " .. message)
        return
    end
    
    -- Calculate damage
    local baseDamage = CombatUtils.HEAVY_PUNCH_DAMAGE
    local finalDamage = CombatUtils.calculateDamage(
        baseDamage,
        playerData[targetPlayer].isBlocking,
        playerData[player].comboCount,
        "heavy"
    )
    
    -- Apply damage
    playerData[targetPlayer].health = math.max(0, playerData[targetPlayer].health - finalDamage)
    playerData[player].lastActionTime = currentTime
    
    -- Heavy attacks can break combos or continue them
    if CombatUtils.isComboBreaker("heavy", playerData[player].comboCount) then
        playerData[player].comboCount = 0
    else
        playerData[player].comboCount = CombatUtils.updateCombo(
            playerData[player].comboCount,
            playerData[player].lastHitTime,
            currentTime
        )
        playerData[player].lastHitTime = currentTime
    end
    
    -- Send damage update to all clients
    damageEvent:FireAllClients(targetPlayer, playerData[targetPlayer].health, finalDamage, "heavy punch")
    
    print(player.Name .. " heavy punched " .. targetPlayer.Name .. " for " .. finalDamage .. " damage")
end

-- Handle special move attacks
local function onSpecialMoveEvent(player, targetPlayer, moveType)
    if not playerData[player] or not playerData[targetPlayer] then return end
    if not CombatUtils.isInAttackRange(player, targetPlayer) then return end
    
    local currentTime = tick()
    local canUse, message = CombatUtils.canUseSpecialMove(
        moveType,
        playerData[player].comboCount,
        playerData[player].lastSpecialTime,
        currentTime
    )
    
    if not canUse then
        warn(player.Name .. ": " .. message)
        return
    end
    
    local specialData = CombatUtils.SPECIAL_MOVES[moveType]
    local finalDamage = CombatUtils.calculateDamage(
        specialData.damage,
        playerData[targetPlayer].isBlocking,
        playerData[player].comboCount,
        "special"
    )
    
    -- Apply damage
    playerData[targetPlayer].health = math.max(0, playerData[targetPlayer].health - finalDamage)
    playerData[player].lastSpecialTime = currentTime
    playerData[player].lastActionTime = currentTime
    
    -- Special moves reset combo but provide massive damage
    playerData[player].comboCount = 0
    
    -- Send damage update to all clients
    damageEvent:FireAllClients(targetPlayer, playerData[targetPlayer].health, finalDamage, moveType)
    
    print(player.Name .. " used " .. moveType .. " on " .. targetPlayer.Name .. " for " .. finalDamage .. " damage!")
end

-- Handle blocking
local function onBlockEvent(player, isBlocking)
    if not playerData[player] then return end
    
    playerData[player].isBlocking = isBlocking
    print(player.Name .. (isBlocking and " started blocking" or " stopped blocking"))
end

-- Connect events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
punchEvent.OnServerEvent:Connect(onPunchEvent)
heavyPunchEvent.OnServerEvent:Connect(onHeavyPunchEvent)
specialMoveEvent.OnServerEvent:Connect(onSpecialMoveEvent)
blockEvent.OnServerEvent:Connect(onBlockEvent)

print("Combat system loaded successfully!")