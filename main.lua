-- // SERVICES
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- // VARS
local Enabled = false
local Fov = 360
local Mode = "Ao Atirar"
local MouseDown = false
local EspEnabled = false
local ShowFovCircle = false
local OnlyVisible = false
local IgnoreDowned = false
local SpinEnabled = false

-- // GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "FFH4X_MG"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- // =============================================
-- // 🔘 BOTÃO FLUTUANTE MG
-- // =============================================
local FloatBtn = Instance.new("TextButton", Gui)
FloatBtn.Name = "FloatButton"
FloatBtn.Size = UDim2.new(0,60,0,60)
FloatBtn.Position = UDim2.new(0,20,0.5,0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
FloatBtn.Text = "MG"
FloatBtn.TextColor3 = Color3.fromRGB(255,0,0)
FloatBtn.Font = Enum.Font.GothamBlack
FloatBtn.TextSize = 22
FloatBtn.ClipsDescendants = true

Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1,0)

-- EFEITO NEON
local StrokeBtn = Instance.new("UIStroke", FloatBtn)
StrokeBtn.Color = Color3.fromRGB(255,0,0)
StrokeBtn.Thickness = 2
StrokeBtn.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ANIMAÇÃO GLOW
coroutine.wrap(function()
    while wait(1) do
        TweenService:Create(StrokeBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.4}):Play()
        wait(1.2)
        TweenService:Create(StrokeBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0}):Play()
    end
end)()

-- ARRASTAR BOTÃO
local function MakeDraggable(object)
    local dragging, start, pos = false, nil, nil
    object.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = i.Position
            pos = object.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging then
            local delta = i.Position - start
            object.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function() dragging = false end)
end
MakeDraggable(FloatBtn)

-- // =============================================
-- // 📦 MENU PRINCIPAL
-- // =============================================
local Menu = Instance.new("Frame", Gui)
Menu.Name = "MainMenu"
Menu.Size = UDim2.new(0,420,0,400)
Menu.Position = UDim2.new(0.5,-210,0.5,-200)
Menu.BackgroundColor3 = Color3.fromRGB(10,10,10)
Menu.Visible = false

Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,8)
local StrokeMenu = Instance.new("UIStroke", Menu)
StrokeMenu.Color = Color3.fromRGB(255,0,0)
StrokeMenu.Thickness = 2

-- // TOPO
local TopBar = Instance.new("Frame", Menu)
TopBar.Size = UDim2.new(1,0,0,35)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = Color3.fromRGB(180,0,0)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,-80,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "FFH4X-MG"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- BOTÃO MINIMIZAR
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-70,0,2)
MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,5)

-- BOTÃO FECHAR
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,5)

-- // ABRE/FECHA MENU
FloatBtn.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

