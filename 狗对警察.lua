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
    DogTab = Window:Tab({ Title = "狗功能" }),
    PoliceTab = Window:Tab({ Title = "警察功能" }),
    BoneTab = Window:Tab({ Title = "骨头" }),
    OtherTab = Window:Tab({ Title = "其他" }),
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
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local biteRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DogBiteEvent")
local currentTarget = nil
local lastBite = 0
local BITE_INTERVAL = 0.01
local OFFSET = Vector3.new(0, 0, 0.5)

local DOGS_TEAM_NAME = "Dogs"
local ESCAPED_TEAM_NAME = "Escaped"

local dogBiteEnabled = false
local dogBiteConnection = nil

local function isAllowedTeam()
    local team = LocalPlayer.Team
    if not team then return false end
    return team.Name == DOGS_TEAM_NAME or team.Name == ESCAPED_TEAM_NAME
end

local function isTargetValid(p)
    if p == LocalPlayer then return false end
    if not p.Team then return true end
    if p.Team == LocalPlayer.Team then return false end
    if p.Team.Name == DOGS_TEAM_NAME then return false end
    if p.Team.Name == ESCAPED_TEAM_NAME then return false end
    return true
end

local function pickNextTarget()
    for _, p in ipairs(Players:GetPlayers()) do
        if isTargetValid(p) then
            local char = p.Character
            if char then
                local h = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if h and root and h.Health > 0 then
                    return p
                end
            end
        end
    end
    return nil
end

local function startDogBite()
    if dogBiteConnection then return end
    dogBiteEnabled = true
    
    if not isAllowedTeam() then
        dogBiteEnabled = false
        return
    end
    
    currentTarget = pickNextTarget()
    
    dogBiteConnection = RunService.Heartbeat:Connect(function()
        if not dogBiteEnabled then return end
        if not isAllowedTeam() then
            dogBiteEnabled = false
            currentTarget = nil
            return
        end
        if not LocalPlayer.Character then return end
        if not currentTarget or not currentTarget.Character then
            currentTarget = pickNextTarget()
            return
        end
        if currentTarget and currentTarget.Character then
            local tRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
            local hum = currentTarget.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum then
                if hum.Health <= 0 then
                    currentTarget = pickNextTarget()
                    return
                end
                LocalPlayer.Character:PivotTo(tRoot.CFrame * CFrame.new(OFFSET))
                local now = tick()
                if now - lastBite >= BITE_INTERVAL then
                    pcall(function()
                        biteRemote:FireServer()
                    end)
                    lastBite = now
                end
            end
        end
    end)
end

local function stopDogBite()
    dogBiteEnabled = false
    if dogBiteConnection then
        dogBiteConnection:Disconnect()
        dogBiteConnection = nil
    end
    currentTarget = nil
end

Tabs.DogTab:Section({ Title = "狗功能" })

Tabs.DogTab:Toggle({
    Title = "疯狂撕咬警察",
    Value = false,
    Callback = function(state)
        if state then
            startDogBite()
        else
            stopDogBite()
        end
    end
})

local FireEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FireEvent")

local aimbotEnabled = false
local aimbotConnection = nil
local lastFire = 0
local fireRate = 0.1
local multiFireCount = 3
local soundId = "rbxassetid://6534948092"

local allowedWeapons = {
    ["Shotgun"] = true,
    ["AR"] = true,
    ["Heavy Sniper"] = true,
    ["Pistol"] = true,
}

local function playSound()
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 1
    sound.Parent = workspace
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function getWeapons()
    local char = LocalPlayer.Character
    if not char then return {} end
    local weapons = {}
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Tool") and allowedWeapons[v.Name] then
            table.insert(weapons, v)
        end
    end
    return weapons
end

local function getEnemies()
    local enemies = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                table.insert(enemies, root)
            end
        end
    end
    return enemies
end

