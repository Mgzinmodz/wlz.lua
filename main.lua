-- // PROTEÇÃO
if getgenv().MG_HUB_LOADED then return end
getgenv().MG_HUB_LOADED = true

-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = Player.Character or Player.CharacterAdded:Wait()

Player.CharacterAdded:Connect(function(c) Character = c end)

-- // VERIFICA JOGO
local JogoAtivo = false
coroutine.wrap(function()
    while task.wait(0.3) do
        JogoAtivo = false
        if workspace:FindFirstChild("Running") and workspace.Running.Value then JogoAtivo = true end
        if workspace:FindFirstChild("RoundInProgress") and workspace.RoundInProgress.Value then JogoAtivo = true end
        if workspace:FindFirstChild("GameStarted") and workspace.GameStarted.Value then JogoAtivo = true end
    end
end)()

-- // GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MG_HUB"
Gui.Parent = game:GetService("CoreGui")
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- // BOTÃO
local Btn = Instance.new("TextButton")
Btn.Parent = Gui
Btn.Size = UDim2.new(0,60,0,60)
Btn.Position = UDim2.new(0,20,0.5,0)
Btn.Text = "MG"
Btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
Btn.TextColor3 = Color3.fromRGB(255,0,0)
Btn.Font = Enum.Font.GothamBlack
Btn.TextSize = 24
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", Btn)
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Thickness = 2

-- // MENU
local Menu = Instance.new("Frame")
Menu.Parent = Gui
Menu.Size = UDim2.new(0,260,0,370)
Menu.Position = UDim2.new(0,100,0.5,-180)
Menu.BackgroundColor3 = Color3.fromRGB(20,20,20)
Menu.Visible = false
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,10)
local strokeMenu = Instance.new("UIStroke", Menu)
strokeMenu.Color = Color3.fromRGB(255,0,0)
strokeMenu.Thickness = 1.5

-- // DRAG CORRIGIDO
local function Dragify(obj)
    local dragging = false
    local startPos, startInput, tipoInput

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            tipoInput = input.UserInputType
            startInput = input.Position
            startPos = obj.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == tipoInput then
            local delta = input.Position - startInput
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == tipoInput then
            dragging = false
        end
    end)
end
Dragify(Btn)
Dragify(Menu)

Btn.Activated:Connect(function() Menu.Visible = not Menu.Visible end)

-- // CONFIGS
local AIMBOT = false
local ESP_M = false
local ESP_S = false
local ESP_P = false
local SHOOT_MURDER = false

-- // BOTÕES
local Y = 20
local function AddBtn(txt, func)
    local b = Instance.new("TextButton")
    b.Parent = Menu
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,Y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    local ligado = false
    b.Activated:Connect(function()
        ligado = not ligado
        b.BackgroundColor3 = ligado and Color3.fromRGB(255,0,0) or Color3.fromRGB(40,40,40)
        b.TextColor3 = ligado and Color3.new(0,0,0) or Color3.new(1,1,1)
        func(ligado)
    end)
    Y = Y + 45
end

-- // DETECTAR FUNÇÃO
local function GetRole(plr)
    if not plr.Character then return "Inocente" end
    local tool = plr.Character:FindFirstChildOfClass("Tool")
    if tool then
        local nome = tool.Name:lower()
        if nome:find("knife") or nome:find("murder") then return "Murder" end
        if nome:find("gun") or nome:find("revolver") or nome:find("sheriff") or nome:find("pistol") then return "Sheriff" end
    end
    if plr.Backpack then
        for _,v in pairs(plr.Backpack:GetChildren()) do
            local nome = v.Name:lower()
            if nome:find("knife") or nome:find("murder") then return "Murder" end
            if nome:find("gun") or nome:find("sheriff") then return "Sheriff" end
        end
    end
    return "Inocente"
end

-- // ESP
local function CriarESP(plr, cor)
    if plr == Player or not plr.Character then return end

    local hl = plr.Character:FindFirstChild("MG_ESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "MG_ESP"
        hl.Parent = plr.Character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0
        hl.LineThickness = 2
    end
    hl.FillColor = cor
    hl.OutlineColor = cor
    hl.Enabled = true

    local bg = plr.Character:FindFirstChild("MG_ICON")
    if not bg then
        bg = Instance.new("BillboardGui")
        bg.Name = "MG_ICON"
        bg.Parent = plr.Character
        bg.Size = UDim2.new(0,40,0,40)
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.AlwaysOnTop = true

        local img = Instance.new("ImageLabel")
        img.Name = "Img"
        img.Parent = bg
        img.Size = UDim2.new(1,0,1,0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://6011141178"
    end

    local img = bg:FindFirstChild("Img")
    if img then
        img.ImageColor3 = cor
    end

    bg.Enabled = true
end

local function RemoverESP(plr)
    if plr.Character then
        local hl = plr.Character:FindFirstChild("MG_ESP")
        if hl then hl.Enabled = false end
        local bg = plr.Character:FindFirstChild("MG_ICON")
        if bg then bg.Enabled = false end
    end
end

-- // ACHAR MURDER (CORRIGIDO)
local function GetMurder()
    if not Character or not Character:FindFirstChild("Head") then return nil end

    local alvo = nil
    local dist = 9999

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
            if GetRole(plr) == "Murder" then
                local d = (Character.Head.Position - plr.Character.Head.Position).Magnitude
                if d < dist then
                    dist = d
                    alvo = plr
                end
            end
        end
    end

    return alvo
end

-- // SHOOT (CORRIGIDO)
UIS.InputBegan:Connect(function(input, gp)
    if gp or not SHOOT_MURDER or not JogoAtivo then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local murder = GetMurder()
        if murder and murder.Character and murder.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murder.Character.Head.Position)

            local rs = game:GetService("ReplicatedStorage")
            local remote = rs:FindFirstChild("DefaultServerEvent")
            if remote then
                remote:FireServer(murder.Character.Head, Vector3.new())
            end
        end
    end
end)

-- // BOTÕES
AddBtn("🎯 AIMBOT", function(v) AIMBOT = v end)
AddBtn("🔫 SHOOT MURDER", function(v) SHOOT_MURDER = v end)
AddBtn("🔴 MURDER", function(v) ESP_M = v end)
AddBtn("🔵 SHERIFF", function(v) ESP_S = v end)
AddBtn("🟢 INOCENTE", function(v) ESP_P = v end)

-- // LOOP
local ultimaAtualizacao = 0
RunService.Heartbeat:Connect(function(delta)
    if not JogoAtivo then return end

    ultimaAtualizacao += delta
    if ultimaAtualizacao >= 0.1 then
        ultimaAtualizacao = 0
        
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local cargo = GetRole(plr)
                if cargo == "Murder" and ESP_M then
                    CriarESP(plr, Color3.fromRGB(255,0,0))
                elseif cargo == "Sheriff" and ESP_S then
                    CriarESP(plr, Color3.fromRGB(0,120,255))
                elseif cargo == "Inocente" and ESP_P then
                    CriarESP(plr, Color3.fromRGB(0,255,0))
                else
                    RemoverESP(plr)
                end
            end
        end
    end

    if AIMBOT and Character and Character:FindFirstChild("Head") then
        local murder = GetMurder()
        if murder and murder.Character and murder.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, murder.Character.Head.Position), 0.2)
        end
    end
end)

print("✅ MG HUB - VERSÃO CORRIGIDA SEM ERROS")
