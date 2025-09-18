-- DinoHub Key System + Arsenal Loadstring
-- Key: "dinohub" 🦖

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Key System
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DinoHub 🦖",
            Text = txt,
            Duration = 3
        })
    end)
end

local function promptKey()
    local key = player:WaitForChild("PlayerGui"):SetCore("PromptInput", {
        Title = "DinoHub Key System 🦖",
        Text = "Enter your key to continue:",
        Placeholder = "Key",
        Callback = function(input)
            if input:lower() == "dinohub" then
                notify("✅ Key correct! Loading DinoHub Arsenal 🦖...")
                loadDinoHub()
            else
                notify("❌ Wrong key! Copying Discord server link...")
                setclipboard("https://discord.gg/jb9WctzJd5")
            end
        end
    })
end

-- Main DinoHub Arsenal
function loadDinoHub()
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local Mouse = player:GetMouse()
    local MIN_Y_COORDINATE = -50 

    notify("✅ DinoHub Arsenal 🦖 Loaded")

    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "DinoHub Arsenal 🦖 | Arsenal"
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

    -- Feature toggles
    local Aimbot, Smooth, Wall, ESP, ESPTeam, ShowName, SafeMode, KillAll, AutoFire = false, false, false, false, false, false, false, false, false
    local TargetPart, parts, partIdx = "Head", {"Head", "UpperTorso", "Torso"}, 1
    local ESPMode = "Highlight"
    local ESPColor = Color3.new(1,1,1)
    local Rainbow = false
    local KillAllIndex = 1
    local safemodew = 10
    local PositionMode = "Front" 

    -- Pages
    local pages = {}
    local currentPage = 1
    local function createPage(name)
        local page = Instance.new("Frame")
        page.Name = name
        page.Size = UDim2.new(1,0,1,-36)
        page.Position = UDim2.new(0,0,0,36)
        page.BackgroundTransparency = 1
        page.Parent = frame
        return page
    end
    local aimbotPage = createPage("AimbotPage")
    local espPage = createPage("ESPPage")
    local miscPage = createPage("MiscPage")
    pages[1], pages[2], pages[3] = aimbotPage, espPage, miscPage
    espPage.Visible, miscPage.Visible = false, false

    -- Aimbot buttons
    local posY = 5
    createSectionTitle("Aimbot Settings:", posY, aimbotPage); posY=posY+30
    local btnAimbot = createBtn("Aimbot: OFF", posY, aimbotPage)
    btnAimbot.MouseButton1Click:Connect(function() Aimbot = not Aimbot; btnAimbot.Text = "Aimbot: "..(Aimbot and "ON" or "OFF"); notify(btnAimbot.Text) end)
    posY = posY + 38
    local btnSmooth = createBtn("Smooth: OFF", posY, aimbotPage)
    btnSmooth.MouseButton1Click:Connect(function() Smooth = not Smooth; btnSmooth.Text = "Smooth: "..(Smooth and "ON" or "OFF"); notify(btnSmooth.Text) end)
    posY = posY + 38
    local btnWall = createBtn("Wall: OFF", posY, aimbotPage)
    btnWall.MouseButton1Click:Connect(function() Wall = not Wall; btnWall.Text = "Wall: "..(Wall and "ON" or "OFF"); notify(btnWall.Text) end)
    posY = posY + 38
    local btnSafe = createBtn("Safe Mode: OFF", posY, aimbotPage)
    btnSafe.MouseButton1Click:Connect(function() SafeMode = not SafeMode; btnSafe.Text = "Safe Mode: "..(SafeMode and "ON" or "OFF"); notify(btnSafe.Text) end)
    posY = posY + 38
    local btnTarget = createBtn("Target: Head", posY, aimbotPage)
    btnTarget.MouseButton1Click:Connect(function() partIdx=partIdx%#parts+1; TargetPart=parts[partIdx]; btnTarget.Text="Target: "..TargetPart; notify(btnTarget.Text) end)

    -- ESP Buttons
    local posY = 5
    createSectionTitle("ESP Settings:", posY, espPage); posY=posY+30
    local btnESP = createBtn("ESP: OFF", posY, espPage)
    btnESP.MouseButton1Click:Connect(function() ESP = not ESP; btnESP.Text="ESP: "..(ESP and "ON" or "OFF"); notify(btnESP.Text) end)
    posY = posY + 38
    local btnESPTeam = createBtn("ESP Team: OFF", posY, espPage)
    btnESPTeam.MouseButton1Click:Connect(function() ESPTeam = not ESPTeam; btnESPTeam.Text="ESP Team: "..(ESPTeam and "ON" or "OFF"); notify(btnESPTeam.Text) end)
    posY = posY + 38
    local btnShowName = createBtn("Show Name: OFF", posY, espPage)
    btnShowName.MouseButton1Click:Connect(function() ShowName = not ShowName; btnShowName.Text="Show Name: "..(ShowName and "ON" or "OFF"); notify(btnShowName.Text) end)
    posY = posY + 38
    local btnESPMode = createBtn("ESP Mode: Highlight", posY, espPage)
    btnESPMode.MouseButton1Click:Connect(function() ESPMode=ESPMode=="Highlight" and "Box" or "Highlight"; btnESPMode.Text="ESP Mode: "..ESPMode; notify(btnESPMode.Text) end)
    posY = posY + 38

    -- Misc Buttons
    local posY = 5
    createSectionTitle("Misc / Enchanted:", posY, miscPage); posY=posY+30
    local btnKillAll = createBtn("Kill All: OFF", posY, miscPage)
    btnKillAll.MouseButton1Click:Connect(function() KillAll=not KillAll; btnKillAll.Text="Kill All: "..(KillAll and "ON" or "OFF"); notify(btnKillAll.Text) end)
    posY = posY + 38
    local btnPosition = createBtn("Position: Front", posY, miscPage)
    btnPosition.MouseButton1Click:Connect(function() PositionMode=PositionMode=="Front" and "Behind" or "Front"; btnPosition.Text="Position: "..PositionMode; notify(btnPosition.Text) end)
    posY = posY + 38
    local btnAutoFire = createBtn("Auto Fire: OFF", posY, miscPage)
    local autoFireConn
    local function startAF() if autoFireConn then return end; autoFireConn = RunService.RenderStepped:Connect(function() if AutoFire and player.Character and player.Character:FindFirstChildOfClass("Tool") then local t=player.Character:FindFirstChildOfClass("Tool"); if t and t:FindFirstChild("Handle") then t:Activate() end end end) end
    local function stopAF() if autoFireConn then autoFireConn:Disconnect(); autoFireConn=nil end end
    btnAutoFire.MouseButton1Click:Connect(function() AutoFire=not AutoFire; btnAutoFire.Text="Auto Fire: "..(AutoFire and "ON" or "OFF"); notify(btnAutoFire.Text); if AutoFire then startAF() else stopAF() end end)

    -- Page Navigation
    local btnBack = Instance.new("TextButton", frame)
    btnBack.Size = UDim2.new(0, 40, 0, 30); btnBack.Position=UDim2.new(0,10,1,-40); btnBack.Text="<"; btnBack.Font=Enum.Font.GothamBlack; btnBack.TextScaled=true; btnBack.BackgroundColor3=Color3.fromRGB(35,35,35); btnBack.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", btnBack).CornerRadius=UDim.new(0,8)
    local btnNext = Instance.new("TextButton", frame)
    btnNext.Size = UDim2.new(0, 40, 0, 30); btnNext.Position=UDim2.new(1,-50,1,-40); btnNext.Text=">"; btnNext.Font=Enum.Font.GothamBlack; btnNext.TextScaled=true; btnNext.BackgroundColor3=Color3.fromRGB(35,35,35); btnNext.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", btnNext).CornerRadius=UDim.new(0,8)
    local function showPage(n) for i,p in ipairs(pages) do p.Visible=(i==n) end; currentPage=n; btnBack.Visible=(currentPage>1); btnNext.Visible=(currentPage<#pages) end
    btnBack.MouseButton1Click:Connect(function() if currentPage>1 then showPage(currentPage-1); notify("Page: "..currentPage) end end)
    btnNext.MouseButton1Click:Connect(function() if currentPage<#pages then showPage(currentPage+1); notify("Page: "..currentPage) end end)
    showPage(1)

    -- Rainbow UI effect
    RunService.RenderStepped:Connect(function()
        local c = Color3.fromHSV(tick()%5/5,1,1)
        stroke.Color = c
        title.TextColor3 = c
        toggleBtn.TextColor3 = c
    end)
end

-- Start Key Prompt
promptKey()
