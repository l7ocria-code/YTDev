--[[
    YTDEVS - FREE CAM & CAM LOCK
    GUI quadrada, minimizável (círculo "YT"), arrastável
]]

-- Serviços
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Limpa GUI antiga
if CoreGui:FindFirstChild("YtDevs") then
    CoreGui.YtDevs:Destroy()
end

-- Tela
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "YtDevs"
Screen.ResetOnSpawn = false

-- ================== FUNÇÃO DE ARRASTE ==================
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
Main.Position = UDim2.new(0.5, -140, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)  -- levemente arredondada, mas quadrada
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

-- ================== CÍRCULO MINIMIZADO ==================
local MinimizedCircle = Instance.new("Frame", Screen)
MinimizedCircle.Size = UDim2.new(0, 60, 0, 60)
MinimizedCircle.Position = Main.Position + UDim2.new(0, 0, 0, 0)  -- mesma posição inicial
MinimizedCircle.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MinimizedCircle.BorderSizePixel = 0
Instance.new("UICorner", MinimizedCircle).CornerRadius = UDim.new(1, 0)  -- círculo perfeito
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

-- Interações minimizar/restaurar
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedCircle.Position = Main.Position
    MinimizedCircle.Visible = true
end)

MinimizedCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Verifica se foi um clique simples (sem arraste prolongado)
        wait(0.1)
        Main.Position = MinimizedCircle.Position
        MinimizedCircle.Visible = false
        Main.Visible = true
    end
end)

-- ================== BOTÕES DE FUNÇÃO ==================
-- Free Cam
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

-- Camera Lock
local CamLockBtn = Instance.new("TextButton", Main)
CamLockBtn.Size = UDim2.new(1, -40, 0, 60)
CamLockBtn.Position = UDim2.new(0, 20, 0, 130)
CamLockBtn.Text = "CAM LOCK"
CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
CamLockBtn.TextColor3 = Color3.new(1, 1, 1)
CamLockBtn.Font = Enum.Font.GothamBold
CamLockBtn.TextSize = 16
CamLockBtn.BorderSizePixel = 0
Instance.new("UICorner", CamLockBtn)

-- ================== LÓGICA DAS CÂMERAS ==================
local FreeCamActive = false
local CamLockActive = false
local LockedCameraCFrame = nil

-- Movimento da Free Cam
local moveVector = Vector3.new()
local keys = {W = false, A = false, S = false, D = false, Space = false, LShift = false}
local mouseSensitivity = 0.5
local moveSpeed = 40

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = true
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = true
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = true
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.LShift = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = false
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = false
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.LShift = false
    end
end)

-- Atualiza câmera a cada frame
RS.RenderStepped:Connect(function(delta)
    if FreeCamActive then
        local cam = Camera
        if not cam then return end
        cam.CameraType = Enum.CameraType.Scriptable
        -- Orientação pelo mouse
        local mouseDelta = UIS:GetMouseDelta()
        local currentCF = cam.CFrame
        local rotX = currentCF.Rotation - currentCF.Rotation:ToEulerAnglesYXZ()
        -- Simples: multiplicar por rotação com base no mouse
        local yaw = mouseDelta.X * mouseSensitivity * 0.02
        local pitch = mouseDelta.Y * mouseSensitivity * 0.02
        local newCF = currentCF * CFrame.Angles(0, -yaw, 0) * CFrame.Angles(-pitch, 0, 0)
        -- Movimento WASD
        local moveDir = Vector3.new()
        if keys.W then moveDir += newCF.LookVector end
        if keys.S then moveDir -= newCF.LookVector end
        if keys.A then moveDir -= newCF.RightVector end
        if keys.D then moveDir += newCF.RightVector end
        if keys.Space then moveDir += Vector3.new(0, 1, 0) end
        if keys.LShift then moveDir += Vector3.new(0, -1, 0) end
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * moveSpeed * delta
        end
        cam.CFrame = CFrame.new(newCF.Position + moveDir, newCF.Position + moveDir + newCF.LookVector)
    elseif CamLockActive then
        Camera.CameraType = Enum.CameraType.Scriptable
        if LockedCameraCFrame then
            Camera.CFrame = LockedCameraCFrame
        end
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Desativa ao fechar / morrer (opcional, mas seguro)
LocalPlayer.CharacterAdded:Connect(function()
    -- Se a câmera estiver lockada, não reposiciona automaticamente
    if not FreeCamActive and not CamLockActive then
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Função para desativar a outra câmera
local function toggleFreeCam(on)
    FreeCamActive = on
    if on then
        CamLockActive = false
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        FreeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end
end

local function toggleCamLock(on)
    CamLockActive = on
    if on then
        FreeCamActive = false
        FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        -- Captura a posição atual da câmera para congelar
        LockedCameraCFrame = Camera.CFrame
    else
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        LockedCameraCFrame = nil
    end
end

-- Conecta os botões
FreeCamBtn.MouseButton1Click:Connect(function()
    toggleFreeCam(not FreeCamActive)
end)

CamLockBtn.MouseButton1Click:Connect(function()
    toggleCamLock(not CamLockActive)
end)
