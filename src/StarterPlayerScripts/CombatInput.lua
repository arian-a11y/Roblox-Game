-- Client-side input handler for fighting game
-- Manages player input and sends combat commands to server

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Wait for RemoteEvents to be created by server
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local punchEvent = remoteEvents:WaitForChild("PunchEvent")
local heavyPunchEvent = remoteEvents:WaitForChild("HeavyPunchEvent")
local specialMoveEvent = remoteEvents:WaitForChild("SpecialMoveEvent")
local blockEvent = remoteEvents:WaitForChild("BlockEvent")
local damageEvent = remoteEvents:WaitForChild("DamageEvent")
local comboEvent = remoteEvents:WaitForChild("ComboEvent")

-- Get combat utilities
local CombatUtils = require(ReplicatedStorage:WaitForChild("CombatUtils"))

-- Input variables
local isBlocking = false
local lastPunchTime = 0
local lastHeavyTime = 0
local lastSpecialTime = 0
local comboSequence = {}
local maxSequenceLength = 4

-- Combat settings
local PUNCH_COOLDOWN = 0.5
local HEAVY_COOLDOWN = 1.2
local PUNCH_RANGE = 20

-- Find the closest enemy player
local function findClosestEnemy()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local myPosition = character.HumanoidRootPart.Position
    local closestPlayer = nil
    local closestDistance = PUNCH_RANGE
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (myPosition - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    
    return closestPlayer
end

-- Handle punch input
local function onLightPunch()
    local currentTime = tick()
    if currentTime - lastPunchTime < PUNCH_COOLDOWN then
        return -- Still on cooldown
    end
    
    local target = findClosestEnemy()
    if target then
        punchEvent:FireServer(target, "light")
        lastPunchTime = currentTime
        
        -- Add to combo sequence
        table.insert(comboSequence, "light")
        if #comboSequence > maxSequenceLength then
            table.remove(comboSequence, 1)
        end
        
        print("Light punch on " .. target.Name)
    else
        print("No target in range!")
    end
end

-- Handle heavy punch input
local function onHeavyPunch()
    local currentTime = tick()
    if currentTime - lastHeavyTime < HEAVY_COOLDOWN then
        return -- Still on cooldown
    end
    
    local target = findClosestEnemy()
    if target then
        heavyPunchEvent:FireServer(target, "heavy")
        lastHeavyTime = currentTime
        
        -- Add to combo sequence
        table.insert(comboSequence, "heavy")
        if #comboSequence > maxSequenceLength then
            table.remove(comboSequence, 1)
        end
        
        print("Heavy punch on " .. target.Name)
    else
        print("No target in range!")
    end
end

-- Handle special move input
local function onSpecialMove(moveType)
    local currentTime = tick()
    if currentTime - lastSpecialTime < CombatUtils.SPECIAL_MOVES[moveType].cooldown then
        return -- Still on cooldown
    end
    
    local target = findClosestEnemy()
    if target then
        specialMoveEvent:FireServer(target, moveType)
        lastSpecialTime = currentTime
        print("Special move " .. moveType .. " on " .. target.Name)
    else
        print("No target in range!")
    end
end

-- Check for special move combos
local function checkSpecialCombo()
    if #comboSequence >= 3 then
        -- Uppercut combo: light, light, heavy
        if comboSequence[#comboSequence-2] == "light" and 
           comboSequence[#comboSequence-1] == "light" and 
           comboSequence[#comboSequence] == "heavy" then
            onSpecialMove("UPPERCUT")
            return true
        end
        
        -- Spinning kick combo: heavy, light, heavy
        if comboSequence[#comboSequence-2] == "heavy" and 
           comboSequence[#comboSequence-1] == "light" and 
           comboSequence[#comboSequence] == "heavy" then
            onSpecialMove("SPINNING_KICK")
            return true
        end
    end
    
    if #comboSequence >= 4 then
        -- Devastator combo: light, heavy, light, heavy
        if comboSequence[#comboSequence-3] == "light" and 
           comboSequence[#comboSequence-2] == "heavy" and 
           comboSequence[#comboSequence-1] == "light" and 
           comboSequence[#comboSequence] == "heavy" then
            onSpecialMove("DEVASTATOR")
            return true
        end
    end
    
    return false
end

-- Handle block input
local function onBlockStart()
    if not isBlocking then
        isBlocking = true
        blockEvent:FireServer(true)
        print("Started blocking")
    end
end

local function onBlockEnd()
    if isBlocking then
        isBlocking = false
        blockEvent:FireServer(false)
        print("Stopped blocking")
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        onLightPunch()
        checkSpecialCombo()
    elseif input.KeyCode == Enum.KeyCode.E then
        onHeavyPunch()
        checkSpecialCombo()
    elseif input.KeyCode == Enum.KeyCode.F then
        onBlockStart()
    elseif input.KeyCode == Enum.KeyCode.R then
        onSpecialMove("UPPERCUT")
    elseif input.KeyCode == Enum.KeyCode.T then
        onSpecialMove("SPINNING_KICK")
    elseif input.KeyCode == Enum.KeyCode.Y then
        onSpecialMove("DEVASTATOR")
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        onBlockEnd()
    end
end)

-- Handle damage events from server
damageEvent.OnClientEvent:Connect(function(targetPlayer, newHealth, damage, attackType)
    if targetPlayer == player then
        print("You took " .. damage .. " damage from " .. (attackType or "attack") .. "! Health: " .. newHealth)
        -- Here you would update the health UI
    else
        print(targetPlayer.Name .. " took " .. damage .. " damage from " .. (attackType or "attack") .. "!")
    end
end)

-- Handle combo events from server
comboEvent.OnClientEvent:Connect(function(playerName, comboCount, comboRank)
    if comboRank then
        print(playerName .. " achieved " .. comboRank .. " with " .. comboCount .. " hits!")
    else
        print(playerName .. " combo: " .. comboCount .. " hits")
    end
    -- Here you would update the combo UI
end)

print("Combat input system loaded!")