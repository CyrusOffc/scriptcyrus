-- ================= CYRUS HUB | FULL SCRIPT =================

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local GameId = game.GameId

-- ================= NOTIFY =================
local function Notify(title, text, time)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = time or 4
        })
    end)
end

-- ================= INTRO UI =================
local function CreateIntro()
    local gui = Instance.new("ScreenGui")
    gui.Name = "CyrusIntro"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1,1)
    bg.BackgroundColor3 = Color3.new(0,0,0)
    bg.BackgroundTransparency = 1
    bg.Parent = gui

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting

    local cyrus = Instance.new("TextLabel")
    cyrus.AnchorPoint = Vector2.new(0.5,0.5)
    cyrus.Position = UDim2.fromScale(0.5,0.45)
    cyrus.Size = UDim2.fromScale(0.9,0.25)
    cyrus.BackgroundTransparency = 1
    cyrus.Text = "CYRUS"
    cyrus.Font = Enum.Font.GothamBlack
    cyrus.TextColor3 = Color3.new(1,1,1)
    cyrus.TextScaled = true
    cyrus.TextTransparency = 1
    cyrus.Parent = bg

    local hub = Instance.new("TextLabel")
    hub.AnchorPoint = Vector2.new(0.5,0.5)
    hub.Position = UDim2.fromScale(0.5,0.6)
    hub.Size = UDim2.fromScale(0.6,0.18)
    hub.BackgroundTransparency = 1
    hub.Text = "HUB"
    hub.Font = Enum.Font.GothamBlack
    hub.TextColor3 = Color3.fromRGB(0,170,255)
    hub.TextScaled = true
    hub.TextTransparency = 1
    hub.Parent = bg

    local dotsFrame = Instance.new("Frame")
    dotsFrame.AnchorPoint = Vector2.new(0.5,0.5)
    dotsFrame.Position = UDim2.fromScale(0.5,0.8)
    dotsFrame.Size = UDim2.fromScale(0.15,0.05)
    dotsFrame.BackgroundTransparency = 1
    dotsFrame.Parent = bg

    local dots = {}
    for i=1,3 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromScale(0.25,1)
        dot.Position = UDim2.fromScale((i-1)*0.35,0)
        dot.BackgroundColor3 = Color3.fromRGB(0,170,255)
        dot.BackgroundTransparency = 1
        dot.Parent = dotsFrame

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent = dot

        table.insert(dots, dot)
    end

    return gui, bg, blur, cyrus, hub, dots
end

-- ================= INTRO ANIMATION =================
local function PlayIntro()
    local gui, bg, blur, cyrus, hub, dots = CreateIntro()

    TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(blur, TweenInfo.new(0.8), {Size = 24}):Play()

    task.wait(0.3)

    cyrus.Position = UDim2.fromScale(-1,0.45)
    TweenService:Create(cyrus, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
        Position = UDim2.fromScale(0.5,0.45),
        TextTransparency = 0
    }):Play()

    task.wait(0.25)

    hub.Position = UDim2.fromScale(1,0.6)
    TweenService:Create(hub, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
        Position = UDim2.fromScale(0.5,0.6),
        TextTransparency = 0
    }):Play()

    for i,dot in ipairs(dots) do
        task.spawn(function()
            while gui.Parent do
                task.wait((i-1)*0.2)
                TweenService:Create(dot, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
                task.wait(0.3)
                TweenService:Create(dot, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
                task.wait(0.4)
            end
        end)
    end

    task.wait(3)

    TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(cyrus, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(hub, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(blur, TweenInfo.new(0.4), {Size = 0}):Play()

    task.wait(0.5)
    gui:Destroy()
    blur:Destroy()
end

-- ================= GAME DATABASE =================
local GameScripts = {
    [9344307274] = "https://raw.githubusercontent.com/CyrusOffc/scriptcyrus/refs/heads/main/roblox/breakaluckyblock.lua",
    [9363735110] = "https://raw.githubusercontent.com/CyrusOffc/scriptcyrus/refs/heads/main/roblox/etfb.lua",
    [9649298941] = "https://raw.githubusercontent.com/CyrusOffc/scriptcyrus/refs/heads/main/roblox/slfb.lua",
    [7709344486] = "https://raw.githubusercontent.com/CyrusOffc/scriptcyrus/refs/heads/main/roblox/sab.lua",
}

-- ================= MAIN FLOW =================
PlayIntro()

Notify("Cyrus Hub", "Checking Game...", 3)

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(GameId)
end)

local GameName = success and info.Name or "Unknown Game"

if GameScripts[GameId] then
    Notify("Cyrus Hub", "Game Detected:\n"..GameName, 4)
    task.wait(1)
    Notify("Cyrus Hub", "Loading Script...", 4)

    local ok, err = pcall(function()
        loadstring(game:HttpGet(GameScripts[GameId], true))()
    end)

    if not ok then
        Notify("Cyrus Hub", "Error loading script!", 5)
        warn(err)
    end
else
    Notify("Cyrus Hub",
        "Game Not Supported!\n"..GameName.."\nGameId: "..GameId,
        6
    )
end