local function startAimbot()
    if aimbotConnection then return end
    aimbotEnabled = true
    aimbotConnection = RunService.Heartbeat:Connect(function()
        if not aimbotEnabled then return end
        if tick() - lastFire < fireRate then return end
        lastFire = tick()
        
        local weapons = getWeapons()
        local enemies = getEnemies()
        if #weapons == 0 or #enemies == 0 then return end
        
        for _, root in ipairs(enemies) do
            local targetPos = root.Position
            for _, weapon in ipairs(weapons) do
                for i = 1, multiFireCount do
                    local args = {
                        "Fire",
                        weapon,
                        Vector3.new(targetPos.X, targetPos.Y, targetPos.Z)
                    }
                    pcall(function()
                        FireEvent:FireServer(unpack(args))
                        playSound()
                    end)
                end
            end
        end
    end)
end

local function stopAimbot()
    aimbotEnabled = false
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

local autoMedkitEnabled = false
local autoMedkitConnection = nil
local purchaseRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PurchaseItemRequest")

local function hasMedkit()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return false end
    for _, item in pairs(backpack:GetChildren()) do
        if item.Name == "Medkit" then
            return true
        end
    end
    return false
end

local function startAutoMedkit()
    if autoMedkitConnection then return end
    autoMedkitEnabled = true
    autoMedkitConnection = RunService.Heartbeat:Connect(function()
        if not autoMedkitEnabled then return end
        if not hasMedkit() then
            pcall(function()
                purchaseRemote:FireServer("Medkit")
                task.wait(0.01)
                purchaseRemote:FireServer("Medkit")
            end)
        end
    end)
end

local function stopAutoMedkit()
    autoMedkitEnabled = false
    if autoMedkitConnection then
        autoMedkitConnection:Disconnect()
        autoMedkitConnection = nil
    end
end

local leashEnabled = false
local leashConnection = nil
local leashIndex = 1
local TARGETS_PER_EXECUTION = 2

local function startLeash()
    if leashConnection then return end
    leashEnabled = true
    leashConnection = RunService.Stepped:Connect(function()
        if not leashEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not (tool and tool.Name:find("Leash")) then return end
        
        local playerList = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and (not player.Team or player.Team ~= LocalPlayer.Team) then
                table.insert(playerList, player)
            end
        end
        if #playerList == 0 then return end
        if leashIndex > #playerList then leashIndex = 1 end
        
        local targetsToHit = math.min(TARGETS_PER_EXECUTION, #playerList)
        for i = 1, targetsToHit do
            local target = playerList[leashIndex]
            if target and target.Character then
                pcall(function()
                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LeachEvent"):FireServer(target.Character)
                end)
            end
            leashIndex = leashIndex + 1
            if leashIndex > #playerList then leashIndex = 1 end
        end
        task.wait(0.01)
    end)
end

local function stopLeash()
    leashEnabled = false
    if leashConnection then
        leashConnection:Disconnect()
        leashConnection = nil
    end
    leashIndex = 1
end

local farmLeashEnabled = false
local farmLeashConnection = nil
local farmIndex = 1
local LockedPosition = nil

local function startFarmLeash()
    if farmLeashConnection then return end
    farmLeashEnabled = true
    farmLeashConnection = RunService.Stepped:Connect(function()
        if not farmLeashEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not (tool and tool.Name:find("Leash")) then
            LockedPosition = nil
            return
        end
        
        if not LockedPosition then
            LockedPosition = hrp.Position
        end
        hrp.CFrame = CFrame.new(LockedPosition)
        
        local playerList = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and (not player.Team or player.Team ~= LocalPlayer.Team) then
                table.insert(playerList, player)
            end
        end
        if #playerList == 0 then return end
        if farmIndex > #playerList then farmIndex = 1 end
        
        local target = playerList[farmIndex]
        if target and target.Character then
            pcall(function()
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LeachEvent"):FireServer(target.Character)
            end)
        end
        farmIndex = farmIndex + 1
        if farmIndex > #playerList then farmIndex = 1 end
        task.wait(0.1)
    end)
end

local function stopFarmLeash()
    farmLeashEnabled = false
    if farmLeashConnection then
        farmLeashConnection:Disconnect()
        farmLeashConnection = nil
    end
    farmIndex = 1
    LockedPosition = nil
end

local muzzleEnabled = false
local muzzleConnection = nil
local muzzleRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("MuzzleEvent")

local function startMuzzle()
    if muzzleConnection then return end
    muzzleEnabled = true
    muzzleConnection = RunService.Heartbeat:Connect(function()
        if not muzzleEnabled then return end
        local localTeam = LocalPlayer.Team
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team ~= localTeam then
                local char = player.Character or player:WaitForChild("Character", 3)
                if char then
                    pcall(function()
                        muzzleRemote:FireServer(char)
                    end)
                end
            end
        end
    end)
end

local function stopMuzzle()
    muzzleEnabled = false
    if muzzleConnection then
        muzzleConnection:Disconnect()
        muzzleConnection = nil
    end
end

local autoCageEnabled = false
local autoCageConnection = nil

local function startAutoCage()
    if autoCageConnection then return end
    autoCageEnabled = true
    
    local Leach = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LeachEvent")
    local Dog = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DogCageOrRelease")
    local cage = workspace:WaitForChild("DogCages"):WaitForChild("Cage1")
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if self == Leach and method == "FireServer" then
            task.defer(function()
                pcall(function()
                    Dog:FireServer(cage, true)
                end)
            end)
        end
        return oldNamecall(self, ...)
    end)
    
    autoCageConnection = {
        Disconnect = function()
            if oldNamecall then
                hookmetamethod(game, "__namecall", oldNamecall)
                oldNamecall = nil
            end
        end
    }
