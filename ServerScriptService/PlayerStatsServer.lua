local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerStatsConfig = require(ReplicatedStorage:WaitForChild("PlayerStatsConfig"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlayerStatsUpdate = Remotes:FindFirstChild("PlayerStatsUpdate")
if not PlayerStatsUpdate then
	PlayerStatsUpdate = Instance.new("RemoteEvent")
	PlayerStatsUpdate.Name = "PlayerStatsUpdate"
	PlayerStatsUpdate.Parent = Remotes
end

local SprintStateRequest = Remotes:FindFirstChild("SprintStateRequest")
if not SprintStateRequest then
	SprintStateRequest = Instance.new("RemoteEvent")
	SprintStateRequest.Name = "SprintStateRequest"
	SprintStateRequest.Parent = Remotes
end

local MAX_HEALTH = PlayerStatsConfig.MaxHealth
local MAX_STAMINA = PlayerStatsConfig.MaxStamina

local NORMAL_SPEED = PlayerStatsConfig.NormalSpeed
local SPRINT_SPEED = PlayerStatsConfig.SprintSpeed

local STAMINA_DRAIN_PER_SECOND = PlayerStatsConfig.StaminaDrainPerSecond
local STAMINA_REGEN_PER_SECOND = PlayerStatsConfig.StaminaRegenPerSecond

local stats = {}

local function sendStats(player)
	local data = stats[player]
	if not data then return end

	PlayerStatsUpdate:FireClient(player, {
		Health = math.floor(data.Health + 0.5),
		MaxHealth = data.MaxHealth,
		Stamina = math.floor(data.Stamina + 0.5),
		MaxStamina = data.MaxStamina,
		IsSprinting = data.IsSprinting,
	})
end

local function setHumanoidSpeed(player, speed)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	humanoid.WalkSpeed = speed
end

local function setupCharacter(player, character)
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.MaxHealth = MAX_HEALTH
	humanoid.Health = MAX_HEALTH
	humanoid.WalkSpeed = NORMAL_SPEED

	local data = stats[player]
	if data then
		data.Health = MAX_HEALTH
		data.Stamina = MAX_STAMINA
		data.IsSprinting = false
	end

	sendStats(player)
end

Players.PlayerAdded:Connect(function(player)
	stats[player] = {
		Health = MAX_HEALTH,
		MaxHealth = MAX_HEALTH,
		Stamina = MAX_STAMINA,
		MaxStamina = MAX_STAMINA,
		IsSprinting = false,
	}

	player.CharacterAdded:Connect(function(character)
		setupCharacter(player, character)
	end)

	sendStats(player)
end)

Players.PlayerRemoving:Connect(function(player)
	stats[player] = nil
end)

SprintStateRequest.OnServerEvent:Connect(function(player, wantsSprint)
	local data = stats[player]
	if not data then return end

	if wantsSprint and data.Stamina > 0 then
		data.IsSprinting = true
		setHumanoidSpeed(player, SPRINT_SPEED)
	else
		data.IsSprinting = false
		setHumanoidSpeed(player, NORMAL_SPEED)
	end

	sendStats(player)
end)

task.spawn(function()
	while true do
		task.wait(0.1)

		for player, data in pairs(stats) do
			local changed = false

			local character = player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				data.Health = math.floor(humanoid.Health + 0.5)

				if data.IsSprinting then
					data.Stamina -= STAMINA_DRAIN_PER_SECOND * 0.1

					if data.Stamina <= 0 then
						data.Stamina = 0
						data.IsSprinting = false
						humanoid.WalkSpeed = NORMAL_SPEED
					end

					changed = true
				else
					if data.Stamina < data.MaxStamina then
						data.Stamina += STAMINA_REGEN_PER_SECOND * 0.1

						if data.Stamina > data.MaxStamina then
							data.Stamina = data.MaxStamina
						end

						changed = true
					end
				end
			end

			if changed then
				sendStats(player)
			end
		end
	end
end)
