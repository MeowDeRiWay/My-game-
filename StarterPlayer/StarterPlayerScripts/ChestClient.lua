local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChestRequest = Remotes:WaitForChild("ChestRequest")

local currentChest = nil
local currentInventory = {}

local gui = Instance.new("ScreenGui")
gui.Name = "ChestGui"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 260)
frame.Position = UDim2.new(0.5, -180, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Примітивний сундук"
title.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.Parent = frame

local chestInfo = Instance.new("TextLabel")
chestInfo.Size = UDim2.new(1, -20, 0, 30)
chestInfo.Position = UDim2.new(0, 10, 0, 45)
chestInfo.BackgroundTransparency = 1
chestInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
chestInfo.Font = Enum.Font.SourceSans
chestInfo.TextSize = 18
chestInfo.TextXAlignment = Enum.TextXAlignment.Left
chestInfo.Text = "Порожньо: 0 / 50"
chestInfo.Parent = frame

local itemBox = Instance.new("TextBox")
itemBox.Size = UDim2.new(0, 220, 0, 30)
itemBox.Position = UDim2.new(0, 10, 0, 90)
itemBox.PlaceholderText = "Назва ресурсу"
itemBox.Text = ""
itemBox.Parent = frame

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(0, 100, 0, 30)
amountBox.Position = UDim2.new(0, 240, 0, 90)
amountBox.PlaceholderText = "К-сть"
amountBox.Text = "1"
amountBox.Parent = frame

local depositButton = Instance.new("TextButton")
depositButton.Size = UDim2.new(0, 160, 0, 35)
depositButton.Position = UDim2.new(0, 10, 0, 135)
depositButton.Text = "Покласти"
depositButton.Parent = frame

local withdrawButton = Instance.new("TextButton")
withdrawButton.Size = UDim2.new(0, 160, 0, 35)
withdrawButton.Position = UDim2.new(0, 180, 0, 135)
withdrawButton.Text = "Забрати"
withdrawButton.Parent = frame

local inventoryText = Instance.new("TextLabel")
inventoryText.Size = UDim2.new(1, -20, 0, 70)
inventoryText.Position = UDim2.new(0, 10, 0, 180)
inventoryText.BackgroundTransparency = 1
inventoryText.TextColor3 = Color3.fromRGB(220, 220, 220)
inventoryText.Font = Enum.Font.SourceSans
inventoryText.TextSize = 16
inventoryText.TextXAlignment = Enum.TextXAlignment.Left
inventoryText.TextYAlignment = Enum.TextYAlignment.Top
inventoryText.TextWrapped = true
inventoryText.Text = ""
inventoryText.Parent = frame

local function refreshInventoryText()
	local lines = {}

	for itemName, amount in pairs(currentInventory or {}) do
		if amount > 0 then
			table.insert(lines, itemName .. ": " .. amount)
		end
	end

	inventoryText.Text = "Інвентар:\n" .. table.concat(lines, "\n")
end

closeButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
	currentChest = nil
end)

depositButton.MouseButton1Click:Connect(function()
	if not currentChest then return end

	ChestRequest:FireServer("Deposit", {
		Chest = currentChest,
		ItemName = itemBox.Text,
		Amount = tonumber(amountBox.Text) or 1,
	})
end)

withdrawButton.MouseButton1Click:Connect(function()
	if not currentChest then return end

	ChestRequest:FireServer("Withdraw", {
		Chest = currentChest,
		Amount = tonumber(amountBox.Text) or 1,
	})
end)

ChestRequest.OnClientEvent:Connect(function(action, data)
	if action == "Open" then
		currentChest = data.Chest
		currentInventory = data.Inventory or {}

		gui.Enabled = true

		local storedItem = data.StoredItem
		local storedAmount = data.StoredAmount or 0
		local capacity = data.Capacity or 50

		if storedItem then
			chestInfo.Text = storedItem .. ": " .. storedAmount .. " / " .. capacity
			itemBox.Text = storedItem
		else
			chestInfo.Text = "Порожньо: 0 / " .. capacity
		end

		refreshInventoryText()
		return
	end

	if action == "Error" then
		warn(data)
		return
	end
end)