end

local function stopAutoCage()
    autoCageEnabled = false
    if autoCageConnection then
        autoCageConnection:Disconnect()
        autoCageConnection = nil
    end
end

Tabs.PoliceTab:Section({ Title = "武器功能" })

Tabs.PoliceTab:Toggle({
    Title = "愤怒机器人",
    Value = false,
    Callback = function(state)
        if state then
            startAimbot()
        else
            stopAimbot()
        end
    end
})

Tabs.PoliceTab:Section({ Title = "套狗功能" })

Tabs.PoliceTab:Toggle({
    Title = "安全套狗",
    Value = false,
    Callback = function(state)
        if state then
            startLeash()
        else
            stopLeash()
        end
    end
})

Tabs.PoliceTab:Toggle({
    Title = "疯狂套狗刷钱",
    Value = false,
    Callback = function(state)
        if state then
            startFarmLeash()
        else
            stopFarmLeash()
        end
    end
})

Tabs.PoliceTab:Section({ Title = "辅助功能" })

Tabs.PoliceTab:Toggle({
    Title = "拿起锁狗嘴自动锁",
    Value = false,
    Callback = function(state)
        if state then
            startMuzzle()
        else
            stopMuzzle()
        end
    end
})

Tabs.PoliceTab:Toggle({
    Title = "自动购买医疗箱",
    Value = false,
    Callback = function(state)
        if state then
            startAutoMedkit()
        else
            stopAutoMedkit()
        end
    end
})

Tabs.PoliceTab:Toggle({
    Title = "自动关狗",
    Value = false,
    Callback = function(state)
        if state then
            startAutoCage()
        else
            stopAutoCage()
        end
    end
})

Tabs.BoneTab:Section({ Title = "金骨头传送" })

local BonesFolder = workspace:WaitForChild("GoldenBones"):WaitForChild("Bones")
local BoneNames = {"bones1","bones2","bones3","bones4","bones5","bones6"}
local boneIdx = 1

