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

	if hitObject:GetAttribute("ResourceType") then
		return hitObject
	end

	local current = hitObject.Parent
	while current do
		if current:GetAttribute("ResourceType") then
			return current
		end
		current = current.Parent
	end

	return nil
end

local function getResourceParts(resourceRoot)
	local parts = {}

	local visualRoot = resourceRoot

	if resourceRoot:IsA("Model") then
		local main = resourceRoot:FindFirstChild("Main")

		if main then
			visualRoot = main
		end
	end

	if visualRoot:IsA("BasePart") then
		table.insert(parts, visualRoot)
	end

	for _, obj in ipairs(visualRoot:GetDescendants()) do
		if obj:IsA("BasePart") then
			table.insert(parts, obj)
		end
	end

	return parts
end

local function rememberDefaults(resourceRoot)
	for _, part in ipairs(getResourceParts(resourceRoot)) do
		if part:GetAttribute("DefaultTransparency") == nil then
			part:SetAttribute("DefaultTransparency", part.Transparency)
		end

		if part:GetAttribute("DefaultCanCollide") == nil then
			part:SetAttribute("DefaultCanCollide", part.CanCollide)
		end

		if part:GetAttribute("DefaultCanTouch") == nil then
			part:SetAttribute("DefaultCanTouch", part.CanTouch)
		end

		if part:GetAttribute("DefaultCanQuery") == nil then
			part:SetAttribute("DefaultCanQuery", part.CanQuery)
		end
	end
end

local function setResourceVisible(resourceRoot, visible)
	for _, part in ipairs(getResourceParts(resourceRoot)) do
		if visible then
			part.Transparency = part:GetAttribute("DefaultTransparency") or 0
			part.CanCollide = part:GetAttribute("DefaultCanCollide")
			part.CanTouch = part:GetAttribute("DefaultCanTouch")
			part.CanQuery = part:GetAttribute("DefaultCanQuery")
		else
			part.Transparency = 1
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
		end
	end
end

function ResourceHitHandler.Handle(player, hitObject, itemName)
	if not player or not hitObject then return end

	local resource = getResourceRoot(hitObject)
	if not resource then return end
	if resource:GetAttribute("Disabled") == true then return end

	rememberDefaults(resource)

	local health = resource:GetAttribute("Health")
	if not health or health <= 0 then return end

	local dropItem = resource:GetAttribute("DropItem")
	if not dropItem then
		warn("Resource has no DropItem:", resource.Name)
		return
	end

	local itemConfig = ctx.ItemConfig[itemName] or {}
	local harvestAmount = itemConfig.HarvestAmount or 1

	local result = ctx.DamageResolver.Resolve({
		Item = {
			Damage = itemConfig.Damage or 1,
			Penetration = itemConfig.Penetration or 0,
			Class = itemConfig.Type or "Unknown",
			HarvestAmount = itemConfig.HarvestAmount or 1,
		},

		Target = {
			Protection = resource:GetAttribute("Protection") or 0,
			Resistance = resource:GetAttribute("Resistance") or 0,
			Absorption = resource:GetAttribute("Absorption") or 0,
			TargetType = resource:GetAttribute("TargetType") or "Resource",
			ResourceType = resource:GetAttribute("ResourceType"),
		}
	})

	if ctx.DamagePopup then
		ctx.DamagePopup:FireClient(player, resource, result.Message)
	end

	if result.Blocked then return end

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

	if health > 0 then return end

	resource:SetAttribute("Disabled", true)
	setResourceVisible(resource, false)

	task.delay(ctx.SpawnTime, function()
		if not resource or not resource.Parent then return end

		local maxHealth = resource:GetAttribute("MaxHealth") or 10
		resource:SetAttribute("Health", maxHealth)
		resource:SetAttribute("Disabled", false)

		setResourceVisible(resource, true)
	end)
end

return ResourceHitHandler
