-- Combat UI - Shows health, controls, and combat feedback
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for remote events
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local damageEvent = remoteEvents:WaitForChild("DamageEvent")
local comboEvent = remoteEvents:WaitForChild("ComboEvent")

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatUI"
screenGui.Parent = playerGui

-- Health Bar Frame
local healthFrame = Instance.new("Frame")
healthFrame.Name = "HealthFrame"
healthFrame.Size = UDim2.new(0, 300, 0, 40)
healthFrame.Position = UDim2.new(0, 20, 0, 20)
healthFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
healthFrame.BorderSizePixel = 2
healthFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
healthFrame.Parent = screenGui

local healthBar = Instance.new("Frame")
healthBar.Name = "HealthBar"
healthBar.Size = UDim2.new(1, -4, 1, -4)
healthBar.Position = UDim2.new(0, 2, 0, 2)
healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthFrame

local healthLabel = Instance.new("TextLabel")
healthLabel.Name = "HealthLabel"
healthLabel.Size = UDim2.new(1, 0, 1, 0)
healthLabel.Position = UDim2.new(0, 0, 0, 0)
healthLabel.BackgroundTransparency = 1
healthLabel.Text = "Health: 100"
healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
healthLabel.TextScaled = true
healthLabel.Font = Enum.Font.GothamBold
healthLabel.Parent = healthFrame

-- Combo Counter
local comboFrame = Instance.new("Frame")
comboFrame.Name = "ComboFrame"
comboFrame.Size = UDim2.new(0, 200, 0, 60)
comboFrame.Position = UDim2.new(0, 20, 0, 80)
comboFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
comboFrame.BorderSizePixel = 2
comboFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
comboFrame.Visible = false
comboFrame.Parent = screenGui

local comboLabel = Instance.new("TextLabel")
comboLabel.Name = "ComboLabel"
comboLabel.Size = UDim2.new(1, 0, 0.6, 0)
comboLabel.Position = UDim2.new(0, 0, 0, 0)
comboLabel.BackgroundTransparency = 1
comboLabel.Text = "0 HIT COMBO"
comboLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
comboLabel.TextScaled = true
comboLabel.Font = Enum.Font.GothamBold
comboLabel.Parent = comboFrame

local comboRankLabel = Instance.new("TextLabel")
comboRankLabel.Name = "ComboRankLabel"
comboRankLabel.Size = UDim2.new(1, 0, 0.4, 0)
comboRankLabel.Position = UDim2.new(0, 0, 0.6, 0)
comboRankLabel.BackgroundTransparency = 1
comboRankLabel.Text = ""
comboRankLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
comboRankLabel.TextScaled = true
comboRankLabel.Font = Enum.Font.GothamBold
comboRankLabel.Parent = comboFrame

-- Controls Frame
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "ControlsFrame"
controlsFrame.Size = UDim2.new(0, 250, 0, 200)
controlsFrame.Position = UDim2.new(1, -270, 1, -220)
controlsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
controlsFrame.BackgroundTransparency = 0.3
controlsFrame.BorderSizePixel = 1
controlsFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
controlsFrame.Parent = screenGui

local controlsTitle = Instance.new("TextLabel")
controlsTitle.Name = "ControlsTitle"
controlsTitle.Size = UDim2.new(1, 0, 0, 25)
controlsTitle.Position = UDim2.new(0, 0, 0, 0)
controlsTitle.BackgroundTransparency = 1
controlsTitle.Text = "COMBAT CONTROLS"
controlsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
controlsTitle.TextScaled = true
controlsTitle.Font = Enum.Font.GothamBold
controlsTitle.Parent = controlsFrame

local controlsList = Instance.new("TextLabel")
controlsList.Name = "ControlsList"
controlsList.Size = UDim2.new(1, -10, 1, -30)
controlsList.Position = UDim2.new(0, 5, 0, 25)
controlsList.BackgroundTransparency = 1
controlsList.Text = [[Q - Light Punch
E - Heavy Punch
F - Block (Hold)
R - Uppercut Special
T - Spinning Kick Special
Y - Devastator Special

WASD - Move
Space - Jump]]
controlsList.TextColor3 = Color3.fromRGB(200, 200, 200)
controlsList.TextSize = 14
controlsList.Font = Enum.Font.Gotham
controlsList.TextXAlignment = Enum.TextXAlignment.Left
controlsList.TextYAlignment = Enum.TextYAlignment.Top
controlsList.Parent = controlsFrame

