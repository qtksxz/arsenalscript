--[[ 

  === DinoHub Arsenal 🦖 | ARSENAL ===
  Version: 2.0.0.0.0.0.0.7
  ===== DinoHub Arsenal 🦖'S TEAM =====

--]]

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

-- Interactive Load Notification
local function showLoadNotification()
    local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
    ScreenGui.Name = "DinoHubLoadNotification"
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 400, 0, 200)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Text = "✅ DinoHub Arsenal 🦖 Loaded"
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1

    local Desc = Instance.new("TextLabel", Frame)
    Desc.Size = UDim2.new(1, -20, 0, 70)
    Desc.Position = UDim2.new(0, 10, 0, 50)
    Desc.Text = "Thank you for using DinoHub Arsenal! Join the Discord server for updates and support."
    Desc.TextWrapped = true
    Desc.TextScaled = true
    Desc.Font = Enum.Font.Gotham
    Desc.TextColor3 = Color3.fromRGB(255, 255, 255)
    Desc.BackgroundTransparency = 1

    local BtnDiscord = Instance.new("TextButton", Frame)
    BtnDiscord.Size = UDim2.new(0, 160, 0, 40)
    BtnDiscord.Position = UDim2.new(0.5, -170, 1, -50)
    BtnDiscord.Text = "Copy Discord Link"
    BtnDiscord.Font = Enum.Font.GothamBold
    BtnDiscord.TextScaled = true
    BtnDiscord.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BtnDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", BtnDiscord).CornerRadius = UDim.new(0, 8)

    local BtnOkay = Instance.new("TextButton", Frame)
    BtnOkay.Size = UDim2.new(0, 160, 0, 40)
    BtnOkay.Position = UDim2.new(0.5, 10, 1, -50)
    BtnOkay.Text = "Okay"
    BtnOkay.Font = Enum.Font.GothamBold
    BtnOkay.TextScaled = true
    BtnOkay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BtnOkay.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", BtnOkay).CornerRadius = UDim.new(0, 8)

    BtnDiscord.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/6fzsWdRyKX")
        notify("✅ Discord invite copied!")
    end)

    BtnOkay.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    task.delay(10, function()
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy()
        end
    end)
end

showLoadNotification()
notify("✅ DinoHub Arsenal 🦖 Loaded")

-- GUI Initialization
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DinoHub Arsenal 🦖 | SKIBIDI TOLIET | Arsenal"
gui.ResetOnSpawn = false

-- Frame
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

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ARSENAL | DinoHub Arsenal 🦖"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0.6

-- Toggle Button
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

-- [Rest of your full DinoHub Arsenal script continues here exactly as you provided, including Pages, Buttons, Aimbot, ESP, Misc, AutoFire, etc.]
