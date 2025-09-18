-- =========================
-- DinoHub Arsenal 🦖 | Full Clean + Rayfield KeySystem
-- =========================

-- Rayfield KeySystem Setup
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/dexhub-art/rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "DinoHubKeySystem",
   LoadingTitle = "DinoHub Interface",
   LoadingSubtitle = "by DinoHub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "https://discord.gg/jb9WctzJd5",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      DinoHub = "Untitled",
      Subtitle = "Key System",
      Note = "Join The Discord For The Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"dinohub"}
   }
})

-- =========================
-- Services & Player
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local MIN_Y_COORDINATE = -50

-- Notification helper
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DinoHub Arsenal 🦖",
            Text = txt,
            Duration = 3
        })
    end)
end

local function getRainbow(t)
    local f = 2
    return Color3.fromRGB(
        math.floor(math.sin(f*t+0)*127+128),
        math.floor(math.sin(f*t+2)*127+128),
        math.floor(math.sin(f*t+4)*127+128)
    )
end

notify("✅ DinoHub Arsenal Loaded")

-- =========================
-- GUI Setup
-- =========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DinoHub Arsenal 🦖"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 380)
frame.Position = UDim2.new(0.5, -135, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ARSENAL | DinoHub"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0.6

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- =========================
-- Section & Button Helpers
-- =========================
local function createSectionTitle(text, posY, parentFrame)
    local lbl = Instance.new("TextLabel", parentFrame)
    lbl.Size = UDim2.new(1, -20, 0, 28)
    lbl.Position = UDim2.new(0, 10, 0, posY)
    lbl.Text = text
    lbl.Name = "SectionTitle"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    return lbl
end

local function createBtn(text, posY, parentFrame)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parentFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

-- =========================
-- Variables
-- =========================
local Aimbot, Smooth, Wall, ESP, ESPTeam, ShowName, SafeMode, KillAll, AutoFire = false, false, false, false, false, false, false, false, false
local TargetPart, parts, partIdx = "Head", {"Head","UpperTorso","Torso"}, 1
local ESPMode = "Highlight"
local ESPColor = Color3.new(1,1,1)
local Rainbow = false
local KillAllIndex = 1
local safemodew = 10
local PositionMode = "Front"

-- =========================
-- Pages
-- =========================
local pages = {}
local currentPage = 1
local aimbotPage = Instance.new("Frame", frame)
aimbotPage.Name = "AimbotPage"
aimbotPage.Size = UDim2.new(1,0,1,-36)
aimbotPage.Position = UDim2.new(0,0,0,36)
aimbotPage.BackgroundTransparency = 1
pages[1] = aimbotPage

local espPage = Instance.new("Frame", frame)
espPage.Name = "ESPPage"
espPage.Size = UDim2.new(1,0,1,-36)
espPage.Position = UDim2.new(0,0,0,36)
espPage.BackgroundTransparency = 1
espPage.Visible = false
pages[2] = espPage

local miscPage = Instance.new("Frame", frame)
miscPage.Name = "MiscPage"
miscPage.Size = UDim2.new(1,0,1,-36)
miscPage.Position = UDim2.new(0,0,0,36)
miscPage.BackgroundTransparency = 1
miscPage.Visible = false
pages[3] = miscPage

-- =========================
-- AutoFire Functions
-- =========================
local autoFireConnection
local function startAutoFire()
    if autoFireConnection then return end
    autoFireConnection = RunService.RenderStepped:Connect(function()
        if AutoFire and player and player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool:Activate()
            end
        end
    end)
end

local function stopAutoFire()
    if autoFireConnection then
        autoFireConnection:Disconnect()
        autoFireConnection = nil
    end
end

-- =========================
-- Pages Navigation Buttons
-- =========================
local btnBack = Instance.new("TextButton", frame)
btnBack.Size = UDim2.new(0,40,0,30)
btnBack.Position = UDim2.new(0,10,1,-40)
btnBack.Text = "<"
btnBack.Font = Enum.Font.GothamBlack
btnBack.TextScaled = true
btnBack.BackgroundColor3 = Color3.fromRGB(35,35,35)
btnBack.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnBack).CornerRadius = UDim.new(0,8)

local btnNext = Instance.new("TextButton", frame)
btnNext.Size = UDim2.new(0,40,0,30)
btnNext.Position = UDim2.new(1,-50,1,-40)
btnNext.Text = ">"
btnNext.Font = Enum.Font.GothamBlack
btnNext.TextScaled = true
btnNext.BackgroundColor3 = Color3.fromRGB(35,35,35)
btnNext.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnNext).CornerRadius = UDim.new(0,8)

