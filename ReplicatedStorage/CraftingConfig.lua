local CraftingConfig = {}

CraftingConfig.Eras = {
	{
		Name = "Палки",

		Crafts = {
			{
				Id = "RoughWoodenTool",
				Name = "Грубий дерев'яний інструмент",

				Requirements = {
					["Ломака"] = 2,
				},
				
				Result = {
					Item = "Грубий дерев'яний інструмент",
					Amount = 1,
				},

				Unique = true,
			},
			
			{
				Id = "RoughtSpear",
				Name = "Заточена палка",

				Requirements = {
					["Ломака"] = 2,
				},

				Result = {
					Item = "Заточена палка",
					Amount = 1,
				},

				Unique = true,
			},
			
			{
				Id = "RoughtWoodenPlank",
				Name = "Груба дошка",
				
				Requirements = {
					["Ломака"] = 1,
				},

				Tools = {
					["Грубий дерев'яний інструмент"] = 1,
				},
				

				Result = {
					Item = "Груба дошка",
					Amount = 1,
				},

				Unique = false,
			},
			{
				Id = "PrimitiveTable",
				Name = "Примітивний стіл",

				Requirements = {
					["Груба дошка"] = 10,
				},

				Tools = {
					["Грубий дерев'яний інструмент"] = 1,
				},

				Result = {
					Item = "Примітивний стіл",
					Amount = 1,
				},

				Unique = false,
			},
			{
				Id = "ProcessedPlanks",
				Name = "Оброблена дошка",

				StationsAny = {
					"PrimitiveTable",
				},

				Requirements = {
					["Груба дошка"] = 2,
				},

				Tools = {
					["Грубий дерев'яний інструмент"] = 1,
				},

				Result = {
					Item = "Оброблена дошка",
					Amount = 1,
				},

				Unique = false,
			},
			
			{
				Id = "PrimitiveChest",
				Name = "Примітивний сундук",

				StationsAny = {
					"PrimitiveTable",
				},

				Requirements = {
					["Оброблена дошка"] = 6,
				},

				Tools = {
					["Грубий дерев'яний інструмент"] = 1,
				},

				Result = {
					Item = "Примітивний сундук",
					Amount = 1,
				},

				Unique = false,
			},
			
			{
				Id = "SharpStone",
				Name = "Точильний камінь",

				StationsAny = {
					"PrimitiveTable",
				},

				Requirements = {
					["Камінь"] = 1,
				},

				Tools = {
					["Грубий дерев'яний інструмент"] = 1,
				},

				Result = {
					Item = "Точильний камінь",
					Amount = 1,
				},

				Unique = false,
			},
			
			{
				Id = "MasterTable",
				Name = "Стіл майстра",

				StationsAny = {
					"PrimitiveTable",
				},

				Requirements = {
					["Оброблена дошка"] = 7,
					["Грубий дерев'яний інструмент"] = 1,
					["Точильний камінь"] = 1,
				},

				Tools = {
					["Грубий дерев'яний інструмент"] = 1,
				},

				Result = {
					Item = "Стіл майстра",
					Amount = 1,
				},

				Unique = false,
			},
		}
	},
}

return CraftingConfig