-- Audio Manager for Fighting Game
-- Handles sound effects, music, and audio feedback

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local AudioManager = {}

-- Audio settings
local MASTER_VOLUME = 0.7
local SFX_VOLUME = 0.8
local MUSIC_VOLUME = 0.5

-- Sound effect IDs (replace with actual Roblox sound IDs)
AudioManager.SoundEffects = {
    LightPunch = {
        id = "rbxasset://sounds/impact_water.mp3",
        volume = 0.6,
        pitch = 1.2
    },
    HeavyPunch = {
        id = "rbxasset://sounds/snap.mp3", 
        volume = 0.8,
        pitch = 0.8
    },
    Block = {
        id = "rbxasset://sounds/metal_hit.mp3",
        volume = 0.5,
        pitch = 1.0
    },
    PerfectParry = {
        id = "rbxasset://sounds/bell.mp3",
        volume = 0.7,
        pitch = 1.5
    },
    ComboHit = {
        id = "rbxasset://sounds/slash.mp3",
        volume = 0.6,
        pitch = 1.3
    },
    SpecialMove = {
        UPPERCUT = {
            id = "rbxasset://sounds/explosion.mp3",
            volume = 0.9,
            pitch = 1.0
        },
        SPINNING_KICK = {
            id = "rbxasset://sounds/whoosh.mp3",
            volume = 0.8,
            pitch = 0.9
        },
        DEVASTATOR = {
            id = "rbxasset://sounds/thunder.mp3",
            volume = 1.0,
            pitch = 0.7
        }
    },
    Victory = {
        id = "rbxasset://sounds/victory.mp3",
        volume = 0.8,
        pitch = 1.0
    },
    Defeat = {
        id = "rbxasset://sounds/lose.mp3",
        volume = 0.6,
        pitch = 0.8
    }
}

-- Background music
AudioManager.Music = {
    Battle = {
        id = "rbxasset://sounds/fight_music.mp3",
        volume = 0.4,
        looped = true
    },
    Menu = {
        id = "rbxasset://sounds/menu_music.mp3",
        volume = 0.3,
        looped = true
    }
}

-- Create and configure sound object
function AudioManager.createSound(soundData, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = soundData.id
    sound.Volume = (soundData.volume or 0.5) * MASTER_VOLUME * SFX_VOLUME
    sound.Pitch = soundData.pitch or 1.0
    sound.RollOffMode = Enum.RollOffMode.Linear
    sound.MaxDistance = 100
    sound.Parent = parent or SoundService
    
    return sound
end

-- Play sound effect at position
function AudioManager.playSoundAtPosition(soundType, position, comboCount)
    local soundData = AudioManager.SoundEffects[soundType]
    if not soundData then
        warn("Unknown sound type: " .. tostring(soundType))
        return
    end
    
    -- Create a temporary part for positional audio
    local part = Instance.new("Part")
    part.Name = "SoundSource"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace
    
    local sound = AudioManager.createSound(soundData, part)
    
    -- Enhance audio for combos
    if comboCount and comboCount >= 3 then
        sound.Pitch = sound.Pitch * (1 + (comboCount * 0.05))
        sound.Volume = sound.Volume * (1 + (comboCount * 0.1))
    end
    
    -- Play and cleanup
    sound:Play()
    sound.Ended:Connect(function()
        part:Destroy()
    end)
    
    -- Safety cleanup
    game:GetService("Debris"):AddItem(part, 5)
end

-- Play special move sound
function AudioManager.playSpecialSound(moveType, position)
    local specialData = AudioManager.SoundEffects.SpecialMove[moveType]
    if not specialData then
        warn("Unknown special move sound: " .. tostring(moveType))
        return
    end
    
    -- Create temporary part for positional audio
    local part = Instance.new("Part")
    part.Name = "SpecialSoundSource"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace
    
    local sound = AudioManager.createSound(specialData, part)
    
    -- Add dramatic effect
    sound.ReverbSoundEffect.Enabled = true
    sound.ReverbSoundEffect.RoomSize = 0.8
    sound.ReverbSoundEffect.DecayTime = 2.0
    
    sound:Play()
    sound.Ended:Connect(function()
        part:Destroy()
    end)
    
    game:GetService("Debris"):AddItem(part, 10)
end

-- Play global sound effect (non-positional)
function AudioManager.playGlobalSound(soundType, volumeMultiplier)
    local soundData = AudioManager.SoundEffects[soundType]
    if not soundData then
        warn("Unknown sound type: " .. tostring(soundType))
        return
    end
    
    local sound = AudioManager.createSound(soundData, SoundService)
    if volumeMultiplier then
        sound.Volume = sound.Volume * volumeMultiplier
    end
    
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Background music management
local currentMusic = nil

function AudioManager.playMusic(musicType, fadeInTime)
    local musicData = AudioManager.Music[musicType]
    if not musicData then
        warn("Unknown music type: " .. tostring(musicType))
        return
    end
    
    -- Stop current music
    if currentMusic then
        if fadeInTime then
            local fadeOut = TweenService:Create(
                currentMusic,
                TweenInfo.new(fadeInTime * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Volume = 0}
            )
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                currentMusic:Stop()
                currentMusic:Destroy()
            end)
        else
            currentMusic:Stop()
            currentMusic:Destroy()
        end
    end
    
    -- Create new music
    currentMusic = Instance.new("Sound")
    currentMusic.SoundId = musicData.id
    currentMusic.Volume = (musicData.volume or 0.5) * MASTER_VOLUME * MUSIC_VOLUME
    currentMusic.Looped = musicData.looped or false
    currentMusic.Parent = SoundService
    
    -- Fade in if requested
    if fadeInTime then
        local targetVolume = currentMusic.Volume
        currentMusic.Volume = 0
        currentMusic:Play()
        
        local fadeIn = TweenService:Create(
            currentMusic,
            TweenInfo.new(fadeInTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Volume = targetVolume}
        )
        fadeIn:Play()
    else
        currentMusic:Play()
    end
