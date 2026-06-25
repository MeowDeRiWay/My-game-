local DamageResolver = {}

local MIN_DAMAGE = 1

function DamageResolver.Resolve(data)
	local item = data.Item or {}
	local target = data.Target or {}

	local damage = item.Damage or item.damage or 1
	local penetration = item.Penetration or item.penetration or 0
	local itemClass = item.Class or item.ItemClass or item.Type or "Unknown"

	local protection = target.Protection or 0
	local resistance = target.Resistance or 0
	local absorption = target.Absorption or 0
	local targetType = target.TargetType or "Unknown"

	local result = {
		Blocked = false,
		FinalDamage = 0,
		ShouldGiveResource = false,
		ResourceType = nil,
		ResourceAmount = 0,
		Message = "",
	}

	if penetration < protection then
		result.Blocked = true
		result.Message = "ЗХСТ"
		return result
	end

	local finalDamage = damage
	finalDamage = finalDamage * (1 - resistance)
	finalDamage = finalDamage - absorption

	if finalDamage > 0 then
		finalDamage = math.max(MIN_DAMAGE, math.floor(finalDamage + 0.5))
	else
		finalDamage = 0
	end

	result.FinalDamage = finalDamage
	result.Message = finalDamage > 0 and tostring(finalDamage) or "Без шкоди"

	if targetType == "Resource" and itemClass == "Tool" then
		result.ShouldGiveResource = true
		result.ResourceType = target.ResourceType
		result.ResourceAmount = item.HarvestAmount or item.harvestAmount or 1
	end

	return result
end

return DamageResolver
