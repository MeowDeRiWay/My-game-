local ChestHandler = {}

local ChestOpen = require(script:WaitForChild("ChestOpen"))
local ChestDeposit = require(script:WaitForChild("ChestDeposit"))
local ChestWithdraw = require(script:WaitForChild("ChestWithdraw"))

function ChestHandler.Init(context)
	ChestOpen.Init(context)
	ChestDeposit.Init(context)
	ChestWithdraw.Init(context)
end

function ChestHandler.InitChest(chest)
	ChestOpen.InitChest(chest)
end

function ChestHandler.Open(player, chest)
	ChestOpen.Run(player, chest)
end

function ChestHandler.Deposit(player, chest, itemName, amount)
	ChestDeposit.Run(player, chest, itemName, amount)
end

function ChestHandler.Withdraw(player, chest, amount)
	ChestWithdraw.Run(player, chest, amount)
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