Tabs.BoneTab:Button({
    Title = "传送到下一个金骨头",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local boneName = BoneNames[boneIdx]
        local m = BonesFolder:FindFirstChild(boneName)
        if m then
            hrp.CFrame = m:GetPivot() + Vector3.new(0, 3, 0)
        end
        boneIdx = (boneIdx % 6) + 1
    end
})

local autoBoneEnabled = false
local autoBoneConnection = nil
local autoBoneDelay = 1

local function startAutoBone()
    if autoBoneConnection then return end
    autoBoneEnabled = true
    autoBoneConnection = RunService.Heartbeat:Connect(function()
        if not autoBoneEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local boneName = BoneNames[boneIdx]
        local m = BonesFolder:FindFirstChild(boneName)
        if m then
            hrp.CFrame = m:GetPivot() + Vector3.new(0, 3, 0)
        end
        boneIdx = (boneIdx % 6) + 1
        task.wait(autoBoneDelay)
    end)
end

local function stopAutoBone()
    autoBoneEnabled = false
    if autoBoneConnection then
        autoBoneConnection:Disconnect()
        autoBoneConnection = nil
    end
    boneIdx = 1
end

Tabs.BoneTab:Toggle({
    Title = "自动传送金骨头",
    Value = false,
    Callback = function(state)
        if state then
            startAutoBone()
        else
            stopAutoBone()
        end
    end
})

local delayLabel = Tabs.BoneTab:Paragraph({
    Title = "金骨头当前延迟:",
    Desc = "1秒"
})

Tabs.BoneTab:Slider({
    Title = "金骨头传送延迟 (秒)",
    Value = { Min = 0.1, Max = 5, Default = 1 },
    Callback = function(value)
        autoBoneDelay = value
        if delayLabel then
            delayLabel:SetDesc(tostring(value) .. "秒")
        end
    end
})

Tabs.BoneTab:Section({ Title = "单独传送金骨头" })

for i, name in ipairs(BoneNames) do
    Tabs.BoneTab:Button({
        Title = "传送至 " .. name,
        Callback = function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local m = BonesFolder:FindFirstChild(name)
            if m then
                hrp.CFrame = m:GetPivot() + Vector3.new(0, 3, 0)
            end
        end
    })
end

Tabs.BoneTab:Section({ Title = "金骨头透视" })

local espEnabled = false
local espHighlights = {}

local function toggleESP(state)
    if state then
        for _, name in ipairs(BoneNames) do
            local m = BonesFolder:FindFirstChild(name)
            if m and not m:FindFirstChild("BoneHL") then
                local hl = Instance.new("Highlight")
                hl.Name = "BoneHL"
                hl.Adornee = m
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.3
                hl.OutlineTransparency = 0
                hl.Parent = m
                table.insert(espHighlights, hl)
            end
        end
    else
        for _, name in ipairs(BoneNames) do
            local m = BonesFolder:FindFirstChild(name)
            if m then
                local hl = m:FindFirstChild("BoneHL")
                if hl then 
                    hl:Destroy() 
                end
            end
        end
        espHighlights = {}
    end
end

Tabs.BoneTab:Toggle({
    Title = "金骨头透视",
    Value = false,
    Callback = function(state)
        espEnabled = state
        toggleESP(state)
    end
})

Tabs.BoneTab:Section({ Title = "白骨传送" })

local WhiteBonesFolder = workspace:WaitForChild("DogBoneQuest"):WaitForChild("Bones")
local WhiteBoneNames = {"bones1","bones2","bones3","bones4","bones5"}
local whiteBoneIdx = 1

Tabs.BoneTab:Button({
    Title = "传送到下一个白骨",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local boneName = WhiteBoneNames[whiteBoneIdx]
        local m = WhiteBonesFolder:FindFirstChild(boneName)
        if m then
            hrp.CFrame = m:GetPivot() + Vector3.new(0, 3, 0)
        end
        whiteBoneIdx = (whiteBoneIdx % 5) + 1
    end
})

