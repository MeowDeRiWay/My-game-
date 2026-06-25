local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemConfig = require(ReplicatedStorage:WaitForChild("ItemConfig"))
local DamageResolver = require(script.Parent:WaitForChild("DamageResolver"))

local ObjectHitHandler = {}

local function getTargetRoot(target)
	if not target then return nil end

	if target:IsA("Model") then
		return target
	end

	local model = target:FindFirstAncestorOfClass("Model")
	if model and model:GetAttribute("Health") then
		return model
	end

	return target
end

local function getAttr(target, name, default)
	local value = target:GetAttribute(name)
	if value ~= nil then
		return value
	end
	return default
end

function ObjectHitHandler.Handle(player, target, itemName, ctx)
	local root = getTargetRoot(target)
	if not root then return end

	local health = getAttr(root, "Health", nil)
	if not health then return end

	local itemData = ItemConfig[itemName]
	if not itemData then return end

	local targetData = {
		TargetType = getAttr(root, "TargetType", getAttr(root, "ObjectType", "Unknown")),
		ResourceType = getAttr(root, "ResourceType", nil),

		Protection = getAttr(root, "Protection", 0),
		Resistance = getAttr(root, "Resistance", 0),
		Absorption = getAttr(root, "Absorption", 0),
	}

	local result = DamageResolver.Resolve({
		Player = player,
		ItemName = itemName,
		Item = itemData,
		Target = targetData,
		TargetInstance = root,
	})

	if result.Blocked then
		if ctx and ctx.Popup then
			ctx.Popup(player, result.Message)
		end
		return
	end

	if result.FinalDamage <= 0 then return end

	local newHealth = math.max(0, health - result.FinalDamage)
	root:SetAttribute("Health", newHealth)

	if ctx and ctx.DamagePopup then
		ctx.DamagePopup(root, result.FinalDamage)
	end

	if result.ShouldGiveResource and result.ResourceType and result.ResourceAmount > 0 then
		if ctx and ctx.AddItem then
			ctx.AddItem(player, result.ResourceType, result.ResourceAmount)
		end

		if ctx and ctx.SendInventory then
			ctx.SendInventory(player)
		end
	end

	if newHealth <= 0 then
		if ctx and ctx.OnObjectDestroyed then
			ctx.OnObjectDestroyed(player, root, targetData)
		else
			root:Destroy()
		end
	end
end

return ObjectHitHandler
