-- Load Rayfield if not loaded
if not Rayfield then
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/qtksxz/dexhub/refs/heads/main/rayfield.lua"))()
    end)
    if not success then
        warn("Failed to load Rayfield: "..err)
        return
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")

local MIN_Y_COORDINATE = -50 

local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DinoHub Arsenal 🦖",
            Text = txt,
            Duration = 3
        })
    end)
end

notify("✅ DinoHub Arsenal Loaded")

-- Variables
local Aimbot, Smooth, Wall, ESP, ESPTeam, ShowName, SafeMode, KillAll, AutoFire = false, false, false, false, false, false, false, false, false
local TargetPart, parts, partIdx = "Head", {"Head", "UpperTorso", "Torso"}, 1
local ESPMode = "Highlight"
local ESPColor = Color3.new(1,1,1)
local Rainbow = false
local KillAllIndex = 1
local safemodew = 10
local PositionMode = "Front" 
local autoFireConnection, CurrentTarget, lastTeleportTime = nil, nil, 0
local TELEPORT_DELAY = 1.5
local highlights, boxes, names = {}, {}, {}

-- Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "DinoHubKeySystem",
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    ShowText = "Rayfield",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "Big Hub"},
    Discord = {Enabled = false, Invite = "https://discord.gg/jb9WctzJd5", RememberJoins = true},
    KeySystem = true,
    KeySettings = {
        DinoHub = "Untitled",
        Subtitle = "Key System",
        Note = "Join The Discord For The Key",
        FileName = "",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"dinohub"}
    }
})

-- Pages
local aimbotPage = Window:CreateTab("Aimbot")
local espPage = Window:CreateTab("ESP")
local miscPage = Window:CreateTab("Misc")

-- ==== Aimbot Page ====
aimbotPage:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(val)
        Aimbot = val
        notify("Aimbot: " .. (Aimbot and "ON" or "OFF"))
    end
})

aimbotPage:CreateToggle({
    Name = "Smooth Aimbot",
    CurrentValue = false,
    Flag = "SmoothToggle",
    Callback = function(val)
        Smooth = val
        notify("Smooth Aimbot: " .. (Smooth and "ON" or "OFF"))
    end
})

aimbotPage:CreateToggle({
    Name = "Wall Aimbot",
    CurrentValue = false,
    Flag = "WallToggle",
    Callback = function(val)
        Wall = val
        notify("Wall Aimbot: " .. (Wall and "ON" or "OFF"))
    end
})

aimbotPage:CreateToggle({
    Name = "Safe Mode",
    CurrentValue = false,
    Flag = "SafeModeToggle",
    Callback = function(val)
        SafeMode = val
        notify("Safe Mode: " .. (SafeMode and "ON" or "OFF"))
    end
})

aimbotPage:CreateDropdown({
    Name = "Target Lock Part",
    Options = parts,
    CurrentOption = TargetPart,
    Flag = "TargetPartDropdown",
    Callback = function(val)
        TargetPart = val
        partIdx = table.find(parts, val)
        notify("Target Lock: " .. TargetPart)
    end
})

-- ==== ESP Page ====
espPage:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(val)
        ESP = val
        notify("ESP: " .. (ESP and "ON" or "OFF"))
    end
})

espPage:CreateToggle({
    Name = "ESP Team",
    CurrentValue = false,
    Flag = "ESPTeamToggle",
    Callback = function(val)
        ESPTeam = val
        notify("ESP Team: " .. (ESPTeam and "ON" or "OFF"))
    end
})

espPage:CreateToggle({
    Name = "Show Name",
    CurrentValue = false,
    Flag = "ShowNameToggle",
    Callback = function(val)
        ShowName = val
        notify("Show Name: " .. (ShowName and "ON" or "OFF"))
    end
})

espPage:CreateDropdown({
    Name = "ESP Mode",
    Options = {"Highlight", "Box"},
    CurrentOption = ESPMode,
    Flag = "ESPModeDropdown",
    Callback = function(val)
        ESPMode = val
        notify("ESP Mode: " .. ESPMode)
    end
})

espPage:CreateTextBox({
    Name = "ESP Color",
    PlaceholderText = "red, blue, green, etc",
    RemoveTextAfterFocusLost = false,
    Callback = function(val)
        Rainbow = false
        local color = val:lower()
        ESPColor = ({
            red = Color3.fromRGB(255,0,0),
            blue = Color3.fromRGB(0,0,255),
            green = Color3.fromRGB(0,255,0),
            yellow = Color3.fromRGB(255,255,0),
            black = Color3.fromRGB(0,0,0),
            white = Color3.fromRGB(255,255,255),
            pink = Color3.fromRGB(255,105,180),
            purple = Color3.fromRGB(128,0,128),
            orange = Color3.fromRGB(255,165,0),
            cyan = Color3.fromRGB(0,255,255),
            rainbow = (Rainbow = true)
        })[color] or Color3.new(1,1,1)
        notify("ESP Color: " .. val)
    end
})

-- ==== Misc Page ====
miscPage:CreateToggle({
    Name = "Kill All",
    CurrentValue = false,
    Flag = "KillAllToggle",
    Callback = function(val)
        KillAll = val
        KillAllIndex = 1
        notify("Kill All: " .. (KillAll and "ON" or "OFF"))
    end
})

miscPage:CreateDropdown({
    Name = "Position",
    Options = {"Front", "Behind"},
    CurrentOption = PositionMode,
    Flag = "PositionDropdown",
    Callback = function(val)
        PositionMode = val
        notify("Position: " .. PositionMode)
    end
})

