local InventoryUI = {}

function InventoryUI.Create(player)
	local gui = Instance.new("ScreenGui")
	gui.Name = "InventoryUI"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local activeSlot = Instance.new("TextLabel")
	activeSlot.Size = UDim2.new(0, 140, 0, 45)
	activeSlot.Position = UDim2.new(0.5, -150, 1, -60)
	activeSlot.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	activeSlot.TextColor3 = Color3.fromRGB(255, 255, 255)
	activeSlot.TextScaled = true
	activeSlot.Text = "Рука"
	activeSlot.Parent = gui

	local modeSlot = Instance.new("TextLabel")
	modeSlot.Size = UDim2.new(0, 140, 0, 45)
	modeSlot.Position = UDim2.new(0.5, 10, 1, -60)
	modeSlot.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	modeSlot.TextColor3 = Color3.fromRGB(255, 255, 255)
	modeSlot.TextScaled = true
	modeSlot.Text = "Спокій"
	modeSlot.Parent = gui

	local inventoryFrame = Instance.new("Frame")
	inventoryFrame.Size = UDim2.new(0, 320, 0, 260)
	inventoryFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
	inventoryFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	inventoryFrame.Visible = false
	inventoryFrame.Parent = gui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Text = "Інвентар"
	title.Parent = inventoryFrame

	local itemList = Instance.new("Frame")
	itemList.Size = UDim2.new(1, -20, 1, -60)
	itemList.Position = UDim2.new(0, 10, 0, 50)
	itemList.BackgroundTransparency = 1
	itemList.Parent = inventoryFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = itemList

	local controller = {}

	function controller.SetActiveItem(itemName)
		activeSlot.Text = itemName or "Пусто"
	end

	function controller.SetCombatMode(isCombat)
		modeSlot.Text = isCombat and "Бій" or "Спокій"
	end

	function controller.SetInventoryVisible(visible)
		inventoryFrame.Visible = visible
	end

	function controller.RefreshInventory(inventory, onItemSelected)
		for _, child in ipairs(itemList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		for itemName, amount in pairs(inventory) do
			if amount > 0 then
				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, 0, 0, 40)
				button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.TextScaled = true
				button.Text = itemName .. " x" .. amount
				button.Parent = itemList

				button.MouseButton1Click:Connect(function()
					onItemSelected(itemName)
				end)
			end
		end
	end

	return controller
end

return InventoryUI