local function autoDragonTalon()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1500 then
        local tikiOutpost = SEA_DATA.ThirdSea.Islands[8]
        safeTeleport(tikiOutpost.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Dragon Talon Sage")
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            local success, err = pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon")
            end)
            if success then
                sendWebhook("Attempting to unlock Dragon Talon")
            else
                sendWebhook("Failed to unlock Dragon Talon: " .. tostring(err))
            end
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
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            local success, err = pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman")
            end)
            if success then
                sendWebhook("Attempting to unlock Godhuman")
            else
                sendWebhook("Failed to unlock Godhuman: " .. tostring(err))
            end
            task.wait(0.1)
        end
    end
end

local function autoStoreFruits()
    local fruits = LocalPlayer.Backpack:GetChildren()
    for _, fruit in ipairs(fruits) do
        if fruit:IsA("Tool") then
            for _, targetFruit in ipairs(CONFIG.TARGET_FRUITS) do
                if fruit.Name == targetFruit.Name then
                    local success, err = pcall(function()
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruit.Name)
                    end)
                    if success then
                        sendWebhook("Storing fruit: " .. fruit.Name)
                    else
                        sendWebhook("Failed to store fruit: " .. tostring(err))
                    end
                    task.wait(0.1)
                    break
                end
            end
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
        if crewNPC and crewNPC:FindFirstChild("HumanoidRootPart") then
            safeTeleport(crewNPC.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = crewNPC:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            local success, err = pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", CONFIG.TEAM)
            end)
            if success then
                sendWebhook("Joining crew: " .. CONFIG.TEAM)
            else
                sendWebhook("Failed to join crew: " .. tostring(err))
            end
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
            local success, err = pcall(function()
                TeleportService:Teleport(game.PlaceId)
            end)
            if not success then
                sendWebhook("Server hop failed: " .. tostring(err))
            end
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
        if longma and longma:FindFirstChild("HumanoidRootPart") then
            safeTeleport(longma.HumanoidRootPart.Position)
            attackNPC(longma)
            sendWebhook("Farming Longma for Cursed Dual Katana")
        end
        local success, err = pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial")
        end)
        if not success then
            sendWebhook("Failed CDK quest: " .. tostring(err))
        end
        task.wait(0.1)
    end
end

local function autoSharkmanKarate()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    if level >= 1425 then
        local forgottenIsland = SEA_DATA.SecondSea.Islands[8]
        safeTeleport(forgottenIsland.Pos)
        local npc = Workspace:FindFirstChild("QuestGivers") and Workspace.QuestGivers:FindFirstChild("Daigrock The Sharkman")
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            local success, err = pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
            end)
            if success then
                sendWebhook("Attempting to unlock Sharkman Karate")
            else
                sendWebhook("Failed to unlock Sharkman Karate: " .. tostring(err))
            end
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
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            safeTeleport(npc.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            local success, err = pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDarkStep")
            end)
            if success then
                sendWebhook("Attempting to unlock Dark Step")
            else
                sendWebhook("Failed to unlock Dark Step: " .. tostring(err))
            end
            task.wait(0.1)
        end
    end
end

local function autoBuyBoats()
    local boatVendor = Workspace:FindFirstChild("Vendors") and Workspace.Vendors:FindFirstChild("Boat Dealer")
    if boatVendor and boatVendor:FindFirstChild("HumanoidRootPart") then
        safeTeleport(boatVendor.HumanoidRootPart.Position)
        task.wait(0.1)
        local prompt = boatVendor:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        end
        local success, err = pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBoat", "Guardian")
        end)
        if success then
            sendWebhook("Purchasing Guardian boat")
        else
            sendWebhook("Failed to purchase boat: " .. tostring(err))
        end
        task.wait(0.1)
    end
end

local function autoSpinFruit()
    local bloxFruitDealer = Workspace:FindFirstChild("Vendors") and Workspace.Vendors:FindFirstChild("Blox Fruit Dealer")
    if bloxFruitDealer and bloxFruitDealer:FindFirstChild("HumanoidRootPart") then
        safeTeleport(bloxFruitDealer.HumanoidRootPart.Position)
        task.wait(0.1)
        local prompt = bloxFruitDealer:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        end
        local success, err = pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
        end)
        if success then
            sendWebhook("Spinning for a new fruit")
        else
            sendWebhook("Failed to spin fruit: " .. tostring(err))
        end
        task.wait(0.1)
    end
