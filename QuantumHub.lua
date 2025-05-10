-- Ultra OmniHub for Blox Fruits (Update 24, Dragon Update)
-- Enhanced Features: All Quantum Hub/Redz Hub/Hoho Hub/Raito Hub/KaitunConfig features, upgraded auto-farm (0.05s attack), auto-boss (drop priority), auto-raid (Dragon Raid), fruit sniper (weighted priority), ESP (color-coded), auto-stats (dynamic), plus new features (auto-complete quests, auto-farm drops, auto-unlock Superhuman, auto-server rank, auto-trade optimizer, auto-Mirage puzzles)
-- Supports all NPCs, bosses, islands in First, Second, Third Seas
-- Modern UI: Gradient themes, animated transitions, search autocomplete, stats dashboard, log panel, profile saving, mobile-optimized
-- Performance: 0.05s attack delay, dynamic FPS (10/30/60), advanced object pooling, texture culling
-- Safety: Randomized teleports (300–600), variable delays (0.05–0.15s), pathfinding, crash recovery
-- Use responsibly to comply with Roblox TOS

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local PathfindingService = game:GetService("PathfindingService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Configuration
local CONFIG = {
    FARM_DISTANCE = 45,
    COLLECT_RANGE = 15,
    ATTACK_DELAY = 0.05,
    TELEPORT_SPEED_MIN = 300,
    TELEPORT_SPEED_MAX = 600,
    AUTO_STAT = "Dynamic",
    TARGET_FRUITS = {
        {Name = "Kitsune-Kitsune", Priority = 10},
        {Name = "Dragon-Dragon", Priority = 9},
        {Name = "Leopard-Leopard", Priority = 8},
        {Name = "Dough-Dough", Priority = 7},
        {Name = "T-Rex-T-Rex", Priority = 6},
        {Name = "Buddha-Buddha", Priority = 5},
        {Name = "Mammoth-Mammoth", Priority = 4},
        {Name = "Venom-Venom", Priority = 3},
    },
    UI_TOGGLE_KEY = Enum.KeyCode.F4,
    TEAM = "Pirates",
    MASTERY_METHOD = "Hybrid",
    WEBHOOK_URL = "",
    FPS_CAP = 30,
    LOW_TEXTURE = true,
    TWEEN_METHOD = "Pathfinding",
    SERVER_HOP_INTERVAL = 300,
    THEME_COLOR = Color3.fromRGB(0, 200, 0),
    COMBAT_MODE = "PVE",
    UI_SCALE = 1,
    AUTO_PROFILE = "Default",
}

-- Sea Data (NPCs, Bosses, Islands)
local SEA_DATA = {
    FirstSea = {
        Islands = {
            {Name = "Starter Island", Level = 0, NPCs = {"Boat Dealer", "Luxury Boat Dealer", "Sword Dealer", "Blox Fruit Dealer", "Marine Recruiter"}, Quests = {"Defeat 5 Bandits"}, Pos = Vector3.new(-200, 50, 200), Drops = {}},
            {Name = "Jungle", Level = 15, NPCs = {"Adventurer", "Blox Fruits Dealer Cousin"}, Quests = {"Defeat 6 Monkeys", "Defeat 8 Gorillas", "Defeat Gorilla King"}, Bosses = {{"Gorilla King", 25}}, Pos = Vector3.new(1000, 50, 1000), Drops = {}},
            {Name = "Pirate Village", Level = 30, NPCs = {"Sword Dealer of the West", "Black Leg Teacher"}, Quests = {"Defeat 8 Pirates"}, Bosses = {{"Bobby", 55}}, Pos = Vector3.new(-1200, 50, 1400), Drops = {}},
            {Name = "Desert", Level = 60, NPCs = {"Desert Quest Giver"}, Quests = {"Defeat 8 Desert Bandits"}, Pos = Vector3.new(1500, 50, -1000), Drops = {}},
            {Name = "Middle Town", Level = 100, NPCs = {"Robotomeg", "King Red Head"}, Quests = {"Defeat 8 Thugs"}, Bosses = {{"Vice Admiral", 130}}, Pos = Vector3.new(0, 50, 0), Drops = {}},
            {Name = "Frozen Village", Level = 90, NPCs = {"Ability Teacher"}, Quests = {"Defeat 8 Snow Bandits", "Defeat 9 Snowmen"}, Bosses = {{"Ice Admiral", 120}}, Pos = Vector3.new(-2000, 50, 2000), Drops = {}},
            {Name = "Marine Fortress", Level = 120, NPCs = {"Marine Quest Giver"}, Quests = {"Defeat 8 Marines"}, Pos = Vector3.new(2500, 50, -1500), Drops = {}},
            {Name = "Skylands", Level = 150, NPCs = {"Mad Scientist"}, Quests = {"Defeat 8 Sky Bandits", "Defeat 8 Dark Masters"}, Bosses = {{"Wysper", 175}}, Pos = Vector3.new(0, 1000, 3000), Drops = {}},
            {Name = "Prison", Level = 190, NPCs = {"Military Detective"}, Quests = {"Defeat 8 Prisoners"}, Bosses = {{"Warden", 200}, {"Saber Expert", 200}}, Pos = Vector3.new(-3000, 50, 0), Drops = {{"Saber", "Saber Expert"}}},
            {Name = "Colosseum", Level = 225, NPCs = {"Colosseum Quest Giver"}, Quests = {"Defeat 8 Gladiators"}, Pos = Vector3.new(2000, 50, 2500), Drops = {}},
            {Name = "Magma Village", Level = 300, NPCs = {"Living Skeleton"}, Quests = {"Defeat 8 Magma Ninjas"}, Pos = Vector3.new(-2500, 50, -2000), Drops = {}},
            {Name = "Underwater City", Level = 400, NPCs = {"Water Kung Fu Teacher"}, Quests = {"Defeat 8 Fishmen"}, Pos = Vector3.new(0, -500, 3500), Drops = {}},
            {Name = "Fountain City", Level = 625, NPCs = {"Fountain Quest Giver"}, Quests = {"Defeat 8 Galley Pirates"}, Bosses = {{"Cyborg", 675}}, Pos = Vector3.new(3000, 50, -3000), Drops = {}},
        },
    },
    SecondSea = {
        Islands = {
            {Name = "Kingdom of Rose", Level = 700, NPCs = {"Cyborg", "Trevor", "Arowe", "Bounty Expert", "Awakenings Expert"}, Quests = {"Defeat 8 Raiders", "Defeat 8 Swan Pirates"}, Bosses = {{"Diamond", 750}, {"Jeremy", 850}, {"Don Swan", 1000}}, Pos = Vector3.new(0, 50, 0), Drops = {{"Swan Glasses", "Don Swan"}}},
            {Name = "Green Zone", Level = 875, NPCs = {"Alchemist", "Mr. Captain"}, Quests = {"Defeat 8 Factory Staff"}, Pos = Vector3.new(1000, 50, 1000), Drops = {}},
            {Name = "Graveyard", Level = 950, NPCs = {"Crew Captain"}, Quests = {"Defeat 8 Zombies"}, Bosses = {{"Deandre", 975}}, Pos = Vector3.new(-1500, 50, 1200), Drops = {}},
            {Name = "Snow Mountain", Level = 1000, NPCs = {"Martial Arts Master"}, Quests = {"Defeat 8 Snow Soldiers"}, Pos = Vector3.new(2000, 50, -1000), Drops = {}},
            {Name = "Hot and Cold", Level = 1100, NPCs = {"Arlthmetic", "Mysterious Scientist"}, Quests = {"Defeat 8 Lab Subordinates"}, Bosses = {{"Smoke Admiral", 1150}}, Pos = Vector3.new(-2000, 50, 1500), Drops = {}},
            {Name = "Cursed Ship", Level = 1250, NPCs = {"El Rodolfo"}, Quests = {"Defeat 8 Ship Engineers"}, Bosses = {{"Cursed Captain", 1325}}, Pos = Vector3.new(2500, 50, -1200), Drops = {{"Hellfire Torch", "Cursed Captain"}}},
            {Name = "Ice Castle", Level = 1350, NPCs = {"Phoeyu The Reformed"}, Quests = {"Defeat 8 Arctic Warriors"}, Bosses = {{"Tide Keeper", 1475}}, Pos = Vector3.new(-3000, 50, 2000), Drops = {{"Dragon Trident", "Tide Keeper"}}},
            {Name = "Forgotten Island", Level = 1425, NPCs = {"Daigrock The Sharkman"}, Quests = {"Defeat 8 Sea Soldiers"}, Pos = Vector3.new(0, 50, 3000), Drops = {}},
            {Name = "Remote Island", Level = 700, NPCs = {"The Strongest God"}, Quests = {}, Pos = Vector3.new(3500, 50, 0), Drops = {}},
            {Name = "Dark Arena", Level = 950, NPCs = {}, Quests = {}, Bosses = {{"Darkbeard", 1000}}, Pos = Vector3.new(-3500, 50, 0), Drops = {{"Dark Coat", "Darkbeard"}}},
        },
    },
    ThirdSea = {
        Islands = {
            {Name = "Port Town", Level = 1500, NPCs = {"Blox Fruit Dealer", "Boat Dealer"}, Quests = {"Defeat 8 Pirate Millionaires", "Defeat 8 Pistol Billionaires"}, Bosses = {{"Stone", 1550}}, Pos = Vector3.new(0, 50, 0), Drops = {}},
            {Name = "Hydra Island", Level = 1575, NPCs = {"Arena Trainer"}, Quests = {"Defeat 8 Dragon Crew Warriors", "Defeat 8 Dragon Crew Archers"}, Bosses = {{"Kilo Admiral", 1750}}, Pos = Vector3.new(1000, 50, 1000), Drops = {}},
            {Name = "Great Tree", Level = 1700, NPCs = {"Crew Captain", "Master of Auras"}, Quests = {"Defeat 8 Marine Commodores", "Defeat 8 Marine Rear Admirals"}, Bosses = {{"Beautiful Pirate", 1950}}, Pos = Vector3.new(-1500, 50, 1200), Drops = {{"Canvander", "Beautiful Pirate"}}},
            {Name = "Floating Turtle", Level = 1775, NPCs = {"Citizen", "Horned Man", "Hungry Man"}, Quests = {"Defeat 8 Female Islanders", "Defeat 8 Giant Islanders"}, Bosses = {{"Island Empress", 1675}}, Pos = Vector3.new(2000, 50, -1000), Drops = {{"Serpent Bow", "Island Empress"}}},
            {Name = "Castle on the Sea", Level = 1500, NPCs = {"Lunoven", "Plokster", "Mysterious Scientist"}, Quests = {}, Bosses = {{"rip_indra", 1500}}, Pos = Vector3.new(-2000, 50, 1500), Drops = {{"Valkyrie Helm", "rip_indra"}}},
            {Name = "Haunted Castle", Level = 1975, NPCs = {"Crypt Master"}, Quests = {"Defeat 8 Reborn Skeletons"}, Bosses = {{"Soul Reaper", 2100}}, Pos = Vector3.new(2500, 50, -1200), Drops = {{"Hallow Scythe", "Soul Reaper"}}},
            {Name = "Sea of Treats", Level = 2075, NPCs = {"Cake Quest Giver"}, Quests = {"Defeat 8 Cookie Crafters", "Defeat 8 Sweet Thieves", "Defeat 8 Candy Rebels", "Defeat 8 Cocoa Warriors", "Defeat 8 Chocolate Bar Battlers", "Defeat 8 Candy Pirates"}, Bosses = {{"Cake Queen", 2175}}, Pos = Vector3.new(-3000, 50, 2000), Drops = {{"Spikey Trident", "Cake Queen"}}},
            {Name = "Tiki Outpost", Level = 2275, NPCs = {"Shafi", "Dragon Talon Sage"}, Quests = {"Defeat 8 Tiki Warriors"}, Bosses = {{"Longma", 2275}}, Pos = Vector3.new(0, 50, 3000), Drops = {{"Cursed Dual Katana", "Longma"}}},
        },
    },
}

-- State
local Toggles = {
    AutoFarm = false,
    AutoBoss = false,
    AutoRaid = false,
    AutoQuest = false,
    AutoFruit = false,
    AutoStat = false,
    FastAttack = false,
    ESP = false,
    AutoGear = false,
    MasteryFarm = false,
    AutoHaki = false,
    AutoSecondSea = false,
    AutoThirdSea = false,
    AutoLegendarySword = false,
    AutoRaceV3 = false,
    AutoRaceV4 = false,
    ChestFarm = false,
    AutoEvent = false,
    AutoAwaken = false,
    AutoTerrorShark = false,
    AutoMirageIsland = false,
    AutoLeviathan = false,
    AutoFragment = false,
    AutoSaber = false,
    AutoPole = false,
    AutoTushita = false,
    AutoElectricClaw = false,
    AutoDragonTalon = false,
    AutoGodhuman = false,
    AutoStoreFruits = false,
    AutoEquipBestGear = false,
    AutoJoinCrew = false,
    AutoServerBoost = false,
    AutoElitePirates = false,
    AutoCursedDualKatana = false,
    AutoSharkmanKarate = false,
    AutoDarkStep = false,
    AutoBuyBoats = false,
    AutoSpinFruit = false,
    AutoDetectRareSpawns = false,
    AutoOptimizeInventory = false,
    AutoBartilo = false,
    AutoV2FightingStyles = false,
    AutoSeaEvents = false,
    AutoBuyHakiColors = false,
    AutoCompleteQuests = false,
    AutoFarmDrops = false,
    AutoSuperhuman = false,
    AutoServerRank = false,
    AutoTradeOptimizer = false,
    AutoMiragePuzzles = false,
}

-- Profiles
local Profiles = {
    Default = {Toggles = {}, CONFIG = {}},
    Farming = {Toggles = {AutoFarm = true, AutoQuest = true, AutoStat = true, FastAttack = true}, CONFIG = {AUTO_STAT = "Melee", FPS_CAP = 30}},
    Raiding = {Toggles = {AutoRaid = true, AutoAwaken = true, AutoStat = true}, CONFIG = {AUTO_STAT = "Fruit", FPS_CAP = 60}},
}

-- Object Pooling
local ESP_POOL = {}
local function getESPBillboard()
    if #ESP_POOL > 0 then
        return table.remove(ESP_POOL)
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextSize = 12
    label.Parent = billboard
    return billboard
end

local function releaseESPBillboard(billboard)
    billboard.Parent = nil
    billboard.Label.Text = ""
    table.insert(ESP_POOL, billboard)
end

-- GUI Setup
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UltraOmniHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 650 * CONFIG.UI_SCALE, 0, 800 * CONFIG.UI_SCALE)
    MainFrame.Position = UDim2.new(0.5, -325 * CONFIG.UI_SCALE, 0.5, -400 * CONFIG.UI_SCALE)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{COLOR3.new(0, 0.7, 0), Color3.new(0, 0.3, 0)}
    UIGradient.Rotation = 45
    UIGradient.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "Ultra OmniHub - Blox Fruits (Update 24)"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 26
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(0.9, 0, 0, 40)
    SearchBar.Position = UDim2.new(0.05, 0, 0, 60)
    SearchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SearchBar.Text = "Search Features..."
    SearchBar.TextColor3 = Color3.fromRGB(150, 150, 150)
    SearchBar.TextSize = 16
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.Parent = MainFrame

    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 0, 40)
    TabFrame.Position = UDim2.new(0, 0, 0, 110)
    TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabFrame.Parent = MainFrame

    local Tabs = {"Farming", "Combat", "Teleport", "Items", "Settings", "Logs"}
    local TabButtons = {}
    local ContentFrames = {}

    for i, tab in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0.166, 0, 1, 0)
        TabButton.Position = UDim2.new((i-1)*0.166, 0, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.Text = tab
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 16
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabFrame
        TabButtons[tab] = TabButton

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Size = UDim2.new(0.95, 0, 0.65, -150)
        ContentFrame.Position = UDim2.new(0.025, 0, 0, 150)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 2500)
        ContentFrame.ScrollBarThickness = 5
        ContentFrame.Parent = MainFrame
        ContentFrame.Visible = tab == "Farming"
        ContentFrames[tab] = ContentFrame
    end

    local function createToggleButton(name, yOffset, toggleKey, parentFrame)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 50)
        Button.Position = UDim2.new(0.05, 0, 0, yOffset)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.Text = name .. ": OFF"
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 16
        Button.Font = Enum.Font.Gotham
        Button.Parent = parentFrame
        Button.Name = name

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Button

        Button.MouseButton1Click:Connect(function()
            Toggles[toggleKey] = not Toggles[toggleKey]
            Button.Text = name .. ": " .. (Toggles[toggleKey] and "ON" or "OFF")
            Button.BackgroundColor3 = Toggles[toggleKey] and CONFIG.THEME_COLOR or Color3.fromRGB(40, 40, 40)
            sendWebhook("Toggled " .. name .. ": " .. (Toggles[toggleKey] and "ON" or "OFF"))
        end)
    end

    -- Feature Tabs
    local featureTabs = {
        Farming = {
            {"Auto-Farm NPCs", "AutoFarm", 10},
            {"Auto-Boss", "AutoBoss", 70},
            {"Auto-Raid", "AutoRaid", 130},
            {"Auto-Quest", "AutoQuest", 190},
            {"Auto-Collect Fruits", "AutoFruit", 250},
            {"Chest Farming", "ChestFarm", 310},
            {"Auto-Event", "AutoEvent", 370},
            {"Auto-Fragment Farming", "AutoFragment", 430},
            {"Auto-Sea Beast", "AutoSeaBeast", 490},
            {"Auto-Elite Pirates", "AutoElitePirates", 550},
            {"Auto-Sea Events", "AutoSeaEvents", 610},
            {"Auto-Farm Specific Drops", "AutoFarmDrops", 670},
            {"Auto-Complete Quests", "AutoCompleteQuests", 730},
        },
        Combat = {
            {"Fast Attack", "FastAttack", 10},
            {"Auto-Stat (Dynamic)", "AutoStat", 70},
            {"Mastery Farming", "MasteryFarm", 130},
            {"Auto-Haki", "AutoHaki", 190},
            {"Auto-Awaken Fruit", "AutoAwaken", 250},
            {"Stats Optimizer", "StatsOptimizer", 310},
            {"Auto-Electric Claw", "AutoElectricClaw", 370},
            {"Auto-Dragon Talon", "AutoDragonTalon", 430},
            {"Auto-Godhuman", "AutoGodhuman", 490},
            {"Auto-Sharkman Karate", "AutoSharkmanKarate", 550},
            {"Auto-Dark Step", "AutoDarkStep", 610},
            {"Auto-V2 Fighting Styles", "AutoV2FightingStyles", 670},
            {"Auto-Superhuman", "AutoSuperhuman", 730},
        },
        Teleport = {
            {"Auto-Second Sea", "AutoSecondSea", 10},
            {"Auto-Third Sea", "AutoThirdSea", 70},
            {"Auto-TerrorShark/Prehistoric", "AutoTerrorShark", 130},
            {"Auto-Mirage Island", "AutoMirageIsland", 190},
            {"Auto-Leviathan", "AutoLeviathan", 250},
            {"Auto-Mirage Puzzles", "AutoMiragePuzzles", 310},
        },
        Items = {
            {"Auto-Gear (Buy Items)", "AutoGear", 10},
            {"Auto-Legendary Sword", "AutoLegendarySword", 70},
            {"Auto-Saber", "AutoSaber", 130},
            {"Auto-Pole", "AutoPole", 190},
            {"Auto-Tushita/Yama", "AutoTushita", 250},
            {"Auto-Cursed Dual Katana", "AutoCursedDualKatana", 310},
            {"Auto-Race V3", "AutoRaceV3", 370},
            {"Auto-Race V4", "AutoRaceV4", 430},
            {"Auto-Trade Optimizer", "AutoTradeOptimizer", 490},
            {"Auto-Store Fruits", "AutoStoreFruits", 550},
            {"Auto-Equip Best Gear", "AutoEquipBestGear", 610},
            {"Auto-Buy Boats", "AutoBuyBoats", 670},
            {"Auto-Spin Fruit", "AutoSpinFruit", 730},
            {"Auto-Buy Haki Colors", "AutoBuyHakiColors", 790},
        },
        Settings = {
            {"Server Hop", "ServerHop", 10},
            {"Anti-AFK", "AntiAFK", 70},
            {"Auto-Join Crew", "AutoJoinCrew", 130},
            {"Auto-Server Boost Detection", "AutoServerBoost", 190},
            {"Auto-Detect Rare Spawns", "AutoDetectRareSpawns", 250},
            {"Auto-Optimize Inventory", "AutoOptimizeInventory", 310},
            {"Auto-Bartilo Quest", "AutoBartilo", 370},
            {"Auto-Server Rank Tracker", "AutoServerRank", 430},
        },
        Logs = {
            -- Log panel handled separately
        },
    }

    for tab, features in pairs(featureTabs) do
        if tab ~= "Logs" then
            for _, feature in ipairs(features) do
                createToggleButton(feature[1], feature[3], feature[2], ContentFrames[tab])
            end
        end
    end

    -- Log Panel
    local LogFrame = Instance.new("ScrollingFrame")
    LogFrame.Size = UDim2.new(0.95, 0, 0.65, -150)
    LogFrame.Position = UDim2.new(0.025, 0, 0, 150)
    LogFrame.BackgroundTransparency = 1
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
    LogFrame.ScrollBarThickness = 5
    LogFrame.Parent = MainFrame
    LogFrame.Visible = false
    ContentFrames["Logs"] = LogFrame

    local LogLabel = Instance.new("TextLabel")
    LogLabel.Size = UDim2.new(0.95, 0, 0, 800)
    LogLabel.Position = UDim2.new(0.025, 0, 0, 10)
    LogLabel.BackgroundTransparency = 1
    LogLabel.Text = "Script Logs:\n"
    LogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogLabel.TextSize = 14
    LogLabel.Font = Enum.Font.Gotham
    LogLabel.TextWrapped = true
    LogLabel.TextYAlignment = Enum.TextYAlignment.Top
    LogLabel.Parent = LogFrame

    local function addLog(message)
        LogLabel.Text = LogLabel.Text .. os.date("[%H:%M:%S] ") .. message .. "\n"
        LogFrame.CanvasPosition = Vector2.new(0, LogFrame.CanvasSize.Y.Offset)
    end

    -- Search with Autocomplete
    local searchSuggestions = {}
    for tab, features in pairs(featureTabs) do
        for _, feature in ipairs(features) do
            table.insert(searchSuggestions, feature[1])
        end
    end

    SearchBar.FocusLost:Connect(function()
        local query = SearchBar.Text:lower()
        for tab, frame in pairs(ContentFrames) do
            if tab ~= "Logs" then
                for _, button in ipairs(frame:GetChildren()) do
                    if button:IsA("TextButton") then
                        button.Visible = query == "" or button.Name:lower():find(query)
                    end
                end
            end
        end
    end)

    SearchBar.Changed:Connect(function()
        local query = SearchBar.Text:lower()
        if query ~= "" then
            local matches = {}
            for _, suggestion in ipairs(searchSuggestions) do
                if suggestion:lower():find(query) then
                    table.insert(matches, suggestion)
                end
            end
            if #matches > 0 then
                SearchBar.Text = matches[1]
            end
        end
    end)

    -- Stats Dashboard
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(0.95, 0, 0, 140)
    StatsFrame.Position = UDim2.new(0.025, 0, 0.82, 0)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    StatsFrame.Parent = MainFrame

    local StatsLabel = Instance.new("TextLabel")
    StatsLabel.Size = UDim2.new(1, 0, 1, 0)
    StatsLabel.BackgroundTransparency = 1
    StatsLabel.Text = "Beli: 0\nFragments: 0\nLevel: 0\nMastery: 0\nFPS: 0\nPing: 0\nServer Age: 0\nServer: Normal"
    StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatsLabel.TextSize = 14
    StatsLabel.Font = Enum.Font.Gotham
    StatsLabel.TextWrapped = true
    StatsLabel.Parent = StatsFrame

    -- Profile Selector
    local ProfileDropdown = Instance.new("TextButton")
    ProfileDropdown.Size = UDim2.new(0.3, 0, 0, 40)
    ProfileDropdown.Position = UDim2.new(0.35, 0, 0, 110)
    ProfileDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ProfileDropdown.Text = "Profile: " .. CONFIG.AUTO_PROFILE
    ProfileDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    ProfileDropdown.TextSize = 16
    ProfileDropdown.Font = Enum.Font.Gotham
    ProfileDropdown.Parent = MainFrame

    ProfileDropdown.MouseButton1Click:Connect(function()
        local profileNames = {"Default", "Farming", "Raiding"}
        local currentIndex = table.find(profileNames, CONFIG.AUTO_PROFILE) or 1
        local nextIndex = (currentIndex % #profileNames) + 1
        CONFIG.AUTO_PROFILE = profileNames[nextIndex]
        ProfileDropdown.Text = "Profile: " .. CONFIG.AUTO_PROFILE
        if Profiles[CONFIG.AUTO_PROFILE] then
            for key, value in pairs(Profiles[CONFIG.AUTO_PROFILE].Toggles) do
                Toggles[key] = value
            end
            for key, value in pairs(Profiles[CONFIG.AUTO_PROFILE].CONFIG) do
                CONFIG[key] = value
            end
            for tab, frame in pairs(ContentFrames) do
                if tab ~= "Logs" then
                    for _, button in ipairs(frame:GetChildren()) do
                        if button:IsA("TextButton") then
                            local toggleKey = featureTabs[tab][tonumber(button.Name:match("%d+"))] and featureTabs[tab][tonumber(button.Name:match("%d+"))][2]
                            if toggleKey then
                                button.Text = button.Name:gsub("%d+", "") .. ": " .. (Toggles[toggleKey] and "ON" or "OFF")
                                button.BackgroundColor3 = Toggles[toggleKey] and CONFIG.THEME_COLOR or Color3.fromRGB(40, 40, 40)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Toggle UI
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == CONFIG.UI_TOGGLE_KEY then
            MainFrame.Visible = not MainFrame.Visible
            local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = MainFrame.Visible and 0 or 0.3})
            tween:Play()
        end
    end)

    return ScreenGui, StatsLabel, addLog
