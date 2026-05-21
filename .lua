here--[[
    YTDEVS - FREE CAM & CAM LOCK (VERSÃO MOBILE ADAPTADA)
    GUI quadrada, minimizável (círculo "YT"), arrastável.
    Controles da Free Cam adaptados para a tela Touch do celular.
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
end)

-- Botão Minimizar (-)
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 2)
MinBtn.Text = "—"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn)

-- ================== CÍRCULO MINIMIZADO ==================
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

-- Interações minimizar/restaurar
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedCircle.Position = Main.Position
    MinimizedCircle.Visible = true
end)

MinimizedCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        task.wait(0.1)
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

-- ================== LÓGICA MOBILE ADAPTADA ==================
local FreeCamActive = false
local CamLockActive = false
local LockedCameraCFrame = nil

local moveSpeed = 40
local touchLookSensitivity = 0.4

-- Variáveis para rotação da câmera via Touch
local cameraYaw = 0
local cameraPitch = 0

-- Captura o movimento de arrastar o dedão direito para olhar ao redor
UIS.InputChanged:Connect(function(input)
    if FreeCamActive and input.UserInputType == Enum.UserInputType.Touch then
        if input.Delta.Magnitude > 0 then
            -- Aplica a rotação baseada no movimento do arrastar de tela
            cameraYaw = cameraYaw - (input.Delta.X * touchLookSensitivity * 0.05)
            cameraPitch = cameraPitch - (input.Delta.Y * touchLookSensitivity * 0.05)
            
            -- Limita o ângulo vertical para a câmera não dar uma cambalhota (360º vertical)
            cameraPitch = math.clamp(cameraPitch, -math.rad(80), math.rad(80))
        end
    end
end)

-- Atualiza câmera a cada frame
RS.RenderStepped:Connect(function(delta)
    if FreeCamActive then
        Camera.CameraType = Enum.CameraType.Scriptable
        
        -- Calcula a nova rotação da câmera baseada nos arrastes salvos
        local rotationCF = CFrame.Angles(0, cameraYaw, 0) * CFrame.Angles(cameraPitch, 0, 0)
        
        -- MOBILE FIX: Pega a direção do analógico virtual do Roblox de forma nativa
        local moveDirection = Vector3.new(0, 0, 0)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            moveDirection = char.Humanoid.MoveDirection
        end
        
        -- Multiplica a direção do movimento pela velocidade do drone
        local moveVector = moveDirection * moveSpeed * delta
        
        -- Se o jogador estiver usando o analógico, ele voará para onde a câmera está apontada
        local currentPosition = Camera.CFrame.Position
        Camera.CFrame = CFrame.new(currentPosition + moveVector) * rotationCF
        
    elseif CamLockActive then
        Camera.CameraType = Enum.CameraType.Scriptable
        if LockedCameraCFrame then
            Camera.CFrame = LockedCameraCFrame
        end
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Desativa ao morrer / resetar personagem
LocalPlayer.CharacterAdded:Connect(function()
    if not FreeCamActive and not CamLockActive then
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Funções alternadoras (Toggles)
local function toggleFreeCam(on)
    FreeCamActive = on
    if on then
        CamLockActive = false
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        FreeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        
        -- Sincroniza a rotação inicial com o ângulo atual que o jogador estava olhando
        local x, y, z = Camera.CFrame:ToEulerAnglesYXZ()
        cameraYaw = y
        cameraPitch = x
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
        LockedCameraCFrame = Camera.CFrame
    else
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        LockedCameraCFrame = nil
    end
end

-- Conecta os botões da interface
FreeCamBtn.MouseButton1Click:Connect(function()
    toggleFreeCam(not FreeCamActive)
end)

CamLockBtn.MouseButton1Click:Connect(function()
    toggleCamLock(not CamLockActive)
end)

-- Limpeza total ao destruir a interface
Screen.Destroying:Connect(function()
    FreeCamActive = false
    CamLockActive = false
    Camera.CameraType = Enum.CameraType.Custom
end)
