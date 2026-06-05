local BaseObjectHandler = {}

local ctx = {}

function BaseObjectHandler.Init(context)
	ctx = context
end

local function getModelTemplate(config, itemName)
	local modelFolderName = config.ModelFolder
	local modelName = config.ModelName

	if not modelFolderName then
		warn("У предмета немає ModelFolder:", itemName)
		return nil
	end

	if not modelName then
		warn("У предмета немає ModelName:", itemName)
		return nil
	end

	local modelFolder = ctx.BaseObjectsStorage:FindFirstChild(modelFolderName)

	if not modelFolder then
		warn("Папка моделей не знайдена в Base.Obj:", modelFolderName)
		return nil
	end

	local modelTemplate = modelFolder:FindFirstChild(modelName)

	if not modelTemplate then
		warn("Модель не знайдена в Base.Obj/" .. modelFolderName .. ":", modelName)
		return nil
	end

	return modelTemplate
end

local function placeObject(player, position, itemName)
	local config = ctx.ItemConfig[itemName]

	if not config then return end
	if config.Type ~= "BasePlaceable" then return end

	if not ctx.HasItem(player, itemName, 1) then
		return
	end

	local modelTemplate = getModelTemplate(config, itemName)
	if not modelTemplate then return end

	ctx.RemoveItem(player, itemName, 1)

	local object = modelTemplate:Clone()
	object.Name = itemName
	object.Parent = ctx.BaseObjectsFolder

	object:PivotTo(CFrame.new(position.X, position.Y, position.Z))

	for _, descendant in ipairs(object:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = true
		end
	end

	object:SetAttribute("ObjectType", config.ObjectType)
	object:SetAttribute("BaseType", config.BaseType)
	object:SetAttribute("MaterialType", config.MaterialType)

	object:SetAttribute("Health", config.MaxHealth)
	object:SetAttribute("MaxHealth", config.MaxHealth)

	object:SetAttribute("Protection", config.Protection or 0)
	object:SetAttribute("Resistance", config.Resistance or 0)
	object:SetAttribute("Absorption", config.Absorption or 0)

	ctx.SendInventory(player)
end

local function interactObject(player, object)
	if not object then return end

	if object:GetAttribute("ObjectType") == "PrimitiveTable" then
		ctx.BaseObjectRequest:FireClient(
			player,
			"OpenCrafting",
			"PrimitiveTable"
		)
	end
end

local function damageObject(player, object, itemName)
	if not object then return end
	if object:GetAttribute("BaseType") ~= "base" then return end

	local health = object:GetAttribute("Health")
	if not health then return end

	local itemConfig = ctx.ItemConfig[itemName] or {}

	local result = ctx.DamageResolver.Resolve(
		{
			Damage = itemConfig.Damage or 1,
			Penetration = itemConfig.Penetration or 0,
		},
		{
			Protection = object:GetAttribute("Protection") or 0,
			Resistance = object:GetAttribute("Resistance") or 0,
			Absorption = object:GetAttribute("Absorption") or 0,
		}
	)

	if ctx.DamagePopup then
		ctx.DamagePopup:FireClient(player, object, result.Message)
	end

	if result.Blocked then
		return
	end

	health -= result.FinalDamage
	object:SetAttribute("Health", health)

	if health <= 0 then
		object:Destroy()
	end
end

function BaseObjectHandler.Handle(player, action, data, itemName)
	if action == "Place" then
		placeObject(player, data, itemName)
		return
	end

	if action == "Interact" then
		interactObject(player, data)
		return
	end

	if action == "Damage" then
		damageObject(player, data, itemName)
		return
	end
end

return BaseObjectHandler