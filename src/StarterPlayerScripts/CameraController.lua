-- Dynamic Camera Controller for Fighting Game
-- Provides cinematic camera angles and smooth following for combat

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local CameraController = {}

-- Camera settings
local CAMERA_DISTANCE = 35
local CAMERA_HEIGHT = 15
local CAMERA_SMOOTH_TIME = 0.1
local ZOOM_SPEED = 5
local ROTATION_SPEED = 2

-- Camera state
local cameraMode = "FOLLOW" -- FOLLOW, CINEMATIC, FREE, LOCKED
local targetPlayers = {}
local cameraConnection = nil
local lastCameraUpdate = 0

-- Camera modes
CameraController.Modes = {
    FOLLOW = "Follow players dynamically",
    CINEMATIC = "Cinematic angles for special moves",
    FREE = "Free camera movement",
    LOCKED = "Fixed camera position"
}

-- Initialize camera system
function CameraController.initialize()
    camera.CameraType = Enum.CameraType.Scriptable
    CameraController.setMode("FOLLOW")
    print("Camera controller initialized!")
end

-- Set camera mode
function CameraController.setMode(mode)
    if not CameraController.Modes[mode] then
        warn("Unknown camera mode: " .. tostring(mode))
        return
    end
    
    cameraMode = mode
    
    -- Disconnect previous camera updates
    if cameraConnection then
        cameraConnection:Disconnect()
        cameraConnection = nil
    end
    
    -- Setup new camera mode
    if mode == "FOLLOW" then
        CameraController.setupFollowMode()
    elseif mode == "CINEMATIC" then
        CameraController.setupCinematicMode()
    elseif mode == "FREE" then
        CameraController.setupFreeMode()
    elseif mode == "LOCKED" then
        CameraController.setupLockedMode()
    end
    
    print("Camera mode set to: " .. mode)
end

-- Follow camera mode - tracks players dynamically
function CameraController.setupFollowMode()
    cameraConnection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastCameraUpdate < CAMERA_SMOOTH_TIME then
            return
        end
        lastCameraUpdate = currentTime
        
        local activePlayers = CameraController.getActivePlayers()
        if #activePlayers == 0 then return end
        
        -- Calculate center point between players
        local centerPosition = CameraController.calculateCenterPosition(activePlayers)
        local distance = CameraController.calculateOptimalDistance(activePlayers)
        
        -- Position camera
        local cameraPosition = centerPosition + Vector3.new(0, CAMERA_HEIGHT, distance)
        local lookDirection = (centerPosition - cameraPosition).Unit
        
        -- Smooth camera movement
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.lookAt(cameraPosition, centerPosition)
        
        local smoothCFrame = currentCFrame:Lerp(targetCFrame, 0.1)
        camera.CFrame = smoothCFrame
    end)
end

-- Cinematic camera mode - for special moves and dramatic moments
function CameraController.setupCinematicMode()
    cameraConnection = RunService.Heartbeat:Connect(function()
        -- Cinematic camera will be controlled by special move triggers
        -- This provides a base smooth movement
        local activePlayers = CameraController.getActivePlayers()
        if #activePlayers > 0 then
            local centerPosition = CameraController.calculateCenterPosition(activePlayers)
            
            -- More dynamic angles for cinematic mode
            local angle = tick() * 0.5
            local radius = CAMERA_DISTANCE * 1.5
            local cameraPosition = centerPosition + Vector3.new(
                math.cos(angle) * radius,
                CAMERA_HEIGHT * 1.2,
                math.sin(angle) * radius
            )
            
            local targetCFrame = CFrame.lookAt(cameraPosition, centerPosition)
            camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.05)
        end
    end)
end

-- Free camera mode - manual control
function CameraController.setupFreeMode()
    local moveSpeed = 50
    local rotateSpeed = 0.005
    
    cameraConnection = RunService.Heartbeat:Connect(function(deltaTime)
        local movement = Vector3.new()
        
        -- WASD movement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            movement = movement + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            movement = movement - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            movement = movement - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            movement = movement + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            movement = movement - camera.CFrame.UpVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            movement = movement + camera.CFrame.UpVector
        end
        
        -- Apply movement
        if movement.Magnitude > 0 then
            movement = movement.Unit * moveSpeed * deltaTime
            camera.CFrame = camera.CFrame + movement
        end
    end)
    
    -- Mouse rotation
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and cameraMode == "FREE" then
            local delta = input.Delta
            local rotationX = -delta.Y * rotateSpeed
            local rotationY = -delta.X * rotateSpeed
            
            camera.CFrame = camera.CFrame * CFrame.Angles(rotationX, rotationY, 0)
        end
    end)
end

-- Locked camera mode - fixed position
function CameraController.setupLockedMode()
    -- Camera stays in fixed position, can be set manually
    local fixedPosition = Vector3.new(0, 50, 50)
    local lookAt = Vector3.new(0, 0, 0)
    
    camera.CFrame = CFrame.lookAt(fixedPosition, lookAt)
end

-- Helper functions
function CameraController.getActivePlayers()
    local active = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(active, p)
        end
    end
    return active
