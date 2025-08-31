-- Nizu Hub v1.2

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis
local noclipEnabled = false
local platformEnabled = false
local speedEnabled = false
local infJumpEnabled = false
local flyingPlatform
local guiVisible = true

-- Criar GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NizuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 260)
Frame.Position = UDim2.new(0.5, -100, 0.5, -130) -- Centralizado
Frame.BackgroundColor3 = Color3.fromRGB(25, 50, 100)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = Frame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Text = "🌌 Nizu Hub v1.2"
Title.Parent = Frame

-- Função para criar botões
local function criarBotao(texto, ordem)
    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(1, -20, 0, 40)
    botao.Position = UDim2.new(0, 10, 0, (ordem - 1) * 50 + 40)
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
local speedBtn = criarBotao("Speed (OFF)", 3)
local infJumpBtn = criarBotao("Inf Jump (OFF)", 4)

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

-- Speed
speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "Speed (ON)" or "Speed (OFF)"
    humanoid.WalkSpeed = speedEnabled and 80 or 16
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = infJumpEnabled and "Inf Jump (ON)" or "Inf Jump (OFF)"
end)

-- Botão para esconder/mostrar a GUI
local ToggleGuiBtn = Instance.new("TextButton")
ToggleGuiBtn.Size = UDim2.new(0, 60, 0, 25)
ToggleGuiBtn.Position = UDim2.new(0.9, 0, 0.05, 0)
ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
ToggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGuiBtn.Font = Enum.Font.GothamBold
ToggleGuiBtn.TextSize = 12
ToggleGuiBtn.Text = "Nizu"
ToggleGuiBtn.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = ToggleGuiBtn

ToggleGuiBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    Frame.Visible = guiVisible
end)

-- Mensagem de confirmação
local successMsg = Instance.new("TextLabel")
successMsg.Size = UDim2.new(1, 0, 0, 20)
successMsg.Position = UDim2.new(0, 0, 1, -20)
successMsg.BackgroundTransparency = 1
successMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
successMsg.Font = Enum.Font.Gotham
successMsg.TextSize = 12
successMsg.Text = "✅ Nizu Hub carregado com sucesso!"
successMsg.Parent = Frame
