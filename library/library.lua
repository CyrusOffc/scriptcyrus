local CyioxUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui") or LocalPlayer.PlayerGui
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local ConfigFolder = "CyioxConfigs"

local KeySystemData = {
    SavedKey = nil,
    IsAuthenticated = false
}

local WatermarkData = {
    Active = false,
    Frame = nil,
    UpdateConnection = nil
}

local function CircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Circle.ImageTransparency = 0.85
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Name = "Circle"
        Circle.Parent = Button
        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2
        local Time = 0.45
        Circle:TweenSizeAndPosition(
            UDim2.new(0, Size, 0, Size),
            UDim2.new(0.5, -Size/2, 0.5, -Size/2),
            "Out", "Quad", Time, false, nil
        )
        for i = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.015
            wait(Time / 10)
        end
        Circle:Destroy()
    end)
end

local function MakeDraggable(topbarObject, object)
    local Dragging, DragInput, DragStart, StartPosition
    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            object.Position = UDim2.new(
                StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
            )
        end
    end)
end

local function MakeDraggableMobileButton(button, object, screenGui)
    local Dragging = false
    local DragInput, DragStart, StartPosition
    local ClickStartPos = nil

    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local newX = math.clamp(StartPosition.X.Offset + Delta.X, 10, screenGui.AbsoluteSize.X - object.AbsoluteSize.X - 10)
        local newY = math.clamp(StartPosition.Y.Offset + Delta.Y, 10, screenGui.AbsoluteSize.Y - object.AbsoluteSize.Y - 10)
        object.Position = UDim2.new(0, newX, 0, newY)
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
            ClickStartPos = input.Position
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if ClickStartPos and not Dragging and (input.Position - ClickStartPos).Magnitude > 5 then
                Dragging = true
            end
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then UpdatePos(input) end
    end)
    return function() return Dragging end
end

-- CONFIG SYSTEM
local ConfigSystem = {
    CurrentConfig = nil,
    ThemeColors = {
        ["Default"]  = Color3.fromRGB(255, 0, 255),
        ["Blue"]     = Color3.fromRGB(0, 120, 255),
        ["Red"]      = Color3.fromRGB(255, 50, 50),
        ["Green"]    = Color3.fromRGB(0, 200, 80),
        ["Orange"]   = Color3.fromRGB(255, 120, 0),
        ["Purple"]   = Color3.fromRGB(160, 0, 255),
        ["Cyan"]     = Color3.fromRGB(0, 200, 255),
        ["Pink"]     = Color3.fromRGB(255, 100, 200),
        ["Gold"]     = Color3.fromRGB(255, 200, 0),
        ["Emerald"]  = Color3.fromRGB(0, 200, 150),
        ["Crimson"]  = Color3.fromRGB(200, 0, 50),
        ["Lavender"] = Color3.fromRGB(180, 130, 255),
        ["Teal"]     = Color3.fromRGB(0, 150, 150),
        ["Neon"]     = Color3.fromRGB(0, 255, 200),
        ["Royal"]    = Color3.fromRGB(100, 0, 200),
        ["Sky"]      = Color3.fromRGB(100, 180, 255),
        ["Amber"]    = Color3.fromRGB(255, 150, 0),
    },
    CurrentTheme = "Default",
    ThemeElements = {},
    ToggleElements = {},
    SliderElements = {},
}

function ConfigSystem:GetColor()
    return self.ThemeColors[self.CurrentTheme] or Color3.fromRGB(255, 0, 255)
end

function ConfigSystem:SetTheme(themeName)
    if self.ThemeColors[themeName] then
        self.CurrentTheme = themeName
        local c = self:GetColor()
        for _, el in pairs(self.ThemeElements) do
            if type(el) == "table" and el.Update then
                pcall(el.Update, c)
            end
        end
        return true, c
    end
    return false, nil
end

function ConfigSystem:EnsureFolder()
    if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
end

function ConfigSystem:SaveConfig(name, data)
    self:EnsureFolder()
    local configData = { Name = name, Theme = self.CurrentTheme, Data = data or {}, SavedAt = os.time() }
    local ok, encoded = pcall(function() return HttpService:JSONEncode(configData) end)
    if ok then
        writefile(ConfigFolder .. "/" .. name .. ".json", encoded)
        self.CurrentConfig = name
        return { Title = "Config", Description = "Saved", Content = "Config '"..name.."' saved!", Color = self:GetColor(), Delay = 3 }
    end
    return { Title = "Config", Description = "Error", Content = "Failed: "..tostring(encoded), Color = Color3.fromRGB(255,50,50), Delay = 3 }
end

function ConfigSystem:LoadConfig(name)
    self:EnsureFolder()
    local filePath = ConfigFolder .. "/" .. name .. ".json"
    if isfile(filePath) then
        local ok, content = pcall(function() return readfile(filePath) end)
        if ok then
            local ok2, config = pcall(function() return HttpService:JSONDecode(content) end)
            if ok2 and config then
                self.CurrentTheme = config.Theme or "Default"
                self.CurrentConfig = name
                return { Title = "Config", Description = "Loaded", Content = "Config '"..name.."' loaded!", Color = self:GetColor(), Delay = 3 }, config.Data
            end
        end
    end
    return { Title = "Config", Description = "Error", Content = "Config '"..name.."' not found!", Color = Color3.fromRGB(255,50,50), Delay = 3 }, nil
end

function ConfigSystem:DeleteConfig(name)
    self:EnsureFolder()
    local filePath = ConfigFolder .. "/" .. name .. ".json"
    if isfile(filePath) then
        pcall(function() delfile(filePath) end)
        if self.CurrentConfig == name then self.CurrentConfig = nil end
        return { Title = "Config", Description = "Deleted", Content = "Config '"..name.."' deleted!", Color = self:GetColor(), Delay = 3 }
    end
    return { Title = "Config", Description = "Error", Content = "Config '"..name.."' not found!", Color = Color3.fromRGB(255,50,50), Delay = 3 }
end

function ConfigSystem:GetConfigList()
    self:EnsureFolder()
    local configs = {}
    local ok, files = pcall(function() return listfiles(ConfigFolder) end)
    if ok and files then
        for _, fp in ipairs(files) do
            local fn = fp:match("([^/\\]+)%.json$")
            if fn then table.insert(configs, fn) end
        end
    end
    return configs
end

