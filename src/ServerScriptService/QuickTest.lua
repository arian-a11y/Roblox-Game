-- Quick test script to verify arena generation works
print("🔧 QUICK TEST SCRIPT STARTING...")

wait(1) -- Wait a moment for other scripts to load

-- Try to require the ArenaGenerator directly
local success, ArenaGenerator = pcall(function()
    return require(script.Parent:FindFirstChild("ArenaGenerator"))
end)

if not success then
    warn("❌ Failed to load ArenaGenerator: " .. tostring(ArenaGenerator))
    return
end

print("✅ ArenaGenerator loaded successfully!")

-- Try to generate a simple arena
local function testArena()
    print("🏟️ Attempting to generate test arena...")
    
    local arena = ArenaGenerator.generateArena("ANCIENT_TEMPLE", Vector3.new(0, 50, 0))
    
    if arena then
        print("🎉 SUCCESS! Arena generated: " .. arena.name)
        print("📍 Platform position: " .. tostring(arena.platform.Position))
        print("🎯 Spawn points: " .. #arena.spawnPoints)
    else
        warn("❌ Arena generation failed!")
    end
end

-- Run the test
spawn(testArena)

print("🔧 Quick test script loaded!")