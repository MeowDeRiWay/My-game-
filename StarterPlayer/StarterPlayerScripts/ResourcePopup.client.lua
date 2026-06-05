local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ResourcePopupEvent = Remotes:WaitForChild("ResourcePopupEvent")

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ResourcePopupGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local holder = Instance.new("Frame")
holder.Name = "PopupHolder"
holder.AnchorPoint = Vector2.new(0, 0.5)
holder.Position = UDim2.new(0, 20, 0.5, 0)
holder.Size = UDim2.new(0, 350, 0, 300)
holder.BackgroundTransparency = 1
holder.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Parent = holder

local function showPopup(text)
	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(1, 0, 0, 32)
	label.BackgroundTransparency = 1

	label.Font = Enum.Font.GothamBold
	label.TextSize = 22

	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center

	label.TextColor3 = Color3.fromRGB(120, 255, 120)
	label.TextStrokeTransparency = 0.3

	label.TextTransparency = 1
	label.Text = "" .. tostring(text)

	label.Parent = holder

	local fadeIn = TweenService:Create(
		label,
		TweenInfo.new(0.15),
		{
			TextTransparency = 0
		}
	)

	local fadeOut = TweenService:Create(
		label,
		TweenInfo.new(0.4),
		{
			TextTransparency = 1
		}
	)

	fadeIn:Play()

	task.delay(1.5, function()
		if not label.Parent then
			return
		end

		fadeOut:Play()
		fadeOut.Completed:Wait()

		if label.Parent then
			label:Destroy()
		end
	end)
end

ResourcePopupEvent.OnClientEvent:Connect(showPopup)