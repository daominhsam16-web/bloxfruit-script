-- Blox Fruit Hack Script - Phiên bản nâng cấp
-- Tác giả: palofsc
-- Mục đích: Menu GUI với icon tròn, auto farm, tối ưu đồ họa, chống dịch chuyển
-- Lưu ý: Sử dụng cho mục đích học tập, tự chịu rủi ro

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
    TeleportToIsland = false,
    SelectedIsland = "Start Island",
}

-- ==================== STATE ====================
local OriginalCFrame = nil
local LastPosition = nil
local AntiTeleportConnection = nil
local FarmConnection = nil
local AuraConnection = nil
local SpeedConnection = nil
local EnergyConnection = nil
local HakiConnection = nil

-- ==================== ANTI TELEPORT ====================
local function enableAntiTeleport()
    if AntiTeleportConnection then AntiTeleportConnection:Disconnect() end
    AntiTeleportConnection = RunService.Heartbeat:Connect(function()
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
end

-- ==================== AUTO FARM ====================
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
    if tool then
        tool:Activate()
    end
end

local function startAutoFarm()
    if FarmConnection then FarmConnection:Disconnect() end
    FarmConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoFarm then return end
        local enemies = getEnemies()
        for _, enemy in pairs(enemies) do
            attackEnemy(enemy)
        end
    end)
end

-- ==================== KILL AURA ====================
local function startKillAura()
    if AuraConnection then AuraConnection:Disconnect() end
    AuraConnection = RunService.Heartbeat:Connect(function()
        if not Config.KillAura then return end
        local enemies = getEnemies()
        for _, enemy in pairs(enemies) do
            attackEnemy(enemy)
        end
    end)
end

-- ==================== SPEED HACK ====================
local function startSpeedHack()
    if SpeedConnection then SpeedConnection:Disconnect() end
    SpeedConnection = RunService.Heartbeat:Connect(function()
        if not Config.SpeedHack then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.SpeedValue
            humanoid.JumpPower = Config.JumpPower
            humanoid.UseJumpPower = true
        end
    end)
end

-- ==================== INFINITE ENERGY ====================
local function startInfiniteEnergy()
    if EnergyConnection then EnergyConnection:Disconnect() end
    EnergyConnection = RunService.Heartbeat:Connect(function()
        if not Config.InfiniteEnergy then return end
        local energy = LocalPlayer:FindFirstChild("Energy")
        if energy then energy.Value = 100 end
        local char = LocalPlayer.Character
        if char then
            local energy2 = char:FindFirstChild("Energy")
            if energy2 then energy2.Value = 100 end
        end
    end)
end

-- ==================== AUTO HAKI ====================
local function startAutoHaki()
    if HakiConnection then HakiConnection:Disconnect() end
    HakiConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoHaki then return end
        local char = LocalPlayer.Character
        if not char then return end
        if not char:FindFirstChild("Haki") then
            local haki = LocalPlayer.Backpack:FindFirstChild("Haki")
            if haki then haki.Parent = char end
        end
    end)
end

-- ==================== OPTIMIZE GRAPHICS ====================
local function optimizeGraphics()
    if Config.OptimizeGraphics then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("Explosion") then
                v.BlastPressure = 0
            end
        end
        settings().Rendering.QualityLevel = 1
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Brightness = 2
        settings().Rendering.QualityLevel = 10
    end
end

-- ==================== TELEPORT TO ISLAND ====================
local function teleportToIsland(islandName)
    local islands = Workspace:FindFirstChild("Islands") or Workspace:FindFirstChild("Map")
    if islands then
        local island = islands:FindFirstChild(islandName)
        if island then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(island.Position + Vector3.new(0, 10, 0))
            end
        end
    end
end

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeepSeekMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Icon tròn
local IconButton = Instance.new("TextButton")
IconButton.Name = "IconButton"
IconButton.Size = UDim2.new(0, 60, 0, 60)
IconButton.Position = UDim2.new(0, 20, 0.5, -30)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
IconButton.BorderSizePixel = 0
IconButton.Text = "DS"
IconButton.TextColor3 = Color3.fromRGB(0, 200, 255)
IconButton.TextSize = 24
IconButton.Font = Enum.Font.GothamBold
IconButton.AutoButtonColor = false
IconButton.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 200, 255)
IconStroke.Thickness = 2
IconStroke.Parent = IconButton

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 200, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "DEEPSEEK BLOX FRUIT"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
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

-- Scrolling Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

-- Hàm tạo toggle button
local function createToggle(name, configKey, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 24)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame

    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 6)
    ToggleBtnCorner.Parent = ToggleButton

    ToggleButton.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            ToggleButton.Text = "ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleButton.Text = "OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            ToggleButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        if callback then callback(Config[configKey]) end
    end)
