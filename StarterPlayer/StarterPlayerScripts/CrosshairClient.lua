local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local combatMode = false

local gui = Instance.new("ScreenGui")
gui.Name = "CombatCrosshairGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local crosshair = Instance.new("Frame")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.new(0, 34, 0, 34)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BackgroundTransparency = 1
crosshair.Visible = false
crosshair.Parent = gui

local function makeLine(name, size, position)
	local line = Instance.new("Frame")
	line.Name = name
	line.Size = size
	line.Position = position
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	line.BorderSizePixel = 0
	line.BackgroundTransparency = 0.1
	line.Parent = crosshair

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1
	stroke.Parent = line

	return line
end

makeLine("Top", UDim2.new(0, 2, 0, 9), UDim2.new(0.5, 0, 0, 4))
makeLine("Bottom", UDim2.new(0, 2, 0, 9), UDim2.new(0.5, 0, 1, -4))
makeLine("Left", UDim2.new(0, 9, 0, 2), UDim2.new(0, 4, 0.5, 0))
makeLine("Right", UDim2.new(0, 9, 0, 2), UDim2.new(1, -4, 0.5, 0))

local dot = Instance.new("Frame")
dot.Name = "Dot"
dot.Size = UDim2.new(0, 4, 0, 4)
dot.AnchorPoint = Vector2.new(0.5, 0.5)
dot.Position = UDim2.new(0.5, 0, 0.5, 0)
dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dot.BorderSizePixel = 0
dot.BackgroundTransparency = 0
dot.Parent = crosshair

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local dotStroke = Instance.new("UIStroke")
dotStroke.Color = Color3.fromRGB(0, 0, 0)
dotStroke.Thickness = 1
dotStroke.Parent = dot

local function setCombatMode(enabled)
	combatMode = enabled
	crosshair.Visible = combatMode
	UserInputService.MouseIconEnabled = not combatMode
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.Q then
		setCombatMode(not combatMode)
	end
end)

RunService.RenderStepped:Connect(function()
	if not combatMode then return end

	crosshair.Position = UDim2.fromOffset(mouse.X, mouse.Y)
end)
