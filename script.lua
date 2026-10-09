-- Blox Fruit Hack Script - DeepSeek Menu v2
-- Tác giả: palofsc
-- Mục đích: Menu tròn có icon DeepSeek, kéo thả được, mặc định ở giữa màn hình

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIG ====================
local Config = {
    AutoFarm = false,
    AutoQuest = false,
    KillAura = false,
    SpeedHack = false,
    SpeedValue = 100,
    JumpPower = 200,
    InfiniteEnergy = false,
    AutoHaki = false,
    AntiTeleport = true,
    OptimizeGraphics = false,
}

-- ==================== ANTI TELEPORT ====================
local LastPosition = nil
RunService.Heartbeat:Connect(function()
    if not Config.AntiTeleport then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if LastPosition then
        local distance = (hrp.Position - LastPosition).Magnitude
        if distance > 50 then
            hrp.CFrame = CFrame.new(LastPosition)
        end
    end
    LastPosition = hrp.Position
end)

-- ==================== HELPERS ====================
local function getEnemies()
    local enemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp and humanoid.Health > 0 then
                table.insert(enemies, player)
            end
        end
    end
    return enemies
end

local function attackEnemy(enemy)
    if not enemy.Character then return end
    local hrp = enemy.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    myHrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 3, 0))
    local tool = myChar:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
end

-- ==================== FEATURES ====================
RunService.Heartbeat:Connect(function()
    if Config.AutoFarm or Config.KillAura then
        local enemies = getEnemies()
        for _, enemy in pairs(enemies) do
            attackEnemy(enemy)
        end
    end
    if Config.SpeedHack then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Config.SpeedValue
                humanoid.JumpPower = Config.JumpPower
                humanoid.UseJumpPower = true
            end
        end
    end
    if Config.InfiniteEnergy then
        local energy = LocalPlayer:FindFirstChild("Energy")
        if energy then energy.Value = 100 end
    end
    if Config.AutoHaki then
        local char = LocalPlayer.Character
        if char and not char:FindFirstChild("Haki") then
            local haki = LocalPlayer.Backpack:FindFirstChild("Haki")
            if haki then haki.Parent = char end
        end
    end
end)

local function optimizeGraphics()
    if Config.OptimizeGraphics then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        settings().Rendering.QualityLevel = 1
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Brightness = 2
        settings().Rendering.QualityLevel = 10
    end
end

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeepSeekMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ICON TRÒN Ở GIỮA MÀN HÌNH
local IconButton = Instance.new("TextButton")
IconButton.Name = "IconButton"
IconButton.Size = UDim2.new(0, 70, 0, 70)
IconButton.Position = UDim2.new(0.5, -35, 0.5, -35)  -- Ở GIỮA MÀN HÌNH
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
IconButton.BorderSizePixel = 0
IconButton.Text = "🐋"
IconButton.TextColor3 = Color3.fromRGB(0, 200, 255)
IconButton.TextSize = 32
IconButton.Font = Enum.Font.GothamBold
IconButton.AutoButtonColor = false
IconButton.Active = true
IconButton.Draggable = true  -- KÉO THẢ ĐƯỢC
IconButton.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 200, 255)
IconStroke.Thickness = 3
IconStroke.Parent = IconButton

local IconGradient = Instance.new("UIGradient")
IconGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 255)),
})
IconGradient.Parent = IconStroke

-- Hiệu ứng pulse
local pulseTween = TweenService:Create(IconStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Thickness = 5,
})
pulseTween:Play()

-- MAIN MENU
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 200, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 14)
TitleFix.Position = UDim2.new(0, 0, 1, -14)
TitleFix.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 45, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "DEEPSEEK BLOX FRUIT"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 35, 1, 0)
TitleIcon.Position = UDim2.new(0, 5, 0, 0)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "🐋"
TitleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleIcon.TextSize = 22
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -38, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Scrolling
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -65)
ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