-- Damage feedback
local damageFrame = Instance.new("Frame")
damageFrame.Name = "DamageFrame"
damageFrame.Size = UDim2.new(0, 200, 0, 50)
damageFrame.Position = UDim2.new(0.5, -100, 0.3, 0)
damageFrame.BackgroundTransparency = 1
damageFrame.Parent = screenGui

local damageLabel = Instance.new("TextLabel")
damageLabel.Name = "DamageLabel"
damageLabel.Size = UDim2.new(1, 0, 1, 0)
damageLabel.Position = UDim2.new(0, 0, 0, 0)
damageLabel.BackgroundTransparency = 1
damageLabel.Text = ""
damageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
damageLabel.TextScaled = true
damageLabel.Font = Enum.Font.GothamBold
damageLabel.TextStrokeTransparency = 0
damageLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
damageLabel.Parent = damageFrame

-- Arena info
local arenaFrame = Instance.new("Frame")
arenaFrame.Name = "ArenaFrame"
arenaFrame.Size = UDim2.new(0, 200, 0, 30)
arenaFrame.Position = UDim2.new(0.5, -100, 0, 20)
arenaFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
arenaFrame.BackgroundTransparency = 0.5
arenaFrame.BorderSizePixel = 0
arenaFrame.Parent = screenGui

local arenaLabel = Instance.new("TextLabel")
arenaLabel.Name = "ArenaLabel"
arenaLabel.Size = UDim2.new(1, 0, 1, 0)
arenaLabel.Position = UDim2.new(0, 0, 0, 0)
arenaLabel.BackgroundTransparency = 1
arenaLabel.Text = "FIGHTING ARENA"
arenaLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
arenaLabel.TextScaled = true
arenaLabel.Font = Enum.Font.GothamBold
arenaLabel.Parent = arenaFrame

-- Variables
local currentHealth = 100
local maxHealth = 100
local comboHideTime = 0

-- Update health display
local function updateHealth(health)
    currentHealth = health
    local healthPercent = currentHealth / maxHealth
    
    -- Update health bar
    healthBar.Size = UDim2.new(healthPercent, -4, 1, -4)
    
    -- Change color based on health
    if healthPercent > 0.6 then
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
    elseif healthPercent > 0.3 then
        healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
    else
        healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
    end
    
    healthLabel.Text = "Health: " .. math.floor(currentHealth) .. "/" .. maxHealth
end

-- Show damage feedback
local function showDamage(damage, attackType)
    damageLabel.Text = "-" .. damage .. " " .. (attackType or "")
    damageLabel.TextTransparency = 0
    
    -- Animate damage text
    local tween = game:GetService("TweenService"):Create(
        damageLabel,
        TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0, 0, -0.2, 0),
            TextTransparency = 1
        }
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        damageLabel.Position = UDim2.new(0, 0, 0, 0)
    end)
end

-- Update combo display
local function updateCombo(comboCount, comboRank)
    if comboCount > 0 then
        comboFrame.Visible = true
        comboLabel.Text = comboCount .. " HIT COMBO"
        comboRankLabel.Text = comboRank or ""
        
        comboHideTime = tick() + 3 -- Hide after 3 seconds of no combos
    else
        comboFrame.Visible = false
    end
end

-- Hide combo after timeout
spawn(function()
    while true do
        wait(0.1)
        if comboFrame.Visible and tick() > comboHideTime then
            comboFrame.Visible = false
        end
    end
end)

-- Connect to server events
damageEvent.OnClientEvent:Connect(function(targetPlayer, newHealth, damage, attackType)
    if targetPlayer == player then
        updateHealth(newHealth)
        showDamage(damage, attackType)
    end
end)

comboEvent.OnClientEvent:Connect(function(playerName, comboCount, comboRank)
    if Players:FindFirstChild(playerName) == player then
        updateCombo(comboCount, comboRank)
    end
end)

-- Toggle controls visibility
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.H then
        controlsFrame.Visible = not controlsFrame.Visible
    end
end)

-- Initial setup
updateHealth(100)

print("Combat UI loaded! Press H to toggle controls.")