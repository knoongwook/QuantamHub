-- Loading_UI.lua
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.3, 0, 0.2, 0)
Frame.Position = UDim2.new(0.35, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Parent = ScreenGui
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame
local Text = Instance.new("TextLabel")
Text.Size = UDim2.new(1, 0, 0.8, 0)
Text.Position = UDim2.new(0, 0, 0.1, 0)
Text.BackgroundTransparency = 1
Text.Text = "Loading QuantumHub..."
Text.TextColor3 = Color3.fromRGB(0, 255, 127)
Text.TextSize = 20
Text.Font = Enum.Font.SourceSansBold
Text.TextWrapped = true
Text.Parent = Frame
task.wait(2) -- Display for 2 seconds
loadstring(game:HttpGet("https://raw.githubusercontent.com/knoongwook/QuantamHub/main/QuantumHub.lua"))()
ScreenGui:Destroy()
