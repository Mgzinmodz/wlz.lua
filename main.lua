--// SERVICES
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local Player = Players.LocalPlayer

--// VARIAVEIS GLOBAIS
getgenv().Config = getgenv().Config or {
    Tema = "Verde",
    Opacidade = 1,
    Tamanho = 1,
    AutoIniciar = true
}

--// CRIA GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MG_HUB_PRO"
Gui.Parent = game:GetService("CoreGui")
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Gui.ResetOnSpawn = false

--// =============================================
--// 🔘 BOTÃO FLUTUANTE
--// =============================================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatButton"
FloatBtn.Size = UDim2.new(0,55,0,55)
FloatBtn.Position = UDim2.new(0,20,0.5,0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(10,10,10)
FloatBtn.Text = "MG"
FloatBtn.TextColor3 = Color3.fromRGB(0,255,100)
FloatBtn.Font = Enum.Font.GothamBlack
FloatBtn.TextSize = 20
FloatBtn.ClipsDescendants = true
FloatBtn.Parent = Gui

-- Borda e Glow
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1,0)
local StrokeBtn = Instance.new("UIStroke", FloatBtn)
StrokeBtn.Color = Color3.fromRGB(0,255,100)
StrokeBtn.Thickness = 1.5
StrokeBtn.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Animação Glow
coroutine.wrap(function()
    while wait(1) do
        TweenService:Create(StrokeBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.3}):Play()
        wait(1.2)
        TweenService:Create(StrokeBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0}):Play()
    end
end)()

--// FUNÇÃO ARRASTAR BOTÃO
local function MakeDraggable(object)
    local dragging, startPos, startInput = false, nil, nil
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = object.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
MakeDraggable(FloatBtn)

--// =============================================
--// 📦 MENU PRINCIPAL
--// =============================================
local Menu = Instance.new("Frame")
Menu.Name = "MainMenu"
Menu.Size = UDim2.new(0,380,0,480)
Menu.Position = UDim2.new(0,90,0.5,-240)
Menu.BackgroundColor3 = Color3.fromRGB(15,15,15)
Menu.Visible = false
Menu.Parent = Gui
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,12)
local StrokeMenu = Instance.new("UIStroke", Menu)
StrokeMenu.Color = Color3.fromRGB(0,255,100)
StrokeMenu.Thickness = 2

-- Sombra Interna
local UIStroke = Instance.new("UIStroke", Menu)
UIStroke.Thickness = 1
UIStroke.Color = Color3.new(0,0,0)

--// TOPO
local TopBar = Instance.new("Frame")
TopBar.Parent = Menu
TopBar.Size = UDim2.new(1,0,0,35)
TopBar.BackgroundColor3 = Color3.fromRGB(10,10,10)
TopBar.Position = UDim2.new(0,0,0,0)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1,-20,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "MG HUB ✦ FREE FIRE STYLE"
Title.TextColor3 = Color3.fromRGB(0,255,100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- BOTAO FECHAR
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

--// =============================================
--// 📑 LAYOUT DE ABAS E CONTEUDO
--// =============================================
local SideBar = Instance.new("Frame")
SideBar.Parent = Menu
SideBar.Size = UDim2.new(0,50,1,-40)
SideBar.Position = UDim2.new(0,5,0,38)
SideBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0,10)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = Menu
ContentArea.Size = UDim2.new(1,-70,1,-45)
ContentArea.Position = UDim2.new(0,60,0,40)
ContentArea.BackgroundTransparency = 1

--// =============================================
--// 🔘 BOTOES DAS ABAS
--// =============================================
local BtnAim = Instance.new("TextButton")
BtnAim.Parent = SideBar
BtnAim.Size = UDim2.new(0.9,0,0,40)
BtnAim.Position = UDim2.new(0.05,0,0,10)
BtnAim.BackgroundColor3 = Color3.fromRGB(0,255,100)
BtnAim.Text = "🎯"
BtnAim.TextColor3 = Color3.new(0,0,0)
BtnAim.Font = Enum.Font.GothamBold
Instance.new("UICorner", BtnAim).CornerRadius = UDim.new(0,8)

