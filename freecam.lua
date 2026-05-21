--[[
    YTDEVS - FREE CAM & CAM LOCK (VERSÃO PRO MOBILE)
    - Personagem congela ao ativar
    - Minimizar oculta Chat/CoreGui (Modo Cinema)
    - Controle de velocidade no menu
    - Botões dedicados para Subir/Descer
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Limpa execuções anteriores
if CoreGui:FindFirstChild("YtDevs") then CoreGui.YtDevs:Destroy() end
if CoreGui:FindFirstChild("YtDevsMobileControls") then CoreGui.YtDevsMobileControls:Destroy() end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "YtDevs"
Screen.ResetOnSpawn = false

-- Estados Globais do Script
local FreeCamActive = false
local CamLockActive = false
local LockedCameraCFrame = nil
local moveSpeed = 20 -- Velocidade inicial mais lenta e controlável
local cameraYaw, cameraPitch = 0, 0
local flyUp, flyDown = false, false

-- Função para fixar/liberar o personagem
local function setCharacterFrozen(frozen)
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Anchored = frozen
            end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = frozen end
    end
end

-- Função para Alternar Modo Cinema (Ocultar chat/HUD do Roblox)
local function setCinematicMode(enabled)
    local state = not enabled
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, state)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, state)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, state)
    end)
end

-- ================== FUNÇÃO DE ARRASTE TOQUE ==================
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

-- ================== JANELA PRINCIPAL ==================
local Main = Instance.new("Frame", Screen)
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 290)
Main.Position = UDim2.new(0.5, -140, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1.5
MakeDraggable(Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "YTDEVS MOBILE PRO"
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

-- ================== CÍRCULO INTERATIVO YT ==================
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

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedCircle.Position = Main.Position
    MinimizedCircle.Visible = true
    if FreeCamActive then setCinematicMode(true) end -- Esconde tudo ao minimizar
end)

MinimizedCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        task.wait(0.1)
        Main.Position = MinimizedCircle.Position
        MinimizedCircle.Visible = false
        Main.Visible = true
        setCinematicMode(false) -- Devolve o HUD padrão
    end
end)

-- ================== BOTÕES DE CONFIGURAÇÃO DE VELOCIDADE ==================
local SpeedFrame = Instance.new("Frame", Main)
SpeedFrame.Size = UDim2.new(1, -40, 0, 40)
SpeedFrame.Position = UDim2.new(0, 20, 0, 45)
SpeedFrame.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Size = UDim2.new(0, 120, 1, 0)
SpeedLabel.Text = "Velocidade: " .. moveSpeed
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedMinus = Instance.new("TextButton", SpeedFrame)
SpeedMinus.Size = UDim2.new(0, 35, 0, 35)
SpeedMinus.Position = UDim2.new(1, -80, 0, 2)
SpeedMinus.Text = "-"
SpeedMinus.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
SpeedMinus.TextColor3 = Color3.new(1, 1, 1)
SpeedMinus.Font = Enum.Font.GothamBold
Instance.new("UICorner", SpeedMinus)

local SpeedPlus = Instance.new("TextButton", SpeedFrame)
SpeedPlus.Size = UDim2.new(0, 35, 0, 35)
SpeedPlus.Position = UDim2.new(1, -35, 0, 2)
SpeedPlus.Text = "+"
SpeedPlus.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
SpeedPlus.TextColor3 = Color3.new(1, 1, 1)
SpeedPlus.Font = Enum.Font.GothamBold
Instance.new("UICorner", SpeedPlus)

SpeedMinus.MouseButton1Click:Connect(function()
    moveSpeed = math.max(5, moveSpeed - 5)
    SpeedLabel.Text = "Velocidade: " .. moveSpeed
end)

SpeedPlus.MouseButton1Click:Connect(function()
    moveSpeed = math.min(150, moveSpeed + 5)
    SpeedLabel.Text = "Velocidade: " .. moveSpeed
end)

-- Botões principais de Ação
local FreeCamBtn = Instance.new("TextButton", Main)
FreeCamBtn.Size = UDim2.new(1, -40, 0, 55)
FreeCamBtn.Position = UDim2.new(0, 20, 0, 95)
FreeCamBtn.Text = "FREE CAM"
FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
FreeCamBtn.TextColor3 = Color3.new(1, 1, 1)
FreeCamBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", FreeCamBtn)

