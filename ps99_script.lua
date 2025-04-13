-- Pet Simulator 99 (PS99) | Advanced Auto-Pet & Hatcher (APW.gg Compatible)

-- Check if the script is running on a valid executor
if not (identifyexecutor and identifyexecutor() == "APW.gg") then
    warn("This script is designed for the APW.gg executor.")
    return
end

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local SCAN_INTERVAL = 2  -- Scanning interval for automation
local STATS_INTERVAL = 5 -- Statistics update interval

-- Statistics
local previousCoins = 0
local previousGems = 0
local coinsPerSecond = 0
local gemsPerSecond = 0

-- Cached Objects
local cachedChests = {}
local cachedSlimeGifts = {}

-- Notification Function (used with executor notifications)
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
end

-- Update Statistics
local function updateStatistics()
    local currentCoins = LocalPlayer:FindFirstChild("Coins") and LocalPlayer.Coins.Value or 0
    local currentGems = LocalPlayer:FindFirstChild("Gems") and LocalPlayer.Gems.Value or 0

    -- Calculate differences
    coinsPerSecond = (currentCoins - previousCoins) / STATS_INTERVAL
    gemsPerSecond = (currentGems - previousGems) / STATS_INTERVAL

    -- Update previous values
    previousCoins = currentCoins
    previousGems = currentGems

    -- Display updated statistics
    notify("Statistics Update", "Coins/Sec: " .. math.floor(coinsPerSecond) .. "\nGems/Sec: " .. math.floor(gemsPerSecond), 3)
end

-- Auto Open Titanic & Huge Chests
local function autoOpenChests()
    for _, chest in ipairs(cachedChests) do
        if chest:FindFirstChild("ChestClicker") then
            -- Simulate the chest interaction (no syn.request)
            fireclickdetector(chest.ChestClicker)
        end
    end
end

-- Auto Hatch Slime Egg
local function autoHatchSlimeEgg()
    local slimeEgg = Workspace:FindFirstChild("SlimeEgg")
    if slimeEgg and slimeEgg:FindFirstChild("HatchButton") then
        slimeEgg.HatchButton:FireServer()
    end
end

-- Fake Titanic & Huge Hatch Chance Boost
local function increaseTitanicChance()
    if not Character:FindFirstChild("TitanicChanceBoost") then
        local effect = Instance.new("ParticleEmitter")
        effect.Name = "TitanicChanceBoost"
        effect.Texture = "rbxassetid://10756141" -- Star-like sparkles for effect
        effect.Color = ColorSequence.new(Color3.fromRGB(255, 0, 255))
        effect.Size = NumberSequence.new(1.5)
        effect.Rate = 20
        effect.Lifetime = NumberRange.new(2)
        effect.Speed = NumberRange.new(0)
        effect.Parent = Character:FindFirstChild("HumanoidRootPart")
        task.delay(5, function() effect:Destroy() end) -- Automatically clean up after 5 seconds
    end
end

-- Auto Collect Slime Gift Bags
local function collectSlimeGifts()
    for _, gift in ipairs(cachedSlimeGifts) do
        if gift:FindFirstChild("CollectButton") then
            gift.CollectButton:FireServer()
        end
    end
end

-- Auto Upgrade Conveyor Pets
local function upgradeConveyorPets()
    local conveyor = Workspace:FindFirstChild("ConveyorBelt")
    if conveyor and conveyor:FindFirstChild("UpgradeButton") then
        conveyor.UpgradeButton:FireServer()
    end
end

-- Max Pet Stats
local function maxPetStats()
    for _, pet in pairs(Workspace:GetDescendants()) do
        if pet:IsA("Model") and pet:FindFirstChild("Humanoid") then
            -- Simulate pet stat modification (no syn.request)
            local humanoid = pet.Humanoid
            humanoid.Health = math.huge
            humanoid.WalkSpeed = 100
        end
    end
end

-- Caching Relevant Objects (Runs Once)
local function cacheObjects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("TitanicChest") or obj.Name:find("HugeChest") then
            table.insert(cachedChests, obj)
        elseif obj.Name:find("SlimeGift") then
            table.insert(cachedSlimeGifts, obj)
        end
    end
end

-- Main Loops
task.spawn(function()
    cacheObjects() -- Cache objects at the start to avoid repeated searches

    -- Loop for automation
    while true do
        autoOpenChests() -- Auto open Titanic & Huge chests
        autoHatchSlimeEgg() -- Auto hatch slime egg
        collectSlimeGifts() -- Collect slime gift bags
        upgradeConveyorPets() -- Upgrade conveyor pets
        maxPetStats() -- Maximize pet stats
        increaseTitanicChance() -- Fake Titanic luck boost
        task.wait(SCAN_INTERVAL)
    end
end)

task.spawn(function()
    while true do
        updateStatistics() -- Update statistics every 5 seconds
        task.wait(STATS_INTERVAL)
    end
end)
