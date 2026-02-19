--[[
    CYRUS UI LIBRARY v3.0
    Modern UI Framework for Roblox
    Features: 
    - Premium modern design with glass morphism
    - Smooth animations with spring physics
    - Open/Close Image Button with custom asset
    - Advanced theme system with 30+ themes
    - Config system with save/load
    - Modern notifications with progress bar
    - Fully customizable
]]

local Cyrus = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui") or LocalPlayer.PlayerGui
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

-- ==================== PREMIUM ANIMATION SYSTEM ====================

local Spring = {}
Spring.__index = Spring

function Spring.new(frequency, dampingRatio)
    return setmetatable({
        frequency = frequency or 4,
        dampingRatio = dampingRatio or 1,
    }, Spring)
end

function Spring:step(state, dt)
    local d = self.dampingRatio
    local f = self.frequency * 2 * math.pi
    local g = state.goal
    local p0 = state.value
    local v0 = state.velocity or 0
    
    local offset = p0 - g
    local decay = math.exp(-d * f * dt)
    
    local p1, v1
    
    if d == 1 then
        p1 = (offset * (1 + f * dt) + v0 * dt) * decay + g
        v1 = (v0 * (1 - f * dt) - offset * (f * f * dt)) * decay
    elseif d < 1 then
        local c = math.sqrt(1 - d * d)
        local i = math.cos(f * c * dt)
        local j = math.sin(f * c * dt)
        local z = j / c
        
        p1 = (offset * (i + d * z) + v0 * z / f) * decay + g
        v1 = (v0 * (i - z * d) - offset * (z * f)) * decay
    else
        local c = math.sqrt(d * d - 1)
        local r1 = -f * (d - c)
        local r2 = -f * (d + c)
        local co2 = (v0 - offset * r1) / (2 * f * c)
        local co1 = offset - co2
        
        p1 = co1 * math.exp(r1 * dt) + co2 * math.exp(r2 * dt) + g
        v1 = co1 * r1 * math.exp(r1 * dt) + co2 * r2 * math.exp(r2 * dt)
    end
    
    local complete = math.abs(v1) < 0.001 and math.abs(p1 - g) < 0.001
    
    return {
        complete = complete,
        value = complete and g or p1,
        velocity = v1,
    }
end

local Motor = {}
Motor.__index = Motor

function Motor.new(initialValue)
    return setmetatable({
        _state = {
            value = initialValue,
            velocity = 0,
            goal = initialValue,
            complete = true,
        },
        _connections = {},
        _running = false,
    }, Motor)
end

function Motor:onStep(callback)
    table.insert(self._connections, callback)
    return callback
end

function Motor:setGoal(goal, spring)
    self._state.goal = goal
    self._state.complete = false
    self._spring = spring or Spring.new(4, 1)
    
    if not self._running then
        self._running = true
        self:_start()
    end
end

function Motor:_start()
    local lastTime = tick()
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = math.min(now - lastTime, 0.1)
        lastTime = now
        
        if not self._state.complete then
            local newState = self._spring:step(self._state, dt)
            self._state.value = newState.value
            self._state.velocity = newState.velocity
            self._state.complete = newState.complete
            
            for _, callback in ipairs(self._connections) do
                callback(self._state.value)
            end
            
            if self._state.complete then
                self._running = false
                connection:Disconnect()
            end
        end
    end)
end

function Motor:getValue()
    return self._state.value
end

-- ==================== MODERN CIRCLE CLICK EFFECT ====================

local function ModernCircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        
        -- Primary circle
        local Circle1 = Instance.new("ImageLabel")
        Circle1.Image = "rbxassetid://266543268"
        Circle1.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Circle1.ImageTransparency = 0.7
        Circle1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle1.BackgroundTransparency = 1
        Circle1.ZIndex = 10
        Circle1.Name = "Circle1"
        Circle1.Parent = Button
        
        -- Secondary circle (trail effect)
        local Circle2 = Instance.new("ImageLabel")
        Circle2.Image = "rbxassetid://266543268"
        Circle2.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Circle2.ImageTransparency = 0.9
        Circle2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle2.BackgroundTransparency = 1
        Circle2.ZIndex = 9
        Circle2.Name = "Circle2"
        Circle2.Parent = Button
        
        local NewX = X - Circle1.AbsolutePosition.X
        local NewY = Y - Circle1.AbsolutePosition.Y
        Circle1.Position = UDim2.new(0, NewX, 0, NewY)
        Circle2.Position = UDim2.new(0, NewX, 0, NewY)
        
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2.5
        
        Circle1:TweenSizeAndPosition(
            UDim2.new(0, Size, 0, Size),
            UDim2.new(0.5, -Size/2, 0.5, -Size/2),
            Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.5, false, nil
        )
        
        Circle2:TweenSizeAndPosition(
            UDim2.new(0, Size * 0.7, 0, Size * 0.7),
            UDim2.new(0.5, -Size * 0.35, 0.5, -Size * 0.35),
            Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.7, false, nil
        )
        
        for i = 1, 15 do
            Circle1.ImageTransparency = Circle1.ImageTransparency + 0.02
            Circle2.ImageTransparency = Circle2.ImageTransparency + 0.015
            wait(0.03)
        end
        
        Circle1:Destroy()
        Circle2:Destroy()
    end)
end

-- ==================== SMOOTH DRAGGABLE WITH SPRING ====================

local function SmoothDraggable(topbarobject, object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    local SpringMotor = Motor.new(0)
    
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local newPos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        
        object.Position = newPos
    end
    
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            -- Scale up effect
            TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
                {Size = UDim2.new(1.02, -48, 1.02, -48)}):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    TweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
                        {Size = UDim2.new(1, -48, 1, -48)}):Play()
                end
            end)
        end
    end)
    
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end

-- ==================== CONFIG SYSTEM ====================

local ConfigSystem = {
    CurrentConfig = nil,
    Configs = {},
    ThemeColors = {
        ["Default"] = Color3.fromRGB(255, 0, 255),
        ["Blue"] = Color3.fromRGB(0, 120, 255),
        ["Red"] = Color3.fromRGB(255, 50, 50),
        ["Green"] = Color3.fromRGB(0, 200, 80),
        ["Orange"] = Color3.fromRGB(255, 120, 0),
        ["Purple"] = Color3.fromRGB(160, 0, 255),
        ["Cyan"] = Color3.fromRGB(0, 200, 255),
        ["Pink"] = Color3.fromRGB(255, 100, 200),
        ["Midnight"] = Color3.fromRGB(10, 30, 60),
        ["Ocean"] = Color3.fromRGB(0, 150, 200),
        ["Sunset"] = Color3.fromRGB(255, 100, 50),
        ["Gold"] = Color3.fromRGB(255, 200, 0),
        ["Emerald"] = Color3.fromRGB(0, 200, 150),
        ["Crimson"] = Color3.fromRGB(200, 0, 50),
        ["Lavender"] = Color3.fromRGB(180, 130, 255),
        ["Teal"] = Color3.fromRGB(0, 150, 150),
        ["Rose"] = Color3.fromRGB(255, 100, 150),
        ["Sky"] = Color3.fromRGB(100, 180, 255),
        ["Forest"] = Color3.fromRGB(0, 120, 80),
        ["Amber"] = Color3.fromRGB(255, 150, 0),
        ["Neon"] = Color3.fromRGB(0, 255, 200),
        ["Royal"] = Color3.fromRGB(100, 0, 200),
        ["Cyber"] = Color3.fromRGB(0, 255, 255),
        ["Lava"] = Color3.fromRGB(255, 80, 0),
        ["Frost"] = Color3.fromRGB(150, 255, 255),
        ["Galaxy"] = Color3.fromRGB(100, 50, 200),
        ["Sunrise"] = Color3.fromRGB(255, 150, 100),
        ["Mint"] = Color3.fromRGB(100, 255, 150),
        ["Cherry"] = Color3.fromRGB(255, 50, 100),
        ["MidnightBlue"] = Color3.fromRGB(20, 30, 80),
        ["BloodRed"] = Color3.fromRGB(150, 0, 0),
        ["ForestGreen"] = Color3.fromRGB(0, 100, 50),
    },
    CurrentTheme = "Default",
    ThemeElements = {},
    ToggleElements = {},
    SliderElements = {},
    DropdownElements = {},
    TabElements = {},
    AllElements = {}
}

function ConfigSystem:SetTheme(themeName)
    if self.ThemeColors[themeName] then
        self.CurrentTheme = themeName
        local newColor = self.ThemeColors[themeName]
        self:UpdateAllThemeElements(newColor)
        return true, newColor
    end
    return false, nil
end