local BtnVis = Instance.new("TextButton")
BtnVis.Parent = SideBar
BtnVis.Size = UDim2.new(0.9,0,0,40)
BtnVis.Position = UDim2.new(0.05,0,0,60)
BtnVis.BackgroundColor3 = Color3.fromRGB(30,30,30)
BtnVis.Text = "👁️"
BtnVis.TextColor3 = Color3.new(1,1,1)
BtnVis.Font = Enum.Font.GothamBold
Instance.new("UICorner", BtnVis).CornerRadius = UDim.new(0,8)

local BtnConf = Instance.new("TextButton")
BtnConf.Parent = SideBar
BtnConf.Size = UDim2.new(0.9,0,0,40)
BtnConf.Position = UDim2.new(0.05,0,0,110)
BtnConf.BackgroundColor3 = Color3.fromRGB(30,30,30)
BtnConf.Text = "⚙️"
BtnConf.TextColor3 = Color3.new(1,1,1)
BtnConf.Font = Enum.Font.GothamBold
Instance.new("UICorner", BtnConf).CornerRadius = UDim.new(0,8)

--// =============================================
--// 🎯 ABA AIM
--// =============================================
local TabAim = Instance.new("Frame")
TabAim.Parent = ContentArea
TabAim.Size = UDim2.new(1,0,1,0)
TabAim.BackgroundTransparency = 1

-- Titulo
local TitleAim = Instance.new("TextLabel")
TitleAim.Parent = TabAim
TitleAim.Size = UDim2.new(1,0,0,25)
TitleAim.Position = UDim2.new(0,0,0,0)
TitleAim.BackgroundTransparency = 1
TitleAim.Text = "ASSISTÊNCIA DE MIRA"
TitleAim.TextColor3 = Color3.fromRGB(0,255,100)
TitleAim.Font = Enum.Font.GothamBold
TitleAim.TextSize = 16

-- BOTAO AIMBOT
local AimToggle = Instance.new("TextButton")
AimToggle.Parent = TabAim
AimToggle.Size = UDim2.new(1,0,0,40)
AimToggle.Position = UDim2.new(0,0,0,35)
AimToggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
AimToggle.Text = "▶ ATIVAR AIMBOT"
AimToggle.TextColor3 = Color3.new(1,1,1)
AimToggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", AimToggle).CornerRadius = UDim.new(0,8)

-- MODO DE MIRA
local ModeText = Instance.new("TextLabel")
ModeText.Parent = TabAim
ModeText.Size = UDim2.new(1,0,0,20)
ModeText.Position = UDim2.new(0,0,0,85)
ModeText.BackgroundTransparency = 1
ModeText.Text = "MODO DE ATIVAÇÃO"
ModeText.TextColor3 = Color3.fromRGB(200,200,200)
ModeText.Font = Enum.Font.Gotham

local Mode1 = Instance.new("TextButton")
Mode1.Parent = TabAim
Mode1.Size = UDim2.new(0.48,0,0,35)
Mode1.Position = UDim2.new(0,0,0,110)
Mode1.BackgroundColor3 = Color3.fromRGB(0,180,80)
Mode1.Text = "AO OLHAR"
Mode1.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", Mode1).CornerRadius = UDim.new(0,8)

local Mode2 = Instance.new("TextButton")
Mode2.Parent = TabAim
Mode2.Size = UDim2.new(0.48,0,0,35)
Mode2.Position = UDim2.new(0.52,0,0,110)
Mode2.BackgroundColor3 = Color3.fromRGB(40,40,40)
Mode2.Text = "AO ATIRAR"
Mode2.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Mode2).CornerRadius = UDim.new(0,8)

