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
    FuncTab = Window:Tab({ Title = "功能" }),
    ItemTab = Window:Tab({ Title = "物品ESP" }),
    EnemyTab = Window:Tab({ Title = "员工ESP" }),
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

local TeleportLocations = {
    ["超市外"] = CFrame.new(306.80, 36.46, -525.27),
    ["电力室"] = CFrame.new(545.36, 37.37, 45.07),
    ["经理"] = nil
}
local savedPos = nil
local currentLoc = "超市外"

local function getManagerCFrame()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, v in ipairs(enemies:GetDescendants()) do
        if v:IsA("Model") and v.Name == "Manager" then
            local pp = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if pp then return pp.CFrame end
        end
    end
    return nil
end

Tabs.FuncTab:Section({ Title = "传送" })

Tabs.FuncTab:Dropdown({
    Title = "选择传送地点",
    Values = {"超市外", "电力室", "经理"},
    Default = "超市外",
    Callback = function(v)
        currentLoc = v
    end
})

Tabs.FuncTab:Button({
    Title = "传送到选定地点",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local c = lp.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local target = TeleportLocations[currentLoc]
        if currentLoc == "经理" then
            target = getManagerCFrame()
            if not target then return end
        end
        if not target then return end
        savedPos = hrp.CFrame
        hrp.CFrame = target
    end
})

Tabs.FuncTab:Button({
    Title = "返回原位置",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local c = lp.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if savedPos then
            hrp.CFrame = savedPos
            savedPos = nil
        end
    end
})

local ItemConfig = {
    ["Pistol"] = {chs = "手枪", color = Color3.fromRGB(255, 60, 60)},
    ["Katana"] = {chs = "武士刀", color = Color3.fromRGB(255, 60, 60)},
    ["BasicFlashlight_Standard"] = {chs = "手电筒", color = Color3.fromRGB(255, 60, 60)},
    ["Hotdog"] = {chs = "热狗", color = Color3.fromRGB(60, 255, 120)},
    ["Ham"] = {chs = "火腿", color = Color3.fromRGB(60, 255, 120)},
    ["Cola"] = {chs = "可乐", color = Color3.fromRGB(60, 255, 120)},
    ["Cake"] = {chs = "蛋糕", color = Color3.fromRGB(60, 255, 120)},
    ["Burger"] = {chs = "汉堡", color = Color3.fromRGB(60, 255, 120)},
    ["RedCube"] = {chs = "红方块", color = Color3.fromRGB(70, 160, 255)},
    ["GreenCube"] = {chs = "绿方块", color = Color3.fromRGB(70, 160, 255)},
    ["BlueCube"] = {chs = "蓝方块", color = Color3.fromRGB(70, 160, 255)},
    ["Plank"] = {chs = "木板", color = Color3.fromRGB(70, 160, 255)},
    ["Metal"] = {chs = "金属块", color = Color3.fromRGB(70, 160, 255)},
    ["Cloth"] = {chs = "布料", color = Color3.fromRGB(70, 160, 255)},
    ["AmmoShotgunBasic"] = {chs = "霰弹枪弹药", color = Color3.fromRGB(255, 230, 60)},
    ["AmmoPistolBasic"] = {chs = "手枪弹药", color = Color3.fromRGB(255, 230, 60)},
    ["AmmoARBasic"] = {chs = "步枪弹药", color = Color3.fromRGB(255, 230, 60)},
    ["Bandage"] = {chs = "绷带", color = Color3.fromRGB(255, 255, 255)}
}

local SelectedItems = {}
local ESPEnabled = false

local function CreateItemESP(obj)
    if not (obj:IsA("BasePart") or obj:IsA("Model")) then return end
    local root = obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") and obj.Parent or obj
    local cfg = ItemConfig[root.Name]
    if not cfg or not SelectedItems[root.Name] then return end
    if root:FindFirstChild("ESP_HL") then return end
    
    local adornee = root.PrimaryPart or root:FindFirstChildWhichIsA("BasePart")
    if not adornee then return end
    
    local hl = Instance.new("Highlight", root)
    hl.Name = "ESP_HL"
    hl.Adornee = root
    hl.FillColor = cfg.color
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.7
    hl.OutlineTransparency = 0.15
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local bb = Instance.new("BillboardGui", root)
    bb.Name = "ESP_TAG"
    bb.Adornee = adornee
    bb.Size = UDim2.new(0, 110, 0, 18)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 600
    
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = cfg.chs
    lbl.TextColor3 = cfg.color
    lbl.TextStrokeTransparency = 0.3
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
end

local function ClearItemESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "ESP_HL" or v.Name == "ESP_TAG" then
            v:Destroy()
        end
    end
