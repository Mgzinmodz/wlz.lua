-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = Player.Character or Player.CharacterAdded:Wait()

Player.CharacterAdded:Connect(function(c)
    Character = c
end)

-- // VERIFICA SE O JOGO COMEÇOU
local JogoComecou = false
workspace.ChildAdded:Connect(function(child)
    if child.Name == "RoundSystem" or child.Name:find("Round") then
        JogoComecou = true
    end
end)

-- // GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MG_HUB"
Gui.Parent = game:GetService("CoreGui")

-- // BOTÃO MG
local Btn = Instance.new("TextButton")
Btn.Parent = Gui
Btn.Size = UDim2.new(0,60,0,60)
Btn.Position = UDim2.new(0,20,0.5,0)
Btn.Text = "MG"
Btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
Btn.TextColor3 = Color3.fromRGB(255,0,0)
Btn.Font = Enum.Font.GothamBlack
Btn.TextSize = 24
Btn.AutoLocalize = false

Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", Btn)
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Thickness = 2

-- // MENU
local Menu = Instance.new("Frame")
Menu.Parent = Gui
Menu.Size = UDim2.new(0,260,0,330)
Menu.Position = UDim2.new(0,100,0.5,-150)
Menu.BackgroundColor3 = Color3.fromRGB(25,25,25)
Menu.Visible = false
Menu.AutoLocalize = false

Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,10)

-- // DRAG FUNCIONANDO 100%
local function Dragify(Frame)
    local dragging, dragInput, startPos, startInput

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startInput = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startInput
            Frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

Dragify(Btn)
Dragify(Menu)

-- // ABRIR MENU
Btn.Activated:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- // BOTÕES
local Y = 20
local function AddBtn(text, callback)
    local b = Instance.new("TextButton")
    b.Parent = Menu
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,Y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.AutoLocalize = false
    
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)

    local on = false
    b.Activated:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Color3.fromRGB(255,0,0) or Color3.fromRGB(40,40,40)
        b.TextColor3 = on and Color3.new(0,0,0) or Color3.new(1,1,1)
        callback(on)
    end)

    Y += 50
end

-- // ESTADOS
local AIMBOT = false
local ESP_M = false
local ESP_S = false
local ESP_P = false

-- // ROLE (DETECTA CERTINHO)
local function GetRole(plr)
    if not plr.Character then return "Player" end

    -- Verifica se tem arma na mão
    local ferramenta = plr.Character:FindFirstChildOfClass("Tool")

    if ferramenta then
        if ferramenta.Name:lower():find("knife") or ferramenta.Name:lower():find("murder") then 
            return "Murder" 
        end
        if ferramenta.Name:lower():find("gun") or ferramenta.Name:lower():find("revolver") or ferramenta.Name:lower():find("sheriff") then 
            return "Sheriff" 
        end
    end

    -- Verifica na mochila
    if plr:FindFirstChild("Backpack") then
        for _,v in pairs(plr.Backpack:GetChildren()) do
            if v.Name:lower():find("knife") or v.Name:lower():find("murder") then return "Murder" end
            if v.Name:lower():find("gun") or v.Name:lower():find("revolver") or v.Name:lower():find("sheriff") then return "Sheriff" end
        end
    end

    return "Player"
end

-- // SET ESP
local function SetESP(plr, color)
    if plr == Player or not plr.Character then return end

    local hl = plr.Character:FindFirstChild("MG_ESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "MG_ESP"
        hl.Parent = plr.Character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end

    hl.Adornee = plr.Character
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.7
    hl.OutlineTransparency = 0
    hl.Enabled = true
end

-- // BOTÕES
AddBtn("🎯 AIMBOT", function(v) AIMBOT = v end)
AddBtn("🔴 ESP MURDER", function(v) ESP_M = v end)
AddBtn("🔵 ESP SHERIFF", function(v) ESP_S = v end)
AddBtn("🟢 ESP PLAYER", function(v) ESP_P = v end)

-- // RODAPÉ
local Rodape = Instance.new("TextLabel")
Rodape.Parent = Menu
Rodape.BackgroundTransparency = 1
Rodape.Size = UDim2.new(1, 0, 0, 30)
Rodape.Position = UDim2.new(0, 0, 1, -30)
Rodape.Font = Enum.Font.GothamBold
Rodape.Text = "TikTok: @Phzonn_mg9"
Rodape.TextColor3 = Color3.fromRGB(255,0,0)
Rodape.TextSize = 14
Rodape.AutoLocalize = false

-- // LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()

    -- SÓ FUNCIONA DEPOIS QUE COMEÇAR
    if not JogoComecou then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local role = GetRole(plr)

            if role == "Murder" and ESP_M then
                SetESP(plr, Color3.fromRGB(255,0,0))
            elseif role == "Sheriff" and ESP_S then
                SetESP(plr, Color3.fromRGB(0,100,255))
            elseif role == "Player" and ESP_P then
                SetESP(plr, Color3.fromRGB(0,255,0))
            else
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("MG_ESP")
                    if hl then
                        hl.Enabled = false
                    end
                end
            end
        end
    end

    -- AIMBOT SÓ NO MURDER COM ARMA NA MÃO
    if AIMBOT 
    and Character 
    and Character:FindFirstChild("Head") 
    and Character:FindFirstChild("HumanoidRootPart") then

        local target, dist = nil, math.huge

        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= Player 
            and plr.Character 
            and plr.Character:FindFirstChild("Head") 
            and plr.Character:FindFirstChild("HumanoidRootPart") then

                -- SÓ MIRA SE ELE FOR MURDER E TIVER A ARMA NA MÃO
                local ferramenta = plr.Character:FindFirstChildOfClass("Tool")
                if GetRole(plr) == "Murder" and ferramenta and ferramenta.Parent == plr.Character then
                    local mag = (Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        target = plr
                    end
                end
            end
        end

        if target 
        and target.Character 
        and target.Character:FindFirstChild("Head") then

            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Character.Head.Position),
                0.2
            )
        end
    end

end)

print("✅ MG HUB - VERSÃO FINAL DEFINITIVA")
