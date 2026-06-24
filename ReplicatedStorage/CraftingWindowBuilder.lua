local CraftingWindowBuilder = {}

function CraftingWindowBuilder.Create(player, craftingConfig, craftRequest)
	local currentInventory = {}
	local currentEra = nil
	local selectedCraft = nil
	local craftButtons = {}
	local currentStationType = nil

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CraftingUI"
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 680, 0, 430)
	mainFrame.Position = UDim2.new(0.5, -340, 0.5, -215)
	mainFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 24)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 45)
	title.BackgroundColor3 = Color3.fromRGB(55, 45, 35)
	title.Text = "Меню створення"
	title.TextColor3 = Color3.fromRGB(255, 230, 180)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.Parent = mainFrame

	local erasTitle = Instance.new("TextLabel")
	erasTitle.Size = UDim2.new(0, 150, 0, 35)
	erasTitle.Position = UDim2.new(0, 15, 0, 60)
	erasTitle.BackgroundTransparency = 1
	erasTitle.Text = "Ера"
	erasTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	erasTitle.TextScaled = true
	erasTitle.Font = Enum.Font.GothamBold
	erasTitle.Parent = mainFrame

	local craftsTitle = Instance.new("TextLabel")
	craftsTitle.Size = UDim2.new(0, 240, 0, 35)
	craftsTitle.Position = UDim2.new(0, 190, 0, 60)
	craftsTitle.BackgroundTransparency = 1
	craftsTitle.Text = "Доступні крафти"
	craftsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	craftsTitle.TextScaled = true
	craftsTitle.Font = Enum.Font.GothamBold
	craftsTitle.Parent = mainFrame

	local requirementsTitle = Instance.new("TextLabel")
	requirementsTitle.Size = UDim2.new(0, 210, 0, 35)
	requirementsTitle.Position = UDim2.new(0, 450, 0, 60)
	requirementsTitle.BackgroundTransparency = 1
	requirementsTitle.Text = "Вимоги"
	requirementsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	requirementsTitle.TextScaled = true
	requirementsTitle.Font = Enum.Font.GothamBold
	requirementsTitle.Parent = mainFrame

	local erasFrame = Instance.new("Frame")
	erasFrame.Size = UDim2.new(0, 150, 0, 280)
	erasFrame.Position = UDim2.new(0, 15, 0, 100)
	erasFrame.BackgroundTransparency = 1
	erasFrame.Parent = mainFrame

	local craftsFrame = Instance.new("Frame")
	craftsFrame.Size = UDim2.new(0, 240, 0, 280)
	craftsFrame.Position = UDim2.new(0, 190, 0, 100)
	craftsFrame.BackgroundTransparency = 1
	craftsFrame.Parent = mainFrame

	local requirementsText = Instance.new("TextLabel")
	requirementsText.Size = UDim2.new(0, 210, 0, 220)
	requirementsText.Position = UDim2.new(0, 450, 0, 100)
	requirementsText.BackgroundColor3 = Color3.fromRGB(45, 40, 35)
	requirementsText.Text = "Обери крафт"
	requirementsText.TextColor3 = Color3.fromRGB(255, 220, 170)
	requirementsText.TextScaled = true
	requirementsText.TextWrapped = true
	requirementsText.Font = Enum.Font.Gotham
	requirementsText.Parent = mainFrame

	local craftButton = Instance.new("TextButton")
	craftButton.Size = UDim2.new(0, 210, 0, 45)
	craftButton.Position = UDim2.new(0, 450, 0, 335)
	craftButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	craftButton.Text = "Створити"
	craftButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	craftButton.TextScaled = true
	craftButton.Font = Enum.Font.GothamBold
	craftButton.Visible = false
	craftButton.Parent = mainFrame

	local statusText = Instance.new("TextLabel")
	statusText.Size = UDim2.new(1, -30, 0, 30)
	statusText.Position = UDim2.new(0, 15, 1, -35)
	statusText.BackgroundTransparency = 1
	statusText.Text = "C — відкрити / закрити"
	statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
	statusText.TextScaled = true
	statusText.Font = Enum.Font.Gotham
	statusText.Parent = mainFrame

	local function clearFrame(frame)
		for _, child in ipairs(frame:GetChildren()) do
			child:Destroy()
		end
	end

	local function hasEnough(list)
		for itemName, amount in pairs(list or {}) do
			if (currentInventory[itemName] or 0) < amount then
				return false
			end
		end

		return true
	end

	local function hasAnyToolGroup(toolsAny)
		if not toolsAny then
			return true
		end

		for _, toolGroup in ipairs(toolsAny) do
			if hasEnough(toolGroup) then
				return true
			end
		end

		return false
	end

	local function craftFitsStation(craft)
		if not craft.StationsAny then
			return currentStationType == nil
		end

		if not currentStationType then
			return false
		end

		for _, station in ipairs(craft.StationsAny) do
			if station == currentStationType then
				return true
			end
		end

		return false
	end

	local function canCraft(craft)
		if not craftFitsStation(craft) then
			return false
		end

		if craft.Unique == true then
			local resultItem = craft.Result.Item

			if (currentInventory[resultItem] or 0) >= 1 then
				return false
			end
		end

		if not hasEnough(craft.Requirements) then
			return false
		end

		if craft.Tools and not hasEnough(craft.Tools) then
			return false
		end

		if craft.ToolsAny and not hasAnyToolGroup(craft.ToolsAny) then
			return false
		end

		return true
	end

	local function valueToText(value)
		if typeof(value) == "table" then
			local parts = {}

			for key, innerValue in pairs(value) do
				table.insert(parts, tostring(key) .. ": " .. tostring(innerValue))
			end

			return table.concat(parts, ", ")
		end

		return tostring(value)
	end

	local function craftInfoToText(craft)
		local lines = {}

		table.insert(lines, "Ресурси:")
		table.insert(lines, "")

		for itemName, amount in pairs(craft.Requirements or {}) do
			local have = currentInventory[itemName] or 0
			table.insert(lines, tostring(amount) .. " x " .. valueToText(itemName) .. " (" .. tostring(have) .. "/" .. tostring(amount) .. ")")
		end

		if craft.Tools and next(craft.Tools) then
			table.insert(lines, "")
			table.insert(lines, "Інструменти:")
			table.insert(lines, "")

			for toolName, amount in pairs(craft.Tools) do
				local have = currentInventory[toolName] or 0
				table.insert(lines, tostring(amount) .. " x " .. valueToText(toolName) .. " (" .. tostring(have) .. "/" .. tostring(amount) .. ")")
			end
		end

		if craft.ToolsAny then
			table.insert(lines, "")
			table.insert(lines, "Інструмент, один з варіантів:")
			table.insert(lines, "")

			for groupIndex, toolGroup in ipairs(craft.ToolsAny) do
				table.insert(lines, "Варіант " .. tostring(groupIndex) .. ":")

				for toolName, amount in pairs(toolGroup) do
					local have = currentInventory[toolName] or 0
					table.insert(lines, tostring(amount) .. " x " .. valueToText(toolName) .. " (" .. tostring(have) .. "/" .. tostring(amount) .. ")")
				end

				table.insert(lines, "")
			end
		end

		if craft.StationsAny then
			table.insert(lines, "")
			table.insert(lines, "Потрібен верстак:")

			for _, stationName in ipairs(craft.StationsAny) do
				table.insert(lines, "- " .. valueToText(stationName))
			end
		end

		return table.concat(lines, "\n")
	end

	local function updateCraftButton()
		if not selectedCraft then
			craftButton.Visible = false
			return
		end

		craftButton.Visible = true

		if canCraft(selectedCraft) then
			craftButton.BackgroundColor3 = Color3.fromRGB(70, 120, 60)
			craftButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			craftButton.Text = "Створити"
			craftButton.Active = true
		else
			craftButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			craftButton.TextColor3 = Color3.fromRGB(170, 170, 170)
			craftButton.Text = "Не вистачає"
			craftButton.Active = false
		end
	end

	local function refreshCraftColors()
		for craft, button in pairs(craftButtons) do
			if canCraft(craft) then
				button.BackgroundColor3 = Color3.fromRGB(80, 130, 70)
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				button.TextColor3 = Color3.fromRGB(170, 170, 170)
			end
		end

		if selectedCraft then
			requirementsText.Text = craftInfoToText(selectedCraft)
		end

		updateCraftButton()
	end

	local function selectCraft(craft)
		selectedCraft = craft
		requirementsText.Text = craftInfoToText(craft)
		updateCraftButton()
	end

	local function showCrafts(era)
		currentEra = era
		selectedCraft = nil
		craftButtons = {}

		clearFrame(craftsFrame)

		requirementsText.Text = "Обери крафт"
		craftButton.Visible = false

		local visibleIndex = 0

		for _, craft in ipairs(era.Crafts) do
			if craftFitsStation(craft) then
				visibleIndex += 1

				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, 0, 0, 45)
				button.Position = UDim2.new(0, 0, 0, (visibleIndex - 1) * 50)
				button.Text = craft.Name
				button.TextScaled = true
				button.TextWrapped = true
				button.Font = Enum.Font.GothamBold
				button.Parent = craftsFrame

				craftButtons[craft] = button

				button.MouseButton1Click:Connect(function()
					selectCraft(craft)
				end)
			end
		end

		refreshCraftColors()
	end

	local function buildEras()
		clearFrame(erasFrame)

		for index, era in ipairs(craftingConfig.Eras) do
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, 0, 0, 45)
			button.Position = UDim2.new(0, 0, 0, (index - 1) * 50)
			button.BackgroundColor3 = Color3.fromRGB(90, 70, 45)
			button.Text = era.Name
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.TextScaled = true
			button.Font = Enum.Font.GothamBold
			button.Parent = erasFrame

			button.MouseButton1Click:Connect(function()
				showCrafts(era)
			end)
		end
	end

	craftButton.MouseButton1Click:Connect(function()
		if not selectedCraft then return end
		if not canCraft(selectedCraft) then return end

		craftRequest:FireServer(selectedCraft.Id)
	end)

	buildEras()

	return {
		ScreenGui = screenGui,

		Open = function(stationType)
			currentStationType = stationType
			screenGui.Enabled = true

			if currentEra then
				showCrafts(currentEra)
			elseif craftingConfig.Eras[1] then
				showCrafts(craftingConfig.Eras[1])
			end
		end,

		Close = function()
			screenGui.Enabled = false
			currentStationType = nil
			selectedCraft = nil
			requirementsText.Text = "Обери крафт"
			craftButton.Visible = false
		end,

		UpdateInventory = function(newInventory)
			currentInventory = newInventory or {}

			if currentEra then
				refreshCraftColors()
			end
		end
	}
end

return CraftingWindowBuilder
