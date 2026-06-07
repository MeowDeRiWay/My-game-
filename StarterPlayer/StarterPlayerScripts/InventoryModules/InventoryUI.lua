local InventoryUI = {}

function InventoryUI.Create(player)
	local self = {}

	local gui = Instance.new("ScreenGui")
	gui.Name = "InventoryGui"
	gui.ResetOnSpawn = false
	gui.Enabled = true
	gui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 620, 0, 360)
	frame.Position = UDim2.new(0.5, -310, 0.5, -180)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = gui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 35)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 22
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "Інвентар"
	title.Parent = frame

	local inventoryTitle = Instance.new("TextLabel")
	inventoryTitle.Size = UDim2.new(0, 270, 0, 30)
	inventoryTitle.Position = UDim2.new(0, 20, 0, 50)
	inventoryTitle.BackgroundTransparency = 1
	inventoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	inventoryTitle.Font = Enum.Font.SourceSansBold
	inventoryTitle.TextSize = 20
	inventoryTitle.Text = "Предмети"
	inventoryTitle.Parent = frame

	local equipmentTitle = Instance.new("TextLabel")
	equipmentTitle.Size = UDim2.new(0, 270, 0, 30)
	equipmentTitle.Position = UDim2.new(0, 330, 0, 50)
	equipmentTitle.BackgroundTransparency = 1
	equipmentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	equipmentTitle.Font = Enum.Font.SourceSansBold
	equipmentTitle.TextSize = 20
	equipmentTitle.Text = "Екіпірування"
	equipmentTitle.Parent = frame

	local itemList = Instance.new("ScrollingFrame")
	itemList.Size = UDim2.new(0, 270, 0, 250)
	itemList.Position = UDim2.new(0, 20, 0, 85)
	itemList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	itemList.BorderSizePixel = 0
	itemList.CanvasSize = UDim2.new(0, 0, 0, 0)
	itemList.ScrollBarThickness = 8
	itemList.Parent = frame

	local equipmentFrame = Instance.new("Frame")
	equipmentFrame.Size = UDim2.new(0, 270, 0, 250)
	equipmentFrame.Position = UDim2.new(0, 330, 0, 85)
	equipmentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	equipmentFrame.BorderSizePixel = 0
	equipmentFrame.Parent = frame

	local armorSlots = {
		"Голова",
		"Тіло",
		"Руки",
		"Ноги",
		"Артефакт",
	}

	for i, slotName in ipairs(armorSlots) do
		local slot = Instance.new("TextLabel")
		slot.Size = UDim2.new(1, -20, 0, 34)
		slot.Position = UDim2.new(0, 10, 0, 10 + (i - 1) * 42)
		slot.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		slot.TextColor3 = Color3.fromRGB(180, 180, 180)
		slot.Font = Enum.Font.SourceSans
		slot.TextSize = 17
		slot.TextXAlignment = Enum.TextXAlignment.Left
		slot.Text = "  " .. slotName .. ": порожньо"
		slot.Parent = equipmentFrame
	end

	local activeLabel = Instance.new("TextLabel")
	activeLabel.Size = UDim2.new(0, 300, 0, 30)
	activeLabel.Position = UDim2.new(0, 20, 1, -80)
	activeLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	activeLabel.BackgroundTransparency = 0.15
	activeLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
	activeLabel.Font = Enum.Font.SourceSansBold
	activeLabel.TextSize = 18
	activeLabel.TextXAlignment = Enum.TextXAlignment.Left
	activeLabel.Text = "  Активний: -"
	activeLabel.Parent = gui

	local modeLabel = Instance.new("TextLabel")
	modeLabel.Size = UDim2.new(0, 300, 0, 30)
	modeLabel.Position = UDim2.new(0, 20, 1, -45)
	modeLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	modeLabel.BackgroundTransparency = 0.15
	modeLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
	modeLabel.Font = Enum.Font.SourceSansBold
	modeLabel.TextSize = 18
	modeLabel.TextXAlignment = Enum.TextXAlignment.Left
	modeLabel.Text = "  Режим: Спокій"
	modeLabel.Parent = gui

	local ammoSlot = Instance.new("TextLabel")
	ammoSlot.Size = UDim2.new(0, 140, 0, 45)
	ammoSlot.Position = UDim2.new(0.5, -310, 1, -60)
	ammoSlot.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	ammoSlot.TextColor3 = Color3.fromRGB(255, 255, 255)
	ammoSlot.TextScaled = true
	ammoSlot.Text = "Набої: пусто"
	ammoSlot.Parent = gui
	
	local function clearList()
		for _, child in ipairs(itemList:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end
	end

	function self.SetInventoryVisible(enabled)
		frame.Visible = enabled
	end

	function self.SetEnabled(enabled)
		frame.Visible = enabled
	end

	function self.SetActiveItem(itemName)
		activeLabel.Text = "  Активний: " .. tostring(itemName or "-")
	end

	function self.SetCombatMode(enabled)
		if enabled then
			modeLabel.Text = "  Режим: Бій"
		else
			modeLabel.Text = "  Режим: Спокій"
		end
	end

	function controller.SetActiveAmmo(itemName)
		ammoSlot.Text = "Набої: " .. (itemName or "Пусто")
	end

	function self.RefreshInventory(inventory, onSelectItem, activeItem)
		clearList()

		local y = 5

		for itemName, amount in pairs(inventory or {}) do
			if amount > 0 then
				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, -14, 0, 30)
				button.Position = UDim2.new(0, 5, 0, y)
				button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.Font = Enum.Font.SourceSans
				button.TextSize = 17
				button.TextXAlignment = Enum.TextXAlignment.Left
				button.Parent = itemList

				if activeItem == itemName then
					button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
					button.Text = "▶  " .. itemName .. " x" .. amount
				else
					button.Text = "  " .. itemName .. " x" .. amount
				end

				button.MouseButton1Click:Connect(function()
					if onSelectItem then
						onSelectItem(itemName)
					end
				end)

				y += 34
			end
		end

		itemList.CanvasSize = UDim2.new(0, 0, 0, y)
		self.SetActiveItem(activeItem)
	end

	return self
end

return InventoryUI