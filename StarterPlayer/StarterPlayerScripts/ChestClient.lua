local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChestRequest = Remotes:WaitForChild("ChestRequest")

local ChestUI = require(script:WaitForChild("ChestUI"))

local currentChest = nil

local ui = ChestUI.new(player, {
	OnClose = function()
		currentChest = nil
	end,

	OnDeposit = function(itemName, amount)
		if not currentChest then return end

		ChestRequest:FireServer("Deposit", {
			Chest = currentChest,
			ItemName = itemName,
			Amount = amount,
		})
	end,

	OnWithdraw = function(amount)
		if not currentChest then return end

		ChestRequest:FireServer("Withdraw", {
			Chest = currentChest,
			Amount = amount,
		})
	end,
})

ChestRequest.OnClientEvent:Connect(function(action, data)
	if action == "Open" then
		currentChest = data.Chest

		ui:SetData({
			Inventory = data.Inventory or {},
			StoredItem = data.StoredItem,
			StoredAmount = data.StoredAmount or 0,
			Capacity = data.Capacity or 50,
		})

		ui:Open()
		return
	end

	if action == "Error" then
		warn(data)
		return
	end
end)