local autoWhiteBoneEnabled = false
local autoWhiteBoneConnection = nil
local autoWhiteBoneDelay = 1

local function startAutoWhiteBone()
    if autoWhiteBoneConnection then return end
    autoWhiteBoneEnabled = true
    autoWhiteBoneConnection = RunService.Heartbeat:Connect(function()
        if not autoWhiteBoneEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local boneName = WhiteBoneNames[whiteBoneIdx]
        local m = WhiteBonesFolder:FindFirstChild(boneName)
        if m then
            hrp.CFrame = m:GetPivot() + Vector3.new(0, 3, 0)
        end
        whiteBoneIdx = (whiteBoneIdx % 5) + 1
        task.wait(autoWhiteBoneDelay)
    end)
end

local function stopAutoWhiteBone()
    autoWhiteBoneEnabled = false
    if autoWhiteBoneConnection then
        autoWhiteBoneConnection:Disconnect()
        autoWhiteBoneConnection = nil
    end
    whiteBoneIdx = 1
end

Tabs.BoneTab:Toggle({
    Title = "自动传送白骨",
    Value = false,
    Callback = function(state)
        if state then
            startAutoWhiteBone()
        else
            stopAutoWhiteBone()
        end
    end
})

local whiteDelayLabel = Tabs.BoneTab:Paragraph({
    Title = "白骨当前延迟:",
    Desc = "1秒"
})

Tabs.BoneTab:Slider({
    Title = "白骨传送延迟 (秒)",
    Value = { Min = 0.1, Max = 5, Default = 1 },
    Callback = function(value)
        autoWhiteBoneDelay = value
        if whiteDelayLabel then
            whiteDelayLabel:SetDesc(tostring(value) .. "秒")
        end
    end
})

Tabs.BoneTab:Section({ Title = "单独传送白骨" })

for i, name in ipairs(WhiteBoneNames) do
    Tabs.BoneTab:Button({
        Title = "传送至 " .. name,
        Callback = function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local m = WhiteBonesFolder:FindFirstChild(name)
            if m then
                hrp.CFrame = m:GetPivot() + Vector3.new(0, 3, 0)
            end
        end
    })
end

Tabs.BoneTab:Section({ Title = "白骨透视" })

local whiteEspEnabled = false
local whiteEspHighlights = {}

local function toggleWhiteESP(state)
    if state then
        for _, name in ipairs(WhiteBoneNames) do
            local m = WhiteBonesFolder:FindFirstChild(name)
            if m and not m:FindFirstChild("WhiteBoneHL") then
                local hl = Instance.new("Highlight")
                hl.Name = "WhiteBoneHL"
                hl.Adornee = m
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.3
                hl.OutlineTransparency = 0
                hl.Parent = m
                table.insert(whiteEspHighlights, hl)
            end
        end
    else
        for _, name in ipairs(WhiteBoneNames) do
            local m = WhiteBonesFolder:FindFirstChild(name)
            if m then
                local hl = m:FindFirstChild("WhiteBoneHL")
                if hl then 
                    hl:Destroy() 
                end
            end
        end
        whiteEspHighlights = {}
    end
end

Tabs.BoneTab:Toggle({
    Title = "白骨透视",
    Value = false,
    Callback = function(state)
        whiteEspEnabled = state
        toggleWhiteESP(state)
    end
})

Tabs.OtherTab:Section({ Title = "火箭筒功能" })

local safeModeEnabled = false
local safeModeConnection = nil
local safeModeFireRate = 0.6
local safeModeLastFire = 0

