-- Memuat library Tween untuk animasi
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Link yang akan di-copy (ganti dengan link Anda)
local SCRIPT_LINK = "https://link-center.net/3006031/peXa3kekylsa" -- GANTI DENGAN LINK ANDA

-- Membuat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernUIGetScript"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Fungsi untuk membuat notifikasi modern
local function showNotification(title, message, duration)
    duration = duration or 3
	
    -- Frame notifikasi
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(1, 20, 0, 20) -- Mulai dari luar layar kanan
    notifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = screenGui
	
    -- Shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.Parent = notifFrame
	
    -- Corner untuk notifikasi
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notifFrame
	
    -- Garis aksen gradient
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(1, 0, 0, 4)
    accentLine.Position = UDim2.new(0, 0, 0, 0)
    accentLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    accentLine.BorderSizePixel = 0
    accentLine.Parent = notifFrame
	
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 200))
    })
    gradient.Rotation = 90
    gradient.Parent = accentLine
	
    -- Icon notifikasi
    local icon = Instance.new("Frame")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 15, 0.5, -20)
    icon.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    icon.BorderSizePixel = 0
    icon.Parent = notifFrame
	
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 10)
    iconCorner.Parent = icon
	
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "IconLabel"
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "✓"
    iconLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = icon
	
    -- Konten teks
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -70, 0, 25)
    titleLabel.Position = UDim2.new(0, 65, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = notifFrame
	
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -70, 0, 20)
    messageLabel.Position = UDim2.new(0, 65, 0, 40)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.Parent = notifFrame
	
    -- Animasi masuk
    local tweenInfoIn = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
	
    local goalIn = {
        Position = UDim2.new(1, -320, 0, 20)
    }
	
    local tweenIn = TweenService:Create(notifFrame, tweenInfoIn, goalIn)
    tweenIn:Play()
	
    -- Animasi keluar
    task.wait(duration)
	
    local tweenInfoOut = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    )
	
    local goalOut = {
        Position = UDim2.new(1, 20, 0, 20),
        BackgroundTransparency = 1
    }
	
    local tweenOut = TweenService:Create(notifFrame, tweenInfoOut, goalOut)
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notifFrame:Destroy()
    end)
end

-- Fungsi untuk copy link ke clipboard
local function copyToClipboard()
    setclipboard(SCRIPT_LINK)
    showNotification("Success! ✓", "Script link copied to clipboard", 2)
end

-- Background blur (efek modern)
local blur = Instance.new("Frame")
blur.Name = "BackgroundBlur"
blur.Size = UDim2.new(1, 0, 1, 0)
blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blur.BackgroundTransparency = 0.5
blur.BorderSizePixel = 0
blur.Parent = screenGui

-- Main container
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 280)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Shadow untuk main frame
local mainShadow = Instance.new("Frame")
mainShadow.Name = "MainShadow"
mainShadow.Size = UDim2.new(1, 20, 1, 20)
mainShadow.Position = UDim2.new(0, -10, 0, -10)
mainShadow.BackgroundColor3 = Color3.new(0, 0, 0)
mainShadow.BackgroundTransparency = 0.8
mainShadow.BorderSizePixel = 0
mainShadow.ZIndex = -1
mainShadow.Parent = mainFrame

-- Corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 24)
mainCorner.Parent = mainFrame

-- Gradient border effect
local borderGradient = Instance.new("Frame")
borderGradient.Name = "BorderGradient"
borderGradient.Size = UDim2.new(1, 4, 1, 4)
borderGradient.Position = UDim2.new(0, -2, 0, -2)
borderGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
borderGradient.BackgroundTransparency = 1
borderGradient.BorderSizePixel = 0
borderGradient.ZIndex = 2
borderGradient.Parent = mainFrame

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 200))
})
uiGradient.Rotation = 45
uiGradient.Parent = borderGradient

-- Close button
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 15)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 0.95
closeButton.Image = "rbxassetid://3926305904" -- Icon X
closeButton.ImageRectOffset = Vector2.new(4, 4)
closeButton.ImageRectSize = Vector2.new(24, 24)
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    -- Animasi close
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local goal = {
        Position = UDim2.new(0.5, -200, 1.5, 0),
        BackgroundTransparency = 1
    }
    local tween = TweenService:Create(mainFrame, tweenInfo, goal)
    tween:Play()
    tween.Completed:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Juga animasi blur
    TweenService:Create(blur, tweenInfo, {BackgroundTransparency = 1}):Play()
end)

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -40, 0, 40)
titleLabel.Position = UDim2.new(0, 20, 0, 25)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GET NEW SCRIPT"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 28
titleLabel.Parent = mainFrame

