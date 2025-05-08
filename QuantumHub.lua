-- Dream Hub for Blox Fruits (Update 24, Dragon Update)
-- The ultimate script with military-grade anti-ban, advanced features, and cross-platform UI

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local CONFIG = {
    FARM_DISTANCE = 15,
    ATTACK_DELAY = {Min = 0.08, Max = 0.12}, -- Randomized for anti-detection
    TELEPORT_SPEED = 300,
    TARGET_FRUITS = {
        "Kitsune-Kitsune", "Dragon-Dragon", "Leopard-Leopard", "T-Rex-T-Rex",
        "Mammoth-Mammoth", "Dough-Dough", "Shadow-Shadow", "Venom-Venom",
        "Control-Control", "Spirit-Spirit", "Dark-Dark", "Rumble-Rumble",
        "Human-Human: Buddha", "Flame-Flame", "Gravity-Gravity"
    },
    WEBHOOK_URL = "", -- Add your Discord webhook URL
    FPS_CAP = 30,
    LOW_TEXTURES = true,
    WHITE_SCREEN = false,
    TOGGLE_KEY = Enum.KeyCode.F4,
    TEAM = "Pirates", -- "Pirates" or "Marines"
    AUTO_EXECUTE = true,
    PRIORITY_ITEMS = {
        SWORDS = {"Canvander", "Buddy Sword", "Cursed Dual Katana", "Shark Anchor"},
        GUNS = {"Acidum Rifle", "Venom Bow", "Soul Guitar"},
        ACCESSORIES = {"Black Spikey Coat", "Cool Shades", "Holy Crown"}
    },
    ANTI_BAN = {
        MAX_WALK_SPEED = 16,
        MAX_JUMP_POWER = 50,
        ACTION_RATE_LIMIT = 100, -- Actions per minute
        TELEPORT_COOLDOWN = 0.5,
        HUMAN_INPUT_SIMULATION = true,
        OBFUSCATION_LEVEL = "High",
        DYNAMIC_URL = "https://raw.githubusercontent.com/dreamhub-secure/dynamic/main/loader.lua"
    }
}

-- Sea Data
local SEA_DATA = {
    FirstSea = {
        Islands = {
            Windmill = {Pos = Vector3.new(979, 16, 1429), Quests = {"Defeat 5 Bandits"}, NPCs = {"Bandit"}},
            MarineStarter = {Pos = Vector3.new(-2605, 7, 5153), Quests = {"Defeat 4 Marine Soldiers"}, NPCs = {"Marine Soldier"}},
            MiddleTown = {Pos = Vector3.new(-950, 7, 1512), Quests = {"Defeat 8 Bandits"}, NPCs = {"Bandit"}},
            Jungle = {Pos = Vector3.new(-1324, 15, 3896), Quests = {"Defeat 6 Monkeys"}, NPCs = {"Monkey"}},
            PirateVillage = {Pos = Vector3.new(-1182, 5, 3832), Quests = {"Defeat 7 Pirates"}, NPCs = {"Pirate"}},
            Desert = {Pos = Vector3.new(896, 6, 4453), Quests = {"Defeat 8 Desert Bandits"}, NPCs = {"Desert Bandit"}},
            FrozenVillage = {Pos = Vector3.new(1047, 8, 1139), Quests = {"Defeat 9 Snow Bandits"}, NPCs = {"Snow Bandit"}},
            MarineFortress = {Pos = Vector3.new(-4986, 40, 4050), Quests = {"Defeat 10 Marine Lieutenants"}, NPCs = {"Marine Lieutenant"}},
            Skylands = {Pos = Vector3.new(-4867, 717, -2667), Quests = {"Defeat 5 Sky Bandits"}, NPCs = {"Sky Bandit"}},
            Prison = {Pos = Vector3.new(4875, 8, 432), Quests = {"Defeat 6 Prisoners"}, NPCs = {"Prisoner"}},
            Colosseum = {Pos = Vector3.new(-1648, 7, 2953), Quests = {"Defeat 8 Gladiators"}, NPCs = {"Gladiator"}},
            MagmaVillage = {Pos = Vector3.new(-5247, 9, 8450), Quests = {"Defeat 9 Magma Ninjas"}, NPCs = {"Magma Ninja"}},
            UnderwaterCity = {Pos = Vector3.new(3876, 6, -3400), Quests = {"Defeat 10 Fishman Warriors"}, NPCs = {"Fishman Warrior"}},
            FountainCity = {Pos = Vector3.new(5156, 16, 989), Quests = {"Defeat 11 Galley Pirates"}, NPCs = {"Galley Pirate"}}
        },
        Bosses = {
            {Name = "Gorilla King", Level = 25, Pos = Vector3.new(-1324, 15, 3896)},
            {Name = "Bobby", Level = 55, Pos = Vector3.new(-1182, 5, 3832)},
            {Name = "Yeti", Level = 110, Pos = Vector3.new(1047, 8, 1139)},
            {Name = "Vice Admiral", Level = 130, Pos = Vector3.new(-4986, 40, 4050)},
            {Name = "Warden", Level = 175, Pos = Vector3.new(4875, 8, 432)},
            {Name = "Chief Warden", Level = 200, Pos = Vector3.new(4875, 8, 432)},
            {Name = "Swan", Level = 240, Pos = Vector3.new(4875, 8, 432)},
            {Name = "Magma Admiral", Level = 350, Pos = Vector3.new(-5247, 9, 8450)},
            {Name = "Fishman Lord", Level = 425, Pos = Vector3.new(3876, 6, -3400)},
            {Name = "Wysper", Level = 500, Pos = Vector3.new(5156, 16, 989)},
            {Name = "Thunder God", Level = 575, Pos = Vector3.new(-4867, 717, -2667)},
            {Name = "Cyborg", Level = 675, Pos = Vector3.new(5156, 16, 989)}
        }
    },
    SecondSea = {
        Islands = {
            Cafe = {Pos = Vector3.new(-380, 74, 297), Quests = {"Defeat 8 Raiders"}, NPCs = {"Raider"}},
            GreenZone = {Pos = Vector3.new(-2100, 72, -950), Quests = {"Defeat 9 Forest Pirates"}, NPCs = {"Forest Pirate"}},
            Graveyard = {Pos = Vector3.new(-5400, 15, 850), Quests = {"Defeat 8 Zombies"}, NPCs = {"Zombie"}},
            SnowMountain = {Pos = Vector3.new(600, 402, -5300), Quests = {"Defeat 8 Snow Bandits"}, NPCs = {"Snow Bandit"}},
            HotAndCold = {Pos = Vector3.new(-5900, 15, -2600), Quests = {"Defeat 9 Lab Subordinates"}, NPCs = {"Lab Subordinate"}},
            CursedShip = {Pos = Vector3.new(-6500, 15, 1500), Quests = {"Defeat 9 Dark Masters"}, NPCs = {"Dark Master"}},
            IceCastle = {Pos = Vector3.new(5500, 40, -6100), Quests = {"Defeat 10 Arctic Warriors"}, NPCs = {"Arctic Warrior"}},
            ForgottenIsland = {Pos = Vector3.new(-3050, 16, -9900), Quests = {"Defeat 11 Sea Soldiers"}, NPCs = {"Sea Soldier"}},
            UsoapsIsland = {Pos = Vector3.new(4747, 15, 750), Quests = {"Defeat 8 Gunmen"}, NPCs = {"Gunman"}},
            DarkArena = {Pos = Vector3.new(-380, 74, 297), Quests = {"Defeat Darkbeard"}, NPCs = {"Darkbeard"}}
        },
        Bosses = {
            {Name = "Diamond", Level = 750, Pos = Vector3.new(-2100, 72, -950)},
            {Name = "Jeremy", Level = 850, Pos = Vector3.new(-2100, 72, -950)},
            {Name = "Fajita", Level = 925, Pos = Vector3.new(-2100, 72, -950)},
            {Name = "Don Swan", Level = 1000, Pos = Vector3.new(-380, 74, 297)},
            {Name = "Smoke Admiral", Level = 1150, Pos = Vector3.new(-5900, 15, -2600)},
            {Name = "Cursed Captain", Level = 1325, Pos = Vector3.new(-6500, 15, 1500)},
            {Name = "Awakened Ice Admiral", Level = 1400, Pos = Vector3.new(5500, 40, -6100)},
            {Name = "Tide Keeper", Level = 1475, Pos = Vector3.new(-3050, 16, -9900)}
        }
    },
    ThirdSea = {
        Islands = {
            PortTown = {Pos = Vector3.new(-310, 40, 6800), Quests = {"Defeat 12 Pirate Millionaires"}, NPCs = {"Pirate Millionaire"}},
            HydraIsland = {Pos = Vector3.new(5225, 603, 350), Quests = {"Defeat 13 Dragon Crew Warriors"}, NPCs = {"Dragon Crew Warrior"}},
            GreatTree = {Pos = Vector3.new(2175, 40, -6500), Quests = {"Defeat 14 Marine Commodores"}, NPCs = {"Marine Commodore"}},
            FloatingTurtle = {Pos = Vector3.new(-13250, 40, -8500), Quests = {"Defeat 15 Fishman Captains"}, NPCs = {"Fishman Captain"}},
            HauntedCastle = {Pos = Vector3.new(-9500, 40, 5500), Quests = {"Defeat 16 Bone Wraiths"}, NPCs = {"Bone Wraith"}},
            SeaOfTreats = {Pos = Vector3.new(-1500, 40, -10500), Quests = {"Defeat 17 Candy Pirates"}, NPCs = {"Candy Pirate"}},
            TikiOutpost = {Pos = Vector3.new(-16500, 40, 10500), Quests = {"Defeat 18 Tiki Outlaws"}, NPCs = {"Tiki Outlaw"}}
        },
        Bosses = {
            {Name = "Cake Prince", Level = 1500, Pos = Vector3.new(-1500, 40, -10500)},
            {Name = "Rip Indra", Level = 1600, Pos = Vector3.new(5225, 603, 350)},
            {Name = "Empress of Light", Level = 1650, Pos = Vector3.new(5225, 603, 350)},
            {Name = "Gravestone", Level = 1700, Pos = Vector3.new(-9500, 40, 5500)},
            {Name = "Captain Elephant", Level = 1800, Pos = Vector3.new(-13250, 40, -8500)},
            {Name = "Beautiful Pirate", Level = 1900, Pos = Vector3.new(-310, 40, 6800)},
            {Name = "Longma", Level = 2000, Pos = Vector3.new(-13250, 40, -8500)},
            {Name = "Stone", Level = 2100, Pos = Vector3.new(-310, 40, 6800)},
            {Name = "Island Emperor", Level = 2200, Pos = Vector3.new(-16500, 40, 10500)},
            {Name = "Kilo Admiral", Level = 2300, Pos = Vector3.new(2175, 40, -6500)},
            {Name = "Captain Goodbeard", Level = 2400, Pos = Vector3.new(-16500, 40, 10500)}
        }
    }
}

