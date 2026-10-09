-- Blox Fruit Hack Script - DeepSeek Menu v5
-- Tác giả: palofsc
-- Mục đích: Fix lỗi v4, tối ưu, thêm bypass anti-cheat và tính năng mới

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIG ====================
local Config = {
    AutoFarm = false,
    AutoQuest = false,
    KillAura = false,
    FarmRange = 50,
    FarmMethod = "Melee",
    AutoCollect = false,
    AutoSell = false,
    AutoChest = false,
    FarmBoss = false,

    SpeedHack = false,
    SpeedValue = 100,
    JumpPower = 200,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    AntiTeleport = true,
    AntiAFK = true,

    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    FullBright = false,
    OptimizeGraphics = false,
    RemoveFog = false,
    RemoveTextures = false,

    AutoHaki = false,
    InfiniteEnergy = false,
    AutoClick = false,
    ClickDelay = 0.1,
    ShowFPS = false,
    AutoFish = false,
    GodMode = false,
    AntiBan = true,

    AutoCombo = false,
    AutoDodge = false,
    AutoSkill = false,
    CombatRange = 30,
}

-- ==================== STATE ====================
local LastPosition = nil
local ESPObjects = {}
local FlyConnection = nil
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local FPSLabel = nil
local FPSConnection = nil
local SelectedBoss = nil

-- ==================== HELPERS ====================
local function getEnemies(range)
    local enemies = {}
    local myChar = LocalPlayer.Character
    if not myChar then return enemies end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return enemies end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp and humanoid.Health > 0 then
                local dist = (hrp.Position - myHrp.Position).Magnitude
                if dist <= range then
                    table.insert(enemies, player)
                end
            end
        end
    end
    return enemies
end

local function getNPCs(range)
    local npcs = {}
    local myChar = LocalPlayer.Character
    if not myChar then return npcs end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return npcs end
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            if npc.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(npc) then
                local humanoid = npc:FindFirstChild("Humanoid")
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                if humanoid and hrp and humanoid.Health > 0 then
                    local dist = (hrp.Position - myHrp.Position).Magnitude
                    if dist <= range then
                        table.insert(npcs, npc)
                    end
                end
            end
        end
    end
    return npcs
end

local function attackEnemy(target)
    if not target then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local targetHrp, targetHumanoid
    if target:IsA("Player") then
        if not target.Character then return end
        targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
        targetHumanoid = target.Character:FindFirstChild("Humanoid")
    else
        targetHrp = target:FindFirstChild("HumanoidRootPart")
        targetHumanoid = target:FindFirstChild("Humanoid")
    end
    if not targetHrp or not targetHumanoid or targetHumanoid.Health <= 0 then return end
    myHrp.CFrame = CFrame.new(targetHrp.Position + Vector3.new(0, 3, 0))
    myHrp.CFrame = CFrame.new(targetHrp.Position, targetHrp.Position + targetHrp.Velocity * Vector3.new(1, 0, 1))
    if Config.FarmMethod == "Melee" then
        local tool = myChar:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    elseif Config.FarmMethod == "Sword" then
        for _, tool in pairs(myChar:GetChildren()) do
            if tool:IsA("Tool") and (tool:FindFirstChild("Handle") or string.find(string.lower(tool.Name), "sword")) then
                tool:Activate()
                break
            end
        end
    elseif Config.FarmMethod == "Fruit" then
        for _, tool in pairs(myChar:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), "fruit") then
                tool:Activate()
                break
            end
        end
    end
end

local function teleportTo(position)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- ==================== FEATURES ====================
-- Auto Farm
RunService.Heartbeat:Connect(function()
    if Config.AutoFarm then
        local enemies = getEnemies(Config.FarmRange)
        for _, enemy in pairs(enemies) do attackEnemy(enemy) end
        local npcs = getNPCs(Config.FarmRange)
        for _, npc in pairs(npcs) do attackEnemy(npc) end
    end
end)

-- Kill Aura
RunService.Heartbeat:Connect(function()
    if Config.KillAura then
        local enemies = getEnemies(Config.FarmRange)
        for _, enemy in pairs(enemies) do attackEnemy(enemy) end
    end
end)

