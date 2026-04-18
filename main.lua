-- // PROTEÇÃO CONTRA EXECUÇÃO DUPLICADA
if getgenv().MG_HUB_LOADED then return end
getgenv().MG_HUB_LOADED = true

-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = Player.Character or Player.CharacterAdded:Wait()

Player.CharacterAdded:Connect(function(c)
    Character = c
end)

-- // VERIFICAÇÃO DO JOGO (OTIMIZADA)
local JogoAtivo = false
coroutine.wrap(function()
    while task.wait(0.1) do
        JogoAtivo = false
        if workspace:FindFirstChild("Running") and workspace.Running.Value == true then
            JogoAtivo = true
        elseif workspace:FindFirstChild("RoundInProgress") and workspace.RoundInProgress.Value == true then
            JogoAtivo = true
        elseif workspace:FindFirstChild("GameStarted") and workspace.GameStarted.Value == true then
            JogoAtivo = true
        end
    end
end)()

-- // GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MG_HUB"
Gui.Parent = game:GetService("CoreGui")
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- // BOTÃO MG
local Btn = Instance.new("TextButton")
Btn.Parent = Gui
Btn.Size = UDim2.new(0,60,0,60)
Btn.Position = UDim2.new(0,20,0.5,0)
Btn.Text = "MG"
Btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
Btn.TextColor3 = Color3.fromRGB(255,0,0)
Btn.Font = Enum.Font.GothamBlack
Btn.TextSize = 24
Btn.AutoLocalize = false

local cornerBtn = Instance.new("UICorner", Btn)
cornerBtn.CornerRadius = UDim.new(1,0)
local strokeBtn = Instance.new("UIStroke", Btn)
strokeBtn.Color = Color3.fromRGB(255,0,0)
strokeBtn.Thickness = 2

-- // MENU
local Menu = Instance.new("Frame")
Menu.Parent = Gui
Menu.Size = UDim2.new(0,260,0,330)
Menu.Position = UDim2.new(0,100,0.5,-150)
Menu.BackgroundColor3 = Color3.fromRGB(20,20,20)
Menu.Visible = false
Menu.AutoLocalize = false

local cornerMenu = Instance.new("UICorner", Menu)
cornerMenu.CornerRadius = UDim.new(0,10)
local strokeMenu = Instance.new("UIStroke", Menu)
strokeMenu.Color = Color3.fromRGB(255,0,0)
strokeMenu.Thickness = 1.5

-- // ARRASTAR (CORRIGIDO PARA CELULAR)
local function Dragify(obj)
    local dragging = false
    local startPos, startInput = nil, nil
    
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = obj.Position
            input.Process = true
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

Dragify(Btn)
Dragify(Menu)

-- // ABRIR MENU
Btn.Activated:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- // CRIAR BOTÕES
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
    b.AutoLocalize = false

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

-- // CONFIGS
local AIMBOT = false
local ESP_M = false
local ESP_S = false
local ESP_P = false

-- // DETECTAR FUNÇÃO
local function GetRole(plr)
    if not plr.Character then return "Inocente" end

    local tool = plr.Character:FindFirstChildOfClass("Tool")
    if tool then
        local nome = tool.Name:lower()
        if nome:find("knife") or nome:find("murder") or nome:find("knj") then return "Murder" end
        if nome:find("gun") or nome:find("revolver") or nome:find("sheriff") or nome:find("pistol") then return "Sheriff" end
    end

    if plr:FindFirstChild("Backpack") then
        for _, item in pairs(plr.Backpack:GetChildren()) do
            local nome = item.Name:lower()
            if nome:find("knife") or nome:find("murder") then return "Murder" end
            if nome:find("gun") or nome:find("sheriff") then return "Sheriff" end
        end
    end

    return "Inocente"
end

-- // CRIAR ESP (VER ATRAVÉS DE PAREDE)
local function CriarESP(plr, cor)
    if plr == Player or not plr.Character then return end

    -- Limpa se existir
    local old = plr.Character:FindFirstChild("MG_ESP")
    if old then old:Destroy() end

    local hl = Instance.new("Highlight")
    hl.Name = "MG_ESP"
    hl.Parent = plr.Character
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.LineThickness = 2
    hl.Adornee = plr.Character
    hl.FillColor = cor
    hl.OutlineColor = cor
end

-- // REMOVER ESP
local function RemoverESP(plr)
    if plr.Character then
        local hl = plr.Character:FindFirstChild("MG_ESP")
        if hl then hl:Destroy() end
    end
end

-- // BOTÕES
AddBtn("🎯 AIMBOT MURDER", function(v) AIMBOT = v end)
AddBtn("🔴 ESP MURDER", function(v) ESP_M = v end)
AddBtn("🔵 ESP XERIFE", function(v) ESP_S = v end)
AddBtn("🟢 ESP INOCENTE", function(v) ESP_P = v end)

-- // RODAPÉ
local Rodape = Instance.new("TextLabel")
Rodape.Parent = Menu
Rodape.BackgroundTransparency = 1
Rodape.Size = UDim2.new(1, 0, 0, 30)
Rodape.Position = UDim2.new(0, 0, 1, -30)
Rodape.Font = Enum.Font.GothamBold
Rodape.Text = "MG HUB | OTIMIZADO"
Rodape.TextColor3 = Color3.fromRGB(255,0,0)
Rodape.TextSize = 13
Rodape.AutoLocalize = false

-- // LOOP PRINCIPAL (OTIMIZADO)
RunService.Heartbeat:Connect(function()
    if not JogoAtivo then return end

    -- ==============================================
    -- // ESP SYSTEM
    -- ==============================================
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local cargo = GetRole(plr)

            if cargo == "Murder" and ESP_M then
                CriarESP(plr, Color3.fromRGB(255, 0, 0))
            elseif cargo == "Sheriff" and ESP_S then
                CriarESP(plr, Color3.fromRGB(0, 120, 255))
            elseif cargo == "Inocente" and ESP_P then
                CriarESP(plr, Color3.fromRGB(0, 255, 0))
            else
                RemoverESP(plr)
            end
        end
    end

    -- ==============================================
    -- // AIMBOT SYSTEM
    -- ==============================================
    if AIMBOT and Character and Character:FindFirstChild("Head") and Character:FindFirstChild("HumanoidRootPart") then
        local alvo = nil
        local distancia = math.huge

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local cargo = GetRole(plr)
                local tool = plr.Character:FindFirstChildOfClass("Tool")

                if cargo == "Murder" and tool and tool.Parent == plr.Character then
                    local dist = (Character.Head.Position - plr.Character.Head.Position).Magnitude
                    if dist < distancia then
                        distancia = dist
                        alvo = plr
                    end
                end
            end
        end

        if alvo and alvo.Character and alvo.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, alvo.Character.Head.Position),
                0.15
            )
        end
    end

end)

print("✅ MG HUB CARREGADO - VERSÃO SEM ERROS")
