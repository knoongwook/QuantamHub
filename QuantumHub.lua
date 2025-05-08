-- Enhanced Blox Fruits GUI Script
-- Educational example with UI, mock status displays, and placeholders
-- Compatible with mobile and PC, no exploitative features
-- Updated with public asset IDs to avoid "user not authorized" error

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Wait for game to load
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Global settings for feature toggles
_G.BloxSettings = {
    AutoFarmLevel = false, AutoFarmBoss = false, FruitSniper = false, IslandTeleport = false,
    AutoRaceV4 = false, AutoMirageIsland = false, AdvancedESP = false, AutoDodge = false,
    BossStatus = true, MoonStatus = true, RaceV4Status = true, AntiAFK = true,
    LagReducer = false, DynamicGUIThemes = false
}

-- Mock data for status displays
local function GetMockSea()
    return math.random(1, 3) -- Simulate Sea 1, 2, or 3
end

local function UpdateMockBossStatus()
    local sea = GetMockSea()
    local bosses = {"Tide Keeper", "Leviathan", "Captain Elephant"}
    if math.random(1, 2) == 1 then
        return "Boss: " .. bosses[math.random(1, #bosses)] .. " (Sea " .. sea .. ")"
    else
        return "Boss: None (Sea " .. sea .. ")"
    end
end

local function GetMockMoonStatus()
    local phases = {"Full Moon", "Waxing Crescent", "Waxing Gibbous", "Waning Gibbous"}
    local phase = phases[math.random(1, #phases)]
    local timeToFull = math.random(0, 24) .. ":" .. string.format("%02d", math.random(0, 59))
    return "Moon: " .. phase .. " (Full in " .. timeToFull .. ")"
end

local function GetMockRaceV4Status()
    local gears = {"Red", "Blue", "Green"}
    local status = {
        trainingSessions = math.random(0, 10),
        activationTime = math.random(0, 120) .. " mins",
        gears = {
            second = gears[math.random(1, #gears)],
            third = gears[math.random(1, #gears)],
            fourth = gears[math.random(1, #gears)]
        }
    }
    return "V4: " .. status.trainingSessions .. " sessions, " .. status.activationTime .. ", Gears: 2nd " .. status.gears.second .. ", 3rd " .. status.gears.third .. ", 4th " .. status.gears.fourth
end

-- Notification System
local function ShowNotification(message, duration)
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Parent = PlayerGui
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.3, 0, 0.1, 0)
    Frame.Position = UDim2.new(0.35, 0, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Parent = NotificationGui
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Text = message
    Text.TextColor3 = Color3.fromRGB(0, 255, 127)
    Text.TextSize = 16
    Text.Font = Enum.Font.Gotham
    Text.TextWrapped = true
    Text.Parent = Frame
    task.spawn(function()
        task.wait(duration or 3)
        NotificationGui:Destroy()
    end)
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsEnhancedGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Text = "QuantumHub V5 (Educational)"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0.2, 0, 0.8, 0)
Sidebar.Position = UDim2.new(0, 0, 0.1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
local ScrollSidebar = Instance.new("ScrollingFrame")
ScrollSidebar.Size = UDim2.new(1, 0, 1, 0)
ScrollSidebar.BackgroundTransparency = 1
ScrollSidebar.ScrollBarThickness = 6
ScrollSidebar.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 127)
ScrollSidebar.Parent = Sidebar

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(0.78, 0, 0.8, 0)
Content.Position = UDim2.new(0.22, 0, 0.1, 0)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Content.BorderSizePixel = 0
Content.Parent = MainFrame
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = Content
local ScrollContent = Instance.new("ScrollingFrame")
ScrollContent.Size = UDim2.new(1, -10, 1, -10)
ScrollContent.Position = UDim2.new(0, 5, 0, 5)
ScrollContent.BackgroundTransparency = 1
ScrollContent.ScrollBarThickness = 6
ScrollContent.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 127)
ScrollContent.Parent = Content

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.TextSize = 16
MinimizeButton.Parent = MainFrame
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = MinimizeButton

-- Collapse Button
local CollapseButton = Instance.new("TextButton")
CollapseButton.Size = UDim2.new(0, 20, 0, 40)
CollapseButton.Position = UDim2.new(0.2, -20, 0.35, 0)
CollapseButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CollapseButton.Text = ">"
CollapseButton.TextColor3 = Color3.fromRGB(0, 255, 127)
CollapseButton.Font = Enum.Font.Gotham
CollapseButton.TextSize = 16
CollapseButton.Parent = MainFrame
local CollapseCorner = Instance.new("UICorner")
CollapseCorner.CornerRadius = UDim.new(0, 6)
CollapseCorner.Parent = CollapseButton

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0.1, 0)
StatusBar.Position = UDim2.new(0, 0, 0.9, 0)
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatusBar.Parent = MainFrame
local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 12)
StatusCorner.Parent = StatusBar

local BossStatus = Instance.new("TextLabel")
BossStatus.Size = UDim2.new(0.33, 0, 1, 0)
BossStatus.Text = "Boss: Loading..."
BossStatus.TextColor3 = Color3.fromRGB(0, 255, 127)
BossStatus.BackgroundTransparency = 1
BossStatus.Font = Enum.Font.Gotham
BossStatus.TextSize = 14
BossStatus.Parent = StatusBar

local MoonStatus = Instance.new("TextLabel")
MoonStatus.Size = UDim2.new(0.33, 0, 1, 0)
MoonStatus.Position = UDim2.new(0.33, 0, 0, 0)
MoonStatus.Text = "Moon: Loading..."
MoonStatus.TextColor3 = Color3.fromRGB(0, 255, 127)
MoonStatus.BackgroundTransparency = 1
MoonStatus.Font = Enum.Font.Gotham
MoonStatus.TextSize = 14
MoonStatus.Parent = StatusBar

local RaceV4Status = Instance.new("TextLabel")
RaceV4Status.Size = UDim2.new(0.34, 0, 1, 0)
RaceV4Status.Position = UDim2.new(0.66, 0, 0, 0)
RaceV4Status.Text = "V4: Loading..."
RaceV4Status.TextColor3 = Color3.fromRGB(0, 255, 127)
RaceV4Status.BackgroundTransparency = 1
RaceV4Status.Font = Enum.Font.Gotham
RaceV4Status.TextSize = 14
RaceV4Status.Parent = StatusBar

-- Categories and Features
local Categories = {
    {Name = "Farming", Icon = "rbxassetid://10734949875", Options = {
        {"Auto Farm Level", "AutoFarmLevel"},
        {"Auto Farm Boss", "AutoFarmBoss"}
    }},
    {Name = "Fruits", Icon = "rbxassetid://10734950359", Options = {
        {"Fruit Sniper", "FruitSniper"},
        {"Teleport to Fruit", "TeleportToFruit"}
    }},
    {Name = "Upgrades", Icon = "rbxassetid://10734950834", Options = {
        {"Auto Race V4", "AutoRaceV4"},
        {"Auto Mirage Island", "AutoMirageIsland"}
    }},
    {Name = "Combat", Icon = "rbxassetid://10734949875", Options = {
        {"Advanced ESP", "AdvancedESP"},
        {"Auto Dodge", "AutoDodge"}
    }},
    {Name = "Status", Icon = "rbxassetid://10734950359", Options = {
        {"Boss Status", "BossStatus"},
        {"Moon Status", "MoonStatus"},
        {"Race V4 Status", "RaceV4Status"}
    }},
    {Name = "Settings", Icon = "rbxassetid://10734950834", Options = {
        {"Anti AFK", "AntiAFK"},
        {"Lag Reducer", "LagReducer"},
        {"Dynamic GUI Themes", "DynamicGUIThemes"}
    }}
}

local CurrentCategory = nil
local CategoryButtons = {}
local ContentFrames = {}

-- Populate Sidebar and Content
for i, category in ipairs(Categories) do
    -- Sidebar Button
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Position = UDim2.new(0.05, 0, 0, (i-1) * 45)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.Text = ""
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(0.1, 0, 0.5, -10)
    Icon.Image = category.Icon
    Icon.ImageColor3 = Color3.fromRGB(0, 255, 127)
    Icon.Parent = Button
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.7, 0, 1, 0)
    Text.Position = UDim2.new(0.3, 0, 0, 0)
    Text.Text = category.Name
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.Gotham
    Text.TextSize = 14
    Text.Parent = Button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    Button.Parent = ScrollSidebar
    CategoryButtons[category.Name] = Button

    -- Content Frame
    local ContentFrame = Instance.new("Frame")
LOOP
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.Parent = ScrollContent
    ContentFrames[category.Name] = ContentFrame

    -- Populate Features
    local y = 0
    for _, option in ipairs(category.Options) do
        local FeatureFrame = Instance.new("Frame")
        FeatureFrame.Size = UDim2.new(1, 0, 0, 35)
        FeatureFrame.Position = UDim2.new(0, 0, 0, y)
        FeatureFrame.BackgroundTransparency = 1
        FeatureFrame.Parent = ContentFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Text = option[1]
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Parent = FeatureFrame

        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0.2, 0, 0.8, 0)
        Toggle.Position = UDim2.new(0.75, 0, 0.1, 0)
        Toggle.BackgroundColor3 = _G.BloxSettings[option[2]] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        Toggle.Text = _G.BloxSettings[option[2]] and "ON" or "OFF"
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 12
        Toggle.Parent = FeatureFrame
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = Toggle

        Toggle.MouseButton1Click:Connect(function()
            _G.BloxSettings[option[2]] = not _G.BloxSettings[option[2]]
            Toggle.Text = _G.BloxSettings[option[2]] and "ON" or "OFF"
            Toggle.BackgroundColor3 = _G.BloxSettings[option[2]] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
            ShowNotification(option[1] .. " " .. (_G.BloxSettings[option[2]] and "ON" or "OFF"), 2)
            if option[2]:find("Status") then
                -- Update status visibility
                if option[2] == "BossStatus" then
                    BossStatus.Visible = _G.BloxSettings.BossStatus
                elseif option[2] == "MoonStatus" then
                    MoonStatus.Visible = _G.BloxSettings.MoonStatus
                elseif option[2] == "RaceV4Status" then
                    RaceV4Status.Visible = _G.BloxSettings.RaceV4Status
                end
            else
                print("Placeholder: " .. option[1] .. " toggled " .. (_G.BloxSettings[option[2]] and "ON" or "OFF"))
            end
        end)

        y = y + 40
    end
    ContentFrame.Size = UDim2.new(1, 0, 0, y)
    ScrollContent.CanvasSize = UDim2.new(0, 0, 0, y)
end
ScrollSidebar.CanvasSize = UDim2.new(0, 0, 0, #Categories * 45)

-- Category Switching
for category, button in pairs(CategoryButtons) do
    button.MouseButton1Click:Connect(function()
        if CurrentCategory then
            ContentFrames[CurrentCategory].Visible = false
            CategoryButtons[CurrentCategory].BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
        ContentFrames[category].Visible = true
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        CurrentCategory = category
    end)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    button.MouseLeave:Connect(function()
        if CurrentCategory ~= category then
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
    end)
end

-- Minimize Functionality
local Minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    MainFrame.Visible = not Minimized
    MinimizeButton.Text = Minimized and "+" or "-"
    if Minimized then
        MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
        MinimizeButton.Parent = ScreenGui
    else
        MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
        MinimizeButton.Parent = MainFrame
    end
end)

-- Collapse Functionality
local isCollapsed = false
CollapseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    CollapseButton.Text = isCollapsed and "<" or ">"
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local sidebarGoal = {Size = UDim2.new(isCollapsed and 0 or 0.2, 0, 0.8, 0)}
    local contentGoal = {Position = UDim2.new(isCollapsed and 0.02 or 0.22, 0, 0.1, 0), Size = UDim2.new(isCollapsed and 0.96 or 0.78, 0, 0.8, 0)}
    TweenService:Create(Sidebar, tweenInfo, sidebarGoal):Play()
    TweenService:Create(Content, tweenInfo, contentGoal):Play()
end)

-- Smooth Dragging for Mobile/PC
local Dragging = false
local DragStart = nil
local StartPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

-- Mobile Touch Swipe Support
local touchStart = nil
UserInputService.TouchStarted:Connect(function(input)
    touchStart = input.Position
end)

UserInputService.TouchEnded:Connect(function(input)
    if touchStart then
        local delta = (input.Position - touchStart).Magnitude
        if delta > 50 then
            if math.abs(input.Position.X - touchStart.X) > math.abs(input.Position.Y - touchStart.Y) then
                isCollapsed = input.Position.X < touchStart.X
                CollapseButton.Text = isCollapsed and "<" or ">"
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local sidebarGoal = {Size = UDim2.new(isCollapsed and 0 or 0.2, 0, 0.8, 0)}
                local contentGoal = {Position = UDim2.new(isCollapsed and 0.02 or 0.22, 0, 0.1, 0), Size = UDim2.new(isCollapsed and 0.96 or 0.78, 0, 0.8, 0)}
                TweenService:Create(Sidebar, tweenInfo, sidebarGoal):Play()
                TweenService:Create(Content, tweenInfo, contentGoal):Play()
            end
        end
    end
    touchStart = nil
end)

-- Status Updates
RunService.RenderStepped:Connect(function()
    if _G.BloxSettings.BossStatus then
        BossStatus.Text = UpdateMockBossStatus()
    end
    if _G.BloxSettings.MoonStatus then
        MoonStatus.Text = GetMockMoonStatus()
    end
    if _G.BloxSettings.RaceV4Status then
        RaceV4Status.Text = GetMockRaceV4Status()
    end
end)

-- Anti-AFK
local function AntiAFK()
    while _G.BloxSettings.AntiAFK do
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:SetKeyDown(Enum.KeyCode.W)
        task.wait(0.1)
        VirtualUser:SetKeyUp(Enum.KeyCode.W)
        task.wait(60)
    end
end
if _G.BloxSettings.AntiAFK then
    task.spawn(AntiAFK)
end

-- Lag Reducer
local function LagReducer()
    while _G.BloxSettings.LagReducer do
        game:GetService("Lighting").GlobalShadows = false
        RunService:Set3dRenderingEnabled(false)
        task.wait(5)
    end
    game:GetService("Lighting").GlobalShadows = true
    RunService:Set3dRenderingEnabled(true)
end
if _G.BloxSettings.LagReducer then
    task.spawn(LagReducer)
end

-- Dynamic GUI Themes
local Themes = {
    Dark = {Background = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(0, 255, 127), Text = Color3.fromRGB(255, 255, 255)},
    Light = {Background = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(0, 128, 255), Text = Color3.fromRGB(0, 0, 0)}
}
local CurrentTheme = Themes.Dark
local function UpdateTheme()
    while _G.BloxSettings.DynamicGUIThemes do
        CurrentTheme = Themes[math.random(1, 2) == 1 and "Dark" or "Light"]
        MainFrame.BackgroundColor Gunn = CurrentTheme.Background
        Sidebar.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(10, 10, 10), 0.2)
        Content.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(5, 5, 5), 0.1)
        StatusBar.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(15, 15, 15), 0.3)
        Title.TextColor3 = CurrentTheme.Accent
        BossStatus.TextColor3 = CurrentTheme.Accent
        MoonStatus.TextColor3 = CurrentTheme.Accent
        RaceV4Status.TextColor3 = CurrentTheme.Accent
        CollapseButton.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(5, 5, 5), 0.1)
        CollapseButton.TextColor3 = CurrentTheme.Accent
        MinimizeButton.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(20, 20, 20), 0.2)
        MinimizeButton.TextColor3 = CurrentTheme.Text
        for _, child in pairs(ScrollSidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = CurrentTheme.Background:lerp(Color3.fromRGB(5, 5, 5), 0.1)
                for _, subChild in pairs(child:GetChildren()) do
                    if subChild:IsA("TextLabel") then
                        subChild.TextColor3 = CurrentTheme.Text
                    elseif subChild:IsA("ImageLabel") then
                        subChild.ImageColor3 = CurrentTheme.Accent
                    end
                end
            end
        end
        for _, child in pairs(ScrollContent:GetChildren()) do
            if child:IsA("Frame") then
                for _, feature in pairs(child:GetChildren()) do
                    if feature:IsA("Frame") then
                        for _, subChild in pairs(feature:GetChildren()) do
                            if subChild:IsA("TextLabel") then
                                subChild.TextColor3 = CurrentTheme.Text
                            elseif subChild:IsA("TextButton") then
                                subChild.TextColor3 = CurrentTheme.Text
                                subChild.BackgroundColor3 = _G.BloxSettings[subChild.Text == "ON" and subChild.Parent.Parent.Parent.Name or ""] and Color3.fromRGB(0, 255, 0) or CurrentTheme.Background:lerp(Color3.fromRGB(20, 20, 20), 0.2)
                            end
                        end
                    end
                end
            end
        end
        task.wait(30)
    end
end
if _G.BloxSettings.DynamicGUIThemes then
    task.spawn(UpdateTheme)
end

-- Initialize
CategoryButtons[Categories[1].Name].MouseButton1Click:Fire()
ShowNotification("QuantumHub V5 (Educational) Loaded Successfully!", 5)

print("Enhanced Blox Fruits GUI loaded successfully!")