-- NOTIFICATION
local function MakeNotify(cfg)
    cfg = cfg or {}
    cfg.Title       = cfg.Title       or "CyioxUI"
    cfg.Description = cfg.Description or "Notification"
    cfg.Content     = cfg.Content     or ""
    cfg.Color       = cfg.Color       or Color3.fromRGB(255, 0, 255)
    cfg.Time        = cfg.Time        or 0.4
    cfg.Delay       = cfg.Delay       or 5

    spawn(function()
        if not CoreGui:FindFirstChild("CyioxNotifyGui") then
            local ng = Instance.new("ScreenGui")
            ng.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ng.Name = "CyioxNotifyGui"
            ng.Parent = CoreGui
        end
        local gui = CoreGui.CyioxNotifyGui

        if not gui:FindFirstChild("NotifyLayout") then
            local nl = Instance.new("Frame")
            nl.AnchorPoint = Vector2.new(1, 1)
            nl.BackgroundTransparency = 1
            nl.BorderSizePixel = 0
            nl.Position = UDim2.new(1, -16, 1, -16)
            nl.Size = UDim2.new(0, 300, 1, 0)
            nl.Name = "NotifyLayout"
            nl.Parent = gui
            local count = 0
            gui.NotifyLayout.ChildRemoved:Connect(function()
                count = 0
                for _, v in gui.NotifyLayout:GetChildren() do
                    if v:IsA("Frame") then
                        TweenService:Create(v, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 10) * count))
                        }):Play()
                        count = count + 1
                    end
                end
            end)
        end

        local layout = gui.NotifyLayout
        local baseY = 0
        for _, v in layout:GetChildren() do
            if v:IsA("Frame") then baseY = -(v.Position.Y.Offset) + v.Size.Y.Offset + 10 end
        end

        local Wrapper = Instance.new("Frame")
        Wrapper.BackgroundTransparency = 1
        Wrapper.BorderSizePixel = 0
        Wrapper.Size = UDim2.new(1, 0, 0, 70)
        Wrapper.AnchorPoint = Vector2.new(0, 1)
        Wrapper.Position = UDim2.new(0, 0, 1, -baseY)
        Wrapper.Name = "NotifyFrame"
        Wrapper.Parent = layout

        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        Card.BorderSizePixel = 0
        Card.Position = UDim2.new(0, 320, 0, 0)
        Card.Size = UDim2.new(1, 0, 1, 0)
        Card.Parent = Wrapper
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

        local CardStroke = Instance.new("UIStroke", Card)
        CardStroke.Color = cfg.Color
        CardStroke.Thickness = 1.2
        CardStroke.Transparency = 0.5

        local Accent = Instance.new("Frame", Card)
        Accent.BackgroundColor3 = cfg.Color
        Accent.BorderSizePixel = 0
        Accent.Size = UDim2.new(0, 3, 0, 36)
        Accent.Position = UDim2.new(0, 0, 0.5, -18)
        Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 4)

        local TitleLbl = Instance.new("TextLabel", Card)
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.Text = cfg.Title
        TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLbl.TextSize = 13
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Position = UDim2.new(0, 14, 0, 10)
        TitleLbl.Size = UDim2.new(1, -80, 0, 16)

        local DescLbl = Instance.new("TextLabel", Card)
        DescLbl.Font = Enum.Font.GothamBold
        DescLbl.Text = cfg.Description
        DescLbl.TextColor3 = cfg.Color
        DescLbl.TextSize = 12
        DescLbl.TextXAlignment = Enum.TextXAlignment.Left
        DescLbl.BackgroundTransparency = 1
        DescLbl.Position = UDim2.new(0, TitleLbl.TextBounds.X + 18, 0, 11)
        DescLbl.Size = UDim2.new(1, -100, 0, 14)

        local ContentLbl = Instance.new("TextLabel", Card)
        ContentLbl.Font = Enum.Font.Gotham
        ContentLbl.Text = cfg.Content
        ContentLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        ContentLbl.TextSize = 11
        ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
        ContentLbl.TextWrapped = true
        ContentLbl.BackgroundTransparency = 1
        ContentLbl.Position = UDim2.new(0, 14, 0, 28)
        ContentLbl.Size = UDim2.new(1, -20, 0, 30)

        local CloseBtn = Instance.new("TextButton", Card)
        CloseBtn.Text = "✕"
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 11
        CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.AnchorPoint = Vector2.new(1, 0)
        CloseBtn.Position = UDim2.new(1, -6, 0, 6)
        CloseBtn.Size = UDim2.new(0, 20, 0, 20)

        local ProgressBg = Instance.new("Frame", Card)
        ProgressBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        ProgressBg.BorderSizePixel = 0
        ProgressBg.Position = UDim2.new(0, 0, 1, -3)
        ProgressBg.Size = UDim2.new(1, 0, 0, 3)
        Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(0, 3)

        local ProgressFill = Instance.new("Frame", ProgressBg)
        ProgressFill.BackgroundColor3 = cfg.Color
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Size = UDim2.new(1, 0, 1, 0)
        Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(0, 3)

        local closed = false
        local function DoClose()
            if closed then return end
            closed = true
            TweenService:Create(Card, TweenInfo.new(cfg.Time, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0, 320, 0, 0)}):Play()
            task.wait(cfg.Time)
            if Wrapper and Wrapper.Parent then Wrapper:Destroy() end
        end

        CloseBtn.Activated:Connect(DoClose)
        TweenService:Create(Card, TweenInfo.new(cfg.Time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(ProgressFill, TweenInfo.new(cfg.Delay, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        task.wait(cfg.Delay)
        DoClose()
    end)
end

-- MAIN UI
local createMainUI

function CyioxUI:CreateWindow(config)
    config = config or {}
    local KeySystemConfig = config.KeySystem or {}

    if ConfigSystem.ThemeColors[config.Theme or "Default"] then
        ConfigSystem.CurrentTheme = config.Theme or "Default"
    end

    local shouldShow = true

    if KeySystemConfig.Enabled then
        shouldShow = false
        local Keys = KeySystemConfig.Keys or {}
        local KeyFileName = KeySystemConfig.FileName or "Cyiox_Key"
        local KeySaveKey = KeySystemConfig.SaveKey ~= false

        if KeySaveKey then
            ConfigSystem:EnsureFolder()
            local path = ConfigFolder .. "/" .. KeyFileName .. ".txt"
            if isfile(path) then
                local saved = readfile(path)
                for _, k in ipairs(Keys) do
                    if saved == k then
                        shouldShow = true
                        KeySystemData.IsAuthenticated = true
                        KeySystemData.SavedKey = saved
                        break
                    end
                end
            end
        end

        if not shouldShow then
            local KeyGui = Instance.new("ScreenGui")
            KeyGui.Name = "CyioxKeySystem"
            KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            KeyGui.Parent = CoreGui

            local Overlay = Instance.new("Frame", KeyGui)
            Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Overlay.BackgroundTransparency = 0.5
            Overlay.BorderSizePixel = 0
            Overlay.Size = UDim2.new(1, 0, 1, 0)

            local Card = Instance.new("Frame", KeyGui)
            Card.AnchorPoint = Vector2.new(0.5, 0.5)
            Card.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
            Card.BorderSizePixel = 0
            Card.Position = UDim2.new(0.5, 0, 0.5, 0)
            Card.Size = UDim2.fromOffset(380, 260)
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

            local CardStroke = Instance.new("UIStroke", Card)
            CardStroke.Color = ConfigSystem:GetColor()
            CardStroke.Thickness = 1.5
            CardStroke.Transparency = 0.4

            local TopBar = Instance.new("Frame", Card)
            TopBar.BackgroundColor3 = ConfigSystem:GetColor()
            TopBar.BorderSizePixel = 0
            TopBar.Size = UDim2.new(1, 0, 0, 3)
            Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

            local LogoLabel = Instance.new("TextLabel", Card)
            LogoLabel.Font = Enum.Font.GothamBlack
            LogoLabel.Text = "CYIOX UI"
            LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            LogoLabel.TextSize = 22
            LogoLabel.BackgroundTransparency = 1
            LogoLabel.Position = UDim2.new(0, 20, 0, 18)
            LogoLabel.Size = UDim2.new(1, -40, 0, 28)
            LogoLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SubLabel = Instance.new("TextLabel", Card)
            SubLabel.Font = Enum.Font.Gotham
            SubLabel.Text = KeySystemConfig.Subtitle or "Enter your key to continue"
            SubLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
            SubLabel.TextSize = 12
            SubLabel.BackgroundTransparency = 1
            SubLabel.Position = UDim2.new(0, 20, 0, 48)
            SubLabel.Size = UDim2.new(1, -40, 0, 16)
            SubLabel.TextXAlignment = Enum.TextXAlignment.Left

            local InputBg = Instance.new("Frame", Card)
            InputBg.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            InputBg.BorderSizePixel = 0
            InputBg.Position = UDim2.new(0, 20, 0, 80)
            InputBg.Size = UDim2.new(1, -40, 0, 42)
            Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 8)
            local InputStroke = Instance.new("UIStroke", InputBg)
            InputStroke.Color = Color3.fromRGB(60, 60, 80)
            InputStroke.Thickness = 1

            local KeyBox = Instance.new("TextBox", InputBg)
            KeyBox.Font = Enum.Font.Gotham
            KeyBox.PlaceholderText = "Enter key here..."
            KeyBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
            KeyBox.Text = ""
            KeyBox.TextColor3 = Color3.fromRGB(220, 220, 220)
            KeyBox.TextSize = 13
            KeyBox.BackgroundTransparency = 1
            KeyBox.Position = UDim2.new(0, 12, 0, 0)
            KeyBox.Size = UDim2.new(1, -24, 1, 0)
            KeyBox.ClearTextOnFocus = false

            KeyBox.Focused:Connect(function()
                TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = ConfigSystem:GetColor()}):Play()
            end)
            KeyBox.FocusLost:Connect(function()
                TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60,60,80)}):Play()
            end)

            local NoteLabel = Instance.new("TextLabel", Card)
            NoteLabel.Font = Enum.Font.Gotham
            NoteLabel.Text = KeySystemConfig.Note or "Get key from discord"
            NoteLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
            NoteLabel.TextSize = 11
            NoteLabel.BackgroundTransparency = 1
            NoteLabel.Position = UDim2.new(0, 20, 0, 130)
            NoteLabel.Size = UDim2.new(1, -40, 0, 14)
            NoteLabel.TextXAlignment = Enum.TextXAlignment.Left

            local StatusLabel = Instance.new("TextLabel", Card)
            StatusLabel.Font = Enum.Font.GothamBold
            StatusLabel.Text = ""
            StatusLabel.TextSize = 11
            StatusLabel.BackgroundTransparency = 1
            StatusLabel.Position = UDim2.new(0, 20, 0, 150)
            StatusLabel.Size = UDim2.new(1, -40, 0, 14)
            StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

            local BtnRow = Instance.new("Frame", Card)
            BtnRow.BackgroundTransparency = 1
            BtnRow.Position = UDim2.new(0, 20, 0, 172)
            BtnRow.Size = UDim2.new(1, -40, 0, 42)

            local function MakeBtn(parent, text, posX, w, primary)
                local Btn = Instance.new("TextButton", parent)
                Btn.Font = Enum.Font.GothamBold
                Btn.Text = text
                Btn.TextSize = 12
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.BackgroundColor3 = primary and ConfigSystem:GetColor() or Color3.fromRGB(30, 30, 40)
                Btn.BorderSizePixel = 0
                Btn.Position = UDim2.new(0, posX, 0, 0)
                Btn.Size = UDim2.new(0, w, 1, 0)
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
                if not primary then
                    local s = Instance.new("UIStroke", Btn)
                    s.Color = Color3.fromRGB(60,60,80)
                    s.Thickness = 1
                end
                return Btn
            end

            local SubmitBtn = MakeBtn(BtnRow, "SUBMIT", 0, 160, true)
            local GetKeyBtn = MakeBtn(BtnRow, "GET KEY", 168, 172, false)

            local function ValidateKey()
                local entered = KeyBox.Text
                for _, k in ipairs(Keys) do
                    if entered == k then
                        StatusLabel.TextColor3 = Color3.fromRGB(0, 220, 100)
                        StatusLabel.Text = "✓ Key valid! Loading..."
                        if KeySaveKey then
                            ConfigSystem:EnsureFolder()
                            writefile(ConfigFolder.."/"..KeyFileName..".txt", entered)
                        end
                        KeySystemData.IsAuthenticated = true
                        KeySystemData.SavedKey = entered
                        task.wait(0.6)
                        TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0,0)}):Play()
                        task.wait(0.3)
                        KeyGui:Destroy()
                        createMainUI(config)
                        return
                    end
                end
                StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
                StatusLabel.Text = "✗ Invalid key. Try again."
                TweenService:Create(InputBg, TweenInfo.new(0.07), {Position = UDim2.new(0, 26, 0, 80)}):Play()
                task.wait(0.07)
                TweenService:Create(InputBg, TweenInfo.new(0.07), {Position = UDim2.new(0, 14, 0, 80)}):Play()
                task.wait(0.07)
                TweenService:Create(InputBg, TweenInfo.new(0.07), {Position = UDim2.new(0, 20, 0, 80)}):Play()
            end

            SubmitBtn.Activated:Connect(ValidateKey)
            KeyBox.FocusLost:Connect(function(enter) if enter then ValidateKey() end end)
            GetKeyBtn.Activated:Connect(function()
                local link = KeySystemConfig.KeyLink or ""
                if link ~= "" then
                    pcall(function() setclipboard(link) end)
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                    StatusLabel.Text = "✓ Link copied!"
                else
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                    StatusLabel.Text = "No key link configured."
                end
            end)

            local CloseX = Instance.new("TextButton", Card)
            CloseX.Text = "✕"
            CloseX.Font = Enum.Font.GothamBold
            CloseX.TextSize = 12
            CloseX.TextColor3 = Color3.fromRGB(120,120,140)
            CloseX.BackgroundTransparency = 1
            CloseX.AnchorPoint = Vector2.new(1, 0)
            CloseX.Position = UDim2.new(1, -10, 0, 10)
            CloseX.Size = UDim2.new(0, 24, 0, 24)
            CloseX.ZIndex = 10
            CloseX.Activated:Connect(function() KeyGui:Destroy() end)

            Card.Size = UDim2.fromOffset(0, 0)
            TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(380, 260)}):Play()
            return nil
        end
    end

    if shouldShow then return createMainUI(config) end
    return nil
