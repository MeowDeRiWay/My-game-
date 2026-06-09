local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local HitResource = Remotes:WaitForChild("HitResource")
local InventoryUpdate = Remotes:WaitForChild("InventoryUpdate")
local ResourcePopupEvent = Remotes:WaitForChild("ResourcePopupEvent")
local DamagePopupEvent = Remotes:WaitForChild("DamagePopupEvent")

local ShootRequest = Remotes:FindFirstChild("ShootRequest")
if not ShootRequest then
	ShootRequest = Instance.new("RemoteEvent")
	ShootRequest.Name = "ShootRequest"
	ShootRequest.Parent = Remotes
end

local BaseObjectRequest = Remotes:FindFirstChild("BaseObjectRequest")
if not BaseObjectRequest then
	BaseObjectRequest = Instance.new("RemoteEvent")
	BaseObjectRequest.Name = "BaseObjectRequest"
	BaseObjectRequest.Parent = Remotes
end

local ChestRequest = Remotes:FindFirstChild("ChestRequest")
if not ChestRequest then
	ChestRequest = Instance.new("RemoteEvent")
	ChestRequest.Name = "ChestRequest"
	ChestRequest.Parent = Remotes
end

local CraftRequest = ReplicatedStorage:WaitForChild("CraftRequest")

local CraftingConfig = require(ReplicatedStorage:WaitForChild("CraftingConfig"))
local ItemConfig = require(ReplicatedStorage:WaitForChild("ItemConfig"))
local DamageResolver = require(ReplicatedStorage:WaitForChild("DamageResolver"))

local BaseObjectsStorage = ReplicatedStorage:WaitForChild("Base.Obj")

local ResourceHitHandler = require(script.Parent.ResourceModules.ResourceHitHandler)
local BaseObjectHandler = require(script.Parent.ResourceModules.BaseObjectHandler)
local ChestHandler = require(script.Parent.ResourceModules.ChestHandler)
local ProjectileHandler = require(script.Parent.ResourceModules.ProjectileHandler)

local StarterPack = require(script:WaitForChild("StarterPack"))

local inventories = {}
local RESPAWN_TIME = 5

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

	if inventories[player][itemName] <= 0 then
		inventories[player][itemName] = nil
	end

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

ProjectileHandler.Init({
	ItemConfig = ItemConfig,

	GetInventory = function(player)
		return inventories[player]
	end,

	RemoveItem = removeItem,
	SendInventory = sendInventory,

	DamageResolver = DamageResolver,
	DamagePopup = DamagePopupEvent,
})

Players.PlayerAdded:Connect(function(player)
	inventories[player] = StarterPack.Get()

	local function forceInventoryUpdate()
		task.wait(0.2)
		sendInventory(player)
	end

	player.CharacterAdded:Connect(function()
		forceInventoryUpdate()
	end)

	forceInventoryUpdate()
end)

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
	ResourceHitHandler.Handle(player, tree, itemName)
end)

BaseObjectRequest.OnServerEvent:Connect(function(player, action, data, itemName)
	BaseObjectHandler.Handle(player, action, data, itemName)
end)

ChestRequest.OnServerEvent:Connect(function(player, action, data)
	ChestHandler.Handle(player, action, data)
end)

ShootRequest.OnServerEvent:Connect(function(player, weaponName, ammoName, targetPosition)
	ProjectileHandler.Shoot(player, weaponName, ammoName, targetPosition)
end)