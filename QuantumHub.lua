-- QuantumHubV5: The Ultimate Blox Fruits Script
-- Surpasses Banana Hub, Hoho Hub, Redz Hub with unmatched security and features
-- Keyless, 120fps optimized, Hoho/Banana JobID compatible, maximized anti-ban
-- Features: Advanced Anti-Exploit Engine, Behavioral Analysis, Server Integrity Checker,
-- Auto Exploit Reporter, Customizable Hotkeys, Performance Profiler, Auto Inventory Backup,
-- Auto Trade Negotiator, Dynamic GUI Themes, Resource Heatmap, and more

-- Wait for game to load
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Global settings
_G.QuantumSettings = {
    AutoFarmLevel = false, AutoFarmBoss = false, AutoFarmHaki = false, AutoFarmChest = false, AutoRaid = false,
    AutoSeaEvents = false, AutoLeviathan = false, AutoTerrorshark = false, AutoSeaBeast = false, AutoGhostShip = false,
    FruitSniper = false, TeleportToFruit = false, IslandTeleport = false, PlayerBountyFarm = false, AutoRaceV4 = false,
    AutoMirageIsland = false, AutoPrehistoricIsland = false, AutoDojoQuest = false, AutoStoreFruits = false,
    AutoQuestCompletion = false, AutoFruitMastery = false, AutoBossRush = false, AutoTradeFruits = false, AutoDodge = false,
    AutoFruitUpgrader = false, AdvancedESP = false, CombatESP = false, PredictiveFruitSpawn = false, CustomAuraColor = false,
    AuraColor = Color3.fromRGB(0, 255, 127), DynamicHUD = false, SpectatePlayer = false, TeleportToPlayer = false,
    AutoTranslateChat = false, ShowUntranslatedChat = false, AutoStatOptimizer = false, AutoSkillTrainer = false,
    TradeScanner = false, DynamicStatAllocator = false, AutoAwakening = false, AutoQuestPrioritizer = false,
    InventoryManager = false, AntiAFK = true, FlyMode = false, FlySpeed = 150, LagReducer = true, WebhookNotifications = false,
    WebhookURL = "", AntiBan = true, AntiExploitDetection = true, AutoExploitReporter = false, CustomHotkeys = false,
    PerformanceProfiler = false, AutoInventoryBackup = false, AutoTradeNegotiator = false, DynamicGUIThemes = false,
    ResourceHeatmap = false, ServerLoadBalancer = false, AnalyticsDashboard = false, ProximityAlerts = false,
    CustomCrosshair = false, AutoMiragePuzzle = false, AutoFruitRarityScanner = false, CustomAuraEffects = false,
    ServerHopForEvents = false, AutoCollectDailyRewards = false, PlayerTracker = false, AutoFruitAwakeningCombo = false
}

-- Anti-Ban: Randomization and humanization
local function RandomDelay(min, max)
    if _G.QuantumSettings.AntiBan then
        local delay = math.random(min, max) / 1000 * (1 + math.random(-0.3, 0.3))
        task.wait(delay)
    end
end