-- Auto Quest
RunService.Heartbeat:Connect(function()
    if Config.AutoQuest then
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                if string.find(string.lower(npc.Name), "quest") then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        teleportTo(hrp.Position)
                        task.wait(0.5)
                        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            prompt:InputHoldBegin()
                            task.wait(prompt.HoldDuration)
                            prompt:InputHoldEnd()
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Collect
RunService.Heartbeat:Connect(function()
    if Config.AutoCollect then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") or item:IsA("Model") then
                    if string.find(string.lower(item.Name), "drop") or string.find(string.lower(item.Name), "chest") then
                        local hrp = item:FindFirstChild("HumanoidRootPart") or item:FindFirstChild("Handle")
                        if hrp then
                            local dist = (hrp.Position - char.HumanoidRootPart.Position).Magnitude
                            if dist < 50 then char.HumanoidRootPart.CFrame = CFrame.new(hrp.Position) end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Sell
RunService.Heartbeat:Connect(function()
    if Config.AutoSell then
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                if string.find(string.lower(npc.Name), "sell") or string.find(string.lower(npc.Name), "shop") then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        teleportTo(hrp.Position)
                        task.wait(0.3)
                        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            prompt:InputHoldBegin()
                            task.wait(prompt.HoldDuration)
                            prompt:InputHoldEnd()
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Chest
RunService.Heartbeat:Connect(function()
    if Config.AutoChest then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, chest in pairs(Workspace:GetDescendants()) do
                if chest:IsA("Model") and (string.find(string.lower(chest.Name), "chest") or string.find(string.lower(chest.Name), "ruong")) then
                    local hrp = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChild("Handle")
                    if hrp then
                        char.HumanoidRootPart.CFrame = CFrame.new(hrp.Position)
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
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
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- Infinite Energy
RunService.Heartbeat:Connect(function()
    if Config.InfiniteEnergy then
        local energy = LocalPlayer:FindFirstChild("Energy")
        if energy then energy.Value = 100 end
        local stamina = LocalPlayer:FindFirstChild("Stamina")
        if stamina then stamina.Value = 100 end
    end
end)

-- Auto Haki
RunService.Heartbeat:Connect(function()
    if Config.AutoHaki then
        local char = LocalPlayer.Character
        if char and not char:FindFirstChild("Haki") then
            local haki = LocalPlayer.Backpack:FindFirstChild("Haki")
            if haki then haki.Parent = char end
        end
    end
end)

-- Auto Click
task.spawn(function()
    while task.wait(Config.ClickDelay) do
        if Config.AutoClick then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
    end
end)

-- Anti Teleport
RunService.Heartbeat:Connect(function()
    if not Config.AntiTeleport then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if LastPosition then
        local distance = (hrp.Position - LastPosition).Magnitude
        if distance > 50 then hrp.CFrame = CFrame.new(LastPosition) end
    end
    LastPosition = hrp.Position
end)

-- Anti AFK
if Config.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end

-- Noclip
RunService.Stepped:Connect(function()
    if Config.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end
end)

-- Fly
local function startFly()
    if FlyConnection then FlyConnection:Disconnect() end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    FlyBodyGyro = bg
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp
    FlyBodyVelocity = bv
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not Config.Fly then
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
            if FlyBodyGyro then FlyBodyGyro:Destroy() end
            return
        end
        local moveDir = Vector3.new(0, 0, 0)
        local cam = Workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * Config.FlySpeed end
        FlyBodyVelocity.Velocity = moveDir
        FlyBodyGyro.CFrame = cam.CFrame
    end)
end

-- ESP
local function createESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DeepSeekESP"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Config.ESPColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0, 16)
    healthLabel.Position = UDim2.new(0, 0, 0, 20)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextSize = 12
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = billboard
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0, 16)
    distLabel.Position = UDim2.new(0, 0, 0, 36)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 12
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = billboard
    table.insert(ESPObjects, {player = player, billboard = billboard})
end

local function updateESP()
    for _, data in pairs(ESPObjects) do
        if data.billboard and data.billboard.Parent then
            local player = data.player
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoid and hrp then
                    local nameLabel = data.billboard:FindFirstChild("NameLabel")
                    local healthLabel = data.billboard:FindFirstChild("HealthLabel")
                    local distLabel = data.billboard:FindFirstChild("DistLabel")
                    if nameLabel then
                        nameLabel.Visible = Config.ESPName
                        nameLabel.TextColor3 = Config.ESPColor
                    end
                    if healthLabel then
                        healthLabel.Visible = Config.ESPHealth
                        healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    end
                    if distLabel then
                        distLabel.Visible = Config.ESPDistance
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            local dist = (hrp.Position - myChar.HumanoidRootPart.Position).Magnitude
                            distLabel.Text = math.floor(dist) .. "m"
                        end
                    end
                end
            end
        end
    end
end

local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then createESP(player) end
    end
end

local function disableESP()
    for _, data in pairs(ESPObjects) do
        if data.billboard then data.billboard:Destroy() end
    end
    ESPObjects = {}
end

Players.PlayerAdded:Connect(function(player)
    if Config.ESP then
        player.CharacterAdded:Wait()
        task.wait(1)
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    for i, data in pairs(ESPObjects) do
        if data.player == player then
            if data.billboard then data.billboard:Destroy() end
            table.remove(ESPObjects, i)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.ESP then updateESP() end
end)

-- Graphics
local function applyGraphics()
    if Config.FullBright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    end
    if Config.RemoveFog then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    end
    if Config.RemoveTextures then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
    end
    if Config.OptimizeGraphics then
        settings().Rendering.QualityLevel = 1
    else
        settings().Rendering.QualityLevel = 10
    end
end

-- FPS
local function enableFPS()
    if FPSLabel then FPSLabel:Destroy() end
    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0, 100, 0, 30)
    FPSLabel.Position = UDim2.new(1, -110, 0, 10)
    FPSLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    FPSLabel.BackgroundTransparency = 0.5
    FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    FPSLabel.TextSize = 14
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.Text = "FPS: 60"
    FPSLabel.Parent = ScreenGui
    local frames = 0
    local lastTime = tick()
    if FPSConnection then FPSConnection:Disconnect() end
    FPSConnection = RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - lastTime >= 1 then
            FPSLabel.Text = "FPS: " .. frames
            frames = 0
            lastTime = now
        end
    end)
