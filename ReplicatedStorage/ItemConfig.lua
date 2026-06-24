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
		Type = "CloseCombat",
		ToolClass = "TwoHandedClose",
		ModelName = "RoughtSpearModel",
		Stackable = false,
		Damage = 5,
		Penetration = 2,
		HarvestAmount = 0,
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
		ReloadTime = 0,
		ShotDelay = 0,
		FireCooldown = 2,

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
		
		HarvestAmount = 0,
		
		ProjectileSpeed = 80,
		MaxDistance = 250,

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
	
	["Ящик"] = {
		Name = "Ящик",
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
		ModelName = "WoodenToolModel",
		Stackable = false,
		Damage = 1,
		HarvestAmount = 3,
		Penetration = 2,
		Icon = "",
	},
	
	["Кам'яна лопата"] = {
		Name = "Кам'яна лопата",
		Type = "Tool",
		ToolClass = "OneHandedClose",
		Stackable = false,
		Damage = 3,
		HarvestAmount = 0,
		Penetration = 2,
		Icon = "",
	},
	
	["Робочий стіл"] = {
		Name = "Робочий стіл",
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
	
	["Мушкет"] = {
		Name = "Мушкет",
		Type = "RangeWeapon",
		ToolClass = "Mushket",

		Stackable = false,

		AcceptedAmmoFamilies = {
			MushketBall = true,
		},

		ModelFolder = "Prehistorical",
		ModelName = "MushketModel",

		MagazineSize = 1,
		ReloadTime = 0,
		ShotDelay = 0,
		FireCooldown = 1,

		DamageMultiplier = 1.0,
		ProjectileSpeedMultiplier = 1.0,
		MaxDistanceMultiplier = 1.0,

		Icon = "",
	},
	
	["Мушкетна куля"] = {
		Name = "Мушкетна куля",
		Type = "Ammo",

		AmmoFamily = "MushketBall",
		Projectile = "MushketBallModel",

		Stackable = true,

		Damage = 10,
		Penetration = 2,
		
		HarvestAmount = 0,
		
		ProjectileSpeed = 350,
		MaxDistance = 250,

		Icon = "",
	},
}

return ItemConfig
