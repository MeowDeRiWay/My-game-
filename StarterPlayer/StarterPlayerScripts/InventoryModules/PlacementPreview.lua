local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemConfig = require(ReplicatedStorage:WaitForChild("ItemConfig"))
local BaseObjectsStorage = ReplicatedStorage:WaitForChild("Base.Obj")

local PlacementPreview = {}

local ROTATION_STEP = 45

function PlacementPreview.Create(params)
	local mouse = params.Mouse
	local placementPreview = nil
	local rotationY = 0

	local controller = {}

	function controller.Clear()
		if placementPreview then
			placementPreview:Destroy()
			placementPreview = nil
		end
		rotationY = 0
	end

	function controller.GetRotationY()
		return rotationY
	end

	function controller.SetActiveItem(itemName)
		controller.Clear()

		if not itemName then return end

		local config = ItemConfig[itemName]
		if not config then return end
		if config.Type ~= "BasePlaceable" then return end
		if not config.ModelFolder or not config.ModelName then return end

		local folder = BaseObjectsStorage:FindFirstChild(config.ModelFolder)
		if not folder then return end

		local template = folder:FindFirstChild(config.ModelName)
		if not template then return end

		placementPreview = template:Clone()
		placementPreview.Name = "PlacementPreview"
		placementPreview.Parent = workspace

		for _, descendant in ipairs(placementPreview:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.CanQuery = false
				descendant.Transparency = 0.45
				descendant.Color = Color3.fromRGB(80, 255, 80)
			end
		end
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not placementPreview then return end

		if input.KeyCode == Enum.KeyCode.R then
			rotationY += ROTATION_STEP

			if rotationY >= 360 then
				rotationY = 0
			end
		end

		if input.KeyCode == Enum.KeyCode.T then
			rotationY = 0
		end
	end)

	RunService.RenderStepped:Connect(function()
		if not placementPreview then return end
		if not mouse.Hit then return end

		local position = mouse.Hit.Position

		placementPreview:PivotTo(
			CFrame.new(position.X, position.Y, position.Z)
				* CFrame.Angles(0, math.rad(rotationY), 0)
		)
	end)

	return controller
end

return PlacementPreview
