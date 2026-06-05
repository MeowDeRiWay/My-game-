local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Modules = script.Parent:WaitForChild("InventoryModules")

local InventoryUI = require(Modules:WaitForChild("InventoryUI"))
local PlacementPreview = require(Modules:WaitForChild("PlacementPreview"))
local WorldInteraction = require(Modules:WaitForChild("WorldInteraction"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local InventoryUpdate = Remotes:WaitForChild("InventoryUpdate")

local inventory = {
	["Рука"] = 1,
	["Ломака"] = 0,
}

local activeItem = "Рука"
local inventoryOpen = false
local combatMode = false

local ui = InventoryUI.Create(player)

local preview = PlacementPreview.Create({
	Mouse = mouse,
})

local interaction = WorldInteraction.Create({
	Mouse = mouse,
	Preview = preview,
})

local function setActiveItem(itemName)
	activeItem = itemName
	ui.SetActiveItem(activeItem)
	preview.SetActiveItem(activeItem)
end

local function refreshInventory()
	if activeItem and ((inventory[activeItem] or 0) <= 0) then
		setActiveItem(nil)
	else
		ui.SetActiveItem(activeItem)
		preview.SetActiveItem(activeItem)
	end

	ui.RefreshInventory(inventory, function(itemName)
		setActiveItem(itemName)
	end)
end

InventoryUpdate.OnClientEvent:Connect(function(newInventory)
	inventory = newInventory or inventory
	refreshInventory()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.B then
		inventoryOpen = not inventoryOpen
		ui.SetInventoryVisible(inventoryOpen)
	end

	if input.KeyCode == Enum.KeyCode.Q then
		combatMode = not combatMode
		ui.SetCombatMode(combatMode)

		if combatMode then
			preview.Clear()
		else
			preview.SetActiveItem(activeItem)
		end
	end
end)

mouse.Button1Down:Connect(function()
	interaction.HandleClick(activeItem, combatMode)
end)

refreshInventory()