end

local function autoDetectRareSpawns()
    local rareSpawns = {"Mirage Island", "Leviathan", "TerrorShark", "Cursed Captain", "Longma"}
    for _, spawn in ipairs(rareSpawns) do
        local entity = Workspace:FindFirstChild(spawn) or (Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild(spawn))
        if entity and entity:FindFirstChild("HumanoidRootPart") then
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
            local success, err = pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("DropFruit", item.Name)
            end)
            if success then
                sendWebhook("Dropped junk item: " .. item.Name)
            else
                sendWebhook("Failed to drop item: " .. tostring(err))
            end
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
        if tradeNPC and tradeNPC:FindFirstChild("HumanoidRootPart") then
            safeTeleport(tradeNPC.HumanoidRootPart.Position)
            task.wait(0.1)
            local prompt = tradeNPC:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            local success, err = pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("TradeFruit", bestFruit.Name)
            end)
            if success then
                sendWebhook("Trading " .. bestFruit.Name .. " for " .. bestValue * 1000 .. " Beli")
            else
                sendWebhook("Failed to trade fruit: " .. tostring(err))
            end
            task.wait(0.1)
        end
    end
end

local function autoMiragePuzzles()
    local mirage = Workspace:FindFirstChild("Mirage Island")
    if mirage and mirage:FindFirstChild("HumanoidRootPart") then
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
        local success, err = pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AwakeningExpert", "MirrorFractal")
        end)
        if not success then
            sendWebhook("Failed Mirror Fractal quest: " .. tostring(err))
        end
        task.wait(0.1)
    else
        sendWebhook("Mirage Island not found. Server hopping...")
        if Toggles.ServerHop then
            local success, err = pcall(function()
                TeleportService:Teleport(game.PlaceId)
            end)
            if not success then
                sendWebhook("Server hop failed: " .. tostring(err))
            end
        end
    end
end

