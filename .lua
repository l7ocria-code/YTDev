herelocal Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Seleção automática e segura de ambiente para Mobile Executors
local TargetGui = LocalPlayer:WaitForChild("PlayerGui")
local success, coreName = pcall(function() return game:GetService("CoreGui").Name end)
if success and game:GetService("CoreGui") then TargetGui = game:GetService("CoreGui") end

if TargetGui:FindFirstChild("YtDevs") then TargetGui.YtDevs:Destroy() end
if TargetGui:FindFirstChild("YtDevsFreeCam") then TargetGui.YtDevsFreeCam:Destroy() end

local YT = { FreeActive = false, FreezeActive = false, Conn = nil, Speed = 40, Move = Vector3.new() }

-- Sistema de arrastar a interface (Touch)
local function MakeDraggable(obj)
	local drag, start, dStart
	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true dStart = i.Position start = obj.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
		end
	end)
	obj.InputChanged:Connect(function(i)
		if (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) and drag then
			local delta = i.Position - dStart
			obj.Position = UDim2.new(start.X.Scale, start.X.Offset + delta.X, start.Y.Scale, start.Y.Offset + delta.Y)
		end
	end)
end

-- Criando a Interface Principal
local Screen = Instance.new("ScreenGui", TargetGui) Screen.Name = "YtDevs" Screen.ResetOnSpawn = false
local Main = Instance.new("Frame", Screen) Main.Size = UDim2.new(0, 260, 0, 200) Main.Position = UDim2.new(0.5, -130, 0.4, -100) Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 0)
MakeDraggable(Main)

local Title = Instance.new("TextLabel", Main) Title.Size = UDim2.new(1, 0, 0, 35) Title.Text = "YTDEVS MOBILE" Title.TextColor3 = Color3.new(1, 1, 1) Title.Font = Enum.Font.GothamBlack Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)

local Close = Instance.new("TextButton", Main) Close.Size = UDim2.new(0, 30, 0, 30) Close.Position = UDim2.new(1, -35, 0, 2) Close.Text = "X" Close.BackgroundColor3 = Color3.fromRGB(180, 0, 0) Close.TextColor3 = Color3.new(1, 1, 1) Instance.new("UICorner", Close)
local Min = Instance.new("TextButton", Main) Min.Size = UDim2.new(0, 30, 0, 30) Min.Position = UDim2.new(1, -70, 0, 2) Min.Text = "—" Min.BackgroundColor3 = Color3.fromRGB(60, 60, 65) Min.TextColor3 = Color3.new(1, 1, 1) Instance.new("UICorner", Min)

local Circle = Instance.new("Frame", Screen) Circle.Size = UDim2.new(0, 55, 0, 55) Circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0) Circle.Visible = false Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
local Clbl = Instance.new("TextLabel", Circle) Clbl.Size = UDim2.new(1, 0, 1, 0) Clbl.Text = "YT" Clbl.TextColor3 = Color3.new(1, 1, 1) Clbl.Font = Enum.Font.GothamBlack Clbl.BackgroundTransparency = 1
MakeDraggable(Circle)

Min.MouseButton1Click:Connect(function() Main.Visible = false Circle.Position = Main.Position Circle.Visible = true end)
Circle.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		local sPos = i.Position
		local c; c = i.Changed:Connect(function()
			if i.UserInputState == Enum.UserInputState.End then
				if (i.Position - sPos).Magnitude < 10 then Main.Position = Circle.Position Circle.Visible = false Main.Visible = true end
				c:Disconnect()
			end
		end)
	end
end)

local B1 = Instance.new("TextButton", Main) B1.Size = UDim2.new(1, -40, 0, 45) B1.Position = UDim2.new(0, 20, 0, 55) B1.Text = "FREEZE CAM: OFF" B1.BackgroundColor3 = Color3.fromRGB(50, 50, 55) B1.TextColor3 = Color3.new(1, 1, 1) B1.Font = Enum.Font.GothamBold Instance.new("UICorner", B1)
local B2 = Instance.new("TextButton", Main) B2.Size = UDim2.new(1, -40, 0, 45) B2.Position = UDim2.new(0, 20, 0, 115) B2.Text = "FREE CAM: OFF" B2.BackgroundColor3 = Color3.fromRGB(50, 50, 55) B2.TextColor3 = Color3.new(1, 1, 1) B2.Font = Enum.Font.GothamBold Instance.new("UICorner", B2)