end

function AudioManager.stopMusic(fadeOutTime)
    if not currentMusic then return end
    
    if fadeOutTime then
        local fadeOut = TweenService:Create(
            currentMusic,
            TweenInfo.new(fadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Volume = 0}
        )
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            currentMusic:Stop()
            currentMusic:Destroy()
            currentMusic = nil
        end)
    else
        currentMusic:Stop()
        currentMusic:Destroy()
        currentMusic = nil
    end
end

-- Combo audio effects
function AudioManager.playComboSound(comboCount)
    if comboCount >= 10 then
        AudioManager.playGlobalSound("Victory", 0.8)
    elseif comboCount >= 7 then
        AudioManager.playSoundAtPosition("ComboHit", workspace.CurrentCamera.CFrame.Position)
    elseif comboCount >= 5 then
        AudioManager.playSoundAtPosition("ComboHit", workspace.CurrentCamera.CFrame.Position)
    elseif comboCount >= 3 then
        AudioManager.playSoundAtPosition("ComboHit", workspace.CurrentCamera.CFrame.Position)
    end
end

-- Volume controls
function AudioManager.setMasterVolume(volume)
    MASTER_VOLUME = math.clamp(volume, 0, 1)
    if currentMusic then
        local musicData = AudioManager.Music[currentMusic.Name] or {volume = 0.5}
        currentMusic.Volume = (musicData.volume or 0.5) * MASTER_VOLUME * MUSIC_VOLUME
    end
end

function AudioManager.setSFXVolume(volume)
    SFX_VOLUME = math.clamp(volume, 0, 1)
end

function AudioManager.setMusicVolume(volume)
    MUSIC_VOLUME = math.clamp(volume, 0, 1)
    if currentMusic then
        local musicData = AudioManager.Music[currentMusic.Name] or {volume = 0.5}
        currentMusic.Volume = (musicData.volume or 0.5) * MASTER_VOLUME * MUSIC_VOLUME
    end
end

-- Initialize audio system
function AudioManager.initialize()
    -- Set up sound groups for better organization
    local sfxGroup = Instance.new("SoundGroup")
    sfxGroup.Name = "SFX"
    sfxGroup.Volume = SFX_VOLUME
    sfxGroup.Parent = SoundService
    
    local musicGroup = Instance.new("SoundGroup")
    musicGroup.Name = "Music"
    musicGroup.Volume = MUSIC_VOLUME
    musicGroup.Parent = SoundService
    
    print("Audio Manager initialized successfully!")
end

return AudioManager