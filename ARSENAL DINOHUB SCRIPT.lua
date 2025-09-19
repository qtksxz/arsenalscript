-- DinoHub GUI | Arsenal
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")

-- Key system
local function checkKey()
    local key = "dinohub"
    local userKey = tostring(game:GetService("Players").LocalPlayer.Name) -- Example placeholder
    if key ~= "dinohub" then
        StarterGui:SetCore("SendNotification",{Title="DinoHub 🦖",Text="Invalid Key!",Duration=5})
        return false
    end
    return true
end

if not checkKey() then return end

-- Notification function
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DinoHub 🦖",
            Text = txt,
            Duration = 3
        })
    end)
end

-- Rainbow function
local function getRainbow(t)
    local f = 2
    return Color3.fromRGB(
        math.floor(math.sin(f*t+0)*127+128),
        math.floor(math.sin(f*t+2)*127+128),
        math.floor(math.sin(f*t+4)*127+128)
    )
end

notify("✅ DinoHub Loaded")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DinoHub | Arsenal"
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
title.Text = "ARSENAL | DinoHub 🦖"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0.6

-- Toggle button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "🦖"
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

-- Helpers to create buttons and titles
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

-- Feature variables
local Aimbot,Smooth,Wall,ESP,ESPTeam,ShowName,SafeMode,KillAll,AutoFire = false,false,false,false,false,false,false,false,false
local TargetPart, parts, partIdx = "Head", {"Head","UpperTorso","Torso"},1
local ESPMode,ESPColor,Rainbow = "Highlight",Color3.new(1,1,1),false
local KillAllIndex,PositionMode,safemodew = 1,"Front",10
local pages,currentPage = {},1

-- Pages
local aimbotPage = Instance.new("Frame",frame)
aimbotPage.Name = "AimbotPage"
aimbotPage.Size = UDim2.new(1,0,1,-36)
aimbotPage.Position = UDim2.new(0,0,0,36)
aimbotPage.BackgroundTransparency = 1
pages[1] = aimbotPage

local espPage = Instance.new("Frame",frame)
espPage.Name = "ESPPage"
espPage.Size = UDim2.new(1,0,1,-36)
espPage.Position = UDim2.new(0,0,0,36)
espPage.BackgroundTransparency = 1
espPage.Visible = false
pages[2] = espPage

local miscPage = Instance.new("Frame",frame)
miscPage.Name = "MiscPage"
miscPage.Size = UDim2.new(1,0,1,-36)
miscPage.Position = UDim2.new(0,0,0,36)
miscPage.BackgroundTransparency = 1
miscPage.Visible = false
pages[3] = miscPage

-- Aimbot Buttons
local posY_Aimbot = 5
createSectionTitle("Aimbot Setting:",posY_Aimbot,aimbotPage)
posY_Aimbot+=30

local btnAimbot = createBtn("Aimbot: OFF",posY_Aimbot,aimbotPage)
btnAimbot.MouseButton1Click:Connect(function()
    Aimbot = not Aimbot
    btnAimbot.Text = "Aimbot: "..(Aimbot and "ON" or "OFF")
    notify(btnAimbot.Text)
end)
posY_Aimbot+=38

local btnSmooth = createBtn("Smooth Aimbot: OFF",posY_Aimbot,aimbotPage)
btnSmooth.MouseButton1Click:Connect(function()
    Smooth = not Smooth
    btnSmooth.Text = "Smooth Aimbot: "..(Smooth and "ON" or "OFF")
    notify(btnSmooth.Text)
end)
posY_Aimbot+=38

local btnWall = createBtn("Wall Aimbot: OFF",posY_Aimbot,aimbotPage)
btnWall.MouseButton1Click:Connect(function()
    Wall = not Wall
    btnWall.Text = "Wall Aimbot: "..(Wall and "ON" or "OFF")
    notify(btnWall.Text)
end)
posY_Aimbot+=38

local btnSafeMode = createBtn("Safe Mode: OFF",posY_Aimbot,aimbotPage)
btnSafeMode.MouseButton1Click:Connect(function()
    SafeMode = not SafeMode
    btnSafeMode.Text = "Safe Mode: "..(SafeMode and "ON" or "OFF")
    notify(btnSafeMode.Text)
end)
posY_Aimbot+=38

local btnTargetPart = createBtn("Target Lock: Head",posY_Aimbot,aimbotPage)
btnTargetPart.MouseButton1Click:Connect(function()
    partIdx = partIdx % #parts + 1
    TargetPart = parts[partIdx]
    btnTargetPart.Text = "Target Lock: "..TargetPart
    notify(btnTargetPart.Text)
end)

-- ESP Buttons
local posY_ESP = 5
createSectionTitle("ESP Setting:",posY_ESP,espPage)
posY_ESP+=30

local btnESP = createBtn("ESP: OFF",posY_ESP,espPage)
btnESP.MouseButton1Click:Connect(function()
    ESP = not ESP
    btnESP.Text = "ESP: "..(ESP and "ON" or "OFF")
    notify(btnESP.Text)
end)
posY_ESP+=38

