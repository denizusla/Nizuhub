-- Nizu Hub | Script Hub para "Roube um Brainrot"
-- Desenvolvido em Lua (Roblox)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis de controle
local noclipEnabled = false
local platformEnabled = false
local flyingPlatform

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NizuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 220)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0,0)
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.UICorner = Instance.new("UICorner", Frame)
Frame.UICorner.CornerRadius = UDim.new(0, 12)

-- Função para criar botões
local function criarBotao(texto, ordem)
    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(1, -20, 0, 40)
    botao.Position = UDim2.new(0, 10, 0, (ordem-1)*50 + 10)
    botao.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Font = Enum.Font.GothamBold
    botao.TextSize = 14
    botao.Text = texto
    botao.Parent = Frame
    local corner = Instance.new("UICorner", botao)
    corner.CornerRadius = UDim.new(0, 10)
    return botao
end

-- Botões
local noclipBtn = criarBotao("NoclipCam", 1)
local platformBtn = criarBotao("Plataforma", 2)
local soonBtn1 = criarBotao("Em breve...", 3)
local soonBtn2 = criarBotao("Em breve...", 4)

-- Função NoclipCam
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = noclipEnabled and "NoclipCam (ON)" or "NoclipCam (OFF)"
end)

-- Aplicando noclip (remove colisões do player)
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Função Plataforma
platformBtn.MouseButton1Click:Connect(function()
    platformEnabled = not platformEnabled
    platformBtn.Text = platformEnabled and "Plataforma (ON)" or "Plataforma (OFF)"

    if platformEnabled then
        -- Criar plataforma se não existir
        if not flyingPlatform then
            flyingPlatform = Instance.new("Part")
            flyingPlatform.Size = Vector3.new(6,1,6)
            flyingPlatform.Anchored = true
            flyingPlatform.Transparency = 0.3
            flyingPlatform.Color = Color3.fromRGB(80,150,255)
            flyingPlatform.CanCollide = true
            flyingPlatform.Parent = workspace
        end
    else
        if flyingPlatform then
            flyingPlatform:Destroy()
            flyingPlatform = nil
        end
    end
end)

-- Atualizar posição da plataforma
RunService.RenderStepped:Connect(function()
    if platformEnabled and flyingPlatform and humanoidRootPart then
        local pos = humanoidRootPart.Position - Vector3.new(0, 3, 0)
        flyingPlatform.Position = flyingPlatform.Position:Lerp(Vector3.new(pos.X, pos.Y, pos.Z), 0.2)
    end
end)