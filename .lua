herelocal Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local TargetGui = LocalPlayer:WaitForChild("PlayerGui")
if pcall(function() return CoreGui.Name end) then TargetGui = CoreGui end

if TargetGui:FindFirstChild("YtDevs") then TargetGui.YtDevs:Destroy() end

_G.YTDevs = {
    FreeCamActive = false,
    FreezeCamActive = false,
    freeCamConnection = nil,
    cameraSpeed = 40,
    MoveVector = Vector3.new(0, 0, 0)
}
local YT = _G.YTDevs

local function MakeDraggable(obj)
    local dragging, startPos, dragStart
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local Screen = Instance.new("ScreenGui", TargetGui)
Screen.Name = "YtDevs"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 280, 0, 240)
Main.Position = UDim2.new(0.5, -140, 0.4, -120)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 1.5
MakeDraggable(Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "YTDEVS MOBILE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 2)
MinBtn.Text = "—"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinBtn)

local MinimizedCircle = Instance.new("Frame", Screen)
MinimizedCircle.Size = UDim2.new(0, 60, 0, 60)
MinimizedCircle.Position = Main.Position
MinimizedCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", MinimizedCircle).CornerRadius = UDim.new(1, 0)
MinimizedCircle.Visible = false
local CircleStroke = Instance.new("UIStroke", MinimizedCircle)
CircleStroke.Color = Color3.fromRGB(255, 255, 255)
CircleStroke.Thickness = 1.5
local CircleLabel = Instance.new("TextLabel", MinimizedCircle)
CircleLabel.Size = UDim2.new(1, 0, 1, 0)
CircleLabel.Text = "YT"
CircleLabel.TextColor3 = Color3.new(1, 1, 1)
CircleLabel.Font = Enum.Font.GothamBlack
CircleLabel.TextSize = 22
CircleLabel.BackgroundTransparency = 1
MakeDraggable(MinimizedCircle)

local isRestoring = false
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedCircle.Position = Main.Position
    MinimizedCircle.Visible = true
end)

MinimizedCircle.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isRestoring then
        isRestoring = true
        local startPos = input.Position
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                local delta = (input.Position - startPos).Magnitude
                if delta < 10 then
                    Main.Position = MinimizedCircle.Position
                    MinimizedCircle.Visible = false
                    Main.Visible = true
                end
                isRestoring = false
                connection:Disconnect()
            end
        end)
    end
end)

local FreezeCamBtn = Instance.new("TextButton", Main)
FreezeCamBtn.Size = UDim2.new(1, -40, 0, 50)
FreezeCamBtn.Position = UDim2.new(0, 20, 0, 60)
FreezeCamBtn.Text = "FREEZE CAM: OFF"
FreezeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
FreezeCamBtn.TextColor3 = Color3.new(1, 1, 1)
FreezeCamBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", FreezeCamBtn)
YT.FreezeCamBtn = FreezeCamBtn

local FreeCamBtn = Instance.new("TextButton", Main)
FreeCamBtn.Size = UDim2.new(1, -40, 0, 50)
FreeCamBtn.Position = UDim2.new(0, 20, 0, 130)
FreeCamBtn.Text = "FREE CAM: OFF"
FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
FreeCamBtn.TextColor3 = Color3.new(1, 1, 1)
FreeCamBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", FreeCamBtn)
YT.FreeCamBtn = FreeCamBtn

CloseBtn.MouseButton1Click:Connect(function()
    if _G.YTDevs_ResetCamera then _G.YTDevs_ResetCamera() end
    Screen:Destroy()
end)local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local TargetGui = LocalPlayer:WaitForChild("PlayerGui")
if pcall(function() return CoreGui.Name end) then TargetGui = CoreGui end

if TargetGui:FindFirstChild("YtDevsFreeCam") then TargetGui.YtDevsFreeCam:Destroy() end

repeat task.wait() until _G.YTDevs
local YT = _G.YTDevs

local MobileControls = Instance.new("ScreenGui", TargetGui)
MobileControls.Name = "YtDevsFreeCam"
MobileControls.Enabled = false