local function getNearestEnemy()
    local char = LocalPlayer.Character
    if not char then return nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local nearest = nil
    local minDist = math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (myRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = root
                end
            end
        end
    end
    return nearest
end

local function startSafeMode()
    if safeModeConnection then return end
    safeModeEnabled = true
    safeModeConnection = RunService.Heartbeat:Connect(function()
        if not safeModeEnabled then return end
        local now = tick()
        if now - safeModeLastFire < safeModeFireRate then return end
        safeModeLastFire = now
        local char = LocalPlayer.Character
        if not char then return end
        local Bazooka = char:FindFirstChild("Bazooka")
        if not Bazooka then return end
        local target = getNearestEnemy()
        if target then
            pcall(function()
                FireEvent:FireServer("Fire", Bazooka, target.Position)
            end)
        end
    end)
end

local function stopSafeMode()
    safeModeEnabled = false
    if safeModeConnection then
        safeModeConnection:Disconnect()
        safeModeConnection = nil
    end
end

local allModeEnabled = false
local allModeConnection = nil
local allModeFireRate = 0.03
local allModeLastFire = 0

local function getNearestPlayer()
    local character = LocalPlayer.Character
    if not character then return nil end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local nearestRoot = nil
    local minDistance = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local theirCharacter = player.Character
            local theirRoot = theirCharacter and theirCharacter:FindFirstChild("HumanoidRootPart")
            if theirRoot then
                local distance = (myRoot.Position - theirRoot.Position).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    nearestRoot = theirRoot
                end
            end
        end
    end
    return nearestRoot
end

local function startAllMode()
    if allModeConnection then return end
    allModeEnabled = true
    allModeConnection = RunService.Heartbeat:Connect(function()
        if not allModeEnabled then return end
        local now = tick()
        if now - allModeLastFire < allModeFireRate then return end
        allModeLastFire = now
        local character = LocalPlayer.Character
        if not character then return end
        local bazooka = character:FindFirstChild("Bazooka")
        if not bazooka then return end
        local target = getNearestPlayer()
        if target then
            pcall(function()
                FireEvent:FireServer("Fire", bazooka, target.Position)
            end)
        end
    end)
end

local function stopAllMode()
    allModeEnabled = false
    if allModeConnection then
        allModeConnection:Disconnect()
        allModeConnection = nil
    end
end

local selfDestructEnabled = false
local selfDestructConnection = nil
local selfDestructFireRate = 0.6
local selfDestructLastFire = 0

local function startSelfDestruct()
    if selfDestructConnection then return end
    selfDestructEnabled = true
    selfDestructConnection = RunService.Heartbeat:Connect(function()
        if not selfDestructEnabled then return end
        local now = tick()
        if now - selfDestructLastFire < selfDestructFireRate then return end
        selfDestructLastFire = now
        local char = LocalPlayer.Character
        if not char then return end
        local Bazooka = char:FindFirstChild("Bazooka")
        if not Bazooka then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    pcall(function()
                        FireEvent:FireServer("Fire", Bazooka, root.Position)
                    end)
                end
            end
        end
    end)
end

local function stopSelfDestruct()
    selfDestructEnabled = false
    if selfDestructConnection then
        selfDestructConnection:Disconnect()
        selfDestructConnection = nil
    end
end

Tabs.OtherTab:Toggle({
    Title = "火箭筒安全模式",
    Value = false,
    Callback = function(state)
        if state then
            startSafeMode()
        else
            stopSafeMode()
        end
    end
})

Tabs.OtherTab:Toggle({
    Title = "火箭筒攻击所有人",
    Value = false,
    Callback = function(state)
        if state then
            startAllMode()
        else
            stopAllMode()
        end
    end
})

Tabs.OtherTab:Toggle({
    Title = "火箭筒自爆模式",
    Value = false,
    Callback = function(state)
        if state then
            startSelfDestruct()
        else
            stopSelfDestruct()
        end
    end
})

Tabs.OtherTab:Section({ Title = "杂项功能" })

Tabs.OtherTab:Button({
    Title = "关狗笼无碰撞体积",
    Callback = function()
        local DogCages = workspace.DogCages
        if not DogCages then return end
        for i = 1, 8 do
            local model = DogCages:GetChildren()[i]
            if model then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.CanTouch = false
                    end
                end
            end
        end
    end
})