MinBtn.MouseButton1Click:Connect(function()
    Menu.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- ARRASTAR MENU
MakeDraggable(Menu)

-- // =============================================
-- // 🎯 CONTEÚDO DO MENU
-- // =============================================

-- AIMBOT
local AimBox = Instance.new("Frame", Menu)
AimBox.Size = UDim2.new(0,28,0,28)
AimBox.Position = UDim2.new(0.05,0,0.12,0)
AimBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", AimBox)

local AimCheck = Instance.new("Frame", AimBox)
AimCheck.Size = UDim2.new(1,0,1,0)
AimCheck.BackgroundColor3 = Color3.fromRGB(0,200,0)
AimCheck.Visible = false
Instance.new("UICorner", AimCheck)

local AimBtn = Instance.new("TextButton", AimBox)
AimBtn.Size = UDim2.new(1,0,1,0)
AimBtn.BackgroundTransparency = 1
AimBtn.Text = ""

local AimTxt = Instance.new("TextLabel", Menu)
AimTxt.Position = UDim2.new(0.15,0,0.12,0)
AimTxt.Size = UDim2.new(0,150,0,30)
AimTxt.Text = "Ativar Aimbot"
AimTxt.TextColor3 = Color3.new(1,1,1)
AimTxt.Font = Enum.Font.GothamBold

-- EXIBIR FOV
local FovBox = Instance.new("Frame", Menu)
FovBox.Size = UDim2.new(0,28,0,28)
FovBox.Position = UDim2.new(0.6,0,0.12,0)
FovBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", FovBox)

local FovCheck = Instance.new("Frame", FovBox)
FovCheck.Size = UDim2.new(1,0,1,0)
FovCheck.BackgroundColor3 = Color3.fromRGB(255,255,0)
FovCheck.Visible = false
Instance.new("UICorner", FovCheck)

local FovBtn = Instance.new("TextButton", FovBox)
FovBtn.Size = UDim2.new(1,0,1,0)
FovBtn.BackgroundTransparency = 1
FovBtn.Text = ""

local FovTxt = Instance.new("TextLabel", Menu)
FovTxt.Position = UDim2.new(0.7,0,0.12,0)
FovTxt.Size = UDim2.new(0,100,0,30)
FovTxt.Text = "Exibir FOV"
FovTxt.TextColor3 = Color3.new(1,1,1)
FovTxt.Font = Enum.Font.GothamBold

-- IGNORAR DERRUBADOS
local DownBox = Instance.new("Frame", Menu)
DownBox.Size = UDim2.new(0,28,0,28)
DownBox.Position = UDim2.new(0.05,0,0.20,0)
DownBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", DownBox)

local DownCheck = Instance.new("Frame", DownBox)
DownCheck.Size = UDim2.new(1,0,1,0)
DownCheck.BackgroundColor3 = Color3.fromRGB(0,150,255)
DownCheck.Visible = false
Instance.new("UICorner", DownCheck)

local DownBtn = Instance.new("TextButton", DownBox)
DownBtn.Size = UDim2.new(1,0,1,0)
DownBtn.BackgroundTransparency = 1
DownBtn.Text = ""

local DownTxt = Instance.new("TextLabel", Menu)
DownTxt.Position = UDim2.new(0.15,0,0.20,0)
DownTxt.Size = UDim2.new(0,180,0,30)
DownTxt.Text = "Ignorar Derrubados"
DownTxt.TextColor3 = Color3.new(1,1,1)
DownTxt.Font = Enum.Font.GothamBold

-- APENAS VISIVEIS
local VisBox = Instance.new("Frame", Menu)
VisBox.Size = UDim2.new(0,28,0,28)
VisBox.Position = UDim2.new(0.6,0,0.20,0)
VisBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", VisBox)

local VisCheck = Instance.new("Frame", VisBox)
VisCheck.Size = UDim2.new(1,0,1,0)
VisCheck.BackgroundColor3 = Color3.fromRGB(255,0,0)
VisCheck.Visible = false
Instance.new("UICorner", VisCheck)

local VisBtn = Instance.new("TextButton", VisBox)
VisBtn.Size = UDim2.new(1,0,1,0)
VisBtn.BackgroundTransparency = 1
VisBtn.Text = ""

local VisTxt = Instance.new("TextLabel", Menu)
VisTxt.Position = UDim2.new(0.7,0,0.20,0)
VisTxt.Size = UDim2.new(0,120,0,30)
VisTxt.Text = "Apenas Visíveis"
VisTxt.TextColor3 = Color3.new(1,1,1)
VisTxt.Font = Enum.Font.GothamBold

-- // BARRA FOV
local BarBack = Instance.new("Frame", Menu)
BarBack.Size = UDim2.new(0.5,0,0,10)
BarBack.Position = UDim2.new(0.2,0,0.28,0)
BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", BarBack)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0.72,0,1,0)
BarFill.BackgroundColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", BarFill)

local BarText = Instance.new("TextLabel", Menu)
BarText.Position = UDim2.new(0.75,0,0.25,0)
BarText.Size = UDim2.new(0,80,0,20)
BarText.Text = "Regular FOV"
BarText.TextColor3 = Color3.new(1,1,1)
BarText.Font = Enum.Font.GothamBold

local ValueText = Instance.new("TextLabel", Menu)
ValueText.Position = UDim2.new(0.35,0,0.30,0)
ValueText.Size = UDim2.new(0,100,0,20)
ValueText.Text = Fov..".0"
ValueText.TextColor3 = Color3.new(1,1,1)
ValueText.Font = Enum.Font.GothamBold

-- // PARTE
local PartBox = Instance.new("Frame", Menu)
PartBox.Size = UDim2.new(0.4,0,0,35)
PartBox.Position = UDim2.new(0.2,0,0.35,0)
PartBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", PartBox)

local PartText = Instance.new("TextLabel", PartBox)
PartText.Size = UDim2.new(1,-40,1,0)
PartText.Position = UDim2.new(0,10,0,0)
PartText.BackgroundTransparency = 1
PartText.Text = "Cabeça"
PartText.TextColor3 = Color3.new(1,1,1)
PartText.Font = Enum.Font.GothamBold

local Arrow = Instance.new("TextLabel", PartBox)
Arrow.Size = UDim2.new(0,30,1,0)
Arrow.Position = UDim2.new(0.85,0,0,0)
Arrow.BackgroundTransparency = 1
Arrow.Text = "▼"
Arrow.TextColor3 = Color3.new(1,1,1)

local PuxadaText = Instance.new("TextLabel", Menu)
PuxadaText.Position = UDim2.new(0.65,0,0.35,0)
PuxadaText.Size = UDim2.new(0,80,0,35)
PuxadaText.Text = "Puxada"
PuxadaText.TextColor3 = Color3.new(1,1,1)
PuxadaText.Font = Enum.Font.GothamBold

-- // TIPO DE AIMBOT
local TypeText = Instance.new("TextLabel", Menu)
TypeText.Position = UDim2.new(0.2,0,0.45,0)
TypeText.Size = UDim2.new(0,150,0,25)
TypeText.Text = "Tipo de Aimbot:"
TypeText.TextColor3 = Color3.new(1,1,1)
TypeText.Font = Enum.Font.GothamBold

local Radio1 = Instance.new("TextButton", Menu)
Radio1.Size = UDim2.new(0,20,0,20)
Radio1.Position = UDim2.new(0.2,0,0.50,0)
Radio1.BackgroundColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", Radio1).CornerRadius = UDim.new(1,0)

local RadioText1 = Instance.new("TextLabel", Menu)
RadioText1.Position = UDim2.new(0.25,0,0.50,0)
RadioText1.Size = UDim2.new(0,80,0,20)
RadioText1.Text = "Ao Atirar"
RadioText1.TextColor3 = Color3.new(1,1,1)
RadioText1.Font = Enum.Font.GothamBold

local Radio2 = Instance.new("TextButton", Menu)
Radio2.Size = UDim2.new(0,20,0,20)
Radio2.Position = UDim2.new(0.5,0,0.50,0)
Radio2.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", Radio2).CornerRadius = UDim.new(1,0)

local RadioText2 = Instance.new("
    