end

-- Utility Functions
local function sendWebhook(message)
    if CONFIG.WEBHOOK_URL ~= "" then
        local data = {content = message}
        pcall(function()
            HttpService:PostAsync(CONFIG.WEBHOOK_URL, HttpService:JSONEncode(data))
        end)
    end
end

local function safeTeleport(targetPos)
    local teleportSpeed = math.random(CONFIG.TELEPORT_SPEED_MIN, CONFIG.TELEPORT_SPEED_MAX)
    if CONFIG.TWEEN_METHOD == "Instant" then
        HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
    else
        local path = PathfindingService:CreatePath({AgentRadius = 2, AgentHeight = 5, AgentCanJump = true})
        local success, _ = pcall(function()
            path:ComputeAsync(HumanoidRootPart.Position, targetPos)
        end)
        if success and path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            for _, waypoint in ipairs(waypoints) do
                local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new((HumanoidRootPart.Position - waypoint.Position).Magnitude / teleportSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = CFrame.new(waypoint.Position + Vector3.new(0, 5, 0))})
                tween:Play()
                tween.Completed:Wait()
                if waypoint.Action == Enum.PathWaypointAction.Jump then
                    Humanoid:Jump()
                end
            end
        else
            local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new((HumanoidRootPart.Position - targetPos).Magnitude / teleportSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))})
            tween:Play()
            tween.Completed:Wait()
        end
    end
