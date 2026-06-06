local ChestHandler = {}

local ctx = {}

local function getCapacity(chest)
	return chest:GetAttribute("StorageCapacity") or 50
end

function ChestHandler.Init(context)
	ctx = context
end

local function getChestData(chest)
	local itemName = chest:GetAttribute("StoredItem")
	local amount = chest:GetAttribute("StoredAmount") or 0

	if itemName == "" then
		itemName = nil
	end

	return itemName, amount
end

local function setChestData(chest, itemName, amount)
	chest:SetAttribute("StoredItem", itemName or "")
	chest:SetAttribute("StoredAmount", amount or 0)
	chest:SetAttribute("Capacity", getCapacity(chest))
end

function ChestHandler.InitChest(chest)
	if not chest then return end
	if chest:GetAttribute("ObjectType") ~= "storage" then return end

	if chest:GetAttribute("StoredAmount") == nil then
		setChestData(chest, nil, 0)
	end
end

function ChestHandler.Open(player, chest)
	print("CHEST OPEN CALLED")
	if not chest then return end
	if chest:GetAttribute("ObjectType") ~= "storage" then return end

	ChestHandler.InitChest(chest)

	local storedItem, storedAmount = getChestData(chest)
	print("SENDING CHEST UI")
	ctx.ChestRequest:FireClient(player, "Open", {
		Chest = chest,
		StoredItem = storedItem,
		StoredAmount = storedAmount,
		Capacity = getCapacity(chest),
		Inventory = ctx.GetInventory(player),
	})
end

function ChestHandler.Deposit(player, chest, itemName, amount)
	if not chest then return end
	if chest:GetAttribute("ObjectType") ~= "storage" then return end

	ChestHandler.InitChest(chest)

	amount = tonumber(amount) or 0
	amount = math.floor(amount)

	if amount <= 0 then return end
	if not itemName then return end

	local itemConfig = ctx.ItemConfig[itemName]
	if not itemConfig then return end
	if itemConfig.Type ~= "Resource" then return end

	local storedItem, storedAmount = getChestData(chest)

	if storedItem and storedItem ~= itemName then
		ctx.ChestRequest:FireClient(player, "Error", "У сундуку вже лежить інший ресурс")
		return
	end

	local freeSpace = getCapacity(chest) - storedAmount
	if freeSpace <= 0 then
		ctx.ChestRequest:FireClient(player, "Error", "Сундук заповнений")
		return
	end

	local depositAmount = math.min(amount, freeSpace)

	if not ctx.HasItem(player, itemName, depositAmount) then
		ctx.ChestRequest:FireClient(player, "Error", "Немає стільки ресурсу")
		return
	end

	ctx.RemoveItem(player, itemName, depositAmount)

	storedItem = itemName
	storedAmount += depositAmount

	setChestData(chest, storedItem, storedAmount)

	ctx.SendInventory(player)
	ChestHandler.Open(player, chest)
end

function ChestHandler.Withdraw(player, chest, amount)
	if not chest then return end
	if chest:GetAttribute("ObjectType") ~= "storage" then return end

	ChestHandler.InitChest(chest)

	amount = tonumber(amount) or 0
	amount = math.floor(amount)

	if amount <= 0 then return end

	local storedItem, storedAmount = getChestData(chest)

	if not storedItem or storedAmount <= 0 then
		ctx.ChestRequest:FireClient(player, "Error", "Сундук порожній")
		return
	end

	local withdrawAmount = math.min(amount, storedAmount)

	ctx.AddItem(player, storedItem, withdrawAmount)

	storedAmount -= withdrawAmount

	if storedAmount <= 0 then
		setChestData(chest, nil, 0)
	else
		setChestData(chest, storedItem, storedAmount)
	end

	ctx.SendInventory(player)
	ChestHandler.Open(player, chest)
end

function ChestHandler.Handle(player, action, data)
	if action == "Open" then
		ChestHandler.Open(player, data.Chest)
		return
	end

	if action == "Deposit" then
		ChestHandler.Deposit(player, data.Chest, data.ItemName, data.Amount)
		return
	end

	if action == "Withdraw" then
		ChestHandler.Withdraw(player, data.Chest, data.Amount)
		return
	end
end

return ChestHandler
