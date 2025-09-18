
-- DinoHub Key System + DinoHub Arsenal 🦖
local DinoHubKeySystem = {}

function DinoHubKeySystem:LoadKeySystem()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local StarterGui = game:GetService("StarterGui")

    local KEY = "dinohub"

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DinoHubKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = screenGui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -20, 0, 50)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Text = "DinoHub Key System 🦖"
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold

    local keyBox = Instance.new("TextBox", frame)
    keyBox.Size = UDim2.new(1, -40, 0, 50)
    keyBox.Position = UDim2.new(0, 20, 0, 80)
    keyBox.PlaceholderText = "Enter Key..."
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.new(1,1,1)
    keyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
    keyBox.Font = Enum.Font.Gotham
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 10)

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.Size = UDim2.new(0, 120, 0, 50)
    submitBtn.Position = UDim2.new(0.5, -60, 1, -60)
    submitBtn.Text = "Submit"
    submitBtn.TextColor3 = Color3.new(1,1,1)
    submitBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    submitBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 10)

    local function notify(txt)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "DinoHub 🦖",
                Text = txt,
                Duration = 5
            })
        end)
    end

    submitBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == KEY then
            screenGui:Destroy()
            notify("✅ Key Correct! Loading DinoHub Arsenal 🦖")
            
            -- =========================
            -- LOAD DINOHUB ARSENAL GUI
            -- =========================
            local RunService = game:GetService("RunService")
            local Camera = workspace.CurrentCamera
            local Mouse = player:GetMouse()
            local MIN_Y_COORDINATE = -50 

            local function getRainbow(t)
                local f = 2
                return Color3.fromRGB(
                    math.floor(math.sin(f*t+0)*127+128),
                    math.floor(math.sin(f*t+2)*127+128),
                    math.floor(math.sin(f*t+4)*127+128)
                )
            end

            notify("✅ DinoHub Arsenal 🦖 Loaded")

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
            title.Text = "ARSENAL | DinoHub Arsenal 🦖"
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
            -- CREATE SECTIONS AND BUTTONS
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
            -- PAGE & FEATURE VARIABLES
            -- =========================
            local Aimbot, Smooth, Wall, ESP, ESPTeam, ShowName, SafeMode, KillAll, AutoFire = false, false, false, false, false, false, false, false, false
            local TargetPart, parts, partIdx = "Head", {"Head", "UpperTorso", "Torso"}, 1
            local ESPMode = "Highlight"
            local ESPColor = Color3.new(1,1,1)
            local Rainbow = false
            local KillAllIndex = 1
            local safemodew = 10
            local PositionMode = "Front"
            local pages = {}
            local currentPage = 1

            local aimbotPage = Instance.new("Frame")
            aimbotPage.Name = "AimbotPage"
            aimbotPage.Size = UDim2.new(1, 0, 1, -36)
            aimbotPage.Position = UDim2.new(0, 0, 0, 36)
            aimbotPage.BackgroundTransparency = 1
            aimbotPage.Parent = frame
            pages[1] = aimbotPage

            local espPage = Instance.new("Frame")
            espPage.Name = "ESPPage"
            espPage.Size = UDim2.new(1, 0, 1, -36)
            espPage.Position = UDim2.new(0, 0, 0, 36)
            espPage.BackgroundTransparency = 1
            espPage.Parent = frame
            espPage.Visible = false
            pages[2] = espPage

            local miscPage = Instance.new("Frame")
            miscPage.Name = "MiscPage"
            miscPage.Size = UDim2.new(1, 0, 1, -36)
            miscPage.Position = UDim2.new(0, 0, 0, 36)
            miscPage.BackgroundTransparency = 1
            miscPage.Parent = frame
            miscPage.Visible = false
            pages[3] = miscPage

            -- =========================
            -- ADD BUTTONS (EXAMPLE)
            -- =========================
            local posY_Aimbot = 5
            createSectionTitle("Aimbot Setting:", posY_Aimbot, aimbotPage)
            posY_Aimbot = posY_Aimbot + 30

            local btnAimbot = createBtn("Aimbot: OFF", posY_Aimbot, aimbotPage)
            btnAimbot.MouseButton1Click:Connect(function()
                Aimbot = not Aimbot
                btnAimbot.Text = "Aimbot: " .. (Aimbot and "ON" or "OFF")
                notify(btnAimbot.Text)
            end)

            -- You can continue adding all other buttons and features from your Arsenal script here
            -- (ESP, Misc, KillAll, AutoFire, etc.)
            
        else
            notify("❌ Wrong Key! Join DISCORD SERVER to get the key")
            setclipboard("https://discord.gg/jb9WctzJd5")
        end
    end)
end

-- Execute the key system
DinoHubKeySystem:LoadKeySystem()
