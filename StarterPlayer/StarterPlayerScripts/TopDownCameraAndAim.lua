-- StarterPlayerScripts/FirstPersonCamera.client.lua

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local COMBAT_MODE = "Бій"
local INTERACT_MODE = "Спокій"

local currentMode = INTERACT_MODE
local uiOpen = false

local sensitivity = 0.25
local yaw = 0
local pitch = 0

local MIN_PITCH = -75
local MAX_PITCH = 75

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function setupPlayerCameraLimits()
	player.CameraMode = Enum.CameraMode.Classic
	player.CameraMinZoomDistance = 0.5
	player.CameraMaxZoomDistance = 0.5
end

local function setMouseState()
	if uiOpen then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
		return
	end

	if currentMode == COMBAT_MODE then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	end
end

local function setMode(mode)
	currentMode = mode
	setMouseState()
end

-- Тимчасово: Q перемикає режим.
-- Якщо у тебе вже є окремий ModeController, потім підв'яжемося до нього через BindableEvent/Attribute.
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.Q then
		if currentMode == COMBAT_MODE then
			setMode(INTERACT_MODE)
		else
			setMode(COMBAT_MODE)
		end
	end
end)

-- Тут можна буде викликати з інвентаря/крафту:
_G.SetGameplayUIOpen = function(isOpen)
	uiOpen = isOpen == true
	setMouseState()
end

RunService.RenderStepped:Connect(function()
	local character = getCharacter()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")

	if not humanoidRootPart or not head then return end

	if uiOpen then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
		camera.CameraType = Enum.CameraType.Custom
		return
	end
	
	setupPlayerCameraLimits()

	if currentMode == COMBAT_MODE and not uiOpen then
		local delta = UserInputService:GetMouseDelta()

		yaw -= delta.X * sensitivity
		pitch = math.clamp(pitch - delta.Y * sensitivity, MIN_PITCH, MAX_PITCH)

		humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, math.rad(yaw), 0)

		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame =
			CFrame.new(head.Position)
			* CFrame.Angles(0, math.rad(yaw), 0)
			* CFrame.Angles(math.rad(pitch), 0, 0)
	else
		camera.CameraType = Enum.CameraType.Custom
	end

	setMouseState()
end)

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	setupPlayerCameraLimits()
	setMouseState()
end)
