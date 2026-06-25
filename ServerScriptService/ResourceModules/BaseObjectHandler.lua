local BaseObjectHandler = {}

local BaseObjectPlace = require(script.Parent:WaitForChild("BaseObjectPlace"))
local BaseObjectInteract = require(script.Parent:WaitForChild("BaseObjectInteract"))

local context = nil

function BaseObjectHandler.Init(ctx)
	context = ctx

	BaseObjectPlace.Init(ctx)
	BaseObjectInteract.Init(ctx)
end

function BaseObjectHandler.Handle(player, action, data, itemName)
	if not context then
		warn("[BaseObjectHandler] context is nil")
		return
	end

	if action == "Place" then
		BaseObjectPlace.Run(player, data, itemName)
		return
	end

	if action == "Interact" then
		BaseObjectInteract.Run(player, data)
		return
	end

	if action == "Damage" then
		context.ObjectHitHandler.Handle(player, data, itemName)
		return
	end

	warn("[BaseObjectHandler] Unknown action:", action)
end

return BaseObjectHandler