-- Toggle
local function createToggle(name, configKey, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollFrame

    local TC = Instance.new("UICorner")
    TC.CornerRadius = UDim.new(0, 8)
    TC.Parent = ToggleFrame

    local TLabel = Instance.new("TextLabel")
    TLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TLabel.Position = UDim2.new(0, 12, 0, 0)
    TLabel.BackgroundTransparency = 1
    TLabel.Text = name
    TLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TLabel.TextSize = 14
    TLabel.Font = Enum.Font.Gotham
    TLabel.TextXAlignment = Enum.TextXAlignment.Left
    TLabel.Parent = ToggleFrame

    local TButton = Instance.new("TextButton")
    TButton.Size = UDim2.new(0, 55, 0, 26)
    TButton.Position = UDim2.new(1, -65, 0.5, -13)
    TButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    TButton.Text = "OFF"
    TButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TButton.TextSize = 12
    TButton.Font = Enum.Font.GothamBold
    TButton.BorderSizePixel = 0
    TButton.Parent = ToggleFrame

    local TBC = Instance.new("UICorner")
    TBC.CornerRadius = UDim.new(0, 6)
    TBC.Parent = TButton

    TButton.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            TButton.Text = "ON"
            TButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            TButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TButton.Text = "OFF"
            TButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            TButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        if callback then callback(Config[configKey]) end
    end)
end

-- Slider
local function createSlider(name, configKey, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 65)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollFrame

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(0, 8)
    SC.Parent = SliderFrame

    local SLabel = Instance.new("TextLabel")
    SLabel.Size = UDim2.new(0.7, 0, 0, 20)
    SLabel.Position = UDim2.new(0, 12, 0, 8)
    SLabel.BackgroundTransparency = 1
    SLabel.Text = name .. ": " .. default
    SLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SLabel.TextSize = 14
    SLabel.Font = Enum.Font.Gotham
    SLabel.TextXAlignment = Enum.TextXAlignment.Left
    SLabel.Parent = SliderFrame

    local SBar = Instance.new("Frame")
    SBar.Size = UDim2.new(1, -24, 0, 8)
    SBar.Position = UDim2.new(0, 12, 0, 40)
    SBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    SBar.BorderSizePixel = 0
    SBar.Parent = SliderFrame

    local SBC = Instance.new("UICorner")
    SBC.CornerRadius = UDim.new(1, 0)
    SBC.Parent = SBar

    local SFill = Instance.new("Frame")
    SFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    SFill.BorderSizePixel = 0
    SFill.Parent = SBar

    local SFC = Instance.new("UICorner")
    SFC.CornerRadius = UDim.new(1, 0)
    SFC.Parent = SFill

    local SBtn = Instance.new("TextButton")
    SBtn.Size = UDim2.new(0, 18, 0, 18)
    SBtn.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    SBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SBtn.Text = ""
    SBtn.BorderSizePixel = 0
    SBtn.Parent = SBar

    local SBC2 = Instance.new("UICorner")
    SBC2.CornerRadius = UDim.new(1, 0)
    SBC2.Parent = SBtn

    local dragging = false

    local function updateSlider(input)
        local barPos = SBar.AbsolutePosition.X
        local barWidth = SBar.AbsoluteSize.X
        local relative = math.clamp((input.Position.X - barPos) / barWidth, 0, 1)
        local value = math.floor(min + (max - min) * relative)
        SFill.Size = UDim2.new(relative, 0, 1, 0)
        SBtn.Position = UDim2.new(relative, -9, 0.5, -9)
        SLabel.Text = name .. ": " .. value
        Config[configKey] = value
        if callback then callback(value) end
    end

    SBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    SBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

-- Thêm chức năng
createToggle("Auto Farm", "AutoFarm")
createToggle("Auto Quest", "AutoQuest")
createToggle("Kill Aura", "KillAura")
createToggle("Speed Hack", "SpeedHack")
createSlider("Speed Value", "SpeedValue", 16, 500, 100)
createSlider("Jump Power", "JumpPower", 50, 500, 200)
createToggle("Infinite Energy", "InfiniteEnergy")
createToggle("Auto Haki", "AutoHaki")
createToggle("Anti Teleport", "AntiTeleport")
createToggle("Optimize Graphics", "OptimizeGraphics", function() optimizeGraphics() end)

-- ==================== DRAG MENU ====================
local draggingMain = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = false
    end
end)

-- ==================== ICON CLICK ====================
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- ==================== NOTIFY ====================
StarterGui:SetCore("SendNotification", {
    Title = "DeepSeek Menu";
    Text = "Script đã tải! Icon 🐋 ở giữa màn hình, kéo thả được.";
    Duration = 5;
})
