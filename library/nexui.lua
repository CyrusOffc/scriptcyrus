local NexusUI = {}
NexusUI.__index = NexusUI

-- ── Services ──────────────────────────────
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local CoreGui        = game:GetService("CoreGui")
local HttpService    = game:GetService("HttpService")

local Player  = Players.LocalPlayer
local Mouse   = Player:GetMouse()
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ── Tween Helper ──────────────────────────
local function Tween(obj, info, props)
    return TweenService:Create(obj, info, props):Play()
end
local T = {
    Fast   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.3,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow   = TweenInfo.new(0.5,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.6,  Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
}

-- ── Themes ────────────────────────────────
local Themes = {
    Dark = {
        Background    = Color3.fromRGB(15,  15,  20),
        Secondary     = Color3.fromRGB(22,  22,  30),
        Tertiary      = Color3.fromRGB(30,  30,  42),
        Surface       = Color3.fromRGB(38,  38,  52),
        SurfaceHover  = Color3.fromRGB(48,  48,  65),
        Border        = Color3.fromRGB(55,  55,  75),
        Text          = Color3.fromRGB(230, 230, 240),
        TextDim       = Color3.fromRGB(140, 140, 160),
        TextMuted     = Color3.fromRGB(80,  80,  100),
        Success       = Color3.fromRGB(80,  200, 120),
        Warning       = Color3.fromRGB(255, 190, 60),
        Error         = Color3.fromRGB(255, 80,  80),
        Info          = Color3.fromRGB(80,  160, 255),
    },
    Light = {
        Background    = Color3.fromRGB(245, 245, 250),
        Secondary     = Color3.fromRGB(235, 235, 245),
        Tertiary      = Color3.fromRGB(220, 220, 235),
        Surface       = Color3.fromRGB(210, 210, 228),
        SurfaceHover  = Color3.fromRGB(195, 195, 215),
        Border        = Color3.fromRGB(190, 190, 210),
        Text          = Color3.fromRGB(20,  20,  35),
        TextDim       = Color3.fromRGB(90,  90,  115),
        TextMuted     = Color3.fromRGB(155, 155, 175),
        Success       = Color3.fromRGB(40,  170, 90),
        Warning       = Color3.fromRGB(210, 150, 20),
        Error         = Color3.fromRGB(210, 50,  50),
        Info          = Color3.fromRGB(50,  120, 220),
    },
    Neon = {
        Background    = Color3.fromRGB(5,   5,   12),
        Secondary     = Color3.fromRGB(10,  10,  22),
        Tertiary      = Color3.fromRGB(15,  15,  32),
        Surface       = Color3.fromRGB(20,  20,  42),
        SurfaceHover  = Color3.fromRGB(28,  28,  55),
        Border        = Color3.fromRGB(80,  40,  130),
        Text          = Color3.fromRGB(240, 230, 255),
        TextDim       = Color3.fromRGB(160, 130, 200),
        TextMuted     = Color3.fromRGB(90,  70,  130),
        Success       = Color3.fromRGB(60,  255, 160),
        Warning       = Color3.fromRGB(255, 210, 0),
        Error         = Color3.fromRGB(255, 50,  100),
        Info          = Color3.fromRGB(100, 180, 255),
    },
}

-- ── UI Helper ─────────────────────────────
local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function AddCorner(parent, radius)
    return Create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end
local function AddStroke(parent, color, thick)
    return Create("UIStroke", { Color = color, Thickness = thick or 1, Parent = parent })
end
local function AddPadding(parent, t, r, b, l)
    return Create("UIPadding", {
        PaddingTop    = UDim.new(0, t or 6),
        PaddingRight  = UDim.new(0, r or 6),
        PaddingBottom = UDim.new(0, b or 6),
        PaddingLeft   = UDim.new(0, l or 6),
        Parent = parent
    })
end
local function AddListLayout(parent, dir, padding, align)
    return Create("UIListLayout", {
        FillDirection  = dir or Enum.FillDirection.Vertical,
        SortOrder      = Enum.SortOrder.LayoutOrder,
        Padding        = UDim.new(0, padding or 4),
        HorizontalAlignment = align or Enum.HorizontalAlignment.Left,
        Parent = parent
    })
end

-- ── Drag System ───────────────────────────
local function MakeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    local function update(pos)
        local delta = pos - dragStart
        target.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            update(i.Position)
        end
    end)
end

