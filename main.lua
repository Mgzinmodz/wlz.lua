-- // PROTEÇÃO
if getgenv().MG_HUB_LOADED then return end
getgenv().MG_HUB_LOADED = true

-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse() -- Para o Shoot

local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local Character = GetCharacter()
Player.CharacterAdded:Connect(function(c)
    Character = c
end)

-- // VERIFICA SE O JOGO COMEÇOU
local JogoAtivo = false
coroutine.wrap(function()
    while task.wait(0.3) do
        JogoAtivo = false
        if workspace:FindFirstChild("Running") and workspace.Running.Value then
            JogoAtivo = true
        elseif workspace:FindFirstChild("RoundInProgress") and workspace.RoundInProgress.Value then
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

Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke", Btn)
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Thickness = 2

-- // MENU
local Menu = Instance.new("Frame")
Menu.Parent = Gui
Menu.Size = UDim2.new(0,260,0,370) -- Aumentei um pouco para caber o botão novo
Menu.Position = UDim2.new(0,100,0.5,-180)
Menu.BackgroundColor3 = Color3.fromRGB(20,20,20)
Menu.Visible = false

Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,10)

local strokeMenu = Instance.new("UIStroke", Menu)
strokeMenu.Color = Color3.fromRGB(255,0,0)
strokeMenu.Thickness = 1.5

-- // DRAG
local function Dragify(obj)
    local dragging = false
    local startPos, startInput

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = obj.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            obj.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
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

-- // CONFIGS
local AIMBOT = false
local ESP_M = false
local ESP_S = false
local ESP_P = false
local SHOOT_MURDER = false -- NOVA FUNÇÃO

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

    Y += 45
end

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

-- // FUNÇÃO PARA ACHAR O MURDER MAIS PERTO
local function GetMurderAlvo()
    local alvo = nil
    local distancia = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
            local cargo = GetRole(plr)
            local tool = plr.Character:FindFirstChildOfClass("Tool")

            if cargo == "Murder" and tool and tool.Parent == plr.Character then
                local dist = (Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < distancia then
                    distancia = dist
                    alvo = plr
                end
            end
        end
    end

    return alvo
end

-- // ESP (OTIMIZADO)
local function CriarESP(plr, cor)
    if plr == Player or not plr.Character then return end

    local hl = plr.Character:FindFirstChild("MG_ESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "MG_ESP"
        hl.Parent = plr.Character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = plr.Character
        hl.FillTransparency = 0.8
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
        bg.StudsOffset = Vector3.new(0, 2.8, 0)
        bg.AlwaysOnTop = true

        local img = Instance.new("ImageLabel")
        img.Name = "ImageLabel"
        img.Parent = bg
        img.Size = UDim2.new(1,0,1,0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://6011141178"
        img.ImageColor3 = cor
    else
        bg.ImageLabel.ImageColor3 = cor
        bg.Enabled = true
    end
end

-- // REMOVER ESP
local function RemoverESP(plr)
    if plr.Character then
        local esp = plr.Character:FindFirstChild("MG_ESP")
        if esp then esp.Enabled = false end

        local ic = plr.Character:FindFirstChild("MG_ICON")
        if ic then ic.Enabled = false end
    end
end

-- // SISTEMA DE SHOOT AUTOMÁTICO
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if SHOOT_MURDER and JogoAtivo then
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local murder = GetMurderAlvo()
            if murder and murder.Character and murder.Character:FindFirstChild("Head") then
                -- Muda o mouse para a cabeça do murder e clica
                Mouse.Target = murder.Character.Head
                fireclickdetector(Mouse.TargetClicked)
            end
        end
    end
end)

-- // BOTÕES FINAIS
AddBtn("🎯 AIMBOT", function(v) AIMBOT = v end)
AddBtn("🔫 SHOOT MURDER", function(v) SHOOT_MURDER = v end) -- NOVO BOTÃO
AddBtn("🔴 MURDER", function(v) ESP_M = v end)
AddBtn("🔵 SHERIFF", function(v) ESP_S = v end)
AddBtn("🟢 INOCENTE", function(v) ESP_P = v end)

-- // LOOP
RunService.Heartbeat:Connect(function()
    if not JogoAtivo then return end

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

print("✅ MG HUB - VERSÃO FINAL COM SHOOT")