local function showPage(pageNumber)
    for i,page in ipairs(pages) do
        page.Visible = (i==pageNumber)
    end
    currentPage = pageNumber
    btnBack.Visible = (currentPage>1)
    btnNext.Visible = (currentPage<#pages)
end
showPage(1)
btnBack.MouseButton1Click:Connect(function() if currentPage>1 then showPage(currentPage-1) notify("Page: "..currentPage) end end)
btnNext.MouseButton1Click:Connect(function() if currentPage<#pages then showPage(currentPage+1) notify("Page: "..currentPage) end end)

-- =========================
-- Aimbot, KillAll, ESP Logic
-- =========================
local highlights, boxes, names = {}, {}, {}
local CurrentTarget = nil
local lastTeleportTime = 0
local TELEPORT_DELAY = 1.5

local function valid(p)
    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    return p and p.Character and p.Character:FindFirstChild(TargetPart)
        and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health>0
        and hrp and hrp.Position.Y>MIN_Y_COORDINATE
end

local function isBehind(p)
    local o = Camera.CFrame.Position
    local d = (p.Character[TargetPart].Position-o)
    local ray = Ray.new(o,d)
    local hit = workspace:FindPartOnRay(ray, player.Character)
    return hit and not p.Character:IsAncestorOf(hit)
end

local function getClosest()
    local best, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=player and valid(p) and p.Team~=player.Team then
            if not Wall and isBehind(p) then continue end
            local pos,onScreen = Camera:WorldToViewportPoint(p.Character[TargetPart].Position)
            if onScreen then
                local mag = (Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
                if mag<dist then dist,best=mag,p end
            end
        end
    end
    return best
end

local function getEnemies()
    local list={}
    for _,p in pairs(Players:GetPlayers()) do
        if p~=player and valid(p) and p.Team~=player.Team then table.insert(list,p) end
    end
    return list
end

local function getSafeTarget()
    local safeTarget=nil
    local safeDist=safemodew
    for _,p in pairs(Players:GetPlayers()) do
        if p~=player and valid(p) and p.Team~=player.Team then
            local dist=(p.Character.PrimaryPart.Position-player.Character.PrimaryPart.Position).Magnitude
            if dist<=safeDist then safeDist=dist safeTarget=p end
        end
    end
    return safeTarget
end

local function getPositionCFrame(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp=target.Character.HumanoidRootPart
    local offset = PositionMode=="Front" and hrp.CFrame.LookVector*3 or -hrp.CFrame.LookVector*3
    return CFrame.new(hrp.Position+offset, hrp.Position)
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Determine target
    if not Aimbot and not KillAll then CurrentTarget=nil end

    if KillAll then
        local enemies=getEnemies()
        if #enemies>0 then
            local currentTime=tick()
            if not CurrentTarget or not valid(CurrentTarget) or (currentTime-lastTeleportTime>=TELEPORT_DELAY) then
                local foundNew=false
                local startIdx=KillAllIndex
                repeat
                    KillAllIndex=(KillAllIndex%#enemies)+1
                    CurrentTarget=enemies[KillAllIndex]
                    if valid(CurrentTarget) and CurrentTarget.Team~=player.Team then
                        foundNew=true break
                    end
                    if KillAllIndex==startIdx then break end
                until foundNew
                if foundNew then lastTeleportTime=currentTime else CurrentTarget=nil end
            end
        else CurrentTarget=nil end

        if CurrentTarget and valid(CurrentTarget) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos=getPositionCFrame(CurrentTarget)
            if pos then player.Character.HumanoidRootPart.CFrame=pos end
            local goal=CFrame.new(Camera.CFrame.Position,CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame=Smooth and Camera.CFrame:Lerp(goal,0.2) or goal
        else CurrentTarget=nil end
    elseif Aimbot then
        if SafeMode then CurrentTarget=getSafeTarget() else CurrentTarget=getClosest() end
        if CurrentTarget and valid(CurrentTarget) and CurrentTarget.Team~=player.Team then
            local goal=CFrame.new(Camera.CFrame.Position,CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame=Smooth and Camera.CFrame:Lerp(goal,0.2) or goal
        else CurrentTarget=nil end
    end

    -- ESP Logic
    for _,p in pairs(Players:GetPlayers()) do
        if p==player then continue end
        local v=valid(p) and (not ESPTeam or p.Team~=player.Team)
        if ESP and v then
            local c = Rainbow and getRainbow(tick()) or ESPColor
            -- Highlight
            if ESPMode=="Highlight" then
                if not highlights[p] then
                    local h=Instance.new("Highlight")
                    h.Adornee=p.Character
                    h.FillTransparency=0.5
                    h.Parent=p.Character
                    highlights[p]=h
                    if boxes[p] then boxes[p]:Destroy() boxes[p]=nil end
                end
                highlights[p].FillColor=c
            elseif ESPMode=="Box" then
                local root=p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
                if root then
                    if not boxes[p] then
                        local b=Instance.new("BoxHandleAdornment")
                        b.Adornee=root
                        b.Size=Vector3.new(4,6,2)
                        b.AlwaysOnTop=true
                        b.ZIndex=5
                        b.Transparency=0.5
                        b.Color3=c
                        b.Parent=root
                        boxes[p]=b
                        if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end
                    else boxes[p].Color3=c end
                end
            end
            -- Names
            if ShowName and not names[p] then
                local head=p.Character:FindFirstChild("Head")
                if head then
                    local bb=Instance.new("BillboardGui",p.Character)
                    bb.Adornee=head
                    bb.Size=UDim2.new(0,150,0,30)
                    bb.AlwaysOnTop=true
                    local lbl=Instance.new("TextLabel",bb)
                    lbl.Size=UDim2.new(1,0,1,0)
                    lbl.Text=p.DisplayName.."(@"..p.Name..")"
                    lbl.BackgroundTransparency=1
                    lbl.TextColor3=Color3.new(1,1,1)
                    lbl.Font=Enum.Font.Gotham
                    lbl.TextScaled=true
                    names[p]=bb
                end
            elseif not ShowName and names[p] then names[p]:Destroy() names[p]=nil end
        else
            if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end
            if boxes[p] then boxes[p]:Destroy() boxes[p]=nil end
            if names[p] then names[p]:Destroy() names[p]=nil end
        end
    end
end)

-- UI Rainbow Effect
RunService.RenderStepped:Connect(function()
    title.TextColor3 = Rainbow and getRainbow(tick()) or Color3.new(1,1,1)
end)

-- =========================
-- GUI Buttons
-- =========================
local posY=5
createSectionTitle("Aimbot Settings", posY, aimbotPage)
posY+=30
local btnAimbot=createBtn("Aimbot: OFF", posY, aimbotPage)
btnAimbot.MouseButton1Click:Connect(function()
    Aimbot=not Aimbot
    btnAimbot.Text="Aimbot: "..(Aimbot and "ON" or "OFF")
    notify(btnAimbot.Text)
end)
posY+=38

local btnSmooth=createBtn("Smooth: OFF", posY, aimbotPage)
btnSmooth.MouseButton1Click:Connect(function()
    Smooth=not Smooth
    btnSmooth.Text="Smooth: "..(Smooth and "ON" or "OFF")
    notify(btnSmooth.Text)
end)
posY+=38

local btnWall=createBtn("WallCheck: OFF", posY, aimbotPage)
btnWall.MouseButton1Click:Connect(function()
    Wall=not Wall
    btnWall.Text="WallCheck: "..(Wall and "ON" or "OFF")
    notify(btnWall.Text)
end)
posY+=38

local btnSafe=createBtn("SafeMode: OFF", posY, aimbotPage)
btnSafe.MouseButton1Click:Connect(function()
    SafeMode=not SafeMode
    btnSafe.Text="SafeMode: "..(SafeMode and "ON" or "OFF")
    notify(btnSafe.Text)
end)
posY+=38

local btnTarget=createBtn("Target: Head", posY, aimbotPage)
btnTarget.MouseButton1Click:Connect(function()
    partIdx=(partIdx%#parts)+1
    TargetPart=parts[partIdx]
    btnTarget.Text="Target: "..TargetPart
    notify(btnTarget.Text)
end)

-- ESP Page Buttons
posY=5
createSectionTitle("ESP Settings", posY, espPage)
posY+=30
local btnESP=createBtn("ESP: OFF", posY, espPage)
btnESP.MouseButton1Click:Connect(function()
    ESP=not ESP
    btnESP.Text="ESP: "..(ESP and "ON" or "OFF")
    notify(btnESP.Text)
end)
posY+=38

local btnESPTeam=createBtn("Team Check: OFF", posY, espPage)
btnESPTeam.MouseButton1Click:Connect(function()
    ESPTeam=not ESPTeam
    btnESPTeam.Text="Team Check: "..(ESPTeam and "ON" or "OFF")
    notify(btnESPTeam.Text)
end)
posY+=38

local btnShowName=createBtn("Show Names: OFF", posY, espPage)
btnShowName.MouseButton1Click:Connect(function()
    ShowName=not ShowName
    btnShowName.Text="Show Names: "..(ShowName and "ON" or "OFF")
    notify(btnShowName.Text)
end)
posY+=38

local btnRainbow=createBtn("Rainbow: OFF", posY, espPage)
btnRainbow.MouseButton1Click:Connect(function()
    Rainbow=not Rainbow
    btnRainbow.Text="Rainbow: "..(Rainbow and "ON" or "OFF")
    notify(btnRainbow.Text)
end)

-- Misc Page Buttons
posY=5
createSectionTitle("Misc Settings", posY, miscPage)
posY+=30
local btnKillAll=createBtn("Kill All: OFF", posY, miscPage)
btnKillAll.MouseButton1Click:Connect(function()
    KillAll=not KillAll
    btnKillAll.Text="Kill All: "..(KillAll and "ON" or "OFF")
    notify(btnKillAll.Text)
end)
posY+=38

local btnAutoFire=createBtn("Auto Fire: OFF", posY, miscPage)
btnAutoFire.MouseButton1Click:Connect(function()
    AutoFire=not AutoFire
    btnAutoFire.Text="Auto Fire: "..(AutoFire and "ON" or "OFF")
    if AutoFire then startAutoFire() else stopAutoFire() end
    notify(btnAutoFire.Text)
end)