end

function CameraController.calculateCenterPosition(players)
    if #players == 0 then return Vector3.new(0, 0, 0) end
    
    local sum = Vector3.new(0, 0, 0)
    for _, player in pairs(players) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            sum = sum + player.Character.HumanoidRootPart.Position
        end
    end
    
    return sum / #players
end

function CameraController.calculateOptimalDistance(players)
    if #players <= 1 then return CAMERA_DISTANCE end
    
    local maxDistance = 0
    local positions = {}
    
    -- Get all player positions
    for _, player in pairs(players) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(positions, player.Character.HumanoidRootPart.Position)
        end
    end
    
    -- Find maximum distance between any two players
    for i = 1, #positions do
        for j = i + 1, #positions do
            local distance = (positions[i] - positions[j]).Magnitude
            maxDistance = math.max(maxDistance, distance)
        end
    end
    
    -- Scale camera distance based on player spread
    return math.max(CAMERA_DISTANCE, maxDistance * 0.8)
end

-- Cinematic effects for special moments
function CameraController.playCinematicSequence(sequenceType, targetPosition, duration)
    local oldMode = cameraMode
    CameraController.setMode("CINEMATIC")
    
    if sequenceType == "SPECIAL_MOVE" then
        -- Dramatic zoom-in for special moves
        local startCFrame = camera.CFrame
        local closeUpPosition = targetPosition + Vector3.new(0, 5, 15)
        local targetCFrame = CFrame.lookAt(closeUpPosition, targetPosition)
        
        local zoomTween = TweenService:Create(
            camera,
            TweenInfo.new(duration * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {CFrame = targetCFrame}
        )
        
        local zoomOutTween = TweenService:Create(
            camera,
            TweenInfo.new(duration * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {CFrame = startCFrame}
        )
        
        zoomTween:Play()
        zoomTween.Completed:Connect(function()
            wait(0.5)
            zoomOutTween:Play()
            zoomOutTween.Completed:Connect(function()
                CameraController.setMode(oldMode)
            end)
        end)
        
    elseif sequenceType == "VICTORY" then
        -- Victory camera sequence
        local centerPos = targetPosition
        local radius = 25
        
        for i = 0, duration, 0.1 do
            local angle = i * 0.5
            local cameraPos = centerPos + Vector3.new(
                math.cos(angle) * radius,
                10 + math.sin(i) * 5,
                math.sin(angle) * radius
            )
            
            camera.CFrame = CFrame.lookAt(cameraPos, centerPos)
            wait(0.1)
        end
        
        CameraController.setMode(oldMode)
        
    elseif sequenceType == "ARENA_REVEAL" then
        -- Arena reveal sequence
        local highPosition = targetPosition + Vector3.new(0, 100, 0)
        local finalPosition = targetPosition + Vector3.new(0, 30, 50)
        
        camera.CFrame = CFrame.lookAt(highPosition, targetPosition)
        
        local revealTween = TweenService:Create(
            camera,
            TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {CFrame = CFrame.lookAt(finalPosition, targetPosition)}
        )
        
        revealTween:Play()
        revealTween.Completed:Connect(function()
            CameraController.setMode(oldMode)
        end)
    end
end

-- Camera shake effect
function CameraController.addScreenShake(intensity, duration)
    local originalCFrame = camera.CFrame
    local shakeConnection
    local startTime = tick()
    
    shakeConnection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            camera.CFrame = originalCFrame
            shakeConnection:Disconnect()
            return
        end
        
        local progress = elapsed / duration
        local currentIntensity = intensity * (1 - progress)
        
        local randomOffset = Vector3.new(
            (math.random() - 0.5) * currentIntensity,
            (math.random() - 0.5) * currentIntensity,
            (math.random() - 0.5) * currentIntensity
        )
        
        camera.CFrame = originalCFrame + randomOffset
    end)
end

-- Zoom effects
function CameraController.zoomIn(targetPosition, zoomLevel, duration)
    local currentCFrame = camera.CFrame
    local direction = (targetPosition - camera.CFrame.Position).Unit
    local zoomedPosition = targetPosition - (direction * zoomLevel)
    local targetCFrame = CFrame.lookAt(zoomedPosition, targetPosition)
    
    local zoomTween = TweenService:Create(
        camera,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {CFrame = targetCFrame}
    )
    
    zoomTween:Play()
    return zoomTween
end

function CameraController.zoomOut(originalCFrame, duration)
    local zoomTween = TweenService:Create(
        camera,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {CFrame = originalCFrame}
    )
    
    zoomTween:Play()
    return zoomTween
end

-- Input handling for camera mode switching
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.One then
        CameraController.setMode("FOLLOW")
    elseif input.KeyCode == Enum.KeyCode.Two then
        CameraController.setMode("CINEMATIC")
    elseif input.KeyCode == Enum.KeyCode.Three then
        CameraController.setMode("FREE")
    elseif input.KeyCode == Enum.KeyCode.Four then
        CameraController.setMode("LOCKED")
    end
end)

return CameraController