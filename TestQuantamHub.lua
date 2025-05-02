-- TestQuantumHub.lua
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.5, 0, 0.5, 0)
Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Parent = ScreenGui
local Text = Instance.new("TextLabel")
Text.Size = UDim2.new(1, 0, 1, 0)
Text.BackgroundTransparency = 1
Text.Text = "QuantumHub Loaded!"
Text.TextColor3 = Color3.fromRGB(0, 255, 127)
Text.TextSize = 20
Text.Parent = Frame
