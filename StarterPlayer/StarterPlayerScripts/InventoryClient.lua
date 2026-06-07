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

local inventory = {}
local activeItem = "Рука"
local activeAmmo = nil
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

local refreshInventory

local function updateActiveItemModel(itemName)
	if itemName == "Грубий дерев'яний інструмент" then
		player:SetAttribute("ActiveItemClass", "OneHandedClose")
		player:SetAttribute("ActiveItemModel", "RoughWoodenToolModel")
	elseif itemName == "Знаряддя праці" then
		player:SetAttribute("ActiveItemClass", "OneHandedClose")
		player:SetAttribute("ActiveItemModel", "MasterToolModel")
	elseif itemName == "Заточена палка" then
		player:SetAttribute("ActiveItemClass", "TwoHandedClose")
		player:SetAttribute("ActiveItemModel", "RoughtSpearModel")
	else
		player:SetAttribute("ActiveItemClass", nil)
		player:SetAttribute("ActiveItemModel", nil)
	end
end

local function setActiveItem(itemName)
	activeItem = itemName

	local config = itemName and require(ReplicatedStorage:WaitForChild("ItemConfig"))[itemName]

	player:SetAttribute("ActiveItemName", activeItem)

	if config then
		player:SetAttribute("ActiveItemClass", config.ToolClass or config.Type)
		player:SetAttribute("ActiveItemModel", config.ModelName)
	else
		player:SetAttribute("ActiveItemClass", nil)
		player:SetAttribute("ActiveItemModel", nil)
	end

	ui.SetActiveItem(activeItem)
	preview.SetActiveItem(activeItem)
end

local function setActiveAmmo(itemName)
	activeAmmo = itemName
	player:SetAttribute("ActiveAmmoName", activeAmmo)

	if ui.SetActiveAmmo then
		ui.SetActiveAmmo(activeAmmo)
	end
end

refreshInventory = function()
	if activeItem and ((inventory[activeItem] or 0) <= 0) then
		activeItem = nil
		ui.SetActiveItem(nil)
		preview.SetActiveItem(nil)
	else
		ui.SetActiveItem(activeItem)
		preview.SetActiveItem(activeItem)
	end

	ui.RefreshInventory(inventory, function(itemName)
		local config = require(ReplicatedStorage:WaitForChild("ItemConfig"))[itemName]

		if config and config.Type == "Ammo" then
			setActiveAmmo(itemName)
		else
			setActiveItem(itemName)
		end
	end)
end

InventoryUpdate.OnClientEvent:Connect(function(newInventory)
	inventory = newInventory or {}

	if not activeItem or (inventory[activeItem] or 0) <= 0 then
		if (inventory["Рука"] or 0) > 0 then
			activeItem = "Рука"
		else
			activeItem = nil
		end
	end

	ui.SetActiveItem(activeItem)
	preview.SetActiveItem(activeItem)
	updateActiveItemModel(activeItem)
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

		player:SetAttribute("ActionMode", combatMode and "Бій" or "Спокій")
		print("ActionMode =", player:GetAttribute("ActionMode"))

		if combatMode then
			preview.Clear()
		else
			preview.SetActiveItem(activeItem)
		end
	end
end)

mouse.Button1Down:Connect(function()
	interaction.HandleClick(activeItem, activeAmmo, combatMode)
end)

ui.SetCombatMode(combatMode)
player:SetAttribute("ActionMode", "Спокій")
refreshInventory()