-- Controles Virtuais do Drone
local Mobile = Instance.new("ScreenGui", TargetGui) Mobile.Name = "YtDevsFreeCam" Mobile.Enabled = false
local function CBtn(n, t, p, s)
	local b = Instance.new("TextButton", Mobile) b.Name = n b.Size = s b.Position = p b.BackgroundColor3 = Color3.new() b.BackgroundTransparency = 0.4 b.TextColor3 = Color3.new(1, 1, 1) b.Text = t b.Font = Enum.Font.GothamBold
	Instance.new("UICorner", b) return b
end
local padX, padY = 0.15, 0.75
local tF = CBtn("F", "▲", UDim2.new(padX, -25, padY, -55), UDim2.new(0, 50, 0, 50))
local tB = CBtn("B", "▼", UDim2.new(padX, -25, padY, 55), UDim2.new(0, 50, 0, 50))
local tL = CBtn("L", "◄", UDim2.new(padX, -80, padY, 0), UDim2.new(0, 50, 0, 50))
local tR = CBtn("R", "►", UDim2.new(padX, 30, padY, 0), UDim2.new(0, 50, 0, 50))
local tU = CBtn("U", "SUBIR", UDim2.new(0.85, -45, padY, -30), UDim2.new(0, 90, 0, 45))
local tD = CBtn("D", "DESCER", UDim2.new(0.85, -45, padY, 25), UDim2.new(0, 90, 0, 45))

local function SetupTouch(b, dir)
	b.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then YT.Move = YT.Move + dir end end)
	b.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then YT.Move = YT.Move - dir end end)
end
SetupTouch(tF, Vector3.new(0,0,-1)) SetupTouch(tB, Vector3.new(0,0,1)) SetupTouch(tL, Vector3.new(-1,0,0)) SetupTouch(tR, Vector3.new(1,0,0)) SetupTouch(tU, Vector3.new(0,1,0)) SetupTouch(tD, Vector3.new(0,-1,0))

-- Mecânica de Câmera
local function Reset()
	YT.FreeActive = false YT.FreezeActive = false Mobile.Enabled = false
	if YT.Conn then YT.Conn:Disconnect() YT.Conn = nil end
	Camera.CameraType = Enum.CameraType.Custom
	local c = LocalPlayer.Character if c and c:FindFirstChild("Humanoid") then Camera.CameraSubject = c.Humanoid end
	B1.Text = "FREEZE CAM: OFF" B1.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
	B2.Text = "FREE CAM: OFF" B2.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end

B1.MouseButton1Click:Connect(function()
	if YT.FreezeActive then Reset() else
		Reset() local c = LocalPlayer.Character
		if c and c:FindFirstChild("Head") then
			YT.FreezeActive = true B1.Text = "FREEZE CAM: ON" B1.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
			Camera.CameraType = Enum.CameraType.Scriptable
			Camera.CFrame = CFrame.new(c.Head.Position + (c.Head.CFrame.LookVector * 8), c.Head.Position)
		end
	end
end)

B2.MouseButton1Click:Connect(function()
	if YT.FreeActive then Reset() else
		Reset() YT.FreeActive = true B2.Text = "FREE CAM: ON" B2.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
		Camera.CameraType = Enum.CameraType.Scriptable Mobile.Enabled = true
		YT.Conn = RS.RenderStepped:Connect(function(dt)
			if YT.Move.Magnitude > 0 then
				local d = Camera.CFrame:VectorToWorldSpace(YT.Move.Unit)
				Camera.CFrame = Camera.CFrame + (d * (YT.Speed * dt))
			end
		end)
	end
end)

Close.MouseButton1Click:Connect(function() Reset() Screen:Destroy() Mobile:Destroy() end)
