-- หากต้องการปิดสคริปให้พิม . ที่ด้านล่าง หากต้องการกลับมาใช้ได้ลบ . ออก --..

local Players =
game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Client = Players.LocalPlayer

local PlayerGui = Client:WaitForChild("PlayerGui")
local Connections = {}

local ConfigFileName = "TestHub_Config.json"
local DefaultConfig = {
    WalkSpeed = false,
    SpeedMultiplier = 1,
    JumpPower = false,
    InfStamina = false,
    AntiDead = false,
    AntiLock = false,
    AntiRagdoll = false,
    AntiAutoSit = false,
    HideName = false,
    AutoRespawn = false,
    Snap = false,
    SnapAmount = 10,
    FlyCar = false,
    FlyCarSpeed = 30,
    CarRamAura = false,
    CarSnap = false,
    ShowFOV = false,
    MultiShoot = false,
    FireRateGun = 850,   
    RecoilGun = 0,      
    AccuracyGun = 100,   
    AutomaticGun = false,  
    AimMode = "โหมดยิงเซฟ",
    FOVRadius = 150,
    SkeletonPlayerVisual = false,
    HealthPlayerVisual = false,
    NamePlayerVisual = false,
    DistancePlayerVisual = false,
    InventoryPlayerVisual = false,
    FireRateValue = 850,
    SettingsApplied = false,
    HoldFire = false,
    NoRecoilAccuracy = false,
}

local function LoadConfig()
    local cfg = {}
    for k, v in pairs(DefaultConfig) do cfg[k] = v end
    pcall(function()
        if isfile and readfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            if type(decoded) == "table" then
                for k, v in pairs(decoded) do cfg[k] = v end
            end
        end
    end)
    return cfg
end

getgenv().TestHubConfig = LoadConfig()
local function c() return getgenv().TestHubConfig end

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(c()))
        end
    end)
end

local Done = false

local function pressButton(guiObject)
    if not guiObject then return end
    pcall(function() guiObject:Activate() end)
    pcall(function() firesignal(guiObject.MouseButton1Click) end)
    pcall(function() firesignal(guiObject.Activated) end)
end

local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local Network
pcall(function()
    Network = require(ReplicatedStorage.Modules.Core.Net)
end)

local function checkInMenu()
    local splashScreenGui = PlayerGui:FindFirstChild("SplashScreenGui")
    if splashScreenGui and splashScreenGui.Enabled then
        local frame = splashScreenGui:FindFirstChild("Frame")
        local playButton = frame and frame:FindFirstChild("PlayButton")
        if playButton and playButton.Visible then
            return true
        end
    end
    return Client:GetAttribute("InMenuCharacterCreator") or false
end

local function ApplySalmonBypass()
    if getgenv then getgenv().identifyexecutor = nil end
    if getfenv then getfenv().identifyexecutor = nil end

    local Net = require(ReplicatedStorage.Modules.Core.Net)
    local getFunc = debug.getupvalue or getupvalue
    local setConst = debug.setconstant or setconstant

    if getFunc and setConst and not _G.SalmonBypassed then
        local func = getFunc(Net.get, 2)
        if type(func) == "function" then
            pcall(function()
                setConst(func, 3, "Bypass")
                setConst(func, 4, "Bypass")
            end)
        end
        _G.SalmonBypassed = true
    end
end

if checkInMenu() then
    local FONT = Enum.Font.GothamBold

    local blurEffect = Instance.new("DepthOfFieldEffect")
    blurEffect.Name = "TestHub_DOF"
    blurEffect.FarIntensity = 1.2
    blurEffect.FocusDistance = 2
    blurEffect.InFocusRadius = 1
    blurEffect.Parent = Lighting

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TestHub_Entry"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    local main = Instance.new("CanvasGroup")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 330, 0, 172)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0
    uiScale.Parent = main

    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://103857318083299"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageTransparency = 0.1
    bgImage.ZIndex = 1
    bgImage.Parent = main
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 17)

    local softVignette = Instance.new("Frame")
    softVignette.Size = UDim2.new(1, 0, 1, 0)
    softVignette.BackgroundTransparency = 0.75
    softVignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    softVignette.BorderSizePixel = 0
    softVignette.ZIndex = 1
    softVignette.Parent = main
    Instance.new("UICorner", softVignette).CornerRadius = UDim.new(0, 14)

    local borderFrame = Instance.new("Frame")
    borderFrame.Size = UDim2.new(1, -6, 1, -6)
    borderFrame.Position = UDim2.new(0, 3, 0, 3)
    borderFrame.BackgroundTransparency = 1
    borderFrame.ZIndex = 10
    borderFrame.Parent = main
    Instance.new("UICorner", borderFrame).CornerRadius = UDim.new(0, 14)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 4
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Parent = borderFrame

    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(140, 140, 145)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 40))
    })
    strokeGradient.Rotation = 50
    strokeGradient.Parent = mainStroke

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 32)
    title.Position = UDim2.new(0, 0, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = "Sultaniqz"
    title.Font = FONT
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(245, 245, 250)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 2
    title.Parent = main

    local function createModeButton(txt, yPos, isGodMode)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 285, 0, 44)
        btn.AnchorPoint = Vector2.new(0.5, 0.5)
        btn.Position = UDim2.new(0.5, 0, 0, yPos + 22)
        btn.Font = FONT
        btn.TextSize = 14
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = txt
        btn.AutoButtonColor = false
        btn.ZIndex = 2
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        btn.BackgroundTransparency = 0.72
        btn.Parent = main

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Thickness = 1
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btnStroke.Parent = btn

        if isGodMode then
            btnStroke.Color = Color3.fromRGB(255, 255, 255)
            btnStroke.Transparency = 0.4
            local btnGradient = Instance.new("UIGradient")
            btnGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 95))
            })
            btnGradient.Rotation = 45
            btnGradient.Parent = btnStroke
        else
            btnStroke.Color = Color3.fromRGB(200, 200, 210)
            btnStroke.Transparency = 0.68
        end

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 295, 0, 48),
                BackgroundTransparency = 0.5
            }):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 285, 0, 44),
                BackgroundTransparency = 0.72
            }):Play()
        end)

        return btn
    end

    local normalBtn = createModeButton("โหมดปกติ", 60, false)
    local godBtn    = createModeButton("โหมดพระเจ้า", 112, true)

    task.delay(0.2, function()
        TweenService:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)

    local function destroyUI()
        TweenService:Create(uiScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0 }):Play()
        if blurEffect then
            TweenService:Create(blurEffect, TweenInfo.new(0.25), { FarIntensity = 0 }):Play()
            task.delay(0.25, function() blurEffect:Destroy() end)
        end
        task.wait(0.3)
        screenGui:Destroy()
    end

    local function StartFlow(isGodMode)
        destroyUI()
        task.spawn(function()
            local Net = require(ReplicatedStorage.Modules.Core.Net)
            ApplySalmonBypass()

            if isGodMode then
                local oldSend
                oldSend = hookfunction(Net.send, function(...)
                    local d = {...}
                    if d[1] == "leave_character_creato
