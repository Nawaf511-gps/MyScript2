-- ===== Teleport Tool UI by Kevyr (BIG + / - Buttons | MoveDirection + Distance) with Camera Follow =====

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- الإعدادات
local TeleportDistance = 80
local MinDistance = 10
local MaxDistance = 300
local Step = 10
local Locked = false
local CameraFollow = true -- تفعيل متابعة الكاميرا

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 160, 0, 95)
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.Position = UDim2.new(1, -60, 1, -10)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- العنوان
local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, 0, 0.18, 0)
Label.Text = "Script by Kevyr"
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.BackgroundTransparency = 1
Label.TextScaled = true

-- زر التليبورت
local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1, 0, 0.42, 0)
Button.Position = UDim2.new(0, 0, 0.18, 0)
Button.Text = "TP TOOL"
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.BackgroundColor3 = Color3.fromRGB(15,15,15)
Button.TextScaled = true
Button.BorderSizePixel = 0

-- عرض المسافة
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = Frame
SpeedLabel.Size = UDim2.new(1, 0, 0.15, 0)
SpeedLabel.Position = UDim2.new(0, 0, 0.6, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.TextScaled = true

local function UpdateText()
	SpeedLabel.Text = "Speed : " .. TeleportDistance
end
UpdateText()

-- زر (-) كبير
local Minus = Instance.new("TextButton")
Minus.Parent = Frame
Minus.Size = UDim2.new(0.45, 0, 0.25, 0)
Minus.Position = UDim2.new(0.03, 0, 0.75, 0)
Minus.Text = "-"
Minus.TextScaled = true
Minus.BackgroundColor3 = Color3.fromRGB(35,35,35)
Minus.TextColor3 = Color3.fromRGB(255,255,255)
Minus.BorderSizePixel = 0
Minus.AutoButtonColor = true

-- زر (+) كبير
local Plus = Instance.new("TextButton")
Plus.Parent = Frame
Plus.Size = UDim2.new(0.45, 0, 0.25, 0)
Plus.Position = UDim2.new(0.52, 0, 0.75, 0)
Plus.Text = "+"
Plus.TextScaled = true
Plus.BackgroundColor3 = Color3.fromRGB(35,35,35)
Plus.TextColor3 = Color3.fromRGB(255,255,255)
Plus.BorderSizePixel = 0
Plus.AutoButtonColor = true

-- زر القفل
local LockButton = Instance.new("TextButton")
LockButton.Parent = Frame
LockButton.Size = UDim2.new(0, 20, 0, 20)
LockButton.Position = UDim2.new(0, 4, 1, -24)
LockButton.Text = "🔓"
LockButton.TextScaled = true
LockButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
LockButton.TextColor3 = Color3.fromRGB(255,255,255)
LockButton.BorderSizePixel = 0
LockButton.ZIndex = 10

LockButton.MouseButton1Click:Connect(function()
	Locked = not Locked
	Frame.Draggable = not Locked
	LockButton.Text = Locked and "🔒" or "🔓"
end)

-- تغيير المسافة
Minus.MouseButton1Click:Connect(function()
	TeleportDistance = math.clamp(TeleportDistance - Step, MinDistance, MaxDistance)
	UpdateText()
end)

Plus.MouseButton1Click:Connect(function()
	TeleportDistance = math.clamp(TeleportDistance + Step, MinDistance, MaxDistance)
	UpdateText()
end)

-- التليبورت
local function TeleportForward()
	local Character = LocalPlayer.Character
	if not Character then return end

	local HRP = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChild("Humanoid")
	if not HRP or not Humanoid then return end

	local MoveDir = Humanoid.MoveDirection
	if MoveDir.Magnitude == 0 then return end

	local FlatDir = Vector3.new(MoveDir.X, 0, MoveDir.Z).Unit
	local NewPosition = HRP.Position + (FlatDir * TeleportDistance)

	HRP.CFrame = CFrame.new(NewPosition, NewPosition + FlatDir)

	if CameraFollow then
		local Camera = workspace.CurrentCamera
		Camera.CameraSubject = HRP
		Camera.CameraType = Enum.CameraType.Custom
	end
end

Button.MouseButton1Click:Connect(TeleportForward)

RunService.RenderStepped:Connect(function()
	if CameraFollow then
		local Character = LocalPlayer.Character
		if Character and Character:FindFirstChild("HumanoidRootPart") then
			workspace.CurrentCamera.CameraSubject = Character.HumanoidRootPart
		end
	end
end)