function ConfigSystem:UpdateAllThemeElements(newColor)
    -- Update toggles
    for _, toggle in pairs(self.ToggleElements) do
        if toggle and toggle:IsA("Frame") then
            local featureFrame = toggle:FindFirstChild("FeatureFrame")
            local toggleCircle = toggle:FindFirstChild("ToggleCircle")
            local toggleTitle = toggle:FindFirstChild("ToggleTitle")
            
            if toggleCircle then
                local isOn = toggleCircle.Position == UDim2.new(0, 20, 0, 0)
                if isOn then
                    TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                        {BackgroundColor3 = newColor}):Play()
                    if toggleTitle then
                        TweenService:Create(toggleTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                            {TextColor3 = newColor}):Play()
                    end
                end
            end
        end
    end
    
    -- Update sliders
    for _, slider in pairs(self.SliderElements) do
        if slider and slider:IsA("Frame") then
            local sliderFill = slider:FindFirstChild("SliderFill")
            local sliderCircle = slider:FindFirstChild("SliderCircle")
            
            if sliderFill then
                TweenService:Create(sliderFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                    {BackgroundColor3 = newColor}):Play()
            end
            if sliderCircle then
                TweenService:Create(sliderCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                    {BackgroundColor3 = newColor}):Play()
            end
        end
    end
    
    -- Update dropdowns
    for _, dropdown in pairs(self.DropdownElements) do
        if dropdown and dropdown:IsA("Frame") then
            local dropdownList = dropdown:FindFirstChild("DropdownList")
            if dropdownList then
                local listScroll = dropdownList:FindFirstChild("ListScroll")
                if listScroll then
                    for _, option in listScroll:GetChildren() do
                        if option:IsA("Frame") and option.Name == "Option" then
                            local checkIcon = option:FindFirstChild("CheckIcon")
                            local optionText = option:FindFirstChild("OptionText")
                            
                            if checkIcon then
                                TweenService:Create(checkIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                                    {ImageColor3 = newColor}):Play()
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Update tabs
    for _, tab in pairs(self.TabElements) do
        if tab and tab:IsA("Frame") then
            local activeIndicator = tab:FindFirstChild("ActiveIndicator")
            local tabIcon = tab:FindFirstChild("TabIcon")
            
            if activeIndicator and activeIndicator.Visible then
                TweenService:Create(activeIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                    {BackgroundColor3 = newColor}):Play()
            end
            if tabIcon then
                TweenService:Create(tabIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
                    {ImageColor3 = newColor}):Play()
            end
        end
    end
    
    return newColor
end

function ConfigSystem:SaveConfig(name, data)
    local configData = {
        Name = name,
        Theme = self.CurrentTheme,
        Data = data or {}
    }
    
    self.Configs[name] = configData
    self.CurrentConfig = name
    
    return {
        Title = "⚙️ Config",
        Description = "Saved",
        Content = "Config '" .. name .. "' saved successfully!",
        Color = self.ThemeColors[self.CurrentTheme],
        Icon = "rbxassetid://111662964379929",
        Delay = 3
    }
end

function ConfigSystem:LoadConfig(name)
    if self.Configs[name] then
        local config = self.Configs[name]
        self.CurrentTheme = config.Theme
        self.CurrentConfig = name
        
        return {
            Title = "⚙️ Config",
            Description = "Loaded",
            Content = "Config '" .. name .. "' loaded successfully!",
            Color = self.ThemeColors[self.CurrentTheme],
            Icon = "rbxassetid://111662964379929",
            Delay = 3
        }, config.Data
    else
        return {
            Title = "⚙️ Config",
            Description = "Error",
            Content = "Config '" .. name .. "' not found!",
            Color = Color3.fromRGB(255, 50, 50),
            Icon = "rbxassetid://111662964379929",
            Delay = 3
        }, nil
    end
end

function ConfigSystem:DeleteConfig(name)
    if self.Configs[name] then
        self.Configs[name] = nil
        if self.CurrentConfig == name then
            self.CurrentConfig = nil
        end
        
        return {
            Title = "⚙️ Config",
            Description = "Deleted",
            Content = "Config '" .. name .. "' deleted successfully!",
            Color = self.ThemeColors[self.CurrentTheme],
            Icon = "rbxassetid://111662964379929",
            Delay = 3
        }
    else
        return {
            Title = "⚙️ Config",
            Description = "Error",
            Content = "Config '" .. name .. "' not found!",
            Color = Color3.fromRGB(255, 50, 50),
            Icon = "rbxassetid://111662964379929",
            Delay = 3
        }
    end
end

function ConfigSystem:GetConfigList()
    local list = {}
    for name, _ in pairs(self.Configs) do
        table.insert(list, name)
    end
    return list
end

-- ==================== MODERN NOTIFICATION ====================

local function ModernNotify(NotifyConfig)
    local NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Notification"
    NotifyConfig.Description = NotifyConfig.Description or "Description"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(255, 0, 255)
    NotifyConfig.Icon = NotifyConfig.Icon or "rbxassetid://111662964379929"
    NotifyConfig.Delay = NotifyConfig.Delay or 5
    
    local NotifyFunction = {}
    
    spawn(function()
        if not CoreGui:FindFirstChild("CyrusNotifyGui") then
            local NotifyGui = Instance.new("ScreenGui")
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifyGui.Name = "CyrusNotifyGui"
            NotifyGui.Parent = CoreGui
        end
        
        if not CoreGui.CyrusNotifyGui:FindFirstChild("NotifyLayout") then
            local NotifyLayout = Instance.new("Frame")
            NotifyLayout.AnchorPoint = Vector2.new(1, 1)
            NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NotifyLayout.BackgroundTransparency = 1
            NotifyLayout.Position = UDim2.new(1, -20, 1, -20)
            NotifyLayout.Size = UDim2.new(0, 350, 0, 0)
            NotifyLayout.Name = "NotifyLayout"
            NotifyLayout.Parent = CoreGui.CyrusNotifyGui
            
            local Layout = Instance.new("UIListLayout")
            Layout.Padding = UDim.new(0, 10)
            Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Parent = NotifyLayout
        end
        
        local NotifyLayout = CoreGui.CyrusNotifyGui.NotifyLayout
        
        -- Main notification frame
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Size = UDim2.new(0, 330, 0, 0)
        NotifyFrame.AutomaticSize = Enum.AutomaticSize.Y
        NotifyFrame.Parent = NotifyLayout
        
        local NotifyCorner = Instance.new("UICorner")
        NotifyCorner.CornerRadius = UDim.new(0, 12)
        NotifyCorner.Parent = NotifyFrame
        
        local NotifyStroke = Instance.new("UIStroke")
        NotifyStroke.Color = NotifyConfig.Color
        NotifyStroke.Thickness = 1.5
        NotifyStroke.Transparency = 0.7
        NotifyStroke.Parent = NotifyFrame
        
        -- Shadow
        local Shadow = Instance.new("ImageLabel")
        Shadow.Image = "rbxassetid://6015897843"
        Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.ImageTransparency = 0.5
        Shadow.ScaleType = Enum.ScaleType.Slice
        Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
        Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        Shadow.BackgroundTransparency = 1
        Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        Shadow.Size = UDim2.new(1, 20, 1, 20)
        Shadow.ZIndex = 0
        Shadow.Parent = NotifyFrame
        
        -- Top bar with icon
        local TopBar = Instance.new("Frame")
        TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TopBar.BackgroundTransparency = 0.5
        TopBar.BorderSizePixel = 0
        TopBar.Size = UDim2.new(1, 0, 0, 40)
        TopBar.Parent = NotifyFrame
        
        local TopBarCorner = Instance.new("UICorner")
        TopBarCorner.CornerRadius = UDim.new(0, 12)
        TopBarCorner.Parent = TopBar
        
        local Icon = Instance.new("ImageLabel")
        Icon.Image = NotifyConfig.Icon
        Icon.ImageColor3 = NotifyConfig.Color
        Icon.BackgroundTransparency = 1
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 12, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.Parent = TopBar
        
        local Title = Instance.new("TextLabel")
        Title.Font = Enum.Font.GothamBold
        Title.Text = NotifyConfig.Title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(1, -70, 1, 0)
        Title.Position = UDim2.new(0, 40, 0, 0)
        Title.Parent = TopBar
        
        local Description = Instance.new("TextLabel")
        Description.Font = Enum.Font.Gotham
        Description.Text = NotifyConfig.Description
        Description.TextColor3 = NotifyConfig.Color
        Description.TextSize = 13
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.BackgroundTransparency = 1
        Description.Size = UDim2.new(1, -70, 1, 0)
        Description.Position = UDim2.new(0, Title.TextBounds.X + 45, 0, 0)
        Description.Parent = TopBar
        
        -- Close button
        local CloseButton = Instance.new("ImageButton")
        CloseButton.Image = "rbxassetid://9886659671"
        CloseButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
        CloseButton.BackgroundTransparency = 1
        CloseButton.Size = UDim2.new(0, 24, 0, 24)
        CloseButton.Position = UDim2.new(1, -32, 0.5, 0)
        CloseButton.AnchorPoint = Vector2.new(1, 0.5)
        CloseButton.Parent = TopBar
        
        -- Content
        local Content = Instance.new("TextLabel")
        Content.Font = Enum.Font.Gotham
        Content.Text = NotifyConfig.Content
        Content.TextColor3 = Color3.fromRGB(180, 180, 180)
        Content.TextSize = 13
        Content.TextWrapped = true
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.BackgroundTransparency = 1
        Content.Size = UDim2.new(1, -24, 0, 0)
        Content.Position = UDim2.new(0, 12, 0, 50)
        Content.AutomaticSize = Enum.AutomaticSize.Y
        Content.Parent = NotifyFrame
        
        -- Progress bar
        local ProgressBar = Instance.new("Frame")
        ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Size = UDim2.new(1, 0, 0, 3)
        ProgressBar.Position = UDim2.new(0, 0, 1, -3)
        ProgressBar.Parent = NotifyFrame
        
        local ProgressFill = Instance.new("Frame")
        ProgressFill.BackgroundColor3 = NotifyConfig.Color
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Size = UDim2.new(0, 0, 1, 0)
        ProgressFill.Parent = ProgressBar
        
        -- Animation
        NotifyFrame.Position = UDim2.new(1, 50, 0, 0)
        NotifyFrame.Visible = true
        
        TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
            {Position = UDim2.new(1, -NotifyFrame.AbsoluteSize.X - 10, 0, 0)}):Play()
        
        TweenService:Create(ProgressFill, TweenInfo.new(NotifyConfig.Delay, Enum.EasingStyle.Linear), 
            {Size = UDim2.new(1, 0, 1, 0)}):Play()
        
        function NotifyFunction:Close()
            TweenService:Create(NotifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
                {Position = UDim2.new(1, 50, 0, 0)}):Play()
            wait(0.4)
            NotifyFrame:Destroy()
        end
        
        CloseButton.MouseButton1Click:Connect(function()
            ModernCircleClick(CloseButton, Mouse.X, Mouse.Y)
            NotifyFunction:Close()
        end)
        
        task.wait(NotifyConfig.Delay)
        NotifyFunction:Close()
    end)
    
    return NotifyFunction