-- Toggles
local Toggles = {
    AutoFarm = false,
    AutoBoss = false,
    AutoRaid = false,
    AutoQuest = false,
    FruitSniper = false,
    AutoHaki = false,
    AutoStats = false,
    AutoGear = false,
    ESP = false,
    AutoSeaEvent = false,
    AutoV2Race = false,
    AutoV3Race = false,
    AutoV4Race = false,
    AutoBartilo = false,
    AutoCombatStyle = false,
    AutoServerHop = false,
    AutoDodgeSkills = false,
    Aimbot = false,
    KillAura = false,
    AutoParry = false,
    AutoBuyHaki = false,
    AutoUpgradeWeapons = false,
    AutoFindPrehistoric = false,
    AutoLeviathan = false,
    AutoKitsune = false,
    AutoTerrorshark = false,
    AutoChest = false,
    AutoMiragePuzzle = false,
    AutoDojoTrainer = false,
    AutoVolcanicMagnet = false
}

-- Anti-Ban System
local AntiBan = {
    ActionCount = 0,
    LastActionTime = os.clock(),
    BanRiskLevel = 0,
    DetectedExecutors = {"Synapse", "Krnl", "Delta", "Fluxus", "Codex"},
    SpoofedAttributes = {WalkSpeed = 16, JumpPower = 50},
    DynamicKey = HttpService:GenerateGUID(false)
}

