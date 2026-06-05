local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local CAMERA_HEIGHT = 35

camera.CameraType = Enum.CameraType.Scriptable

RunService.RenderStepped:Connect(function()
	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Камера строго зверху
	local rootPos = root.Position

	camera.CFrame = CFrame.new(
		rootPos + Vector3.new(0, CAMERA_HEIGHT, 0),
		rootPos
	)

	-- Поворот квадратика лицем до курсора
	local mousePos = mouse.Hit.Position

	local lookPos = Vector3.new(
		mousePos.X,
		rootPos.Y,
		mousePos.Z
	)

	local direction = lookPos - rootPos

	if direction.Magnitude > 0.1 then
		root.CFrame = CFrame.lookAt(rootPos, rootPos + direction)
	end
end)