end

-- ==================== OPEN/CLOSE IMAGE BUTTON ====================

local function CreateOpenButton()
    local OpenButtonGui = Instance.new("ScreenGui")
    OpenButtonGui.Name = "CyrusOpenButton"
    OpenButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    OpenButtonGui.Parent = CoreGui
    
    local OpenButton = Instance.new("ImageButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Parent = OpenButtonGui
    OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OpenButton.BackgroundTransparency = 0.2
    OpenButton.BorderSizePixel = 0
    OpenButton.Position = UDim2.new(1, -70, 1, -70)
    OpenButton.Size = UDim2.new(0, 0, 0, 0)  -- Start hidden
    OpenButton.AnchorPoint = Vector2.new(0.5, 0.5)
    OpenButton.Image = "rbxassetid://111662964379929"  -- Your custom asset
    OpenButton.ImageColor3 = Color3.fromRGB(0, 255, 255)  -- Cyan
    OpenButton.Visible = false
    OpenButton.ZIndex = 1000
    
    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 25)
    OpenCorner.Parent = OpenButton
    
    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(0, 255, 255)
    OpenStroke.Thickness = 2.5
    OpenStroke.Transparency = 0.5
    OpenStroke.Parent = OpenButton
    
    -- Hover effect
    OpenButton.MouseEnter:Connect(function()
        TweenService:Create(OpenButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
            {Size = UDim2.new(0, 60, 0, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(OpenStroke, TweenInfo.new(0.2), 
            {Transparency = 0, Color = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    OpenButton.MouseLeave:Connect(function()
        TweenService:Create(OpenButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
            {Size = UDim2.new(0, 50, 0, 50), ImageColor3 = Color3.fromRGB(0, 255, 255)}):Play()
        TweenService:Create(OpenStroke, TweenInfo.new(0.2), 
            {Transparency = 0.5, Color = Color3.fromRGB(0, 255, 255)}):Play()
    end)
    
    return OpenButton
end

-- ==================== MAIN WINDOW CREATION ====================

function Cyrus:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Cyrus UI"
    local Theme = config.Theme or "Cyber"
    local Size = config.Size or UDim2.fromOffset(600, 500)
    local Center = config.Center ~= false
    local Draggable = config.Draggable ~= false
    local MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightShift
    
    if ConfigSystem.ThemeColors[Theme] then
        ConfigSystem.CurrentTheme = Theme
    end
    
    -- Create main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name = "CyrusUI"
    ScreenGui.Parent = CoreGui
    
    -- Main window container
    local DropShadowHolder = Instance.new("Frame")
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.Size = Size
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = ScreenGui
    DropShadowHolder.ClipsDescendants = false
    
    if Center then
        DropShadowHolder.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    end
    
    -- Shadow effect
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    
    -- Main window with glass effect
    local Main = Instance.new("Frame")
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Main.BackgroundTransparency = 0.05
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow
    Main.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(50, 50, 50)
    UIStroke.Thickness = 1.8
    UIStroke.Parent = Main
    
    -- Top bar
    local Top = Instance.new("Frame")
    Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Top.BackgroundTransparency = 0.1
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 45)
    Top.Name = "Top"
    Top.Parent = Main
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = Top
    
    local TopLine = Instance.new("Frame")
    TopLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopLine.BorderSizePixel = 0
    TopLine.Position = UDim2.new(0, 0, 1, -1)
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Parent = Top
    
    -- Window icon
    local WindowIcon = Instance.new("ImageLabel")
    WindowIcon.Image = "rbxassetid://111662964379929"
    WindowIcon.ImageColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
    WindowIcon.BackgroundTransparency = 1
    WindowIcon.Size = UDim2.new(0, 20, 0, 20)
    WindowIcon.Position = UDim2.new(0, 12, 0.5, 0)
    WindowIcon.AnchorPoint = Vector2.new(0, 0.5)
    WindowIcon.Parent = Top
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 40, 0, 0)
    TitleLabel.Parent = Top
    
    -- Window controls
    local function CreateControlButton(position, iconId, callback)
        local Button = Instance.new("ImageButton")
        Button.Image = iconId
        Button.ImageColor3 = Color3.fromRGB(180, 180, 180)
        Button.BackgroundTransparency = 1
        Button.Size = UDim2.new(0, 28, 0, 28)
        Button.Position = UDim2.new(1, position, 0.5, 0)
        Button.AnchorPoint = Vector2.new(1, 0.5)
        Button.Parent = Top
        
        -- Hover effect
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), 
                {ImageColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 30, 0, 30)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), 
                {ImageColor3 = Color3.fromRGB(180, 180, 180), Size = UDim2.new(0, 28, 0, 28)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            ModernCircleClick(Button, Mouse.X, Mouse.Y)
            if callback then callback() end
        end)
        
        return Button
    end
    
    -- Create Open Button
    local OpenButton = CreateOpenButton()
    
    -- Minimize function
    local function ToggleMinimize()
        if DropShadowHolder.Visible then
            -- Minimize
            DropShadowHolder.Visible = false
            OpenButton.Visible = true
            TweenService:Create(OpenButton, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
                {Size = UDim2.new(0, 50, 0, 50), ImageTransparency = 0}):Play()
        else
            -- Restore
            DropShadowHolder.Visible = true
            TweenService:Create(OpenButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
                {Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1}):Play()
            wait(0.3)
            OpenButton.Visible = false
        end
    end
    
    -- Open button click
    OpenButton.MouseButton1Click:Connect(ToggleMinimize)
    
    -- Control buttons
    local MinButton = CreateControlButton(-40, "rbxassetid://9886659276", ToggleMinimize)
    local MaxButton = CreateControlButton(-78, "rbxassetid://9886659406", function()
        if MaxButton.Image == "rbxassetid://9886659406" then
            MaxButton.Image = "rbxassetid://9886659001"
            OldPos = DropShadowHolder.Position
            OldSize = DropShadowHolder.Size
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
                {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)}):Play()
        else
            MaxButton.Image = "rbxassetid://9886659406"
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
                {Position = OldPos, Size = OldSize}):Play()
        end
    end)
    
    local CloseButton = CreateControlButton(-10, "rbxassetid://9886659671", function()
        TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(OpenButton, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
        OpenButton.Parent:Destroy()
    end)
    
    local OldPos = DropShadowHolder.Position
    local OldSize = DropShadowHolder.Size
    
    -- Keyboard shortcut
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == MinimizeKey then
            ToggleMinimize()
        end
    end)
    
    -- Make window draggable
    if Draggable then
        SmoothDraggable(Top, DropShadowHolder)
    end
    
    -- Tab frame
    local TabFrame = Instance.new("Frame")
    TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabFrame.BackgroundTransparency = 0.1
    TabFrame.BorderSizePixel = 0
    TabFrame.Position = UDim2.new(0, 12, 0, 60)
    TabFrame.Size = UDim2.new(0, 140, 1, -72)
    TabFrame.Name = "TabFrame"
    TabFrame.Parent = Main
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabFrame
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    TabScroll.ScrollBarThickness = 3
    TabScroll.Active = true
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Size = UDim2.new(1, -10, 1, -10)
    TabScroll.Position = UDim2.new(0, 5, 0, 5)
    TabScroll.Name = "TabScroll"
    TabScroll.Parent = TabFrame
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabScroll
    
    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.BackgroundTransparency = 0.1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 164, 0, 60)
    ContentFrame.Size = UDim2.new(1, -176, 1, -72)
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame
    
    local ContentTitle = Instance.new("TextLabel")
    ContentTitle.Font = Enum.Font.GothamBold
    ContentTitle.Text = "Main"
    ContentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ContentTitle.TextSize = 24
    ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
    ContentTitle.BackgroundTransparency = 1
    ContentTitle.Size = UDim2.new(1, -20, 0, 35)
    ContentTitle.Position = UDim2.new(0, 12, 0, 8)
    ContentTitle.Name = "ContentTitle"
    ContentTitle.Parent = ContentFrame
    
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    ContentScroll.ScrollBarThickness = 4
    ContentScroll.Active = true
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.Position = UDim2.new(0, 12, 0, 48)
    ContentScroll.Size = UDim2.new(1, -24, 1, -60)
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Parent = ContentFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 12)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = ContentScroll
    
    local TabContents = {}
    local CurrentTab = nil
    local TabCount = 0
    local AllElements = {}
    
    -- Update functions
    local function UpdateTabSize()
        local OffsetY = 0
        for _, child in TabScroll:GetChildren() do
            if child:IsA("Frame") and child.Name == "Tab" then
                OffsetY = OffsetY + 5 + child.Size.Y.Offset
            end
        end
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    
    local function UpdateContentSize()
        if CurrentTab and TabContents[CurrentTab] then
            local OffsetY = 0
            for _, child in TabContents[CurrentTab]:GetChildren() do
                if child:IsA("Frame") then
                    OffsetY = OffsetY + 12 + child.Size.Y.Offset
                end
            end
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
        end
    end
    
    TabScroll.ChildAdded:Connect(UpdateTabSize)
    TabScroll.ChildRemoved:Connect(UpdateTabSize)
    
    -- ==================== UI ELEMENTS ====================
    
    -- Paragraph creator
    local function CreateParagraph(tabContainer, title, content)
        if not tabContainer or not tabContainer:IsA("Frame") then return end
        
        local Paragraph = Instance.new("Frame")
        Paragraph.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Paragraph.BackgroundTransparency = 0.3
        Paragraph.BorderSizePixel = 0
        Paragraph.Size = UDim2.new(1, 0, 0, 0)
        Paragraph.AutomaticSize = Enum.AutomaticSize.Y
        Paragraph.Name = "Paragraph"
        Paragraph.Parent = tabContainer
        
        local ParagraphCorner = Instance.new("UICorner")
        ParagraphCorner.CornerRadius = UDim.new(0, 8)
        ParagraphCorner.Parent = Paragraph
        
        local ParagraphTitle = Instance.new("TextLabel")
        ParagraphTitle.Font = Enum.Font.GothamBold
        ParagraphTitle.Text = title
        ParagraphTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ParagraphTitle.TextSize = 15
        ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
        ParagraphTitle.BackgroundTransparency = 1
        ParagraphTitle.Position = UDim2.new(0, 14, 0, 12)
        ParagraphTitle.Size = UDim2.new(1, -28, 0, 18)
        ParagraphTitle.Name = "ParagraphTitle"
        ParagraphTitle.Parent = Paragraph
        
        local ParagraphContent = Instance.new("TextLabel")
        ParagraphContent.Font = Enum.Font.Gotham
        ParagraphContent.Text = content
        ParagraphContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        ParagraphContent.TextSize = 13
        ParagraphContent.TextWrapped = true
        ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
        ParagraphContent.BackgroundTransparency = 1
        ParagraphContent.Position = UDim2.new(0, 14, 0, 35)
        ParagraphContent.Size = UDim2.new(1, -28, 0, 0)
        ParagraphContent.AutomaticSize = Enum.AutomaticSize.Y
        ParagraphContent.Name = "ParagraphContent"
        ParagraphContent.Parent = Paragraph
        
        return Paragraph
    end
    
    -- Button creator
    local function CreateButton(tabContainer, title, content, iconId, callback)
        if not tabContainer or not tabContainer:IsA("Frame") then return end
        
        local Button = Instance.new("Frame")
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Button.BackgroundTransparency = 0.3
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 0)
        Button.AutomaticSize = Enum.AutomaticSize.Y
        Button.Name = "Button"
        Button.Parent = tabContainer
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        local ButtonTitle = Instance.new("TextLabel")
        ButtonTitle.Font = Enum.Font.GothamBold
        ButtonTitle.Text = title
        ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonTitle.TextSize = 14
        ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
        ButtonTitle.BackgroundTransparency = 1
        ButtonTitle.Position = UDim2.new(0, 14, 0, 12)
        ButtonTitle.Size = UDim2.new(1, -100, 0, 16)
        ButtonTitle.Name = "ButtonTitle"
        ButtonTitle.Parent = Button
        
        local ButtonContent = Instance.new("TextLabel")
        ButtonContent.Font = Enum.Font.Gotham
        ButtonContent.Text = content
        ButtonContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        ButtonContent.TextSize = 13
        ButtonContent.TextWrapped = true
        ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
        ButtonContent.BackgroundTransparency = 1
        ButtonContent.Position = UDim2.new(0, 14, 0, 32)
        ButtonContent.Size = UDim2.new(1, -100, 0, 0)
        ButtonContent.AutomaticSize = Enum.AutomaticSize.Y
        ButtonContent.Name = "ButtonContent"
        ButtonContent.Parent = Button
        
        local ButtonButton = Instance.new("TextButton")
        ButtonButton.BackgroundTransparency = 1
        ButtonButton.Size = UDim2.new(1, 0, 1, 0)
        ButtonButton.Text = ""
        ButtonButton.Parent = Button
        
        local IconFrame = Instance.new("Frame")
        IconFrame.AnchorPoint = Vector2.new(1, 0.5)
        IconFrame.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
        IconFrame.BackgroundTransparency = 0.7
        IconFrame.BorderSizePixel = 0
        IconFrame.Position = UDim2.new(1, -20, 0.5, 0)
        IconFrame.Size = UDim2.new(0, 36, 0, 36)
        IconFrame.Parent = Button
        
        local IconCorner = Instance.new("UICorner")
        IconCorner.CornerRadius = UDim.new(0, 8)
        IconCorner.Parent = IconFrame
        
        local Icon = Instance.new("ImageLabel")
        Icon.Image = iconId or "rbxassetid://111662964379929"
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Icon.BackgroundTransparency = 1
        Icon.Size = UDim2.new(1, -8, 1, -8)
        Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0.5, 0.5)
        Icon.Parent = IconFrame
        
        -- Hover effect
        ButtonButton.MouseEnter:Connect(function()
            TweenService:Create(IconFrame, TweenInfo.new(0.2), 
                {BackgroundTransparency = 0.5, Size = UDim2.new(0, 38, 0, 38)}):Play()
        end)
        
        ButtonButton.MouseLeave:Connect(function()
            TweenService:Create(IconFrame, TweenInfo.new(0.2), 
                {BackgroundTransparency = 0.7, Size = UDim2.new(0, 36, 0, 36)}):Play()
        end)
        
        ButtonButton.MouseButton1Click:Connect(function()
            ModernCircleClick(ButtonButton, Mouse.X, Mouse.Y)
            if callback then callback() end
        end)
        
        return Button
    end
    
    -- Toggle creator
    local function CreateToggle(tabContainer, title, content, defaultValue, callback, elementId)
        if not tabContainer or not tabContainer:IsA("Frame") then return end
        
        local Toggle = Instance.new("Frame")
        Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Toggle.BackgroundTransparency = 0.3
        Toggle.BorderSizePixel = 0
        Toggle.Size = UDim2.new(1, 0, 0, 0)
        Toggle.AutomaticSize = Enum.AutomaticSize.Y
        Toggle.Name = "Toggle"
        Toggle.Parent = tabContainer
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = Toggle
        
        local ToggleTitle = Instance.new("TextLabel")
        ToggleTitle.Font = Enum.Font.GothamBold
        ToggleTitle.Text = title
        ToggleTitle.TextSize = 14
        ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
        ToggleTitle.BackgroundTransparency = 1
        ToggleTitle.Position = UDim2.new(0, 14, 0, 12)
        ToggleTitle.Size = UDim2.new(1, -100, 0, 16)
        ToggleTitle.Name = "ToggleTitle"
        ToggleTitle.Parent = Toggle
        
        local ToggleContent = Instance.new("TextLabel")
        ToggleContent.Font = Enum.Font.Gotham
        ToggleContent.Text = content
        ToggleContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        ToggleContent.TextSize = 13
        ToggleContent.TextWrapped = true
        ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
        ToggleContent.BackgroundTransparency = 1
        ToggleContent.Position = UDim2.new(0, 14, 0, 32)
        ToggleContent.Size = UDim2.new(1, -100, 0, 0)
        ToggleContent.AutomaticSize = Enum.AutomaticSize.Y
        ToggleContent.Name = "ToggleContent"
        ToggleContent.Parent = Toggle
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Text = ""
        ToggleButton.Parent = Toggle
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleFrame.BackgroundTransparency = 0.3
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Position = UDim2.new(1, -25, 0.5, 0)
        ToggleFrame.Size = UDim2.new(0, 44, 0, 22)
        ToggleFrame.Parent = Toggle
        
        local ToggleFrameCorner = Instance.new("UICorner")
        ToggleFrameCorner.CornerRadius = UDim.new(0, 11)
        ToggleFrameCorner.Parent = ToggleFrame
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
        ToggleCircle.Position = defaultValue and UDim2.new(0, 23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
        ToggleCircle.Parent = ToggleFrame
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(0, 9)
        CircleCorner.Parent = ToggleCircle
        
        table.insert(ConfigSystem.ToggleElements, Toggle)
        
        local state = defaultValue or false
        
        local function SetState(value)
            state = value
            local themeColor = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
            
            if value then
                TweenService:Create(ToggleTitle, TweenInfo.new(0.3, Enum.EasingStyle.Back), 
                    {TextColor3 = themeColor}):Play()
                TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back), 
                    {Position = UDim2.new(0, 23, 0.5, 0), BackgroundColor3 = themeColor}):Play()
                TweenService:Create(ToggleFrame, TweenInfo.new(0.3), 
                    {BackgroundColor3 = themeColor}):Play()
            else
                TweenService:Create(ToggleTitle, TweenInfo.new(0.3), 
                    {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back), 
                    {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                TweenService:Create(ToggleFrame, TweenInfo.new(0.3), 
                    {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end
            
            if callback then callback(state) end
        end
        
        SetState(state)
        
        ToggleButton.MouseButton1Click:Connect(function()
            ModernCircleClick(ToggleButton, Mouse.X, Mouse.Y)
            SetState(not state)
        end)
        
        UpdateContentSize()
        
        local toggleFunc = {
            Value = state,
            Set = SetState,
            Type = "Toggle",
            Id = elementId
        }
        
        if elementId then
            AllElements[elementId] = toggleFunc
        end
        
        return toggleFunc
    end
    
    -- Input creator
    local function CreateInput(tabContainer, title, content, placeholder, callback, elementId)
        if not tabContainer or not tabContainer:IsA("Frame") then return end
        
        local Input = Instance.new("Frame")
        Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Input.BackgroundTransparency = 0.3
        Input.BorderSizePixel = 0
        Input.Size = UDim2.new(1, 0, 0, 0)
        Input.AutomaticSize = Enum.AutomaticSize.Y
        Input.Name = "Input"
        Input.Parent = tabContainer
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 8)
        InputCorner.Parent = Input
        
        local InputTitle = Instance.new("TextLabel")
        InputTitle.Font = Enum.Font.GothamBold
        InputTitle.Text = title
        InputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        InputTitle.TextSize = 14
        InputTitle.TextXAlignment = Enum.TextXAlignment.Left
        InputTitle.BackgroundTransparency = 1
        InputTitle.Position = UDim2.new(0, 14, 0, 12)
        InputTitle.Size = UDim2.new(1, -150, 0, 16)
        InputTitle.Name = "InputTitle"
        InputTitle.Parent = Input
        
        local InputContent = Instance.new("TextLabel")
        InputContent.Font = Enum.Font.Gotham
        InputContent.Text = content
        InputContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        InputContent.TextSize = 13
        InputContent.TextWrapped = true
        InputContent.TextXAlignment = Enum.TextXAlignment.Left
        InputContent.BackgroundTransparency = 1
        InputContent.Position = UDim2.new(0, 14, 0, 32)
        InputContent.Size = UDim2.new(1, -150, 0, 0)
        InputContent.AutomaticSize = Enum.AutomaticSize.Y
        InputContent.Name = "InputContent"
        InputContent.Parent = Input
        
        local InputBoxFrame = Instance.new("Frame")
        InputBoxFrame.AnchorPoint = Vector2.new(1, 0.5)
        InputBoxFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        InputBoxFrame.BackgroundTransparency = 0.3
        InputBoxFrame.BorderSizePixel = 0
        InputBoxFrame.Position = UDim2.new(1, -15, 0.5, 0)
        InputBoxFrame.Size = UDim2.new(0, 150, 0, 36)
        InputBoxFrame.Parent = Input
        
        local InputBoxCorner = Instance.new("UICorner")
        InputBoxCorner.CornerRadius = UDim.new(0, 8)
        InputBoxCorner.Parent = InputBoxFrame
        
        local TextBox = Instance.new("TextBox")
        TextBox.Font = Enum.Font.Gotham
        TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        TextBox.PlaceholderText = placeholder or "Type here..."
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 13
        TextBox.TextXAlignment = Enum.TextXAlignment.Left
        TextBox.BackgroundTransparency = 1
        TextBox.Size = UDim2.new(1, -16, 1, -8)
        TextBox.Position = UDim2.new(0, 8, 0.5, 0)
        TextBox.AnchorPoint = Vector2.new(0, 0.5)
        TextBox.Parent = InputBoxFrame
        
        -- Focus effect
        TextBox.Focused:Connect(function()
            TweenService:Create(InputBoxFrame, TweenInfo.new(0.2), 
                {BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]}):Play()
        end)
        
        TextBox.FocusLost:Connect(function()
            TweenService:Create(InputBoxFrame, TweenInfo.new(0.2), 
                {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end)
        
        local inputFunc = {
            Value = "",
            Type = "Input",
            Id = elementId
        }
        
        function inputFunc:Set(value)
            TextBox.Text = value
            inputFunc.Value = value
            if callback then callback(value) end
        end
        
        TextBox.FocusLost:Connect(function()
            inputFunc:Set(TextBox.Text)
        end)
        
        UpdateContentSize()
        
        if elementId then
            AllElements[elementId] = inputFunc
        end
        
        return inputFunc
    end
    
    -- Dropdown creator
    local function CreateDropdown(tabContainer, title, content, options, multi, defaultValue, callback, elementId)
        if not tabContainer or not tabContainer:IsA("Frame") then return end
        
        local Dropdown = Instance.new("Frame")
        Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Dropdown.BackgroundTransparency = 0.3
        Dropdown.BorderSizePixel = 0
        Dropdown.Size = UDim2.new(1, 0, 0, 0)
        Dropdown.AutomaticSize = Enum.AutomaticSize.Y
        Dropdown.Name = "Dropdown"
        Dropdown.Parent = tabContainer
        
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 8)
        DropdownCorner.Parent = Dropdown
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Size = UDim2.new(1, 0, 1, 0)
        DropdownButton.Text = ""
        DropdownButton.Parent = Dropdown
        
        local DropdownTitle = Instance.new("TextLabel")
        DropdownTitle.Font = Enum.Font.GothamBold
        DropdownTitle.Text = title
        DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownTitle.TextSize = 14
        DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
        DropdownTitle.BackgroundTransparency = 1
        DropdownTitle.Position = UDim2.new(0, 14, 0, 12)
        DropdownTitle.Size = UDim2.new(1, -150, 0, 16)
        DropdownTitle.Name = "DropdownTitle"
        DropdownTitle.Parent = Dropdown
        
        local DropdownContent = Instance.new("TextLabel")
        DropdownContent.Font = Enum.Font.Gotham
        DropdownContent.Text = content
        DropdownContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        DropdownContent.TextSize = 13
        DropdownContent.TextWrapped = true
        DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
        DropdownContent.BackgroundTransparency = 1
        DropdownContent.Position = UDim2.new(0, 14, 0, 32)
        DropdownContent.Size = UDim2.new(1, -150, 0, 0)
        DropdownContent.AutomaticSize = Enum.AutomaticSize.Y
        DropdownContent.Name = "DropdownContent"
        DropdownContent.Parent = Dropdown
        
        local SelectFrame = Instance.new("Frame")
        SelectFrame.AnchorPoint = Vector2.new(1, 0.5)
        SelectFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SelectFrame.BackgroundTransparency = 0.3
        SelectFrame.BorderSizePixel = 0
        SelectFrame.Position = UDim2.new(1, -15, 0.5, 0)
        SelectFrame.Size = UDim2.new(0, 150, 0, 36)
        SelectFrame.Parent = Dropdown
        
        local SelectCorner = Instance.new("UICorner")
        SelectCorner.CornerRadius = UDim.new(0, 8)
        SelectCorner.Parent = SelectFrame
        
        local SelectedText = Instance.new("TextLabel")
        SelectedText.Font = Enum.Font.Gotham
        SelectedText.Text = "Select Option"
        SelectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
        SelectedText.TextSize = 13
        SelectedText.TextXAlignment = Enum.TextXAlignment.Left
        SelectedText.BackgroundTransparency = 1
        SelectedText.Size = UDim2.new(1, -40, 1, -8)
        SelectedText.Position = UDim2.new(0, 8, 0.5, 0)
        SelectedText.AnchorPoint = Vector2.new(0, 0.5)
        SelectedText.Parent = SelectFrame
        
        local Arrow = Instance.new("ImageLabel")
        Arrow.Image = "rbxassetid://16851841101"
        Arrow.ImageColor3 = Color3.fromRGB(180, 180, 180)
        Arrow.BackgroundTransparency = 1
        Arrow.Size = UDim2.new(0, 20, 0, 20)
        Arrow.Position = UDim2.new(1, -25, 0.5, 0)
        Arrow.AnchorPoint = Vector2.new(1, 0.5)
        Arrow.Parent = SelectFrame
        
        -- Dropdown list
        local DropdownList = Instance.new("Frame")
        DropdownList.AnchorPoint = Vector2.new(1, 0)
        DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DropdownList.BorderSizePixel = 0
        DropdownList.Position = UDim2.new(1, -15, 0, 45)
        DropdownList.Size = UDim2.new(0, 180, 0, 0)
        DropdownList.Visible = false
        DropdownList.ClipsDescendants = true
        DropdownList.ZIndex = 10
        DropdownList.Parent = ScreenGui
        
        local ListCorner = Instance.new("UICorner")
        ListCorner.CornerRadius = UDim.new(0, 8)
        ListCorner.Parent = DropdownList
        
        local ListStroke = Instance.new("UIStroke")
        ListStroke.Color = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
        ListStroke.Thickness = 2
        ListStroke.Transparency = 0.5
        ListStroke.Parent = DropdownList
        
        local ListScroll = Instance.new("ScrollingFrame")
        ListScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        ListScroll.ScrollBarThickness = 4
        ListScroll.Active = true
        ListScroll.BackgroundTransparency = 1
        ListScroll.BorderSizePixel = 0
        ListScroll.Size = UDim2.new(1, -10, 1, -10)
        ListScroll.Position = UDim2.new(0, 5, 0, 5)
        ListScroll.Name = "ListScroll"
        ListScroll.ZIndex = 11
        ListScroll.Parent = DropdownList
        
        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 5)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = ListScroll
        
        table.insert(ConfigSystem.DropdownElements, Dropdown)
        
        local dropdownData = {
            Options = options or {},
            Value = multi and (defaultValue or {}) or defaultValue or nil,
            Multi = multi or false,
            Open = false
        }
        
        local function UpdateListSize()
            local totalHeight = 0
            for _, child in ListScroll:GetChildren() do
                if child:IsA("Frame") then
                    totalHeight = totalHeight + child.Size.Y.Offset + 5
                end
            end
            ListScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
            DropdownList.Size = UDim2.new(0, 180, 0, math.min(200, totalHeight + 15))
        end
        
        local function UpdateSelectedDisplay()
            if dropdownData.Multi then
                if #dropdownData.Value > 0 then
                    local displayText = ""
                    for i, v in ipairs(dropdownData.Value) do
                        if i > 2 then
                            displayText = displayText .. ", ..."
                            break
                        end
                        displayText = displayText .. (i > 1 and ", " or "") .. v
                    end
                    SelectedText.Text = displayText
                else
                    SelectedText.Text = "Select Option"
                end
            else
                SelectedText.Text = dropdownData.Value or "Select Option"
            end
        end
        
        local function ToggleDropdown()
            dropdownData.Open = not dropdownData.Open
            if dropdownData.Open then
                local dropdownAbsPos = Dropdown.AbsolutePosition
                local dropdownAbsSize = Dropdown.AbsoluteSize
                DropdownList.Position = UDim2.new(0, dropdownAbsPos.X + dropdownAbsSize.X - 195, 0, dropdownAbsPos.Y + dropdownAbsSize.Y + 5)
                
                DropdownList.Visible = true
                TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
                    {Size = UDim2.new(0, 180, 0, math.min(200, ListScroll.CanvasSize.Y.Offset + 15))}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            else
                TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
                    {Size = UDim2.new(0, 180, 0, 0)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                wait(0.3)
                DropdownList.Visible = false
            end
        end
        
        local function CreateOption(optionName)
            local Option = Instance.new("Frame")
            Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Option.BackgroundTransparency = 1
            Option.BorderSizePixel = 0
            Option.Size = UDim2.new(1, 0, 0, 35)
            Option.Name = "Option"
            Option.ZIndex = 12
            Option.Parent = ListScroll
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 6)
            OptionCorner.Parent = Option
            
            local OptionButton = Instance.new("TextButton")
            OptionButton.BackgroundTransparency = 1
            OptionButton.Size = UDim2.new(1, 0, 1, 0)
            OptionButton.Text = ""
            OptionButton.ZIndex = 13
            OptionButton.Parent = Option
            
            local OptionText = Instance.new("TextLabel")
            OptionText.Font = Enum.Font.Gotham
            OptionText.Text = optionName
            OptionText.TextSize = 13
            OptionText.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptionText.TextXAlignment = Enum.TextXAlignment.Left
            OptionText.BackgroundTransparency = 1
            OptionText.Position = UDim2.new(0, 12, 0, 9)
            OptionText.Size = UDim2.new(1, -40, 0, 16)
            OptionText.ZIndex = 14
            OptionText.Parent = Option
            
            local CheckIcon = Instance.new("ImageLabel")
            CheckIcon.Image = "rbxassetid://111662964379929"
            CheckIcon.ImageColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
            CheckIcon.BackgroundTransparency = 1
            CheckIcon.Size = UDim2.new(0, 16, 0, 16)
            CheckIcon.Position = UDim2.new(1, -25, 0.5, 0)
            CheckIcon.AnchorPoint = Vector2.new(1, 0.5)
            CheckIcon.Visible = false
            CheckIcon.ZIndex = 15
            CheckIcon.Parent = Option
            
            local function UpdateOptionVisual()
                local isSelected = false
                if dropdownData.Multi then
                    isSelected = table.find(dropdownData.Value, optionName) ~= nil
                else
                    isSelected = dropdownData.Value == optionName
                end
                
                OptionText.TextColor3 = isSelected and ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme] or Color3.fromRGB(200, 200, 200)
                CheckIcon.Visible = isSelected
            end
            
            OptionButton.MouseButton1Click:Connect(function()
                ModernCircleClick(OptionButton, Mouse.X, Mouse.Y)
                
                if dropdownData.Multi then
                    local index = table.find(dropdownData.Value, optionName)
                    if index then
                        table.remove(dropdownData.Value, index)
                    else
                        table.insert(dropdownData.Value, optionName)
                    end
                else
                    dropdownData.Value = optionName
                end
                
                -- Update all options
                for _, child in ListScroll:GetChildren() do
                    if child:IsA("Frame") and child.Name == "Option" then
                        local childText = child:FindFirstChild("OptionText")
                        local childIcon = child:FindFirstChild("CheckIcon")
                        if childText and childIcon then
                            local isChildSelected = false
                            if dropdownData.Multi then
                                isChildSelected = table.find(dropdownData.Value, childText.Text) ~= nil
                            else
                                isChildSelected = dropdownData.Value == childText.Text
                            end
                            childText.TextColor3 = isChildSelected and ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme] or Color3.fromRGB(200, 200, 200)
                            childIcon.Visible = isChildSelected
                        end
                    end
                end
                
                UpdateSelectedDisplay()
                
                if callback then
                    callback(dropdownData.Value)
                end
                
                if not dropdownData.Multi then
                    ToggleDropdown()
                end
            end)
            
            UpdateOptionVisual()
            return Option
        end
        
        for _, option in ipairs(dropdownData.Options) do
            CreateOption(option)
        end
        
        UpdateListSize()
        UpdateSelectedDisplay()
        
        DropdownButton.MouseButton1Click:Connect(function()
            ModernCircleClick(DropdownButton, Mouse.X, Mouse.Y)
            ToggleDropdown()
        end)
        
        -- Close dropdown when clicking outside
        local dropdownConnection
        dropdownConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dropdownData.Open and DropdownList.Visible then
                    local mousePos = input.Position
                    local dropdownPos = DropdownList.AbsolutePosition
                    local dropdownSize = DropdownList.AbsoluteSize
                    local selectFramePos = SelectFrame.AbsolutePosition
                    local selectFrameSize = SelectFrame.AbsoluteSize
                    
                    if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                           mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) and
                       not (mousePos.X >= selectFramePos.X and mousePos.X <= selectFramePos.X + selectFrameSize.X and
                           mousePos.Y >= selectFramePos.Y and mousePos.Y <= selectFramePos.Y + selectFrameSize.Y) then
                        ToggleDropdown()
                    end
                end
            end
        end)
        
        Dropdown.Destroying:Connect(function()
            if dropdownConnection then
                dropdownConnection:Disconnect()
            end
            DropdownList:Destroy()
        end)
        
        UpdateContentSize()
        
        local dropdownFunc = {
            Value = dropdownData.Value,
            Options = dropdownData.Options,
            Type = "Dropdown",
            Id = elementId
        }
        
        function dropdownFunc:Set(value)
            if dropdownData.Multi then
                dropdownData.Value = value or {}
            else
                dropdownData.Value = value
            end
            UpdateSelectedDisplay()
            
            for _, child in ListScroll:GetChildren() do
                if child:IsA("Frame") and child.Name == "Option" then
                    local childText = child:FindFirstChild("OptionText")
                    local childIcon = child:FindFirstChild("CheckIcon")
                    if childText and childIcon then
                        local isChildSelected = false
                        if dropdownData.Multi then
                            isChildSelected = table.find(dropdownData.Value, childText.Text) ~= nil
                        else
                            isChildSelected = dropdownData.Value == childText.Text
                        end
                        childText.TextColor3 = isChildSelected and ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme] or Color3.fromRGB(200, 200, 200)
                        childIcon.Visible = isChildSelected
                    end
                end
            end
        end
        
        function dropdownFunc:Refresh(newOptions, newValue)
            for _, child in ListScroll:GetChildren() do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
            
            dropdownData.Options = newOptions or {}
            dropdownData.Value = newValue or (dropdownData.Multi and {} or nil)
            
            for _, option in ipairs(dropdownData.Options) do
                CreateOption(option)
            end
            
            UpdateListSize()
            UpdateSelectedDisplay()
            dropdownFunc.Value = dropdownData.Value
            dropdownFunc.Options = dropdownData.Options
        end
        
        if elementId then
            AllElements[elementId] = dropdownFunc
        end
        
        return dropdownFunc
    end
    
    -- Slider creator
    local function CreateSlider(tabContainer, title, content, minValue, maxValue, defaultValue, callback, elementId)
        if not tabContainer or not tabContainer:IsA("Frame") then return end
        
        local Slider = Instance.new("Frame")
        Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Slider.BackgroundTransparency = 0.3
        Slider.BorderSizePixel = 0
        Slider.Size = UDim2.new(1, 0, 0, 0)
        Slider.AutomaticSize = Enum.AutomaticSize.Y
        Slider.Name = "Slider"
        Slider.Parent = tabContainer
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = Slider
        
        local SliderTitle = Instance.new("TextLabel")
        SliderTitle.Font = Enum.Font.GothamBold
        SliderTitle.Text = title
        SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderTitle.TextSize = 14
        SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
        SliderTitle.BackgroundTransparency = 1
        SliderTitle.Position = UDim2.new(0, 14, 0, 12)
        SliderTitle.Size = UDim2.new(1, -100, 0, 16)
        SliderTitle.Name = "SliderTitle"
        SliderTitle.Parent = Slider
        
        local SliderContent = Instance.new("TextLabel")
        SliderContent.Font = Enum.Font.Gotham
        SliderContent.Text = content
        SliderContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        SliderContent.TextSize = 13
        SliderContent.TextWrapped = true
        SliderContent.TextXAlignment = Enum.TextXAlignment.Left
        SliderContent.BackgroundTransparency = 1
        SliderContent.Position = UDim2.new(0, 14, 0, 32)
        SliderContent.Size = UDim2.new(1, -100, 0, 0)
        SliderContent.AutomaticSize = Enum.AutomaticSize.Y
        SliderContent.Name = "SliderContent"
        SliderContent.Parent = Slider
        
        local ValueDisplay = Instance.new("TextLabel")
        ValueDisplay.Font = Enum.Font.GothamBold
        ValueDisplay.Text = tostring(defaultValue or minValue)
        ValueDisplay.TextColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
        ValueDisplay.TextSize = 14
        ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
        ValueDisplay.BackgroundTransparency = 1
        ValueDisplay.Position = UDim2.new(1, -80, 0, 12)
        ValueDisplay.Size = UDim2.new(0, 60, 0, 16)
        ValueDisplay.Name = "ValueDisplay"
        ValueDisplay.Parent = Slider
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.AnchorPoint = Vector2.new(0, 0)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SliderFrame.BackgroundTransparency = 0.5
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Position = UDim2.new(0, 14, 0, 60)
        SliderFrame.Size = UDim2.new(1, -100, 0, 4)
        SliderFrame.Name = "SliderFrame"
        SliderFrame.Parent = Slider
        
        local SliderFrameCorner = Instance.new("UICorner")
        SliderFrameCorner.CornerRadius = UDim.new(0, 2)
        SliderFrameCorner.Parent = SliderFrame
        
        local SliderFill = Instance.new("Frame")
        SliderFill.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
        SliderFill.BorderSizePixel = 0
        SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        SliderFill.Name = "SliderFill"
        SliderFill.Parent = SliderFrame
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0, 2)
        FillCorner.Parent = SliderFill
        
        local SliderCircle = Instance.new("Frame")
        SliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        SliderCircle.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
        SliderCircle.BorderSizePixel = 0
        SliderCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
        SliderCircle.Size = UDim2.new(0, 16, 0, 16)
        SliderCircle.Name = "SliderCircle"
        SliderCircle.Parent = SliderFrame
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(0, 8)
        CircleCorner.Parent = SliderCircle
        
        local CircleStroke = Instance.new("UIStroke")
        CircleStroke.Color = Color3.fromRGB(255, 255, 255)
        CircleStroke.Thickness = 2
        CircleStroke.Parent = SliderCircle
        
        table.insert(ConfigSystem.SliderElements, SliderFrame)
        
        local sliderData = {
            Min = minValue or 0,
            Max = maxValue or 100,
            Value = defaultValue or minValue or 0,
            Dragging = false
        }
        
        local function SetValue(value, instant)
            value = math.clamp(value, sliderData.Min, sliderData.Max)
            sliderData.Value = math.floor(value)
            
            ValueDisplay.Text = tostring(sliderData.Value)
            
            local percentage = (sliderData.Value - sliderData.Min) / (sliderData.Max - sliderData.Min)
            
            if instant then
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderCircle.Position = UDim2.new(percentage, 0, 0.5, 0)
            else
                TweenService:Create(SliderFill, TweenInfo.new(0.15), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
                TweenService:Create(SliderCircle, TweenInfo.new(0.15), {Position = UDim2.new(percentage, 0, 0.5, 0)}):Play()
            end
            
            if callback then callback(sliderData.Value) end
        end
        
        SetValue(defaultValue or minValue or 0, true)
        
        local function UpdateSlider(input)
            local inputPos = input.Position
            local sliderPos = SliderFrame.AbsolutePosition
            local sliderSize = SliderFrame.AbsoluteSize
            
            local percentage = math.clamp((inputPos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = sliderData.Min + (percentage * (sliderData.Max - sliderData.Min))
            
            SetValue(value)
        end
        
        SliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliderData.Dragging = true
                UpdateSlider(input)
                
                TweenService:Create(SliderCircle, TweenInfo.new(0.2), {Size = UDim2.new(0, 20, 0, 20)}):Play()
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliderData.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliderData.Dragging = false
                TweenService:Create(SliderCircle, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)}):Play()
            end
        end)
        
        UpdateContentSize()
        
        local sliderFunc = {
            Value = sliderData.Value,
            Type = "Slider",
            Id = elementId
        }
        
        function sliderFunc:Set(value)
            SetValue(value)
            sliderFunc.Value = sliderData.Value
        end
        
        if elementId then
            AllElements[elementId] = sliderFunc
        end
        
        return sliderFunc
    end
    
    -- Tab creator
    local function CreateTabButton(tabName, iconId, isConfigTab)
        TabCount = TabCount + 1
        
        local Tab = Instance.new("Frame")
        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Tab.BackgroundTransparency = 1
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(1, 0, 0, 40)
        Tab.LayoutOrder = isConfigTab and 999 or TabCount
        Tab.Name = "Tab"
        Tab.Parent = TabScroll
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = Tab
        
        local TabButton = Instance.new("TextButton")
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Text = ""
        TabButton.Parent = Tab
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Image = iconId or "rbxassetid://111662964379929"
        TabIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 12, 0.5, 0)
        TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabIcon.Parent = Tab
        
        local TabName = Instance.new("TextLabel")
        TabName.Font = Enum.Font.Gotham
        TabName.Text = tabName
        TabName.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabName.TextSize = 14
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.BackgroundTransparency = 1
        TabName.Size = UDim2.new(1, -45, 1, 0)
        TabName.Position = UDim2.new(0, 40, 0, 0)
        TabName.Parent = Tab
        
        local ActiveIndicator = Instance.new("Frame")
        ActiveIndicator.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
        ActiveIndicator.BorderSizePixel = 0
        ActiveIndicator.Position = UDim2.new(0, 0, 0, 8)
        ActiveIndicator.Size = UDim2.new(0, 3, 0, 24)
        ActiveIndicator.Visible = false
        ActiveIndicator.Parent = Tab
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 2)
        IndicatorCorner.Parent = ActiveIndicator
        
        table.insert(ConfigSystem.TabElements, Tab)
        
        local TabContentContainer = Instance.new("Frame")
        TabContentContainer.BackgroundTransparency = 1
        TabContentContainer.Size = UDim2.new(1, 0, 0, 0)
        TabContentContainer.Visible = false
        TabContentContainer.LayoutOrder = isConfigTab and 999 or TabCount
        TabContentContainer.Name = tabName.."Content"
        TabContentContainer.Parent = ContentScroll
        
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 12)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = TabContentContainer
        
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContentContainer.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
            UpdateContentSize()
        end)
        
        TabContents[tabName] = TabContentContainer
        
        local function SwitchToTab()
            for _, container in pairs(TabContents) do
                container.Visible = false
            end
            
            for _, tabFrame in TabScroll:GetChildren() do
                if tabFrame:IsA("Frame") and tabFrame.Name == "Tab" then
                    local indicator = tabFrame:FindFirstChild("ActiveIndicator")
                    local icon = tabFrame:FindFirstChild("TabIcon")
                    local nameLabel = tabFrame:FindFirstChild("TabName")
                    
                    if indicator then indicator.Visible = false end
                    if icon then icon.ImageColor3 = Color3.fromRGB(200, 200, 200) end
                    if nameLabel then nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200) end
                end
            end
            
            TabContentContainer.Visible = true
            ActiveIndicator.Visible = true
            TabIcon.ImageColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
            TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
            ContentTitle.Text = tabName
            CurrentTab = tabName
            UpdateContentSize()
        end
        
        TabButton.MouseButton1Click:Connect(function()
            ModernCircleClick(TabButton, Mouse.X, Mouse.Y)
            SwitchToTab()
        end)
        
        return TabContentContainer, SwitchToTab
    end
    
    -- Create Config tab
    local ConfigTabContainer, SwitchToConfigTab = CreateTabButton("⚙️ Config", "rbxassetid://111662964379929", true)
    
    CreateParagraph(ConfigTabContainer, "Configuration System", "Manage your UI settings, themes, and configurations.")
    
    local themeNames = {}
    for themeName, _ in pairs(ConfigSystem.ThemeColors) do
        table.insert(themeNames, themeName)
    end
    
    local CurrentConfigName = ""
    
    local ThemeDropdown = CreateDropdown(ConfigTabContainer, "Theme", "Select UI theme color", themeNames, false, ConfigSystem.CurrentTheme, function(value)
        local success, themeColor = ConfigSystem:SetTheme(value)
        if success then
            ModernNotify({
                Title = "🎨 Theme",
                Description = "Changed",
                Content = "Theme changed to " .. value .. "!",
                Color = themeColor,
                Icon = "rbxassetid://111662964379929",
                Delay = 3
            })
            
            -- Update open button color
            TweenService:Create(OpenButton, TweenInfo.new(0.3), {ImageColor3 = themeColor}):Play()
            TweenService:Create(OpenStroke, TweenInfo.new(0.3), {Color = themeColor}):Play()
        end
    end, "ThemeDropdown")
    
    local TransparencyToggle = CreateToggle(ConfigTabContainer, "Glass Effect", "Toggle UI transparency/glass effect", false, function(state)
        if state then
            TweenService:Create(Main, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.4), {Transparency = 0.5}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.4), {BackgroundTransparency = 0.05}):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
        end
    end, "TransparencyToggle")
    
    local ConfigNameInput = CreateInput(ConfigTabContainer, "Config Name", "Enter name for your configuration", "MyConfig", function(value)
        CurrentConfigName = value
    end, "ConfigNameInput")
    
    CreateButton(ConfigTabContainer, "💾 Save Config", "Save current settings to config", "rbxassetid://111662964379929", function()
        if CurrentConfigName and CurrentConfigName ~= "" then
            local configData = {}
            for id, element in pairs(AllElements) do
                if element.Type == "Toggle" then
                    configData[id] = element.Value
                elseif element.Type == "Slider" then
                    configData[id] = element.Value
                elseif element.Type == "Dropdown" then
                    configData[id] = element.Value
                elseif element.Type == "Input" then
                    configData[id] = element.Value
                end
            end
            
            local notifyData = ConfigSystem:SaveConfig(CurrentConfigName, configData)
            ModernNotify(notifyData)
            
            local configList = ConfigSystem:GetConfigList()
            LoadConfigDropdown:Refresh(configList)
            DeleteConfigDropdown:Refresh(configList)
        else
            ModernNotify({
                Title = "⚠️ Error",
                Description = "Config Name Required",
                Content = "Please enter a config name first!",
                Color = Color3.fromRGB(255, 50, 50),
                Icon = "rbxassetid://111662964379929",
                Delay = 3
            })
        end
    end)
    
    local LoadConfigDropdown = CreateDropdown(ConfigTabContainer, "📂 Load Config", "Select config to load", {}, false, nil, function(value)
        if value then
            local notifyData, configData = ConfigSystem:LoadConfig(value)
            ModernNotify(notifyData)
            
            if configData then
                for id, val in pairs(configData) do
                    if AllElements[id] then
                        AllElements[id]:Set(val)
                    end
                end
                ThemeDropdown:Set(ConfigSystem.CurrentTheme)
            end
        end
    end, "LoadConfigDropdown")
    
    local DeleteConfigDropdown = CreateDropdown(ConfigTabContainer, "🗑️ Delete Config", "Select config to delete", {}, false, nil, function(value)
        if value then
            local notifyData = ConfigSystem:DeleteConfig(value)
            ModernNotify(notifyData)
            
            local configList = ConfigSystem:GetConfigList()
            LoadConfigDropdown:Refresh(configList)
            DeleteConfigDropdown:Refresh(configList)
        end
    end, "DeleteConfigDropdown")
    
    CreateParagraph(ConfigTabContainer, "📌 Note", "Configs are saved locally for this session. For permanent storage, implement DataStore.")
    
    -- Switch to first tab automatically
    task.wait(0.1)
    for _, tabFrame in TabScroll:GetChildren() do
        if tabFrame:IsA("Frame") and tabFrame.Name == "Tab" then
            local tabButton = tabFrame:FindFirstChild("TabButton")
            if tabButton then
                tabButton.MouseButton1Click:Fire()
                break
            end
        end
    end
    
    -- Window API
    local Window = {}
    
    function Window:CreateTab(tabName, iconId)
        return CreateTabButton(tabName, iconId, false)
    end
    
    function Window:AddParagraph(tabContainer, title, content)
        return CreateParagraph(tabContainer, title, content)
    end
    
    function Window:AddButton(tabContainer, title, content, iconId, callback)
        return CreateButton(tabContainer, title, content, iconId, callback)
    end
    
    function Window:AddToggle(tabContainer, title, content, defaultValue, callback)
        return CreateToggle(tabContainer, title, content, defaultValue, callback)
    end
    
    function Window:AddInput(tabContainer, title, content, placeholder, callback)
        return CreateInput(tabContainer, title, content, placeholder, callback)
    end
    
    function Window:AddDropdown(tabContainer, title, content, options, multi, defaultValue, callback)
        return CreateDropdown(tabContainer, title, content, options, multi, defaultValue, callback)
    end
    
    function Window:AddSlider(tabContainer, title, content, minValue, maxValue, defaultValue, callback)
        return CreateSlider(tabContainer, title, content, minValue, maxValue, defaultValue, callback)
    end
    
    function Window:Notify(notifyConfig)
        return ModernNotify(notifyConfig)
    end
    
    function Window:SetTheme(themeName)
        return ConfigSystem:SetTheme(themeName)
    end
    
    function Window:SaveConfig(name)
        local configData = {}
        for id, element in pairs(AllElements) do
            if element.Type == "Toggle" then
                configData[id] = element.Value
            elseif element.Type == "Slider" then
                configData[id] = element.Value
            elseif element.Type == "Dropdown" then
                configData[id] = element.Value
            elseif element.Type == "Input" then
                configData[id] = element.Value
            end
        end
        local notifyData = ConfigSystem:SaveConfig(name, configData)
        ModernNotify(notifyData)
    end
    
    function Window:LoadConfig(name)
        local notifyData, configData = ConfigSystem:LoadConfig(name)
        ModernNotify(notifyData)
        if configData then
            for id, val in pairs(configData) do
                if AllElements[id] then
                    AllElements[id]:Set(val)
                end
            end
        end
    end
    
    function Window:DeleteConfig(name)
        local notifyData = ConfigSystem:DeleteConfig(name)
        ModernNotify(notifyData)
    end
    
    function Window:GetConfigs()
        return ConfigSystem:GetConfigList()
    end
    
    function Window:Destroy()
        TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(OpenButton, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
        OpenButton.Parent:Destroy()
    end
    
    return Window
end

return Cyrus
