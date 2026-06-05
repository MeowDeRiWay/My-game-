local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CraftingConfig = require(ReplicatedStorage:WaitForChild("CraftingConfig"))
local CraftingWindowBuilder = require(ReplicatedStorage:WaitForChild("CraftingWindowBuilder"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local InventoryUpdate = Remotes:WaitForChild("InventoryUpdate")
local BaseObjectRequest = Remotes:WaitForChild("BaseObjectRequest")

local player = Players.LocalPlayer
local craftRequest = ReplicatedStorage:WaitForChild("CraftRequest")

local craftingGuiController = CraftingWindowBuilder.Create(player, CraftingConfig, craftRequest)

BaseObjectRequest.OnClientEvent:Connect(function(action, stationType)
	if action == "OpenCrafting" then
		craftingGuiController.Open(stationType)
	end
end)

InventoryUpdate.OnClientEvent:Connect(function(inventory)
	craftingGuiController.UpdateInventory(inventory)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.C then
		if craftingGuiController.ScreenGui.Enabled then
			craftingGuiController.Close()
		else
			craftingGuiController.Open(nil)
		end
	end
end)