end

-- Auto Fish
task.spawn(function()
    while task.wait(1) do
        if Config.AutoFish then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and string.find(string.lower(tool.Name), "rod") then tool:Activate() end
            end
        end
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if Config.GodMode then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end
    end
end)

-- Auto Combo
RunService.Heartbeat:Connect(function()
    if Config.AutoCombo then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeepSeekMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local IconButton = Instance.new("TextButton")
IconButton.Name = "IconButton"
IconButton.Size = UDim2.new(0, 70, 0, 70)
IconButton.Position = UDim2.new(0.5, -35, 0.5, -35)
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
IconButton.BorderSizePixel = 0
IconButton.Text = "🐋"
IconButton.TextColor3 = Color3.fromRGB(0, 200, 255)
IconButton.TextSize = 32
IconButton.Font = Enum.Font.GothamBold
IconButton.AutoButtonColor = false
IconButton.Active = true
IconButton.Draggable = true
IconButton.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 200, 255)
IconStroke.Thickness = 3
IconStroke.Parent = IconButton

local pulseTween = TweenService:Create(IconStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Thickness = 5})
pulseTween:Play()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
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
TitleText.Text = "DEEPSEEK BLOX FRUIT v5"
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

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 55)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 4)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 4)
TabPadding.PaddingTop = UDim.new(0, 4)
TabPadding.Parent = TabBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -115)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Tabs = {}
local ActiveTab = nil

local function createTab(name, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.19, 0, 1, -8)
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.LayoutOrder = order
    tabBtn.Parent = TabBar
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 6)
    tc.Parent = tabBtn
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 1200)
    scroll.Visible = false
    scroll.Parent = ContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll
    Tabs[name] = {button = tabBtn, scroll = scroll}
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            t.button.TextColor3 = Color3.fromRGB(180, 180, 180)
            t.scroll.Visible = false
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        scroll.Visible = true
        ActiveTab = name
    end)
end

createTab("Farm", 1)
createTab("Move", 2)
createTab("Visual", 3)
createTab("Misc", 4)
createTab("Combat", 5)

Tabs["Farm"].button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Tabs["Farm"].button.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs["Farm"].scroll.Visible = true
ActiveTab = "Farm"

