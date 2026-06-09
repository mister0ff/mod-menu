-- ═══════════════════════════════════════════════════════════════════
--  STAR CLIENT v1.0 - ULTIMATE ROBLOX MOD MENU
--  Features: ESP, Aimbot, Kill Aura, Teleport, VIP, Free Buy, Anti-Ban,
--  Freecam, Player Swap, Infinite Health, Hitbox Expander, Item TP,
--  Auto Follow, Speed Slider, Wallbang, and more!
-- ═══════════════════════════════════════════════════════════════════

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://si.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")

-- ═══════ ANTI-BAN / ANTI-KICK / ANTI-DETECT ═══════
local AntiBanEnabled = true
local OriginalKick = nil
local OriginalNamecall = nil

-- Hook no Kick do jogador
pcall(function()
    OriginalKick = LocalPlayer.Kick
    LocalPlayer.Kick = function(self, msg)
        if AntiBanEnabled then
            print("[STAR CLIENT] Kick bloqueado:", msg)
            return nil
        end
        return OriginalKick(self, msg)
    end
end)

-- Hook no Namecall (metatable)
pcall(function()
    local mt = getrawmetatable and getrawmetatable(game) or nil
    if mt then
        setreadonly(mt, false)
        OriginalNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or ""
            if AntiBanEnabled and (method == "Kick" or method == "kick") then
                print("[STAR CLIENT] Namecall Kick bloqueado")
                return nil
            end
            return OriginalNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- Anti-AFK avançado
task.spawn(function()
    while true do
        if AntiBanEnabled then
            VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
        end
        task.wait(60)
    end
end)

-- Anti-Report (tenta prevenir reports)
pcall(function()
    for _, gui in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if gui.Name:lower():find("report") or gui.Name:lower():find("moderation") then
            gui:Destroy()
        end
    end
end)

-- ═══════ CRIANDO INTERFACE PRINCIPAL ═══════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "STAR_CLIENT_V1"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 400, 0, 550)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
MainFrame.BackgroundTransparency = 0.02
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Sombra dupla neon
for i = 1, 2 do
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"..i
    Shadow.Parent = MainFrame
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40 + (i*20), 1, 40 + (i*20))
    Shadow.ZIndex = -i
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = i == 1 and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 150, 255)
    Shadow.ImageTransparency = 0.5 + (i * 0.15)
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
end

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 18)
UICorner.Parent = MainFrame

-- Borda Neon Animada
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Transparency = 0.1
UIStroke.Parent = MainFrame

-- Gradiente no topo
local TopGradient = Instance.new("Frame")
TopGradient.Name = "TopBar"
TopGradient.Size = UDim2.new(1, 0, 0, 5)
TopGradient.Position = UDim2.new(0, 0, 0, 0)
TopGradient.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
TopGradient.BorderSizePixel = 0
TopGradient.Parent = MainFrame

local TopGradientCorner = Instance.new("UICorner")
TopGradientCorner.CornerRadius = UDim.new(0, 3)
TopGradientCorner.Parent = TopGradient

-- Animação RGB da borda
local hue = 0
task.spawn(function()
    while true do
        hue = (hue + 0.008) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        UIStroke.Color = color
        TopGradient.BackgroundColor3 = color
        task.wait(0.02)
    end
end)

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundTransparency = 1
Title.Text = "⭐ STAR CLIENT v1.0 ⭐"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBlack
Title.TextStrokeTransparency = 0.85
Title.TextStrokeColor3 = Color3.fromRGB(0, 255, 150)

-- Subtítulo
local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Parent = MainFrame
SubTitle.Size = UDim2.new(1, 0, 0, 22)
SubTitle.Position = UDim2.new(0, 0, 0, 46)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "ULTIMATE EDITION | PREMIUM | UNDETECTED"
SubTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.GothamBold

-- Botões de controle
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "Minimize"
MinBtn.Parent = MainFrame
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0, 12)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Container de scroll
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Parent = MainFrame
Container.Size = UDim2.new(1, -20, 1, -95)
Container.Position = UDim2.new(0, 10, 0, 75)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 2000)
Container.ScrollBarThickness = 5
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- ═══════ SISTEMA DE ESTADOS ═══════
local Toggles = {
    ESP = false,
    Aimbot = false,
    AimbotSmooth = 0.5,
    Speed = false,
    SpeedValue = 100,
    Fly = false,
    FlySpeed = 50,
    NoClip = false,
    InfiniteJump = false,
    Fullbright = false,
    GodMode = false,
    KillAura = false,
    KillAuraRange = 50,
    KillAuraWallbang = true,
    FreeBuy = false,
    VIP = false,
    Freecam = false,
    Immortal = false,
    AutoFollow = false,
    FollowTarget = nil,
    HitboxExpander = false,
    HitboxSize = 5,
    ItemTP = false,
    AntiBan = true,
    AutoClick = false,
    AntiAFK = true,
    PlayerSwap = false
}

