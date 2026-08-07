local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

local XION = {
    Deep     = Color3.fromHex("#002B00"),
    Mid      = Color3.fromHex("#0A5C0A"),
    Main     = Color3.fromHex("#1B9B1B"),
    Bright   = Color3.fromHex("#4ADE80"),
    Glow     = Color3.fromHex("#22C55E"),
    Light    = Color3.fromHex("#90EE90"),
    Soft     = Color3.fromHex("#BBF7D0"),
    Accent   = Color3.fromHex("#00FFAA"),
    Pale     = Color3.fromHex("#86EFAC"),
    DarkBg   = Color3.fromHex("#05140A"),
    White    = Color3.fromHex("#FFFFFF"),
}

local MarketplaceService = game:GetService("MarketplaceService")

local function getPlaceName()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    return (ok and info and info.Name) or game.Name
end
local placeName = getPlaceName()

function gradient3(text, color1, color2, color3)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r, g, b
        if t < 0.5 then
            local s = t * 2
            r = color1.R + (color2.R - color1.R) * s
            g = color1.G + (color2.G - color1.G) * s
            b = color1.B + (color2.B - color1.B) * s
        else
            local s = (t - 0.5) * 2
            r = color2.R + (color3.R - color2.R) * s
            g = color2.G + (color3.G - color2.G) * s
            b = color2.B + (color3.B - color2.B) * s
        end
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>',
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient3("XION脚本", XION.Deep, XION.Bright, XION.Light),
    Author = gradient3("司空制作", XION.Accent, XION.Main, XION.Bright),
    Icon = "https://raw.githubusercontent.com/TypingSP/XION/main/1786044777935.png",
    IconThemed = false,
    Folder = "XION",
    Size = UDim2.fromOffset(580, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 160,
    HideSearchBar = false,
    ScrollBarEnabled = true,
})

Window:Tag({
    Title = placeName,
    Radius = 5,
    Color = XION.Main,
})

Window:EditOpenButton({
    Title = "XION",
    Icon = "https://raw.githubusercontent.com/TypingSP/XION/main/1786044777935.png",
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   XION.Deep),
        ColorSequenceKeypoint.new(0.25, XION.Main),
        ColorSequenceKeypoint.new(0.5,  XION.Bright),
        ColorSequenceKeypoint.new(0.75, XION.Light),
        ColorSequenceKeypoint.new(1,   XION.Deep),
    }),
    Glow = true,
    GlowColor = XION.Glow,
    GlowTransparency = 0.35,
    Draggable = true,
})

task.spawn(function()
    repeat task.wait() until Window.OpenButtonMain and Window.OpenButtonMain.Button
    local btn = Window.OpenButtonMain.Button

    local textLabel = btn:FindFirstChildWhichIsA("TextLabel")
    if textLabel then
        textLabel.TextColor3 = XION.Bright
        textLabel.TextStrokeTransparency = 0.7
        textLabel.TextStrokeColor3 = XION.Deep
    end

    local icon = btn:FindFirstChildWhichIsA("ImageLabel")
    if icon then
        icon.ImageColor3 = XION.Bright
    end
end)

local borderEnabled = true
local COLOR_SCHEMES = {
    ["XION"] = {
        type = "gradient",
        colors = {
            ColorSequenceKeypoint.new(0,   XION.Deep),
            ColorSequenceKeypoint.new(0.2, XION.Mid),
            ColorSequenceKeypoint.new(0.4, XION.Bright),
            ColorSequenceKeypoint.new(0.6, XION.Light),
            ColorSequenceKeypoint.new(0.8, XION.Accent),
            ColorSequenceKeypoint.new(1,   XION.Deep),
        }
    }
}
local currentColorScheme = "XION"

local function ensureBlurElement()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then return end
    local blur = mainFrame:FindFirstChild("Blur")
    if not blur then
        blur = Instance.new("ImageLabel")
        blur.Name = "Blur"
        blur.Size = UDim2.new(1, 0, 1, 0)
        blur.BackgroundTransparency = 1
        blur.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        blur.ImageTransparency = 0.15
        blur.ZIndex = 0
        blur.Parent = mainFrame
    end
    return blur
end

local function getColorSequenceForScheme(scheme)
    local data = COLOR_SCHEMES[scheme]
    if data.type == "gradient" then
        return data.colors
    end
    return ColorSequence.new(XION.Main)
end

local function applyBorderColor(c, colorSeq, e)
    e = e or 0.15
    local f = c.UIElements and c.UIElements.Main or c.Frame or c.Gui or c
    if not f then return false end
    local g = f:FindFirstChild("Blur", true)
    if g and g:IsA("ImageLabel") then
        g.ImageColor3 = XION.Main
        g.ImageTransparency = e
        local existingGrad = g:FindFirstChild("XIONBorderGrad")
        if not existingGrad then
            existingGrad = Instance.new("UIGradient")
            existingGrad.Name = "XIONBorderGrad"
            existingGrad.Color = ColorSequence.new(colorSeq)
            existingGrad.Rotation = 0
            existingGrad.Parent = g
        else
            existingGrad.Color = ColorSequence.new(colorSeq)
        end
        return true
    end
    local h = f:FindFirstChild("Shadow", true)
    if h and h:IsA("ImageLabel") then
        h.ImageColor3 = XION.Main
        h.ImageTransparency = e
        return true
    end
    return false
