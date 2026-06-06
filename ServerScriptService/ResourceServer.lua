local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local HitResource = Remotes:WaitForChild("HitResource")
local InventoryUpdate = Remotes:WaitForChild("InventoryUpdate")
local ResourcePopupEvent = Remotes:WaitForChild("ResourcePopupEvent")
local DamagePopupEvent = Remotes:WaitForChild("DamagePopupEvent")
local ChestHandler = require(script.Parent.ResourceModules.ChestHandler)

local CraftRequest = ReplicatedStorage:WaitForChild("CraftRequest")
local CraftingConfig = require(ReplicatedStorage:WaitForChild("CraftingConfig"))
local ItemConfig = require(ReplicatedStorage:WaitForChild("ItemConfig"))
local DamageResolver = require(ReplicatedStorage:WaitForChild("DamageResolver"))

local BaseObjectsStorage = ReplicatedStorage:WaitForChild("Base.Obj")
local Era1BaseObjects = BaseObjectsStorage:WaitForChild("Era_1")

local ResourceHitHandler = require(script.Parent.ResourceModules.ResourceHitHandler)
local BaseObjectHandler =
	require(script.Parent.ResourceModules.BaseObjectHandler)

local inventories = {}

local RESPAWN_TIME = 5

local BaseObjectRequest = Remotes:FindFirstChild("BaseObjectRequest")

local ChestRequest = Remotes:FindFirstChild("ChestRequest")
if not ChestRequest then
	ChestRequest = Instance.new("RemoteEvent")
	ChestRequest.Name = "ChestRequest"
	ChestRequest.Parent = Remotes
end

if not BaseObjectRequest then
	BaseObjectRequest = Instance.new("RemoteEvent")
	BaseObjectRequest.Name = "BaseObjectRequest"
	BaseObjectRequest.Parent = Remotes
end

local baseObjectsFolder = workspace:FindFirstChild("BaseObjects")

if not baseObjectsFolder then
	baseObjectsFolder = Instance.new("Folder")
	baseObjectsFolder.Name = "BaseObjects"
	baseObjectsFolder.Parent = workspace
end

local function sendInventory(player)
	InventoryUpdate:FireClient(player, inventories[player])
end

local function addItem(player, itemName, amount)
	if not inventories[player] then
		return
	end

	if not ItemConfig[itemName] then
		warn("Невідомий предмет: " .. tostring(itemName))
		return
	end

	inventories[player][itemName] =
		(inventories[player][itemName] or 0) + amount
end

local function removeItem(player, itemName, amount)
	if not inventories[player] then
		return false
	end

	local currentAmount = inventories[player][itemName] or 0

	if currentAmount < amount then
		return false
	end

	inventories[player][itemName] = currentAmount - amount
	return true
end

local function hasItem(player, itemName, amount)
	if not inventories[player] then
		return false
	end

	return (inventories[player][itemName] or 0) >= amount
end

local function findRecipe(craftId)
	for _, era in ipairs(CraftingConfig.Eras) do
		for _, craft in ipairs(era.Crafts) do
			if craft.Id == craftId then
				return craft
			end
		end
	end

	return nil
end

ResourceHitHandler.Init({
	AddItem = addItem,
	SendInventory = sendInventory,
	Popup = ResourcePopupEvent,
	DamagePopup = DamagePopupEvent,

	DamageResolver = DamageResolver,
	ItemConfig = ItemConfig,

	SpawnTime = RESPAWN_TIME,
})

Players.PlayerAdded:Connect(function(player)
	inventories[player] = {
		["Рука"] = 1,
		["Примітивний стіл"] = 1,
		["Оброблена дошка"] = 20,
	}

	sendInventory(player)
end)

BaseObjectHandler.Init({
	ItemConfig = ItemConfig,
	DamageResolver = DamageResolver,
	
	ChestHandler = ChestHandler,
	
	BaseObjectsStorage = BaseObjectsStorage,
	BaseObjectsFolder = baseObjectsFolder,

	HasItem = hasItem,
	RemoveItem = removeItem,
	SendInventory = sendInventory,

	BaseObjectRequest = BaseObjectRequest,
	DamagePopup = DamagePopupEvent,
})

ChestHandler.Init({
	ItemConfig = ItemConfig,
	GetInventory = function(player)
		return inventories[player]
	end,
	HasItem = hasItem,
	AddItem = addItem,
	RemoveItem = removeItem,
	SendInventory = sendInventory,
	ChestRequest = ChestRequest,
})

Players.PlayerRemoving:Connect(function(player)
	inventories[player] = nil
end)

CraftRequest.OnServerEvent:Connect(function(player, craftId)
	if not inventories[player] then return end

	local craft = findRecipe(craftId)
	if not craft then return end

	if craft.Unique == true then
		local resultItem = craft.Result.Item

		if hasItem(player, resultItem, 1) then
			return
		end
	end

	for itemName, requiredAmount in pairs(craft.Requirements or {}) do
		if not hasItem(player, itemName, requiredAmount) then
			return
		end
	end

	for toolName, requiredAmount in pairs(craft.Tools or {}) do
		if not hasItem(player, toolName, requiredAmount) then
			return
		end
	end

	for _, toolGroup in ipairs(craft.ToolsAny or {}) do
		local hasAnyTool = false

		for toolName, requiredAmount in pairs(toolGroup) do
			if hasItem(player, toolName, requiredAmount) then
				hasAnyTool = true
				break
			end
		end

		if not hasAnyTool then
			return
		end
	end

	for itemName, requiredAmount in pairs(craft.Requirements or {}) do
		removeItem(player, itemName, requiredAmount)
	end

	addItem(player, craft.Result.Item, craft.Result.Amount)
	sendInventory(player)

	ResourcePopupEvent:FireClient(
		player,
		"Виготовлено: " .. craft.Result.Item .. " x" .. craft.Result.Amount
	)
end)

HitResource.OnServerEvent:Connect(function(player, tree, itemName)
	print("SERVER RESOURCE HIT ITEM:", itemName)
	ResourceHitHandler.Handle(player, tree, itemName)
end)

BaseObjectRequest.OnServerEvent:Connect(function(player, action, data, itemName)
	print("SERVER BASE ACTION:", action, "ITEM:", itemName)
	BaseObjectHandler.Handle(player, action, data, itemName)
end)

ChestRequest.OnServerEvent:Connect(function(player, action, data)
	ChestHandler.Handle(player, action, data)
end)