local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemConfig = require(ReplicatedStorage:WaitForChild("ItemConfig"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local HitResource = Remotes:WaitForChild("HitResource")
local BaseObjectRequest = Remotes:WaitForChild("BaseObjectRequest")
local ShootRequest = Remotes:WaitForChild("ShootRequest")

local WorldInteraction = {}

local function getObjectWithAttribute(target, attributeName, expectedValue)
	if not target then
		return nil
	end

	local current = target

	while current do
		local value = current:GetAttribute(attributeName)

		if value ~= nil then
			if expectedValue == nil or value == expectedValue then
				return current
			end
		end

		current = current.Parent
	end

	return nil
end

local function getBaseObjectFromTarget(target)
	return getObjectWithAttribute(target, "BaseType", "base")
end

local function getResourceFromTarget(target)
	return getObjectWithAttribute(target, "ResourceType")
end

function WorldInteraction.Create(params)
	local mouse = params.Mouse
	local preview = params.Preview

	local controller = {}

	function controller.HandleClick(activeItem, activeAmmo, combatMode)
		local target = mouse.Target
		local baseObject = getBaseObjectFromTarget(target)
		local resourceObject = getResourceFromTarget(target)

		if combatMode == true then
			local activeConfig = activeItem and ItemConfig[activeItem]

			if activeConfig and activeConfig.Type == "RangeWeapon" then
				ShootRequest:FireServer(activeItem, activeAmmo, mouse.Hit.Position)
				return
			end

			if resourceObject then
				HitResource:FireServer(resourceObject, activeItem)
				return
			end

			if baseObject then
				BaseObjectRequest:FireServer("Damage", baseObject, activeItem)
				return
			end

			return
		end

		if baseObject then
			BaseObjectRequest:FireServer("Interact", baseObject)
			return
		end

		if activeItem then
			local config = ItemConfig[activeItem]

			if config and config.Type == "BasePlaceable" then
				BaseObjectRequest:FireServer("Place", mouse.Hit.Position, activeItem)
				preview.Clear()
				return
			end
		end
	end

	return controller
end

return WorldInteraction