end

createMainUI = function(config)
    local Title          = config.Title             or "CyioxUI"
    local Theme          = config.Theme             or "Default"
    local Size           = config.Size              or UDim2.fromOffset(560, 440)
    local Center         = config.Center            ~= false
    local Draggable      = config.Draggable         ~= false
    local MinimizeKey    = config.MinimizeKey        or Enum.KeyCode.RightShift
    local Badges         = config.Badges            or {}
    local MinimizeButton = config.MinimizeButton    ~= false
    local MiniButtonImage = config.MinimizeButton_Image or "rbxassetid://72558237095001"

    if ConfigSystem.ThemeColors[Theme] then ConfigSystem.CurrentTheme = Theme end

    -- Reset theme elements tiap window baru
    ConfigSystem.ThemeElements = {}
    ConfigSystem.ToggleElements = {}
    ConfigSystem.SliderElements = {}

    local function GetColor() return ConfigSystem:GetColor() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name = "CyioxUI"
    ScreenGui.Parent = CoreGui

    -- Shadow
    local ShadowHolder = Instance.new("Frame", ScreenGui)
    ShadowHolder.BackgroundTransparency = 1
    ShadowHolder.BorderSizePixel = 0
    ShadowHolder.Size = Size
    ShadowHolder.Name = "ShadowHolder"
    if Center then
        ShadowHolder.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    end

    local Shadow = Instance.new("ImageLabel", ShadowHolder)
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    Shadow.ImageTransparency = 0.55
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49,49,450,450)
    Shadow.AnchorPoint = Vector2.new(0.5,0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.BorderSizePixel = 0
    Shadow.Position = UDim2.new(0.5,0,0.5,0)
    Shadow.Size = UDim2.new(1,52,1,52)
    Shadow.ZIndex = 0

    -- Main
    local Main = Instance.new("Frame", Shadow)
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.BackgroundColor3 = Color3.fromRGB(13,13,18)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5,0,0.5,0)
    Main.Size = UDim2.new(1,-52,1,-52)
    Main.Name = "Main"
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(40,40,55)
    MainStroke.Thickness = 1.5

    -- Topbar
    local TopBar = Instance.new("Frame", Main)
    TopBar.BackgroundColor3 = Color3.fromRGB(16,16,22)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1,0,0,44)
    TopBar.Name = "TopBar"
    TopBar.ZIndex = 2
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,12)

    -- fill bawah topbar (tutup rounded corner bawah)
    local TopFill = Instance.new("Frame", TopBar)
    TopFill.BackgroundColor3 = Color3.fromRGB(16,16,22)
    TopFill.BorderSizePixel = 0
    TopFill.Position = UDim2.new(0,0,0.5,0)
    TopFill.Size = UDim2.new(1,0,0.5,0)
    TopFill.ZIndex = 2

    -- Accent line atas
    local AccentLine = Instance.new("Frame", Main)
    AccentLine.BackgroundColor3 = GetColor()
    AccentLine.BorderSizePixel = 0
    AccentLine.Position = UDim2.new(0,12,0,0)
    AccentLine.Size = UDim2.new(0,60,0,2)
    AccentLine.ZIndex = 3
    Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(0,2)
    table.insert(ConfigSystem.ThemeElements, {Update = function(c) AccentLine.BackgroundColor3 = c end})

    -- Logo dot
    local LogoDot = Instance.new("Frame", TopBar)
    LogoDot.BackgroundColor3 = GetColor()
    LogoDot.BorderSizePixel = 0
    LogoDot.Position = UDim2.new(0,12,0.5,-5)
    LogoDot.Size = UDim2.new(0,10,0,10)
    LogoDot.ZIndex = 3
    Instance.new("UICorner", LogoDot).CornerRadius = UDim.new(1,0)
    table.insert(ConfigSystem.ThemeElements, {Update = function(c) LogoDot.BackgroundColor3 = c end})

    -- Title
    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(240,240,240)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0,30,0,0)
    TitleLabel.Size = UDim2.new(0.5,0,1,0)
    TitleLabel.ZIndex = 3

    -- Badges
    for _, badgeText in ipairs(Badges) do
        local Badge = Instance.new("TextLabel", TopBar)
        Badge.Font = Enum.Font.GothamBold
        Badge.Text = badgeText
        Badge.TextColor3 = Color3.fromRGB(255,255,255)
        Badge.TextSize = 9
        Badge.BackgroundColor3 = GetColor()
        Badge.BackgroundTransparency = 0.2
        Badge.BorderSizePixel = 0
        local bw = TextService:GetTextSize(badgeText, 9, Enum.Font.GothamBold, Vector2.new(999,999)).X + 10
        Badge.Size = UDim2.new(0,bw,0,16)
        Badge.Position = UDim2.new(0, TitleLabel.TextBounds.X + 36, 0.5, -8)
        Badge.ZIndex = 3
        Instance.new("UICorner", Badge).CornerRadius = UDim.new(0,4)
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) Badge.BackgroundColor3 = c end})
    end

    -- Window control buttons
    local function MakeWinBtn(offsetX, icon, hoverCol)
        local Btn = Instance.new("TextButton", TopBar)
        Btn.Text = ""
        Btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
        Btn.BorderSizePixel = 0
        Btn.AnchorPoint = Vector2.new(1,0.5)
        Btn.Position = UDim2.new(1, offsetX, 0.5, 0)
        Btn.Size = UDim2.new(0,26,0,26)
        Btn.ZIndex = 10
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
        local Lbl = Instance.new("TextLabel", Btn)
        Lbl.Text = icon
        Lbl.Font = Enum.Font.GothamBold
        Lbl.TextSize = 11
        Lbl.TextColor3 = Color3.fromRGB(160,160,180)
        Lbl.BackgroundTransparency = 1
        Lbl.Size = UDim2.new(1,0,1,0)
        Lbl.ZIndex = 11
        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverCol}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35,35,45)}):Play()
        end)
        return Btn, Lbl
    end

    local CloseBtn, _     = MakeWinBtn(-10, "✕", Color3.fromRGB(200,50,50))
    local MinBtn, _       = MakeWinBtn(-44, "—", Color3.fromRGB(50,50,80))
    local MaxBtn, MaxLbl  = MakeWinBtn(-78, "⛶", Color3.fromRGB(50,80,50))

    -- Divider horizontal
    local Divider = Instance.new("Frame", Main)
    Divider.BackgroundColor3 = Color3.fromRGB(30,30,42)
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0,0,0,44)
    Divider.Size = UDim2.new(1,0,0,1)
    Divider.ZIndex = 2

    -- ── SIDEBAR ──
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16,16,22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0,0,0,45)
    Sidebar.Size = UDim2.new(0,130,1,-45)
    Sidebar.Name = "Sidebar"
    Sidebar.ClipsDescendants = true
    Sidebar.ZIndex = 2

    -- ScrollingFrame untuk tab list
    local SidebarScroll = Instance.new("ScrollingFrame", Sidebar)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.Position = UDim2.new(0,0,0,8)
    SidebarScroll.Size = UDim2.new(1,0,1,-16)
    SidebarScroll.CanvasSize = UDim2.new(0,0,0,0)
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.ScrollingEnabled = true
    SidebarScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    -- PENTING: Active = false agar tidak block klik
    SidebarScroll.Active = false
    SidebarScroll.ZIndex = 2

    local SideLayout = Instance.new("UIListLayout", SidebarScroll)
    SideLayout.Padding = UDim.new(0,4)
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarScroll.CanvasSize = UDim2.new(0,0,0, SideLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Divider vertikal sidebar
    local SideDivider = Instance.new("Frame", Main)
    SideDivider.BackgroundColor3 = Color3.fromRGB(30,30,42)
    SideDivider.BorderSizePixel = 0
    SideDivider.Position = UDim2.new(0,130,0,45)
    SideDivider.Size = UDim2.new(0,1,1,-45)
    SideDivider.ZIndex = 2

    -- ── CONTENT AREA ──
    local ContentArea = Instance.new("Frame", Main)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0,140,0,45)
    ContentArea.Size = UDim2.new(1,-148,1,-53)
    ContentArea.Name = "ContentArea"
    ContentArea.ZIndex = 2

    local ContentHeader = Instance.new("TextLabel", ContentArea)
    ContentHeader.Font = Enum.Font.GothamBlack
    ContentHeader.Text = "Welcome"
    ContentHeader.TextColor3 = Color3.fromRGB(220,220,220)
    ContentHeader.TextSize = 18
    ContentHeader.TextXAlignment = Enum.TextXAlignment.Left
    ContentHeader.BackgroundTransparency = 1
    ContentHeader.Position = UDim2.new(0,6,0,4)
    ContentHeader.Size = UDim2.new(1,-12,0,24)
    ContentHeader.ZIndex = 3

    local ContentScroll = Instance.new("ScrollingFrame", ContentArea)
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(60,60,80)
    ContentScroll.ScrollBarThickness = 3
    ContentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentScroll.CanvasSize = UDim2.new(0,0,0,0)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.ClipsDescendants = true
    ContentScroll.Position = UDim2.new(0,0,0,32)
    ContentScroll.Size = UDim2.new(1,0,1,-32)
    ContentScroll.Active = true
    ContentScroll.ZIndex = 2

    local ContentLayout = Instance.new("UIListLayout", ContentScroll)
    ContentLayout.Padding = UDim.new(0,6)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- State
    local TabContents = {}
    local CurrentTab = nil
    local TabCount = 0
    local AllElements = {}

    -- ── TOPBAR ACTIONS ──

    -- Close = destroy UI sepenuhnya
    CloseBtn.Activated:Connect(function()
        TweenService:Create(ShadowHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, Size.X.Offset, 0, 0)
        }):Play()
        task.wait(0.2)
        ScreenGui:Destroy()
    end)

    -- Minimize = sembunyikan (float button akan muncul)
    MinBtn.Activated:Connect(function()
        ShadowHolder.Visible = false
    end)

    local OldPos = ShadowHolder.Position
    local OldSize = ShadowHolder.Size
    local isMaximized = false

    MaxBtn.Activated:Connect(function()
        if not isMaximized then
            isMaximized = true
            MaxLbl.Text = "❐"
            OldPos = ShadowHolder.Position
            OldSize = ShadowHolder.Size
            TweenService:Create(ShadowHolder, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0,0,0,0),
                Size = UDim2.new(1,0,1,0)
            }):Play()
        else
            isMaximized = false
            MaxLbl.Text = "⛶"
            TweenService:Create(ShadowHolder, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Position = OldPos,
                Size = OldSize
            }):Play()
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == MinimizeKey then
            ShadowHolder.Visible = not ShadowHolder.Visible
        end
    end)

    if Draggable then MakeDraggable(TopBar, ShadowHolder) end

    -- ── FLOATING BUTTON ──
    if MinimizeButton then
        local FloatFrame = Instance.new("Frame", ScreenGui)
        FloatFrame.Name = "FloatMinButton"
        FloatFrame.BackgroundColor3 = Color3.fromRGB(14,14,20)
        FloatFrame.BorderSizePixel = 0
        FloatFrame.Size = UDim2.new(0,48,0,48)
        FloatFrame.Position = UDim2.new(0,20,0.5,0)
        FloatFrame.ZIndex = 200
        FloatFrame.Visible = false
        Instance.new("UICorner", FloatFrame).CornerRadius = UDim.new(1,0)

        local FloatStroke = Instance.new("UIStroke", FloatFrame)
        FloatStroke.Color = GetColor()
        FloatStroke.Thickness = 2
        FloatStroke.Transparency = 0.2
        FloatStroke.ZIndex = 200
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) FloatStroke.Color = c end})

        local FloatImg = Instance.new("ImageLabel", FloatFrame)
        FloatImg.Image = MiniButtonImage
        FloatImg.BackgroundTransparency = 1
        FloatImg.Size = UDim2.new(0.6,0,0.6,0)
        FloatImg.Position = UDim2.new(0.2,0,0.2,0)
        FloatImg.ZIndex = 201

        -- Pulse
        local PulseRing = Instance.new("Frame", FloatFrame)
        PulseRing.BackgroundTransparency = 1
        PulseRing.AnchorPoint = Vector2.new(0.5,0.5)
        PulseRing.Position = UDim2.new(0.5,0,0.5,0)
        PulseRing.Size = UDim2.new(1,0,1,0)
        PulseRing.BorderSizePixel = 0
        PulseRing.ZIndex = 199
        Instance.new("UICorner", PulseRing).CornerRadius = UDim.new(1,0)
        local PulseStroke = Instance.new("UIStroke", PulseRing)
        PulseStroke.Color = GetColor()
        PulseStroke.Thickness = 1.5
        PulseStroke.Transparency = 0.6
        PulseStroke.ZIndex = 199
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) PulseStroke.Color = c end})

        spawn(function()
            while FloatFrame and FloatFrame.Parent do
                if FloatFrame.Visible then
                    TweenService:Create(PulseRing, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1.5,0,1.5,0)}):Play()
                    TweenService:Create(PulseStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
                end
                wait(1.2)
                PulseRing.Size = UDim2.new(1,0,1,0)
                PulseStroke.Transparency = 0.6
            end
        end)

        -- Click button
        local ClickDetect = Instance.new("TextButton", FloatFrame)
        ClickDetect.Text = ""
        ClickDetect.BackgroundTransparency = 1
        ClickDetect.Size = UDim2.new(1,0,1,0)
        ClickDetect.ZIndex = 202

        local isDragging = MakeDraggableMobileButton(ClickDetect, FloatFrame, ScreenGui)
        local lastTap = 0

        -- Sync visibility
        ShadowHolder:GetPropertyChangedSignal("Visible"):Connect(function()
            FloatFrame.Visible = not ShadowHolder.Visible
        end)

        ClickDetect.Activated:Connect(function()
            local now = tick()
            if now - lastTap < 0.25 then return end
            lastTap = now
            if not isDragging() then
                ShadowHolder.Visible = true
                TweenService:Create(FloatFrame, TweenInfo.new(0.1), {Size = UDim2.new(0,40,0,40)}):Play()
                task.wait(0.1)
                TweenService:Create(FloatFrame, TweenInfo.new(0.1), {Size = UDim2.new(0,48,0,48)}):Play()
            end
        end)
    end

    -- ══════════════════════════════
    --      ELEMENT BUILDERS
    -- ══════════════════════════════

    local function CreateSection(container, sectionTitle)
        if not container then return end

        local Wrapper = Instance.new("Frame", container)
        Wrapper.BackgroundTransparency = 1
        Wrapper.BorderSizePixel = 0
        Wrapper.Size = UDim2.new(1,0,0,36)
        Wrapper.Name = "SectionWrapper"
        Wrapper.ClipsDescendants = true

        local Header = Instance.new("Frame", Wrapper)
        Header.BackgroundColor3 = Color3.fromRGB(20,20,28)
        Header.BorderSizePixel = 0
        Header.Size = UDim2.new(1,0,0,32)
        Instance.new("UICorner", Header).CornerRadius = UDim.new(0,7)
        local HS = Instance.new("UIStroke", Header)
        HS.Color = Color3.fromRGB(40,40,56)
        HS.Thickness = 1

        local LeftBar = Instance.new("Frame", Header)
        LeftBar.BackgroundColor3 = GetColor()
        LeftBar.BorderSizePixel = 0
        LeftBar.Position = UDim2.new(0,0,0.15,0)
        LeftBar.Size = UDim2.new(0,3,0.7,0)
        Instance.new("UICorner", LeftBar).CornerRadius = UDim.new(0,2)
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) LeftBar.BackgroundColor3 = c end})

        local STitle = Instance.new("TextLabel", Header)
        STitle.Font = Enum.Font.GothamBold
        STitle.Text = sectionTitle or "Section"
        STitle.TextColor3 = Color3.fromRGB(200,200,210)
        STitle.TextSize = 12
        STitle.TextXAlignment = Enum.TextXAlignment.Left
        STitle.BackgroundTransparency = 1
        STitle.Position = UDim2.new(0,14,0,0)
        STitle.Size = UDim2.new(1,-50,1,0)

        local Arrow = Instance.new("TextLabel", Header)
        Arrow.Font = Enum.Font.GothamBold
        Arrow.Text = "▾"
        Arrow.TextColor3 = Color3.fromRGB(120,120,140)
        Arrow.TextSize = 14
        Arrow.BackgroundTransparency = 1
        Arrow.AnchorPoint = Vector2.new(1,0.5)
        Arrow.Position = UDim2.new(1,-10,0.5,0)
        Arrow.Size = UDim2.new(0,20,0,20)

        local SContent = Instance.new("Frame", Wrapper)
        SContent.BackgroundTransparency = 1
        SContent.BorderSizePixel = 0
        SContent.Position = UDim2.new(0,0,0,36)
        SContent.Size = UDim2.new(1,0,0,0)
        SContent.Name = "SectionContent"
        SContent.ClipsDescendants = true

        local SCLayout = Instance.new("UIListLayout", SContent)
        SCLayout.Padding = UDim.new(0,5)
        SCLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local isOpen = true
        local contentH = 0

        SCLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentH = SCLayout.AbsoluteContentSize.Y
            if isOpen then
                SContent.Size = UDim2.new(1,0,0,contentH)
                Wrapper.Size = UDim2.new(1,0,0,36 + contentH)
            end
        end)

        local HBtn = Instance.new("TextButton", Header)
        HBtn.Text = ""
        HBtn.BackgroundTransparency = 1
        HBtn.Size = UDim2.new(1,0,1,0)
        HBtn.ZIndex = 5

        HBtn.Activated:Connect(function()
            isOpen = not isOpen
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = isOpen and 0 or -90}):Play()
            local targetW = isOpen and (36 + contentH) or 36
            local targetC = isOpen and contentH or 0
            TweenService:Create(Wrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1,0,0,targetW)}):Play()
            TweenService:Create(SContent, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1,0,0,targetC)}):Play()
        end)

        task.wait(0.06)
        contentH = SCLayout.AbsoluteContentSize.Y
        SContent.Size = UDim2.new(1,0,0,contentH)
        Wrapper.Size = UDim2.new(1,0,0,36 + contentH)

        return SContent
    end

    local function CreateParagraph(container, title, content)
        if not container then return end
        local P = Instance.new("Frame", container)
        P.BackgroundColor3 = Color3.fromRGB(19,19,26)
        P.BorderSizePixel = 0
        P.Size = UDim2.new(1,0,0,50)
        P.Name = "Paragraph"
        Instance.new("UICorner", P).CornerRadius = UDim.new(0,7)
        Instance.new("UIStroke", P).Color = Color3.fromRGB(38,38,52)

        local PT = Instance.new("TextLabel", P)
        PT.Font = Enum.Font.GothamBold
        PT.Text = title
        PT.TextColor3 = Color3.fromRGB(210,210,220)
        PT.TextSize = 12
        PT.TextXAlignment = Enum.TextXAlignment.Left
        PT.BackgroundTransparency = 1
        PT.Position = UDim2.new(0,10,0,8)
        PT.Size = UDim2.new(1,-20,0,14)

        local PC = Instance.new("TextLabel", P)
        PC.Font = Enum.Font.Gotham
        PC.Text = content
        PC.TextColor3 = Color3.fromRGB(130,130,150)
        PC.TextSize = 11
        PC.TextXAlignment = Enum.TextXAlignment.Left
        PC.TextWrapped = true
        PC.BackgroundTransparency = 1
        PC.Position = UDim2.new(0,10,0,24)
        local ts = TextService:GetTextSize(content, 11, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X - 40, math.huge))
        PC.Size = UDim2.new(1,-20,0,ts.Y)
        P.Size = UDim2.new(1,0,0,math.max(50, ts.Y + 32))
        return P
    end

    local function CreateButton(container, title, content, iconId, callback)
        if not container then return end
        local B = Instance.new("Frame", container)
        B.BackgroundColor3 = Color3.fromRGB(19,19,26)
        B.BorderSizePixel = 0
        B.Size = UDim2.new(1,0,0,50)
        B.Name = "Button"
        Instance.new("UICorner", B).CornerRadius = UDim.new(0,7)
        local BS = Instance.new("UIStroke", B)
        BS.Color = Color3.fromRGB(38,38,52)
        BS.Thickness = 1

        local BT = Instance.new("TextLabel", B)
        BT.Font = Enum.Font.GothamBold
        BT.Text = title
        BT.TextColor3 = Color3.fromRGB(210,210,220)
        BT.TextSize = 12
        BT.TextXAlignment = Enum.TextXAlignment.Left
        BT.BackgroundTransparency = 1
        BT.Position = UDim2.new(0,10,0,9)
        BT.Size = UDim2.new(1,-90,0,14)

        local BC = Instance.new("TextLabel", B)
        BC.Font = Enum.Font.Gotham
        BC.Text = content
        BC.TextColor3 = Color3.fromRGB(110,110,130)
        BC.TextSize = 11
        BC.TextXAlignment = Enum.TextXAlignment.Left
        BC.TextWrapped = true
        BC.BackgroundTransparency = 1
        BC.Position = UDim2.new(0,10,0,26)
        BC.Size = UDim2.new(1,-90,0,14)

        local RunBtn = Instance.new("TextButton", B)
        RunBtn.Font = Enum.Font.GothamBold
        RunBtn.Text = "RUN"
        RunBtn.TextSize = 11
        RunBtn.TextColor3 = Color3.fromRGB(255,255,255)
        RunBtn.BackgroundColor3 = GetColor()
        RunBtn.BackgroundTransparency = 0.1
        RunBtn.BorderSizePixel = 0
        RunBtn.AnchorPoint = Vector2.new(1,0.5)
        RunBtn.Position = UDim2.new(1,-10,0.5,0)
        RunBtn.Size = UDim2.new(0,60,0,28)
        RunBtn.ZIndex = 3
        Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,6)
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) RunBtn.BackgroundColor3 = c end})

        local HitBox = Instance.new("TextButton", B)
        HitBox.Text = ""
        HitBox.BackgroundTransparency = 1
        HitBox.Size = UDim2.new(1,0,1,0)
        HitBox.ZIndex = 2

        local function fire()
            if callback then callback() end
        end
        HitBox.Activated:Connect(function() CircleClick(HitBox, Mouse.X, Mouse.Y) fire() end)
        RunBtn.Activated:Connect(function() CircleClick(RunBtn, Mouse.X, Mouse.Y) fire() end)

        B.MouseEnter:Connect(function()
            TweenService:Create(BS, TweenInfo.new(0.15), {Color = GetColor(), Transparency = 0.5}):Play()
        end)
        B.MouseLeave:Connect(function()
            TweenService:Create(BS, TweenInfo.new(0.15), {Color = Color3.fromRGB(38,38,52), Transparency = 0}):Play()
        end)
        return B
    end

    local function CreateToggle(container, title, content, default, callback, elementId)
        if not container then return end
        local T = Instance.new("Frame", container)
        T.BackgroundColor3 = Color3.fromRGB(19,19,26)
        T.BorderSizePixel = 0
        T.Size = UDim2.new(1,0,0,50)
        T.Name = "Toggle"
        Instance.new("UICorner", T).CornerRadius = UDim.new(0,7)
        local TS = Instance.new("UIStroke", T)
        TS.Color = Color3.fromRGB(38,38,52)
        TS.Thickness = 1

        local TT = Instance.new("TextLabel", T)
        TT.Font = Enum.Font.GothamBold
        TT.Text = title
        TT.TextColor3 = Color3.fromRGB(210,210,220)
        TT.TextSize = 12
        TT.TextXAlignment = Enum.TextXAlignment.Left
        TT.BackgroundTransparency = 1
        TT.Position = UDim2.new(0,10,0,9)
        TT.Size = UDim2.new(1,-90,0,14)
        TT.Name = "ToggleTitle"

        local TC = Instance.new("TextLabel", T)
        TC.Font = Enum.Font.Gotham
        TC.Text = content
        TC.TextColor3 = Color3.fromRGB(110,110,130)
        TC.TextSize = 11
        TC.TextXAlignment = Enum.TextXAlignment.Left
        TC.TextWrapped = true
        TC.BackgroundTransparency = 1
        TC.Position = UDim2.new(0,10,0,26)
        TC.Size = UDim2.new(1,-90,0,14)

        local Track = Instance.new("Frame", T)
        Track.BackgroundColor3 = Color3.fromRGB(35,35,48)
        Track.BorderSizePixel = 0
        Track.AnchorPoint = Vector2.new(1,0.5)
        Track.Position = UDim2.new(1,-12,0.5,0)
        Track.Size = UDim2.new(0,40,0,20)
        Track.Name = "FeatureFrame"
        Instance.new("UICorner", Track).CornerRadius = UDim.new(1,0)
        local TrackStroke = Instance.new("UIStroke", Track)
        TrackStroke.Color = Color3.fromRGB(60,60,80)
        TrackStroke.Thickness = 1.2

        local Thumb = Instance.new("Frame", Track)
        Thumb.BackgroundColor3 = Color3.fromRGB(180,180,200)
        Thumb.BorderSizePixel = 0
        Thumb.Position = default and UDim2.new(0,21,0.5,-8) or UDim2.new(0,1,0.5,-8)
        Thumb.Size = UDim2.new(0,18,0,18)
        Thumb.Name = "ToggleCircle"
        Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1,0)
        table.insert(ConfigSystem.ToggleElements, T)

        local state = default or false

        local function SetState(val)
            state = val
            local col = GetColor()
            if val then
                TweenService:Create(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0,21,0.5,-8), BackgroundColor3 = col}):Play()
                TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
                TweenService:Create(TrackStroke, TweenInfo.new(0.2), {Color = col, Transparency = 0.5}):Play()
                TweenService:Create(TT, TweenInfo.new(0.2), {TextColor3 = col}):Play()
                TweenService:Create(TS, TweenInfo.new(0.2), {Color = col, Transparency = 0.5}):Play()
            else
                TweenService:Create(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0,1,0.5,-8), BackgroundColor3 = Color3.fromRGB(180,180,200)}):Play()
                TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,48)}):Play()
                TweenService:Create(TrackStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60,60,80), Transparency = 0}):Play()
                TweenService:Create(TT, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(210,210,220)}):Play()
                TweenService:Create(TS, TweenInfo.new(0.2), {Color = Color3.fromRGB(38,38,52), Transparency = 0}):Play()
            end
            if callback then callback(state) end
        end

        SetState(state)

        local TBtn = Instance.new("TextButton", T)
        TBtn.Text = ""
        TBtn.BackgroundTransparency = 1
        TBtn.Size = UDim2.new(1,0,1,0)
        TBtn.ZIndex = 3
        TBtn.Activated:Connect(function()
            CircleClick(TBtn, Mouse.X, Mouse.Y)
            SetState(not state)
        end)

        local tFunc = {Value = state, Set = SetState, Type = "Toggle", Id = elementId}
        if elementId then AllElements[elementId] = tFunc end
        return tFunc
    end

    local function CreateSlider(container, title, content, minVal, maxVal, defVal, callback, elementId)
        if not container then return end
        local S = Instance.new("Frame", container)
        S.BackgroundColor3 = Color3.fromRGB(19,19,26)
        S.BorderSizePixel = 0
        S.Size = UDim2.new(1,0,0,62)
        S.Name = "Slider"
        Instance.new("UICorner", S).CornerRadius = UDim.new(0,7)
        local SS = Instance.new("UIStroke", S)
        SS.Color = Color3.fromRGB(38,38,52)
        SS.Thickness = 1

        local ST = Instance.new("TextLabel", S)
        ST.Font = Enum.Font.GothamBold
        ST.Text = title
        ST.TextColor3 = Color3.fromRGB(210,210,220)
        ST.TextSize = 12
        ST.TextXAlignment = Enum.TextXAlignment.Left
        ST.BackgroundTransparency = 1
        ST.Position = UDim2.new(0,10,0,8)
        ST.Size = UDim2.new(1,-70,0,14)

        local ValLbl = Instance.new("TextLabel", S)
        ValLbl.Font = Enum.Font.GothamBold
        ValLbl.Text = tostring(defVal or minVal)
        ValLbl.TextColor3 = GetColor()
        ValLbl.TextSize = 12
        ValLbl.TextXAlignment = Enum.TextXAlignment.Right
        ValLbl.BackgroundTransparency = 1
        ValLbl.AnchorPoint = Vector2.new(1,0)
        ValLbl.Position = UDim2.new(1,-10,0,8)
        ValLbl.Size = UDim2.new(0,50,0,14)
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) ValLbl.TextColor3 = c end})

        local SC = Instance.new("TextLabel", S)
        SC.Font = Enum.Font.Gotham
        SC.Text = content
        SC.TextColor3 = Color3.fromRGB(110,110,130)
        SC.TextSize = 11
        SC.TextXAlignment = Enum.TextXAlignment.Left
        SC.BackgroundTransparency = 1
        SC.Position = UDim2.new(0,10,0,24)
        SC.Size = UDim2.new(1,-70,0,12)

        local TrackBg = Instance.new("Frame", S)
        TrackBg.BackgroundColor3 = Color3.fromRGB(30,30,42)
        TrackBg.BorderSizePixel = 0
        TrackBg.Position = UDim2.new(0,10,0,46)
        TrackBg.Size = UDim2.new(1,-20,0,5)
        TrackBg.Name = "SliderFrame"
        Instance.new("UICorner", TrackBg).CornerRadius = UDim.new(1,0)
        table.insert(ConfigSystem.SliderElements, TrackBg)

        local Fill = Instance.new("Frame", TrackBg)
        Fill.BackgroundColor3 = GetColor()
        Fill.BorderSizePixel = 0
        Fill.Position = UDim2.new(0,0,0,0)
        Fill.Size = UDim2.new(0,0,1,0)
        Fill.Name = "SliderFill"
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) Fill.BackgroundColor3 = c end})

        local Knob = Instance.new("Frame", TrackBg)
        Knob.BackgroundColor3 = Color3.fromRGB(240,240,240)
        Knob.BorderSizePixel = 0
        Knob.AnchorPoint = Vector2.new(0.5,0.5)
        Knob.Position = UDim2.new(0,0,0.5,0)
        Knob.Size = UDim2.new(0,13,0,13)
        Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

        local sData = {Min = minVal or 0, Max = maxVal or 100, Value = defVal or minVal or 0, Dragging = false}

        local function SetValue(v)
            v = math.clamp(math.floor(v + 0.5), sData.Min, sData.Max)
            sData.Value = v
            ValLbl.Text = tostring(v)
            local pct = (v - sData.Min) / (sData.Max - sData.Min)
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            Knob.Position = UDim2.new(pct, 0, 0.5, 0)
            if callback then callback(v) end
        end

        SetValue(sData.Value)

        local function UpdateFromInput(input)
            local pct = math.clamp((input.Position.X - TrackBg.AbsolutePosition.X) / TrackBg.AbsoluteSize.X, 0, 1)
            SetValue(sData.Min + pct * (sData.Max - sData.Min))
        end

        TrackBg.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                sData.Dragging = true
                UpdateFromInput(inp)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if sData.Dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                UpdateFromInput(inp)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                sData.Dragging = false
            end
        end)

        local sFunc = {Value = sData.Value, Type = "Slider", Id = elementId}
        function sFunc:Set(v) SetValue(v) sFunc.Value = sData.Value end
        if elementId then AllElements[elementId] = sFunc end
        return sFunc
    end

    local function CreateInput(container, title, content, placeholder, callback, elementId)
        if not container then return end
        local I = Instance.new("Frame", container)
        I.BackgroundColor3 = Color3.fromRGB(19,19,26)
        I.BorderSizePixel = 0
        I.Size = UDim2.new(1,0,0,50)
        I.Name = "Input"
        Instance.new("UICorner", I).CornerRadius = UDim.new(0,7)
        local IS = Instance.new("UIStroke", I)
        IS.Color = Color3.fromRGB(38,38,52)
        IS.Thickness = 1

        local IT = Instance.new("TextLabel", I)
        IT.Font = Enum.Font.GothamBold
        IT.Text = title
        IT.TextColor3 = Color3.fromRGB(210,210,220)
        IT.TextSize = 12
        IT.TextXAlignment = Enum.TextXAlignment.Left
        IT.BackgroundTransparency = 1
        IT.Position = UDim2.new(0,10,0.5,-7)
        IT.Size = UDim2.new(0.45,0,0,14)

        local IBg = Instance.new("Frame", I)
        IBg.BackgroundColor3 = Color3.fromRGB(25,25,35)
        IBg.BorderSizePixel = 0
        IBg.AnchorPoint = Vector2.new(1,0.5)
        IBg.Position = UDim2.new(1,-8,0.5,0)
        IBg.Size = UDim2.new(0,160,0,30)
        Instance.new("UICorner", IBg).CornerRadius = UDim.new(0,6)
        local IStroke = Instance.new("UIStroke", IBg)
        IStroke.Color = Color3.fromRGB(50,50,68)
        IStroke.Thickness = 1

        local TBox = Instance.new("TextBox", IBg)
        TBox.Font = Enum.Font.Gotham
        TBox.PlaceholderText = placeholder or "Type here..."
        TBox.PlaceholderColor3 = Color3.fromRGB(80,80,100)
        TBox.Text = ""
        TBox.TextColor3 = Color3.fromRGB(210,210,220)
        TBox.TextSize = 12
        TBox.BackgroundTransparency = 1
        TBox.Position = UDim2.new(0,8,0,0)
        TBox.Size = UDim2.new(1,-16,1,0)
        TBox.ClearTextOnFocus = false

        TBox.Focused:Connect(function()
            TweenService:Create(IStroke, TweenInfo.new(0.15), {Color = GetColor()}):Play()
        end)
        TBox.FocusLost:Connect(function()
            TweenService:Create(IStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50,50,68)}):Play()
        end)

        local iFunc = {Value = "", Type = "Input", Id = elementId}
        function iFunc:Set(v)
            TBox.Text = v
            iFunc.Value = v
            if callback then callback(v) end
        end
        TBox.FocusLost:Connect(function()
            iFunc.Value = TBox.Text
            if callback then callback(TBox.Text) end
        end)
        if elementId then AllElements[elementId] = iFunc end
        return iFunc
    end

    local function CreateDropdown(container, title, content, options, multi, defaultValue, callback, elementId)
        if not container then return end
        local D = Instance.new("Frame", container)
        D.BackgroundColor3 = Color3.fromRGB(19,19,26)
        D.BorderSizePixel = 0
        D.Size = UDim2.new(1,0,0,50)
        D.Name = "Dropdown"
        Instance.new("UICorner", D).CornerRadius = UDim.new(0,7)
        local DS = Instance.new("UIStroke", D)
        DS.Color = Color3.fromRGB(38,38,52)
        DS.Thickness = 1

        local DT = Instance.new("TextLabel", D)
        DT.Font = Enum.Font.GothamBold
        DT.Text = title
        DT.TextColor3 = Color3.fromRGB(210,210,220)
        DT.TextSize = 12
        DT.TextXAlignment = Enum.TextXAlignment.Left
        DT.BackgroundTransparency = 1
        DT.Position = UDim2.new(0,10,0.5,-7)
        DT.Size = UDim2.new(0.45,0,0,14)

        local SelBg = Instance.new("Frame", D)
        SelBg.BackgroundColor3 = Color3.fromRGB(25,25,35)
        SelBg.BorderSizePixel = 0
        SelBg.AnchorPoint = Vector2.new(1,0.5)
        SelBg.Position = UDim2.new(1,-8,0.5,0)
        SelBg.Size = UDim2.new(0,160,0,30)
        Instance.new("UICorner", SelBg).CornerRadius = UDim.new(0,6)
        local SelStroke = Instance.new("UIStroke", SelBg)
        SelStroke.Color = Color3.fromRGB(50,50,68)
        SelStroke.Thickness = 1

        local SelLbl = Instance.new("TextLabel", SelBg)
        SelLbl.Font = Enum.Font.Gotham
        SelLbl.Text = "Select..."
        SelLbl.TextColor3 = Color3.fromRGB(130,130,150)
        SelLbl.TextSize = 11
        SelLbl.TextXAlignment = Enum.TextXAlignment.Left
        SelLbl.TextTruncate = Enum.TextTruncate.AtEnd
        SelLbl.BackgroundTransparency = 1
        SelLbl.Position = UDim2.new(0,8,0,0)
        SelLbl.Size = UDim2.new(1,-26,1,0)

        local ArrowLbl = Instance.new("TextLabel", SelBg)
        ArrowLbl.Font = Enum.Font.GothamBold
        ArrowLbl.Text = "▾"
        ArrowLbl.TextSize = 12
        ArrowLbl.TextColor3 = Color3.fromRGB(120,120,140)
        ArrowLbl.BackgroundTransparency = 1
        ArrowLbl.AnchorPoint = Vector2.new(1,0.5)
        ArrowLbl.Position = UDim2.new(1,-2,0.5,0)
        ArrowLbl.Size = UDim2.new(0,20,0,20)

        local ListPanel = Instance.new("Frame", ScreenGui)
        ListPanel.BackgroundColor3 = Color3.fromRGB(18,18,26)
        ListPanel.BorderSizePixel = 0
        ListPanel.Size = UDim2.new(0,168,0,0)
        ListPanel.Visible = false
        ListPanel.ClipsDescendants = true
        ListPanel.ZIndex = 50
        Instance.new("UICorner", ListPanel).CornerRadius = UDim.new(0,8)
        local LPS = Instance.new("UIStroke", ListPanel)
        LPS.Color = GetColor()
        LPS.Thickness = 1.2
        LPS.Transparency = 0.5
        LPS.ZIndex = 50
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) LPS.Color = c end})

        local ListScroll = Instance.new("ScrollingFrame", ListPanel)
        ListScroll.ScrollBarThickness = 2
        ListScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,110)
        ListScroll.BackgroundTransparency = 1
        ListScroll.BorderSizePixel = 0
        ListScroll.Position = UDim2.new(0,4,0,4)
        ListScroll.Size = UDim2.new(1,-8,1,-8)
        ListScroll.CanvasSize = UDim2.new(0,0,0,0)
        ListScroll.ZIndex = 51
        local ListLayout = Instance.new("UIListLayout", ListScroll)
        ListLayout.Padding = UDim.new(0,2)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local dData = {
            Options = options or {},
            Value = multi and (defaultValue or {}) or defaultValue or nil,
            Multi = multi or false,
            Open = false
        }

        local function UpdateDisplay()
            if dData.Multi then
                if #dData.Value > 0 then
                    SelLbl.Text = table.concat(dData.Value, ", ")
                    SelLbl.TextColor3 = Color3.fromRGB(210,210,220)
                else
                    SelLbl.Text = "Select..."
                    SelLbl.TextColor3 = Color3.fromRGB(130,130,150)
                end
            else
                if dData.Value then
                    SelLbl.Text = dData.Value
                    SelLbl.TextColor3 = Color3.fromRGB(210,210,220)
                else
                    SelLbl.Text = "Select..."
                    SelLbl.TextColor3 = Color3.fromRGB(130,130,150)
                end
            end
        end

        local function ToggleList()
            dData.Open = not dData.Open
            if dData.Open then
                TweenService:Create(SelStroke, TweenInfo.new(0.15), {Color = GetColor()}):Play()
                local ap = D.AbsolutePosition
                local as = D.AbsoluteSize
                local totalH = ListLayout.AbsoluteContentSize.Y + 8
                local finalH = math.min(totalH, 160)
                ListScroll.CanvasSize = UDim2.new(0,0,0,totalH-8)
                ListPanel.Size = UDim2.new(0,168,0,0)
                ListPanel.Position = UDim2.new(0, ap.X + as.X - 168, 0, ap.Y + as.Y + 4)
                ListPanel.Visible = true
                TweenService:Create(ListPanel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,168,0,finalH)}):Play()
                TweenService:Create(ArrowLbl, TweenInfo.new(0.2), {Rotation = 180}):Play()
            else
                TweenService:Create(SelStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50,50,68)}):Play()
                TweenService:Create(ListPanel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,168,0,0)}):Play()
                TweenService:Create(ArrowLbl, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.wait(0.15)
                ListPanel.Visible = false
            end
        end

        local function CreateOption(optName)
            local Opt = Instance.new("Frame", ListScroll)
            Opt.BackgroundColor3 = Color3.fromRGB(26,26,36)
            Opt.BackgroundTransparency = 0.5
            Opt.BorderSizePixel = 0
            Opt.Size = UDim2.new(1,0,0,30)
            Opt.Name = "Option"
            Opt.ZIndex = 52
            Instance.new("UICorner", Opt).CornerRadius = UDim.new(0,5)

            local OL = Instance.new("TextLabel", Opt)
            OL.Font = Enum.Font.Gotham
            OL.Text = optName
            OL.TextColor3 = Color3.fromRGB(180,180,200)
            OL.TextSize = 12
            OL.TextXAlignment = Enum.TextXAlignment.Left
            OL.BackgroundTransparency = 1
            OL.Position = UDim2.new(0,10,0,0)
            OL.Size = UDim2.new(1,-36,1,0)
            OL.ZIndex = 53
            OL.Name = "OptionText"

            local CL = Instance.new("TextLabel", Opt)
            CL.Font = Enum.Font.GothamBold
            CL.Text = ""
            CL.TextColor3 = GetColor()
            CL.TextSize = 12
            CL.BackgroundTransparency = 1
            CL.AnchorPoint = Vector2.new(1,0.5)
            CL.Position = UDim2.new(1,-6,0.5,0)
            CL.Size = UDim2.new(0,20,0,20)
            CL.ZIndex = 53
            table.insert(ConfigSystem.ThemeElements, {Update = function(c) CL.TextColor3 = c end})

            local OB = Instance.new("TextButton", Opt)
            OB.Text = ""
            OB.BackgroundTransparency = 1
            OB.Size = UDim2.new(1,0,1,0)
            OB.ZIndex = 54

            local function UpdateVis()
                local sel = dData.Multi and (table.find(dData.Value, optName) ~= nil) or (dData.Value == optName)
                if sel then
                    TweenService:Create(Opt, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
                    TweenService:Create(OL, TweenInfo.new(0.15), {TextColor3 = GetColor()}):Play()
                    CL.Text = "✓"
                else
                    TweenService:Create(Opt, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
                    TweenService:Create(OL, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(180,180,200)}):Play()
                    CL.Text = ""
                end
            end

            OB.Activated:Connect(function()
                CircleClick(OB, Mouse.X, Mouse.Y)
                if dData.Multi then
                    local idx = table.find(dData.Value, optName)
                    if idx then table.remove(dData.Value, idx) else table.insert(dData.Value, optName) end
                else
                    dData.Value = optName
                    for _, child in ListScroll:GetChildren() do
                        if child:IsA("Frame") and child.Name == "Option" then
                            local ol = child:FindFirstChild("OptionText")
                            if ol and ol.Text ~= optName then
                                TweenService:Create(child, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
                                TweenService:Create(ol, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(180,180,200)}):Play()
                                local cl = child:FindFirstChildWhichIsA("TextLabel")
                                if cl and cl.Name ~= "OptionText" then cl.Text = "" end
                            end
                        end
                    end
                end
                UpdateVis()
                UpdateDisplay()
                if callback then callback(dData.Value) end
                if not dData.Multi then
                    task.wait(0.05)
                    ToggleList()
                end
            end)

            UpdateVis()
            return Opt
        end

        for _, opt in ipairs(dData.Options) do CreateOption(opt) end
        UpdateDisplay()

        local DBtn = Instance.new("TextButton", D)
        DBtn.Text = ""
        DBtn.BackgroundTransparency = 1
        DBtn.Size = UDim2.new(1,0,1,0)
        DBtn.ZIndex = 3
        DBtn.Activated:Connect(function()
            CircleClick(DBtn, Mouse.X, Mouse.Y)
            ToggleList()
        end)

        local conn
        conn = UserInputService.InputBegan:Connect(function(inp)
            if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and dData.Open then
                local mp = inp.Position
                local lp = ListPanel.AbsolutePosition
                local ls = ListPanel.AbsoluteSize
                local sp = SelBg.AbsolutePosition
                local ss = SelBg.AbsoluteSize
                if not (mp.X>=lp.X and mp.X<=lp.X+ls.X and mp.Y>=lp.Y and mp.Y<=lp.Y+ls.Y) and
                   not (mp.X>=sp.X and mp.X<=sp.X+ss.X and mp.Y>=sp.Y and mp.Y<=sp.Y+ss.Y) then
                    ToggleList()
                end
            end
        end)
        D.Destroying:Connect(function()
            if conn then conn:Disconnect() end
            if ListPanel and ListPanel.Parent then ListPanel:Destroy() end
        end)

        local dFunc = {Value = dData.Value, Options = dData.Options, Type = "Dropdown", Id = elementId}
        function dFunc:Set(v)
            dData.Value = v
            UpdateDisplay()
        end
        function dFunc:Refresh(newOpts, newVal)
            for _, c in ListScroll:GetChildren() do
                if c:IsA("Frame") then c:Destroy() end
            end
            dData.Options = newOpts or {}
            dData.Value = newVal or (dData.Multi and {} or nil)
            for _, opt in ipairs(dData.Options) do CreateOption(opt) end
            ListScroll.CanvasSize = UDim2.new(0,0,0, ListLayout.AbsoluteContentSize.Y)
            UpdateDisplay()
            dFunc.Value = dData.Value
            dFunc.Options = dData.Options
        end
        if elementId then AllElements[elementId] = dFunc end
        return dFunc
    end

    -- ── TAB CREATOR (FIXED) ──
    local function CreateTabButton(tabName, iconId, isConfig)
        TabCount = TabCount + 1

        local TabItem = Instance.new("Frame")
        TabItem.BackgroundColor3 = Color3.fromRGB(22,22,30)
        TabItem.BackgroundTransparency = 1
        TabItem.BorderSizePixel = 0
        -- Gunakan ukuran tetap, UIListLayout yang handle posisi
        TabItem.Size = UDim2.new(1, -8, 0, 34)
        TabItem.LayoutOrder = isConfig and 999 or TabCount
        TabItem.Name = "TabItem_" .. tabName
        TabItem.ZIndex = 3
        TabItem.Parent = SidebarScroll
        Instance.new("UICorner", TabItem).CornerRadius = UDim.new(0,7)

        local ActiveBar = Instance.new("Frame", TabItem)
        ActiveBar.BackgroundColor3 = GetColor()
        ActiveBar.BorderSizePixel = 0
        ActiveBar.Position = UDim2.new(0,0,0.2,0)
        ActiveBar.Size = UDim2.new(0,3,0.6,0)
        ActiveBar.Visible = false
        ActiveBar.ZIndex = 4
        Instance.new("UICorner", ActiveBar).CornerRadius = UDim.new(0,2)
        table.insert(ConfigSystem.ThemeElements, {Update = function(c) ActiveBar.BackgroundColor3 = c end})

        local Icon = Instance.new("ImageLabel", TabItem)
        Icon.Image = iconId or ""
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0,10,0.5,-8)
        Icon.Size = UDim2.new(0,16,0,16)
        Icon.ImageColor3 = Color3.fromRGB(130,130,150)
        Icon.ZIndex = 4

        local TabLbl = Instance.new("TextLabel", TabItem)
        TabLbl.Font = Enum.Font.GothamBold
        TabLbl.Text = tabName
        TabLbl.TextColor3 = Color3.fromRGB(130,130,150)
        TabLbl.TextSize = 12
        TabLbl.TextXAlignment = Enum.TextXAlignment.Left
        TabLbl.BackgroundTransparency = 1
        TabLbl.Position = UDim2.new(0,32,0,0)
        TabLbl.Size = UDim2.new(1,-36,1,0)
        TabLbl.ZIndex = 4

        -- TextButton sebagai hitbox klik — ZIndex paling tinggi
        local TabBtn = Instance.new("TextButton", TabItem)
        TabBtn.Text = ""
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1,0,1,0)
        TabBtn.Position = UDim2.new(0,0,0,0)
        TabBtn.ZIndex = 20  -- lebih tinggi dari semua child lain
        TabBtn.AutoButtonColor = false

        -- Content
        local TabContent = Instance.new("Frame", ContentScroll)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1,0,0,0)
        TabContent.Visible = false
        TabContent.Name = tabName .. "Content"
        TabContent.LayoutOrder = isConfig and 999 or TabCount

        local TCLayout = Instance.new("UIListLayout", TabContent)
        TCLayout.Padding = UDim.new(0,6)
        TCLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TCLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.Size = UDim2.new(1,0,0, TCLayout.AbsoluteContentSize.Y)
            if CurrentTab == tabName then
                ContentScroll.CanvasSize = UDim2.new(0,0,0, TCLayout.AbsoluteContentSize.Y + 10)
            end
        end)

        TabContents[tabName] = TabContent

        local function SwitchTab()
            for _, cont in pairs(TabContents) do
                cont.Visible = false
            end
            for _, item in SidebarScroll:GetChildren() do
                if item:IsA("Frame") and item.Name:sub(1,8) == "TabItem_" then
                    local ab = item:FindFirstChild("ActiveBar")
                    if ab then ab.Visible = false end
                    TweenService:Create(item, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                    for _, child in item:GetChildren() do
                        if child:IsA("TextLabel") then
                            TweenService:Create(child, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(130,130,150)}):Play()
                        elseif child:IsA("ImageLabel") then
                            TweenService:Create(child, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(130,130,150)}):Play()
                        end
                    end
                end
            end

            TabContent.Visible = true
            ActiveBar.Visible = true
            TweenService:Create(TabItem, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
            TweenService:Create(TabLbl, TweenInfo.new(0.15), {TextColor3 = GetColor()}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.15), {ImageColor3 = GetColor()}):Play()
            ContentHeader.Text = tabName
            CurrentTab = tabName
            ContentScroll.CanvasSize = UDim2.new(0,0,0, TCLayout.AbsoluteContentSize.Y + 10)
            ContentScroll.CanvasPosition = Vector2.new(0,0)
        end

        TabBtn.Activated:Connect(function()
            CircleClick(TabBtn, Mouse.X, Mouse.Y)
            SwitchTab()
        end)

        return TabContent, SwitchTab
    end

    -- Config Tab
    local ConfigTabContent, _ = CreateTabButton("Config", "rbxassetid://16932740082", true)
    CreateParagraph(ConfigTabContent, "CyioxUI Configuration", "Manage themes and save/load configs.")

    local themeList = {}
    for k in pairs(ConfigSystem.ThemeColors) do table.insert(themeList, k) end
    table.sort(themeList)

    local ThemeDrop = CreateDropdown(ConfigTabContent, "Theme", "Choose accent color", themeList, false, ConfigSystem.CurrentTheme, function(v)
        local ok, col = ConfigSystem:SetTheme(v)
        if ok then
            MakeNotify({Title="CyioxUI", Description="Theme", Content="Theme set to "..v, Color=col, Delay=3})
        end
    end, "ThemeDropdown")

    CreateToggle(ConfigTabContent, "UI Transparency", "Toggle glass effect", false, function(state)
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = state and 0.35 or 0}):Play()
    end, "TransparencyToggle")

    local CurrentConfigName = ""
    CreateInput(ConfigTabContent, "Config Name", "Name for saving", "MyConfig", function(v)
        CurrentConfigName = v
    end, "ConfigNameInput")

    local LoadDrop, DeleteDrop

    CreateButton(ConfigTabContent, "Save Config", "Save current settings", nil, function()
        if CurrentConfigName and CurrentConfigName ~= "" then
            local data = {}
            for id, el in pairs(AllElements) do data[id] = el.Value end
            MakeNotify(ConfigSystem:SaveConfig(CurrentConfigName, data))
            local list = ConfigSystem:GetConfigList()
            if LoadDrop then LoadDrop:Refresh(list) end
            if DeleteDrop then DeleteDrop:Refresh(list) end
        else
            MakeNotify({Title="Config", Description="Error", Content="Enter a config name first!", Color=Color3.fromRGB(255,60,60), Delay=3})
        end
    end)

    LoadDrop = CreateDropdown(ConfigTabContent, "Load Config", "Select config to load", ConfigSystem:GetConfigList(), false, nil, function(v)
        if v then
            local nd, data = ConfigSystem:LoadConfig(v)
            MakeNotify(nd)
            if data then
                for id, val in pairs(data) do
                    if AllElements[id] and AllElements[id].Set then AllElements[id]:Set(val) end
                end
                if ThemeDrop then ThemeDrop:Set(ConfigSystem.CurrentTheme) end
            end
        end
    end, "LoadConfigDropdown")

    DeleteDrop = CreateDropdown(ConfigTabContent, "Delete Config", "Select config to delete", ConfigSystem:GetConfigList(), false, nil, function(v)
        if v then
            MakeNotify(ConfigSystem:DeleteConfig(v))
            local list = ConfigSystem:GetConfigList()
            if LoadDrop then LoadDrop:Refresh(list) end
            if DeleteDrop then DeleteDrop:Refresh(list) end
        end
    end, "DeleteConfigDropdown")

    -- ── WINDOW API ──
    local Window = {}
    local firstTabSwitched = false

    function Window:CreateTab(name, icon)
        local cont, sw = CreateTabButton(name, icon, false)
        if not firstTabSwitched then
            firstTabSwitched = true
            task.wait(0.05)
            sw()
        end
        return cont, sw
    end

    function Window:CreateSection(container, sectionTitle)
        return CreateSection(container, sectionTitle)
    end

    function Window:AddParagraph(container, title, content)
        return CreateParagraph(container, title, content)
    end

    function Window:AddButton(container, title, content, icon, callback)
        return CreateButton(container, title, content, icon, callback)
    end

    function Window:AddToggle(container, title, content, default, callback, id)
        return CreateToggle(container, title, content, default, callback, id)
    end

    function Window:AddSlider(container, title, content, min, max, default, callback, id)
        return CreateSlider(container, title, content, min, max, default, callback, id)
    end

    function Window:AddInput(container, title, content, placeholder, callback, id)
        return CreateInput(container, title, content, placeholder, callback, id)
    end

    function Window:AddDropdown(container, title, content, opts, multi, default, callback, id)
        return CreateDropdown(container, title, content, opts, multi, default, callback, id)
    end

    function Window:Notify(cfg)
        return MakeNotify(cfg)
    end

    function Window:SetTheme(name)
        return ConfigSystem:SetTheme(name)
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    return Window
end

return CyioxUI
