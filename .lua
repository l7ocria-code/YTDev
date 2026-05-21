here--[[ YTDEVS - PARTE 1/3 (GUI) ]]

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

-- Tabela global compartilhada (mesma estrutura anterior)
_G.YTDevs = {
    FreeCamActive = false,
    FreezeCamActive = false,
    freeCamConnection = nil,
    cameraSpeed = 50
}

local YT = _G.YTDevs

-- Função de arraste (touch)
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

-- ScreenGui
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "YtDevs"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true
YT.Screen = Screen

-- Janela principal (quadrada)
local Main = Instance.new("Frame", Screen)
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
YT.Main = Main

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
    -- Reseta câmera se ativa
    if YT.FreezeCamActive or YT.FreeCamActive then
        _G.YTDevs_ResetCamera()
    end
    Screen:Destroy()
    _G.YTDevs = nil
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
YT.MinimizedCircle = MinimizedCircle

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

-- Botões de função
local FreezeCamBtn = Instance.new("TextButton", Main)
FreezeCamBtn.Size = UDim2.new(1, -40, 0, 60)
FreezeCamBtn.Position = UDim2.new(0, 20, 0, 50)
FreezeCamBtn.Text = "FREEZE CAM"
FreezeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
FreezeCamBtn.TextColor3 = Color3.new(1, 1, 1)
FreezeCamBtn.Font = Enum.Font.GothamBold
FreezeCamBtn.TextSize = 16
FreezeCamBtn.BorderSizePixel = 0
Instance.new("UICorner", FreezeCamBtn)
YT.FreezeCamBtn = FreezeCamBtn

local FreeCamBtn = Instance.new("TextButton", Main)
FreeCamBtn.Size = UDim2.new(1, -40, 0, 60)
FreeCamBtn.Position = UDim2.new(0, 20, 0, 130)
FreeCamBtn.Text = "FREE CAM"
FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
FreeCamBtn.TextColor3 = Color3.new(1, 1, 1)
FreeCamBtn.Font = Enum.Font.GothamBold
FreeCamBtn.TextSize = 16
FreeCamBtn.BorderSizePixel = 0
Instance.new("UICorner", FreeCamBtn)
YT.FreeCamBtn = FreeCamBtn--[[ YTDEVS - PARTE 2/3 (CÂMERAS) ]]

local YT = _G.YTDevs
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Teclas de atalho (mantidas do original)
local KEY_FREEZE_CAM = Enum.KeyCode.F
local KEY_FREE_CAM = Enum.KeyCode.C

-- Função original para restaurar câmera
function _G.YTDevs_ResetCamera()
    if YT.freeCamConnection then
        YT.freeCamConnection:Disconnect()
        YT.freeCamConnection = nil
    end
    YT.FreezeCamActive = false
    YT.FreeCamActive = false
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
    -- Atualiza cores dos botões
    if YT.FreezeCamBtn then
        YT.FreezeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end
    if YT.FreeCamBtn then
        YT.FreeCamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end
end

-- FREEZE CAM (congela na frente)
local function toggleFreezeCam()
    if YT.FreezeCamActive then
        _G.YTDevs_ResetCamera()
    else
        _G.YTDevs_ResetCamera() -- desativa qualquer outro modo
        local character = player.Character
        if character and character:FindFirstChild("Head") then
            YT.FreezeCamActive = true
            camera.CameraType = Enum.CameraType.Scriptable
            local head = character.Head
            camera.CFrame = CFrame.new(head.Position + (head.CFrame.LookVector * 10), head.Position)
            YT.FreezeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        end
    end
end

-- FREE CAM (drone)
local function toggleFreeCam()
    if YT.FreeCamActive then
        _G.YTDevs_ResetCamera()
    else
        _G.YTDevs_ResetCamera()
        YT.FreeCamActive = true
        camera.CameraType = Enum.CameraType.Scriptable
        YT.freeCamConnection = RunService.RenderStepped:Connect(function(deltaTime)
            local moveVector = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += Vector3.new(0, 0, -1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector += Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector += Vector3.new(-1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveVector += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVector += Vector3.new(0, -1, 0) end

            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                local delta = UserInputService:GetMouseDelta()
                local newCFrame = camera.CFrame * CFrame.Angles(-math.rad(delta.Y), -math.rad(delta.X), 0)
                local x, y, z = newCFrame:ToOrientation()
                camera.CFrame = CFrame.new(newCFrame.Position) * CFrame.Angles(x, y, 0)
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end

            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit
                camera.CFrame = camera.CFrame + (camera.CFrame:VectorToWorldSpace(moveVector) * (YT.cameraSpeed * deltaTime))
            end
        end)
        YT.FreeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end

-- Conexão dos botões da GUI
YT.FreezeCamBtn.MouseButton1Click:Connect(toggleFreezeCam)
YT.FreeCamBtn.MouseButton1Click:Connect(toggleFreeCam)

-- Atalhos de teclado (originais)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == KEY_FREEZE_CAM then
        toggleFreezeCam()
    elseif input.KeyCode == KEY_FREE_CAM then
        toggleFreeCam()
    end
end)--[[ YTDEVS - PARTE 3/3 (FINALIZAÇÃO) ]]

local YT = _G.YTDevs
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Garantir que a câmera seja resetada quando o personagem morrer/renascer
player.CharacterAdded:Connect(function()
    if YT.FreezeCamActive or YT.FreeCamActive then
        _G.YTDevs_ResetCamera()
    end
end)