local function autoSeaBeast()
    local seaEvents = Workspace:FindFirstChild("SeaEvents")
    if seaEvents then
        for _, event in ipairs(seaEvents:GetChildren()) do
            if event.Name == "Sea Beast" and event:FindFirstChild("HumanoidRootPart") then
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
    if not addLog then
        warn("Warning: addLog is nil, using fallback logging")
        addLog = function(message) print("[UltraOmniHub Log] " .. message) end
    end
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
                local success, err = pcall(function()
                    TeleportService:Teleport(game.PlaceId)
                end)
                if not success then
                    addLog("Server hop failed: " .. tostring(err))
                    sendWebhook("Server hop failed: " .. tostring(err))
                end
            end
            task.wait(1)
        end
    end)

    -- Main Feature Loop
    while true do
        local function safeSpawn(func, name)
            local success, err = pcall(function()
                task.spawn(func)
            end)
            if not success then
                addLog("Error in " .. name .. ": " .. tostring(err))
                sendWebhook("Error in " .. name .. ": " .. tostring(err))
            end
        end

        if Toggles.AutoFarm then
            safeSpawn(autoFarm, "AutoFarm")
        end

        if Toggles.AutoBoss then
            safeSpawn(autoBoss, "AutoBoss")
        end

        if Toggles.AutoRaid then
            safeSpawn(autoRaid, "AutoRaid")
        end

        if Toggles.AutoQuest then
            safeSpawn(autoQuest, "AutoQuest")
        end

        if Toggles.AutoFruit then
            safeSpawn(collectFruits, "AutoFruit")
        end

        if Toggles.AutoStat then
            safeSpawn(autoStat, "AutoStat")
        end

        if Toggles.FastAttack then
            safeSpawn(function()
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
                if tool then
                    for _ = 1, 15 do
                        tool:Activate()
                        task.wait(0.01)
                    end
                end
            end, "FastAttack")
        end

        if Toggles.ESP then
            safeSpawn(esp, "ESP")
            safeSpawn(fruitNotifier, "FruitNotifier")
        end

        if Toggles.AutoGear then
            safeSpawn(autoGear, "AutoGear")
        end

        if Toggles.MasteryFarm then
            safeSpawn(masteryFarm, "MasteryFarm")
        end

        if Toggles.AutoHaki then
            safeSpawn(autoHaki, "AutoHaki")
        end

        if Toggles.AutoSecondSea then
            safeSpawn(autoSecondSea, "AutoSecondSea")
        end

        if Toggles.AutoThirdSea then
            safeSpawn(autoThirdSea, "AutoThirdSea")
        end

        if Toggles.AutoLegendarySword then
            safeSpawn(autoLegendarySword, "AutoLegendarySword")
        end

        if Toggles.AutoRaceV3 then
            safeSpawn(autoRaceV3, "AutoRaceV3")
        end

        if Toggles.AutoRaceV4 then
            safeSpawn(autoRaceV4, "AutoRaceV4")
        end

        if Toggles.ChestFarm then
            safeSpawn(chestFarm, "ChestFarm")
        end

        if Toggles.AutoEvent then
            safeSpawn(autoEvent, "AutoEvent")
        end

        if Toggles.AutoAwaken then
            safeSpawn(autoAwaken, "AutoAwaken")
        end

        if Toggles.AutoTerrorShark then
            safeSpawn(autoTerrorShark, "AutoTerrorShark")
        end

        if Toggles.AutoMirageIsland then
            safeSpawn(autoMirageIsland, "AutoMirageIsland")
        end

        if Toggles.AutoLeviathan then
            safeSpawn(autoLeviathan, "AutoLeviathan")
        end

        if Toggles.AutoFragment then
            safeSpawn(autoFragment, "AutoFragment")
        end

        if Toggles.AutoSaber then
            safeSpawn(autoSaber, "AutoSaber")
        end

        if Toggles.AutoPole then
            safeSpawn(autoPole, "AutoPole")
        end

        if Toggles.AutoTushita then
            safeSpawn(autoTushita, "AutoTushita")
        end

        if Toggles.AutoElectricClaw then
            safeSpawn(autoElectricClaw, "AutoElectricClaw")
        end

        if Toggles.AutoDragonTalon then
            safeSpawn(autoDragonTalon, "AutoDragonTalon")
        end

        if Toggles.AutoGodhuman then
            safeSpawn(autoGodhuman, "AutoGodhuman")
        end

        if Toggles.AutoStoreFruits then
            safeSpawn(autoStoreFruits, "AutoStoreFruits")
        end

        if Toggles.AutoEquipBestGear then
            safeSpawn(autoEquipBestGear, "AutoEquipBestGear")
        end

        if Toggles.AutoJoinCrew then
            safeSpawn(autoJoinCrew, "AutoJoinCrew")
        end

        if Toggles.AutoServerBoost then
            safeSpawn(autoServerBoost, "AutoServerBoost")
        end

        if Toggles.AutoElitePirates then
            safeSpawn(autoElitePirates, "AutoElitePirates")
        end

        if Toggles.AutoCursedDualKatana then
            safeSpawn(autoCursedDualKatana, "AutoCursedDualKatana")
        end

        if Toggles.AutoSharkmanKarate then
            safeSpawn(autoSharkmanKarate, "AutoSharkmanKarate")
        end

        if Toggles.AutoDarkStep then
            safeSpawn(autoDarkStep, "AutoDarkStep")
        end

        if Toggles.AutoBuyBoats then
            safeSpawn(autoBuyBoats, "AutoBuyBoats")
        end

        if Toggles.AutoSpinFruit then
            safeSpawn(autoSpinFruit, "AutoSpinFruit")
        end

        if Toggles.AutoDetectRareSpawns then
            safeSpawn(autoDetectRareSpawns, "AutoDetectRareSpawns")
        end

        if Toggles.AutoOptimizeInventory then
            safeSpawn(autoOptimizeInventory, "AutoOptimizeInventory")
        end

        if Toggles.AutoTradeOptimizer then
            safeSpawn(autoTradeOptimizer, "AutoTradeOptimizer")
        end

        if Toggles.AutoMiragePuzzles then
            safeSpawn(autoMiragePuzzles, "AutoMiragePuzzles")
        end

        if Toggles.AutoSeaBeast then
            safeSpawn(autoSeaBeast, "AutoSeaBeast")
        end

        if Toggles.AutoCompleteQuests then
            safeSpawn(autoCompleteQuests, "AutoCompleteQuests")
        end

        if Toggles.AutoFarmDrops then
            safeSpawn(autoFarmDrops, "AutoFarmDrops")
        end

        if Toggles.AutoSuperhuman then
            safeSpawn(autoSuperhuman, "AutoSuperhuman")
        end

        if Toggles.AutoServerRank then
            safeSpawn(autoServerRank, "AutoServerRank")
        end

        if Toggles.AutoBartilo then
            safeSpawn(autoBartilo, "AutoBartilo")
        end

        if Toggles.AutoV2FightingStyles then
            safeSpawn(autoV2FightingStyles, "AutoV2FightingStyles")
        end

        if Toggles.AutoSeaEvents then
            safeSpawn(autoSeaEvents, "AutoSeaEvents")
        end

        if Toggles.AutoBuyHakiColors then
            safeSpawn(autoBuyHakiColors, "AutoBuyHakiColors")
        end

        -- Memory cleanup
        safeSpawn(cleanUp, "CleanUp")

        -- Error handling
        local success, err = pcall(function()
            task.wait(0.1)
        end)
        if not success then
            addLog("Main loop error: " .. tostring(err))
            sendWebhook("Main loop error: " .. tostring(err))
            task.wait(1) -- Prevent crash loop
        end
    end