end

local function ScanItemESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        pcall(CreateItemESP, v)
    end
    workspace.DescendantAdded:Connect(function(v)
        if ESPEnabled then
            task.wait(0.05)
            pcall(CreateItemESP, v)
        end
    end)
end

Tabs.ItemTab:Section({ Title = "物品ESP" })

Tabs.ItemTab:Toggle({
    Title = "开启物品ESP",
    Value = false,
    Callback = function(v)
        ESPEnabled = v
        if v then
            ClearItemESP()
            ScanItemESP()
        else
            ClearItemESP()
        end
    end
})

local Categories = {
    {title = "武器", keys = {"Pistol", "Katana", "BasicFlashlight_Standard"}},
    {title = "食物", keys = {"Hotdog", "Ham", "Cola", "Cake", "Burger"}},
    {title = "材料", keys = {"RedCube", "GreenCube", "BlueCube", "Plank", "Metal", "Cloth"}},
    {title = "弹药", keys = {"AmmoShotgunBasic", "AmmoPistolBasic", "AmmoARBasic"}},
    {title = "医疗", keys = {"Bandage"}}
}

for _, cat in ipairs(Categories) do
    Tabs.ItemTab:Section({ Title = cat.title })
    for _, k in ipairs(cat.keys) do
        Tabs.ItemTab:Toggle({
            Title = ItemConfig[k].chs,
            Value = false,
            Callback = function(s)
                SelectedItems[k] = s or nil
                if ESPEnabled then
                    ClearItemESP()
                    ScanItemESP()
                end
            end
        })
    end
end

Tabs.ItemTab:Button({
    Title = "传送到最近勾选物品",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local c = lp.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then return end
        local myPos = c.HumanoidRootPart.Position
        local nearest = nil
        local minDist = math.huge
        
        for _, v in ipairs(workspace:GetDescendants()) do
            local cfg = ItemConfig[v.Name]
            if cfg and SelectedItems[v.Name] then
                local p = (v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))) or (v:IsA("BasePart") and v)
                if p then
                    local d = (p.Position - myPos).Magnitude
                    if d < minDist then
                        minDist = d
                        nearest = p
                    end
                end
            end
        end
        
        if nearest then
            c.HumanoidRootPart.CFrame = nearest.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

local EnemyESP_Enabled = false
local EnemyNameMap = {
    ["BuffEmployee"] = "强化员工",
    ["Employee"] = "普通员工",
    ["Roach"] = "蟑螂",
    ["Manager"] = "经理"
}

local function CreateEnemyESP(obj)
    if not obj:IsA("Model") then return end
    local chs = EnemyNameMap[obj.Name]
    if not chs then return end
    if obj:FindFirstChild("ESP_HL") then return end
    
    local adornee = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    if not adornee then return end
    
    local fillColor = Color3.fromRGB(255, 50, 50)
    if obj.Name == "Roach" then
        fillColor = Color3.fromRGB(160, 100, 200)
    elseif obj.Name == "Manager" then
        fillColor = Color3.fromRGB(255, 165, 0)
    elseif obj.Name == "BuffEmployee" then
        fillColor = Color3.fromRGB(255, 50, 50)
    elseif obj.Name == "Employee" then
        fillColor = Color3.fromRGB(255, 120, 120)
    end
    
    local hl = Instance.new("Highlight", obj)
    hl.Name = "ESP_HL"
    hl.Adornee = obj
    hl.FillColor = fillColor
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.65
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local bb = Instance.new("BillboardGui", obj)
    bb.Name = "ESP_TAG"
    bb.Adornee = adornee
    bb.Size = UDim2.new(0, 120, 0, 18)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 600
    
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = chs
    lbl.TextColor3 = fillColor
    lbl.TextStrokeTransparency = 0.3
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
end

local function ClearEnemyESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "ESP_HL" or v.Name == "ESP_TAG" then
            local p = v.Parent
            if p and EnemyNameMap[p.Name] then
                v:Destroy()
            end
        end
    end
end

local function ScanEnemyESP()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end
    for _, v in ipairs(enemies:GetDescendants()) do
        pcall(CreateEnemyESP, v)
    end
    enemies.DescendantAdded:Connect(function(v)
        if EnemyESP_Enabled then
            task.wait(0.05)
            pcall(CreateEnemyESP, v)
        end
    end)
end

Tabs.EnemyTab:Section({ Title = "员工ESP" })

Tabs.EnemyTab:Toggle({
    Title = "开启员工ESP",
    Value = false,
    Callback = function(v)
        EnemyESP_Enabled = v
        if v then
            ClearEnemyESP()
            ScanEnemyESP()
        else
            ClearEnemyESP()
        end
    end
})