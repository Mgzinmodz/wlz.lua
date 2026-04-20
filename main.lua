-- // SERVICES
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

-- // VARS
local Enabled = false
local Fov = 300
local Mode = "Ao Olhar"
local MouseDown = false
local EspEnabled = false
local ShowFovCircle = false

-- // GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "MG_FFH4X"
Gui.ResetOnSpawn = false

-- // CIRCULO FOV
local FovCircle = Instance.new("ImageLabel", Gui)
FovCircle.Name = "CircleFOV"
FovCircle.Size = UDim2.new(0, Fov*2, 0, Fov*2)
FovCircle.Position = UDim2.new(0.5, -Fov, 0.5, -Fov)
FovCircle.BackgroundTransparency = 1
FovCircle.Image = "rbxassetid://4999832484"
FovCircle.ImageColor3 = Color3.fromRGB(255,0,0)
FovCircle.ImageTransparency = 0.5
FovCircle.Visible = false

-- // MENU
local Menu = Instance.new("Frame", Gui)
Menu.Size = UDim2.new(0,420,0,380)
Menu.Position = UDim2.new(0.5,-210,0.5,-190)
Menu.BackgroundColor3 = Color3.fromRGB(12,12,12)

Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,6)

local Stroke = Instance.new("UIStroke", Menu)
Stroke.Color = Color3.fromRGB(255,0,0)
Stroke.Thickness = 2

-- // TOP BAR
local Top = Instance.new("Frame", Menu)
Top.Size = UDim2.new(1,0,0,35)
Top.BackgroundColor3 = Color3.fromRGB(180,0,0)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "FFH4X @MG - STYLE"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15

-- // CHECKBOX AIMBOT
local Box = Instance.new("Frame", Menu)
Box.Size = UDim2.new(0,28,0,28)
Box.Position = UDim2.new(0.05,0,0.15,0)
Box.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", Box).CornerRadius = UDim.new(0,4)

local Check = Instance.new("Frame", Box)
Check.Size = UDim2.new(1,0,1,0)
Check.BackgroundColor3 = Color3.fromRGB(0,200,0)
Check.Visible = false
Instance.new("UICorner", Check).CornerRadius = UDim.new(0,4)

local BtnBox = Instance.new("TextButton", Box)
BtnBox.Size = UDim2.new(1,0,1,0)
BtnBox.Text = ""
BtnBox.BackgroundTransparency = 1

local Txt = Instance.new("TextLabel", Menu)
Txt.Position = UDim2.new(0.15,0,0.15,0)
Txt.Size = UDim2.new(0,200,0,30)
Txt.Text = "Aimbot Rage"
Txt.TextColor3 = Color3.new(1,1,1)
Txt.BackgroundTransparency = 1
Txt.Font = Enum.Font.GothamBold
Txt.TextSize = 18

-- // CHECKBOX ESP
local BoxEsp = Instance.new("Frame", Menu)
BoxEsp.Size = UDim2.new(0,28,0,28)
BoxEsp.Position = UDim2.new(0.05,0,0.25,0)
BoxEsp.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", BoxEsp).CornerRadius = UDim.new(0,4)

local CheckEsp = Instance.new("Frame", BoxEsp)
CheckEsp.Size = UDim2.new(1,0,1,0)
CheckEsp.BackgroundColor3 = Color3.fromRGB(0,100,255)
CheckEsp.Visible = false
Instance.new("UICorner", CheckEsp).CornerRadius = UDim.new(0,4)

local BtnBoxEsp = Instance.new("TextButton", BoxEsp)
BtnBoxEsp.Size = UDim2.new(1,0,1,0)
BtnBoxEsp.Text = ""
BtnBoxEsp.BackgroundTransparency = 1

local TxtEsp = Instance.new("TextLabel", Menu)
TxtEsp.Position = UDim2.new(0.15,0,0.25,0)
TxtEsp.Size = UDim2.new(0,200,0,30)
TxtEsp.Text = "ESP Inimigos"
TxtEsp.TextColor3 = Color3.new(1,1,1)
TxtEsp.BackgroundTransparency = 1
TxtEsp.Font = Enum.Font.GothamBold
TxtEsp.TextSize = 18

-- // CHECKBOX EXIBIR FOV
local BoxFov = Instance.new("Frame", Menu)
BoxFov.Size = UDim2.new(0,28,0,28)
BoxFov.Position = UDim2.new(0.05,0,0.35,0)
BoxFov.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", BoxFov).CornerRadius = UDim.new(0,4)

local CheckFov = Instance.new("Frame", BoxFov)
CheckFov.Size = UDim2.new(1,0,1,0)
CheckFov.BackgroundColor3 = Color3.fromRGB(255,255,0)
CheckFov.Visible = false
Instance.new("UICorner", CheckFov).CornerRadius = UDim.new(0,4)

local BtnBoxFov = Instance.new("TextButton", BoxFov)
BtnBoxFov.Size = UDim2.new(1,0,1,0)
BtnBoxFov.Text = ""
BtnBoxFov.BackgroundTransparency = 1

