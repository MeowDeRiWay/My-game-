local DamageResolver = {}

DamageResolver.MinDamage = 1

function DamageResolver.Resolve(damageInfo, defenseInfo)
	damageInfo = damageInfo or {}
	defenseInfo = defenseInfo or {}

	local baseDamage = damageInfo.Damage or DamageResolver.MinDamage
	local penetration = damageInfo.Penetration or 0

	local protection = defenseInfo.Protection or 0
	local resistance = defenseInfo.Resistance or 0
	local absorption = defenseInfo.Absorption or 0

	-- Захист не пробитий
	if penetration < protection then
		return {
			Blocked = true,
			FinalDamage = 0,
			Message = "зхст",
		}
	end

	-- Тимчасова базова формула
	local finalDamage = baseDamage

	finalDamage = finalDamage * (1 - resistance)
	finalDamage = finalDamage - absorption
	finalDamage = math.floor(finalDamage + 0.5)

	if finalDamage < DamageResolver.MinDamage then
		finalDamage = DamageResolver.MinDamage
	end

	return {
		Blocked = false,
		FinalDamage = finalDamage,
		Message = tostring(finalDamage),
	}
end

return DamageResolver