end

local borderConnection = nil
local borderRotation = 0

local function startBorderAnimation()
    if borderConnection then
        borderConnection:Disconnect()
        borderConnection = nil
    end
    if not borderEnabled then return end
    ensureBlurElement()
    borderConnection = game:GetService("RunService").Heartbeat:Connect(function(delta)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if not mainFrame or not mainFrame.Visible then return end
        borderRotation = (borderRotation + 25 * delta) % 360
        local colorSeq = getColorSequenceForScheme(currentColorScheme)
        applyBorderColor(Window, colorSeq, 0.15)
        local blur = mainFrame:FindFirstChild("Blur", true)
        if blur then
            local grad = blur:FindFirstChild("XIONBorderGrad")
            if grad then
                grad.Rotation = borderRotation
            end
        end
    end)
end

local function stopBorderAnimation()
    if borderConnection then
        borderConnection:Disconnect()
        borderConnection = nil
    end
end

local function setupVisibilityListener()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then
        task.spawn(function()
            repeat task.wait() until Window.UIElements and Window.UIElements.Main
            setupVisibilityListener()
        end)
        return
    end
    if mainFrame.Visible and borderEnabled then
        startBorderAnimation()
    elseif not mainFrame.Visible then
        stopBorderAnimation()
    end
    mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        if mainFrame.Visible and borderEnabled then
            startBorderAnimation()
        else
            stopBorderAnimation()
        end
    end)
end

setupVisibilityListener()
Window:OnClose(function()
    stopBorderAnimation()
end)

task.spawn(function()
    repeat task.wait() until Window.UIElements and Window.UIElements.Main
    local mainContainer = Window.UIElements.Main
    if mainContainer then
        local stroke = Instance.new("UIStroke")
        stroke.Name = "XIONStroke"
        stroke.Thickness = 2
        stroke.Color = XION.Main
        stroke.Transparency = 0.3
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = mainContainer

        local gradientElement = Instance.new("UIGradient")
        gradientElement.Name = "XIONGradient"
        gradientElement.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   XION.Deep),
            ColorSequenceKeypoint.new(0.17, XION.Main),
            ColorSequenceKeypoint.new(0.33, XION.Bright),
            ColorSequenceKeypoint.new(0.5,  XION.Light),
            ColorSequenceKeypoint.new(0.67, XION.Accent),
            ColorSequenceKeypoint.new(0.83, XION.Soft),
            ColorSequenceKeypoint.new(1,   XION.Deep),
        })
        gradientElement.Parent = stroke

        task.spawn(function()
            while mainContainer and mainContainer.Parent do
                task.wait(0.05)
                gradientElement.Rotation = (gradientElement.Rotation + 1.5) % 360
            end
        end)
    end
end)

task.spawn(function()
    repeat task.wait() until Window.OpenButtonMain and Window.OpenButtonMain.Button
    local button = Window.OpenButtonMain.Button
    local stroke = button:FindFirstChildWhichIsA("UIStroke")
    if not stroke then return end
    local grad = stroke:FindFirstChildWhichIsA("UIGradient")
    if not grad then return end

    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   XION.Deep),
        ColorSequenceKeypoint.new(0.2, XION.Main),
        ColorSequenceKeypoint.new(0.4, XION.Bright),
        ColorSequenceKeypoint.new(0.6, XION.Light),
        ColorSequenceKeypoint.new(0.8, XION.Accent),
        ColorSequenceKeypoint.new(1,   XION.Deep),
    })

    game:GetService("RunService").Heartbeat:Connect(function()
        if grad and grad.Parent then
            grad.Rotation = (tick() * 50) % 360
        end
    end)
end)

task.spawn(function()
    repeat task.wait() until Window.UIElements and Window.UIElements.Main
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end

    local topGlow = Instance.new("Frame")
    topGlow.Name = "TopGlow"
    topGlow.Size = UDim2.new(1, 0, 0.3, 0)
    topGlow.BackgroundTransparency = 1
    topGlow.ZIndex = 0
    topGlow.Parent = mainFrame

    local topGrad = Instance.new("UIGradient")
    topGrad.Color = ColorSequence.new(XION.Bright, XION.DarkBg)
    topGrad.Transparency = NumberSequence.new(0.75, 1)
    topGrad.Rotation = 90
    topGrad.Parent = topGlow

    local bottomGlow = Instance.new("Frame")
    bottomGlow.Name = "BottomGlow"
    bottomGlow.Size = UDim2.new(1, 0, 0.25, 0)
    bottomGlow.Position = UDim2.new(0, 0, 0.75, 0)
    bottomGlow.BackgroundTransparency = 1
    bottomGlow.ZIndex = 0
    bottomGlow.Parent = mainFrame

    local bottomGrad = Instance.new("UIGradient")
    bottomGrad.Color = ColorSequence.new(XION.DarkBg, XION.Bright)
    bottomGrad.Transparency = NumberSequence.new(1, 0.92)
    bottomGrad.Rotation = 90
    bottomGrad.Parent = bottomGlow
end)