-- ── Ripple Effect ─────────────────────────
local function Ripple(btn, accent)
    local rip = Create("Frame", {
        Size = UDim2.new(0,0,0,0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = accent or Color3.new(1,1,1),
        BackgroundTransparency = 0.7,
        ZIndex = btn.ZIndex + 5,
        Parent = btn,
    })
    AddCorner(rip, 999)
    local maxS = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.5
    TweenService:Create(rip, T.Medium, { Size = UDim2.new(0, maxS, 0, maxS), BackgroundTransparency = 1 }):Play()
    task.delay(0.35, function() rip:Destroy() end)
end

-- ════════════════════════════════════════════
--           CREATE WINDOW
-- ════════════════════════════════════════════

function NexusUI:CreateWindow(cfg)
    cfg = cfg or {}
    local W = {}
    local Theme  = Themes[cfg.Theme or "Dark"]
    local Accent = cfg.AccentColor or Color3.fromRGB(100, 160, 255)
    local WinSize = cfg.Size or UDim2.new(0, 520, 0, 420)
    local WinPos  = cfg.Position or UDim2.new(0.5, -260, 0.5, -210)
    local Minimized = false
    local Tabs, ActiveTab = {}, nil

    -- ── ScreenGui ──────────────────────────
    local ScreenGui = Create("ScreenGui", {
        Name             = "NexusUI_" .. (cfg.Title or "Window"),
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset   = true,
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

    -- ── Main Window ────────────────────────
    local Main = Create("Frame", {
        Name             = "Main",
        Size             = WinSize,
        Position         = WinPos,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        Parent           = ScreenGui,
    })
    AddCorner(Main, 14)
    AddStroke(Main, Theme.Border, 1.5)

    -- Drop Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 8),
        Size = UDim2.new(1, 40, 1, 40),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.5,
        ZIndex = 0,
        Parent = Main,
    })

    -- ── Top Bar ────────────────────────────
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel  = 0,
        ZIndex = 2,
        Parent = Main,
    })
    AddCorner(TopBar, 14)
    -- Bottom cover
    Create("Frame", {
        Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,1,-14),
        BackgroundColor3 = Theme.Secondary, BorderSizePixel = 0, ZIndex = 2,
        Parent = TopBar,
    })

    -- Logo / Icon
    local LogoFrame = Create("Frame", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 12, 0.5, -16),
        BackgroundColor3 = Accent,
        ZIndex = 3,
        Parent = TopBar,
    })
    AddCorner(LogoFrame, 8)
    local LogoLabel = Create("TextLabel", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = cfg.LogoText or "N",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        ZIndex = 4,
        Parent = LogoFrame,
    })
    if cfg.Logo then
        LogoLabel.Text = ""
        Create("ImageLabel", {
            Size = UDim2.new(0.85, 0, 0.85, 0),
            Position = UDim2.new(0.075, 0, 0.075, 0),
            BackgroundTransparency = 1,
            Image = cfg.Logo,
            ZIndex = 5,
            Parent = LogoFrame,
        })
    end

    -- Title
    local TitleLabel = Create("TextLabel", {
        Position = UDim2.new(0, 52, 0, 6),
        Size = UDim2.new(0.5, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = cfg.Title or "NexusUI",
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        ZIndex = 3,
        Parent = TopBar,
    })
    local SubLabel = Create("TextLabel", {
        Position = UDim2.new(0, 52, 0, 26),
        Size = UDim2.new(0.5, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = cfg.SubTitle or "",
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        ZIndex = 3,
        Parent = TopBar,
    })

    -- Control Buttons
    local CtrlFrame = Create("Frame", {
        Position = UDim2.new(1, -100, 0.5, -12),
        Size = UDim2.new(0, 90, 0, 24),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = TopBar,
    })
    AddListLayout(CtrlFrame, Enum.FillDirection.Horizontal, 6, Enum.HorizontalAlignment.Right)

    local function MakeCtrlBtn(icon, col)
        local btn = Create("TextButton", {
            Size = UDim2.new(0, 24, 0, 24),
            BackgroundColor3 = Theme.Surface,
            Text = icon,
            TextColor3 = col or Theme.TextDim,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            ZIndex = 4,
            Parent = CtrlFrame,
        })
        AddCorner(btn, 6)
        btn.MouseEnter:Connect(function()
            Tween(btn, T.Fast, { BackgroundColor3 = col or Accent, TextColor3 = Color3.new(1,1,1) })
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, T.Fast, { BackgroundColor3 = Theme.Surface, TextColor3 = col or Theme.TextDim })
        end)
        return btn
    end

    local CloseBtn    = MakeCtrlBtn("✕", Theme.Error)
    local MinimizeBtn = MakeCtrlBtn("—")

    -- ── Tab Bar ────────────────────────────
    local TabBarScroll = Create("ScrollingFrame", {
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(0, 155, 1, -48),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel  = 0,
        ScrollBarThickness = 0,
        ZIndex = 2,
        Parent = Main,
    })
    AddListLayout(TabBarScroll, Enum.FillDirection.Vertical, 3)
    AddPadding(TabBarScroll, 8, 8, 8, 8)

    -- Divider
    Create("Frame", {
        Position = UDim2.new(0, 155, 0, 48),
        Size = UDim2.new(0, 1, 1, -48),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main,
    })

    -- ── Content Area ───────────────────────
    local ContentFrame = Create("Frame", {
        Position = UDim2.new(0, 156, 0, 48),
        Size = UDim2.new(1, -156, 1, -48),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = Main,
    })

    MakeDraggable(TopBar, Main)

    -- ── Animate In ─────────────────────────
    Main.BackgroundTransparency = 1
    Main.Size = UDim2.new(WinSize.X.Scale, WinSize.X.Offset, 0, 0)
    task.defer(function()
        Tween(Main, T.Bounce, { BackgroundTransparency = 0, Size = WinSize })
    end)

    -- ── Minimize ───────────────────────────
    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(Main, T.Medium, { Size = UDim2.new(WinSize.X.Scale, WinSize.X.Offset, 0, 48) })
            MinimizeBtn.Text = "□"
        else
            Tween(Main, T.Medium, { Size = WinSize })
            MinimizeBtn.Text = "—"
        end
    end)

    -- ── Close ──────────────────────────────
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, T.Medium, { BackgroundTransparency = 1, Size = UDim2.new(WinSize.X.Scale, WinSize.X.Offset, 0, 0) })
        task.delay(0.35, function() ScreenGui:Destroy() end)
    end)

    -- ════════════════════════════════════════
    --              ADD TAB
    -- ════════════════════════════════════════
    function W:AddTab(tabCfg)
        tabCfg = tabCfg or {}
        local Tab = {}

        -- Tab Button
        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel  = 0,
            Text = "",
            ZIndex = 3,
            Parent = TabBarScroll,
        })
        AddCorner(TabBtn, 8)

        -- Indicator
        local Indicator = Create("Frame", {
            Size = UDim2.new(0, 3, 0.7, 0),
            Position = UDim2.new(0, 0, 0.15, 0),
            BackgroundColor3 = Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            Parent = TabBtn,
        })
        AddCorner(Indicator, 4)

        local TabIcon = Create("TextLabel", {
            Position = UDim2.new(0, 10, 0.5, -9),
            Size = UDim2.new(0, 18, 0, 18),
            BackgroundTransparency = 1,
            Text = tabCfg.Icon or "●",
            TextColor3 = Theme.TextMuted,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            ZIndex = 4,
            Parent = TabBtn,
        })
        local TabName = Create("TextLabel", {
            Position = UDim2.new(0, 32, 0.5, -8),
            Size = UDim2.new(1, -36, 0, 16),
            BackgroundTransparency = 1,
            Text = tabCfg.Name or "Tab",
            TextColor3 = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            ZIndex = 4,
            Parent = TabBtn,
        })

        -- Tab Page
        local TabPage = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = IsMobile and 5 or 3,
            ScrollBarImageColor3 = Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ZIndex = 3,
            Parent = ContentFrame,
        })
        AddListLayout(TabPage, Enum.FillDirection.Vertical, 6)
        AddPadding(TabPage, 10, 10, 10, 10)

        -- Auto Canvas (reliable)
        local layout = TabPage:FindFirstChildOfClass("UIListLayout")
        local function UpdateCanvas()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

        -- Also update when any child's size changes (for AutomaticSize sections)
        TabPage.ChildAdded:Connect(function(child)
            task.defer(UpdateCanvas)
            if child:IsA("Frame") then
                child:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateCanvas)
            end
        end)

        -- Select Function
        local function Select()
            for _, t in ipairs(Tabs) do
                Tween(t.btn, T.Fast, { BackgroundColor3 = Theme.Tertiary })
                Tween(t.icon, T.Fast, { TextColor3 = Theme.TextMuted })
                Tween(t.label, T.Fast, { TextColor3 = Theme.TextDim, TextSize = 13 })
                t.label.Font = Enum.Font.Gotham
                Tween(t.indicator, T.Fast, { BackgroundTransparency = 1 })
                t.page.Visible = false
            end
            Tween(TabBtn, T.Fast, { BackgroundColor3 = Theme.Surface })
            Tween(TabIcon, T.Fast, { TextColor3 = Accent })
            Tween(TabName, T.Fast, { TextColor3 = Theme.Text, TextSize = 14 })
            TabName.Font = Enum.Font.GothamBold
            Tween(Indicator, T.Fast, { BackgroundTransparency = 0 })
            TabPage.Visible = true
            ActiveTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(function()
            Ripple(TabBtn, Accent)
            Select()
        end)
        TabBtn.MouseEnter:Connect(function()
            if ActiveTab ~= Tab then
                Tween(TabBtn, T.Fast, { BackgroundColor3 = Theme.SurfaceHover })
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if ActiveTab ~= Tab then
                Tween(TabBtn, T.Fast, { BackgroundColor3 = Theme.Tertiary })
            end
        end)

        table.insert(Tabs, {
            btn = TabBtn, icon = TabIcon, label = TabName,
            indicator = Indicator, page = TabPage
        })

        if #Tabs == 1 then Select() end

        -- ══════════════════════════════════════
        --            ADD SECTION
        -- ══════════════════════════════════════
        function Tab:AddSection(sCfg)
            sCfg = sCfg or {}
            local Section = {}

            local SectionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel  = 0,
                AutomaticSize    = Enum.AutomaticSize.Y,
                ZIndex = 4,
                Parent = TabPage,
            })
            AddCorner(SectionFrame, 10)
            AddStroke(SectionFrame, Theme.Border, 1)

            -- Section Header
            local SHeader = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Theme.Tertiary,
                BorderSizePixel  = 0,
                ZIndex = 4,
                Parent = SectionFrame,
            })
            AddCorner(SHeader, 10)
            Create("Frame", {
                Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,1,-10),
                BackgroundColor3 = Theme.Tertiary, BorderSizePixel = 0, ZIndex = 4,
                Parent = SHeader,
            })
            -- Accent Bar
            Create("Frame", {
                Size = UDim2.new(0, 3, 0.6, 0),
                Position = UDim2.new(0, 10, 0.2, 0),
                BackgroundColor3 = Accent,
                BorderSizePixel = 0, ZIndex = 5, Parent = SHeader,
            })
            Create("TextLabel", {
                Position = UDim2.new(0, 18, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                BackgroundTransparency = 1,
                Text = sCfg.Name or "Section",
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                ZIndex = 5,
                Parent = SHeader,
            })

            -- Elements Container
            local ElemContainer = Create("Frame", {
                Position = UDim2.new(0, 0, 0, 32),
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 4,
                Parent = SectionFrame,
            })
            local elemLayout = AddListLayout(ElemContainer, Enum.FillDirection.Vertical, 2)
            AddPadding(ElemContainer, 4, 8, 8, 8)

            -- Propagate size up so TabPage canvas recalculates
            elemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                task.defer(function()
                    TabPage.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
                end)
            end)

            -- ── Element Builder ──────────────────
            local function NewElem(h)
                local f = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, h or 40),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel  = 0,
                    ZIndex = 5,
                    Parent = ElemContainer,
                })
                AddCorner(f, 8)
                return f
            end

            -- ════════════════════════════════════
            --           BUTTON
            -- ════════════════════════════════════
            function Section:AddButton(bCfg)
                bCfg = bCfg or {}
                local frame = NewElem(38)
                Tween(frame, T.Fast, { BackgroundColor3 = Theme.Surface })

                local Btn = Create("TextButton", {
                    Size = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 6,
                    Parent = frame,
                })
                local Lbl = Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = bCfg.Name or "Button",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    ZIndex = 6,
                    Parent = frame,
                })
                local BtnPill = Create("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 70, 0, 26),
                    BackgroundColor3 = Accent,
                    Text = bCfg.BtnText or "Execute",
                    TextColor3 = Color3.new(1,1,1),
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    ZIndex = 6,
                    Parent = frame,
                })
                AddCorner(BtnPill, 7)
                if bCfg.Icon then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(0, 20, 1, 0),
                        BackgroundTransparency = 1,
                        Text = bCfg.Icon,
                        TextColor3 = Accent,
                        Font = Enum.Font.GothamBold,
                        TextSize = 14, ZIndex = 6, Parent = frame,
                    })
                    Lbl.Position = UDim2.new(0, 34, 0, 0)
                end
                local function click()
                    Ripple(frame, Accent)
                    Tween(BtnPill, T.Fast, { BackgroundColor3 = Color3.new(1,1,1) })
                    task.delay(0.15, function()
                        Tween(BtnPill, T.Fast, { BackgroundColor3 = Accent })
                    end)
                    if bCfg.Callback then bCfg.Callback() end
                end
                Btn.MouseButton1Click:Connect(click)
                BtnPill.MouseButton1Click:Connect(click)
                Btn.MouseEnter:Connect(function() Tween(frame, T.Fast, { BackgroundColor3 = Theme.SurfaceHover }) end)
                Btn.MouseLeave:Connect(function() Tween(frame, T.Fast, { BackgroundColor3 = Theme.Surface }) end)
                return { Frame = frame, Label = Lbl }
            end

            -- ════════════════════════════════════
            --           TOGGLE
            -- ════════════════════════════════════
            function Section:AddToggle(tCfg)
                tCfg = tCfg or {}
                local Val = tCfg.Default or false
                local frame = NewElem(40)
                Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.65, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tCfg.Name or "Toggle",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    ZIndex = 6,
                    Parent = frame,
                })

                local Track = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.new(0, 44, 0, 24),
                    BackgroundColor3 = Theme.Surface,
                    ZIndex = 6,
                    Parent = frame,
                })
                AddCorner(Track, 12)
                AddStroke(Track, Theme.Border, 1)

                local Knob = Create("Frame", {
                    Position = UDim2.new(0, 3, 0.5, -9),
                    Size = UDim2.new(0, 18, 0, 18),
                    BackgroundColor3 = Theme.TextMuted,
                    ZIndex = 7,
                    Parent = Track,
                })
                AddCorner(Knob, 9)

                local function UpdateToggle(animate)
                    local ti = animate and T.Medium or T.Fast
                    if Val then
                        Tween(Track, ti, { BackgroundColor3 = Accent })
                        Tween(Knob,  ti, { Position = UDim2.new(0, 23, 0.5, -9), BackgroundColor3 = Color3.new(1,1,1) })
                    else
                        Tween(Track, ti, { BackgroundColor3 = Theme.Surface })
                        Tween(Knob,  ti, { Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Theme.TextMuted })
                    end
                end
                UpdateToggle(false)

                local Btn = Create("TextButton", {
                    Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
                    Text = "", ZIndex = 8, Parent = frame,
                })
                Btn.MouseButton1Click:Connect(function()
                    Val = not Val
                    UpdateToggle(true)
                    if tCfg.Callback then tCfg.Callback(Val) end
                end)
                Btn.MouseEnter:Connect(function() Tween(frame, T.Fast, { BackgroundColor3 = Theme.SurfaceHover }) end)
                Btn.MouseLeave:Connect(function() Tween(frame, T.Fast, { BackgroundColor3 = Theme.Tertiary }) end)

                local Elem = { Frame = frame }
                function Elem:Set(v)
                    Val = v; UpdateToggle(true)
                    if tCfg.Callback then tCfg.Callback(Val) end
                end
                function Elem:Get() return Val end
                return Elem
            end

            -- ════════════════════════════════════
            --           SLIDER
            -- ════════════════════════════════════
            function Section:AddSlider(sCfg2)
                sCfg2 = sCfg2 or {}
                local Min, Max = sCfg2.Min or 0, sCfg2.Max or 100
                local Val = math.clamp(sCfg2.Default or Min, Min, Max)
                local Suffix = sCfg2.Suffix or ""
                local frame = NewElem(52)

                Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 4),
                    Size = UDim2.new(0.6, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = sCfg2.Name or "Slider",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 6, Parent = frame,
                })
                local ValLabel = Create("TextLabel", {
                    Position = UDim2.new(0.6, 0, 0, 4),
                    Size = UDim2.new(0.35, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = tostring(Val) .. Suffix,
                    TextColor3 = Accent,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.GothamBold, TextSize = 13, ZIndex = 6, Parent = frame,
                })

                local Track = Create("Frame", {
                    Position = UDim2.new(0, 12, 0, 32),
                    Size = UDim2.new(1, -24, 0, 6),
                    BackgroundColor3 = Theme.Surface,
                    ZIndex = 6, Parent = frame,
                })
                AddCorner(Track, 3)

                local Fill = Create("Frame", {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Accent,
                    ZIndex = 7, Parent = Track,
                })
                AddCorner(Fill, 3)

                local Thumb = Create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundColor3 = Color3.new(1,1,1),
                    ZIndex = 8, Parent = Track,
                })
                AddCorner(Thumb, 8)
                AddStroke(Thumb, Accent, 2)

                local function UpdateSlider(pct, animate)
                    Val = math.floor(Min + (Max - Min) * pct + 0.5)
                    ValLabel.Text = tostring(Val) .. Suffix
                    local ti = animate and T.Fast or TweenInfo.new(0)
                    Tween(Fill,  ti, { Size = UDim2.new(pct, 0, 1, 0) })
                    Tween(Thumb, ti, { Position = UDim2.new(pct, 0, 0.5, 0) })
                end

                local pct = (Val - Min) / (Max - Min)
                UpdateSlider(pct, false)

                local Dragging = false
                Track.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        if Dragging then
                            Dragging = false
                            if sCfg2.Callback then sCfg2.Callback(Val) end
                        end
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                        or i.UserInputType == Enum.UserInputType.Touch) then
                        local abs = Track.AbsolutePosition.X
                        local w   = Track.AbsoluteSize.X
                        local p   = math.clamp((i.Position.X - abs) / w, 0, 1)
                        UpdateSlider(p, true)
                    end
                end)

                local Elem = { Frame = frame }
                function Elem:Set(v)
                    local p = math.clamp((v - Min) / (Max - Min), 0, 1)
                    UpdateSlider(p, true)
                    if sCfg2.Callback then sCfg2.Callback(Val) end
                end
                function Elem:Get() return Val end
                return Elem
            end

            -- ════════════════════════════════════
            --           DROPDOWN
            -- ════════════════════════════════════
            function Section:AddDropdown(dCfg)
                dCfg = dCfg or {}
                local Options = dCfg.Options or {}
                local Val = dCfg.Default or (Options[1] or "")
                local Opened = false
                local frame = NewElem(40)

                Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = dCfg.Name or "Dropdown",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 6, Parent = frame,
                })

                local DropBtn = Create("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0.45, -10, 0, 28),
                    BackgroundColor3 = Theme.Surface,
                    Text = "", ZIndex = 6, Parent = frame,
                })
                AddCorner(DropBtn, 7)
                AddStroke(DropBtn, Theme.Border, 1)

                local DropLabel = Create("TextLabel", {
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(1, -28, 1, 0),
                    BackgroundTransparency = 1,
                    Text = Val,
                    TextColor3 = Accent,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 7,
                    Parent = DropBtn,
                })
                local Arrow = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundTransparency = 1,
                    Text = "▾",
                    TextColor3 = Theme.TextDim,
                    Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 7,
                    Parent = DropBtn,
                })

                -- Dropdown List
                local ListHolder = Create("Frame", {
                    Position = UDim2.new(0.55, -10, 1, 2),
                    Size = UDim2.new(0.45, -10, 0, 0),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel  = 0,
                    ClipsDescendants = true,
                    ZIndex = 20,
                    Parent = frame,
                })
                AddCorner(ListHolder, 8)
                AddStroke(ListHolder, Accent, 1)

                local ListScroll = Create("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Accent,
                    ZIndex = 21,
                    Parent = ListHolder,
                })
                AddListLayout(ListScroll, Enum.FillDirection.Vertical, 2)
                AddPadding(ListScroll, 4, 4, 4, 4)

                local maxH = math.min(#Options * 28 + 8, 140)

                for _, opt in ipairs(Options) do
                    local optBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = Theme.Tertiary,
                        Text = "", ZIndex = 22, Parent = ListScroll,
                    })
                    AddCorner(optBtn, 6)
                    local optLabel = Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(1, -8, 1, 0),
                        BackgroundTransparency = 1,
                        Text = opt,
                        TextColor3 = opt == Val and Accent or Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Font = opt == Val and Enum.Font.GothamBold or Enum.Font.Gotham,
                        TextSize = 12, ZIndex = 23, Parent = optBtn,
                    })
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, T.Fast, { BackgroundColor3 = Theme.SurfaceHover })
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, T.Fast, { BackgroundColor3 = Theme.Tertiary })
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        Val = opt
                        DropLabel.Text = opt
                        -- reset all
                        for _, c in ipairs(ListScroll:GetChildren()) do
                            if c:IsA("TextButton") then
                                local lb = c:FindFirstChildOfClass("TextLabel")
                                if lb then
                                    lb.TextColor3 = lb.Text == Val and Accent or Theme.TextDim
                                    lb.Font = lb.Text == Val and Enum.Font.GothamBold or Enum.Font.Gotham
                                end
                            end
                        end
                        Opened = false
                        Tween(ListHolder, T.Fast, { Size = UDim2.new(0.45, -10, 0, 0) })
                        Tween(Arrow, T.Fast, { Rotation = 0 })
                        if dCfg.Callback then dCfg.Callback(Val) end
                    end)
                end

                ListScroll.CanvasSize = UDim2.new(0, 0, 0, maxH)

                DropBtn.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    if Opened then
                        Tween(ListHolder, T.Medium, { Size = UDim2.new(0.45, -10, 0, maxH) })
                        Tween(Arrow, T.Fast, { Rotation = 180 })
                    else
                        Tween(ListHolder, T.Fast, { Size = UDim2.new(0.45, -10, 0, 0) })
                        Tween(Arrow, T.Fast, { Rotation = 0 })
                    end
                end)

                local Elem = { Frame = frame }
                function Elem:Set(v) Val = v; DropLabel.Text = v end
                function Elem:Get() return Val end
                return Elem
            end

            -- ════════════════════════════════════
            --         MULTI DROPDOWN
            -- ════════════════════════════════════
            function Section:AddMultiDropdown(mCfg)
                mCfg = mCfg or {}
                local Options = mCfg.Options or {}
                local Selected = {}
                if mCfg.Default then
                    for _, v in ipairs(mCfg.Default) do Selected[v] = true end
                end
                local Opened = false
                local frame = NewElem(40)

                Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = mCfg.Name or "Multi Select",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 6, Parent = frame,
                })

                local DropBtn = Create("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0.45, -10, 0, 28),
                    BackgroundColor3 = Theme.Surface,
                    Text = "", ZIndex = 6, Parent = frame,
                })
                AddCorner(DropBtn, 7)
                AddStroke(DropBtn, Theme.Border, 1)

                local DropLabel = Create("TextLabel", {
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(1, -28, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "Select...",
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 11, ZIndex = 7, Parent = DropBtn,
                })
                Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundTransparency = 1,
                    Text = "▾",
                    TextColor3 = Theme.TextDim,
                    Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 7, Parent = DropBtn,
                })

                local ListHolder = Create("Frame", {
                    Position = UDim2.new(0.55, -10, 1, 2),
                    Size = UDim2.new(0.45, -10, 0, 0),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel  = 0,
                    ClipsDescendants = true,
                    ZIndex = 20,
                    Parent = frame,
                })
                AddCorner(ListHolder, 8)
                AddStroke(ListHolder, Accent, 1)

                local ListScroll = Create("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Accent,
                    ZIndex = 21, Parent = ListHolder,
                })
                AddListLayout(ListScroll, Enum.FillDirection.Vertical, 2)
                AddPadding(ListScroll, 4, 4, 4, 4)

                local function UpdateLabel()
                    local t = {}
                    for k in pairs(Selected) do table.insert(t, k) end
                    if #t == 0 then
                        DropLabel.Text = "Select..."
                        DropLabel.TextColor3 = Theme.TextDim
                    else
                        DropLabel.Text = table.concat(t, ", ")
                        DropLabel.TextColor3 = Accent
                    end
                end

                local maxH = math.min(#Options * 30 + 8, 150)

                for _, opt in ipairs(Options) do
                    local row = Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = Theme.Tertiary,
                        ZIndex = 22, Parent = ListScroll,
                    })
                    AddCorner(row, 6)

                    local chk = Create("Frame", {
                        Position = UDim2.new(0, 6, 0.5, -9),
                        Size = UDim2.new(0, 18, 0, 18),
                        BackgroundColor3 = Selected[opt] and Accent or Theme.Surface,
                        ZIndex = 23, Parent = row,
                    })
                    AddCorner(chk, 5)
                    AddStroke(chk, Accent, 1)
                    local chkMark = Create("TextLabel", {
                        Size = UDim2.new(1,0,1,0),
                        BackgroundTransparency = 1,
                        Text = "✓",
                        TextColor3 = Color3.new(1,1,1),
                        Font = Enum.Font.GothamBold, TextSize = 12,
                        TextTransparency = Selected[opt] and 0 or 1,
                        ZIndex = 24, Parent = chk,
                    })

                    Create("TextLabel", {
                        Position = UDim2.new(0, 30, 0, 0),
                        Size = UDim2.new(1, -34, 1, 0),
                        BackgroundTransparency = 1,
                        Text = opt,
                        TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 23, Parent = row,
                    })

                    local rowBtn = Create("TextButton", {
                        Size = UDim2.new(1,0,1,0),
                        BackgroundTransparency = 1,
                        Text = "", ZIndex = 25, Parent = row,
                    })
                    rowBtn.MouseEnter:Connect(function()
                        Tween(row, T.Fast, { BackgroundColor3 = Theme.SurfaceHover })
                    end)
                    rowBtn.MouseLeave:Connect(function()
                        Tween(row, T.Fast, { BackgroundColor3 = Theme.Tertiary })
                    end)
                    rowBtn.MouseButton1Click:Connect(function()
                        if Selected[opt] then
                            Selected[opt] = nil
                            Tween(chk, T.Fast, { BackgroundColor3 = Theme.Surface })
                            Tween(chkMark, T.Fast, { TextTransparency = 1 })
                        else
                            Selected[opt] = true
                            Tween(chk, T.Fast, { BackgroundColor3 = Accent })
                            Tween(chkMark, T.Fast, { TextTransparency = 0 })
                        end
                        UpdateLabel()
                        if mCfg.Callback then
                            local t = {}
                            for k in pairs(Selected) do table.insert(t, k) end
                            mCfg.Callback(t)
                        end
                    end)
                end

                ListScroll.CanvasSize = UDim2.new(0, 0, 0, maxH)

                DropBtn.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    Tween(ListHolder, Opened and T.Medium or T.Fast,
                        { Size = UDim2.new(0.45, -10, 0, Opened and maxH or 0) })
                end)

                UpdateLabel()
                local Elem = { Frame = frame }
                function Elem:Get()
                    local t = {}
                    for k in pairs(Selected) do table.insert(t, k) end
                    return t
                end
                return Elem
            end

            -- ════════════════════════════════════
            --           TEXTBOX
            -- ════════════════════════════════════
            function Section:AddTextbox(tbCfg)
                tbCfg = tbCfg or {}
                local frame = NewElem(40)
                Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tbCfg.Name or "Input",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 6, Parent = frame,
                })
                local InputBox = Create("TextBox", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0.55, -10, 0, 28),
                    BackgroundColor3 = Theme.Surface,
                    Text = tbCfg.Default or "",
                    PlaceholderText = tbCfg.PlaceHolder or "Type...",
                    PlaceholderColor3 = Theme.TextMuted,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 12,
                    ClearTextOnFocus = tbCfg.Clear or false,
                    ZIndex = 6, Parent = frame,
                })
                AddCorner(InputBox, 7)
                AddPadding(InputBox, 0, 6, 0, 8)
                local stroke = AddStroke(InputBox, Theme.Border, 1)
                InputBox.Focused:Connect(function()
                    Tween(stroke, T.Fast, { Color = Accent })
                    Tween(InputBox, T.Fast, { BackgroundColor3 = Theme.SurfaceHover })
                end)
                InputBox.FocusLost:Connect(function(enter)
                    Tween(stroke, T.Fast, { Color = Theme.Border })
                    Tween(InputBox, T.Fast, { BackgroundColor3 = Theme.Surface })
                    if tbCfg.Callback then tbCfg.Callback(InputBox.Text, enter) end
                end)
                local Elem = { Frame = frame, Input = InputBox }
                function Elem:Set(v) InputBox.Text = v end
                function Elem:Get() return InputBox.Text end
                return Elem
            end

            -- ════════════════════════════════════
            --           PARAGRAPH
            -- ════════════════════════════════════
            function Section:AddParagraph(pCfg)
                pCfg = pCfg or {}
                local frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel  = 0,
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    ZIndex = 5,
                    Parent = ElemContainer,
                })
                AddCorner(frame, 8)
                AddPadding(frame, 8, 12, 8, 12)

                local inner = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 6, Parent = frame,
                })
                AddListLayout(inner, Enum.FillDirection.Vertical, 4)

                if pCfg.Title and pCfg.Title ~= "" then
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 18),
                        BackgroundTransparency = 1,
                        Text = pCfg.Title,
                        TextColor3 = Accent,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Font = Enum.Font.GothamBold, TextSize = 13, ZIndex = 7, Parent = inner,
                    })
                end
                local contentLabel = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text = pCfg.Content or "",
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 7, Parent = inner,
                })
                local Elem = { Frame = frame }
                function Elem:SetContent(t) contentLabel.Text = t end
                return Elem
            end

            -- ════════════════════════════════════
            --         COLOR PICKER
            -- ════════════════════════════════════
            function Section:AddColorPicker(cpCfg)
                cpCfg = cpCfg or {}
                local Val = cpCfg.Default or Color3.new(1, 0.3, 0.3)
                local Opened = false
                local frame = NewElem(40)

                Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = cpCfg.Name or "Color",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 6, Parent = frame,
                })
                local Preview = Create("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 34, 0, 24),
                    BackgroundColor3 = Val,
                    Text = "", ZIndex = 6, Parent = frame,
                })
                AddCorner(Preview, 7)
                AddStroke(Preview, Theme.Border, 1)

                -- Simple Hue Picker
                local Picker = Create("Frame", {
                    Position = UDim2.new(0, 10, 1, 4),
                    Size = UDim2.new(1, -20, 0, 0),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    ZIndex = 20, Parent = frame,
                })
                AddCorner(Picker, 8)
                AddStroke(Picker, Accent, 1)

                local HueBar = Create("Frame", {
                    Position = UDim2.new(0, 8, 0, 10),
                    Size = UDim2.new(1, -16, 0, 16),
                    BackgroundColor3 = Color3.new(1,1,1),
                    ZIndex = 21, Parent = Picker,
                })
                AddCorner(HueBar, 5)
                -- Hue gradient
                local hueGrad = Instance.new("UIGradient")
                hueGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,   1, 1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
                    ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,   1, 1)),
                })
                hueGrad.Parent = HueBar

                local HueBtn = Create("TextButton", {
                    Size = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    Text = "", ZIndex = 22, Parent = HueBar,
                })

                local function pickHue(i)
                    local pct = math.clamp((i.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                    Val = Color3.fromHSV(pct, 1, 1)
                    Tween(Preview, T.Fast, { BackgroundColor3 = Val })
                    if cpCfg.Callback then cpCfg.Callback(Val) end
                end

                local hDrag = false
                HueBtn.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        hDrag = true; pickHue(i)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then hDrag = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if hDrag then pickHue(i) end
                end)

                Preview.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    Tween(Picker, T.Medium, { Size = UDim2.new(1, -20, 0, Opened and 40 or 0) })
                end)

                local Elem = { Frame = frame }
                function Elem:Set(c) Val = c; Preview.BackgroundColor3 = c end
                function Elem:Get() return Val end
                return Elem
            end

            -- ════════════════════════════════════
            --           KEYBIND
            -- ════════════════════════════════════
            function Section:AddKeybind(kCfg)
                kCfg = kCfg or {}
                local Val = kCfg.Default or Enum.KeyCode.Unknown
                local Listening = false
                local frame = NewElem(40)

                Create("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.6, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = kCfg.Name or "Keybind",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 6, Parent = frame,
                })
                local KeyBtn = Create("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 80, 0, 26),
                    BackgroundColor3 = Theme.Surface,
                    Text = Val == Enum.KeyCode.Unknown and "None" or Val.Name,
                    TextColor3 = Accent,
                    Font = Enum.Font.GothamBold, TextSize = 11,
                    ZIndex = 6, Parent = frame,
                })
                AddCorner(KeyBtn, 7)
                AddStroke(KeyBtn, Accent, 1)

                KeyBtn.MouseButton1Click:Connect(function()
                    Listening = true
                    KeyBtn.Text = "..."
                    Tween(KeyBtn, T.Fast, { BackgroundColor3 = Accent })
                    Tween(KeyBtn, T.Fast, { TextColor3 = Color3.new(1,1,1) })
                end)
                UserInputService.InputBegan:Connect(function(i, gp)
                    if gp then return end
                    if Listening and i.UserInputType == Enum.UserInputType.Keyboard then
                        Val = i.KeyCode
                        KeyBtn.Text = Val.Name
                        Listening = false
                        Tween(KeyBtn, T.Fast, { BackgroundColor3 = Theme.Surface })
                        Tween(KeyBtn, T.Fast, { TextColor3 = Accent })
                        if kCfg.Callback then kCfg.Callback(Val) end
                    elseif not Listening and i.UserInputType == Enum.UserInputType.Keyboard
                        and i.KeyCode == Val then
                        if kCfg.PressCallback then kCfg.PressCallback() end
                    end
                end)

                local Elem = { Frame = frame }
                function Elem:Get() return Val end
                return Elem
            end

            -- ════════════════════════════════════
            --          DRIVE / IMAGE BOX
            -- ════════════════════════════════════
            function Section:AddImageBox(imgCfg)
                imgCfg = imgCfg or {}
                local h = imgCfg.Height or 120
                local frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, h),
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel  = 0,
                    ClipsDescendants = true,
                    ZIndex = 5,
                    Parent = ElemContainer,
                })
                AddCorner(frame, 8)
                AddStroke(frame, Theme.Border, 1)

                if imgCfg.Image then
                    Create("ImageLabel", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Image = imgCfg.Image,
                        ScaleType = imgCfg.ScaleType or Enum.ScaleType.Crop,
                        ZIndex = 6, Parent = frame,
                    })
                end
                if imgCfg.Caption then
                    local overlay = Create("Frame", {
                        Position = UDim2.new(0, 0, 1, -30),
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Color3.new(0,0,0),
                        BackgroundTransparency = 0.4,
                        ZIndex = 7, Parent = frame,
                    })
                    Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(1, -16, 1, 0),
                        BackgroundTransparency = 1,
                        Text = imgCfg.Caption,
                        TextColor3 = Color3.new(1,1,1),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 8, Parent = overlay,
                    })
                end
                return { Frame = frame }
            end

            -- ── Box (info box) ──────────────────
            function Section:AddBox(boxCfg)
                boxCfg = boxCfg or {}
                local col = boxCfg.Color or Theme.Info
                local frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(
                        math.floor(col.R*255*0.15),
                        math.floor(col.G*255*0.15),
                        math.floor(col.B*255*0.15)
                    ),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0, ZIndex = 5, Parent = ElemContainer,
                })
                AddCorner(frame, 8)
                AddStroke(frame, col, 1)
                AddPadding(frame, 8, 10, 8, 38)

                Create("TextLabel", {
                    Position = UDim2.new(0, 10, 0.5, -9),
                    Size = UDim2.new(0, 18, 0, 18),
                    BackgroundTransparency = 1,
                    Text = boxCfg.Icon or "ℹ",
                    TextColor3 = col, Font = Enum.Font.GothamBold,
                    TextSize = 14, ZIndex = 6, Parent = frame,
                })
                local lbl = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text = boxCfg.Text or "",
                    TextColor3 = Theme.Text, TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 6, Parent = frame,
                })
                local Elem = { Frame = frame }
                function Elem:SetText(t) lbl.Text = t end
                return Elem
            end

            return Section
        end

        return Tab
    end

    -- ════════════════════════════════════════
    --           NOTIFICATION SYSTEM
    -- ════════════════════════════════════════
    function W:Notify(nCfg)
        nCfg = nCfg or {}
        local typeColors = {
            Success = Theme.Success, Warning = Theme.Warning,
            Error = Theme.Error, Info = Theme.Info
        }
        local typeIcons = { Success = "✓", Warning = "⚠", Error = "✕", Info = "ℹ" }
        local nType = nCfg.Type or "Info"
        local col   = typeColors[nType] or Theme.Info
        local icon  = typeIcons[nType] or "ℹ"
        local dur   = nCfg.Duration or 4

        local NotifFrame = Create("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -12, 1, 60),
            Size = UDim2.new(0, 280, 0, 70),
            BackgroundColor3 = Theme.Secondary,
            BorderSizePixel  = 0,
            ZIndex = 100,
            Parent = ScreenGui,
        })
        AddCorner(NotifFrame, 12)
        AddStroke(NotifFrame, col, 1.5)

        -- Progress bar
        local Bar = Create("Frame", {
            Position = UDim2.new(0, 0, 1, -3),
            Size = UDim2.new(1, 0, 0, 3),
            BackgroundColor3 = col,
            BorderSizePixel = 0, ZIndex = 101, Parent = NotifFrame,
        })
        AddCorner(Bar, 2)

        -- Icon
        local IconBox = Create("Frame", {
            Position = UDim2.new(0, 10, 0.5, -16),
            Size = UDim2.new(0, 32, 0, 32),
            BackgroundColor3 = col,
            BackgroundTransparency = 0.8,
            ZIndex = 101, Parent = NotifFrame,
        })
        AddCorner(IconBox, 8)
        Create("TextLabel", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            Text = icon, TextColor3 = col,
            Font = Enum.Font.GothamBold, TextSize = 16, ZIndex = 102, Parent = IconBox,
        })

        Create("TextLabel", {
            Position = UDim2.new(0, 50, 0, 10),
            Size = UDim2.new(1, -60, 0, 18),
            BackgroundTransparency = 1,
            Text = nCfg.Title or nType,
            TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.GothamBold, TextSize = 13, ZIndex = 101, Parent = NotifFrame,
        })
        Create("TextLabel", {
            Position = UDim2.new(0, 50, 0, 30),
            Size = UDim2.new(1, -60, 0, 28),
            BackgroundTransparency = 1,
            Text = nCfg.Message or "",
            TextColor3 = Theme.TextDim, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true, Font = Enum.Font.Gotham, TextSize = 11, ZIndex = 101, Parent = NotifFrame,
        })

        -- Slide in
        task.defer(function()
            Tween(NotifFrame, T.Bounce, { Position = UDim2.new(1, -12, 1, -12) })
        end)

        -- Progress drain
        TweenService:Create(Bar, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 3)
        }):Play()

        -- Slide out
        task.delay(dur, function()
            Tween(NotifFrame, T.Medium, { Position = UDim2.new(1, 280, 1, -12), BackgroundTransparency = 1 })
            task.delay(0.4, function() NotifFrame:Destroy() end)
        end)

        -- Click to dismiss
        Create("TextButton", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            Text = "", ZIndex = 103, Parent = NotifFrame,
        }).MouseButton1Click:Connect(function()
            Tween(NotifFrame, T.Fast, { Position = UDim2.new(1, 280, 1, -12) })
            task.delay(0.2, function() NotifFrame:Destroy() end)
        end)
    end

    -- ── Toggle UI visibility (image button) ──
    local ToggleBtn = Create("ImageButton", {
        Position = cfg.TogglePos or UDim2.new(0, 16, 0.5, -20),
        Size = UDim2.new(0, 40, 0, 40),
        BackgroundColor3 = Accent,
        Image = cfg.ToggleImage or "rbxassetid://6026568198",
        ImageColor3 = Color3.new(1,1,1),
        ZIndex = 50,
        Parent = ScreenGui,
    })
    AddCorner(ToggleBtn, 10)
    local stroke2 = AddStroke(ToggleBtn, Color3.new(1,1,1), 1.5)
    stroke2.Transparency = 0.6

    local UIVisible = true
    ToggleBtn.MouseButton1Click:Connect(function()
        UIVisible = not UIVisible
        if UIVisible then
            Main.Visible = true
            Tween(Main, T.Bounce, { BackgroundTransparency = 0, Size = WinSize })
            Tween(ToggleBtn, T.Fast, { Rotation = 0 })
        else
            Tween(Main, T.Medium, { BackgroundTransparency = 1, Size = UDim2.new(WinSize.X.Scale, WinSize.X.Offset, 0, 0) })
            Tween(ToggleBtn, T.Fast, { Rotation = 90 })
            task.delay(0.35, function() if not UIVisible then Main.Visible = false end end)
        end
        Ripple(ToggleBtn, Color3.new(1,1,1))
    end)

    -- ── Update Title / Size ────────────────
    function W:SetTitle(t, s)
        TitleLabel.Text = t or TitleLabel.Text
        if s then SubLabel.Text = s end
    end
    function W:SetSize(sz)
        WinSize = sz
        Tween(Main, T.Medium, { Size = sz })
    end
    function W:SetAccent(c)
        Accent = c
    end
    function W:Destroy()
        ScreenGui:Destroy()
    end
    function W:Toggle()
        ToggleBtn.MouseButton1Click:Fire()
    end

    return W
end

return NexusUI