end

local function optimizePerformance()
    if CONFIG.LOW_TEXTURE then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v.Texture = ""
            elseif v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    end
    RunService:Set3dRenderingEnabled(CONFIG.FPS_CAP > 0)
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    settings().Rendering.GraphicsMode = Enum.GraphicsMode.OpenGL
    settings().Rendering.EnableVR = false
    settings().Physics.AllowSleep = true
    settings().Physics.ForceCS2 = true
    settings().Physics.SteppedSimulation = true
    RunService:SetFrameRate(CONFIG.FPS_CAP)
    Lighting.FogEnd = 10000
    Lighting.FogStart = 10000
    Lighting.Brightness = 1
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.ClockTime = 12
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then
            v:Destroy()
        end
    end
    -- Dynamic FPS adjustment
    task.spawn(function()
        while true do
            local fps = getFPS()
            if fps < 20 then
                CONFIG.FPS_CAP = 10
            elseif fps < 40 then
                CONFIG.FPS_CAP = 30
            else
                CONFIG.FPS_CAP = 60
            end
            RunService:SetFrameRate(CONFIG.FPS_CAP)
            task.wait(5)
        end
    end)
end

local function getFPS()
    local frameTime = 0
    local frames = 0
    local connection = RunService.RenderStepped:Connect(function(delta)
        frameTime = frameTime + delta
        frames = frames + 1
        if frameTime >= 1 then
            local fps = math.round(frames / frameTime)
            frameTime = 0
            frames = 0
            return fps
        end
    end)
    task.wait(1)
    connection:Disconnect()
    return getFPS() or 0
