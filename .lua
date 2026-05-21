here--[[ YTDEVS MOBILE - FREE CAM & CAM LOCK (PARTE 1/3) ]]

-- Serviços
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Limpeza
if CoreGui:FindFirstChild("YtDevs") then CoreGui.YtDevs:Destroy() end
if CoreGui:FindFirstChild("YtDevsFreeCam") then CoreGui.YtDevsFreeCam:Destroy() end

-- ScreenGui principal
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "YtDevs"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true  -- ocupa toda a tela no mobile

-- ================== FUNÇÃO DE ARRASTE (TOUCH) ==================
local function MakeDraggable(obj)
    local dragging, startPos, dragStart
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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

-- ================== JANELA PRINCIPAL (QUADRADA) ==================
local Main = Instance.new("Frame", Screen)
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 280)
Main.Position = UDim2.new(0.5, -140, 0.4, -140)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Main.ClipsDescendants = true
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1.5

MakeDraggable(Main)

-- Título
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "YTDEVS"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Title.BorderSizePixel = 0

-- Botão Fechar (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    Screen:Destroy()
    if CoreGui:FindFirstChild("YtDevsFreeCam") then CoreGui.YtDevsFreeCam:Destroy() end
end)

-- Botão Minimizar (-)
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 2)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn)

-- Círculo minimizado
local MinimizedCircle = Instance.new("Frame", Screen)
MinimizedCircle.Size = UDim2.new(0, 60, 0, 60)
MinimizedCircle.Position = Main.Position
MinimizedCircle.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MinimizedCircle.BorderSizePixel = 0
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
CircleLabel.TextSize = 24
CircleLabel.BackgroundTransparency = 1

MakeDraggable(MinimizedCircle)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedCircle.Position = Main.Position
    MinimizedCircle.Visible = true
end)

MinimizedCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wait(0.15)
        Main.Position = MinimizedCircle.Position
        MinimizedCircle.Visible = false
        Main.Visible = true
    end
end)

-- Botões da GUI principal
local FreeCamBtn = Instance.new("TextButton", Main)
FreeCamBtn.Size = UDim2.new(1, -40, 0, 60)
FreeCamBtn.Position = UDim2.new(0, 20, 0, 50)
FreeCamBtn.Text = "FREE CAM"
FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
FreeCamBtn.TextColor3 = Color3.new(1, 1, 1)
FreeCamBtn.Font = Enum.Font.GothamBold
FreeCamBtn.TextSize = 16
FreeCamBtn.BorderSizePixel = 0
Instance.new("UICorner", FreeCamBtn)

local CamLockBtn = Instance.new("TextButton", Main)
CamLockBtn.Size = UDim2.new(1, -40, 0, 60)
CamLockBtn.Position = UDim2.new(0, 20, 0, 130)
CamLockBtn.Text = "CAM LOCK"
CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
CamLockBtn.TextColor3 = Color3.new(1, 1, 1)
CamLockBtn.Font = Enum.Font.GothamBold
CamLockBtn.TextSize = 16
CamLockBtn.BorderSizePixel = 0
Instance.new("UICorner", CamLockBtn)--[[ PARTE 2/3 ]]

-- Estados
local FreeCamActive = false
local CamLockActive = false
local LockedCameraCFrame = nil

-- Funções de ativação/desativação
local function activateFreeCam()
    FreeCamActive = true
    CamLockActive = false
    Camera.CameraType = Enum.CameraType.Scriptable
    Main.Visible = false
    MinimizedCircle.Visible = false
    FreeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end

local function deactivateFreeCam()
    FreeCamActive = false
    Camera.CameraType = Enum.CameraType.Custom
    Main.Visible = true
    FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end

local function activateCamLock()
    CamLockActive = true
    FreeCamActive = false
    Camera.CameraType = Enum.CameraType.Scriptable
    LockedCameraCFrame = Camera.CFrame
    CamLockBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end

local function deactivateCamLock()
    CamLockActive = false
    Camera.CameraType = Enum.CameraType.Custom
    LockedCameraCFrame = nil
    CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end

-- Conexões dos botões
FreeCamBtn.MouseButton1Click:Connect(function()
    if FreeCamActive then
        deactivateFreeCam()
    else
        activateFreeCam()
    end
end)

CamLockBtn.MouseButton1Click:Connect(function()
    if CamLockActive then
        deactivateCamLock()
    else
        activateCamLock()
    end
end)

-- Desativar ao fechar/morrer (segurança)
LocalPlayer.CharacterAdded:Connect(function()
    if FreeCamActive then deactivateFreeCam() end
    if CamLockActive then deactivateCamLock() end
end)--[[ PARTE 3/3 ]]

-- ScreenGui dos controles (aparece só com Free Cam ativa)
local ControlScreen = Instance.new("ScreenGui", CoreGui)
ControlScreen.Name = "YtDevsFreeCam"
ControlScreen.ResetOnSpawn = false
ControlScreen.IgnoreGuiInset = true
ControlScreen.Enabled = false  -- começa desativada

-- ================== JOYSTICK ESQUERDO (MOVIMENTO) ==================
local joystickBase = Instance.new("Frame", ControlScreen)
joystickBase.Size = UDim2.new(0, 120, 0, 120)
joystickBase.Position = UDim2.new(0, 30, 0.7, -60)
joystickBase.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joystickBase.BackgroundTransparency = 0.7
joystickBase.BorderSizePixel = 0
Instance.new("UICorner", joystickBase).CornerRadius = UDim.new(1, 0)

local joystickThumb = Instance.new("Frame", joystickBase)
joystickThumb.Size = UDim2.new(0, 50, 0, 50)
joystickThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
joystickThumb.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
joystickThumb.BorderSizePixel = 0
Instance.new("UICorner", joystickThumb).CornerRadius = UDim.new(1, 0)