miscPage:CreateToggle({
    Name = "Auto Fire",
    CurrentValue = false,
    Flag = "AutoFireToggle",
    Callback = function(val)
        AutoFire = val
        notify("Auto Fire: " .. (AutoFire and "ON" or "OFF"))
        if AutoFire then
            startAutoFire()
        else
            stopAutoFire()
        end
    end
})

-- ==== Functions ====
local function valid(p)
    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    return p and p.Character
        and p.Character:FindFirstChild(TargetPart)
        and p.Character:FindFirstChild("Humanoid")
        and p.Character.Humanoid.Health > 0
        and hrp and hrp.Position.Y > MIN_Y_COORDINATE
end

local function isBehind(p)
    local o = Camera.CFrame.Position
    local d = (p.Character[TargetPart].Position - o)
    local ray = Ray.new(o, d)
    local hit = workspace:FindPartOnRay(ray, player.Character)
    return hit and not p.Character:IsAncestorOf(hit)
end

local function getClosest()
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and valid(p) and p.Team ~= player.Team then
            if not Wall and isBehind(p) then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character[TargetPart].Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then dist, best = mag, p end
            end
        end
    end
    return best
end

local function getEnemies()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and valid(p) and p.Team ~= player.Team then
            table.insert(list, p)
        end
    end
    return list
end

local function getSafeTarget()
    local safeTarget = nil
    local safeDist = safemodew
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and valid(p) and p.Team ~= player.Team then
            local dist = (p.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
            if dist <= safeDist then
                safeDist = dist
                safeTarget = p
            end
        end
    end
    return safeTarget
end

local function getPositionCFrame(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = target.Character.HumanoidRootPart
    local offset = (PositionMode == "Front" and hrp.CFrame.LookVector * 3) or (-hrp.CFrame.LookVector * 3)
    return CFrame.new(hrp.Position + offset, hrp.Position)
end

function startAutoFire()
    if autoFireConnection then return end
    autoFireConnection = RunService.RenderStepped:Connect(function()
        if AutoFire and player and player.Character and player.Character:FindFirstChildOfClass("Tool") then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool:Activate()
            end
        end
    end)
end

function stopAutoFire()
    if autoFireConnection then
        autoFireConnection:Disconnect()
        autoFireConnection = nil
    end
end

-- ==== Render Loop ====
RunService.RenderStepped:Connect(function()
    -- Target selection
    if not Aimbot and not KillAll then CurrentTarget = nil end

    if KillAll then
        local enemies = getEnemies()
        if #enemies > 0 then
            local currentTime = tick()
            if not CurrentTarget or not valid(CurrentTarget) or (currentTime - lastTeleportTime >= TELEPORT_DELAY) then
                local foundNewTarget = false
                local startIdx = KillAllIndex
                repeat
                    KillAllIndex = (KillAllIndex % #enemies) + 1
                    CurrentTarget = enemies[KillAllIndex]
                    if valid(CurrentTarget) and CurrentTarget.Team ~= player.Team then
                        foundNewTarget = true
                        break
                    end
                    if KillAllIndex == startIdx then break end
                until foundNewTarget
                if not foundNewTarget then CurrentTarget = nil end
                lastTeleportTime = currentTime
            end
        else CurrentTarget = nil end

        if CurrentTarget and valid(CurrentTarget) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = getPositionCFrame(CurrentTarget)
            if pos then player.Character.HumanoidRootPart.CFrame = pos end
            local goal = CFrame.new(Camera.CFrame.Position, CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame = Smooth and Camera.CFrame:Lerp(goal,0.2) or goal
        else CurrentTarget = nil end
    elseif Aimbot then
        if SafeMode then CurrentTarget = getSafeTarget() else CurrentTarget = getClosest() end
        if CurrentTarget and valid(CurrentTarget) and CurrentTarget.Team ~= player.Team then
            local goal = CFrame.new(Camera.CFrame.Position, CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame = Smooth and Camera.CFrame:Lerp(goal,0.2) or goal
        else CurrentTarget = nil end
    end

    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p == player then continue end
        local v = valid(p) and (not ESPTeam or p.Team ~= player.Team)
        if ESP and v then
            local c = Rainbow and Color3.fromHSV(tick()%5/5,1,1) or ESPColor
            if ESPMode == "Highlight" then
                if not highlights[p] then
                    local h = Instance.new("Highlight")
                    h.Adornee = p.Character
                    h.FillTransparency = 0.5
                    h.Parent = p.Character
                    highlights[p] = h
                    if boxes[p] then boxes[p]:Destroy() boxes[p] = nil end
                end
                highlights[p].FillColor = c
            elseif ESPMode == "Box" then
                local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
                if root then
                    if not boxes[p] then
                        local b = Instance.new("BoxHandleAdornment")
                        b.Adornee = root
                        b.Size = Vector3.new(4,6,2)
                        b.AlwaysOnTop = true
                        b.ZIndex = 5
                        b.Transparency = 0.5
                        b.Color3 = c
                        b.Parent = root
                        boxes[p] = b
                        if highlights[p] then highlights[p]:Destroy() highlights[p] = nil end
                    else boxes[p].Color3 = c end
                end
            end
            if ShowName and not names[p] then
                local bb = Instance.new("BillboardGui", p.Character)
                bb.Adornee = p.Character:FindFirstChild("Head")
                bb.Size = UDim2.new(0,150,0,30)
                bb.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.Text = p.DisplayName.."(@"..p.Name..")"
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.Font = Enum.Font.Gotham
                lbl.TextScaled = true
                names[p] = bb
            elseif not ShowName and names[p] then
                names[p]:Destroy()
                names[p] = nil
            end
        else
            if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end
            if boxes[p] then boxes[p]:Destroy() boxes[p]=nil end
            if names[p] then names[p]:Destroy() names[p]=nil end
        end
    end
end)