local function CreateDroneButton(name, text, pos, size)
    local btn = Instance.new("TextButton", MobileControls)
    btn.Name = name
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.4
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(255, 255, 255)
    return btn
end

local BtnFwd  = CreateDroneButton("Fwd", "▲", UDim2.new(0.15, -25, 0.7, -60), UDim2.new(0, 50, 0, 50))
local BtnBwd  = CreateDroneButton("Bwd", "▼", UDim2.new(0.15, -25, 0.7, 60), UDim2.new(0, 50, 0, 50))
local BtnLeft = CreateDroneButton("Left", "◄", UDim2.new(0.15, -85, 0.7, 0), UDim2.new(0, 50, 0, 50))
local BtnRight = CreateDroneButton("Right", "►", UDim2.new(0.15, 35, 0.7, 0), UDim2.new(0, 50, 0, 50))
local BtnUp   = CreateDroneButton("Up", "SUBIR", UDim2.new(0.85, -50, 0.65, -35), UDim2.new(0, 100, 0, 50))
local BtnDown = CreateDroneButton("Down", "DESCER", UDim2.new(0.85, -50, 0.65, 35), UDim2.new(0, 100, 0, 50))

local function SetupTouchMovement(btn, vectorDirection)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            YT.MoveVector = YT.MoveVector + vectorDirection
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            YT.MoveVector = YT.MoveVector - vectorDirection
        end
    end)
end

SetupTouchMovement(BtnFwd, Vector3.new(0, 0, -1))
SetupTouchMovement(BtnBwd, Vector3.new(0, 0, 1))
SetupTouchMovement(BtnLeft, Vector3.new(-1, 0, 0))
SetupTouchMovement(BtnRight, Vector3.new(1, 0, 0))
SetupTouchMovement(BtnUp, Vector3.new(0, 1, 0))
SetupTouchMovement(BtnDown, Vector3.new(0, -1, 0))

local function ResetCamera()
    YT.FreeCamActive = false
    YT.FreezeCamActive = false
    MobileControls.Enabled = false
    if YT.freeCamConnection then YT.freeCamConnection:Disconnect() YT.freeCamConnection = nil end
    Camera.CameraType = Enum.CameraType.Custom
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then Camera.CameraSubject = char.Humanoid end
    if YT.FreezeCamBtn then YT.FreezeCamBtn.Text = "FREEZE CAM: OFF" YT.FreezeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55) end
    if YT.FreeCamBtn then YT.FreeCamBtn.Text = "FREE CAM: OFF" YT.FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55) end
end
_G.YTDevs_ResetCamera = ResetCamera

task.spawn(function()
    while task.wait(0.5) do
        if not YT.FreezeCamBtn then break end
        
        YT.FreezeCamBtn.MouseButton1Click:Connect(function()
            if YT.FreezeCamActive then ResetCamera() else
                ResetCamera()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Head") then
                    YT.FreezeCamActive = true
                    YT.FreezeCamBtn.Text = "FREEZE CAM: ON"
                    YT.FreezeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                    Camera.CameraType = Enum.CameraType.Scriptable
                    local head = char.Head
                    Camera.CFrame = CFrame.new(head.Position + (head.CFrame.LookVector * 8), head.Position)
                end
            end
        end)

        YT.FreeCamBtn.MouseButton1Click:Connect(function()
            if YT.FreeCamActive then ResetCamera() else
                ResetCamera()
                YT.FreeCamActive = true
                YT.FreeCamBtn.Text = "FREE CAM: ON"
                YT.FreeCamBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
                Camera.CameraType = Enum.CameraType.Scriptable
                MobileControls.Enabled = true
                YT.freeCamConnection = RS.RenderStepped:Connect(function(dt)
                    if YT.MoveVector.Magnitude > 0 then
                        local direction = Camera.CFrame:VectorToWorldSpace(YT.MoveVector.Unit)
                        Camera.CFrame = Camera.CFrame + (direction * (YT.cameraSpeed * dt))
                    end
                end)
            end
        end)
        break
    end
end)
