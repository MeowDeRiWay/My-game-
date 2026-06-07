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
	
	["Ломака"] = {
		Name = "Ломака",
		Type = "Resource",
		Stackable = true,
		HarvestAmount = 0,
		Damage = 1,
		Penetration = 0,
		Icon = "",
	},
	
	["Грубий дерев'яний інструмент"] = {
		Name = "Грубий дерев'яний інструмент",
		Type = "Tool",
		ToolClass = "OneHandedClose",
		ModelName = "RoughWoodenToolModel",
		Stackable = false,
		Damage = 1,
		HarvestAmount = 2,
		Penetration = 1,
		Icon = "",
	},
	
	["Заточена палка"] = {
		Name = "Заточена палка",
		Type = "MaleWeapon",
		ToolClass = "TwoHandedClose",
		ModelName = "RoughtSpearModel",
		Stackable = false,
		Damage = 5,
		Penetration = 2,
		Icon = "",
	},
	
	["Простий лук"] = {
		Name = "Простий лук",
		Type = "RangeWeapon",
		ToolClass = "Bow",

		Stackable = false,

		AcceptedAmmoFamilies = {
			Arrow = true,
		},

		ModelFolder = "Prehistorical",
		ModelName = "PrimitiveBowModel",

		MagazineSize = 1,
		ReloadTime = 1.2,
		ShotDelay = 0.1,
		FireCooldown = 0.9,

		DamageMultiplier = 1.0,
		ProjectileSpeedMultiplier = 1.0,
		MaxDistanceMultiplier = 1.0,

		Icon = "",
	},

	["Примітивна стріла"] = {
		Name = "Примітивна стріла",
		Type = "Ammo",

		AmmoFamily = "Arrow",
		Projectile = "WoodenArrowModel",

		Stackable = true,

		Damage = 10,
		Penetration = 2,

		ProjectileSpeed = 10,
		MaxDistance = 30,

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
		MaxHealth = 10,
		Icon = "",
	},

	["Оброблена дошка"] = {
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
		MaxHealth = 10,
		StorageCapacity = 50,
		Icon = "",
	},
	
	["Камінь"] = {
		Name = "Камінь",
		Type = "Resource",
		Stackable = true,
		Damage = 1,
		HarvestAmount = 0,
		Penetration = 2,
		Icon = "",
	},
	
	["Точильний камінь"] = {
		Name = "Точильний камінь",
		Type = "Resource",
		Stackable = true,
		Damage = 1,
		HarvestAmount = 0,
		Penetration = 0,
		Icon = "",
	},
	
	["Знаряддя праці"] = {
		Name = "Знаряддя праці",
		Type = "Tool",
		ToolClass = "OneHandedClose",
		ModelName = "MasterToolModel",
		Stackable = false,
		Damage = 1,
		HarvestAmount = 3,
		Penetration = 2,
		Icon = "",
	},
	
	["Проста лопата"] = {
		Name = "Проста лопата",
		Type = "Tool",
		ToolClass = "OneHandedClose",
		Stackable = false,
		Damage = 3,
		HarvestAmount = 0,
		Penetration = 2,
		Icon = "",
	},
	
	["Стіл майстра"] = {
		Name = "Стіл майстра",
		Type = "BasePlaceable",
		Stackable = true,

		ObjectType = "workbench",
		ObjectId = "MasterTable",
		BaseType = "base",
		MaterialType = "wood",

		ModelFolder = "Era_2",
		ModelName = "MasterTableModel",

		Protection = 1,
		Resistance = 0,
		Absorption = 0,
		MaxHealth = 10,
		Icon = "",
	},
}

return ItemConfig