-- Controle do joystick
local moveInput = Vector2.new()
local joystickActive = false
local joystickOrigin = Vector2.new()

joystickBase.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = true
        joystickOrigin = input.Position
    end
end)

joystickBase.InputEnded:Connect(function(input)
    joystickActive = false
    moveInput = Vector2.new()
    joystickThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
end)

UIS.InputChanged:Connect(function(input)
    if joystickActive and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - joystickOrigin
        local maxRadius = 45
        local clamped = Vector2.new(math.clamp(delta.X, -maxRadius, maxRadius), math.clamp(delta.Y, -maxRadius, maxRadius))
        moveInput = clamped / maxRadius  -- vetor normalizado (-1 a 1)
        joystickThumb.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
    end
end)

-- ================== JOYSTICK DIREITO (ROTAÇÃO) ==================
local lookBase = Instance.new("Frame", ControlScreen)
lookBase.Size = UDim2.new(0, 120, 0, 120)
lookBase.Position = UDim2.new(1, -150, 0.7, -60)
lookBase.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lookBase.BackgroundTransparency = 0.7
lookBase.BorderSizePixel = 0
Instance.new("UICorner", lookBase).CornerRadius = UDim.new(1, 0)

local lookThumb = Instance.new("Frame", lookBase)
lookThumb.Size = UDim2.new(0, 50, 0, 50)
lookThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
lookThumb.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
lookThumb.BorderSizePixel = 0
Instance.new("UICorner", lookThumb).CornerRadius = UDim.new(1, 0)

local lookInput = Vector2.new()
local lookActive = false
local lookOrigin = Vector2.new()

lookBase.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        lookActive = true
        lookOrigin = input.Position
    end
end)

lookBase.InputEnded:Connect(function(input)
    lookActive = false
    lookInput = Vector2.new()
    lookThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
end)

UIS.InputChanged:Connect(function(input)
    if lookActive and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - lookOrigin
        local maxRadius = 45
        local clamped = Vector2.new(math.clamp(delta.X, -maxRadius, maxRadius), math.clamp(delta.Y, -maxRadius, maxRadius))
        lookInput = clamped / maxRadius
        lookThumb.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
    end
end)

-- ================== BOTÕES DE ALTITUDE (UP/DOWN) ==================
local upBtn = Instance.new("TextButton", ControlScreen)
upBtn.Size = UDim2.new(0, 60, 0, 60)
upBtn.Position = UDim2.new(0.5, -30, 0.85, 0)
upBtn.Text = "↑"
upBtn.TextColor3 = Color3.new(1,1,1)
upBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
upBtn.Font = Enum.Font.GothamBold
upBtn.TextSize = 24
upBtn.BorderSizePixel = 0
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1, 0)

local downBtn = Instance.new("TextButton", ControlScreen)
downBtn.Size = UDim2.new(0, 60, 0, 60)
downBtn.Position = UDim2.new(0.5, -30, 1, -80)
downBtn.Text = "↓"
downBtn.TextColor3 = Color3.new(1,1,1)
downBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
downBtn.Font = Enum.Font.GothamBold
downBtn.TextSize = 24
downBtn.BorderSizePixel = 0
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(1, 0)

local altitude = 0  -- valor temporário
upBtn.MouseButton1Down:Connect(function() altitude = 1 end)
upBtn.MouseButton1Up:Connect(function() altitude = 0 end)
downBtn.MouseButton1Down:Connect(function() altitude = -1 end)
downBtn.MouseButton1Up:Connect(function() altitude = 0 end)

-- Botão sair da Free Cam
local exitBtn = Instance.new("TextButton", ControlScreen)
exitBtn.Size = UDim2.new(0, 40, 0, 40)
exitBtn.Position = UDim2.new(1, -50, 0, 10)
exitBtn.Text = "X"
exitBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
exitBtn.TextColor3 = Color3.new(1,1,1)
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextSize = 18
exitBtn.BorderSizePixel = 0
Instance.new("UICorner", exitBtn).CornerRadius = UDim.new(1, 0)

exitBtn.MouseButton1Click:Connect(function()
    deactivateFreeCam()
    ControlScreen.Enabled = false
end)

-- ================== LOOP DE ATUALIZAÇÃO DA CÂMERA ==================
local moveSpeed = 30
local lookSensitivity = 3  -- graus por frame

RS.RenderStepped:Connect(function(dt)
    if FreeCamActive then
        ControlScreen.Enabled = true
        local cam = Camera
        if not cam then return end
        cam.CameraType = Enum.CameraType.Scriptable

        -- Rotação com base no lookInput
        local yaw = lookInput.X * lookSensitivity * dt * 20   -- ajuste
        local pitch = lookInput.Y * lookSensitivity * dt * 20
        local newCF = cam.CFrame * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
        -- Movimento
        local moveDir = Vector3.new()
        if moveInput.X ~= 0 or moveInput.Y ~= 0 then
            moveDir += newCF.RightVector * moveInput.X
            moveDir -= newCF.LookVector * moveInput.Y
        end
        if altitude ~= 0 then
            moveDir += Vector3.new(0, altitude, 0)
        end
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * moveSpeed * dt
        end
        cam.CFrame = CFrame.new(newCF.Position + moveDir, newCF.Position + moveDir + newCF.LookVector)
    elseif CamLockActive then
        ControlScreen.Enabled = false
        Camera.CameraType = Enum.CameraType.Scriptable
        if LockedCameraCFrame then
            Camera.CFrame = LockedCameraCFrame
        end
    else
        ControlScreen.Enabled = false
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Garantir que ao reativar a Free Cam a ControlScreen apareça
-- (já é tratado no loop, mas força)
