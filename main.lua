-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = Workspace.CurrentCamera

-- // ATUALIZA QUANDO MORRE
Player.CharacterAdded:Connect(function(char)
    Character = char
end)

-- ==============================================
-- // CRIAÇÃO DA GUI - ESTILO IGUAL VÍDEO
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MG_Hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- ==============================================
-- // BOTÃO FLUTUANTE MG
-- ==============================================
local BtnMG = Instance.new("TextButton")
BtnMG.Name = "BtnMG"
BtnMG.Parent = ScreenGui
BtnMG.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
BtnMG.BackgroundTransparency = 0.2
BtnMG.BorderSizePixel = 0
BtnMG.Size = UDim2.new(0, 65, 0, 65)
BtnMG.Position = UDim2.new(0, 20, 0.35, 0)
BtnMG.Font = Enum.Font.GothamBlack
BtnMG.Text = "MG"
BtnMG.TextColor3 = Color3.new(1, 0, 0)
BtnMG.TextSize = 26
BtnMG.AutoLocalize = false

-- BORDA ARREDONDADA E SOMBRA
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = BtnMG

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Color = Color3.new(1, 0, 0)
UIStrokeBtn.Thickness = 2
UIStrokeBtn.Parent = BtnMG

-- ANIMAÇÃO DO BOTÃO
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenGoal = {BackgroundTransparency = 0.5}
local tween = TweenService:Create(BtnMG, tweenInfo, tweenGoal)
tween:Play()

-- ==============================================
-- // MENU PRINCIPAL - ESTILO TOP
-- ==============================================
local Menu = Instance.new("Frame")
Menu.Name = "MenuPrincipal"
Menu.Parent = ScreenGui
Menu.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
Menu.BorderSizePixel = 0
Menu.Size = UDim2.new(0, 320, 0, 450)
Menu.Position = UDim2.new(0, 100, 0.2, 0)
Menu.Visible = false
Menu.AutoLocalize = false

-- BORDA E SOMBRA DO MENU
local UICornerMenu = Instance.new("UICorner")
UICornerMenu.CornerRadius = UDim.new(0, 12)
UICornerMenu.Parent = Menu

local UIStrokeMenu = Instance.new("UIStroke")
UIStrokeMenu.Color = Color3.new(1, 0, 0)
UIStrokeMenu.Thickness = 1.5
UIStrokeMenu.Parent = Menu

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0.1, 0.1, 0.1)),
    ColorSequenceKeypoint.new(1, Color3.new(0.05, 0.05, 0.05))
}
UIGradient.Parent = Menu

-- ==============================================
-- // TOPO DO MENU
-- ==============================================
local TopBar = Instance.new("Frame")
TopBar.Parent = Menu
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.new(1, 0, 0)
TopBar.BorderSizePixel = 0

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 12)
UICornerTop.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "✦ MG HUB ✦"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ==============================================
-- // FUNÇÃO CRIAR BOTÃO ESTILO VÍDEO
-- ==============================================
local Y = 60
local function AddButton(nome, func)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Menu
    Btn.Size = UDim2.new(0.9, 0, 0, 42)
    Btn.Position = UDim2.new(0.05, 0, 0, Y)
    Btn.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    Btn.BorderSizePixel = 0
    Btn.Text = nome
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.AutoLocalize = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = Btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 0, 0)
    stroke.Thickness = 1
    stroke.Parent = Btn

    local estado = false
    Btn.MouseButton1Click:Connect(function()
        estado = not estado
        if estado then
            Btn.BackgroundColor3 = Color3.new(1, 0, 0)
            Btn.TextColor3 = Color3.new(0, 0, 0)
        else
            Btn.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
            Btn.TextColor3 = Color3.new(1, 1, 1)
        end
        func(estado)
    end)

    Y = Y + 50
end

-- ==============================================
-- // CONFIGS
-- ==============================================
local AIMBOT_ON = false
local FARM_ON = false
local PEGAR_ARMA_ON = false
local ESP_INOCENTE_ON = false
local ESP_MURDER_ON = false
local ESP_XERIFE_ON = false

-- ==============================================
-- // DETECTAR FUNÇÃO
-- ==============================================
local function GetRole(plr)
    if not plr.Character then return "Inocente" end
    local items = {}
    if plr.Backpack then for _,v in pairs(plr.Backpack:GetChildren()) do table.insert(items, v) end end
    if plr.Character then for _,v in pairs(plr.Character:GetChildren()) do table.insert(items, v) end end
    for _, v in pairs(items) do
        if v.Name:lower():find("knife") or v.Name:lower():find("murder") then return "Murder" end
        if v.Name:lower():find("gun") or v.Name:lower():find("revolver") or v.Name:lower():find("sheriff") then return "Sheriff" end
    end
    return "Inocente"
