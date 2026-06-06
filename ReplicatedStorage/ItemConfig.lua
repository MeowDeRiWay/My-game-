local ItemConfig = {

	["Рука"] = {
		Name = "Рука",
		Type = "Tool",
		Stackable = false,
		HarvestAmount = 1,
		Damage = 1,
		Penetration = 0,
		Icon = "",
	},
	
	["Грубий дерев'яний інструмент"] = {
		Name = "Грубий дерев'яний інструмент",
		Type = "Tool",
		Stackable = false,
		Damage = 1,
		HarvestAmount = 2,
		Penetration = 1,
		Icon = "",
	},

	["Ломака"] = {
		Name = "Ломака",
		Type = "Resource",
		Stackable = true,
		HarvestAmount = 0,
		Damage = 1,
		Penetration = 0,
		Icon = "",
	},
	
	["Груба дошка"] = {
		Name = "Груба дошка",
		Type = "Resource",
		Stackable = true,
		Damage = 1,
		HarvestAmount = 0,
		Penetration = 0,
		Icon = "",
	},
	
	["Примітивний стіл"] = {
		Name = "Примітивний стіл",
		Type = "BasePlaceable",
		Stackable = true,

		ObjectType = "workbench",
		ObjectId = "PrimitiveTable",
		BaseType = "base",
		MaterialType = "wood",

		ModelFolder = "Era_1",
		ModelName = "PrimitiveTableModel",
		
		Protection = 1,
		Resistance = 0,
		Absorption = 0,
		MaxHealth = 20,
		Icon = "",
	},

	["Оброблені дошки"] = {
		Name = "Оброблена дошка",
		Type = "Resource",
		Stackable = true,
		Damage = 1,
		HarvestAmount = 0,
		Penetration = 0,
		Icon = "",
	},
	
	["Примітивний сундук"] = {
		Name = "Примітивний сундук",
		Type = "BasePlaceable",
		Stackable = true,

		ObjectType = "storage",
		ObjectId = "PrimitiveChest",
		
		BaseType = "base",
		MaterialType = "wood",

		ModelFolder = "Era_1",
		ModelName = "PrimitiveChestModel",
		
		Protection = 1,
		Resistance = 0,
		Absorption = 0,
		MaxHealth = 50,
		StorageCapacity = 50,
		Icon = "",
	},
}

return ItemConfig