-- SLIDER FOV
local FovTitle = Instance.new("TextLabel")
FovTitle.Parent = TabAim
FovTitle.Size = UDim2.new(1,0,0,20)
FovTitle.Position = UDim2.new(0,0,0,160)
FovTitle.BackgroundTransparency = 1
FovTitle.Text = "CAMPO DE VISÃO (FOV): 250"
FovTitle.TextColor3 = Color3.fromRGB(200,200,200)
FovTitle.Font = Enum.Font.Gotham

local FovBack = Instance.new("Frame")
FovBack.Parent = TabAim
FovBack.Size = UDim2.new(1,0,0,12)
FovBack.Position = UDim2.new(0,0,0,185)
FovBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", FovBack).CornerRadius = UDim.new(1,0)

local FovFill = Instance.new("Frame")
FovFill.Parent = FovBack
FovFill.Size = UDim2.new(0.5,0,1,0)
FovFill.BackgroundColor3 = Color3.fromRGB(0,255,100)
Instance.new("UICorner", FovFill).CornerRadius = UDim.new(1,0)

-- CIRCULO FOV
local CircleFOV = Instance.new("ImageLabel")
CircleFOV.Name = "CircleFOV"
CircleFOV.Parent = Gui
CircleFOV.Size = UDim2.new(0,500,0,500)
CircleFOV.Position = UDim2.new(0.5,-250,0.5,-250)
CircleFOV.BackgroundTransparency = 1
CircleFOV.Image = "rbxassetid://4999832484"
CircleFOV.ImageColor3 = Color3.fromRGB(0,255,100)
CircleFOV.ImageTransparency = 0.4
CircleFOV.Visible = false

-- BOTAO MOSTRAR CIRCULO
local ShowCircle = Instance.new("TextButton")
ShowCircle.Parent = TabAim
ShowCircle.Size = UDim2.new(1,0,0,35)
ShowCircle.Position = UDim2.new(0,0,0,210)
ShowCircle.BackgroundColor3 = Color3.fromRGB(35,35,35)
ShowCircle.Text = "👁️ EXIBIR CIRCULO FOV"
ShowCircle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ShowCircle).CornerRadius = UDim.new(0,8)

--// =============================================
--// 👁️ ABA VISUAL
--// =============================================
local TabVis = Instance.new("Frame")
TabVis.Parent = ContentArea
TabVis.Size = UDim2.new(1,0,1,0)
TabVis.BackgroundTransparency = 1
TabVis.Visible = false

local TitleVis = Instance.new("TextLabel")
TitleVis.Parent = TabVis
TitleVis.Size = UDim2.new(1,0,0,25)
TitleVis.Position = UDim2.new(0,0,0,0)
TitleVis.BackgroundTransparency = 1
TitleVis.Text = "ELEMENTOS VISUAIS"
TitleVis.TextColor3 = Color3.fromRGB(0,255,100)
TitleVis.Font = Enum.Font.GothamBold
TitleVis.TextSize = 16

local EspBtn = Instance.new("TextButton")
EspBtn.Parent = TabVis
EspBtn.Size = UDim2.new(1,0,0,40)
EspBtn.Position = UDim2.new(0,0,0,35)
EspBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
EspBtn.Text = "🔴 DESTACAR JOGADORES"
EspBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", EspBtn).CornerRadius = UDim.new(0,8)

local DistBtn = Instance.new("TextButton")
DistBtn.Parent = TabVis
DistBtn.Size = UDim2.new(1,0,0,40)
DistBtn.Position = UDim2.new(0,0,0,85)
DistBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
DistBtn.Text = "📏 EXIBIR DISTÂNCIA"
DistBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", DistBtn).CornerRadius = UDim.new(0,8)

local LineBtn = Instance.new("TextButton")
LineBtn.Parent = TabVis
LineBtn.Size = UDim2.new(1,0,0,40)
LineBtn.Position = UDim2.new(0,0,0,135)
LineBtn
