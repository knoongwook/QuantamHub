-- Final Notification
StarterGui:SetCore("SendNotification", {
    Title = "Dream Hub",
    Text = "Enhanced features loaded successfully. Use responsibly.",
    Duration = 5
})

-- Enhanced Notification System for Mobile Debugging
local function sendErrorNotification(message)
    StarterGui:SetCore("SendNotification", {
        Title = "Dream Hub Error",
        Text = message,
        Duration = 10
    })
    if CONFIG.WEBHOOK_URL ~= "" then
        sendWebhook("Error: " .. message)
    end
end

-- Modified findClosestNPC to Handle Missing Humanoids
local function findClosestNPC(npcName)
    local closest, closestDist = nil, math.huge
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        local success, result = pcall(function()
            if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
                local humanoid = npc:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 or not humanoid then
                    local dist = (npc.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                    if dist < closestDist then
                        closest = npc
                        closestDist = dist
                    end
                end
            end
        end)
        if not success then
            sendErrorNotification("NPC Error (" .. npcName .. "): " .. result)
        end
    end
    return closest
end

-- Modified attackNPC to Handle Effect Container Issues
local function attackNPC(npc)
    local success, result = pcall(function()
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            local humanoid = npc:FindFirstChild("Humanoid")
            if (humanoid and humanoid.Health > 0) or not humanoid then
                safeTeleport(npc.HumanoidRootPart.Position + Vector3.new(0, CONFIG.FARM_DISTANCE, 0))
                ReplicatedStorage.Remotes.Combat:FireServer("Attack", npc)
                task.wait(math.random(CONFIG.ATTACK_DELAY.Min, CONFIG.ATTACK_DELAY.Max))
                if UserInputService.TouchEnabled then
                    local clickDetector = npc:FindFirstChildOfClass("ClickDetector")
                    if clickDetector then
                        fireclickdetector(clickDetector)
                    end
                else
                    simulateHumanInput()
                end
            end
        end
    end)
    if not success then
        sendErrorNotification("Attack Error: " .. result)
    end
end

-- Modified collectFruits to Handle Missing Handles and Celestial Fruit
local function collectFruits()
    for _, fruit in pairs(Workspace:GetChildren()) do
        local success, result = pcall(function()
            if fruit:IsA("Tool") and (table.find(CONFIG.TARGET_FRUITS, fruit.Name) or fruit.Name == "Celestial Fruit") then
                local handle = fruit:FindFirstChild("Handle")
                if handle then
                    safeTeleport(handle.Position)
                    firetouchinterest(HumanoidRootPart, handle, 0)
                    firetouchinterest(HumanoidRootPart, handle, 1)
                    if CONFIG.WEBHOOK_URL ~= "" then
                        sendWebhook("Fruit Found: " .. fruit.Name)
                    end
                else
                    sendErrorNotification("Fruit Error (" .. fruit.Name .. "): No Handle")
                end
            end
        end)
        if not success then
            sendErrorNotification("Fruit Collection Error: " .. result)
        end
    end
end

-- Modified simulateHumanInput for Mobile Compatibility
local function simulateHumanInput()
    if CONFIG.ANTI_BAN.HUMAN_INPUT_SIMULATION and not UserInputService.TouchEnabled then
        local success, result = pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(math.random(0, 100), math.random(0, 100)))
        end)
        if not success then
            sendErrorNotification("Input Simulation Error: " .. result)
        end
    end
    task.wait(math.random(0.05, 0.15))
end

-- Modified optimizePerformance for Mobile
local function optimizePerformance()
    local success, result = pcall(function()
        if CONFIG.LOW_TEXTURES then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Texture = ""
                end
            end
        end
        if CONFIG.FPS_CAP > 0 and not UserInputService.TouchEnabled then
            RunService:Set3dRenderingEnabled(true)
            setfpscap(CONFIG.FPS_CAP)
        end
        if CONFIG.WHITE_SCREEN and not UserInputService.TouchEnabled then
            local screen = Instance.new("Frame")
            screen.Size = UDim2.new(1, 0, 1, 0)
            screen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            screen.BackgroundTransparency = 0.5
            screen.Parent = game.CoreGui
        end
    end)
    if not success then
        sendErrorNotification("Performance Optimization Error: " .. result)
    end