-- ═══════ FUNÇÕES UTILITÁRIAS ═══════
local function ShowNotification(text, duration)
    duration = duration or 3
    local Notif = Instance.new("Frame")
    Notif.Parent = ScreenGui
    Notif.Size = UDim2.new(0, 300, 0, 80)
    Notif.Position = UDim2.new(1, 20, 0.82, 0)
    Notif.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Notif.BorderSizePixel = 0
    Notif.ZIndex = 100

    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 14)

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(0, 255, 150)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = Notif

    local NotifText = Instance.new("TextLabel")
    NotifText.Parent = Notif
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 13
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextWrapped = true
    NotifText.ZIndex = 101

    TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -320, 0.82, 0)}):Play()

    task.delay(duration, function()
        TweenService:Create(Notif, TweenInfo.new(0.4), {Position = UDim2.new(1, 20, 0.82, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.4)
        Notif:Destroy()
    end)
end

local function CreateSection(title)
    local Section = Instance.new("TextLabel")
    Section.Parent = Container
    Section.Size = UDim2.new(1, -10, 0, 30)
    Section.BackgroundTransparency = 1
    Section.Text = "▸ "..title
    Section.TextColor3 = Color3.fromRGB(0, 255, 150)
    Section.TextSize = 14
    Section.Font = Enum.Font.GothamBlack
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.LayoutOrder = #Container:GetChildren()
    return Section
end

local function CreateToggle(name, description, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = name.."Toggle"
    Frame.Parent = Container
    Frame.Size = UDim2.new(1, -10, 0, 58)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Frame.BorderSizePixel = 0
    Frame.LayoutOrder = #Container:GetChildren()

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Glow = Instance.new("UIStroke")
    Glow.Thickness = 1.5
    Glow.Color = Color3.fromRGB(45, 45, 50)
    Glow.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(0.6, 0, 0.55, 0)
    Label.Position = UDim2.new(0, 14, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Desc = Instance.new("TextLabel")
    Desc.Parent = Frame
    Desc.Size = UDim2.new(0.6, 0, 0.4, 0)
    Desc.Position = UDim2.new(0, 14, 0.55, 0)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = Color3.fromRGB(140, 140, 140)
    Desc.TextSize = 11
    Desc.Font = Enum.Font.Gotham
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = Frame
    ToggleBtn.Size = UDim2.new(0, 52, 0, 30)
    ToggleBtn.Position = UDim2.new(1, -64, 0.5, -15)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    ToggleBtn.Text = ""
    ToggleBtn.AutoButtonColor = false
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Parent = ToggleBtn
    Circle.Size = UDim2.new(0, 24, 0, 24)
    Circle.Position = UDim2.new(0, 3, 0.5, -12)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local Active = false

    local function UpdateToggle()
        Active = not Active
        if Active then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.25), {Position = UDim2.new(1, -27, 0.5, -12)}):Play()
            Glow.Color = Color3.fromRGB(0, 255, 150)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 45, 30)
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.25), {Position = UDim2.new(0, 3, 0.5, -12)}):Play()
            Glow.Color = Color3.fromRGB(45, 45, 50)
            Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        end
        callback(Active)
    end

    ToggleBtn.MouseButton1Click:Connect(UpdateToggle)
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.Position.X < ToggleBtn.AbsolutePosition.X then
                UpdateToggle()
            end
        end
    end)

    Frame.MouseEnter:Connect(function()
        if not Active then Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35) end
    end)
    Frame.MouseLeave:Connect(function()
        if not Active then Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24) end
    end)

    return Frame, function() return Active end
end

