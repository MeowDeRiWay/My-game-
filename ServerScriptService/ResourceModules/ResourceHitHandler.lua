local ResourceHitHandler = {}

local ctx = {
	AddItem = nil,
	SendInventory = nil,
	Popup = nil,
	DamagePopup = nil,
	DamageResolver = nil,
	ItemConfig = nil,
	SpawnTime = 5,
}

function ResourceHitHandler.Init(context)
	ctx.AddItem = context.AddItem
	ctx.SendInventory = context.SendInventory
	ctx.Popup = context.Popup
	ctx.DamagePopup = context.DamagePopup
	ctx.DamageResolver = context.DamageResolver
	ctx.ItemConfig = context.ItemConfig
	ctx.SpawnTime = context.SpawnTime
end

local function hideResource(resource)
	resource.Transparency = 1
	resource.CanCollide = false
	resource.CanTouch = false
	resource.CanQuery = false
end

local function restoreResource(resource)
	resource.Transparency = 0
	resource.CanCollide = true
	resource.CanTouch = true
	resource.CanQuery = true

	local maxHealth = resource:GetAttribute("MaxHealth")
	resource:SetAttribute("Health", maxHealth)
	resource:SetAttribute("Disabled", false)
end

function ResourceHitHandler.Handle(player, resource, itemName)
	if not player then return end
	if not resource then return end
	if not resource:IsA("BasePart") then return end
	if not resource:GetAttribute("ResourceType") then return end
	if resource:GetAttribute("Disabled") == true then return end

	local health = resource:GetAttribute("Health")
	if not health or health <= 0 then return end

	local dropItem = resource:GetAttribute("DropItem")
	if not dropItem then
		warn("Resource has no DropItem:", resource.Name)
		return
	end

	local itemConfig = ctx.ItemConfig[itemName] or {}
	local harvestAmount = itemConfig.HarvestAmount

	local result = ctx.DamageResolver.Resolve(
		{
			Damage = itemConfig.Damage or 1,
			Penetration = itemConfig.Penetration or 0,
		},
		{
			Protection = resource:GetAttribute("Protection") or 0,
			Resistance = resource:GetAttribute("Resistance") or 0,
			Absorption = resource:GetAttribute("Absorption") or 0,
		}
	)

	if ctx.DamagePopup then
		ctx.DamagePopup:FireClient(player, resource, result.Message)
	end

	if result.Blocked then
		return
	endі

	if ctx.AddItem then
		ctx.AddItem(player, dropItem, harvestAmount)
	end

	if ctx.SendInventory then
		ctx.SendInventory(player)
	end

	if ctx.Popup then
		ctx.Popup:FireClient(player, "+" .. harvestAmount .. " " .. dropItem)
	end

	health -= result.FinalDamage
	resource:SetAttribute("Health", health)

	if health > 0 then
		return
	end

	resource:SetAttribute("Disabled", true)
	hideResource(resource)

	task.delay(ctx.SpawnTime, function()
		if resource and resource.Parent then
			restoreResource(resource)
		end
	end)
end

return ResourceHitHandler