end

-- Hàm tạo slider
local function createSlider(name, configKey, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollFrame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name .. ": " .. default
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 8)
    SliderBar.Position = UDim2.new(0, 10, 0, 35)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame

    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.BorderSizePixel = 0
    SliderButton.Parent = SliderBar

    local SliderBtnCorner = Instance.new("UICorner")
    SliderBtnCorner.CornerRadius = UDim.new(1, 0)
    SliderBtnCorner.Parent = SliderButton

    local dragging = false

    local function updateSlider(input)
        local barPos = SliderBar.AbsolutePosition.X
        local barWidth = SliderBar.AbsoluteSize.X
        local relative = math.clamp((input.Position.X - barPos) / barWidth, 0, 1)
        local value = math.floor(min + (max - min) * relative)
        SliderFill.Size = UDim2.new(relative, 0, 1, 0)
        SliderButton.Position = UDim2.new(relative, -8, 0.5, -8)
        SliderLabel.Text = name .. ": " .. value
        Config[configKey] = value
        if callback then callback(value) end
    end

    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    SliderButton.InputEnded:Connect(function(input)
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

-- Thêm các toggle vào menu
createToggle("Auto Farm", "AutoFarm", function(v)
    if v then startAutoFarm() end
end)

createToggle("Auto Quest", "AutoQuest", function(v)
    -- Placeholder cho auto quest
end)

createToggle("Kill Aura", "KillAura", function(v)
    if v then startKillAura() end
end)

createToggle("Speed Hack", "SpeedHack", function(v)
    if v then startSpeedHack() end
end)

createSlider("Speed Value", "SpeedValue", 16, 500, 100, function(v)
    -- Cập nhật tốc độ
end)

createSlider("Jump Power", "JumpPower", 50, 500, 200, function(v)
    -- Cập nhật lực nhảy
end)

createToggle("Infinite Energy", "InfiniteEnergy", function(v)
    if v then startInfiniteEnergy() end
end)

createToggle("Auto Haki", "AutoHaki", function(v)
    if v then startAutoHaki() end
end)

createToggle("Anti Teleport", "AntiTeleport", function(v)
    if v then enableAntiTeleport() end
end)

createToggle("Optimize Graphics", "OptimizeGraphics", function(v)
    optimizeGraphics()
end)

-- Thêm nút teleport island
local TeleportFrame = Instance.new("Frame")
TeleportFrame.Size = UDim2.new(1, 0, 0, 80)
TeleportFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TeleportFrame.BorderSizePixel = 0
TeleportFrame.Parent = ScrollFrame

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0, 8)
TeleportCorner.Parent = TeleportFrame

local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Size = UDim2.new(1, -20, 0, 20)
TeleportLabel.Position = UDim2.new(0, 10, 0, 5)
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Text = "Teleport To Island"
TeleportLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TeleportLabel.TextSize = 14
TeleportLabel.Font = Enum.Font.Gotham
TeleportLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportLabel.Parent = TeleportFrame

local IslandInput = Instance.new("TextBox")
IslandInput.Size = UDim2.new(0.6, 0, 0, 30)
IslandInput.Position = UDim2.new(0, 10, 0, 35)
IslandInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
IslandInput.Text = "Start Island"
IslandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandInput.TextSize = 12
IslandInput.Font = Enum.Font.Gotham
IslandInput.BorderSizePixel = 0
IslandInput.Parent = TeleportFrame

local IslandInputCorner = Instance.new("UICorner")
IslandInputCorner.CornerRadius = UDim.new(0, 6)
IslandInputCorner.Parent = IslandInput

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0.3, 0, 0, 30)
TeleportButton.Position = UDim2.new(0.65, 0, 0, 35)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
TeleportButton.Text = "GO"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 14
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.BorderSizePixel = 0
TeleportButton.Parent = TeleportFrame

local TeleportBtnCorner = Instance.new("UICorner")
TeleportBtnCorner.CornerRadius = UDim.new(0, 6)
TeleportBtnCorner.Parent = TeleportButton

TeleportButton.MouseButton1Click:Connect(function()
    teleportToIsland(IslandInput.Text)
end)

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

-- ==================== INIT ====================
enableAntiTeleport()
startAutoFarm()
startKillAura()
startSpeedHack()
startInfiniteEnergy()
startAutoHaki()

StarterGui:SetCore("SendNotification", {
    Title = "DeepSeek Menu";
    Text = "Script đã tải thành công! Nhấn icon DS để mở menu.";
    Duration = 5;
})