local TxtFov = Instance.new("TextLabel", Menu)
TxtFov.Position = UDim2.new(0.15,0,0.35,0)
TxtFov.Size = UDim2.new(0,200,0,30)
TxtFov.Text = "Exibir FOV"
TxtFov.TextColor3 = Color3.new(1,1,1)
TxtFov.BackgroundTransparency = 1
TxtFov.Font = Enum.Font.GothamBold
TxtFov.TextSize = 18

-- // TOGGLES
BtnBox.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    Check.Visible = Enabled
end)

BtnBoxEsp.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    CheckEsp.Visible = EspEnabled
end)

BtnBoxFov.MouseButton1Click:Connect(function()
    ShowFovCircle = not ShowFovCircle
    CheckFov.Visible = ShowFovCircle
    FovCircle.Visible = ShowFovCircle and Enabled
end)

-- // FOV BAR
local BarBack = Instance.new("Frame", Menu)
BarBack.Size = UDim2.new(0.6,0,0,8)
BarBack.Position = UDim2.new(0.2,0,0.48,0)
BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", BarBack)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0.5,0,1,0)
BarFill.BackgroundColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", BarFill)

local Drag = false

BarBack.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        Drag = true
    end
end)

UIS.InputEnded:Connect(function()
    Drag = false
end)

UIS.InputChanged:Connect(function(i)
    if Drag then
        local X = i.Position.X
        local Start = BarBack.AbsolutePosition.X
        local Size = BarBack.AbsoluteSize.X
        local Percent = math.clamp((X - Start)/Size,0,1)

        BarFill:TweenSize(UDim2.new(Percent,0,1,0),"Out","Quad",0.05,true)

        Fov = math.floor(Percent * 500)
        FovCircle.Size = UDim2.new(0, Fov*2, 0, Fov*2)
        FovCircle.Position = UDim2.new(0.5, -Fov, 0.5, -Fov)
    end
end)

-- // FOV TEXT
local FovTxt = Instance.new("TextLabel", Menu)
FovTxt.Position = UDim2.new(0.8,0,0.45,0)
FovTxt.Size = UDim2.new(0,100,0,20)
FovTxt.Text = "FOV: "..Fov
FovTxt.TextColor3 = Color3.new(1,1,1)
FovTxt.BackgroundTransparency = 1
FovTxt.Font = Enum.Font.GothamBold

RunService.RenderStepped:Connect(function()
    FovTxt.Text = "FOV: "..Fov
end)

-- // BOTÕES
local function MakeBtn(text,pos)
    local b = Instance.new("TextButton", Menu)
    b.Size = UDim2.new(0.35,0,0,35)
    b.Position = pos
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", b)
    return b
end

local Btn1 = MakeBtn("Ao Olhar",UDim2.new(0.2,0,0.60,0))
local Btn2 = MakeBtn("Ao Atirar",UDim2.new(0.57,0,0.60,0))

Btn1.BackgroundColor3 = Color3.fromRGB(255,0,0)

Btn1.MouseButton1Click:Connect(function()
    Mode = "Ao Olhar"
    Btn1.BackgroundColor3 = Color3.fromRGB(255,0,0)
    Btn2.BackgroundColor3 = Color3.fromRGB(40,40,40)
end)

Btn2.MouseButton1Click:Connect(function()
    Mode = "Ao Atirar"
    Btn2.BackgroundColor3 = Color3.fromRGB(255,0,0)
    Btn1.BackgroundColor3 = Color3.fromRGB(40,40,40)
end)

-- // DRAG MENU
local dragging = false
local start, pos

Menu.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        start = i.Position
        pos = Menu.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging then
        local delta = i.Position - start
        Menu.Position = UDim2.new(pos.X.Scale,pos.X.Offset+delta.X,pos.Y.Scale,pos.Y.Offset+delta.Y)
    end
end)

UIS.InputEnded:Connect(function()
    dragging = false
end)

-- // INPUT
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        MouseDown = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        MouseDown = false
    end
end)

-- // FUNÇÕES

-- AIMBOT
local function GetClosest()
    local target, dist = nil, math.huge

    for _,v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

            if mag < dist and mag < Fov and vis then
                dist = mag
                target = v
            end
        end
    end

    return target
end

-- ESP
local function CreateEsp(character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "MG_ESP"
    highlight.Adornee = character
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    return highlight
end

RunService.RenderStepped:Connect(function()
    if Enabled then
        local t = GetClosest()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            if Mode == "Ao Olhar" or (Mode == "Ao Atirar" and MouseDown) then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), 0.2)
            end
        end
    end

    -- ESP LOGIC
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character then
            if EspEnabled then
                if not v.Character:FindFirstChild("MG_ESP") then
                    CreateEsp(v.Character)
                end
            else
                if v.Character:FindFirstChild("MG_ESP") then
                    v.Character.MG_ESP:Destroy()
                end
            end
        end
    end
end)

print("✅ FFH4X STYLE LOADED - MG MODZ")
