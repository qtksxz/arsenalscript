-- DinoHub Arsenal 🦖 fully integrated into your GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")

local MIN_Y_COORDINATE = -50
local TELEPORT_DELAY = 1.5
local safemodew = 10

-- Notification function
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

notify("✅ DinoHub Arsenal 🦖 Loaded")

-- === GUI CREATION ===
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DinoHub Arsenal 🦖"
gui.ResetOnSpawn = false

-- FRAME
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
title.Text = "ARSENAL | DinoHub Arsenal 🦖"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextStrokeTransparency = 0.6

-- GUI toggle button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- HELPER: create section
local function createSectionTitle(text,posY,parent)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1,-20,0,28)
    lbl.Position = UDim2.new(0,10,0,posY)
    lbl.Text = text
    lbl.Name = "SectionTitle"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    return lbl
end

local function createBtn(text,posY,parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,32)
    b.Position = UDim2.new(0,10,0,posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

-- === FEATURE VARIABLES ===
local Aimbot, Smooth, Wall, ESP, ESPTeam, ShowName, SafeMode, KillAll, AutoFire = false,false,false,false,false,false,false,false,false
local TargetPart, parts, partIdx = "Head", {"Head","UpperTorso","Torso"}, 1
local ESPMode, ESPColor, Rainbow = "Highlight", Color3.new(1,1,1), false
local PositionMode, KillAllIndex = "Front",1
local CurrentTarget, autoFireConnection, lastTeleportTime = nil,nil,0
local highlights, boxes, names = {},{},{}

-- === PAGES ===
local pages = {}
local currentPage = 1
local function createPage(name)
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.new(1,0,1,-36)
    p.Position = UDim2.new(0,0,0,36)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = frame
    return p
end

local aimbotPage = createPage("AimbotPage")
local espPage = createPage("ESPPage")
local miscPage = createPage("MiscPage")
pages = {aimbotPage, espPage, miscPage}
pages[1].Visible = true

-- === AIMBOT SECTION ===
local posY_A = 5
createSectionTitle("Aimbot Settings",posY_A,aimbotPage); posY_A=posY_A+30
local btnAimbot = createBtn("Aimbot: OFF",posY_A,aimbotPage)
btnAimbot.MouseButton1Click:Connect(function() Aimbot = not Aimbot; btnAimbot.Text="Aimbot: "..(Aimbot and "ON" or "OFF"); notify(btnAimbot.Text) end); posY_A=posY_A+38
local btnSmooth = createBtn("Smooth: OFF",posY_A,aimbotPage)
btnSmooth.MouseButton1Click:Connect(function() Smooth = not Smooth; btnSmooth.Text="Smooth: "..(Smooth and "ON" or "OFF"); notify(btnSmooth.Text) end); posY_A=posY_A+38
local btnWall = createBtn("WallCheck: OFF",posY_A,aimbotPage)
btnWall.MouseButton1Click:Connect(function() Wall = not Wall; btnWall.Text="WallCheck: "..(Wall and "ON" or "OFF"); notify(btnWall.Text) end); posY_A=posY_A+38
local btnSafeMode = createBtn("SafeMode: OFF",posY_A,aimbotPage)
btnSafeMode.MouseButton1Click:Connect(function() SafeMode = not SafeMode; btnSafeMode.Text="SafeMode: "..(SafeMode and "ON" or "OFF"); notify(btnSafeMode.Text) end); posY_A=posY_A+38
local btnTargetPart = createBtn("TargetPart: Head",posY_A,aimbotPage)
btnTargetPart.MouseButton1Click:Connect(function() partIdx = partIdx % #parts + 1; TargetPart = parts[partIdx]; btnTargetPart.Text="TargetPart: "..TargetPart; notify(btnTargetPart.Text) end)

-- === ESP SECTION ===
local posY_E = 5
createSectionTitle("ESP Settings",posY_E,espPage); posY_E=posY_E+30
local btnESP = createBtn("ESP: OFF",posY_E,espPage)
btnESP.MouseButton1Click:Connect(function() ESP = not ESP; btnESP.Text="ESP: "..(ESP and "ON" or "OFF"); notify(btnESP.Text) end); posY_E=posY_E+38
local btnESPTeam = createBtn("ESP Team: OFF",posY_E,espPage)
btnESPTeam.MouseButton1Click:Connect(function() ESPTeam = not ESPTeam; btnESPTeam.Text="ESP Team: "..(ESPTeam and "ON" or "OFF"); notify(btnESPTeam.Text) end); posY_E=posY_E+38
local btnShowName = createBtn("Show Name: OFF",posY_E,espPage)
btnShowName.MouseButton1Click:Connect(function() ShowName = not ShowName; btnShowName.Text="Show Name: "..(ShowName and "ON" or "OFF"); notify(btnShowName.Text) end); posY_E=posY_E+38
local btnESPMode = createBtn("ESP Mode: Highlight",posY_E,espPage)
btnESPMode.MouseButton1Click:Connect(function() ESPMode = ESPMode=="Highlight" and "Box" or "Highlight"; btnESPMode.Text="ESP Mode: "..ESPMode; notify(btnESPMode.Text) end); posY_E=posY_E+38
-- ESP color box
local colorBox = Instance.new("TextBox",espPage)
colorBox.Size = UDim2.new(1,-20,0,32)
colorBox.Position = UDim2.new(0,10,0,posY_E)
colorBox.PlaceholderText = "Type color (red,blue,black,etc)"
colorBox.Text=""
colorBox.Font=Enum.Font.Gotham
colorBox.TextColor3=Color3.new(1,1,1)
colorBox.BackgroundColor3=Color3.fromRGB(35,35,35)
Instance.new("UICorner",colorBox).CornerRadius=UDim.new(0,8)
colorBox.FocusLost:Connect(function(enter)
    if not enter then return end
    Rainbow=false
    local v=colorBox.Text:lower()
    if v=="red" then ESPColor=Color3.fromRGB(255,0,0)
    elseif v=="blue" then ESPColor=Color3.fromRGB(0,0,255)
    elseif v=="green" then ESPColor=Color3.fromRGB(0,255,0)
    elseif v=="yellow" then ESPColor=Color3.fromRGB(255,255,0)
    elseif v=="black" then ESPColor=Color3.fromRGB(0,0,0)
    elseif v=="white" then ESPColor=Color3.fromRGB(255,255,255)
    elseif v=="pink" then ESPColor=Color3.fromRGB(255,105,180)
    elseif v=="purple" then ESPColor=Color3.fromRGB(128,0,128)
    elseif v=="orange" then ESPColor=Color3.fromRGB(255,165,0)
    elseif v=="cyan" then ESPColor=Color3.fromRGB(0,255,255)
    elseif v=="rainbow" then Rainbow=true
    else ESPColor=Color3.new(1,1,1) end
    notify("ESP Color: "..v)
end)

-- === MISC SECTION ===
local posY_M = 5
createSectionTitle("Misc / Enchanted",posY_M,miscPage); posY_M=posY_M+30
local btnKillAll = createBtn("KillAll: OFF",posY_M,miscPage)
btnKillAll.MouseButton1Click:Connect(function() KillAll=not KillAll; btnKillAll.Text="KillAll: "..(KillAll and "ON" or "OFF"); notify(btnKillAll.Text); if KillAll then KillAllIndex=1 end end); posY_M=posY_M+38
local btnPosition = createBtn("Position: Front",posY_M,miscPage)
btnPosition.MouseButton1Click:Connect(function() PositionMode=PositionMode=="Front" and "Behind" or "Front"; btnPosition.Text="Position: "..PositionMode; notify(btnPosition.Text) end); posY_M=posY_M+38
local btnAutoFire = createBtn("AutoFire: OFF",posY_M,miscPage)
btnAutoFire.MouseButton1Click:Connect(function() AutoFire=not AutoFire; btnAutoFire.Text="AutoFire: "..(AutoFire and "ON" or "OFF"); notify(btnAutoFire.Text) end)

-- === BACK/NEXT PAGE ===
local btnBack = Instance.new("TextButton", frame)
btnBack.Size = UDim2.new(0,40,0,30)
btnBack.Position = UDim2.new(0,10,1,-40)
btnBack.Text="<"
btnBack.Font=Enum.Font.GothamBlack
btnBack.TextScaled=true
btnBack.BackgroundColor3=Color3.fromRGB(35,35,35)
btnBack.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",btnBack).CornerRadius=UDim.new(0,8)

local btnNext = Instance.new("TextButton", frame)
btnNext.Size=UDim2.new(0,40,0,30)
btnNext.Position=UDim2.new(1,-50,1,-40)
btnNext.Text=">"
btnNext.Font=Enum.Font.GothamBlack
btnNext.TextScaled=true
btnNext.BackgroundColor3=Color3.fromRGB(35,35,35)
btnNext.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",btnNext).CornerRadius=UDim.new(0,8)

local function showPage(num)
    for i,p in ipairs(pages) do p.Visible = (i==num) end
    currentPage=num
    btnBack.Visible=(currentPage>1)
    btnNext.Visible=(currentPage<#pages)
end

btnBack.MouseButton1Click:Connect(function() if currentPage>1 then showPage(currentPage-1); notify("Page: "..currentPage) end end)
btnNext.MouseButton1Click:Connect(function() if currentPage<#pages then showPage(currentPage+1); notify("Page: "..currentPage) end end)

-- === FUNCTIONAL LOGIC ===
local function valid(p)
    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    return p and p.Character and p.Character:FindFirstChild(TargetPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health>0 and hrp and hrp.Position.Y>MIN_Y_COORDINATE
end

local function isBehind(p)
    local o=Camera.CFrame.Position
    local d=(p.Character[TargetPart].Position-o)
    local ray = Ray.new(o,d)
    local hit = workspace:FindPartOnRay(ray,player.Character)
    return hit and not p.Character:IsAncestorOf(hit)
end

local function getClosest()
    local best, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=player and valid(p) and p.Team~=player.Team then
            if not Wall and isBehind(p) then continue end
            local pos,onScreen = Camera:WorldToViewportPoint(p.Character[TargetPart].Position)
            if onScreen then
                local mag=(Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
                if mag<dist then dist,best=mag,p end
            end
        end
    end
    return best
end

local function getEnemies()
    local list = {}
    for _,p in pairs(Players:GetPlayers()) do
        if p~=player and valid(p) and p.Team~=player.Team then
            table.insert(list,p)
        end
    end
    return list
end

local function getSafeTarget()
    local safeTarget=nil
    local safeDist=safemodew
    for _,p in pairs(Players:GetPlayers()) do
        if p~=player and valid(p) and p.Team~=player.Team then
            local dist=(p.Character.PrimaryPart.Position-player.Character.PrimaryPart.Position).Magnitude
            if dist<=safeDist then safeDist=dist; safeTarget=p end
        end
    end
    return safeTarget
end

local function getPositionCFrame(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp=target.Character.HumanoidRootPart
    local offset=Vector3.new(0,0,0)
    if PositionMode=="Front" then offset=hrp.CFrame.LookVector*3 else offset=-hrp.CFrame.LookVector*3 end
    return CFrame.new(hrp.Position+offset, hrp.Position)
end

local function startAutoFire()
    if autoFireConnection then return end
    autoFireConnection = RunService.RenderStepped:Connect(function()
        if AutoFire and player.Character and player.Character:FindFirstChildOfClass("Tool") then
            local tool=player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then tool:Activate() end
        end
    end)
end

local function stopAutoFire()
    if autoFireConnection then autoFireConnection:Disconnect(); autoFireConnection=nil end
end

RunService.RenderStepped:Connect(function()
    -- AutoFire logic
    if AutoFire then startAutoFire() else stopAutoFire() end

    -- Aimbot & KillAll
    if not Aimbot and not KillAll then CurrentTarget=nil end

    local enemies = getEnemies()
    local now=tick()

    if KillAll and #enemies>0 then
        if not CurrentTarget or not valid(CurrentTarget) or (now-lastTeleportTime>=TELEPORT_DELAY) then
            local startIdx = KillAllIndex
            repeat KillAllIndex=(KillAllIndex%#enemies)+1; CurrentTarget=enemies[KillAllIndex]
                if valid(CurrentTarget) and CurrentTarget.Team~=player.Team then break end
                if KillAllIndex==startIdx then CurrentTarget=nil; break end
            until false
            lastTeleportTime=now
        end

        if CurrentTarget and valid(CurrentTarget) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos=getPositionCFrame(CurrentTarget)
            if pos then player.Character.HumanoidRootPart.CFrame=pos end
            local goal=CFrame.new(Camera.CFrame.Position,CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame=Smooth and Camera.CFrame:Lerp(goal,0.2) or goal
        else CurrentTarget=nil end
    elseif Aimbot then
        CurrentTarget=SafeMode and getSafeTarget() or getClosest()
        if CurrentTarget and valid(CurrentTarget) and CurrentTarget.Team~=player.Team then
            local goal=CFrame.new(Camera.CFrame.Position,CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame=Smooth and Camera.CFrame:Lerp(goal,0.2) or goal
        else CurrentTarget=nil end
    end

    -- ESP logic
    for _,p in pairs(Players:GetPlayers()) do
        if p==player then continue end
        local v = valid(p) and (not ESPTeam or p.Team~=player.Team)
        if ESP and v then
            local c = Rainbow and getRainbow(tick()) or ESPColor
            if ESPMode=="Highlight" then
                if not highlights[p] then local h=Instance.new("Highlight"); h.Adornee=p.Character; h.FillTransparency=0.5; h.Parent=p.Character; highlights[p]=h end
                highlights[p].FillColor=c
            elseif ESPMode=="Box" then
                local root=p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
                if root then
                    if not boxes[p] then
                        local b=Instance.new("BoxHandleAdornment"); b.Adornee=root; b.Size=Vector3.new(4,6,2); b.AlwaysOnTop=true; b.Transparency=0.5; b.Color3=c; b.Parent=root; boxes[p]=b end
                    else boxes[p].Color3=c end
                end
            end

            -- Names
            if ShowName and not names[p] then
                local bb=Instance.new("BillboardGui",p.Character)
                bb.Adornee=p.Character:FindFirstChild("Head")
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
            elseif not ShowName and names[p] then names[p]:Destroy(); names[p]=nil end
        else
            if highlights[p] then highlights[p]:Destroy(); highlights[p]=nil end
            if boxes[p] then boxes[p]:Destroy(); boxes[p]=nil end
            if names[p] then names[p]:Destroy(); names[p]=nil end
        end
    end

    -- Rainbow stroke & title
    local c=getRainbow(tick())
    stroke.Color=c
    title.TextColor3=c
    toggleBtn.TextColor3=c
    for _,lbl in pairs(pages[currentPage]:GetChildren()) do
        if lbl:IsA("TextLabel") and lbl.Name=="SectionTitle" then lbl.TextColor3=c end
    end
    btnNext.TextColor3=c
    btnBack.TextColor3=c
end)
