-- Simple test to trigger Rojo sync
print("🔄 Rojo sync test - if you see this, syncing is working!")

-- Create a test part to confirm the script is running
local testPart = Instance.new("Part")
testPart.Name = "RojoSyncTest"
testPart.Size = Vector3.new(4, 4, 4)
testPart.Position = Vector3.new(0, 60, 0)
testPart.BrickColor = BrickColor.new("Bright yellow")
testPart.Anchored = true
testPart.Parent = workspace

print("✅ Test part created! Rojo is working!")