-- Subtitle
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -40, 0, 25)
subtitleLabel.Position = UDim2.new(0, 20, 0, 70)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Get New Script Click Button Get Script"
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 16
subtitleLabel.Parent = mainFrame

-- Decorative line
local line = Instance.new("Frame")
line.Name = "Line"
line.Size = UDim2.new(1, -40, 0, 2)
line.Position = UDim2.new(0, 20, 0, 105)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.9
line.BorderSizePixel = 0
line.Parent = mainFrame

-- Info panel
local infoPanel = Instance.new("Frame")
infoPanel.Name = "InfoPanel"
infoPanel.Size = UDim2.new(1, -40, 0, 50)
infoPanel.Position = UDim2.new(0, 20, 0, 120)
infoPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
infoPanel.BackgroundTransparency = 0.5
infoPanel.BorderSizePixel = 0
infoPanel.Parent = mainFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 12)
infoCorner.Parent = infoPanel

local infoIcon = Instance.new("TextLabel")
infoIcon.Name = "InfoIcon"
infoIcon.Size = UDim2.new(0, 30, 1, 0)
infoIcon.Position = UDim2.new(0, 10, 0, 0)
infoIcon.BackgroundTransparency = 1
infoIcon.Text = "ℹ"
infoIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
infoIcon.TextSize = 20
infoIcon.Font = Enum.Font.GothamBold
infoIcon.Parent = infoPanel

local infoText = Instance.new("TextLabel")
infoText.Name = "InfoText"
infoText.Size = UDim2.new(1, -50, 1, 0)
infoText.Position = UDim2.new(0, 45, 0, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "Click the button below to get the script"
infoText.TextColor3 = Color3.fromRGB(220, 220, 240)
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 14
infoText.Parent = infoPanel

-- Get Script Button
local getButton = Instance.new("TextButton")
getButton.Name = "GetScriptButton"
getButton.Size = UDim2.new(1, -40, 0, 60)
getButton.Position = UDim2.new(0, 20, 0, 190)
getButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
getButton.BorderSizePixel = 0
getButton.Text = ""
getButton.AutoButtonColor = false
getButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 16)
buttonCorner.Parent = getButton

-- Button gradient
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 255))
})
buttonGradient.Rotation = 90
buttonGradient.Parent = getButton

-- Button text
local buttonText = Instance.new("TextLabel")
buttonText.Name = "ButtonText"
buttonText.Size = UDim2.new(1, 0, 1, 0)
buttonText.BackgroundTransparency = 1
buttonText.Text = "GET SCRIPT"
buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonText.Font = Enum.Font.GothamBold
buttonText.TextSize = 20
buttonText.Parent = getButton

-- Button icon
local buttonIcon = Instance.new("TextLabel")
buttonIcon.Name = "ButtonIcon"
buttonIcon.Size = UDim2.new(0, 30, 0, 30)
buttonIcon.Position = UDim2.new(1, -40, 0.5, -15)
buttonIcon.BackgroundTransparency = 1
buttonIcon.Text = "→"
buttonIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonIcon.TextSize = 24
buttonIcon.Font = Enum.Font.GothamBold
buttonIcon.Parent = getButton

-- Button animations
getButton.MouseEnter:Connect(function()
    TweenService:Create(getButton, TweenInfo.new(0.3), {Size = UDim2.new(1, -35, 0, 65)}):Play()
    TweenService:Create(buttonText, TweenInfo.new(0.3), {TextSize = 22}):Play()
    TweenService:Create(buttonIcon, TweenInfo.new(0.3), {Position = UDim2.new(1, -45, 0.5, -15)}):Play()
end)

getButton.MouseLeave:Connect(function()
    TweenService:Create(getButton, TweenInfo.new(0.3), {Size = UDim2.new(1, -40, 0, 60)}):Play()
    TweenService:Create(buttonText, TweenInfo.new(0.3), {TextSize = 20}):Play()
    TweenService:Create(buttonIcon, TweenInfo.new(0.3), {Position = UDim2.new(1, -40, 0.5, -15)}):Play()
end)

getButton.MouseButton1Click:Connect(function()
    -- Efek klik
    TweenService:Create(getButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
    task.wait(0.1)
    TweenService:Create(getButton, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    
    -- Copy link
    copyToClipboard()
    
    -- Animasi button icon berubah
    buttonIcon.Text = "✓"
    task.wait(0.5)
    buttonIcon.Text = "→"
end)

-- Animasi muncul saat pertama kali
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
blur.BackgroundTransparency = 1

local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local goal = {
    Position = UDim2.new(0.5, -200, 0.5, -140)
}
local tween = TweenService:Create(mainFrame, tweenInfo, goal)
tween:Play()

TweenService:Create(blur, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()

-- Welcome notification
task.wait(0.5)
showNotification("Welcome!", "Ready to get your script", 2)
