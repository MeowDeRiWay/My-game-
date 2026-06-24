local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlayerStatsUpdate = Remotes:WaitForChild("PlayerStatsUpdate")
local SprintStateRequest = Remotes:WaitForChild("SprintStateRequest")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerStatsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local function createBar(name, positionY, labelText)
	local container = Instance.new("Frame")
	container.Name = name
	container.Size = UDim2.new(0, 220, 0, 24)
	container.Position = UDim2.new(0, 20, 0, positionY)
	container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	container.BorderSizePixel = 0
	container.Parent = screenGui

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(1, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
	fill.BorderSizePixel = 0
	fill.Parent = container

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextStrokeTransparency = 0.5
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 16
	label.Text = labelText
	label.Parent = container

	return {
		Container = container,
		Fill = fill,
		Label = label,
	}
end

local healthBar = createBar("HealthBar", 20, "ХП")
local staminaBar = createBar("StaminaBar", 50, "Витривалість")

healthBar.Fill.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
staminaBar.Fill.BackgroundColor3 = Color3.fromRGB(70, 120, 200)

local function updateBar(bar, current, maxValue, text)
	local percent = 0

	if maxValue > 0 then
		percent = math.clamp(current / maxValue, 0, 1)
	end

	bar.Fill.Size = UDim2.new(percent, 0, 1, 0)
	bar.Label.Text = text .. ": " .. tostring(current) .. " / " .. tostring(maxValue)
end

PlayerStatsUpdate.OnClientEvent:Connect(function(data)
	updateBar(healthBar, data.Health or 0, data.MaxHealth or 100, "ХП")
	updateBar(staminaBar, data.Stamina or 0, data.MaxStamina or 100, "Витривалість")
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		SprintStateRequest:FireServer(true)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		SprintStateRequest:FireServer(false)
	end
end)