local Tabs = {
    MainTab = Window:Tab({ Title = "主页" }),
    CombatTab = Window:Tab({ Title = "战斗" }),
}

local function GetInjectorInfo()
    local injectorName = "未知"
    if getexecutorname then
        injectorName = getexecutorname()
    elseif identifyexecutor then
        injectorName = identifyexecutor()
    end
    return injectorName
end

local function GetPlayerName()
    return game.Players.LocalPlayer.Name
end

local function GetServerId()
    local success, id = pcall(function()
        return game:GetService("TeleportService"):GetLocalServerId()
    end)
    if success and id and id ~= "" then
        return id
    end
    success, id = pcall(function()
        return game.JobId
    end)
    if success and id and id ~= "" then
        return id
    end
    return "未知"
end

local function GetServerRegion()
    local success, region = pcall(function()
        return game:GetService("TeleportService"):GetServerRegion()
    end)
    if success and region then
        return region
    end
    return "未知"
end

local function GetServerInfo()
    return string.format("服务器: %s | 区域: %s", GetServerId(), GetServerRegion())
end

Tabs.MainTab:Section({ Title = "玩家信息" })

local nameLabel = Tabs.MainTab:Paragraph({
    Title = "玩家名称:",
    Desc = GetPlayerName()
})

local injectorLabel = Tabs.MainTab:Paragraph({
    Title = "注入器:",
    Desc = GetInjectorInfo()
})

local serverLabel = Tabs.MainTab:Paragraph({
    Title = "服务器:",
    Desc = GetServerInfo()
})

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if nameLabel then nameLabel:SetDesc(GetPlayerName()) end
            if injectorLabel then injectorLabel:SetDesc(GetInjectorInfo()) end
            if serverLabel then serverLabel:SetDesc(GetServerInfo()) end
        end)
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Actions"):WaitForChild("Fire")
local ActiveZombies = Workspace:WaitForChild("ActiveZombies")
local AwaitingBosses = Workspace:WaitForChild("AwaitingBosses")

local autoKillEnabled = false
local autoKillThread = nil

local TRACER_COLOR = Color3.fromRGB(255, 255, 255)
local TRACER_THICKNESS = 0.05
local TRACER_DURATION = 0.1

local function CreateTracer(startPos, endPos)
    local distance = math.clamp((endPos - startPos).Magnitude, 0, 2000)
    local tracer = Instance.new("Part")
    tracer.Material = Enum.Material.Neon
    tracer.Color = TRACER_COLOR
    tracer.Transparency = 0.2
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.CanQuery = false
    tracer.Size = Vector3.new(TRACER_THICKNESS, TRACER_THICKNESS, distance)
    tracer.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
    tracer.Parent = Workspace.CurrentCamera
    Debris:AddItem(tracer, TRACER_DURATION)
end

local function GetTarget()
    local bossFolder = AwaitingBosses:FindFirstChild("Boss")
    if bossFolder then
        local bossModel = bossFolder:FindFirstChildWhichIsA("Model") or bossFolder:FindFirstChildWhichIsA("BasePart")
        if bossModel then
            local hitbox = bossModel:FindFirstChild("Head") or bossModel:FindFirstChild("HumanoidRootPart") or (bossModel:IsA("BasePart") and bossModel)
            if hitbox then return hitbox end
        end
    end
    for _, zombie in ipairs(ActiveZombies:GetChildren()) do
        local hitbox = zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart")
        if hitbox then return hitbox end
    end
    return nil
end

local function startAutoKill()
    if autoKillThread then return end
    autoKillEnabled = true
    autoKillThread = task.spawn(function()
        while autoKillEnabled do
            pcall(function()
                local Character = LocalPlayer.Character
                if Character then
                    local currentTool = Character:FindFirstChildWhichIsA("Tool")
                    if currentTool and currentTool:FindFirstChild("Exit") then
                        local weaponName = currentTool.Name
                        local muzzle = currentTool.Exit
                        local targetPart = GetTarget()
                        if targetPart then
                            local originPos = muzzle.Position
                            local targetPos = targetPart.Position
                            local direction = (targetPos - originPos).Unit
                            CreateTracer(originPos, targetPos)
                            Event:FireServer(
                                weaponName,
                                {{targetPart, targetPos, direction}},
                                {{weaponName, originPos, targetPos, targetPos, true, targetPart, false, false, "Default", muzzle}}
                            )
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function stopAutoKill()
    autoKillEnabled = false
    if autoKillThread then
        task.cancel(autoKillThread)
        autoKillThread = nil
    end
end

Tabs.CombatTab:Section({ Title = "战斗功能" })

Tabs.CombatTab:Toggle({
    Title = "自动秒杀",
    Value = false,
    Callback = function(state)
        if state then
            startAutoKill()
        else
            stopAutoKill()
        end
    end
})