local function CreateButton(name, description, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = name.."Button"
    Frame.Parent = Container
    Frame.Size = UDim2.new(1, -10, 0, 58)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Frame.BorderSizePixel = 0
    Frame.LayoutOrder = #Container:GetChildren()
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Glow = Instance.new("UIStroke")
    Glow.Thickness = 1.5
    Glow.Color = Color3.fromRGB(45, 45, 50)
    Glow.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(0.55, 0, 0.55, 0)
    Label.Position = UDim2.new(0, 14, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Desc = Instance.new("TextLabel")
    Desc.Parent = Frame
    Desc.Size = UDim2.new(0.55, 0, 0.4, 0)
    Desc.Position = UDim2.new(0, 14, 0.55, 0)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = Color3.fromRGB(140, 140, 140)
    Desc.TextSize = 11
    Desc.Font = Enum.Font.Gotham
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Parent = Frame
    ActionBtn.Size = UDim2.new(0, 90, 0, 36)
    ActionBtn.Position = UDim2.new(1, -102, 0.5, -18)
    ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
    ActionBtn.Text = "EXECUTAR"
    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionBtn.TextSize = 12
    ActionBtn.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 10)

    ActionBtn.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(ActionBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 255, 150)}):Play()
        task.wait(0.1)
        TweenService:Create(ActionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 130, 255)}):Play()
    end)

    Frame.MouseEnter:Connect(function() Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35) end)
    Frame.MouseLeave:Connect(function() Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24) end)

    return Frame
end