end

-- Initialize
local success, err = pcall(main)
if not success then
    local fallbackLog = function(message) print("[UltraOmniHub Fallback] " .. message) end
    fallbackLog("Initialization failed: " .. tostring(err))
    sendWebhook("Initialization failed: " .. tostring(err))
    task.wait(5)
    pcall(main) -- Retry
end

-- Character reset handling
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
    local fallbackLog = function(message) print("[UltraOmniHub Fallback] " .. message) end
    addLog = addLog or fallbackLog
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

local fallbackLog = function(message) print("[UltraOmniHub Fallback] " .. message) end
addLog = addLog or fallbackLog
addLog("Ultra OmniHub initialized successfully!")
sendWebhook("Ultra OmniHub initialized successfully!")

-- Disconnect handling
game:BindToClose(function()
    cleanUp()
    sendWebhook("Script terminated. Cleaning up resources.")
end)

local fallbackLog = function(message) print("[UltraOmniHub Fallback] " .. message) end
addLog = addLog or fallbackLog
addLog("Ultra OmniHub initialized successfully!")
sendWebhook("Ultra OmniHub initialized successfully!")

-- Version Check
local SCRIPT_VERSION = "1.2.0"
task.spawn(function()
    local success, response = pcall(function()
        return HttpService:GetAsync("https://raw.githubusercontent.com/UltraOmniHub/BloxFruits/main/version.txt")
    end)
    if success and response then
        local latestVersion = response:match("%S+")
        if latestVersion ~= SCRIPT_VERSION then
            addLog("New version available: " .. latestVersion .. ". Current: " .. SCRIPT_VERSION)
            sendWebhook("New version available: " .. latestVersion .. ". Update at https://github.com/UltraOmniHub/BloxFruits")
        end
    else
        addLog("Failed to check for updates: " .. tostring(response))
        sendWebhook("Failed to check for updates: " .. tostring(response))
    end
end)

-- Performance Reporting
task.spawn(function()
    local startTime = os.time()
    while true do
        task.wait(3600) -- Report every hour
        local uptime = os.time() - startTime
        local memoryUsage = collectgarbage("count") / 1024 -- MB
        local fps = getFPS()
        local ping = getPing()
        local report = string.format(
            "Performance Report: Uptime: %d hours, Memory: %.2f MB, FPS: %d, Ping: %dms",
            uptime / 3600, memoryUsage, fps, ping
        )
        addLog(report)
        sendWebhook(report)
    end
end)

-- Usage Instructions and Credits
--[[
Ultra Blox Fruits OmniHub (Update 24)
- Features: Auto-farm, auto-boss, auto-raid, fruit sniper, ESP, auto-stats, auto-quests, auto-drops, auto-superhuman, auto-server rank, auto-trade, auto-Mirage puzzles, and more.
- Usage: Run in a private server for best results. Toggle features via UI (F4 key). Set WEBHOOK_URL for logging.
- Compatibility: Synapse X, Delta, Arceus X, Codex, Fluxus.
- Safety: Randomized teleports (300–600), delays (0.05–0.15s), pathfinding, and humanized inputs.
- Credits: Inspired by Quantum Hub, Redz Hub, Hoho Hub, Raito Hub, KaitunConfig. Data from blox-fruits.fandom.com.
- Warning: Use responsibly to comply with Roblox TOS.
--]]