end

local function getPing()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    return tonumber(ping:match("%d+")) or 0
end

local function getServerAge()
    local age = game:GetService("Stats").Network.ServerStatsItem["Server Age"]:GetValueString()
    return age or "0"
end

local function findClosestNPC()
    local closestNPC = nil
    local closestDistance = CONFIG.FARM_DISTANCE
    local npcs = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("NPCs")
    
    if not npcs then return nil end
    
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    for _, npc in ipairs(npcs:GetChildren()) do
        local npcHumanoid = npc:FindFirstChild("Humanoid")
        local npcRoot = npc:FindFirstChild("HumanoidRootPart")
        if npcHumanoid and npcRoot and npcHumanoid.Health > 0 then
            local distance = (npcRoot.Position - HumanoidRootPart.Position).Magnitude
            local npcLevel = npcHumanoid:FindFirstChild("Level") and npcHumanoid.Level.Value or level
            if distance < closestDistance and math.abs(npcLevel - level) <= 100 then
                closestNPC = npc
                closestDistance = distance
            end
        end
    end
    return closestNPC
end

local function findBoss(sea)
    local bosses = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Bosses")
    if not bosses then return nil end
    
    for _, boss in ipairs(bosses:GetChildren()) do
        local humanoid = boss:FindFirstChild("Humanoid")
        local root = boss:FindFirstChild("HumanoidRootPart")
        if humanoid and root and humanoid.Health > 0 then
            for _, island in ipairs(SEA_DATA[sea].Islands) do
                for _, bossData in ipairs(island.Bosses or {}) do
                    if bossData[1] == boss.Name then
                        return boss
                    end
                end
            end
        end
    end
    return nil
end

local function attackNPC(npc)
    if not npc or not npc:FindFirstChild("Humanoid") or not npc:FindFirstChild("HumanoidRootPart") then return end
    local npcRoot = npc.HumanoidRootPart
    
    safeTeleport(npcRoot.Position)
    
    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
    if tool then
        tool.Parent = Character
        tool:Activate()
        if Toggles.FastAttack then
            for _ = 1, 15 do
                tool:Activate()
                task.wait(0.01)
            end
        end
    end
    task.wait(math.random(50, 150) / 1000)
end

local function autoFarm()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    local sea = level < 700 and "FirstSea" or (level < 1500 and "SecondSea" or "ThirdSea")
    
    for _, island in ipairs(SEA_DATA[sea].Islands) do
        if level >= island.Level then
            safeTeleport(island.Pos)
            local npc = findClosestNPC()
            if npc then
                attackNPC(npc)
                if Toggles.AutoQuest then
                    for _, npcName in ipairs(island.NPCs) do
                        local questNPC = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild(npcName)
                        if questNPC and questNPC:FindFirstChild("HumanoidRootPart") then
                            safeTeleport(questNPC.HumanoidRootPart.Position)
                            local prompt = questNPC:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                            break
                        end
                    end
                end
                break
            end
        end
    end
end

local function autoBoss()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    local sea = level < 700 and "FirstSea" or (level < 1500 and "SecondSea" or "ThirdSea")
    
    local boss = findBoss(sea)
    if boss then
        safeTeleport(boss.HumanoidRootPart.Position)
        attackNPC(boss)
        for _, island in ipairs(SEA_DATA[sea].Islands) do
            for _, bossData in ipairs(island.Bosses or {}) do
                if bossData[1] == boss.Name and island.Drops[1] then
                    sendWebhook("Farming boss " .. boss.Name .. " for " .. island.Drops[1][1])
                end
            end
        end
    else
        sendWebhook("No boss found in " .. sea .. ". Server hopping...")
        if Toggles.ServerHop then
            TeleportService:Teleport(game.PlaceId)
        end
    end
end

local function autoRaid()
    local raidFolder = Workspace:FindFirstChild("Raids") or Workspace:FindFirstChild("Raid")
    if raidFolder then
        for _, raid in ipairs(raidFolder:GetChildren()) do
            local raidPos = raid:FindFirstChild("HumanoidRootPart") and raid.HumanoidRootPart.Position
            if raidPos then
                safeTeleport(raidPos)
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    if raid.Name:match("Dragon") then
                        ReplicatedStorage.Remotes.AwakenFruit:FireServer(tool.Name)
                    end
                end
                task.wait(0.1)
            end
        end
    end