end

-- Dynamic Configuration System
local function updateDynamicConfig()
    local success, result = pcall(function()
        local serverHealth = math.clamp(Workspace.ServerAge.Value / 3600, 0.5, 2.0)
        local playerDensity = #Players:GetPlayers() / 50
        CONFIG.TELEPORT_SPEED = math.max(200, 300 / (serverHealth * playerDensity))
        CONFIG.ANTI_BAN.ACTION_RATE_LIMIT = math.floor(100 / (serverHealth * playerDensity))
        CONFIG.FARM_DISTANCE = math.clamp(15 * serverHealth, 10, 20)
        sendNotification("Dynamic config updated: Teleport Speed = " .. CONFIG.TELEPORT_SPEED .. ", Action Limit = " .. CONFIG.ANTI_BAN.ACTION_RATE_LIMIT)
    end)
    if not success then
        sendErrorNotification("Config Update Error: " .. result)
    end
end

-- New Feature: Auto Dragon Trident
local function autoFarmDragonTrident()
    local success, result = pcall(function()
        ReplicatedStorage.Remotes.Quest:FireServer("Dragon Trident Quest")
        task.wait(1)
        local boss = findClosestNPC("Dragon Lord")
        if boss then
            attackNPC(boss)
        else
            safeTeleport(Vector3.new(5225, 603, 350)) -- Hydra Island
            sendNotification("Teleporting to Hydra Island for Dragon Trident")
        end
    end)
    if not success then
        sendErrorNotification("Dragon Trident Error: " .. result)
    end
end

-- New Feature: Mirage Island Tracker
local function autoMirageIsland()
    local success, result = pcall(function()
        local mirage = Workspace:FindFirstChild("Mirage Island")
        if mirage then
            safeTeleport(mirage.Position)
            sendNotification("Mirage Island detected! Teleported to location.")
            if CONFIG.WEBHOOK_URL ~= "" then
                sendWebhook("Mirage Island Spawned")
            end
        else
            sendNotification("No Mirage Island found. Checking again in 60s...")
        end
    end)
    if not success then
        sendErrorNotification("Mirage Island Error: " .. result)
    end
end

-- New Feature: Auto Race V4 Trials
local function autoRaceV4Trials()
    local success, result = pcall(function()
        local trials = {"Trial of Human", "Trial of Mink", "Trial of Shark", "Trial of Cyborg"}
        for _, trial in ipairs(trials) do
            local trialInstance = Workspace:FindFirstChild(trial)
            if trialInstance then
                safeTeleport(trialInstance.Position)
                ReplicatedStorage.Remotes.Puzzle:FireServer(trial)
                sendNotification("Attempting " .. trial)
                return
            end
        end
        safeTeleport(Vector3.new(-9500, 40, 5500)) -- Default to Temple of Time
        sendNotification("No trials found. Teleporting to Temple of Time.")
    end)
    if not success then
        sendErrorNotification("Race V4 Trials Error: " .. result)
    end
end

-- New Feature: Auto Awaken Fruits
local function autoAwakenFruits()
    local success, result = pcall(function()
        local awakening = Workspace:FindFirstChild("Awakening Altar")
        if awakening then
            safeTeleport(awakening.Position)
            ReplicatedStorage.Remotes.Awakening:FireServer("Awaken")
            sendNotification("Attempting to awaken fruit")
        else
            sendNotification("No Awakening Altar found. Checking again in 30s...")
        end
    end)
    if not success then
        sendErrorNotification("Fruit Awakening Error: " .. result)
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
        local success, result = pcall(function()
            local serverAge = Workspace.ServerAge.Value / 3600
            if serverAge > 24 then
                sendNotification("Server age exceeds 24 hours. Initiating server hop.")
                Toggles.AutoServerHop = true
            end
        end)
        if not success then
            sendErrorNotification("Server Health Error: " .. result)
        end
    end)
end