local CamLockBtn = Instance.new("TextButton", Main)
CamLockBtn.Size = UDim2.new(1, -40, 0, 55)
CamLockBtn.Position = UDim2.new(0, 20, 0, 165)
CamLockBtn.Text = "CAM LOCK"
CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
CamLockBtn.TextColor3 = Color3.new(1, 1, 1)
CamLockBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CamLockBtn)

-- ================== CONTROLES DE ALTITUDE MOBILE ==================
local MobileControls = Instance.new("ScreenGui", CoreGui)
MobileControls.Name = "YtDevsMobileControls"
MobileControls.Enabled = false

local function CreateAltitudeBtn(text, pos)
    local btn = Instance.new("TextButton", MobileControls)
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.TextSize = 24
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    Instance.new("UIStroke", btn).Color = Color3.new(1,1,1)
    return btn
end

-- Posiciona os botões de subir e descer na ponta direita da tela, fáceis de alcançar
local BtnUp = CreateAltitudeBtn("▲", UDim2.new(0.85, 0, 0.5, -70))
local BtnDown = CreateAltitudeBtn("▼", UDim2.new(0.85, 0, 0.5, 10))

BtnUp.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUp = true end end)
BtnUp.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUp = false end end)
BtnDown.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyDown = true end end)
BtnDown.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyDown = false end end)


-- ================== EXECUÇÃO MECÂNICA DA CÂMERA ==================
UIS.InputChanged:Connect(function(input, gameProcessed)
    if not FreeCamActive or gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Touch and input.Delta.Magnitude > 0 then
        cameraYaw = cameraYaw - (input.Delta.X * 0.006)
        cameraPitch = cameraPitch - (input.Delta.Y * 0.006)
        cameraPitch = math.clamp(cameraPitch, -math.rad(85), math.rad(85))
    end
end)

RS.RenderStepped:Connect(function(delta)
    if FreeCamActive then
        Camera.CameraType = Enum.CameraType.Scriptable
        local lookCF = CFrame.Angles(0, cameraYaw, 0) * CFrame.Angles(cameraPitch, 0, 0)
        
        -- Capta direção do analógico do celular
        local moveDir = Vector3.new()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            moveDir = char.Humanoid.MoveDirection
        end
        
        -- Processa subida e descida vertical dos botões da tela
        local verticalMove = 0
        if flyUp then verticalMove = 1 elseif flyDown then verticalMove = -1 end
        
        -- Traduz os movimentos horizontais relativos ao olhar da câmera + o eixo vertical absoluto
        local horizontalVectors = Camera.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z))
        local finalMove = Vector3.new(horizontalVectors.X, verticalMove, horizontalVectors.Z)
        
        if finalMove.Magnitude > 0 then
            finalMove = finalMove.Unit * moveSpeed * delta
        end
        
        Camera.CFrame = CFrame.new(Camera.CFrame.Position + finalMove) * lookCF
    elseif CamLockActive then
        Camera.CameraType = Enum.CameraType.Scriptable
        if LockedCameraCFrame then Camera.CFrame = LockedCameraCFrame end
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

local function toggleFreeCam(on)
    FreeCamActive = on
    MobileControls.Enabled = on
    setCharacterFrozen(on) -- Congela ou descongela o personagem
    
    if on then
        CamLockActive = false
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        FreeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        local x, y, z = Camera.CFrame:ToEulerAnglesYXZ()
        cameraYaw, cameraPitch = y, x
    else
        FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        setCinematicMode(false)
    end
end

local function toggleCamLock(on)
    CamLockActive = on
    if on then
        toggleFreeCam(false)
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        LockedCameraCFrame = Camera.CFrame
    else
        CamLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        LockedCameraCFrame = nil
    end
end

FreeCamBtn.MouseButton1Click:Connect(function() toggleFreeCam(not FreeCamActive) end)
CamLockBtn.MouseButton1Click:Connect(function() toggleCamLock(not CamLockActive) end)

CloseBtn.MouseButton1Click:Connect(function()
    toggleFreeCam(false)
    toggleCamLock(false)
    setCinematicMode(false)
    Screen:Destroy()
    MobileControls:Destroy()
end)