end

local function collectFruits()
    for _, item in ipairs(Workspace:GetChildren()) do
        if item:IsA("Model") and item:FindFirstChild("TouchInterest") then
            local itemRoot = item:FindFirstChild("Handle") or item:FindFirstChild("Part")
            if itemRoot and (itemRoot.Position - HumanoidRootPart.Position).Magnitude < CONFIG.COLLECT_RANGE then
                for _, fruit in ipairs(CONFIG.TARGET_FRUITS) do
                    if item.Name == fruit.Name then
                        safeTeleport(itemRoot.Position)
                        sendWebhook("Found fruit: " .. item.Name .. " (Priority: " .. fruit.Priority .. ")")
                        task.wait(0.05)
                        break
                    end
                end
            end
        end
    end
end

local function fruitNotifier()
    for _, item in ipairs(Workspace:GetChildren()) do
        if item:IsA("Model") and item:FindFirstChild("TouchInterest") then
            for _, fruit in ipairs(CONFIG.TARGET_FRUITS) do
                if item.Name == fruit.Name then
                    local billboard = getESPBillboard()
                    billboard.Name = "FruitESP"
                    billboard.Parent = item
                    billboard.Label.Text = item.Name .. " (" .. fruit.Priority .. ")"
                    billboard.Label.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end

local function autoQuest()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    local sea = level < 700 and "FirstSea" or (level < 1500 and "SecondSea" or "ThirdSea")
    
    for _, island in ipairs(SEA_DATA[sea].Islands) do
        if level >= island.Level then
            safeTeleport(island.Pos)
            for _, npcName in ipairs(island.NPCs) do
                local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild(npcName)
                if npc and npc:FindFirstChild("HumanoidRootPart") then
                    safeTeleport(npc.HumanoidRootPart.Position)
                    task.wait(0.1)
                    local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                    break
                end
            end
            break
        end
    end
end

local function autoCompleteQuests()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    local sea = level < 700 and "FirstSea" or (level < 1500 and "SecondSea" or "ThirdSea")
    
    local keyQuests = {
        {Name = "Bartilo", Sea = "SecondSea", Level = 850, NPC = "Bartilo", Pos = SEA_DATA.SecondSea.Islands[1].Pos, Remote = "BartiloQuest"},
        {Name = "Hungry Man", Sea = "ThirdSea", Level = 1775, NPC = "Hungry Man", Pos = SEA_DATA.ThirdSea.Islands[4].Pos, Remote = "HungryManQuest"},
        {Name = "Colosseum", Sea = "FirstSea", Level = 225, NPC = "Colosseum Quest Giver", Pos = SEA_DATA.FirstSea.Islands[10].Pos, Remote = "ColosseumQuest"},
        {Name = "Temple of Time", Sea = "ThirdSea", Level = 2000, NPC = "Mysterious Force", Pos = SEA_DATA.ThirdSea.Islands[5].Pos, Remote = "TempleQuest"},
    }
    
    for _, quest in ipairs(keyQuests) do
        if level >= quest.Level and sea == quest.Sea then
            safeTeleport(quest.Pos)
            local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild(quest.NPC)
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                safeTeleport(npc.HumanoidRootPart.Position)
                task.wait(0.1)
                local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
                ReplicatedStorage.Remotes.Quest:FireServer(quest.Remote)
                sendWebhook("Completing quest: " .. quest.Name)
            end
            break
        end
    end
end

local function autoStat()
    local stats = LocalPlayer:WaitForChild("Data"):WaitForChild("Stats")
    local points = stats:WaitForChild("Points").Value
    if points > 0 then
        local stat = CONFIG.AUTO_STAT
        if stat == "Dynamic" then
            local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
            stat = level < 1000 and "Melee" or (level < 2000 and "Fruit" or "Defense")
        end
        ReplicatedStorage.Remotes.Stats:FireServer(stat, points)
    end
end

local function statsOptimizer()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    local stats = LocalPlayer:WaitForChild("Data"):WaitForChild("Stats")
    local points = stats:WaitForChild("Points").Value
    if points > 0 then
        local statPriority = level < 1000 and "Melee" or (level < 2000 and "Fruit" or "Defense")
        ReplicatedStorage.Remotes.Stats:FireServer(statPriority, points)
    end
end

local function autoGear()
    local shop = Workspace:FindFirstChild("Shops") or Workspace:FindFirstChild("Vendors")
    if shop then
        for _, vendor in ipairs(shop:GetChildren()) do
            if vendor:FindFirstChild("HumanoidRootPart") then
                safeTeleport(vendor.HumanoidRootPart.Position)
                task.wait(0.1)
                local prompt = vendor:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
                ReplicatedStorage.Remotes.BuyHaki:FireServer("Buso")
                ReplicatedStorage.Remotes.BuyHaki:FireServer("Ken")
                ReplicatedStorage.Remotes.BuyItem:FireServer("Katana")
                ReplicatedStorage.Remotes.BuyItem:FireServer("Shark Anchor")
                ReplicatedStorage.Remotes.BuyItem:FireServer("Cursed Dual Katana")
                ReplicatedStorage.Remotes.BuyItem:FireServer("Buddy Sword")
                task.wait(0.1)
            end
        end
    end
end

local function masteryFarm()
    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
    if tool then
        local npc = findClosestNPC()
        if npc then
            attackNPC(npc)
            for _, skill in ipairs({"Z", "X", "C", "V", "F"}) do
                ReplicatedStorage.Remotes.UseSkill:FireServer(tool.Name, skill)
                task.wait(0.01)
            end
        end
    end
end

local function autoHaki()
    ReplicatedStorage.Remotes.BuyHaki:FireServer("Buso")
    ReplicatedStorage.Remotes.BuyHaki:FireServer("Ken")
    task.wait(0.1)
end

local function esp()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if (obj:IsA("Model") and obj:FindFirstChild("TouchInterest")) or (obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0) or obj.Name:match("Chest") then
            local billboard = getESPBillboard()
            billboard.Name = "ESP"
            billboard.Parent = obj
            billboard.Label.Text = obj.Name .. " (" .. math.round((obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Part")).Position - HumanoidRootPart.Position).Magnitude .. " studs)"
            billboard.Label.TextColor3 = obj:FindFirstChild("TouchInterest") and Color3.fromRGB(255, 0, 0) or (obj:FindFirstChild("Humanoid") and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 255, 0))
        end
    end
end

