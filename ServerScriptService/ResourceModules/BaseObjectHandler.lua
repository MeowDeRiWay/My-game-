local BaseObjectHandler = {}

local BaseObjectPlace = require(script:WaitForChild("BaseObjectPlace"))
local BaseObjectInteract = require(script:WaitForChild("BaseObjectInteract"))
local BaseObjectDamage = require(script:WaitForChild("BaseObjectDamage"))

function BaseObjectHandler.Init(context)
	BaseObjectPlace.Init(context)
	BaseObjectInteract.Init(context)
	BaseObjectDamage.Init(context)
end

function BaseObjectHandler.Handle(player, action, data, itemName)
	if action == "Place" then
		BaseObjectPlace.Run(player, data, itemName)
		return
	end

	if action == "Interact" then
		BaseObjectInteract.Run(player, data)
		return
	end

	if action == "Damage" then
		BaseObjectDamage.Run(player, data, itemName)
		return
	end
end

return BaseObjectHandler
