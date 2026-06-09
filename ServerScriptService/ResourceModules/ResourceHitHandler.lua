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
	ctx.SpawnTime = context.SpawnTime or 5
end

local function getResourceRoot(hitObject)
	if not hitObject then return nil end

	if hitObject:IsA("Model") and hitObject:GetAttribute("ResourceType") then
		return hitObject
	end

	if hitObject:IsA("BasePart") and hitObject:GetAttribute("ResourceType") then
		return hitObject
	end

	local model = hitObject:FindFirstAncestorOfClass("Model")
	if model and model:GetAttribute("ResourceType") then
		return model
	end

	return nil
end

local function getResourceParts(resourceRoot)
	local parts = {}

	if resourceRoot:IsA("BasePart") then
		table.insert(parts, resourceRoot)
		return parts
	end

	for _, obj in ipairs(resourceRoot:GetDescendants()) do
		if obj:IsA("BasePart") then
			table.insert(parts, obj)
		end
	end

	return parts
end

local function hideResource(resourceRoot)
	for _, part in ipairs(getResourceParts(resourceRoot)) do
		part.Transparency = 1
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
	end
end

local function restoreResource(resourceRoot)
	for _, part in ipairs(getResourceParts(resourceRoot)) do
		local defaultTransparency = part:GetAttribute("DefaultTransparency")

		if defaultTransparency == nil then
			defaultTransparency = 0
		end

		part.Transparency = defaultTransparency
		part.CanCollide = true
		part.CanTouch = true
		part.CanQuery = true
	end

	local maxHealth = resourceRoot:GetAttribute("MaxHealth") or 10
	resourceRoot:SetAttribute("Health", maxHealth)
	resourceRoot:SetAttribute("Disabled", false)
end

local function rememberDefaultTransparency(resourceRoot)
	for _, part in ipairs(getResourceParts(resourceRoot)) do
		if part:GetAttribute("DefaultTransparency") == nil then
			part:SetAttribute("DefaultTransparency", part.Transparency)
		end
	end
end

function ResourceHitHandler.Handle(player, hitObject, itemName)
	if not player then return end
	if not hitObject then return end

	local resource = getResourceRoot(hitObject)
	if not resource then return end

	if resource:GetAttribute("Disabled") == true then return end

	rememberDefaultTransparency(resource)

	local health = resource:GetAttribute("Health")
	if not health or health <= 0 then return end

	local dropItem = resource:GetAttribute("DropItem")
	if not dropItem then
		warn("Resource has no DropItem:", resource.Name)
		return
	end

	local itemConfig = ctx.ItemConfig[itemName] or {}
	local harvestAmount = itemConfig.HarvestAmount or 1

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
	end

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
