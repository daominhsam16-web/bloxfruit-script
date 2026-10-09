-- Script hack Blox Fruit
-- Tác giả: palofsc
-- Mục đích: Tự động hóa và hỗ trợ người chơi
-- Cảnh báo: Sử dụng có thể vi phạm điều khoản dịch vụ

-- Kết nối với môi trường Roblox
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cấu hình
local config = {
    autoFarm = true,
    autoQuest = true,
    killAura = false,
    speedHack = true,
    speedValue = 100,
    jumpPower = 200,
    infiniteEnergy = true,
    teleportToIsland = true,
    autoHaki = true,
    autoDevilFruit = false,
}

-- Hàm teleport đến vị trí
local function teleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Hàm lấy tất cả kẻ địch
local function getEnemies()
    local enemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(enemies, player)
            end
        end
    end
    return enemies
end

-- Hàm tấn công kẻ địch
local function attackEnemy(enemy)
    if enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
        teleportTo(enemy.Character.HumanoidRootPart.Position)
        local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            tool.Parent = LocalPlayer.Character
            tool:Activate()
        end
    end
end

-- Auto Farm
local function autoFarm()
    while config.autoFarm do
        RunService.Heartbeat:Wait()
        local enemies = getEnemies()
        for _, enemy in pairs(enemies) do
            attackEnemy(enemy)
        end
        wait(0.1)
    end
end

-- Speed Hack
local function speedHack()
    RunService.Heartbeat:Connect(function()
        if config.speedHack and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = config.speedValue
            end
        end
    end)
end

-- Jump Power
local function jumpPower()
    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = config.jumpPower
                humanoid.UseJumpPower = true
            end
        end
    end)
end

-- Infinite Energy
local function infiniteEnergy()
    RunService.Heartbeat:Connect(function()
        if config.infiniteEnergy then
            local energy = LocalPlayer:FindFirstChild("Energy")
            if energy then
                energy.Value = 100
            end
        end
    end)
end

-- Auto Haki
local function autoHaki()
    while config.autoHaki do
        RunService.Heartbeat:Wait()
        local haki = LocalPlayer.Backpack:FindFirstChild("Haki")
        if haki and not LocalPlayer.Character:FindFirstChild("Haki") then
            haki.Parent = LocalPlayer.Character
        end
    end
end

-- Teleport to Island
local function teleportToIsland(islandName)
    local islands = Workspace:FindFirstChild("Islands")
    if islands then
        local island = islands:FindFirstChild(islandName)
        if island then
            teleportTo(island.Position)
        end
    end
end

-- Kill Aura
local function killAura()
    RunService.Heartbeat:Connect(function()
        if config.killAura then
            local enemies = getEnemies()
            for _, enemy in pairs(enemies) do
                attackEnemy(enemy)
            end
        end
    end)
end

-- Khởi tạo các chức năng
if config.autoFarm then
    spawn(autoFarm)
end

if config.speedHack then
    speedHack()
end

if config.jumpPower then
    jumpPower()
end

if config.infiniteEnergy then
    infiniteEnergy()
end

if config.autoHaki then
    spawn(autoHaki)
end

if config.killAura then
    killAura()
end

-- Thông báo
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blox Fruit Hack";
    Text = "Script đã được tải thành công!";
    Duration = 5;
})
