--[[
    HUYMODS ULTIMATE FPS HUB - VERSION 9.0 (RIVALS & SOLARA OPTIMIZED)
    - New: Target Part Selection (Head, Torso, Nearest Part)
    - New: Advanced ESP (Health Bar, Names, Boxes)
    - Fix: Rayfield Dropdown Callback & Solara Stability
    - Credits: HuyMods
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- --- KHỞI TẠO UI (RAYFIELD) ---
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "HuyMods Premium | v9.0 Rivals Edition",
    LoadingTitle = "HUYMODS SYSTEM STARTING...",
    LoadingSubtitle = "Optimized for Rivals & Solara",
    ConfigurationSaving = { Enabled = false }
})

-- --- CÀI ĐẶT HỆ THỐNG ---
local Settings = {
    -- Combat
    AimbotEnabled = false,
    InputMode = "M2",
    TargetPart = "Head", -- "Head", "Torso", "Nearest Part"
    Smoothness = 0.2,
    FOV = 150,
    ShowFOV = true,
    WallCheck = true,
    TeamCheck = true,

    -- Visuals
    ESPEnabled = false,
    ESPBoxes = false,
    ESPNames = false,
    ESPHealth = false,
    ESPColor = Color3.fromRGB(0, 255, 255),
}

-- --- BIẾN HỆ THỐNG ---
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESP_Cache = {}

-- Vẽ vòng FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- --- HÀM TIỆN ÍCH ---

-- Kiểm tra vật cản (Wall Check)
local function IsVisible(targetPart)
    if not Settings.WallCheck then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, params)
    return result == nil or result.Instance:IsDescendantOf(targetPart.Parent)
end

-- Tìm bộ phận gần tâm chuột nhất trên một đối thủ
local function GetNearestPart(character)
    local nearest = nil
    local minDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    -- Danh sách các bộ phận Rivals thường có
    local bodyParts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
    
    for _, name in pairs(bodyParts) do
        local part = character:FindFirstChild(name)
        if part then
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    nearest = part
                end
            end
        end
    end
    return nearest
end

-- Khởi tạo ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    local function Setup()
        if ESP_Cache[player] then return end
        ESP_Cache[player] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            HealthOutline = Drawing.new("Line"),
            HealthBar = Drawing.new("Line"),
            Tracer = Drawing.new("Line")
        }
        local d = ESP_Cache[player]
        d.Box.Thickness = 1.5
        d.Name.Size = 14; d.Name.Center = true; d.Name.Outline = true
        d.HealthBar.Thickness = 2
    end
    player.CharacterAdded:Connect(Setup)
    if player.Character then Setup() end
end

-- --- GIAO DIỆN UI ---
local AimTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483345998)

-- TAB COMBAT
AimTab:CreateToggle({Name = "Kích hoạt Aimbot", CurrentValue = false, Callback = function(v) Settings.AimbotEnabled = v end})

AimTab:CreateDropdown({
    Name = "Vùng ngắm (Target Part)",
    Options = {"Head", "Torso", "Nearest Part"},
    CurrentOption = "Head",
    Callback = function(v) 
        Settings.TargetPart = type(v) == "table" and v[1] or v 
    end
})

AimTab:CreateSlider({
    Name = "Độ mượt (Smoothness)", 
    Range = {0.05, 1}, 
    Increment = 0.05, 
    CurrentValue = 0.2, 
    Callback = function(v) Settings.Smoothness = v end
})

AimTab:CreateToggle({Name = "Hiện FOV", CurrentValue = true, Callback = function(v) Settings.ShowFOV = v end})
AimTab:CreateSlider({Name = "Bán kính FOV", Range = {30, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) Settings.FOV = v end})
AimTab:CreateToggle({Name = "Kiểm tra tường", CurrentValue = true, Callback = function(v) Settings.WallCheck = v end})
AimTab:CreateToggle({Name = "Kiểm tra Team", CurrentValue = true, Callback = function(v) Settings.TeamCheck = v end})

-- TAB VISUALS
VisualTab:CreateToggle({Name = "Kích hoạt ESP", CurrentValue = false, Callback = function(v) Settings.ESPEnabled = v end})
VisualTab:CreateToggle({Name = "Hiện Box", CurrentValue = false, Callback = function(v) Settings.ESPBoxes = v end})
VisualTab:CreateToggle({Name = "Hiện Tên", CurrentValue = false, Callback = function(v) Settings.ESPNames = v end})
VisualTab:CreateToggle({Name = "Hiện Máu", CurrentValue = false, Callback = function(v) Settings.ESPHealth = v end})
VisualTab:CreateColorPicker({Name = "Màu ESP", Color = Settings.ESPColor, Callback = function(v) Settings.ESPColor = v end})

-- --- VÒNG LẶP CHÍNH ---
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    
    FOVCircle.Visible = Settings.AimbotEnabled and Settings.ShowFOV
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Position = mousePos

    local closestPart = nil
    local shortestDist = Settings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        local d = ESP_Cache[player]
        if player ~= LocalPlayer and d then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            local isTeam = Settings.TeamCheck and player.Team == LocalPlayer.Team

            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                -- Xử lý hiển thị ESP
                if Settings.ESPEnabled and onScreen and not isTeam then
                    local sizeX, sizeY = 2000/pos.Z, 3000/pos.Z
                    local boxPos = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2)

                    if Settings.ESPBoxes then
                        d.Box.Visible = true; d.Box.Size = Vector2.new(sizeX, sizeY); d.Box.Position = boxPos; d.Box.Color = Settings.ESPColor
                    else d.Box.Visible = false end

                    if Settings.ESPNames then
                        d.Name.Visible = true; d.Name.Text = player.Name; d.Name.Position = Vector2.new(pos.X, boxPos.Y - 15); d.Name.Color = Color3.fromRGB(255,255,255)
                    else d.Name.Visible = false end

                    if Settings.ESPHealth then
                        d.HealthBar.Visible = true
                        d.HealthBar.From = Vector2.new(boxPos.X - 5, boxPos.Y + sizeY)
                        d.HealthBar.To = Vector2.new(boxPos.X - 5, boxPos.Y + sizeY - (sizeY * (hum.Health/hum.MaxHealth)))
                        d.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                    else d.HealthBar.Visible = false end
                else
                    d.Box.Visible = false; d.Name.Visible = false; d.HealthBar.Visible = false
                end

                -- Xử lý quét mục tiêu Aimbot
                if onScreen and not isTeam then
                    local target
                    if Settings.TargetPart == "Head" then
                        target = char:FindFirstChild("Head")
                    elseif Settings.TargetPart == "Torso" then
                        target = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
                    else
                        target = GetNearestPart(char)
                    end

                    if target and IsVisible(target) then
                        local tPos = Camera:WorldToViewportPoint(target.Position)
                        local dist = (Vector2.new(tPos.X, tPos.Y) - mousePos).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestPart = target
                        end
                    end
                end
            else
                d.Box.Visible = false; d.Name.Visible = false; d.HealthBar.Visible = false
            end
        end
    end

    -- Thực thi nhắm (Aimbot)
    if closestPart and Settings.AimbotEnabled then
        local isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if isAiming then
            local targetCF = CFrame.new(Camera.CFrame.Position, closestPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Smoothness)
        end
    end
end)

-- Khởi chạy hệ thống
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

Rayfield:Notify({
    Title = "HuyMods v9.0 Loaded",
    Content = "Target Part & Nearest Part logic active!",
    Duration = 5
})
