local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local DamagePopupEvent = Remotes:WaitForChild("DamagePopupEvent")

local function getAdornee(target)
	if not target then
		return nil
	end

	if target:IsA("BasePart") then
		return target
	end

	if target:IsA("Model") then
		return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
	end

	return nil
end

local function showDamagePopup(target, damage)
	local adornee = getAdornee(target)
	if not adornee then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.fromOffset(80, 40)
	billboard.StudsOffset = Vector3.new(
		math.random(-15, 15) / 10,
		3,
		math.random(-15, 15) / 10
	)
	billboard.AlwaysOnTop = true
	billboard.Adornee = adornee
	billboard.Parent = adornee

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "-" .. tostring(damage)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.fromRGB(255, 80, 80)
	label.TextStrokeTransparency = 0
	label.Parent = billboard

	local moveTween = TweenService:Create(
		billboard,
		TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			StudsOffset = billboard.StudsOffset + Vector3.new(0, 2, 0)
		}
	)

	local fadeTween = TweenService:Create(
		label,
		TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}
	)

	moveTween:Play()
	fadeTween:Play()

	Debris:AddItem(billboard, 0.8)
end

DamagePopupEvent.OnClientEvent:Connect(function(target, damage)
	showDamagePopup(target, damage)
end)