local function autoSecondSea()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 700 then
        local questGiver = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Military Detective")
        if questGiver then
            safeTeleport(questGiver.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = questGiver:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.Teleport:FireServer("SecondSea")
        end
    end
end

local function autoThirdSea()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1500 then
        local questGiver = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Bartilo")
        if questGiver then
            safeTeleport(questGiver.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = questGiver:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
        local kingRedHead = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("King Red Head")
        if kingRedHead then
            safeTeleport(kingRedHead.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = kingRedHead:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
        ReplicatedStorage.Remotes.Teleport:FireServer("ThirdSea")
    end
end

local function autoBartilo()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 850 then
        local kingdomOfRose = SEA_DATA.SecondSea.Islands[1]
        safeTeleport(kingdomOfRose.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Bartilo")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
        ReplicatedStorage.Remotes.Quest:FireServer("BartiloQuest")
        task.wait(0.1)
    end
end

local function autoV2FightingStyles()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1100 then
        local hotAndCold = SEA_DATA.SecondSea.Islands[5]
        safeTeleport(hotAndCold.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Previous Hero")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
        ReplicatedStorage.Remotes.BuyItem:FireServer("Death Step")
        ReplicatedStorage.Remotes.BuyItem:FireServer("Electric")
        task.wait(0.1)
    end
end

local function autoSuperhuman()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1100 then
        local kingdomOfRose = SEA_DATA.SecondSea.Islands[1]
        safeTeleport(kingdomOfRose.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Martial Arts Master")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
        ReplicatedStorage.Remotes.BuyItem:FireServer("Superhuman")
        task.wait(0.1)
    end
end

local function autoSeaEvents()
    local seaEvents = Workspace:FindFirstChild("SeaEvents")
    if seaEvents then
        for _, event in ipairs(seaEvents:GetChildren()) do
            if event.Name == "Ship Raid" or event.Name == "Sea Serpent" then
                safeTeleport(event.HumanoidRootPart.Position)
                attackNPC(event)
                sendWebhook("Sea event detected: " .. event.Name)
                task.wait(0.1)
            end
        end
    end
end

local function autoBuyHakiColors()
    local greatTree = SEA_DATA.ThirdSea.Islands[3]
    safeTeleport(greatTree.Pos)
    local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Master of Auras")
    if npc then
        safeTeleport(npc.HumanoidRootPart.Position)
        task.wait(0.1)
        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        end
        ReplicatedStorage.Remotes.BuyHaki:FireServer("Color")
        task.wait(0.1)
    end
end

local function autoFarmDrops()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    local sea = level < 700 and "FirstSea" or (level < 1500 and "SecondSea" or "ThirdSea")
    
    local targetDrops = {
        {"Hellfire Torch", "Cursed Captain", "SecondSea", SEA_DATA.SecondSea.Islands[6].Pos},
        {"Mirror Fractal", "Mirage Island", "ThirdSea", Vector3.new(0, 50, 0)},
        {"Leviathan Scales", "Leviathan", "ThirdSea", Vector3.new(0, 50, 0)},
        {"Cursed Dual Katana", "Longma", "ThirdSea", SEA_DATA.ThirdSea.Islands[8].Pos},
    }
    
    for _, drop in ipairs(targetDrops) do
        if sea == drop[3] then
            safeTeleport(drop[4])
            local target = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild(drop[2])
            if target then
                attackNPC(target)
                sendWebhook("Farming for " .. drop[1])
            end
            break
        end
    end
end

local function autoServerRank()
    local players = Players:GetPlayers()
    local totalLevel = 0
    local highGearCount = 0
    for _, player in ipairs(players) do
        local level = player:WaitForChild("Data"):WaitForChild("Level").Value
        totalLevel = totalLevel + level
        local gear = player.Backpack:FindFirstChildOfClass("Tool") or player.Character and player.Character:FindFirstChildOfClass("Tool")
        if gear and table.find({"Cursed Dual Katana", "Shark Anchor", "Tushita", "Yama"}, gear.Name) then
            highGearCount = highGearCount + 1
        end
    end
    local avgLevel = totalLevel / #players
    local competitiveness = avgLevel > 1500 and highGearCount > #players / 2 and "High" or "Low"
    sendWebhook("Server Rank: " .. competitiveness .. " (Avg Level: " .. math.round(avgLevel) .. ", High Gear: " .. highGearCount .. "/" .. #players .. ")")
    return competitiveness
end

local function autoTradeOptimizer()
    local fruits = LocalPlayer.Backpack:GetChildren()
    local tradeValue = {
        ["Kitsune-Kitsune"] = 1000,
        ["Dragon-Dragon"] = 900,
        ["Leopard-Leopard"] = 800,
        ["Dough-Dough"] = 700,
    }
    local bestFruit = nil
    local bestValue = 0
    for _, fruit in ipairs(fruits) do
        if fruit:IsA("Tool") and tradeValue[fruit.Name] and tradeValue[fruit.Name] > bestValue then
            bestFruit = fruit
            bestValue = tradeValue[fruit.Name]
        end
    end
    if bestFruit then
        local tradeNPC = Workspace:FindFirstChild("Trade") or Workspace:FindFirstChild("Trading")
        if tradeNPC then
            safeTeleport(tradeNPC.HumanoidRootPart.Position)
            local prompt = tradeNPC:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.Trade:FireServer(bestFruit.Name, bestValue * 1000)
            sendWebhook("Trading " .. bestFruit.Name .. " for " .. bestValue * 1000 .. " Beli")
            task.wait(0.1)
        end
    end
end

local function autoMiragePuzzles()
    local mirage = Workspace:FindFirstChild("Mirage Island")
    if mirage then
        safeTeleport(mirage.HumanoidRootPart.Position)
        local puzzles = mirage:FindFirstChild("Puzzles")
        if puzzles then
            for _, puzzle in ipairs(puzzles:GetChildren()) do
                local prompt = puzzle:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    safeTeleport(puzzle.Position)
                    fireproximityprompt(prompt)
                    sendWebhook("Solving Mirage Island puzzle: " .. puzzle.Name)
                    task.wait(0.1)
                end
            end
        end
        ReplicatedStorage.Remotes.Quest:FireServer("MirrorFractal")
        task.wait(0.1)
    else
        sendWebhook("Mirage Island not found. Server hopping...")
        if Toggles.ServerHop then
            TeleportService:Teleport(game.PlaceId)
        end
    end
end

local function autoLegendarySword()
    local swords = {"Rengoku", "Buddy Sword", "Cursed Dual Katana", "Shark Anchor", "Tushita", "Yama"}
    for _, sword in ipairs(swords) do
        ReplicatedStorage.Remotes.BuyItem:FireServer(sword)
        task.wait(0.1)
    end
end

local function autoRaceV3()
    local race = LocalPlayer:WaitForChild("Data"):WaitForChild("Race").Value
    if race == "Human" or race == "Mink" then
        ReplicatedStorage.Remotes.UpgradeRace:FireServer("V3")
        task.wait(0.1)
    end
end

local function autoRaceV4()
    local race = LocalPlayer:WaitForChild("Data"):WaitForChild("Race").Value
    if race == "Human" or race == "Mink" then
        local temple = Workspace:FindFirstChild("Temple of Time")
        if temple then
            safeTeleport(temple.HumanoidRootPart.Position)
            ReplicatedStorage.Remotes.UpgradeRace:FireServer("V4")
            task.wait(0.1)
        end
    end
end

local function chestFarm()
    for _, chest in ipairs(Workspace:GetChildren()) do
        if chest.Name:match("Chest") and chest:IsA("Model") then
            local chestRoot = chest:FindFirstChild("Part") or chest:FindFirstChild("Handle")
            if chestRoot then
                safeTeleport(chestRoot.Position)
                task.wait(0.05)
            end
        end
    end
end

local function autoEvent()
    local eventFolder = Workspace:FindFirstChild("Events")
    if eventFolder then
        for _, event in ipairs(eventFolder:GetChildren()) do
            if event:FindFirstChild("HumanoidRootPart") then
                safeTeleport(event.HumanoidRootPart.Position)
                local prompt = event:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
                task.wait(0.1)
            end
        end
    end
end

local function autoAwaken()
    local fruit = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
    if fruit and table.find(CONFIG.TARGET_FRUITS, fruit.Name) then
        ReplicatedStorage.Remotes.AwakenFruit:FireServer(fruit.Name)
        task.wait(0.1)
    end
end

local function autoTerrorShark()
    local seaEvents = Workspace:FindFirstChild("SeaEvents")
    if seaEvents then
        for _, event in ipairs(seaEvents:GetChildren()) do
            if event.Name == "TerrorShark" or event.Name == "PrehistoricIsland" then
                safeTeleport(event.HumanoidRootPart.Position)
                attackNPC(event)
                task.wait(0.1)
            end
        end
    end
end

local function autoMirageIsland()
    local mirage = Workspace:FindFirstChild("Mirage Island")
    if mirage then
        safeTeleport(mirage.HumanoidRootPart.Position)
        local prompt = mirage:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        end
        task.wait(0.1)
    else
        sendWebhook("Mirage Island not found. Server hopping...")
        if Toggles.ServerHop then
            TeleportService:Teleport(game.PlaceId)
        end
    end
end

local function autoLeviathan()
    local leviathan = Workspace:FindFirstChild("Frozen Dimension")
    if leviathan then
        safeTeleport(leviathan.HumanoidRootPart.Position)
        attackNPC(leviathan)
        task.wait(0.1)
    else
        sendWebhook("Leviathan not found. Server hopping...")
        if Toggles.ServerHop then
            TeleportService:Teleport(game.PlaceId)
        end
    end
end

local function autoFragment()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1500 then
        local hauntedCastle = SEA_DATA.ThirdSea.Islands[6]
        safeTeleport(hauntedCastle.Pos)
        local npc = findClosestNPC()
        if npc then
            attackNPC(npc)
        end
    end
end

local function autoSaber()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 200 then
        local saberExpert = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Saber Expert")
        if saberExpert then
            safeTeleport(saberExpert.HumanoidRootPart.Position)
            attackNPC(saberExpert)
        end
    end
end

local function autoPole()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 150 then
        local thunderGod = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Thunder God")
        if thunderGod then
            safeTeleport(thunderGod.HumanoidRootPart.Position)
            attackNPC(thunderGod)
        end
    end
end

local function autoTushita()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 2000 then
        local floatingTurtle = SEA_DATA.ThirdSea.Islands[4]
        safeTeleport(floatingTurtle.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Hungry Man")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
        ReplicatedStorage.Remotes.Quest:FireServer("Tushita")
        task.wait(0.1)
    end
end

local function autoElectricClaw()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1100 then
        local hotAndCold = SEA_DATA.SecondSea.Islands[5]
        safeTeleport(hotAndCold.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Previous Hero")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
        ReplicatedStorage.Remotes.BuyItem:FireServer("Electric Claw")
        task.wait(0.1)
    end
end

local function autoDragonTalon()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1500 then
        local tikiOutpost = SEA_DATA.ThirdSea.Islands[8]
        safeTeleport(tikiOutpost.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Dragon Talon Sage")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.BuyItem:FireServer("Dragon Talon")
            sendWebhook("Attempting to unlock Dragon Talon")
            task.wait(0.1)
        end
    end
end

local function autoGodhuman()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1500 then
        local floatingTurtle = SEA_DATA.ThirdSea.Islands[4]
        safeTeleport(floatingTurtle.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Master of Enhancement")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.BuyItem:FireServer("Godhuman")
            sendWebhook("Attempting to unlock Godhuman")
            task.wait(0.1)
        end
    end
end

local function autoStoreFruits()
    local fruits = LocalPlayer.Backpack:GetChildren()
    for _, fruit in ipairs(fruits) do
        if fruit:IsA("Tool") and table.find(CONFIG.TARGET_FRUITS, fruit.Name) then
            ReplicatedStorage.Remotes.StoreFruit:FireServer(fruit.Name)
            sendWebhook("Storing fruit: " .. fruit.Name)
            task.wait(0.1)
        end
    end
end

local function autoEquipBestGear()
    local bestWeapons = {"Cursed Dual Katana", "Shark Anchor", "Tushita", "Yama", "Buddy Sword", "Rengoku"}
    for _, weapon in ipairs(bestWeapons) do
        local tool = LocalPlayer.Backpack:FindFirstChild(weapon)
        if tool then
            tool.Parent = Character
            sendWebhook("Equipped best gear: " .. weapon)
            break
        end
    end
end

local function autoJoinCrew()
    if LocalPlayer:WaitForChild("Data"):WaitForChild("Crew").Value == 0 then
        local crewNPC = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Crew Captain")
        if crewNPC then
            safeTeleport(crewNPC.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = crewNPC:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.JoinCrew:FireServer(CONFIG.TEAM)
            sendWebhook("Joining crew: " .. CONFIG.TEAM)
            task.wait(0.1)
        end
    end
end

local function autoServerBoost()
    local serverData = ReplicatedStorage:FindFirstChild("ServerData")
    if serverData and serverData:FindFirstChild("Boost") then
        sendWebhook("Server boost detected: " .. serverData.Boost.Value)
    else
        sendWebhook("No server boost detected. Server hopping...")
        if Toggles.ServerHop then
            TeleportService:Teleport(game.PlaceId)
        end
    end
end

local function autoElitePirates()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1500 then
        local greatTree = SEA_DATA.ThirdSea.Islands[3]
        safeTeleport(greatTree.Pos)
        local npc = findClosestNPC()
        if npc and npc.Name:match("Elite Pirate") then
            attackNPC(npc)
            sendWebhook("Farming Elite Pirates")
        end
    end
end

local function autoCursedDualKatana()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 2000 then
        local tikiOutpost = SEA_DATA.ThirdSea.Islands[8]
        safeTeleport(tikiOutpost.Pos)
        local longma = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Longma")
        if longma then
            safeTeleport(longma.HumanoidRootPart.Position)
            attackNPC(longma)
            sendWebhook("Farming Longma for Cursed Dual Katana")
        end
        ReplicatedStorage.Remotes.Quest:FireServer("CursedDualKatana")
        task.wait(0.1)
    end
end

local function autoSharkmanKarate()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1425 then
        local forgottenIsland = SEA_DATA.SecondSea.Islands[8]
        safeTeleport(forgottenIsland.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Daigrock The Sharkman")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.BuyItem:FireServer("Sharkman Karate")
            sendWebhook("Attempting to unlock Sharkman Karate")
            task.wait(0.1)
        end
    end
end

local function autoDarkStep()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 400 then
        local underwaterCity = SEA_DATA.FirstSea.Islands[12]
        safeTeleport(underwaterCity.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Water Kung Fu Teacher")
        if npc then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.BuyItem:FireServer("Dark Step")
            sendWebhook("Attempting to unlock Dark Step")
            task.wait(0.1)
        end
    end
end

local function autoBuyBoats()
    local boatVendor = Workspace:FindFirstChild("Vendors") and Workspace.Vendors:FindFirstChild("Boat Dealer")
    if boatVendor then
        safeTeleport(boatVendor.HumanoidRootPart.Position)
        task.wait(0.1)
        local prompt = boatVendor:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        end
        ReplicatedStorage.Remotes.BuyItem:FireServer("Guardian")
        sendWebhook("Purchasing Guardian boat")
        task.wait(0.1)
    end
end

local function autoSpinFruit()
    local bloxFruitDealer = Workspace:FindFirstChild("Vendors") and Workspace.Vendors:FindFirstChild("Blox Fruit Dealer")
    if bloxFruitDealer then
        safeTeleport(bloxFruitDealer.HumanoidRootPart.Position)
        task.wait(0.1)
        local prompt = bloxFruitDealer:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        end
        ReplicatedStorage.Remotes.SpinFruit:FireServer()
        sendWebhook("Spinning for a new fruit")
        task.wait(0.1)
    end
end

local function autoDetectRareSpawns()
    local rareSpawns = {"Mirage Island", "Leviathan", "TerrorShark", "Cursed Captain", "Longma"}
    for _, spawn in ipairs(rareSpawns) do
        local entity = Workspace:FindFirstChild(spawn) or (Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild(spawn))
        if entity then
            safeTeleport(entity.HumanoidRootPart.Position)
            sendWebhook("Rare spawn detected: " .. spawn)
            task.wait(0.1)
            break
        end
    end
end

local function autoOptimizeInventory()
    local junkItems = {"Bomb-Bomb", "Spike-Spike", "Chop-Chop"}
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and table.find(junkItems, item.Name) then
            ReplicatedStorage.Remotes.DropItem:FireServer(item.Name)
            sendWebhook("Dropped junk item: " .. item.Name)
            task.wait(0.1)
        end
    end
end

local function autoTradeOptimizer()
    local fruits = LocalPlayer.Backpack:GetChildren()
    local tradeValue = {
        ["Kitsune-Kitsune"] = 1000,
        ["Dragon-Dragon"] = 900,
        ["Leopard-Leopard"] = 800,
        ["Dough-Dough"] = 700,
    }
    local bestFruit = nil
    local bestValue = 0
    for _, fruit in ipairs(fruits) do
        if fruit:IsA("Tool") and tradeValue[fruit.Name] and tradeValue[fruit.Name] > bestValue then
            bestFruit = fruit
            bestValue = tradeValue[fruit.Name]
        end
    end
    if bestFruit then
        local tradeNPC = Workspace:FindFirstChild("Trade") or Workspace:FindFirstChild("Trading")
        if tradeNPC then
            safeTeleport(tradeNPC.HumanoidRootPart.Position)
            local prompt = tradeNPC:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            ReplicatedStorage.Remotes.Trade:FireServer(bestFruit.Name, bestValue * 1000)
            sendWebhook("Trading " .. bestFruit.Name .. " for " .. bestValue * 1000 .. " Beli")
            task.wait(0.1)
        end
    end
end

local function autoMiragePuzzles()
    local mirage = Workspace:FindFirstChild("Mirage Island")
    if mirage then
        safeTeleport(mirage.HumanoidRootPart.Position)
        local puzzles = mirage:FindFirstChild("Puzzles")
        if puzzles then
            for _, puzzle in ipairs(puzzles:GetChildren()) do
                local prompt = puzzle:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    safeTeleport(puzzle.Position)
                    fireproximityprompt(prompt)
                    sendWebhook("Solving Mirage Island puzzle: " .. puzzle.Name)
                    task.wait(0.1)
                end
            end
        end
        ReplicatedStorage.Remotes.Quest:FireServer("MirrorFractal")
        task.wait(0.1)
    else
        sendWebhook("Mirage Island not found. Server hopping...")
        if Toggles.ServerHop then
            TeleportService:Teleport(game.PlaceId)
        end
    end
end

local function autoSeaBeast()
    local seaEvents = Workspace:FindFirstChild("SeaEvents")
    if seaEvents then
        for _, event in ipairs(seaEvents:GetChildren()) do
            if event.Name == "Sea Beast" then
                safeTeleport(event.HumanoidRootPart.Position)
                attackNPC(event)
                sendWebhook("Farming Sea Beast")
                task.wait(0.1)
            end
        end
    end
end

local function cleanUp()
    for _, billboard in ipairs(Workspace:GetChildren()) do
        if billboard.Name == "ESP" or billboard.Name == "FruitESP" then
            releaseESPBillboard(billboard)
        end
    end
    collectgarbage("collect")
    sendWebhook("Performed memory cleanup")
end

-- Main Loop
local function main()
    local ScreenGui, StatsLabel, addLog = createUI()
    optimizePerformance()

    -- Anti-AFK
    task.spawn(function()
        while true do
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
            task.wait(math.random(300, 600))
        end
    end)

    -- Stats Dashboard
    task.spawn(function()
        while true do
            local beli = LocalPlayer:WaitForChild("Data"):WaitForChild("Beli").Value
            local fragments = LocalPlayer:WaitForChild("Data"):WaitForChild("Fragments").Value
            local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
            local mastery = LocalPlayer:WaitForChild("Data"):WaitForChild("Mastery").Value
            local fps = getFPS()
            local ping = getPing()
            local serverAge = getServerAge()
            local serverRank = Toggles.AutoServerRank and autoServerRank() or "Normal"
            StatsLabel.Text = string.format(
                "Beli: %d\nFragments: %d\nLevel: %d\nMastery: %d\nFPS: %d\nPing: %dms\nServer Age: %s\nServer: %s",
                beli, fragments, level, mastery, fps, ping, serverAge, serverRank
            )
            task.wait(1)
        end
    end)

    -- Server Hop Timer
    task.spawn(function()
        while true do
            if Toggles.ServerHop then
                task.wait(CONFIG.SERVER_HOP_INTERVAL)
                TeleportService:Teleport(game.PlaceId)
            end
            task.wait(1)
        end
    end)

    -- Main Feature Loop
    while true do
        if Toggles.AutoFarm then
            task.spawn(autoFarm)
        end

        if Toggles.AutoBoss then
            task.spawn(autoBoss)
        end

        if Toggles.AutoRaid then
            task.spawn(autoRaid)
        end

        if Toggles.AutoQuest then
            task.spawn(autoQuest)
        end

        if Toggles.AutoFruit then
            task.spawn(collectFruits)
        end

        if Toggles.AutoStat then
            task.spawn(autoStat)
        end

        if Toggles.FastAttack then
            task.spawn(function()
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
                if tool then
                    for _ = 1, 15 do
                        tool:Activate()
                        task.wait(0.01)
                    end
                end
            end)
        end

        if Toggles.ESP then
            task.spawn(esp)
            task.spawn(fruitNotifier)
        end

        if Toggles.AutoGear then
            task.spawn(autoGear)
        end

        if Toggles.MasteryFarm then
            task.spawn(masteryFarm)
        end

        if Toggles.AutoHaki then
            task.spawn(autoHaki)
        end

        if Toggles.AutoSecondSea then
            task.spawn(autoSecondSea)
        end

        if Toggles.AutoThirdSea then
            task.spawn(autoThirdSea)
        end

        if Toggles.AutoLegendarySword then
            task.spawn(autoLegendarySword)
        end

        if Toggles.AutoRaceV3 then
            task.spawn(autoRaceV3)
        end

        if Toggles.AutoRaceV4 then
            task.spawn(autoRaceV4)
        end

        if Toggles.ChestFarm then
            task.spawn(chestFarm)
        end

        if Toggles.AutoEvent then
            task.spawn(autoEvent)
        end

        if Toggles.AutoAwaken then
            task.spawn(autoAwaken)
        end

        if Toggles.AutoTerrorShark then
            task.spawn(autoTerrorShark)
        end

        if Toggles.AutoMirageIsland then
            task.spawn(autoMirageIsland)
        end

        if Toggles.AutoLeviathan then
            task.spawn(autoLeviathan)
        end

        if Toggles.AutoFragment then
            task.spawn(autoFragment)
        end

        if Toggles.AutoSaber then
            task.spawn(autoSaber)
        end

        if Toggles.AutoPole then
            task.spawn(autoPole)
        end

        if Toggles.AutoTushita then
            task.spawn(autoTushita)
        end

        if Toggles.AutoElectricClaw then
            task.spawn(autoElectricClaw)
        end

        if Toggles.AutoDragonTalon then
            task.spawn(autoDragonTalon)
        end

        if Toggles.AutoGodhuman then
            task.spawn(autoGodhuman)
        end

        if Toggles.AutoStoreFruits then
            task.spawn(autoStoreFruits)
        end

        if Toggles.AutoEquipBestGear then
            task.spawn(autoEquipBestGear)
        end

        if Toggles.AutoJoinCrew then
            task.spawn(autoJoinCrew)
        end

        if Toggles.AutoServerBoost then
            task.spawn(autoServerBoost)
        end

        if Toggles.AutoElitePirates then
            task.spawn(autoElitePirates)
        end

        if Toggles.AutoCursedDualKatana then
            task.spawn(autoCursedDualKatana)
        end

        if Toggles.AutoSharkmanKarate then
            task.spawn(autoSharkmanKarate)
        end

        if Toggles.AutoDarkStep then
            task.spawn(autoDarkStep)
        end

        if Toggles.AutoBuyBoats then
            task.spawn(autoBuyBoats)
        end

        if Toggles.AutoSpinFruit then
            task.spawn(autoSpinFruit)
        end

        if Toggles.AutoDetectRareSpawns then
            task.spawn(autoDetectRareSpawns)
        end

        if Toggles.AutoOptimizeInventory then
            task.spawn(autoOptimizeInventory)
        end

        if Toggles.AutoTradeOptimizer then
            task.spawn(autoTradeOptimizer)
        end

        if Toggles.AutoMiragePuzzles then
            task.spawn(autoMiragePuzzles)
        end

        if Toggles.AutoSeaBeast then
            task.spawn(autoSeaBeast)
        end

        if Toggles.AutoCompleteQuests then
            task.spawn(autoCompleteQuests)
        end

        if Toggles.AutoFarmDrops then
            task.spawn(autoFarmDrops)
        end

        if Toggles.AutoSuperhuman then
            task.spawn(autoSuperhuman)
        end

        if Toggles.AutoServerRank then
            task.spawn(autoServerRank)
        end

        if Toggles.AutoBartilo then
            task.spawn(autoBartilo)
        end

        if Toggles.AutoV2FightingStyles then
            task.spawn(autoV2FightingStyles)
        end

        if Toggles.AutoSeaEvents then
            task.spawn(autoSeaEvents)
        end

        if Toggles.AutoBuyHakiColors then
            task.spawn(autoBuyHakiColors)
        end

        -- Memory cleanup
        task.spawn(cleanUp)

        -- Error handling
        local success, err = pcall(function()
            task.wait(0.1)
        end)
        if not success then
            addLog("Error detected: " .. tostring(err))
            sendWebhook("Error detected: " .. tostring(err))
            task.wait(1) -- Prevent crash loop
        end
    end
end

-- Initialize
local success, err = pcall(main)
if not success then
    addLog("Initialization failed: " .. tostring(err))
    sendWebhook("Initialization failed: " .. tostring(err))
    task.wait(5)
    pcall(main) -- Retry
end

-- Character reset handling
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
    addLog("Character reset detected. Reinitializing...")
    sendWebhook("Character reset detected. Reinitializing...")
end)

-- Anti-cheat safety
task.spawn(function()
    while true do
        if Humanoid.WalkSpeed > 16 then
            Humanoid.WalkSpeed = 16
        end
        if Humanoid.JumpPower > 50 then
            Humanoid.JumpPower = 50
        end
        task.wait(1)
    end
end)

-- Disconnect handling
game:BindToClose(function()
    cleanUp()
    sendWebhook("Script terminated. Cleaning up resources.")
end)

addLog("Ultra OmniHub initialized successfully!")
sendWebhook("Ultra OmniHub initialized successfully!")