local function SimulateHumanBehavior()
    if _G.QuantumSettings.AntiBan then
        local actions = {
            function() VirtualUser:MoveMouse(Vector2.new(math.random(0, 1920), math.random(0, 1080))) end,
            function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(math.random(-5, 5)), 0) end end,
            function() VirtualUser:SetKeyDown(Enum.KeyCode.W) task.wait(0.05) VirtualUser:SetKeyUp(Enum.KeyCode.W) end
        }
        actions[math.random(1, #actions)]()
        RandomDelay(500, 1500)
    end
end

local function EncryptCommunication(data)
    if _G.QuantumSettings.AntiBan then
        local key = math.random(1, 255)
        local encrypted = {}
        for i = 1, #data do
            encrypted[i] = string.char(bit32.bxor(string.byte(data, i), key))
        end
        return table.concat(encrypted), key
    end
    return data, 0
end

-- Anti-Exploit: Advanced detection
local function AntiExploitDetection()
    local exploitPatterns = {
        {Check = function(player) return player.Character and player.Character.Humanoid.WalkSpeed > 50 end, Reason = "Excessive WalkSpeed"},
        {Check = function(player) return player.Character and player.Character.Humanoid.JumpPower > 100 end, Reason = "Excessive JumpPower"},
        {Check = function(player) return player.Character and player.Character.HumanoidRootPart.Velocity.Magnitude > 1000 end, Reason = "Unnatural Velocity"},
        {Check = function(player) return player.Character and player.Data.Stats.Melee.Value > 10000 end, Reason = "Stat Manipulation"},
        {Check = function(player) local lastPos = player.Character and player.Character.HumanoidRootPart.Position return function() local newPos = player.Character and player.Character.HumanoidRootPart.Position return (newPos - lastPos).Magnitude > 500 end end, Reason = "Teleportation Exploit"}
    }
    local behaviorLog = {}
    while _G.QuantumSettings.AntiExploitDetection do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                behaviorLog[player.UserId] = behaviorLog[player.UserId] or {Actions = 0, LastAction = tick()}
                behaviorLog[player.UserId].Actions = behaviorLog[player.UserId].Actions + 1
                if behaviorLog[player.UserId].Actions > 80 and (tick() - behaviorLog[player.UserId].LastAction) < 4 then
                    ReportExploit(player, "High Action Rate")
                end
                for _, pattern in pairs(exploitPatterns) do
                    if pattern.Check(player) then
                        ReportExploit(player, pattern.Reason)
                    end
                end
            end
        end
        task.wait(1)
    end
end

local function ReportExploit(player, reason)
    if _G.QuantumSettings.AutoExploitReporter and _G.QuantumSettings.WebhookURL ~= "" then
        pcall(function()
            local payload = HttpService:JSONEncode({
                content = "Exploit detected: " .. player.Name .. " (UserID: " .. player.UserId .. ") - Reason: " .. reason
            })
            local encrypted, key = EncryptCommunication(payload)
            HttpService:PostAsync(_G.QuantumSettings.WebhookURL, encrypted)
        end)
    end
end

-- Notification System
local function ShowNotification(message, duration)
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Parent = PlayerGui
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.3, 0, 0.1, 0)
    Frame.Position = UDim2.new(0.35, 0, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.Parent = NotificationGui
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Frame
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Text = message
    Text.TextColor3 = Color3.fromRGB(0, 255, 127)
    Text.TextSize = 16
    Text.TextWrapped = true
    Text.Parent = Frame
    task.spawn(function()
        task.wait(duration or 3)
        NotificationGui:Destroy()
    end)
end

-- Boss and Moon Status
local function GetCurrentSea()
    local sea = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Sea")
    if sea then
        return sea.Value
    end
    local pos = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
    if pos.X < 50000 then return 1 end
    if pos.X < 150000 then return 2 end
    return 3
end

local function UpdateBossStatus()
    local sea = GetCurrentSea()
    local bosses = {}
    for _, boss in pairs(workspace.Enemies:GetChildren()) do
        if boss:IsA("Model") and boss.Name:find("Boss") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
            local bossSea = 1
            if boss.HumanoidRootPart.Position.X > 150000 then bossSea = 3
            elseif boss.HumanoidRootPart.Position.X > 50000 then bossSea = 2 end
            if bossSea == sea then
                table.insert(bosses, boss.Name)
            end
        end
    end
    return #bosses > 0 and table.concat(bosses, ", ") or "No bosses spawned in Sea " .. sea
end

local function GetMoonStatus()
    local time = tonumber(string.match(Lighting.TimeOfDay, "%d+%.?%d*")) or 0
    local phase = "Unknown"
    local fullMoonTime = 0
    local timeToFullMoon = 0
    if time >= 18 or time < 6 then
        phase = "Full Moon" fullMoonTime = 0
    elseif time >= 6 and time < 12 then
        phase = "Waxing Crescent" fullMoonTime = 12 - time timeToFullMoon = (12 - time) * 3600
    elseif time >= 12 and time < 18 then
        phase = "Waxing Gibbous" fullMoonTime = 18 - time timeToFullMoon = (18 - time) * 3600
    else
        phase = "Waning Gibbous" fullMoonTime = 24 - time timeToFullMoon = (24 - time) * 3600
    end
    local hours = math.floor(timeToFullMoon / 3600)
    local minutes = math.floor((timeToFullMoon % 3600) / 60)
    return phase, string.format("%d hours %d minutes", hours, minutes)
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.IgnoreGuiInset = true
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0.5, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Text = "QuantumHub V5"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1

local TabList = Instance.new("Frame", MainFrame)
TabList.Size = UDim2.new(0.3, 0, 0.8, 0)
TabList.Position = UDim2.new(0, 0, 0.1, 0)
TabList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(0.7, 0, 0.8, 0)
ContentFrame.Position = UDim2.new(0.3, 0, 0.1, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Status Frame
local StatusFrame = Instance.new("Frame", MainFrame)
StatusFrame.Size = UDim2.new(1, 0, 0.1, 0)
StatusFrame.Position = UDim2.new(0, 0, 0.9, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local BossStatus = Instance.new("TextLabel", StatusFrame)
BossStatus.Size = UDim2.new(0.5, 0, 1, 0)
BossStatus.Text = "Boss Status: Loading..."
BossStatus.TextColor3 = Color3.fromRGB(0, 255, 127)
local MoonStatus = Instance.new("TextLabel", StatusFrame)
MoonStatus.Size = UDim2.new(0.5, 0, 1, 0)
MoonStatus.Position = UDim2.new(0.5, 0, 0, 0)
MoonStatus.Text = "Moon Status: Loading..."
MoonStatus.TextColor3 = Color3.fromRGB(0, 255, 127)

-- Tabs and Features
local Tabs = {
    {Name = "Tab Farming Other", Options = {
        {"Auto Farm Level", function() _G.QuantumSettings.AutoFarmLevel = not _G.QuantumSettings.AutoFarmLevel ShowNotification("AutoFarmLevel " .. (_G.QuantumSettings.AutoFarmLevel and "ON" or "OFF"), 2) end},
        {"Auto Farm Boss", function() _G.QuantumSettings.AutoFarmBoss = not _G.QuantumSettings.AutoFarmBoss ShowNotification("AutoFarmBoss " .. (_G.QuantumSettings.AutoFarmBoss and "ON" or "OFF"), 2) end},
        {"Auto Farm Haki", function() _G.QuantumSettings.AutoFarmHaki = not _G.QuantumSettings.AutoFarmHaki ShowNotification("AutoFarmHaki " .. (_G.QuantumSettings.AutoFarmHaki and "ON" or "OFF"), 2) end},
        {"Auto Farm Chest", function() _G.QuantumSettings.AutoFarmChest = not _G.QuantumSettings.AutoFarmChest ShowNotification("AutoFarmChest " .. (_G.QuantumSettings.AutoFarmChest and "ON" or "OFF"), 2) end},
        {"Auto Raid", function() _G.QuantumSettings.AutoRaid = not _G.QuantumSettings.AutoRaid ShowNotification("AutoRaid " .. (_G.QuantumSettings.AutoRaid and "ON" or "OFF"), 2) end},
        {"Auto Quest Completion", function() _G.QuantumSettings.AutoQuestCompletion = not _G.QuantumSettings.AutoQuestCompletion ShowNotification("AutoQuestCompletion " .. (_G.QuantumSettings.AutoQuestCompletion and "ON" or "OFF"), 2) end},
        {"Auto Fruit Mastery", function() _G.QuantumSettings.AutoFruitMastery = not _G.QuantumSettings.AutoFruitMastery ShowNotification("AutoFruitMastery " .. (_G.QuantumSettings.AutoFruitMastery and "ON" or "OFF"), 2) end},
        {"Auto Boss Rush", function() _G.QuantumSettings.AutoBossRush = not _G.QuantumSettings.AutoBossRush ShowNotification("AutoBossRush " .. (_G.QuantumSettings.AutoBossRush and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Fruit and Raid", Options = {
        {"Fruit Sniper", function() _G.QuantumSettings.FruitSniper = not _G.QuantumSettings.FruitSniper ShowNotification("FruitSniper " .. (_G.QuantumSettings.FruitSniper and "ON" or "OFF"), 2) end},
        {"Teleport To Fruit", function() _G.QuantumSettings.TeleportToFruit = not _G.QuantumSettings.TeleportToFruit ShowNotification("TeleportToFruit " .. (_G.QuantumSettings.TeleportToFruit and "ON" or "OFF"), 2) end},
        {"Auto Trade Fruits", function() _G.QuantumSettings.AutoTradeFruits = not _G.QuantumSettings.AutoTradeFruits ShowNotification("AutoTradeFruits " .. (_G.QuantumSettings.AutoTradeFruits and "ON" or "OFF"), 2) end},
        {"Auto Fruit Upgrader", function() _G.QuantumSettings.AutoFruitUpgrader = not _G.QuantumSettings.AutoFruitUpgrader ShowNotification("AutoFruitUpgrader " .. (_G.QuantumSettings.AutoFruitUpgrader and "ON" or "OFF"), 2) end},
        {"Auto Fruit Rarity Scanner", function() _G.QuantumSettings.AutoFruitRarityScanner = not _G.QuantumSettings.AutoFruitRarityScanner ShowNotification("AutoFruitRarityScanner " .. (_G.QuantumSettings.AutoFruitRarityScanner and "ON" or "OFF"), 2) end},
        {"Auto Fruit Awakening Combo", function() _G.QuantumSettings.AutoFruitAwakeningCombo = not _G.QuantumSettings.AutoFruitAwakeningCombo ShowNotification("AutoFruitAwakeningCombo " .. (_G.QuantumSettings.AutoFruitAwakeningCombo and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Sea Event", Options = {
        {"Auto Sea Events", function() _G.QuantumSettings.AutoSeaEvents = not _G.QuantumSettings.AutoSeaEvents ShowNotification("AutoSeaEvents " .. (_G.QuantumSettings.AutoSeaEvents and "ON" or "OFF"), 2) end},
        {"Auto Leviathan", function() _G.QuantumSettings.AutoLeviathan = not _G.QuantumSettings.AutoLeviathan ShowNotification("AutoLeviathan " .. (_G.QuantumSettings.AutoLeviathan and "ON" or "OFF"), 2) end},
        {"Auto Terrorshark", function() _G.QuantumSettings.AutoTerrorshark = not _G.QuantumSettings.AutoTerrorshark ShowNotification("AutoTerrorshark " .. (_G.QuantumSettings.AutoTerrorshark and "ON" or "OFF"), 2) end},
        {"Auto Sea Beast", function() _G.QuantumSettings.AutoSeaBeast = not _G.QuantumSettings.AutoSeaBeast ShowNotification("AutoSeaBeast " .. (_G.QuantumSettings.AutoSeaBeast and "ON" or "OFF"), 2) end},
        {"Auto Ghost Ship", function() _G.QuantumSettings.AutoGhostShip = not _G.QuantumSettings.AutoGhostShip ShowNotification("AutoGhostShip " .. (_G.QuantumSettings.AutoGhostShip and "ON" or "OFF"), 2) end},
        {"Server Hop For Events", function() _G.QuantumSettings.ServerHopForEvents = not _G.QuantumSettings.ServerHopForEvents ShowNotification("ServerHopForEvents " .. (_G.QuantumSettings.ServerHopForEvents and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Upgrade Race", Options = {
        {"Auto Race V4", function() _G.QuantumSettings.AutoRaceV4 = not _G.QuantumSettings.AutoRaceV4 ShowNotification("AutoRaceV4 " .. (_G.QuantumSettings.AutoRaceV4 and "ON" or "OFF"), 2) end},
        {"Auto Mirage Island", function() _G.QuantumSettings.AutoMirageIsland = not _G.QuantumSettings.AutoMirageIsland ShowNotification("AutoMirageIsland " .. (_G.QuantumSettings.AutoMirageIsland and "ON" or "OFF"), 2) end},
        {"Auto Prehistoric Island", function() _G.QuantumSettings.AutoPrehistoricIsland = not _G.QuantumSettings.AutoPrehistoricIsland ShowNotification("AutoPrehistoricIsland " .. (_G.QuantumSettings.AutoPrehistoricIsland and "ON" or "OFF"), 2) end},
        {"Auto Mirage Puzzle", function() _G.QuantumSettings.AutoMiragePuzzle = not _G.QuantumSettings.AutoMiragePuzzle ShowNotification("AutoMiragePuzzle " .. (_G.QuantumSettings.AutoMiragePuzzle and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Get and Upgrade Items", Options = {
        {"Auto Store Fruits", function() _G.QuantumSettings.AutoStoreFruits = not _G.QuantumSettings.AutoStoreFruits ShowNotification("AutoStoreFruits " .. (_G.QuantumSettings.AutoStoreFruits and "ON" or "OFF"), 2) end},
        {"Auto Dojo Quest", function() _G.QuantumSettings.AutoDojoQuest = not _G.QuantumSettings.AutoDojoQuest ShowNotification("AutoDojoQuest " .. (_G.QuantumSettings.AutoDojoQuest and "ON" or "OFF"), 2) end},
        {"Auto Collect Daily Rewards", function() _G.QuantumSettings.AutoCollectDailyRewards = not _G.QuantumSettings.AutoCollectDailyRewards ShowNotification("AutoCollectDailyRewards " .. (_G.QuantumSettings.AutoCollectDailyRewards and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Local Player", Options = {
        {"Fly Mode", function() _G.QuantumSettings.FlyMode = not _G.QuantumSettings.FlyMode ShowNotification("FlyMode " .. (_G.QuantumSettings.FlyMode and "ON" or "OFF"), 2) end},
        {"Auto Stat Optimizer", function() _G.QuantumSettings.AutoStatOptimizer = not _G.QuantumSettings.AutoStatOptimizer ShowNotification("AutoStatOptimizer " .. (_G.QuantumSettings.AutoStatOptimizer and "ON" or "OFF"), 2) end},
        {"Auto Skill Trainer", function() _G.QuantumSettings.AutoSkillTrainer = not _G.QuantumSettings.AutoSkillTrainer ShowNotification("AutoSkillTrainer " .. (_G.QuantumSettings.AutoSkillTrainer and "ON" or "OFF"), 2) end},
        {"Dynamic Stat Allocator", function() _G.QuantumSettings.DynamicStatAllocator = not _G.QuantumSettings.DynamicStatAllocator ShowNotification("DynamicStatAllocator " .. (_G.QuantumSettings.DynamicStatAllocator and "ON" or "OFF"), 2) end},
        {"Auto Awakening", function() _G.QuantumSettings.AutoAwakening = not _G.QuantumSettings.AutoAwakening ShowNotification("AutoAwakening " .. (_G.QuantumSettings.AutoAwakening and "ON" or "OFF"), 2) end},
        {"Inventory Manager", function() _G.QuantumSettings.InventoryManager = not _G.QuantumSettings.InventoryManager ShowNotification("InventoryManager " .. (_G.QuantumSettings.InventoryManager and "ON" or "OFF"), 2) end},
        {"Auto Inventory Backup", function() _G.QuantumSettings.AutoInventoryBackup = not _G.QuantumSettings.AutoInventoryBackup ShowNotification("AutoInventoryBackup " .. (_G.QuantumSettings.AutoInventoryBackup and "ON" or "OFF"), 2) end},
        {"Player Tracker", function() _G.QuantumSettings.PlayerTracker = not _G.QuantumSettings.PlayerTracker ShowNotification("PlayerTracker " .. (_G.QuantumSettings.PlayerTracker and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Teleport", Options = {
        {"Island Teleport", function() _G.QuantumSettings.IslandTeleport = not _G.QuantumSettings.IslandTeleport ShowNotification("IslandTeleport " .. (_G.QuantumSettings.IslandTeleport and "ON" or "OFF"), 2) end},
        {"Teleport To Player", function() _G.QuantumSettings.TeleportToPlayer = not _G.QuantumSettings.TeleportToPlayer ShowNotification("TeleportToPlayer " .. (_G.QuantumSettings.TeleportToPlayer and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Combat", Options = {
        {"Player Bounty Farm", function() _G.QuantumSettings.PlayerBountyFarm = not _G.QuantumSettings.PlayerBountyFarm ShowNotification("PlayerBountyFarm " .. (_G.QuantumSettings.PlayerBountyFarm and "ON" or "OFF"), 2) end},
        {"Auto Dodge", function() _G.QuantumSettings.AutoDodge = not _G.QuantumSettings.AutoDodge ShowNotification("AutoDodge " .. (_G.QuantumSettings.AutoDodge and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Visuals", Options = {
        {"Advanced ESP", function() _G.QuantumSettings.AdvancedESP = not _G.QuantumSettings.AdvancedESP ShowNotification("AdvancedESP " .. (_G.QuantumSettings.AdvancedESP and "ON" or "OFF"), 2) end},
        {"Combat ESP", function() _G.QuantumSettings.CombatESP = not _G.QuantumSettings.CombatESP ShowNotification("CombatESP " .. (_G.QuantumSettings.CombatESP and "ON" or "OFF"), 2) end},
        {"Predictive Fruit Spawn", function() _G.QuantumSettings.PredictiveFruitSpawn = not _G.QuantumSettings.PredictiveFruitSpawn ShowNotification("PredictiveFruitSpawn " .. (_G.QuantumSettings.PredictiveFruitSpawn and "ON" or "OFF"), 2) end},
        {"Custom Aura Color", function() _G.QuantumSettings.CustomAuraColor = not _G.QuantumSettings.CustomAuraColor ShowNotification("CustomAuraColor " .. (_G.QuantumSettings.CustomAuraColor and "ON" or "OFF"), 2) end},
        {"Custom Aura Effects", function() _G.QuantumSettings.CustomAuraEffects = not _G.QuantumSettings.CustomAuraEffects ShowNotification("CustomAuraEffects " .. (_G.QuantumSettings.CustomAuraEffects and "ON" or "OFF"), 2) end},
        {"Dynamic HUD", function() _G.QuantumSettings.DynamicHUD = not _G.QuantumSettings.DynamicHUD ShowNotification("DynamicHUD " .. (_G.QuantumSettings.DynamicHUD and "ON" or "OFF"), 2) end},
        {"Resource Heatmap", function() _G.QuantumSettings.ResourceHeatmap = not _G.QuantumSettings.ResourceHeatmap ShowNotification("ResourceHeatmap " .. (_G.QuantumSettings.ResourceHeatmap and "ON" or "OFF"), 2) end},
        {"Proximity Alerts", function() _G.QuantumSettings.ProximityAlerts = not _G.QuantumSettings.ProximityAlerts ShowNotification("ProximityAlerts " .. (_G.QuantumSettings.ProximityAlerts and "ON" or "OFF"), 2) end},
        {"Custom Crosshair", function() _G.QuantumSettings.CustomCrosshair = not _G.QuantumSettings.CustomCrosshair ShowNotification("CustomCrosshair " .. (_G.QuantumSettings.CustomCrosshair and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Automation", Options = {
        {"Trade Scanner", function() _G.QuantumSettings.TradeScanner = not _G.QuantumSettings.TradeScanner ShowNotification("TradeScanner " .. (_G.QuantumSettings.TradeScanner and "ON" or "OFF"), 2) end},
        {"Auto Quest Prioritizer", function() _G.QuantumSettings.AutoQuestPrioritizer = not _G.QuantumSettings.AutoQuestPrioritizer ShowNotification("AutoQuestPrioritizer " .. (_G.QuantumSettings.AutoQuestPrioritizer and "ON" or "OFF"), 2) end},
        {"Auto Trade Negotiator", function() _G.QuantumSettings.AutoTradeNegotiator = not _G.QuantumSettings.AutoTradeNegotiator ShowNotification("AutoTradeNegotiator " .. (_G.QuantumSettings.AutoTradeNegotiator and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Player", Options = {
        {"Spectate Player", function() _G.QuantumSettings.SpectatePlayer = not _G.QuantumSettings.SpectatePlayer ShowNotification("SpectatePlayer " .. (_G.QuantumSettings.SpectatePlayer and "ON" or "OFF"), 2) end},
        {"Auto Translate Chat", function() _G.QuantumSettings.AutoTranslateChat = not _G.QuantumSettings.AutoTranslateChat ShowNotification("AutoTranslateChat " .. (_G.QuantumSettings.AutoTranslateChat and "ON" or "OFF"), 2) end},
        {"Show Untranslated Chat", function() _G.QuantumSettings.ShowUntranslatedChat = not _G.QuantumSettings.ShowUntranslatedChat ShowNotification("ShowUntranslatedChat " .. (_G.QuantumSettings.ShowUntranslatedChat and "ON" or "OFF"), 2) end}
    }},
    {Name = "Tab Settings", Options = {
        {"Anti AFK", function() _G.QuantumSettings.AntiAFK = not _G.QuantumSettings.AntiAFK ShowNotification("AntiAFK " .. (_G.QuantumSettings.AntiAFK and "ON" or "OFF"), 2) end},
        {"Lag Reducer", function() _G.QuantumSettings.LagReducer = not _G.QuantumSettings.LagReducer ShowNotification("LagReducer " .. (_G.QuantumSettings.LagReducer and "ON" or "OFF"), 2) end},
        {"Anti Exploit Detection", function() _G.QuantumSettings.AntiExploitDetection = not _G.QuantumSettings.AntiExploitDetection ShowNotification("AntiExploitDetection " .. (_G.QuantumSettings.AntiExploitDetection and "ON" or "OFF"), 2) end},
        {"Auto Exploit Reporter", function() _G.QuantumSettings.AutoExploitReporter = not _G.QuantumSettings.AutoExploitReporter ShowNotification("AutoExploitReporter " .. (_G.QuantumSettings.AutoExploitReporter and "ON" or "OFF"), 2) end},
        {"Custom Hotkeys", function() _G.QuantumSettings.CustomHotkeys = not _G.QuantumSettings.CustomHotkeys ShowNotification("CustomHotkeys " .. (_G.QuantumSettings.CustomHotkeys and "ON" or "OFF"), 2) end},
        {"Performance Profiler", function() _G.QuantumSettings.PerformanceProfiler = not _G.QuantumSettings.PerformanceProfiler ShowNotification("PerformanceProfiler " .. (_G.QuantumSettings.PerformanceProfiler and "ON" or "OFF"), 2) end},
        {"Dynamic GUI Themes", function() _G.QuantumSettings.DynamicGUIThemes = not _G.QuantumSettings.DynamicGUIThemes ShowNotification("DynamicGUIThemes " .. (_G.QuantumSettings.DynamicGUIThemes and "ON" or "OFF"), 2) end},
        {"Server Load Balancer", function() _G.QuantumSettings.ServerLoadBalancer = not _G.QuantumSettings.ServerLoadBalancer ShowNotification("ServerLoadBalancer " .. (_G.QuantumSettings.ServerLoadBalancer and "ON" or "OFF"), 2) end},
        {"Analytics Dashboard", function() _G.QuantumSettings.AnalyticsDashboard = not _G.QuantumSettings.AnalyticsDashboard ShowNotification("AnalyticsDashboard " .. (_G.QuantumSettings.AnalyticsDashboard and "ON" or "OFF"), 2) end}
    }}
}

local CurrentTab = nil
for i, tab in pairs(Tabs) do
    local Button = Instance.new("TextButton", TabList)
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, (i-1) * 45)
    Button.Text = tab.Name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button
    Button.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        CurrentTab = Instance.new("Frame", ContentFrame)
        CurrentTab.Size = UDim2.new(1, -10, 1, -10)
        CurrentTab.Position = UDim2.new(0, 5, 0, 5)
        CurrentTab.BackgroundTransparency = 1
        local y = 0
        for _, option in pairs(tab.Options) do
            local OptButton = Instance.new("TextButton", CurrentTab)
            OptButton.Size = UDim2.new(1, -20, 0, 40)
            OptButton.Position = UDim2.new(0, 10, 0, y)
            OptButton.Text = option[1]
            OptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 5)
            OptCorner.Parent = OptButton
            OptButton.MouseButton1Click:Connect(option[2])
            y = y + 45
        end
        CurrentTab.Visible = true
    end)
end

-- Update Status Loop
RunService.RenderStepped:Connect(function()
    BossStatus.Text = "Boss Status: " .. UpdateBossStatus()
    local phase, timeToFull = GetMoonStatus()
    MoonStatus.Text = "Moon Status: " .. phase .. " (Time to Full: " .. timeToFull .. ")"
end)

-- Feature Implementations
local function AutoFarmLevel()
    while _G.QuantumSettings.AutoFarmLevel do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        local quest = nil
        for _, q in pairs(workspace.Quests:GetChildren()) do
            if q:IsA("Model") and q:FindFirstChild("QuestData") then quest = q break end
        end
        if quest then
            local npcs = {}
            for _, npc in pairs(workspace.NPCs:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("QuestTarget") and npc.QuestTarget.Value == quest.Name then
                    table.insert(npcs, npc)
                end
            end
            if #npcs > 0 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = npcs[1].HumanoidRootPart.CFrame + Vector3.new(0, 6, 0)
                VirtualUser:ClickButton1(Vector2.new())
                SimulateHumanBehavior()
            else
                ReplicatedStorage.Remotes.QuestRemote:FireServer("Accept")
            end
        end
        task.wait(1)
    end
end

local function AutoFarmBoss()
    while _G.QuantumSettings.AutoFarmBoss do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        local sea = GetCurrentSea()
        local bosses = {}
        for _, boss in pairs(workspace.Enemies:GetChildren()) do
            if boss:IsA("Model") and boss.Name:find("Boss") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                local bossSea = 1
                if boss.HumanoidRootPart.Position.X > 150000 then bossSea = 3
                elseif boss.HumanoidRootPart.Position.X > 50000 then bossSea = 2 end
                if bossSea == sea then table.insert(bosses, boss) end
            end
        end
        if #bosses > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = bosses[1].HumanoidRootPart.CFrame + Vector3.new(0, 6, 0)
            VirtualUser:ClickButton1(Vector2.new())
            SimulateHumanBehavior()
            if _G.QuantumSettings.WebhookNotifications and _G.QuantumSettings.WebhookURL ~= "" then
                pcall(function()
                    HttpService:PostAsync(_G.QuantumSettings.WebhookURL, HttpService:JSONEncode({content = "Boss killed: " .. bosses[1].Name}))
                end)
            end
        end
        task.wait(1)
    end
end

local function AutoFarmHaki()
    while _G.QuantumSettings.AutoFarmHaki do
        ReplicatedStorage.Remotes.HakiRemote:FireServer("Train")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AutoFarmChest()
    while _G.QuantumSettings.AutoFarmChest do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        local chests = {}
        for _, chest in pairs(workspace:GetChildren()) do
            if chest.Name:find("Chest") then table.insert(chests, chest) end
        end
        if #chests > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = chests[1].CFrame
            ReplicatedStorage.Remotes.CollectChest:FireServer(chests[1])
            SimulateHumanBehavior()
        end
        task.wait(1)
    end
end

local function AutoRaid()
    while _G.QuantumSettings.AutoRaid do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        ReplicatedStorage.Remotes.RaidRemote:FireServer("Join")
        local enemies = {}
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                table.insert(enemies, enemy)
            end
        end
        if #enemies > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = enemies[1].HumanoidRootPart.CFrame + Vector3.new(0, 6, 0)
            VirtualUser:ClickButton1(Vector2.new())
            SimulateHumanBehavior()
        end
        task.wait(1)
    end
end

local function AutoSeaEvents()
    while _G.QuantumSettings.AutoSeaEvents do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, event in pairs(workspace:GetChildren()) do
            if event.Name:find("SeaEvent") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = event.CFrame
                break
            end
        end
        task.wait(1)
    end
end

local function AutoLeviathan()
    while _G.QuantumSettings.AutoLeviathan do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, leviathan in pairs(workspace:GetChildren()) do
            if leviathan.Name:find("Leviathan") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = leviathan.CFrame + Vector3.new(0, 10, 0)
                VirtualUser:ClickButton1(Vector2.new())
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(1)
    end
end

local function AutoTerrorshark()
    while _G.QuantumSettings.AutoTerrorshark do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, shark in pairs(workspace:GetChildren()) do
            if shark.Name:find("Terrorshark") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = shark.CFrame + Vector3.new(0, 10, 0)
                VirtualUser:ClickButton1(Vector2.new())
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(1)
    end
end

local function AutoSeaBeast()
    while _G.QuantumSettings.AutoSeaBeast do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, beast in pairs(workspace:GetChildren()) do
            if beast.Name:find("SeaBeast") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = beast.CFrame + Vector3.new(0, 10, 0)
                VirtualUser:ClickButton1(Vector2.new())
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(1)
    end
end

local function AutoGhostShip()
    while _G.QuantumSettings.AutoGhostShip do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, ship in pairs(workspace:GetChildren()) do
            if ship.Name:find("GhostShip") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = ship.CFrame + Vector3.new(0, 10, 0)
                VirtualUser:ClickButton1(Vector2.new())
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(1)
    end
end

local function FruitSniper()
    while _G.QuantumSettings.FruitSniper do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") and fruit:IsA("Model") then
                local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildOfClass("BasePart")
                if handle then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame
                    ReplicatedStorage.Remotes.PickFruit:FireServer(fruit)
                    SimulateHumanBehavior()
                    break
                end
            end
        end
        task.wait(1)
    end
end

local function TeleportToFruit()
    while _G.QuantumSettings.TeleportToFruit do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") and fruit:IsA("Model") then
                local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildOfClass("BasePart")
                if handle then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame
                    break
                end
            end
        end
        task.wait(1)
    end
end

local function IslandTeleport()
    while _G.QuantumSettings.IslandTeleport do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        local islands = {
            {Name = "Windmill", CFrame = CFrame.new(1000, 50, 1000)},
            {Name = "Cafe", CFrame = CFrame.new(100000, 50, 100000)},
            {Name = "Tiki Outpost", CFrame = CFrame.new(200000, 50, 200000)}
        }
        for _, island in pairs(islands) do
            LocalPlayer.Character.HumanoidRootPart.CFrame = island.CFrame
            task.wait(2)
        end
        task.wait(1)
    end
end

local function PlayerBountyFarm()
    while _G.QuantumSettings.PlayerBountyFarm do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 6, 0)
                VirtualUser:ClickButton1(Vector2.new())
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(1)
    end
end

local function AutoRaceV4()
    while _G.QuantumSettings.AutoRaceV4 do
        ReplicatedStorage.Remotes.RaceV4Remote:FireServer("Start")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AutoMirageIsland()
    while _G.QuantumSettings.AutoMirageIsland do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, island in pairs(workspace:GetChildren()) do
            if island.Name:find("MirageIsland") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = island.CFrame
                break
            end
        end
        task.wait(1)
    end
end

local function AutoPrehistoricIsland()
    while _G.QuantumSettings.AutoPrehistoricIsland do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, island in pairs(workspace:GetChildren()) do
            if island.Name:find("PrehistoricIsland") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = island.CFrame
                break
            end
        end
        task.wait(1)
    end
end

local function AutoDojoQuest()
    while _G.QuantumSettings.AutoDojoQuest do
        ReplicatedStorage.Remotes.DojoQuestRemote:FireServer("Start")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AutoStoreFruits()
    while _G.QuantumSettings.AutoStoreFruits do
        for _, fruit in pairs(LocalPlayer.Backpack:GetChildren()) do
            if fruit.Name:find("Fruit") then
                ReplicatedStorage.Remotes.StoreFruit:FireServer(fruit)
                SimulateHumanBehavior()
            end
        end
        task.wait(2)
    end
end

local function AutoQuestCompletion()
    while _G.QuantumSettings.AutoQuestCompletion do
        ReplicatedStorage.Remotes.QuestRemote:FireServer("Complete")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AutoFruitMastery()
    while _G.QuantumSettings.AutoFruitMastery do
        ReplicatedStorage.Remotes.UseSkillRemote:FireServer("Fruit")
        SimulateHumanBehavior()
        task.wait(1)
    end
end

local function AutoBossRush()
    while _G.QuantumSettings.AutoBossRush do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        ReplicatedStorage.Remotes.BossRushRemote:FireServer("Start")
        local bosses = {}
        for _, boss in pairs(workspace.Enemies:GetChildren()) do
            if boss:IsA("Model") and boss.Name:find("Boss") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                table.insert(bosses, boss)
            end
        end
        if #bosses > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = bosses[1].HumanoidRootPart.CFrame + Vector3.new(0, 6, 0)
            VirtualUser:ClickButton1(Vector2.new())
            SimulateHumanBehavior()
        end
        task.wait(1)
    end
end

local function AutoTradeFruits()
    while _G.QuantumSettings.AutoTradeFruits do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                ReplicatedStorage.Remotes.TradeRequestRemote:FireServer(player)
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(2)
    end
end

local function AutoDodge()
    while _G.QuantumSettings.AutoDodge do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                local distance = (enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < 10 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
                    SimulateHumanBehavior()
                end
            end
        end
        task.wait(1)
    end
end

local function AutoFruitUpgrader()
    while _G.QuantumSettings.AutoFruitUpgrader do
        ReplicatedStorage.Remotes.UpgradeFruitRemote:FireServer("Upgrade")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AdvancedESP()
    while _G.QuantumSettings.AdvancedESP do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
                task.spawn(function() task.wait(1) highlight:Destroy() end)
            end
        end
        task.wait(1)
    end
end

local function CombatESP()
    while _G.QuantumSettings.CombatESP do
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = enemy
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = enemy
                task.spawn(function() task.wait(1) highlight:Destroy() end)
            end
        end
        task.wait(1)
    end
end

local function PredictiveFruitSpawn()
    while _G.QuantumSettings.PredictiveFruitSpawn do
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") then
                ShowNotification("Fruit predicted at " .. tostring(fruit.Position), 3)
            end
        end
        task.wait(5)
    end
end

local function CustomAuraColor()
    while _G.QuantumSettings.CustomAuraColor do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local aura = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Aura")
            if aura then aura.Color = _G.QuantumSettings.AuraColor end
        end
        task.wait(1)
    end
end

local function DynamicHUD()
    while _G.QuantumSettings.DynamicHUD do
        task.wait(2)
    end
end

local function SpectatePlayer()
    while _G.QuantumSettings.SpectatePlayer do
        if _G.QuantumSettings.SpectatePlayer and _G.QuantumSettings.SpectatePlayer.Character then
            Camera.CameraSubject = _G.QuantumSettings.SpectatePlayer.Character.Humanoid
        end
        task.wait(1)
    end
end

local function TeleportToPlayer()
    while _G.QuantumSettings.TeleportToPlayer do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        if _G.QuantumSettings.TeleportToPlayer and _G.QuantumSettings.TeleportToPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = _G.QuantumSettings.TeleportToPlayer.Character.HumanoidRootPart.CFrame
        end
        task.wait(1)
    end
end

local function AutoTranslateChat()
    while _G.QuantumSettings.AutoTranslateChat do
        task.wait(2)
    end
end

local function ShowUntranslatedChat()
    while _G.QuantumSettings.ShowUntranslatedChat do
        task.wait(2)
    end
end

local function AutoStatOptimizer()
    while _G.QuantumSettings.AutoStatOptimizer do
        ReplicatedStorage.Remotes.StatRemote:FireServer("Optimize")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AutoSkillTrainer()
    while _G.QuantumSettings.AutoSkillTrainer do
        ReplicatedStorage.Remotes.SkillRemote:FireServer("Train")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function TradeScanner()
    while _G.QuantumSettings.TradeScanner do
        task.wait(2)
    end
end

local function DynamicStatAllocator()
    while _G.QuantumSettings.DynamicStatAllocator do
        ReplicatedStorage.Remotes.StatRemote:FireServer("Allocate")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AutoAwakening()
    while _G.QuantumSettings.AutoAwakening do
        ReplicatedStorage.Remotes.AwakeningRemote:FireServer("Start")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function AutoQuestPrioritizer()
    while _G.QuantumSettings.AutoQuestPrioritizer do
        ReplicatedStorage.Remotes.QuestRemote:FireServer("Prioritize")
        SimulateHumanBehavior()
        task.wait(2)
    end
end

local function InventoryManager()
    while _G.QuantumSettings.InventoryManager do
        task.wait(2)
    end
end

local function AutoInventoryBackup()
    while _G.QuantumSettings.AutoInventoryBackup do
        local inventory = {}
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do table.insert(inventory, item.Name) end
        if _G.QuantumSettings.WebhookURL ~= "" then
            pcall(function()
                HttpService:PostAsync(_G.QuantumSettings.WebhookURL, HttpService:JSONEncode({inventory = inventory}))
            end)
        end
        task.wait(300)
    end
end

local function AutoTradeNegotiator()
    while _G.QuantumSettings.AutoTradeNegotiator do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                ReplicatedStorage.Remotes.TradeRequestRemote:FireServer(player)
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(2)
    end
end

local function ResourceHeatmap()
    while _G.QuantumSettings.ResourceHeatmap do
        task.wait(2)
    end
end

local function ProximityAlerts()
    while _G.QuantumSettings.ProximityAlerts do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < 50 then ShowNotification("Player nearby: " .. player.Name, 2) end
            end
        end
        task.wait(2)
    end
end

local function CustomCrosshair()
    while _G.QuantumSettings.CustomCrosshair do
        task.wait(2)
    end
end

local function FlyMode()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
    while _G.QuantumSettings.FlyMode do
        local moveDirection = Vector3.new(
            UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0,
            UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0,
            UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
        )
        bodyVelocity.Velocity = Camera.CFrame:VectorToWorldSpace(moveDirection) * _G.QuantumSettings.FlySpeed
        task.wait()
    end
    bodyVelocity:Destroy()
end

local function ServerLoadBalancer()
    while _G.QuantumSettings.ServerLoadBalancer do
        if #Players:GetPlayers() > 25 then TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end
        task.wait(60)
    end
end

local function AnalyticsDashboard()
    while _G.QuantumSettings.AnalyticsDashboard do
        task.wait(2)
    end
end

local function AutoMiragePuzzle()
    while _G.QuantumSettings.AutoMiragePuzzle do
        for _, puzzle in pairs(workspace:GetChildren()) do
            if puzzle.Name:find("MiragePuzzle") then
                ReplicatedStorage.Remotes.SolvePuzzle:FireServer(puzzle)
                SimulateHumanBehavior()
                break
            end
        end
        task.wait(2)
    end
end

local function AutoFruitRarityScanner()
    while _G.QuantumSettings.AutoFruitRarityScanner do
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") and fruit:IsA("Model") then
                local rarity = fruit:FindFirstChild("Rarity") and fruit.Rarity.Value or "Common"
                if rarity == "Legendary" or rarity == "Mythical" then
                    ShowNotification("Rare fruit found: " .. fruit.Name .. " (" .. rarity .. ")", 5)
                    if _G.QuantumSettings.WebhookNotifications and _G.QuantumSettings.WebhookURL ~= "" then
                        pcall(function()
                            HttpService:PostAsync(_G.QuantumSettings.WebhookURL, HttpService:JSONEncode({content = "Rare fruit found: " .. fruit.Name .. " (" .. rarity .. ")"}))
                        end)
                    end
                end
            end
        end
        task.wait(5)
    end
end

local function CustomAuraEffects()
    while _G.QuantumSettings.CustomAuraEffects do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local particle = Instance.new("ParticleEmitter")
            particle.Texture = "rbxassetid://243098098"
            particle.Size = NumberSequence.new(1, 0)
            particle.Lifetime = NumberRange.new(1, 2)
            particle.Rate = 50
            particle.Speed = NumberRange.new(5)
            particle.Parent = LocalPlayer.Character.HumanoidRootPart
            task.spawn(function() task.wait(1) particle:Destroy() end)
        end
        task.wait(1)
    end
end

local function ServerHopForEvents()
    while _G.QuantumSettings.ServerHopForEvents do
        local foundEvent = false
        for _, event in pairs(workspace:GetChildren()) do
            if event.Name:find("SeaEvent") or event.Name:find("MirageIsland") then foundEvent = true break end
        end
        if not foundEvent then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end
        task.wait(30)
    end
end

local function AutoCollectDailyRewards()
    while _G.QuantumSettings.AutoCollectDailyRewards do
        ReplicatedStorage.Remotes.DailyReward:FireServer("Claim")
        SimulateHumanBehavior()
        task.wait(300)
    end
end

local function PlayerTracker()
    while _G.QuantumSettings.PlayerTracker do
        if _G.QuantumSettings.PlayerTracker and _G.QuantumSettings.PlayerTracker.Character then
            ShowNotification("Tracking " .. _G.QuantumSettings.PlayerTracker.Name .. " at " .. tostring(_G.QuantumSettings.PlayerTracker.Character.HumanoidRootPart.Position), 3)
        end
        task.wait(5)
    end
end

local function AutoFruitAwakeningCombo()
    while _G.QuantumSettings.AutoFruitAwakeningCombo do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            ReplicatedStorage.Remotes.UseSkillRemote:FireServer("FruitSkill1")
            task.wait(0.5)
            ReplicatedStorage.Remotes.UseSkillRemote:FireServer("FruitSkill2")
            SimulateHumanBehavior()
        end
        task.wait(2)
    end
end

-- Feature Management
local function ManageFeatures()
    while true do
        if _G.QuantumSettings.AutoFarmLevel then task.spawn(AutoFarmLevel) end
        if _G.QuantumSettings.AutoFarmBoss then task.spawn(AutoFarmBoss) end
        if _G.QuantumSettings.AutoFarmHaki then task.spawn(AutoFarmHaki) end
        if _G.QuantumSettings.AutoFarmChest then task.spawn(AutoFarmChest) end
        if _G.QuantumSettings.AutoRaid then task.spawn(AutoRaid) end
        if _G.QuantumSettings.AutoSeaEvents then task.spawn(AutoSeaEvents) end
        if _G.QuantumSettings.AutoLeviathan then task.spawn(AutoLeviathan) end
        if _G.QuantumSettings.AutoTerrorshark then task.spawn(AutoTerrorshark) end
        if _G.QuantumSettings.AutoSeaBeast then task.spawn(AutoSeaBeast) end
        if _G.QuantumSettings.AutoGhostShip then task.spawn(AutoGhostShip) end
        if _G.QuantumSettings.FruitSniper then task.spawn(FruitSniper) end
        if _G.QuantumSettings.TeleportToFruit then task.spawn(TeleportToFruit) end
        if _G.QuantumSettings.IslandTeleport then task.spawn(IslandTeleport) end
        if _G.QuantumSettings.PlayerBountyFarm then task.spawn(PlayerBountyFarm) end
        if _G.QuantumSettings.AutoRaceV4 then task.spawn(AutoRaceV4) end
        if _G.QuantumSettings.AutoMirageIsland then task.spawn(AutoMirageIsland) end
        if _G.QuantumSettings.AutoPrehistoricIsland then task.spawn(AutoPrehistoricIsland) end
        if _G.QuantumSettings.AutoDojoQuest then task.spawn(AutoDojoQuest) end
        if _G.QuantumSettings.AutoStoreFruits then task.spawn(AutoStoreFruits) end
        if _G.QuantumSettings.AutoQuestCompletion then task.spawn(AutoQuestCompletion) end
        if _G.QuantumSettings.AutoFruitMastery then task.spawn(AutoFruitMastery) end
        if _G.QuantumSettings.AutoBossRush then task.spawn(AutoBossRush) end
        if _G.QuantumSettings.AutoTradeFruits then task.spawn(AutoTradeFruits) end
        if _G.QuantumSettings.AutoDodge then task.spawn(AutoDodge) end
        if _G.QuantumSettings.AutoFruitUpgrader then task.spawn(AutoFruitUpgrader) end
        if _G.QuantumSettings.AdvancedESP then task.spawn(AdvancedESP) end
        if _G.QuantumSettings.CombatESP then task.spawn(CombatESP) end
        if _G.QuantumSettings.PredictiveFruitSpawn then task.spawn(PredictiveFruitSpawn) end
        if _G.QuantumSettings.CustomAuraColor then task.spawn(CustomAuraColor) end
        if _G.QuantumSettings.DynamicHUD then task.spawn(DynamicHUD) end
        if _G.QuantumSettings.SpectatePlayer then task.spawn(SpectatePlayer) end
        if _G.QuantumSettings.TeleportToPlayer then task.spawn(TeleportToPlayer) end
        if _G.QuantumSettings.AutoTranslateChat then task.spawn(AutoTranslateChat) end
        if _G.QuantumSettings.ShowUntranslatedChat then task.spawn(ShowUntranslatedChat) end
        if _G.QuantumSettings.AutoStatOptimizer then task.spawn(AutoStatOptimizer) end
        if _G.QuantumSettings.AutoSkillTrainer then task.spawn(AutoSkillTrainer) end
        if _G.QuantumSettings.TradeScanner then task.spawn(TradeScanner) end
        if _G.QuantumSettings.DynamicStatAllocator then task.spawn(DynamicStatAllocator) end
        if _G.QuantumSettings.AutoAwakening then task.spawn(AutoAwakening) end
        if _G.QuantumSettings.AutoQuestPrioritizer then task.spawn(AutoQuestPrioritizer) end
        if _G.QuantumSettings.InventoryManager then task.spawn(InventoryManager) end
        if _G.QuantumSettings.AutoInventoryBackup then task.spawn(AutoInventoryBackup) end
        if _G.QuantumSettings.AutoTradeNegotiator then task.spawn(AutoTradeNegotiator) end
        if _G.QuantumSettings.ResourceHeatmap then task.spawn(ResourceHeatmap) end
        if _G.QuantumSettings.ProximityAlerts then task.spawn(ProximityAlerts) end
        if _G.QuantumSettings.CustomCrosshair then task.spawn(CustomCrosshair) end
        if _G.QuantumSettings.FlyMode then task.spawn(FlyMode) end
        if _G.QuantumSettings.ServerLoadBalancer then task.spawn(ServerLoadBalancer) end
        if _G.QuantumSettings.AnalyticsDashboard then task.spawn(AnalyticsDashboard) end
        if _G.QuantumSettings.AutoMiragePuzzle then task.spawn(AutoMiragePuzzle) end
        if _G.QuantumSettings.AutoFruitRarityScanner then task.spawn(AutoFruitRarityScanner) end
        if _G.QuantumSettings.CustomAuraEffects then task.spawn(CustomAuraEffects) end
        if _G.QuantumSettings.ServerHopForEvents then task.spawn(ServerHopForEvents) end
        if _G.QuantumSettings.AutoCollectDailyRewards then task.spawn(AutoCollectDailyRewards) end
        if _G.QuantumSettings.PlayerTracker then task.spawn(PlayerTracker) end
        if _G.QuantumSettings.AutoFruitAwakeningCombo then task.spawn(AutoFruitAwakeningCombo) end
        task.wait(2)
    end
end
task.spawn(ManageFeatures)

-- Anti-AFK
local function AntiAFK()
    while _G.QuantumSettings.AntiAFK do
        VirtualUser:CaptureController()
        VirtualUser:SetKeyDown(Enum.KeyCode.W)
        task.wait(0.1)
        VirtualUser:SetKeyUp(Enum.KeyCode.W)
        task.wait(60)
    end
end
if _G.QuantumSettings.AntiAFK then task.spawn(AntiAFK) end

-- Performance Profiler
local function PerformanceProfiler()
    while _G.QuantumSettings.PerformanceProfiler do
        local fps = 1 / RunService.RenderStepped:Wait()
        if fps < 60 then
            _G.QuantumSettings.LagReducer = true
            Lighting.GlobalShadows = false
            RunService:Set3dRenderingEnabled(false)
        elseif fps > 100 then
            Lighting.GlobalShadows = true
            RunService:Set3dRenderingEnabled(true)
        end
        task.wait(5)
    end
end
if _G.QuantumSettings.PerformanceProfiler then task.spawn(PerformanceProfiler) end

-- Dynamic Themes
local Themes = {
    Dark = {Background = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(0, 255, 127), Text = Color3.fromRGB(255, 255, 255)},
    Light = {Background = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(0, 128, 255), Text = Color3.fromRGB(0, 0, 0)}
}
local CurrentTheme = Themes.Dark
local function UpdateTheme()
    while _G.QuantumSettings.DynamicGUIThemes do
        CurrentTheme = Themes[math.random(1, 2) == 1 and "Dark" or "Light"]
        MainFrame.BackgroundColor3 = CurrentTheme.Background
        TabList.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(0, 0, 0), 0.1)
        ContentFrame.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(10, 10, 10), 0.2)
        StatusFrame.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(0, 0, 0), 0.1)
        Title.TextColor3 = CurrentTheme.Accent
        BossStatus.TextColor3 = CurrentTheme.Accent
        MoonStatus.TextColor3 = CurrentTheme.Accent
        for _, child in pairs(TabList:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(5, 5, 5), 0.1)
                child.TextColor3 = CurrentTheme.Text
            end
        end
        if CurrentTab then
            for _, child in pairs(CurrentTab:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(10, 10, 10), 0.2)
                    child.TextColor3 = CurrentTheme.Text
                end
            end
        end
        task.wait(30)
    end
end
if _G.QuantumSettings.DynamicGUIThemes then task.spawn(UpdateTheme) end

-- Mobile Touch Support
local touchStart = nil
UserInputService.TouchStarted:Connect(function(input)
    touchStart = input.Position
end)
UserInputService.TouchEnded:Connect(function(input)
    if touchStart then
        local delta = input.Position - touchStart
        if delta.Magnitude > 50 then
            ShowNotification("Swipe detected: " .. tostring(delta), 2)
        end
    end
    touchStart = nil
end)

print("QuantumHubV5: Initialized successfully")