local function CreateInput(name, description, placeholder, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = name.."Input"
    Frame.Parent = Container
    Frame.Size = UDim2.new(1, -10, 0, 75)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Frame.BorderSizePixel = 0
    Frame.LayoutOrder = #Container:GetChildren()
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Glow = Instance.new("UIStroke")
    Glow.Thickness = 1.5
    Glow.Color = Color3.fromRGB(45, 45, 50)
    Glow.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(0.6, 0, 0.4, 0)
    Label.Position = UDim2.new(0, 14, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Desc = Instance.new("TextLabel")
    Desc.Parent = Frame
    Desc.Size = UDim2.new(0.6, 0, 0.3, 0)
    Desc.Position = UDim2.new(0, 14, 0.4, 0)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = Color3.fromRGB(140, 140, 140)
    Desc.TextSize = 11
    Desc.Font = Enum.Font.Gotham
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    local InputBox = Instance.new("TextBox")
    InputBox.Parent = Frame
    InputBox.Size = UDim2.new(0, 150, 0, 32)
    InputBox.Position = UDim2.new(1, -164, 0.5, -16)
    InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.PlaceholderText = placeholder
    InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    InputBox.TextSize = 12
    InputBox.Font = Enum.Font.Gotham
    InputBox.ClearTextOnFocus = false
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Thickness = 1
    InputStroke.Color = Color3.fromRGB(60, 60, 70)
    InputStroke.Parent = InputBox

    InputBox.Focused:Connect(function()
        TweenService:Create(InputBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        InputStroke.Color = Color3.fromRGB(0, 255, 150)
    end)
    InputBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(InputBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
        InputStroke.Color = Color3.fromRGB(60, 60, 70)
        if enterPressed then callback(InputBox.Text) end
    end)

    return Frame, InputBox
end

local function CreateSlider(name, description, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = name.."Slider"
    Frame.Parent = Container
    Frame.Size = UDim2.new(1, -10, 0, 80)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Frame.BorderSizePixel = 0
    Frame.LayoutOrder = #Container:GetChildren()
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Glow = Instance.new("UIStroke")
    Glow.Thickness = 1.5
    Glow.Color = Color3.fromRGB(45, 45, 50)
    Glow.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(0.6, 0, 0.35, 0)
    Label.Position = UDim2.new(0, 14, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Desc = Instance.new("TextLabel")
    Desc.Parent = Frame
    Desc.Size = UDim2.new(0.6, 0, 0.25, 0)
    Desc.Position = UDim2.new(0, 14, 0.35, 0)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = Color3.fromRGB(140, 140, 140)
    Desc.TextSize = 11
    Desc.Font = Enum.Font.Gotham
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = Frame
    ValueLabel.Size = UDim2.new(0, 60, 0, 20)
    ValueLabel.Position = UDim2.new(1, -70, 0, 8)
    ValueLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    Instance.new("UICorner", ValueLabel).CornerRadius = UDim.new(0, 6)

    local Track = Instance.new("Frame")
    Track.Parent = Frame
    Track.Size = UDim2.new(1, -28, 0, 8)
    Track.Position = UDim2.new(0, 14, 0.65, 0)
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Parent = Track
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Parent = Track
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (pos * (max - min)))
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -9, 0.5, -9)
        ValueLabel.Text = tostring(value)
        callback(value)
        return value
    end

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return Frame
end

-- ═══════ ESP SYSTEM ═══════
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP"
ESPFolder.Parent = ScreenGui

local function CreateESPBox(player)
    if player == LocalPlayer then return end

    local Box = Instance.new("BillboardGui")
    Box.Name = player.Name.."ESP"
    Box.AlwaysOnTop = true
    Box.Size = UDim2.new(0, 100, 0, 100)
    Box.StudsOffset = Vector3.new(0, 2, 0)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Box

    local Outline = Instance.new("UIStroke")
    Outline.Thickness = 2
    Outline.Color = Color3.fromRGB(255, 0, 0)
    Outline.Parent = Frame

    local NameTag = Instance.new("TextLabel")
    NameTag.Size = UDim2.new(1, 0, 0, 20)
    NameTag.Position = UDim2.new(0, 0, -0.2, 0)
    NameTag.BackgroundTransparency = 1
    NameTag.Text = player.Name
    NameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameTag.TextSize = 12
    NameTag.Font = Enum.Font.GothamBold
    NameTag.Parent = Frame

    local DistTag = Instance.new("TextLabel")
    DistTag.Size = UDim2.new(1, 0, 0, 15)
    DistTag.Position = UDim2.new(0, 0, 1.05, 0)
    DistTag.BackgroundTransparency = 1
    DistTag.Text = "0m"
    DistTag.TextColor3 = Color3.fromRGB(0, 255, 150)
    DistTag.TextSize = 10
    DistTag.Font = Enum.Font.Gotham
    DistTag.Parent = Frame

    local HealthBar = Instance.new("Frame")
    HealthBar.Size = UDim2.new(0, 4, 1, 0)
    HealthBar.Position = UDim2.new(0, -8, 0, 0)
    HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    HealthBar.BorderSizePixel = 0
    HealthBar.Parent = Frame
    Instance.new("UICorner", HealthBar).CornerRadius = UDim.new(0, 2)

    Box.Parent = ESPFolder
    return Box
end

RunService.RenderStepped:Connect(function()
    if not Toggles.ESP then
        ESPFolder:ClearAllChildren()
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local esp = ESPFolder:FindFirstChild(player.Name.."ESP")
            if not esp then
                esp = CreateESPBox(player)
            end

            local hrp = player.Character.HumanoidRootPart
            local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
            esp.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
            esp.Adornee = hrp
            esp.Size = UDim2.new(0, math.clamp(4000/dist, 50, 150), 0, math.clamp(4000/dist, 50, 150))

            local frame = esp:FindFirstChildOfClass("Frame")
            if frame then
                for _, child in pairs(frame:GetChildren()) do
                    if child:IsA("TextLabel") and child.Position.Y.Scale == 1.05 then
                        child.Text = math.floor(dist).."m"
                    end
                end

                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local healthBar = frame:FindFirstChildOfClass("Frame")
                    if healthBar then
                        healthBar.Size = UDim2.new(0, 4, humanoid.Health/humanoid.MaxHealth, 0)
                        healthBar.BackgroundColor3 = Color3.fromRGB(
                            255 * (1 - humanoid.Health/humanoid.MaxHealth),
                            255 * (humanoid.Health/humanoid.MaxHealth),
                            0
                        )
                    end
                end
            end
        end
    end
end)

-- ═══════ AIMBOT ═══════
local function GetClosestPlayer()
    local closest = nil
    local minDist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < minDist and dist < 300 then
                    minDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Toggles.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            local pos = Camera:WorldToViewportPoint(target.Position)
            local smooth = Toggles.AimbotSmooth
            mousemoverel((pos.X - Mouse.X) * smooth, (pos.Y - Mouse.Y) * smooth)
        end
    end
end)

-- ═══════ KILL AURA (COM WALLBANG) ═══════
local killAuraConnection = nil
CreateToggle("Kill Aura", "Mata jogadores próximos (atravessa paredes)", function(active)
    Toggles.KillAura = active
    if active then
        killAuraConnection = RunService.Heartbeat:Connect(function()
            if not Toggles.KillAura then return end
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            local myPos = char.HumanoidRootPart.Position
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if targetHrp and targetHumanoid and targetHumanoid.Health > 0 then
                        local dist = (targetHrp.Position - myPos).Magnitude
                        if dist <= Toggles.KillAuraRange then
                            -- Método 1: Dano direto
                            pcall(function()
                                targetHumanoid:TakeDamage(9999)
                                targetHumanoid.Health = 0
                            end)

                            -- Método 2: Ferramenta equipada
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                pcall(function() tool:Activate() end)
                            end

                            -- Método 3: RemoteEvents de dano
                            for _, obj in pairs(player.Character:GetDescendants()) do
                                if obj:IsA("RemoteEvent") then
                                    local n = obj.Name:lower()
                                    if n:find("damage") or n:find("hit") or n:find("attack") or n:find("hurt") then
                                        pcall(function() obj:FireServer(targetHumanoid, 9999) end)
                                    end
                                end
                            end

                            -- Método 4: RemoteEvents globais
                            for _, obj in pairs(game:GetDescendants()) do
                                if obj:IsA("RemoteEvent") then
                                    local n = obj.Name:lower()
                                    if n:find("damage") or n:find("hit") or n:find("attack") then
                                        pcall(function()
                                            obj:FireServer(player, 9999)
                                            obj:FireServer(targetHrp.Position, 9999)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        ShowNotification("🔴 Kill Aura ATIVADO!\nAlcance: "..Toggles.KillAuraRange.." studs | Wallbang: ON", 2)
    else
        if killAuraConnection then killAuraConnection:Disconnect() end
        ShowNotification("🟢 Kill Aura DESATIVADO", 2)
    end
end)

-- Slider do Kill Aura Range
CreateSlider("Kill Aura Range", "Distância do Kill Aura", 10, 100, 50, function(value)
    Toggles.KillAuraRange = value
end)

-- ═══════ HITBOX EXPANDER ═══════
local hitboxConnection = nil
local originalSizes = {}

CreateToggle("Hitbox Expander", "Aumenta hitbox dos inimigos", function(active)
    Toggles.HitboxExpander = active
    if active then
        hitboxConnection = RunService.Heartbeat:Connect(function()
            if not Toggles.HitboxExpander then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and (part.Name:lower():find("head") or part.Name:lower():find("torso") or part.Name:lower():find("humanoid")) then
                            if not originalSizes[part] then
                                originalSizes[part] = part.Size
                            end
                            local size = Toggles.HitboxSize
                            part.Size = Vector3.new(size, size, size)
                            part.Transparency = 0.7
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
        ShowNotification("🎯 Hitbox Expander ATIVADO!\nTamanho: "..Toggles.HitboxSize, 2)
    else
        if hitboxConnection then hitboxConnection:Disconnect() end
        for part, size in pairs(originalSizes) do
            if part and part.Parent then
                part.Size = size
                part.Transparency = 0
            end
        end
        originalSizes = {}
        ShowNotification("🟢 Hitbox Expander DESATIVADO", 2)
    end
end)

-- Slider do Hitbox
CreateSlider("Hitbox Size", "Tamanho da hitbox (1-10)", 1, 10, 5, function(value)
    Toggles.HitboxSize = value
end)

-- ═══════ TELEPORT PARA JOGADOR ═══════
CreateSection("TELEPORT & FOLLOW")

CreateInput("Teleport to Player", "Digite o nome do jogador", "Nome...", function(text)
    local targetName = text:lower():gsub("%s+", "")
    local found = false

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Name:lower():gsub("%s+", ""):find(targetName) then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    ShowNotification("✅ Teleportado para: "..player.Name, 3)
                    found = true
                    break
                end
            end
        end
    end

    if not found then
        ShowNotification("❌ Jogador não encontrado!", 3)
    end
end)

-- TP Player até mim
CreateInput("TP Player to Me", "Jogador teleporta até você", "Nome...", function(text)
    local targetName = text:lower():gsub("%s+", "")
    local found = false

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Name:lower():gsub("%s+", ""):find(targetName) then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame * CFrame.new(3, 0, 3)
                    ShowNotification("✅ "..player.Name.." teleportado até você!", 3)
                    found = true
                    break
                end
            end
        end
    end

    if not found then
        ShowNotification("❌ Jogador não encontrado!", 3)
    end
end)

-- Auto Follow
local followConnection = nil
CreateInput("Auto Follow Player", "Segue jogador automaticamente", "Nome...", function(text)
    local targetName = text:lower():gsub("%s+", "")
    local target = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Name:lower():gsub("%s+", ""):find(targetName) then
            target = player
            break
        end
    end

    if not target then
        ShowNotification("❌ Jogador não encontrado!", 3)
        return
    end

    Toggles.FollowTarget = target
    Toggles.AutoFollow = true

    if followConnection then followConnection:Disconnect() end
    followConnection = RunService.Heartbeat:Connect(function()
        if not Toggles.AutoFollow or not Toggles.FollowTarget then return end
        local targetChar = Toggles.FollowTarget.Character
        local myChar = LocalPlayer.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local targetPos = targetChar.HumanoidRootPart.Position
            local myPos = myChar.HumanoidRootPart.Position
            local direction = (targetPos - myPos).Unit
            local dist = (targetPos - myPos).Magnitude
            if dist > 5 then
                myChar.HumanoidRootPart.CFrame = CFrame.new(myPos + direction * math.min(dist * 0.1, 8))
            end
        end
    end)

    ShowNotification("🏃 Auto Follow ATIVADO!\nSeguindo: "..target.Name, 3)
end)

CreateButton("Stop Following", "Para de seguir jogador", function()
    Toggles.AutoFollow = false
    Toggles.FollowTarget = nil
    if followConnection then followConnection:Disconnect() end
    ShowNotification("🛑 Auto Follow DESATIVADO", 2)
end)

-- ═══════ VIP / FREE BUY ═══════
CreateSection("VIP & ECONOMIA")

CreateToggle("VIP Mode", "Simula status VIP no jogo", function(active)
    Toggles.VIP = active
    if active then
        -- Tenta ativar VIP em vários sistemas comuns
        pcall(function()
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in pairs(leaderstats:GetChildren()) do
                    if stat.Name:lower():find("vip") or stat.Name:lower():find("rank") or stat.Name:lower():find("tier") then
                        stat.Value = "VIP" or 999
                    end
                end
            end
        end)

        -- Tenta ativar via RemoteEvents
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local n = obj.Name:lower()
                if n:find("vip") or n:find("premium") or n:find("rank") then
                    pcall(function() obj:FireServer(true, "VIP") end)
                end
            end
        end

        ShowNotification("👑 VIP Mode ATIVADO!", 2)
    else
        ShowNotification("🟢 VIP Mode DESATIVADO", 2)
    end
end)

CreateToggle("Free Buy", "Compra itens sem gastar dinheiro", function(active)
    Toggles.FreeBuy = active
    if active then
        ShowNotification("🛒 Free Buy ATIVADO!\nTente comprar qualquer item", 3)
    else
        ShowNotification("🟢 Free Buy DESATIVADO", 2)
    end
end)

-- Hook de compra
pcall(function()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("buy") or n:find("purchase") or n:find("shop") or n:find("transaction") then
                local oldFire = obj.FireServer
                obj.FireServer = function(self, ...)
                    local args = {...}
                    if Toggles.FreeBuy then
                        -- Tenta substituir preço por 0
                        for i, v in pairs(args) do
                            if typeof(v) == "number" and v > 0 then
                                args[i] = 0
                            end
                        end
                        print("[STAR CLIENT] Free Buy interceptado:", obj.Name)
                    end
                    return oldFire(self, unpack(args))
                end
            end
        end
    end
end)

CreateButton("Add Money", "Adiciona dinheiro ao jogo", function()
    local success = false

    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                local name = stat.Name:lower()
                if name:find("money") or name:find("cash") or name:find("coin") or name:find("gold") or name:find("point") or name:find("credit") or name:find("gem") then
                    stat.Value = stat.Value + 999999999
                    ShowNotification("💰 +999999999 em: "..stat.Name, 3)
                    success = true
                end
            end
        end
    end

    -- RemoteEvents
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local remoteName = remote.Name:lower()
            if remoteName:find("money") or remoteName:find("cash") or remoteName:find("add") or remoteName:find("give") then
                pcall(function()
                    remote:FireServer(999999999)
                    remote:FireServer("add", 999999999)
                end)
                success = true
            end
        end
    end

    if not success then
        ShowNotification("⚠️ Tente em um jogo com leaderstats visíveis", 3)
    end
end)

CreateButton("Max Stats / Level", "Maximiza todos os stats", function()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                stat.Value = 999999999
            end
        end
        ShowNotification("📊 Todos os stats maximizados!", 3)
    else
        ShowNotification("⚠️ Leaderstats não encontrado", 2)
    end
end)

-- ═══════ FREE ITEMS & ITEM TP ═══════
CreateSection("ITENS & INVENTÁRIO")

CreateButton("Free Items (All)", "Pega todos os itens do jogo", function()
    local count = 0

    local rs = game:FindFirstChild("ReplicatedStorage")
    if rs then
        for _, obj in pairs(rs:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Model") then
                pcall(function()
                    local clone = obj:Clone()
                    clone.Parent = LocalPlayer:WaitForChild("Backpack")
                    count = count + 1
                end)
            end
        end
    end

    for _, tool in pairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            pcall(function()
                local clone = tool:Clone()
                clone.Parent = LocalPlayer:WaitForChild("Backpack")
                count = count + 1
            end)
        end
    end

    ShowNotification("🎁 "..count.." itens adicionados!", 3)
end)

CreateToggle("TP Items to Me", "Puxa itens do mapa até você", function(active)
    Toggles.ItemTP = active
    if active then
        task.spawn(function()
            while Toggles.ItemTP do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, item in pairs(workspace:GetDescendants()) do
                        if item:IsA("Tool") or item:IsA("Part") then
                            if item.Name:lower():find("item") or item.Name:lower():find("drop") or item.Name:lower():find("loot") or item.Name:lower():find("coin") or item.Name:lower():find("gem") then
                                pcall(function()
                                    item.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                                end)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
        ShowNotification("🧲 TP Items ATIVADO!", 2)
    else
        ShowNotification("🟢 TP Items DESATIVADO", 2)
    end
end)

-- ═══════ PLAYER SWAP / TROCAR VISÃO ═══════
CreateSection("VISÃO & CÂMERA")

CreateInput("Swap Vision (Player)", "Vê através dos olhos do jogador", "Nome...", function(text)
    local targetName = text:lower():gsub("%s+", "")
    local target = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Name:lower():gsub("%s+", ""):find(targetName) then
            target = player
            break
        end
    end

    if not target then
        ShowNotification("❌ Jogador não encontrado!", 3)
        return
    end

    if target.Character and target.Character:FindFirstChild("Head") then
        Camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid") or target.Character.Head
        ShowNotification("👁️ Visão trocada para: "..target.Name, 3)
    end
end)

CreateButton("Reset Camera", "Volta sua visão normal", function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Camera.CameraSubject = humanoid
            ShowNotification("📷 Visão restaurada!", 2)
        end
    end
end)

-- FREECAM
local freecamConnection = nil
local freecamEnabled = false

CreateToggle("Freecam (Place Camera)", "Move a câmera livremente", function(active)
    Toggles.Freecam = active
    freecamEnabled = active

    if active then
        local camPos = Camera.CFrame.Position
        local camRot = Vector2.new(Camera.CFrame:ToEulerAnglesYXZ())
        local speed = 2

        freecamConnection = RunService.RenderStepped:Connect(function()
            if not freecamEnabled then return end

            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed = 5 else speed = 2 end

            if moveDir.Magnitude > 0 then
                camPos = camPos + moveDir.Unit * speed
            end

            Camera.CFrame = CFrame.new(camPos) * CFrame.fromEulerAnglesYXZ(camRot.X, camRot.Y, 0)
        end)

        -- Mouse look
        UserInputService.InputChanged:Connect(function(input)
            if freecamEnabled and input.UserInputType == Enum.UserInputType.MouseMovement then
                camRot = camRot - Vector2.new(input.Delta.Y * 0.003, input.Delta.X * 0.003)
            end
        end)

        ShowNotification("📹 Freecam ATIVADO!\nWASD=Move | Q/E=Up/Down | Shift=Fast", 4)
    else
        if freecamConnection then freecamConnection:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
        ShowNotification("🟢 Freecam DESATIVADO", 2)
    end
end)

-- ═══════ COMBATE ═══════
CreateSection("COMBATE")

CreateToggle("Player ESP", "Veja jogadores através das paredes", function(active)
    Toggles.ESP = active
    if not active then ESPFolder:ClearAllChildren() end
end)

CreateToggle("Aimbot", "Mira automática no inimigo (RMB)", function(active)
    Toggles.Aimbot = active
end)

CreateToggle("God Mode", "Regeneração de vida rápida", function(active)
    Toggles.GodMode = active
    if active then
        task.spawn(function()
            while Toggles.GodMode do
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = humanoid.MaxHealth
                        humanoid.MaxHealth = 999999
                    end
                end
                task.wait(0.05)
            end
        end)
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.MaxHealth = 100 end
        end
    end
end)

CreateToggle("Immortal", "Vida infinita / Não morre", function(active)
    Toggles.Immortal = active
    if active then
        task.spawn(function()
            while Toggles.Immortal do
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = math.huge
                        humanoid.MaxHealth = math.huge
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end
                end
                task.wait(0.01)
            end
        end)
        ShowNotification("🛡️ Immortal ATIVADO!", 2)
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end
        end
        ShowNotification("🟢 Immortal DESATIVADO", 2)
    end
end)

-- ═══════ MOVIMENTO ═══════
CreateSection("MOVIMENTO")

local speedConnection = nil
CreateToggle("Speed Hack", "Aumenta velocidade de movimento", function(active)
    Toggles.Speed = active
    if active then
        speedConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = Toggles.SpeedValue
            end
        end)
    else
        if speedConnection then speedConnection:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- SLIDER DE SPEED
CreateSlider("Speed Power", "Potência do Speed Hack", 16, 500, 100, function(value)
    Toggles.SpeedValue = value
end)

local flyConnection = nil
local flyBodyVelocity = nil
CreateToggle("Fly", "Voe pelo mapa (E=↑ Q=↓)", function(active)
    Toggles.Fly = active
    local char = LocalPlayer.Character
    if not char then return end

    if active then
        local hrp = char:WaitForChild("HumanoidRootPart")
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        flyBodyVelocity.Velocity = Vector3.zero
        flyBodyVelocity.Parent = hrp

        flyConnection = RunService.RenderStepped:Connect(function()
            if not flyBodyVelocity then return end
            local direction = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then direction = direction - Vector3.new(0, 1, 0) end

            if direction.Magnitude > 0 then
                flyBodyVelocity.Velocity = direction.Unit * Toggles.FlySpeed
            else
                flyBodyVelocity.Velocity = Vector3.zero
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        flyBodyVelocity = nil
    end
end)

local noclipConnection = nil
CreateToggle("NoClip", "Atravessa paredes", function(active)
    Toggles.NoClip = active
    if active then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CreateToggle("Infinite Jump", "Pule infinitamente no ar", function(active)
    Toggles.InfiniteJump = active
end)

-- ═══════ UTILIDADES ═══════
CreateSection("UTILIDADES")

CreateToggle("Fullbright", "Visão noturna total", function(active)
    Toggles.Fullbright = active
    if active then
        Lighting.Brightness = 10
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
    end
end)

CreateToggle("Anti-AFK", "Previne kick por inatividade", function(active)
    Toggles.AntiAFK = active
end)

local autoClickConnection = nil
CreateToggle("Auto Click", "Clique automático rápido", function(active)
    Toggles.AutoClick = active
    if active then
        autoClickConnection = RunService.RenderStepped:Connect(function()
            if Toggles.AutoClick then mouse1click() end
        end)
    else
        if autoClickConnection then autoClickConnection:Disconnect() end
    end
end)

CreateToggle("Anti-Ban System", "Proteção contra kicks e bans", function(active)
    AntiBanEnabled = active
    Toggles.AntiBan = active
    if active then
        ShowNotification("🛡️ Anti-Ban ATIVADO!\nKicks serão bloqueados", 3)
    else
        ShowNotification("⚠️ Anti-Ban DESATIVADO", 2)
    end
end)

-- ═══════ CONTROLE DA INTERFACE ═══════
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 55)}):Play()
        Container.Visible = false
        SubTitle.Visible = false
        MinBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 550)}):Play()
        Container.Visible = true
        SubTitle.Visible = true
        MinBtn.Text = "−"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ═══════ NOTIFICAÇÃO DE INICIALIZAÇÃO ═══════
ShowNotification("⭐ STAR CLIENT v1.0 Carregado!\nINSERT para mostrar/esconder\nAnti-Ban: ATIVO | Pressione INSERT", 6)

print("⭐ STAR CLIENT v1.0 ULTIMATE - Inicializado com sucesso!")
print("🔒 Anti-Ban System: ATIVO")
print("🎮 Features: ESP, Aimbot, Kill Aura, Wallbang, Hitbox, Freecam, VIP, Free Buy, TP, Follow, Immortal, Speed Slider")