local function simulatePlayerActivity()
    spawn(function()
        while true do
            if CONFIG.ANTI_BAN.HUMAN_INPUT_SIMULATION and not UserInputService.TouchEnabled then
                local success, result = pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:SetKeyDown(Enum.KeyCode.W)
                    task.wait(math.random(0.1, 0.3))
                    VirtualUser:SetKeyUp(Enum.KeyCode.W)
                    VirtualUser:MoveMouse(Vector2.new(math.random(-50, 50), math.random(-50, 50)))
                end)
                if not success then
                    sendErrorNotification("Player Activity Error: " .. result)
                end
            end
            task.wait(math.random(5, 15))
        end
    end)
end

-- Improved Mobile UI
local function createMobileUI()
    local success, result = pcall(function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DreamHub"
        screenGui.Parent = game.CoreGui
        screenGui.IgnoreGuiInset = true

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
        mainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        mainFrame.Parent = screenGui
        mainFrame.Visible = false

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = mainFrame

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.BackgroundTransparency = 1
        title.Text = "Dream Hub - Blox Fruits"
        title.TextColor3 = Color3.fromRGB(0, 255, 255)
        title.TextSize = 24
        title.Font = Enum.Font.SourceSansBold
        title.Parent = mainFrame

        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 50, 0, 50)
        toggleButton.Position = UDim2.new(1, -60, 0, 10)
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleButton.Text = "X"
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.TextSize = 20
        toggleButton.Parent = mainFrame

        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, -10, 1, -60)
        contentFrame.Position = UDim2.new(0, 5, 0, 55)
        contentFrame.BackgroundTransparency = 1
        contentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
        contentFrame.ScrollBarThickness = 5
        contentFrame.Parent = mainFrame

        toggleButton.MouseButton1Click:Connect(function()
            mainFrame.Visible = not mainFrame.Visible
        end)

        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F4 or input.UserInputType == Enum.UserInputType.Touch then
                mainFrame.Visible = not mainFrame.Visible
            end
        end)

        screenGui.MainFrame = mainFrame
        screenGui.ContentFrame = contentFrame
        return screenGui
    end)
    if not success then
        sendErrorNotification("UI Creation Error: " .. result)
    end
    return success and result
end

-- Add New Features to UI
local function addNewFeatureToggles(screenGui)
    local success, result = pcall(function()
        local newFeatures = {
            {Name = "AutoDragonTrident", Tab = "Farming"},
            {Name = "AutoMirageIsland", Tab = "Teleport"},
            {Name = "AutoRaceV4Trials", Tab = "Farming"},
            {Name = "AutoAwakenFruits", Tab = "Farming"}
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
    end)
    if not success then
        sendErrorNotification("Feature Toggle Error: " .. result)
    end
end

-- Enhanced Initialization
local function initializeEnhancedFeatures()
    local success, result = pcall(function()
        Toggles.AutoDragonTrident = false
        Toggles.AutoMirageIsland = false
        Toggles.AutoRaceV4Trials = false
        Toggles.AutoAwakenFruits = false

        local screenGui = game.CoreGui:FindFirstChild("DreamHub") or createMobileUI()
        addNewFeatureToggles(screenGui)
        updateDynamicConfig()
        randomizePacketTiming()
        monitorServerHealth()
        simulatePlayerActivity()
    end)
    if not success then
        sendErrorNotification("Initialization Error: " .. result)
    end
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
                if Toggles.AutoDragonTrident then autoFarmDragonTrident() end
                if Toggles.AutoMirageIsland then autoMirageIsland() end
                if Toggles.AutoRaceV4Trials then autoRaceV4Trials() end
            end)
            if not success then
                sendErrorNotification("Main Loop Error: " .. err)
                sendWebhook("Main Loop Error: " .. err)
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
    local success, result = pcall(function()
        local obfuscatedMain = advancedObfuscate([[
            ]] .. string.dump(main, true) .. [[
        ]])
        loadstring(obfuscatedMain)()
    end)
    if not success then
        sendErrorNotification("Execution Error: " .. result)
    end
end

-- Completion Notification
StarterGui:SetCore("SendNotification", {
    Title = "Dream Hub",
    Text = "All enhanced features, including Update 24 automation, loaded. Ready for action!",
    Duration = 5
})