end

-- ==============================================
-- // ESP DE LINHA / CONTORNO (IGUAL FOTO)
-- ==============================================
local function ApplyESP(plr, cor)
    if plr == Player or not plr.Character then return end
    if plr.Character:FindFirstChild("MG_ESP") then plr.Character.MG_ESP:Destroy() end
    
    local folder = Instance.new("Model")
    folder.Name = "MG_ESP"
    folder.Parent = plr.Character
    
    for _, part in pairs(plr.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "Line"
            box.Adornee = part
            box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
            box.Color3 = cor
            box.Transparency = 0.1
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Parent = folder
        end
    end
end

-- ==============================================
// ADICIONAR OPÇÕES
-- ==============================================
AddButton("🎯 AIMBOT MURDER", function(v) AIMBOT_ON = v end)
AddButton("💰 AUTO FARM", function(v) FARM_ON = v end)
AddButton("🔫 PEGAR ARMA", function(v) PEGAR_ARMA_ON = v end)
AddButton("🟢 ESP INOCENTE", function(v) ESP_INOCENTE_ON = v end)
AddButton("🔴 ESP MURDER", function(v) ESP_MURDER_ON = v end)
AddButton("🔵 ESP XERIFE", function(v) ESP_XERIFE_ON = v end)

-- ==============================================
-- // RODAPÉ
-- ==============================================
local Footer = Instance.new("TextLabel")
Footer.Parent = Menu
Footer.BackgroundTransparency = 1
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -35)
Footer.Font = Enum.Font.GothamBold
Footer.Text = "TikTok: @Phzonn_mg9"
Footer.TextColor3 = Color3.new(1, 0, 0)
Footer.TextSize = 13

-- ==============================================
-- // SISTEMA DE ARRASTAR
-- ==============================================
local function EnableDrag(obj)
    local dragging = false
    local startPos, startMouse = nil, nil
    obj.MouseButton1Down:Connect(function()
        dragging = true
        startMouse = UserInputService:GetMouseLocation()
        startPos = obj.Position
    end)
    UserInputService.InputChanged:Connect(function()
        if dragging then
            local delta = UserInputService:GetMouseLocation() - startMouse
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

EnableDrag(Menu)
EnableDrag(BtnMG)

-- ABRIR E FECHAR MENU
BtnMG.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- ==============================================
-- // LOOPS PRINCIPAIS
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local role = GetRole(plr)
            if role == "Murder" and ESP_MURDER_ON then
                ApplyESP(plr, Color3.new(1,0,0))
            elseif role == "Sheriff" and ESP_XERIFE_ON then
                ApplyESP(plr, Color3.new(0,0,1))
            elseif role == "Inocente" and ESP_INOCENTE_ON then
                ApplyESP(plr, Color3.new(0,1,0))
            elseif plr.Character:FindFirstChild("MG_ESP") then
                plr.Character.MG_ESP:Destroy()
            end
        end
    end
    
    -- AIMBOT
    if AIMBOT_ON and Character and Character:FindFirstChild("Head") then
        local target = nil
        local dist = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
                if GetRole(plr) == "Murder" then
                    local mag = (Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if mag < dist then dist = mag target = plr end
                end
            end
        end
        if target and target.Character.Head then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- AUTO FARM
RunService.Heartbeat:Connect(function()
    if FARM_ON and Character and Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Character.HumanoidRootPart
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("box")) then
                if (hrp.Position - v.Position).Magnitude < 12 then
                    local old = hrp.CFrame
                    hrp.CFrame = CFrame.new(v.Position + Vector3.new(0,1,0))
                    task.wait(0.08)
                    hrp.CFrame = old
                end
            end
        end
    end
end)

-- PEGAR ARMA
RunService.Heartbeat:Connect(function()
    if PEGAR_ARMA_ON and Character and Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Character.HumanoidRootPart
        local posIni = hrp.Position
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Tool") and v.Parent == Workspace and v.Name:lower():find("gun") then
                if (hrp.Position - v.Position).Magnitude < 40 then
                    hrp.CFrame = CFrame.new(v.Position)
                    task.wait(0.15)
                    v.Parent = Player.Backpack
                    hrp.CFrame = CFrame.new(posIni)
                end
            end
        end
    end
end)

print("✅ MG HUB CARREGADO - ESTILO TOP!")

