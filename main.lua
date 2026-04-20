-- // FFH4X STYLE - ROBLOX SCRIPT
-- // FEITO POR MG CHATS / DOLA

-- // SERVICES
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = Workspace.CurrentCamera

-- // VARIAVEIS
local AimbotEnabled = false
local Fov = 500
local AimPart = "Head"
local AimMode = "Ao Atirar" -- Ou "Ao Olhar"
local MouseDown = false

-- // CRIA A GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "FFH4X_MENU"
Gui.Parent = game:GetService("CoreGui")
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- // MENU PRINCIPAL
local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 400, 0, 280)
Menu.Position = UDim2.new(0.3, 0, 0.2, 0)
Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Menu.BorderSizePixel = 2
Menu.BorderColor3 = Color3.fromRGB(255, 0, 0)
Menu.Parent = Gui

-- // TOPO
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 30)
Top.Position = UDim2.new(0,0,0,0)
Top.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Top.Parent = Menu

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "FFH4X @MGCHATS - ROBLOX MOD"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Top

-- // BOTÃO AIMBOT RAGE
local CheckAim = Instance.new("TextButton")
CheckAim.Size = UDim2.new(0, 25, 0, 25)
CheckAim.Position = UDim2.new(0.05, 0, 0.15, 0)
CheckAim.BackgroundColor3 = Color3.fromRGB(40,40,40)
CheckAim.Text = "✅"
CheckAim.TextColor3 = Color3.new(0,0,0)
CheckAim.Parent = Menu

local TextAim = Instance.new("TextLabel")
TextAim.Size = UDim2.new(0, 150, 0, 25)
TextAim.Position = UDim2.new(0.15, 0, 0.15, 0)
TextAim.BackgroundTransparency = 1
TextAim.Text = "Aimbot Rage"
TextAim.TextColor3 = Color3.new(1,1,1)
TextAim.Font = Enum.Font.GothamBold
TextAim.TextSize = 16
TextAim.Parent = Menu

-- // BARRA FOV
local FovBar = Instance.new("Frame")
FovBar.Size = UDim2.new(0.6, 0, 0, 10)
FovBar.Position = UDim2.new(0.2, 0, 0.30, 0)
FovBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
FovBar.Parent = Menu

local FovFill = Instance.new("Frame")
FovFill.Size = UDim2.new(0.5, 0, 1, 0)
FovFill.BackgroundColor3 = Color3.fromRGB(255,0,0)
FovFill.Parent = FovBar

local FovText = Instance.new("TextLabel")
FovText.Size = UDim2.new(0, 100, 0, 20)
FovText.Position = UDim2.new(0.82, 0, 0.27, 0)
FovText.BackgroundTransparency = 1
FovText.Text = "Aim Fov: "..Fov
FovText.TextColor3 = Color3.new(1,1,1)
FovText.Parent = Menu

-- // SELECIONAR PARTE (CABEÇA)
local PartBox = Instance.new("Frame")
PartBox.Size = UDim2.new(0.3, 0, 0, 30)
PartBox.Position = UDim2.new(0.2, 0, 0.40, 0)
PartBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
PartBox.Parent = Menu

local PartText = Instance.new("TextLabel")
PartText.Size = UDim2.new(1, -20, 1, 0)
PartText.Position = UDim2.new(0,10,0,0)
PartText.BackgroundTransparency = 1
PartText.Text = "Cabeça"
PartText.TextColor3 = Color3.new(1,1,1)
PartText.Parent = PartBox

local Arrow = Instance.new("TextLabel")
Arrow.Size = UDim2.new(0, 30, 1, 0)
Arrow.Position = UDim2.new(0.85, 0, 0, 0)
Arrow.BackgroundTransparency = 1
Arrow.Text = "▼"
Arrow.TextColor3 = Color3.new(1,1,1)
Arrow.Parent = PartBox

-- // MODO DE AIM
local Mode1 = Instance.new("TextButton")
Mode1.Size = UDim2.new(0.3, 0, 0, 30)
Mode1.Position = UDim2.new(0.2, 0, 0.55, 0)
Mode1.BackgroundColor3 = Color3.fromRGB(40,40,40)
Mode1.Text = "Ao Olhar"
Mode1.TextColor3 = Color3.new(1,1,1)
Mode1.Parent = Menu

local Mode2 = Instance.new("TextButton")
Mode2.Size = UDim2.new(0.3, 0, 0, 30)
Mode2.Position = UDim2.new(0.52, 0, 0.55, 0)
Mode2.BackgroundColor3 = Color3.fromRGB(255,0,0)
Mode2.Text = "Ao Atirar"
Mode2.TextColor3 = Color3.new(1,1,1)
Mode2.Parent = Menu

-- // FUNÇÕES

-- Ligar/Desligar Aimbot
local On = false
CheckAim.MouseButton1Click:Connect(function()
    On = not On
    if On then
        CheckAim.BackgroundColor3 = Color3.fromRGB(0,255,0)
        AimbotEnabled = true
    else
        CheckAim.BackgroundColor3 = Color3.fromRGB(40,40,40)
        AimbotEnabled = false
    end
end)

-- Mudar Modo
Mode1.MouseButton1Click:Connect(function()
    AimMode = "Ao Olhar"
    Mode1.BackgroundColor3 = Color3.fromRGB(255,0,0)
    Mode2.BackgroundColor3 = Color3.fromRGB(40,40,40)
end)

Mode2.MouseButton1Click:Connect(function()
    AimMode = "Ao Atirar"
    Mode2.BackgroundColor3 = Color3.fromRGB(255,0,0)
    Mode1.BackgroundColor3 = Color3.fromRGB(40,40,40)
end)

-- Função de achar inimigo
local function GetClosest()
    local MaxDistance = Fov
    local Target = nil
    local Shortest = math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild(AimPart) then
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character[AimPart].Position)
            local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
            
            if Distance < Shortest and Distance < MaxDistance and OnScreen then
                Shortest = Distance
                Target = v
            end
        end
    end
    return Target
end

-- Lógica do Aimbot
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MouseDown = false
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local Enemy = GetClosest()
        if Enemy and Enemy.Character and Enemy.Character:FindFirstChild(AimPart) then
            if AimMode == "Ao Atirar" and MouseDown or AimMode == "Ao Olhar" then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Enemy.Character[AimPart].Position), 0.2)
            end
        end
    end
end)

-- // ARRASTAR MENU
local Dragging, DragStart, StartPos

Menu.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = Menu.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        Menu.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

print("✅ FFH4X SCRIPT CARREGADO COM SUCESSO!")