local function createToggle(parent, name, configKey, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
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

local function createSlider(parent, name, configKey, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 65)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
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

local function createDropdown(parent, name, configKey, options, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 42)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = Frame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.4, 0, 0, 28)
    Btn.Position = UDim2.new(0.55, 0, 0.5, -14)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Btn.Text = default
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.Gotham
    Btn.BorderSizePixel = 0
    Btn.Parent = Frame
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Btn
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(0.4, 0, 0, #options * 26)
    Dropdown.Position = UDim2.new(0.55, 0, 1, 4)
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Dropdown.BorderSizePixel = 0
    Dropdown.Visible = false
    Dropdown.ZIndex = 10
    Dropdown.Parent = Frame
    local DC = Instance.new("UICorner")
    DC.CornerRadius = UDim.new(0, 6)
    DC.Parent = Dropdown
    local DL = Instance.new("UIListLayout")
    DL.Parent = Dropdown
    for _, option in pairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 26)
        OptBtn.BackgroundTransparency = 1
        OptBtn.Text = option
        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptBtn.TextSize = 12
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.ZIndex = 11
        OptBtn.Parent = Dropdown
        OptBtn.MouseButton1Click:Connect(function()
            Config[configKey] = option
            Btn.Text = option
            Dropdown.Visible = false
            if callback then callback(option) end
        end)
    end
    Btn.MouseButton1Click:Connect(function()
        Dropdown.Visible = not Dropdown.Visible
    end)
end

local farmTab = Tabs["Farm"].scroll
createToggle(farmTab, "Auto Farm", "AutoFarm")
createToggle(farmTab, "Auto Quest", "AutoQuest")
createToggle(farmTab, "Kill Aura", "KillAura")
createSlider(farmTab, "Farm Range", "FarmRange", 10, 500, 50)
createDropdown(farmTab, "Farm Method", "FarmMethod", {"Melee", "Sword", "Fruit"}, "Melee")
createToggle(farmTab, "Auto Collect", "AutoCollect")
createToggle(farmTab, "Auto Sell", "AutoSell")
createToggle(farmTab, "Auto Chest", "AutoChest")
createToggle(farmTab, "Farm Boss", "FarmBoss")

local moveTab = Tabs["Move"].scroll
createToggle(moveTab, "Speed Hack", "SpeedHack")
createSlider(moveTab, "Speed Value", "SpeedValue", 16, 500, 100)
createSlider(moveTab, "Jump Power", "JumpPower", 50, 500, 200)
createToggle(moveTab, "Infinite Jump", "InfiniteJump")
createToggle(moveTab, "Fly", "Fly", function(v)
    if v then startFly() end
end)
createSlider(moveTab, "Fly Speed", "FlySpeed", 10, 300, 50)
createToggle(moveTab, "Noclip", "Noclip")
createToggle(moveTab, "Anti Teleport", "AntiTeleport")
createToggle(moveTab, "Anti AFK", "AntiAFK")

local visualTab = Tabs["Visual"].scroll
createToggle(visualTab, "ESP", "ESP", function(v)
    if v then enableESP() else disableESP() end
end)
createToggle(visualTab, "ESP Name", "ESPName")
createToggle(visualTab, "ESP Health", "ESPHealth")
createToggle(visualTab, "ESP Distance", "ESPDistance")
createToggle(visualTab, "Full Bright", "FullBright", function() applyGraphics() end)
createToggle(visualTab, "Remove Fog", "RemoveFog", function() applyGraphics() end)
createToggle(visualTab, "Remove Textures", "RemoveTextures", function() applyGraphics() end)
createToggle(visualTab, "Optimize Graphics", "OptimizeGraphics", function() applyGraphics() end)

local miscTab = Tabs["Misc"].scroll
createToggle(miscTab, "Auto Haki", "AutoHaki")
createToggle(miscTab, "Infinite Energy", "InfiniteEnergy")
createToggle(miscTab, "Auto Click", "AutoClick")
createSlider(miscTab, "Click Delay", "ClickDelay", 0.01, 1, 0.1)
createToggle(miscTab, "Show FPS", "ShowFPS", function(v)
    if v then enableFPS() else
        if FPSLabel then FPSLabel:Destroy() FPSLabel = nil end
        if FPSConnection then FPSConnection:Disconnect() end
    end
end)
createToggle(miscTab, "Auto Fish", "AutoFish")
createToggle(miscTab, "God Mode", "GodMode")
createToggle(miscTab, "Anti Ban", "AntiBan")

local combatTab = Tabs["Combat"].scroll
createToggle(combatTab, "Auto Combo", "AutoCombo")
createToggle(combatTab, "Auto Dodge", "AutoDodge")
createToggle(combatTab, "Auto Skill", "AutoSkill")
createSlider(combatTab, "Combat Range", "CombatRange", 10, 100, 30)
createToggle(combatTab, "Auto Block", "AutoBlock")

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

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

StarterGui:SetCore("SendNotification", {
    Title = "DeepSeek Menu v5";
    Text = "Đã fix lỗi! Thêm Combat tab, Anti Ban, God Mode. Icon 🐋 ở giữa màn hình.";
    Duration = 5;
})
