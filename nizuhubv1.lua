-- Nizu Hub v1.0

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis
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
Frame.Size = UDim2.new(0, 180, 0, 240)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = Frame

-- Função para criar botões
local function criarBotao(texto, ordem)
    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(1, -20, 0, 40)
    botao.Position = UDim2.new(0, 10, 0, (ordem - 1) * 50 + 10)
    botao.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Font = Enum.Font.GothamBold
    botao.TextSize = 14
    botao.Text = texto
    botao.Parent = Frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = botao

    return botao
end

-- Criar botões
local noclipBtn = criarBotao("NoclipCam (OFF)", 1)
local platformBtn = criarBotao("Plataforma (OFF)", 2)
local soonBtn1 = criarBotao("Em breve...", 3)
local soonBtn2 = criarBotao("Em breve...", 4)

-- Noclip
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = noclipEnabled and "NoclipCam (ON)" or "NoclipCam (OFF)"
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Plataforma
platformBtn.MouseButton1Click:Connect(function()
    platformEnabled = not platformEnabled
    platformBtn.Text = platformEnabled and "Plataforma (ON)" or "Plataforma (OFF)"

    if platformEnabled then
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

RunService.RenderStepped:Connect(function()
    if platformEnabled and flyingPlatform and humanoidRootPart then
        local pos = humanoidRootPart.Position - Vector3.new(0, 3, 0)
        flyingPlatform.Position = flyingPlatform.Position:Lerp(pos, 0.2)
    end
end)

-- Mensagem de confirmação
local successMsg = Instance.new("TextLabel")
successMsg.Size = UDim2.new(1, 0, 0, 30)
successMsg.Position = UDim2.new(0, 0, 1, -30)
successMsg.BackgroundTransparency = 1
successMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
successMsg.Font = Enum.Font.Gotham
successMsg.TextSize = 12
successMsg.Text = "✅ Nizu Hub carregado com sucesso!"
successMsg.Parent = Frame