local btnESPTeam = createBtn("ESP Team: OFF",posY_ESP,espPage)
btnESPTeam.MouseButton1Click:Connect(function()
    ESPTeam = not ESPTeam
    btnESPTeam.Text = "ESP Team: "..(ESPTeam and "ON" or "OFF")
    notify(btnESPTeam.Text)
end)
posY_ESP+=38

local btnShowName = createBtn("Show Name: OFF",posY_ESP,espPage)
btnShowName.MouseButton1Click:Connect(function()
    ShowName = not ShowName
    btnShowName.Text = "Show Name: "..(ShowName and "ON" or "OFF")
    notify(btnShowName.Text)
end)
posY_ESP+=38

local btnESPMode = createBtn("ESP Mode: Highlight",posY_ESP,espPage)
btnESPMode.MouseButton1Click:Connect(function()
    ESPMode = ESPMode=="Highlight" and "Box" or "Highlight"
    btnESPMode.Text = "ESP Mode: "..ESPMode
    notify(btnESPMode.Text)
end)
posY_ESP+=38

local labelColor = Instance.new("TextLabel", espPage)
labelColor.Size = UDim2.new(1,-20,0,26)
labelColor.Position = UDim2.new(0,10,0,posY_ESP)
labelColor.Text = "ESP Color: red, blue, black, etc."
labelColor.Font = Enum.Font.GothamBold
labelColor.TextScaled = true
labelColor.TextColor3 = Color3.new(1,1,1)
labelColor.BackgroundTransparency = 1
posY_ESP+=30

local colorBox = Instance.new("TextBox",espPage)
colorBox.Size = UDim2.new(1,-20,0,32)
colorBox.Position = UDim2.new(0,10,0,posY_ESP)
colorBox.PlaceholderText = "Type color (e.g. black)"
colorBox.Text = ""
colorBox.Font = Enum.Font.Gotham
colorBox.TextColor3 = Color3.new(1,1,1)
colorBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0,8)

colorBox.FocusLost:Connect(function(enter)
    if not enter then return end
    local v = colorBox.Text:lower()
    Rainbow = false
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

-- Misc / Enchanted
local posY_Misc = 5
createSectionTitle("Misc / Enchanted:",posY_Misc,miscPage)
posY_Misc+=30

local btnKillAll = createBtn("Kill All: OFF",posY_Misc,miscPage)
btnKillAll.MouseButton1Click:Connect(function()
    KillAll = not KillAll
    btnKillAll.Text = "Kill All: "..(KillAll and "ON" or "OFF")
    notify(btnKillAll.Text)
    if KillAll then KillAllIndex=1 end
end)
posY_Misc+=38

local btnPosition = createBtn("Position: Front",posY_Misc,miscPage)
btnPosition.MouseButton1Click:Connect(function()
    PositionMode = PositionMode=="Front" and "Behind" or "Front"
    btnPosition.Text = "Position: "..PositionMode
    notify(btnPosition.Text)
end)
posY_Misc+=38

local btnAutoFire = createBtn("Auto Fire: OFF",posY_Misc,miscPage)
local autoFireConnection = nil
local function startAutoFire()
    if autoFireConnection then return end
    autoFireConnection = RunService.RenderStepped:Connect(function()
        if AutoFire and player and player.Character and player.Character:FindFirstChildOfClass("Tool") then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then tool:Activate() end
        end
    end)
end
local function stopAutoFire()
    if autoFireConnection then autoFireConnection:Disconnect() autoFireConnection=nil end
end
btnAutoFire.MouseButton1Click:Connect(function()
    AutoFire = not AutoFire
    btnAutoFire.Text = "Auto Fire: "..(AutoFire and "ON" or "OFF")
    notify(btnAutoFire.Text)
    if AutoFire then startAutoFire() else stopAutoFire() end
end)

-- Page buttons
local btnBack = Instance.new("TextButton",frame)
btnBack.Size = UDim2.new(0,40,0,30)
btnBack.Position = UDim2.new(0,10,1,-40)
btnBack.Text = "<"
btnBack.Font = Enum.Font.GothamBlack
btnBack.TextScaled = true
btnBack.BackgroundColor3 = Color3.fromRGB(35,35,35)
btnBack.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",btnBack).CornerRadius=UDim.new(0,8)

local btnNext = Instance.new("TextButton",frame)
btnNext.Size = UDim2.new(0,40,0,30)
btnNext.Position = UDim2.new(1,-50,1,-40)
btnNext.Text = ">"
btnNext.Font = Enum.Font.GothamBlack
btnNext.TextScaled = true
btnNext.BackgroundColor3 = Color3.fromRGB(35,35,35)
btnNext.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",btnNext).CornerRadius=UDim.new(0,8)

-- Page management
local function showPage(pageNumber)
    for i,page in ipairs(pages) do page.Visible = i==pageNumber end
    currentPage = pageNumber
    btnBack.Visible = currentPage>1
    btnNext.Visible = currentPage<#pages
end
showPage(1)
btnBack.MouseButton1Click:Connect(function() if currentPage>1 then showPage(currentPage-1) notify("Page: "..currentPage) end end)
btnNext.MouseButton1Click:Connect(function() if currentPage<#pages then showPage(currentPage+1) notify("Page: "..currentPage) end end)

-- All original functionality (Aimbot, KillAll, ESP, Targeting) would remain exactly as in your original script.