local function obfuscateCode(code)
    if CONFIG.ANTI_BAN.OBFUSCATION_LEVEL == "High" then
        local key = HttpService:GenerateGUID(false)
        local obfuscated = ""
        for i = 1, #code do
            obfuscated = obfuscated .. string.char(bit32.bxor(string.byte(code, i), string.byte(key, (i % #key) + 1)))
        end
        return [[
            local key = "]] .. key .. [["
            local code = "]] .. obfuscated .. [["
            local deobfuscated = ""
            for i = 1, #code do
                deobfuscated = deobfuscated .. string.char(bit32.bxor(string.byte(code, i), string.byte(key, (i % #key) + 1)))
            end
            loadstring(deobfuscated)()
        ]]
    end
    return code
end

local function simulateHumanInput()
    if CONFIG.ANTI_BAN.HUMAN_INPUT_SIMULATION then
        local randDelay = math.random(0.05, 0.15)
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(math.random(0, 100), math.random(0, 100)))
        task.wait(randDelay)
    end
end

local function checkBanRisk()
    local currentTime = os.clock()
    if currentTime - AntiBan.LastActionTime >= 60 then
        AntiBan.ActionCount = 0
        AntiBan.LastActionTime = currentTime
    end
    AntiBan.ActionCount = AntiBan.ActionCount + 1
    if AntiBan.ActionCount > CONFIG.ANTI_BAN.ACTION_RATE_LIMIT then
        AntiBan.BanRiskLevel = AntiBan.BanRiskLevel + 0.1
        sendNotification("Warning: High action rate detected. Pausing for 5 seconds.")
        task.wait(5)
        AntiBan.ActionCount = 0
    end
    if AntiBan.BanRiskLevel > 0.5 then
        sendNotification("High ban risk detected. Disabling risky features.")
        Toggles.AutoFarm = false
        Toggles.AutoBoss = false
        Toggles.AutoRaid = false
    end
end

local function spoofAttributes()
    Humanoid.WalkSpeed = AntiBan.SpoofedAttributes.WalkSpeed
    Humanoid.JumpPower = AntiBan.SpoofedAttributes.JumpPower
end

-- UI Setup
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DreamHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Dream Hub - Blox Fruits"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    TitleLabel.TextSize = 22
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Parent = MainFrame

    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(0, 150, 1, -40)
    TabFrame.Position = UDim2.new(0, 0, 0, 40)
    TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabFrame.Parent = MainFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(0, 450, 1, -40)
    ContentFrame.Position = UDim2.new(0, 150, 0, 40)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -10, 1, -50)
    ScrollingFrame.Position = UDim2.new(0, 5, 0, 45)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.Parent = ContentFrame
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ScrollingFrame

    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(1, -10, 0, 30)
    SearchBar.Position = UDim2.new(0, 5, 0, 5)
    SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBar.Text = "Search Features..."
    SearchBar.TextSize = 16
    SearchBar.Font = Enum.Font.SourceSans
    SearchBar.Parent = ContentFrame

    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, -10, 0, 100)
    StatsFrame.Position = UDim2.new(0, 5, 1, -105)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    StatsFrame.Parent = ContentFrame

    local StatsLabel = Instance.new("TextLabel")
    StatsLabel.Size = UDim2.new(1, 0, 1, 0)
    StatsLabel.BackgroundTransparency = 1
    StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatsLabel.TextSize = 12
    StatsLabel.Text = "Stats: Loading..."
    StatsLabel.TextWrapped = true
    StatsLabel.Font = Enum.Font.SourceSans
    StatsLabel.Parent = StatsFrame

    -- Tabs
    local Tabs = {"Farming", "Combat", "Teleport", "Items", "PvP", "Settings", "Stats"}
    local TabButtons = {}
    local CurrentTab = "Farming"

    for i, tab in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Position = UDim2.new(0, 0, 0, (i-1)*40)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.TextColor3 = Color3.fromRGB(0, 255, 255)
        TabButton.Text = tab
        TabButton.TextSize = 16
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Parent = TabFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = TabButton

        TabButtons[tab] = TabButton

        TabButton.MouseButton1Click:Connect(function()
            CurrentTab = tab
            for _, btn in pairs(TabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            updateContent()
        end)
    end

    -- Feature Toggles
    local FeatureButtons = {}
    local function createToggle(feature, tab)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -10, 0, 30)
        Button.BackgroundColor3 = Toggles[feature] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Text = feature:gsub("([A-Z])", " %1"):sub(2)
        Button.TextSize = 14
        Button.Font = Enum.Font.SourceSans
        Button.Parent = ScrollingFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button

        Button.MouseButton1Click:Connect(function()
            Toggles[feature] = not Toggles[feature]
            Button.BackgroundColor3 = Toggles[feature] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            saveConfig()
        end)

        FeatureButtons[feature] = {Button = Button, Tab = tab}
    end

    -- Assign Features to Tabs
    local FeatureTabs = {
        Farming = {"AutoFarm", "AutoQuest", "AutoRaid", "AutoSeaEvent", "AutoFindPrehistoric", "AutoLeviathan", "AutoKitsune", "AutoTerrorshark", "AutoChest"},
        Combat = {"AutoBoss", "AutoHaki", "AutoCombatStyle", "AutoDodgeSkills", "AutoDojoTrainer"},
        Teleport = {"AutoV2Race", "AutoV3Race", "AutoV4Race", "AutoBartilo", "AutoMiragePuzzle"},
        Items = {"FruitSniper", "AutoStats", "AutoGear", "AutoBuyHaki", "AutoUpgradeWeapons", "AutoVolcanicMagnet"},
        PvP = {"Aimbot", "KillAura", "AutoParry"},
        Settings = {"AutoServerHop", "ESP"},
        Stats = {}
    }

    for tab, features in pairs(FeatureTabs) do
        for _, feature in ipairs(features) do
            createToggle(feature, tab)
        end
    end

    -- Update Content
    local function updateContent()
        for feature, data in pairs(FeatureButtons) do
            data.Button.Visible = (data.Tab == CurrentTab)
        end
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #FeatureTabs[CurrentTab] * 35)
    end
    updateContent()

    -- Search Functionality
    SearchBar.FocusLost:Connect(function()
        local query = SearchBar.Text:lower()
        for feature, data in pairs(FeatureButtons) do
            data.Button.Visible = (data.Tab == CurrentTab and (query == "" or feature:lower():find(query)))
        end
    end)

    -- Draggable and Resizable
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle UI
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == CONFIG.TOGGLE_KEY then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Mobile Optimization
    if UserInputService.TouchEnabled then
        MainFrame.Size = UDim2.new(0, 500, 0, 350)
        for _, button in pairs(FeatureButtons) do
            button.Button.TextSize = 16
            button.Button.Size = UDim2.new(1, -10, 0, 40)
        end
        SearchBar.TextSize = 18
        TitleLabel.TextSize = 24
    end

    -- Stats Update
    RunService.Heartbeat:Connect(function()
        local stats = string.format(
            "Beli: %s\nFragments: %s\nLevel: %d\nMastery: %d\nFPS: %d\nPing: %d\nServer Age: %s\nBan Risk: %.2f",
            LocalPlayer.Data.Beli.Value,
            LocalPlayer.Data.Fragments.Value,
            LocalPlayer.Data.Level.Value,
            LocalPlayer.Data.DevilFruitMastery and LocalPlayer.Data.DevilFruitMastery.Value or 0,
            math.floor(1 / RunService:GetFrameTime()),
            Players:GetPlayerPing(LocalPlayer) or 0,
            os.date("!%H:%M:%S", Workspace.ServerAge.Value),
            AntiBan.BanRiskLevel
        )
        StatsLabel.Text = stats
    end)

    -- Save/Load Config
    local function saveConfig()
        local configData = {Toggles = Toggles}
        pcall(function()
            writefile("DreamHubConfig.json", HttpService:JSONEncode(configData))
        end)
    end

    local function loadConfig()
        pcall(function()
            if isfile("DreamHubConfig.json") then
                local configData = HttpService:JSONDecode(readfile("DreamHubConfig.json"))
                for feature, state in pairs(configData.Toggles) do
                    Toggles[feature] = state
                    if FeatureButtons[feature] then
                        FeatureButtons[feature].Button.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end)
    end
    loadConfig()

    return ScreenGui
end

-- Core Functions
local function safeTeleport(pos)
    checkBanRisk()
    task.wait(math.random(CONFIG.ANTI_BAN.TELEPORT_COOLDOWN * 0.8, CONFIG.ANTI_BAN.TELEPORT_COOLDOWN * 1.2))
    local success, err = pcall(function()
        local tweenInfo = TweenInfo.new((HumanoidRootPart.Position - pos).Magnitude / CONFIG.TELEPORT_SPEED, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(pos)})
        tween:Play()
        tween.Completed:Wait()
    end)
    if not success then
        HumanoidRootPart.CFrame = CFrame.new(pos)
    end
    simulateHumanInput()
end

local function findClosestNPC(npcName)
    local closest, closestDist = nil, math.huge
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local dist = (npc.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closest = npc
                closestDist = dist
            end
        end
    end
    return closest
end

local function attackNPC(npc)
    if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
        safeTeleport(npc.HumanoidRootPart.Position + Vector3.new(0, CONFIG.FARM_DISTANCE, 0))
        ReplicatedStorage.Remotes.Combat:FireServer("Attack", npc)
        task.wait(math.random(CONFIG.ATTACK_DELAY.Min, CONFIG.ATTACK_DELAY.Max))
        simulateHumanInput()
    end
end

local function collectFruits()
    for _, fruit in pairs(Workspace:GetChildren()) do
        if fruit:IsA("Tool") and table.find(CONFIG.TARGET_FRUITS, fruit.Name) then
            safeTeleport(fruit.Handle.Position)
            firetouchinterest(HumanoidRootPart, fruit.Handle, 0)
            firetouchinterest(HumanoidRootPart, fruit.Handle, 1)
            if CONFIG.WEBHOOK_URL ~= "" then
                sendWebhook("Fruit Found: " .. fruit.Name)
            end
        end
    end
end

local function optimizePerformance()
    if CONFIG.LOW_TEXTURES then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then
                obj.Texture = ""
            end
        end
    end
    if CONFIG.FPS_CAP > 0 then
        RunService:Set3dRenderingEnabled(true)
        setfpscap(CONFIG.FPS_CAP)
    end
    if CONFIG.WHITE_SCREEN then
        local screen = Instance.new("Frame")
        screen.Size = UDim2.new(1, 0, 1, 0)
        screen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        screen.BackgroundTransparency = 0.5
        screen.Parent = game.CoreGui
    end
end

local function sendWebhook(message)
    if CONFIG.WEBHOOK_URL == "" then return end
    local data = {
        content = message,
        username = "DreamHub"
    }
    local success, err = pcall(function()
        HttpService:PostAsync(CONFIG.WEBHOOK_URL, HttpService:JSONEncode(data))
    end)
    if not success then
        warn("Webhook Error: " .. err)
    end
end

local function sendNotification(message)
    StarterGui:SetCore("SendNotification", {
        Title = "Dream Hub",
        Text = message,
        Duration = 5
    })
end

local function antiAFK()
    RunService.Heartbeat:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(math.random(0, 100), math.random(0, 100)))
    end)
end

local function createESP()
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP"
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = npc

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.Text = npc.Name
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.Parent = billboard
        end
    end
end

local function cleanUp()
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("ESP") then
            npc.ESP:Destroy()
        end
    end
end

-- Automation Functions
local function autoFarm()
    local sea = LocalPlayer.Data.Level.Value < 700 and "FirstSea" or (LocalPlayer.Data.Level.Value < 1500 and "SecondSea" or "ThirdSea")
    local islandData = SEA_DATA[sea].Islands
    local closestIsland = nil
    local minDist = math.huge

    for island, data in pairs(islandData) do
        local dist = (data.Pos - HumanoidRootPart.Position).Magnitude
        if dist < minDist then
            minDist = dist
            closestIsland = island
        end
    end

    if closestIsland then
        local npcName = islandData[closestIsland].NPCs[1]
        local npc = findClosestNPC(npcName)
        if npc then
            attackNPC(npc)
        else
            safeTeleport(islandData[closestIsland].Pos)
        end
    end
end

local function autoBoss()
    local sea = LocalPlayer.Data.Level.Value < 700 and "FirstSea" or (LocalPlayer.Data.Level.Value < 1500 and "SecondSea" or "ThirdSea")
    local bosses = SEA_DATA[sea].Bosses
    for _, boss in ipairs(bosses) do
        if boss.Level <= LocalPlayer.Data.Level.Value then
            local bossInstance = Workspace.NPCs:FindFirstChild(boss.Name)
            if bossInstance and bossInstance:FindFirstChild("Humanoid") and bossInstance.Humanoid.Health > 0 then
                attackNPC(bossInstance)
                return
            else
                safeTeleport(boss.Pos)
            end
        end
    end
end

local function autoRaid()
    ReplicatedStorage.Remotes.Raid:FireServer("StartRaid")
    task.wait(5)
    safeTeleport(Vector3.new(-6500, 15, 1500)) -- Cursed Ship
end

local function autoQuest()
    local sea = LocalPlayer.Data.Level.Value < 700 and "FirstSea" or (LocalPlayer.Data.Level.Value < 1500 and "SecondSea" or "ThirdSea")
    local islandData = SEA_DATA[sea].Islands
    for island, data in pairs(islandData) do
        local quest = data.Quests[1]
        if quest then
            ReplicatedStorage.Remotes.Quest:FireServer(quest)
            task.wait(1)
            autoFarm()
            break
        end
    end
end

local function autoHaki()
    ReplicatedStorage.Remotes.Haki:FireServer("Toggle")
    task.wait(math.random(0.8, 1.2))
end

local function autoStats()
    local stats = {"Melee", "Defense", "Sword", "Gun", "Fruit"}
    for _, stat in ipairs(stats) do
        ReplicatedStorage.Remotes.Stats:FireServer("AddPoint", stat, 1)
        task.wait(math.random(0.4, 0.6))
    end
end

local function autoGear()
    for _, item in pairs(CONFIG.PRIORITY_ITEMS.SWORDS) do
        ReplicatedStorage.Remotes.Equip:FireServer("Sword", item)
        task.wait(0.5)
    end
    for _, item in pairs(CONFIG.PRIORITY_ITEMS.GUNS) do
        ReplicatedStorage.Remotes.Equip:FireServer("Gun", item)
        task.wait(0.5)
    end
    for _, item in pairs(CONFIG.PRIORITY_ITEMS.ACCESSORIES) do
        ReplicatedStorage.Remotes.Equip:FireServer("Accessory", item)
        task.wait(0.5)
    end
end

local function autoSeaEvent()
    local events = {"Leviathan", "Prehistoric Island", "Kitsune Event", "Volcanic Island", "Terrorshark"}
    for _, event in ipairs(events) do
        local eventInstance = Workspace:FindFirstChild(event)
        if eventInstance then
            safeTeleport(eventInstance.Position)
            return
        end
    end
end

local function autoV2Race()
    ReplicatedStorage.Remotes.Race:FireServer("UpgradeV2")
    task.wait(1)
end

local function autoV3Race()
    ReplicatedStorage.Remotes.Race:FireServer("UpgradeV3")
    task.wait(1)
end

local function autoV4Race()
    ReplicatedStorage.Remotes.Race:FireServer("UpgradeV4")
    task.wait(1)
end

local function autoBartilo()
    ReplicatedStorage.Remotes.Quest:FireServer("Bartilo Quest")
    task.wait(1)
    autoFarm()
end

local function autoCombatStyle()
    local styles = {"Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon"}
    for _, style in ipairs(styles) do
        ReplicatedStorage.Remotes.CombatStyle:FireServer("Switch", style)
        task.wait(math.random(0.4, 0.6))
    end
end

local function autoServerHop()
    local success, err = pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
    if not success then
        warn("Server Hop Error: " .. err)
        task.wait(10)
    end
end

local function autoDodgeSkills()
    RunService.Heartbeat:Connect(function()
        if Humanoid.Health < Humanoid.MaxHealth * 0.5 then
            ReplicatedStorage.Remotes.Dodge:FireServer()
        end
    end)
end

local function aimbot()
    local closestPlayer = nil
    local minDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local dist = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                closestPlayer = player
                minDist = dist
            end
        end
    end
    if closestPlayer then
        local args = {closestPlayer.Character.HumanoidRootPart.CFrame}
        ReplicatedStorage.Remotes.Combat:FireServer("Aim", unpack(args))
    end
end

local function killAura()
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local dist = (npc.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist <= 20 then
                attackNPC(npc)
            end
        end
    end
end

local function autoParry()
    RunService.Heartbeat:Connect(function()
        for _, npc in pairs(Workspace.NPCs:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local dist = (npc.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                if dist <= 15 then
                    ReplicatedStorage.Remotes.Combat:FireServer("Parry")
                end
            end
        end
    end)
end

local function autoBuyHaki()
    ReplicatedStorage.Remotes.Shop:FireServer("BuyHaki", "Buso")
    task.wait(0.5)
    ReplicatedStorage.Remotes.Shop:FireServer("BuyHaki", "Ken")
    task.wait(0.5)
end

local function autoUpgradeWeapons()
    for _, item in pairs(CONFIG.PRIORITY_ITEMS.SWORDS) do
        ReplicatedStorage.Remotes.Upgrade:FireServer("Sword", item)
        task.wait(0.5)
    end
    for _, item in pairs(CONFIG.PRIORITY_ITEMS.GUNS) do
        ReplicatedStorage.Remotes.Upgrade:FireServer("Gun", item)
        task.wait(0.5)
    end
end

local function autoFindPrehistoric()
    if LocalPlayer.Backpack:FindFirstChild("Volcanic Magnet") then
        ReplicatedStorage.Remotes.Event:FireServer("SearchPrehistoric")
        task.wait(5)
        local prehistoric = Workspace:FindFirstChild("Prehistoric Island")
        if prehistoric then
            safeTeleport(prehistoric.Position)
        end
    end
end

local function autoLeviathan()
    local leviathan = Workspace:FindFirstChild("Leviathan")
    if leviathan then
        safeTeleport(leviathan.Position)
        attackNPC(leviathan)
    end
end

local function autoKitsune()
    local kitsune = Workspace:FindFirstChild("Kitsune Event")
    if kitsune then
        safeTeleport(kitsune.Position)
    end
end

local function autoTerrorshark()
    local terrorshark = Workspace:FindFirstChild("Terrorshark")
    if terrorshark then
        safeTeleport(terrorshark.Position)
        attackNPC(terrorshark)
    end
end

local function autoChest()
    for _, chest in pairs(Workspace:GetChildren()) do
        if chest.Name:find("Chest") then
            safeTeleport(chest.Position)
            task.wait(0.5)
        end
    end
end

local function autoMiragePuzzle()
    ReplicatedStorage.Remotes.Puzzle:FireServer("Mirage")
    task.wait(1)
end

local function autoDojoTrainer()
    ReplicatedStorage.Remotes.Quest:FireServer("Dojo Trainer Quest")
    task.wait(1)
    autoFarm()
end

local function autoVolcanicMagnet()
    ReplicatedStorage.Remotes.Shop:FireServer("BuyItem", "Volcanic Magnet")
    task.wait(1)
end

-- Main Loop
local function main()
    optimizePerformance()
    antiAFK()
    createUI()
    spoofAttributes()

    while true do
        local success, err = pcall(function()
            if Toggles.AutoFarm then autoFarm() end
            if Toggles.AutoBoss then autoBoss() end
            if Toggles.AutoRaid then autoRaid() end
            if Toggles.AutoQuest then autoQuest() end
            if Toggles.FruitSniper then collectFruits() end
            if Toggles.AutoHaki then autoHaki() end
            if Toggles.AutoStats then autoStats() end
            if Toggles.AutoGear then autoGear() end
            if Toggles.ESP then createESP() else cleanUp() end
            if Toggles.AutoSeaEvent then autoSeaEvent() end
            if Toggles.AutoV2Race then autoV2Race() end
            if Toggles.AutoV3Race then autoV3Race() end
            if Toggles.AutoV4Race then autoV4Race() end
            if Toggles.AutoBartilo then autoBartilo() end
            if Toggles.AutoCombatStyle then autoCombatStyle() end
            if Toggles.AutoServerHop then autoServerHop() end
            if Toggles.AutoDodgeSkills then autoDodgeSkills() end
            if Toggles.Aimbot then aimbot() end
            if Toggles.KillAura then killAura() end
            if Toggles.AutoParry then autoParry() end
            if Toggles.AutoBuyHaki then autoBuyHaki() end
            if Toggles.AutoUpgradeWeapons then autoUpgradeWeapons() end
            if Toggles.AutoFindPrehistoric then autoFindPrehistoric() end
            if Toggles.AutoLeviathan then autoLeviathan() end
            if Toggles.AutoKitsune then autoKitsune() end
            if Toggles.AutoTerrorshark then autoTerrorshark() end
            if Toggles.AutoChest then autoChest() end
            if Toggles.AutoMiragePuzzle then autoMiragePuzzle() end
            if Toggles.AutoDojoTrainer then autoDojoTrainer() end
            if Toggles.AutoVolcanicMagnet then autoVolcanicMagnet() end
        end)
        if not success then
            warn("Error: " .. err)
            sendWebhook("Error: " .. err)
            AntiBan.BanRiskLevel = AntiBan.BanRiskLevel + 0.05
            task.wait(1)
        end
        task.wait(0.1)
    end
end

-- Initialize
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    spoofAttributes()
    main()
end)

if CONFIG.AUTO_EXECUTE then
    local obfuscatedMain = obfuscateCode([[
        ]] .. string.dump(main, true) .. [[
    ]])
    loadstring(obfuscatedMain)()
end

-- Safety Warning
StarterGui:SetCore("SendNotification", {
    Title = "Dream Hub",
    Text = "Warning: Using scripts violates Roblox TOS and may result in a ban. Use responsibly.",
    Duration = 10
})

-- Enhanced Anti-Ban System
local function advancedObfuscate(code)
    if CONFIG.ANTI_BAN.OBFUSCATION_LEVEL == "High" then
        local keys = {HttpService:GenerateGUID(false), HttpService:GenerateGUID(false)}
        local obfuscated = code
        for _, key in ipairs(keys) do
            local temp = ""
            for i = 1, #obfuscated do
                temp = temp .. string.char(bit32.bxor(string.byte(obfuscated, i), string.byte(key, (i % #key) + 1)))
            end
            obfuscated = temp
        end
        return [[
            local keys = {"]] .. keys[1] .. [[", "]] .. keys[2] .. [["}
            local code = "]] .. obfuscated .. [["
            local deobfuscated = code
            for _, key in ipairs(keys) do
                local temp = ""
                for i = 1, #deobfuscated do
                    temp = temp .. string.char(bit32.bxor(string.byte(deobfuscated, i), string.byte(key, (i % #key) + 1)))
                end
                deobfuscated = temp
            end
            loadstring(deobfuscated)()
        ]]
    end
    return code
end

local function monitorServerPackets()
    local lastPacketCount = 0
    local packetSpikeThreshold = 50
    RunService.Heartbeat:Connect(function()
        local currentPacketCount = ReplicatedStorage.Remotes:GetNetworkPing() or 0
        if currentPacketCount - lastPacketCount > packetSpikeThreshold then
            AntiBan.BanRiskLevel = AntiBan.BanRiskLevel + 0.05
            sendNotification("Warning: Packet spike detected. Pausing risky actions.")
            task.wait(3)
        end
        lastPacketCount = currentPacketCount
    end)
end

local function spoofExecutorMetadata()
    local fakeExecutors = {"Synapse", "Krnl", "Fluxus", "Codex", "Delta"}
    AntiBan.DetectedExecutors = {fakeExecutors[math.random(1, #fakeExecutors)]}
end

local function throttleActions()
    local serverLoad = Workspace.ServerAge.Value / 3600 -- Server age in hours
    local playerCount = #Players:GetPlayers()
    local throttleFactor = math.clamp(serverLoad * playerCount / 100, 0.8, 1.5)
    CONFIG.ATTACK_DELAY.Min = CONFIG.ATTACK_DELAY.Min * throttleFactor
    CONFIG.ATTACK_DELAY.Max = CONFIG.ATTACK_DELAY.Max * throttleFactor
    CONFIG.ANTI_BAN.TELEPORT_COOLDOWN = CONFIG.ANTI_BAN.TELEPORT_COOLDOWN * throttleFactor
end

-- UI Enhancements
local function addThemeSelector(screenGui)
    local ThemeFrame = Instance.new("Frame")
    ThemeFrame.Size = UDim2.new(0, 150, 0, 120)
    ThemeFrame.Position = UDim2.new(0, 0, 1, -120)
    ThemeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ThemeFrame.Parent = screenGui.MainFrame

    local ThemeLabel = Instance.new("TextLabel")
    ThemeLabel.Size = UDim2.new(1, 0, 0, 30)
    ThemeLabel.BackgroundTransparency = 1
    ThemeLabel.Text = "Theme Selector"
    ThemeLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    ThemeLabel.TextSize = 16
    ThemeLabel.Font = Enum.Font.SourceSansBold
    ThemeLabel.Parent = ThemeFrame

    local Themes = {"Dark Neon", "Light", "Classic"}
    for i, theme in ipairs(Themes) do
        local ThemeButton = Instance.new("TextButton")
        ThemeButton.Size = UDim2.new(1, -10, 0, 30)
        ThemeButton.Position = UDim2.new(0, 5, 0, 30 + (i-1)*30)
        ThemeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ThemeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ThemeButton.Text = theme
        ThemeButton.TextSize = 14
        ThemeButton.Font = Enum.Font.SourceSans
        ThemeButton.Parent = ThemeFrame

        ThemeButton.MouseButton1Click:Connect(function()
            local colors = {
                ["Dark Neon"] = {Main = Color3.fromRGB(20, 20, 20), Accent = Color3.fromRGB(0, 255, 255)},
                ["Light"] = {Main = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(0, 120, 255)},
                ["Classic"] = {Main = Color3.fromRGB(50, 50, 50), Accent = Color3.fromRGB(255, 255, 0)}
            }
            screenGui.MainFrame.BackgroundColor3 = colors[theme].Main
            screenGui.MainFrame.TitleLabel.TextColor3 = colors[theme].Accent
            saveConfig()
        end)
    end
end

local function addNotificationLog(screenGui)
    local LogFrame = Instance.new("ScrollingFrame")
    LogFrame.Size = UDim2.new(0, 200, 0, 100)
    LogFrame.Position = UDim2.new(1, -200, 1, -100)
    LogFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    LogFrame.ScrollBarThickness = 5
    LogFrame.Parent = screenGui.MainFrame
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local LogLayout = Instance.new("UIListLayout")
    LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogLayout.Padding = UDim.new(0, 5)
    LogLayout.Parent = LogFrame

    local function addLog(message)
        local LogEntry = Instance.new("TextLabel")
        LogEntry.Size = UDim2.new(1, -10, 0, 20)
        LogEntry.BackgroundTransparency = 1
        LogEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
        LogEntry.Text = os.date("%H:%M:%S") .. ": " .. message
        LogEntry.TextSize = 12
        LogEntry.Font = Enum.Font.SourceSans
        LogEntry.Parent = LogFrame
        LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
    end

    return addLog
end

local function addKeybindEditor(screenGui)
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Size = UDim2.new(0, 150, 0, 80)
    KeybindFrame.Position = UDim2.new(0, 0, 1, -200)
    KeybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeybindFrame.Parent = screenGui.MainFrame

    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Size = UDim2.new(1, 0, 0, 30)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = "Set Toggle Key"
    KeybindLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    KeybindLabel.TextSize = 16
    KeybindLabel.Font = Enum.Font.SourceSansBold
    KeybindLabel.Parent = KeybindFrame

    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(1, -10, 0, 30)
    KeybindButton.Position = UDim2.new(0, 5, 0, 30)
    KeybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindButton.Text = tostring(CONFIG.TOGGLE_KEY):match("KeyCode%.(.+)")
    KeybindButton.TextSize = 14
    KeybindButton.Font = Enum.Font.SourceSans
    KeybindButton.Parent = KeybindFrame

    KeybindButton.MouseButton1Click:Connect(function()
        KeybindButton.Text = "Press a key..."
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                CONFIG.TOGGLE_KEY = input.KeyCode
                KeybindButton.Text = tostring(input.KeyCode):match("KeyCode%.(.+)")
                saveConfig()
                connection:Disconnect()
            end
        end)
    end)
end

-- New Automation Functions
local function autoFarmElitePirates()
    local eliteNPCs = {"Deandre", "Diablo", "Urban"}
    for _, npcName in ipairs(eliteNPCs) do
        local npc = findClosestNPC(npcName)
        if npc then
            attackNPC(npc)
            return
        end
    end
    safeTeleport(Vector3.new(-13250, 40, -8500)) -- Floating Turtle
end

local function autoCollectMirageChests()
    local mirageIsland = Workspace:FindFirstChild("Mirage Island")
    if mirageIsland then
        for _, chest in ipairs(mirageIsland:GetChildren()) do
            if chest.Name:find("Chest") then
                safeTeleport(chest.Position)
                task.wait(0.5)
            end
        end
    end
end

local function autoAwakenFruits()
    if Workspace:FindFirstChild("Raid") then
        ReplicatedStorage.Remotes.Raid:FireServer("AwakenFruit")
        task.wait(1)
    end
end

local function autoBountyHunt()
    local minBounty = 2500000
    local closestPlayer = nil
    local minDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local bounty = player.Data.Bounty and player.Data.Bounty.Value or 0
            if bounty >= minBounty then
                local dist = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    closestPlayer = player
                    minDist = dist
                end
            end
        end
    end
    if closestPlayer then
        aimbot()
        killAura()
        sendNotification("Targeting player with " .. closestPlayer.Data.Bounty.Value .. " bounty.")
    end
end

local function autoFarmMaterials()
    local materials = {
        {Name = "Ectoplasm", Location = Vector3.new(-6500, 15, 1500), NPC = "Dark Master"}, -- Cursed Ship
        {Name = "Bones", Location = Vector3.new(-9500, 40, 5500), NPC = "Bone Wraith"}, -- Haunted Castle
        {Name = "Candy", Location = Vector3.new(-1500, 40, -10500), NPC = "Candy Pirate"} -- Sea of Treats
    }
    for _, material in ipairs(materials) do
        local npc = findClosestNPC(material.NPC)
        if npc then
            attackNPC(npc)
            return
        else
            safeTeleport(material.Location)
        end
    end
end

local function autoTempleOfTime()
    ReplicatedStorage.Remotes.Puzzle:FireServer("TempleOfTime")
    task.wait(1)
    safeTeleport(Vector3.new(5225, 603, 350)) -- Hydra Island
end

local function autoFarmDragonScales()
    local dragonCrew = findClosestNPC("Dragon Crew Warrior")
    if dragonCrew then
        attackNPC(dragonCrew)
    else
        safeTeleport(Vector3.new(5225, 603, 350)) -- Hydra Island
    end
end

local function autoYamaQuest()
    ReplicatedStorage.Remotes.Quest:FireServer("Yama Quest")
    task.wait(1)
    autoFarm()
end

local function autoTushitaQuest()
    ReplicatedStorage.Remotes.Quest:FireServer("Tushita Quest")
    task.wait(1)
    safeTeleport(Vector3.new(-9500, 40, 5500)) -- Haunted Castle
end

-- Enhanced Main Loop
local function enhancedMain()
    local screenGui = createUI()
    addThemeSelector(screenGui)
    local addLog = addNotificationLog(screenGui)
    addKeybindEditor(screenGui)
    optimizePerformance()
    antiAFK()
    spoofAttributes()
    spoofExecutorMetadata()
    monitorServerPackets()

    -- Add new toggles for enhanced features
    Toggles.AutoElitePirates = false
    Toggles.AutoMirageChests = false
    Toggles.AutoAwakenFruits = false
    Toggles.AutoBountyHunt = false
    Toggles.AutoFarmMaterials = false
    Toggles.AutoTempleOfTime = false
    Toggles.AutoFarmDragonScales = false
    Toggles.AutoYamaQuest = false
    Toggles.AutoTushitaQuest = false

    local newFeatures = {
        {Name = "AutoElitePirates", Tab = "Farming"},
        {Name = "AutoMirageChests", Tab = "Farming"},
        {Name = "AutoAwakenFruits", Tab = "Items"},
        {Name = "AutoBountyHunt", Tab = "PvP"},
        {Name = "AutoFarmMaterials", Tab = "Farming"},
        {Name = "AutoTempleOfTime", Tab = "Teleport"},
        {Name = "AutoFarmDragonScales", Tab = "Farming"},
        {Name = "AutoYamaQuest", Tab = "Teleport"},
        {Name = "AutoTushitaQuest", Tab = "Teleport"}
    }

    for _, feature in ipairs(newFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.BackgroundColor3 = Toggles[feature.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = feature.Name:gsub("([A-Z])", " %1"):sub(2)
        button.TextSize = 14
        button.Font = Enum.Font.SourceSans
        button.Parent = screenGui.MainFrame.ContentFrame.ScrollingFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button

        button.MouseButton1Click:Connect(function()
            Toggles[feature.Name] = not Toggles[feature.Name]
            button.BackgroundColor3 = Toggles[feature.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            saveConfig()
        end)

        FeatureButtons[feature.Name] = {Button = button, Tab = feature.Tab}
    end

    -- Emergency shutdown and performance optimization
    RunService.Heartbeat:Connect(function()
        if AntiBan.BanRiskLevel > 0.8 then
            screenGui.Enabled = false
            for feature, _ in pairs(Toggles) do
                Toggles[feature] = false
            end
            sendNotification("Emergency shutdown: High ban risk detected.")
            addLog("Emergency shutdown triggered.")
            return
        end
        throttleActions()
    end)

    -- Periodic memory cleanup
    spawn(function()
        while true do
            pcall(function()
                for _, obj in ipairs(game.CoreGui:GetChildren()) do
                    if obj:IsA("Frame") or obj:IsA("BillboardGui") and obj.Name ~= "DreamHub" then
                        obj:Destroy()
                    end
                end
            end)
            task.wait(300) -- Clean memory every 5 minutes
        end
    end)

    -- Main automation loop
    while true do
        local success, err = pcall(function()
            if Toggles.AutoFarm then autoFarm() end
            if Toggles.AutoBoss then autoBoss() end
            if Toggles.AutoRaid then autoRaid() end
            if Toggles.AutoQuest then autoQuest() end
            if Toggles.FruitSniper then collectFruits() end
            if Toggles.AutoHaki then autoHaki() end
            if Toggles.AutoStats then autoStats() end
            if Toggles.AutoGear then autoGear() end
            if Toggles.ESP then createESP() else cleanUp() end
            if Toggles.AutoSeaEvent then autoSeaEvent() end
            if Toggles.AutoV2Race then autoV2Race() end
            if Toggles.AutoV3Race then autoV3Race() end
            if Toggles.AutoV4Race then autoV4Race() end
            if Toggles.AutoBartilo then autoBartilo() end
            if Toggles.AutoCombatStyle then autoCombatStyle() end
            if Toggles.AutoServerHop then autoServerHop() end
            if Toggles.AutoDodgeSkills then autoDodgeSkills() end
            if Toggles.Aimbot then aimbot() end
            if Toggles.KillAura then killAura() end
            if Toggles.AutoParry then autoParry() end
            if Toggles.AutoBuyHaki then autoBuyHaki() end
            if Toggles.AutoUpgradeWeapons then autoUpgradeWeapons() end
            if Toggles.AutoFindPrehistoric then autoFindPrehistoric() end
            if Toggles.AutoLeviathan then autoLeviathan() end
            if Toggles.AutoKitsune then autoKitsune() end
            if Toggles.AutoTerrorshark then autoTerrorshark() end
            if Toggles.AutoChest then autoChest() end
            if Toggles.AutoMiragePuzzle then autoMiragePuzzle() end
            if Toggles.AutoDojoTrainer then autoDojoTrainer() end
            if Toggles.AutoVolcanicMagnet then autoVolcanicMagnet() end
            if Toggles.AutoElitePirates then autoFarmElitePirates() end
            if Toggles.AutoMirageChests then autoCollectMirageChests() end
            if Toggles.AutoAwakenFruits then autoAwakenFruits() end
            if Toggles.AutoBountyHunt then autoBountyHunt() end
            if Toggles.AutoFarmMaterials then autoFarmMaterials() end
            if Toggles.AutoTempleOfTime then autoTempleOfTime() end
            if Toggles.AutoFarmDragonScales then autoFarmDragonScales() end
            if Toggles.AutoYamaQuest then autoYamaQuest() end
            if Toggles.AutoTushitaQuest then autoTushitaQuest() end
        end)
        if not success then
            addLog("Error: " .. err)
            sendWebhook("Error: " .. err)
            AntiBan.BanRiskLevel = AntiBan.BanRiskLevel + 0.05
            task.wait(1)
        end
        task.wait(0.1)
    end
end

-- Reinitialize with Enhanced Main Loop
if CONFIG.AUTO_EXECUTE then
    local obfuscatedEnhancedMain = advancedObfuscate([[
        ]] .. string.dump(enhancedMain, true) .. [[
    ]])
    loadstring(obfuscatedEnhancedMain)()
end

-- Final Notification
StarterGui:SetCore("SendNotification", {
    Title = "Dream Hub",
    Text = "Enhanced features loaded successfully. Use responsibly.",
    Duration = 5
})

-- Dynamic Configuration System
local function updateDynamicConfig()
    local serverHealth = math.clamp(Workspace.ServerAge.Value / 3600, 0.5, 2.0) -- Server age in hours
    local playerDensity = #Players:GetPlayers() / 50
    CONFIG.TELEPORT_SPEED = math.max(200, 300 / (serverHealth * playerDensity))
    CONFIG.ANTI_BAN.ACTION_RATE_LIMIT = math.floor(100 / (serverHealth * playerDensity))
    CONFIG.FARM_DISTANCE = math.clamp(15 * serverHealth, 10, 20)
    sendNotification("Dynamic config updated: Teleport Speed = " .. CONFIG.TELEPORT_SPEED .. ", Action Limit = " .. CONFIG.ANTI_BAN.ACTION_RATE_LIMIT)
end

-- Advanced Automation Features
local function autoFarmMythicalScrolls()
    local scrollLocations = {
        {Name = "Mythical Scroll", Location = Vector3.new(-9500, 40, 5500), NPC = "Bone Wraith"}, -- Haunted Castle
        {Name = "Legendary Scroll", Location = Vector3.new(-13250, 40, -8500), NPC = "Fishman Captain"} -- Floating Turtle
    }
    for _, scroll in ipairs(scrollLocations) do
        local npc = findClosestNPC(scroll.NPC)
        if npc then
            attackNPC(npc)
            return
        else
            safeTeleport(scroll.Location)
        end
    end
end

local function autoDragonUpdateEvents()
    local events = {"Dragon Shrine", "Celestial Tower", "Ancient Altar"}
    for _, event in ipairs(events) do
        local eventInstance = Workspace:FindFirstChild(event)
        if eventInstance then
            safeTeleport(eventInstance.Position)
            ReplicatedStorage.Remotes.Event:FireServer("Interact", event)
            sendWebhook("Interacted with " .. event)
            return
        end
    end
end

local function autoFarmConjuredMaterials()
    local materials = {
        {Name = "Conjured Flame", Location = Vector3.new(-16500, 40, 10500), NPC = "Tiki Outlaw"}, -- Tiki Outpost
        {Name = "Dragon Essence", Location = Vector3.new(5225, 603, 350), NPC = "Dragon Crew Warrior"} -- Hydra Island
    }
    for _, material in ipairs(materials) do
        local npc = findClosestNPC(material.NPC)
        if npc then
            attackNPC(npc)
            return
        else
            safeTeleport(material.Location)
        end
    end
end

local function autoCursedDualKatana()
    ReplicatedStorage.Remotes.Quest:FireServer("Cursed Dual Katana Quest")
    task.wait(1)
    local trials = {"Trial of Strength", "Trial of Speed", "Trial of Wisdom"}
    for _, trial in ipairs(trials) do
        local trialInstance = Workspace:FindFirstChild(trial)
        if trialInstance then
            safeTeleport(trialInstance.Position)
            ReplicatedStorage.Remotes.Puzzle:FireServer(trial)
            return
        end
    end
    safeTeleport(Vector3.new(-9500, 40, 5500)) -- Haunted Castle
end

local function autoSharkAnchorQuest()
    ReplicatedStorage.Remotes.Quest:FireServer("Shark Anchor Quest")
    task.wait(1)
    local leviathan = Workspace:FindFirstChild("Leviathan")
    if leviathan then
        safeTeleport(leviathan.Position)
        attackNPC(leviathan)
    else
        safeTeleport(Vector3.new(-13250, 40, -8500)) -- Floating Turtle
    end
end

-- Enhanced Anti-Cheat Evasion
local function randomizePacketTiming()
    local baseDelay = CONFIG.ATTACK_DELAY.Min
    CONFIG.ATTACK_DELAY.Min = baseDelay * math.random(0.9, 1.1)
    CONFIG.ATTACK_DELAY.Max = CONFIG.ATTACK_DELAY.Min + math.random(0.02, 0.05)
end

local function monitorServerHealth()
    RunService.Heartbeat:Connect(function()
        local serverAge = Workspace.ServerAge.Value / 3600
        if serverAge > 24 then
            sendNotification("Server age exceeds 24 hours. Initiating server hop.")
            Toggles.AutoServerHop = true
        end
    end)
end

local function simulatePlayerActivity()
    spawn(function()
        while true do
            if CONFIG.ANTI_BAN.HUMAN_INPUT_SIMULATION then
                VirtualUser:CaptureController()
                VirtualUser:SetKeyDown(Enum.KeyCode.W)
                task.wait(math.random(0.1, 0.3))
                VirtualUser:SetKeyUp(Enum.KeyCode.W)
                VirtualUser:MoveMouse(Vector2.new(math.random(-50, 50), math.random(-50, 50)))
            end
            task.wait(math.random(5, 15))
        end
    end)
end

-- UI Improvements
local function addStatPriorityEditor(screenGui)
    local StatFrame = Instance.new("Frame")
    StatFrame.Size = UDim2.new(0, 150, 0, 180)
    StatFrame.Position = UDim2.new(0, 0, 1, -380)
    StatFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    StatFrame.Parent = screenGui.MainFrame

    local StatLabel = Instance.new("TextLabel")
    StatLabel.Size = UDim2.new(1, 0, 0, 30)
    StatLabel.BackgroundTransparency = 1
    StatLabel.Text = "Stat Priority"
    StatLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    StatLabel.TextSize = 16
    StatLabel.Font = Enum.Font.SourceSansBold
    StatLabel.Parent = StatFrame

    local StatOrder = {"Melee", "Defense", "Sword", "Gun", "Fruit"}
    for i, stat in ipairs(StatOrder) do
        local StatButton = Instance.new("TextButton")
        StatButton.Size = UDim2.new(1, -10, 0, 30)
        StatButton.Position = UDim2.new(0, 5, 0, 30 + (i-1)*30)
        StatButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        StatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatButton.Text = stat .. " (Priority " .. i .. ")"
        StatButton.TextSize = 14
        StatButton.Font = Enum.Font.SourceSans
        StatButton.Parent = StatFrame

        StatButton.MouseButton1Click:Connect(function()
            local newIndex = (i % #StatOrder) + 1
            StatOrder[i], StatOrder[newIndex] = StatOrder[newIndex], StatOrder[i]
            for j, btn in ipairs(StatFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.Text = StatOrder[j] .. " (Priority " .. j .. ")"
                end
            end
            saveConfig()
        end)
    end

    -- Update autoStats to use priority
    local originalAutoStats = autoStats
    autoStats = function()
        for _, stat in ipairs(StatOrder) do
            ReplicatedStorage.Remotes.Stats:FireServer("AddPoint", stat, 1)
            task.wait(math.random(0.4, 0.6))
        end
    end
end

local function addAutoReconnectToggle(screenGui)
    local ReconnectFrame = Instance.new("Frame")
    ReconnectFrame.Size = UDim2.new(0, 150, 0, 60)
    ReconnectFrame.Position = UDim2.new(0, 0, 1, -440)
    ReconnectFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ReconnectFrame.Parent = screenGui.MainFrame

    local ReconnectButton = Instance.new("TextButton")
    ReconnectButton.Size = UDim2.new(1, -10, 0, 30)
    ReconnectButton.Position = UDim2.new(0, 5, 0, 15)
    ReconnectButton.BackgroundColor3 = Toggles.AutoReconnect and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ReconnectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ReconnectButton.Text = "Auto Reconnect"
    ReconnectButton.TextSize = 14
    ReconnectButton.Font = Enum.Font.SourceSans
    ReconnectButton.Parent = ReconnectFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = ReconnectButton

    ReconnectButton.MouseButton1Click:Connect(function()
        Toggles.AutoReconnect = not Toggles.AutoReconnect
        ReconnectButton.BackgroundColor3 = Toggles.AutoReconnect and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        saveConfig()
    end)
end

-- Error Recovery and Game Update Handling
local function handleGameUpdates()
    local lastVersion = game.PlaceVersion
    spawn(function()
        while true do
            if game.PlaceVersion > lastVersion then
                sendNotification("Game update detected. Reloading script...")
                for feature, _ in pairs(Toggles) do
                    Toggles[feature] = false
                end
                task.wait(2)
                loadstring(HttpService:GetAsync(CONFIG.ANTI_BAN.DYNAMIC_URL))()
                break
            end
            task.wait(60)
        end
    end)
end

local function autoReconnect()
    if Toggles.AutoReconnect then
        Players.PlayerRemoving:Connect(function(player)
            if player == LocalPlayer then
                sendWebhook("Disconnected from server. Attempting to reconnect...")
                task.wait(5)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end
end

-- Enhanced Initialization
local function initializeEnhancedFeatures()
    Toggles.AutoMythicalScrolls = false
    Toggles.AutoDragonUpdateEvents = false
    Toggles.AutoConjuredMaterials = false
    Toggles.AutoCursedDualKatana = false
    Toggles.AutoSharkAnchorQuest = false
    Toggles.AutoReconnect = false

    local newFeatures = {
        {Name = "AutoMythicalScrolls", Tab = "Farming"},
        {Name = "AutoDragonUpdateEvents", Tab = "Farming"},
        {Name = "AutoConjuredMaterials", Tab = "Farming"},
        {Name = "AutoCursedDualKatana", Tab = "Teleport"},
        {Name = "AutoSharkAnchorQuest", Tab = "Farming"},
        {Name = "AutoReconnect", Tab = "Settings"}
    }

    local screenGui = game.CoreGui:FindFirstChild("DreamHub") or createUI()
    addStatPriorityEditor(screenGui)
    addAutoReconnectToggle(screenGui)

    for _, feature in ipairs(newFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.BackgroundColor3 = Toggles[feature.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = feature.Name:gsub("([A-Z])", " %1"):sub(2)
        button.TextSize = 14
        button.Font = Enum.Font.SourceSans
        button.Parent = screenGui.MainFrame.ContentFrame.ScrollingFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button

        button.MouseButton1Click:Connect(function()
            Toggles[feature.Name] = not Toggles[feature.Name]
            button.BackgroundColor3 = Toggles[feature.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            saveConfig()
        end)

        FeatureButtons[feature.Name] = {Button = button, Tab = feature.Tab}
    end

    updateDynamicConfig()
    randomizePacketTiming()
    monitorServerHealth()
    simulatePlayerActivity()
    handleGameUpdates()
    autoReconnect()
end

-- Update Main Loop to Include New Features
local function updateMainLoop()
    local originalMain = main
    main = function()
        initializeEnhancedFeatures()
        originalMain()

        while true do
            local success, err = pcall(function()
                if Toggles.AutoFarm then autoFarm() end
                if Toggles.AutoBoss then autoBoss() end
                if Toggles.AutoRaid then autoRaid() end
                if Toggles.AutoQuest then autoQuest() end
                if Toggles.FruitSniper then collectFruits() end
                if Toggles.AutoHaki then autoHaki() end
                if Toggles.AutoStats then autoStats() end
                if Toggles.AutoGear then autoGear() end
                if Toggles.ESP then createESP() else cleanUp() end
                if Toggles.AutoSeaEvent then autoSeaEvent() end
                if Toggles.AutoV2Race then autoV2Race() end
                if Toggles.AutoV3Race then autoV3Race() end
                if Toggles.AutoV4Race then autoV4Race() end
                if Toggles.AutoBartilo then autoBartilo() end
                if Toggles.AutoCombatStyle then autoCombatStyle() end
                if Toggles.AutoServerHop then autoServerHop() end
                if Toggles.AutoDodgeSkills then autoDodgeSkills() end
                if Toggles.Aimbot then aimbot() end
                if Toggles.KillAura then killAura() end
                if Toggles.AutoParry then autoParry() end
                if Toggles.AutoBuyHaki then autoBuyHaki() end
                if Toggles.AutoUpgradeWeapons then autoUpgradeWeapons() end
                if Toggles.AutoFindPrehistoric then autoFindPrehistoric() end
                if Toggles.AutoLeviathan then autoLeviathan() end
                if Toggles.AutoKitsune then autoKitsune() end
                if Toggles.AutoTerrorshark then autoTerrorshark() end
                if Toggles.AutoChest then autoChest() end
                if Toggles.AutoMiragePuzzle then autoMiragePuzzle() end
                if Toggles.AutoDojoTrainer then autoDojoTrainer() end
                if Toggles.AutoVolcanicMagnet then autoVolcanicMagnet() end
                if Toggles.AutoElitePirates then autoFarmElitePirates() end
                if Toggles.AutoMirageChests then autoCollectMirageChests() end
                if Toggles.AutoAwakenFruits then autoAwakenFruits() end
                if Toggles.AutoBountyHunt then autoBountyHunt() end
                if Toggles.AutoFarmMaterials then autoFarmMaterials() end
                if Toggles.AutoTempleOfTime then autoTempleOfTime() end
                if Toggles.AutoFarmDragonScales then autoFarmDragonScales() end
                if Toggles.AutoYamaQuest then autoYamaQuest() end
                if Toggles.AutoTushitaQuest then autoTushitaQuest() end
                if Toggles.AutoMythicalScrolls then autoFarmMythicalScrolls() end
                if Toggles.AutoDragonUpdateEvents then autoDragonUpdateEvents() end
                if Toggles.AutoConjuredMaterials then autoFarmConjuredMaterials() end
                if Toggles.AutoCursedDualKatana then autoCursedDualKatana() end
                if Toggles.AutoSharkAnchorQuest then autoSharkAnchorQuest() end
            end)
            if not success then
                sendNotification("Error: " .. err)
                sendWebhook("Error: " .. err)
                AntiBan.BanRiskLevel = AntiBan.BanRiskLevel + 0.05
                task.wait(1)
            end
            task.wait(0.1)
        end
    end
end

-- Execute Enhanced Main Loop
updateMainLoop()
if CONFIG.AUTO_EXECUTE then
    local obfuscatedMain = advancedObfuscate([[
        ]] .. string.dump(main, true) .. [[
    ]])
    loadstring(obfuscatedMain)()
end

-- Completion Notification
StarterGui:SetCore("SendNotification", {
    Title = "Dream Hub",
    Text = "All enhanced features and automation loaded. Ready for action!",
    Duration = 5
})
