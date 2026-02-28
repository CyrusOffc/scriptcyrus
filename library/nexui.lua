local NexusUI = {}
NexusUI.__index = NexusUI

-- ── Services ──────────────────────────────
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")

local Player    = Players.LocalPlayer
local IsMobile  = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ── Tween ─────────────────────────────────
local function Tween(o, i, p) TweenService:Create(o, i, p):Play() end
local TI = {
    Fast   = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Med    = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
}

-- ── Themes ────────────────────────────────
local Themes = {
    Dark = {
        Bg         = Color3.fromRGB(15,  15,  20),
        Bg2        = Color3.fromRGB(22,  22,  30),
        Bg3        = Color3.fromRGB(30,  30,  42),
        Surface    = Color3.fromRGB(38,  38,  52),
        SurfaceHov = Color3.fromRGB(50,  50,  68),
        Border     = Color3.fromRGB(55,  55,  75),
        Text       = Color3.fromRGB(230, 230, 240),
        TextDim    = Color3.fromRGB(140, 140, 160),
        TextMut    = Color3.fromRGB(75,  75,  100),
        Success    = Color3.fromRGB(80,  200, 120),
        Warning    = Color3.fromRGB(255, 190, 60),
        Error      = Color3.fromRGB(255, 80,  80),
        Info       = Color3.fromRGB(80,  160, 255),
    },
    Light = {
        Bg         = Color3.fromRGB(245, 245, 250),
        Bg2        = Color3.fromRGB(232, 232, 242),
        Bg3        = Color3.fromRGB(218, 218, 232),
        Surface    = Color3.fromRGB(205, 205, 225),
        SurfaceHov = Color3.fromRGB(190, 190, 212),
        Border     = Color3.fromRGB(185, 185, 208),
        Text       = Color3.fromRGB(20,  20,  35),
        TextDim    = Color3.fromRGB(85,  85,  110),
        TextMut    = Color3.fromRGB(150, 150, 172),
        Success    = Color3.fromRGB(40,  160, 80),
        Warning    = Color3.fromRGB(200, 140, 10),
        Error      = Color3.fromRGB(200, 45,  45),
        Info       = Color3.fromRGB(45,  110, 210),
    },
    Neon = {
        Bg         = Color3.fromRGB(5,   5,   12),
        Bg2        = Color3.fromRGB(10,  10,  22),
        Bg3        = Color3.fromRGB(15,  15,  32),
        Surface    = Color3.fromRGB(20,  20,  42),
        SurfaceHov = Color3.fromRGB(28,  28,  55),
        Border     = Color3.fromRGB(80,  40,  130),
        Text       = Color3.fromRGB(240, 230, 255),
        TextDim    = Color3.fromRGB(160, 130, 200),
        TextMut    = Color3.fromRGB(85,  65,  125),
        Success    = Color3.fromRGB(60,  255, 160),
        Warning    = Color3.fromRGB(255, 210, 0),
        Error      = Color3.fromRGB(255, 50,  100),
        Info       = Color3.fromRGB(100, 180, 255),
    },
}

-- ── Helpers ───────────────────────────────
local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props) do
        if k ~= "Parent" then pcall(function() o[k] = v end) end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end
local function Corner(p, r)  New("UICorner",  { CornerRadius = UDim.new(0, r or 8), Parent = p }) end
local function Stroke(p,c,t) return New("UIStroke", { Color = c, Thickness = t or 1, Parent = p }) end
local function Pad(p,t,r,b,l)
    New("UIPadding", {
        PaddingTop = UDim.new(0,t or 6), PaddingRight  = UDim.new(0,r or 6),
        PaddingBottom = UDim.new(0,b or 6), PaddingLeft = UDim.new(0,l or 6),
        Parent = p
    })
end
local function List(p, dir, gap)
    return New("UIListLayout", {
        FillDirection = dir or Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, gap or 4),
        Parent = p,
    })
end
local function Ripple(btn, col)
    local r = New("Frame", {
        Size = UDim2.new(0,0,0,0), AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        BackgroundColor3 = col or Color3.new(1,1,1),
        BackgroundTransparency = 0.65, ZIndex = btn.ZIndex+5, Parent = btn,
    })
    Corner(r, 999)
    local s = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.5
    Tween(r, TI.Med, { Size = UDim2.new(0,s,0,s), BackgroundTransparency = 1 })
    task.delay(0.3, function() r:Destroy() end)
end

-- ── Drag ──────────────────────────────────
local function Drag(handle, target)
    local active, start, origin = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            active, start, origin = true, i.Position, target.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then active = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if active and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            target.Position = UDim2.new(origin.X.Scale, origin.X.Offset+d.X, origin.Y.Scale, origin.Y.Offset+d.Y)
        end
    end)
end

-- ════════════════════════════════════════════
--             CREATE WINDOW
-- ════════════════════════════════════════════
function NexusUI:CreateWindow(cfg)
    cfg = cfg or {}
    local W       = {}
    local TH      = Themes[cfg.Theme or "Dark"]
    local Accent  = cfg.AccentColor or Color3.fromRGB(100, 160, 255)
    local WSize   = cfg.Size or UDim2.new(0, 530, 0, 420)
    local WPos    = cfg.Position or UDim2.new(0.5, -265, 0.5, -210)
    local Tabs    = {}
    local ActiveTab = nil
    local OpenPopups = {} -- track all open popups to close on outside click

    -- ── ScreenGui ──────────────────────────
    local SG = New("ScreenGui", {
        Name = "NexusUI", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    -- Safe parent: gethui() > CoreGui > PlayerGui
    local function safeParent(gui)
        if typeof(gethui) == "function" then
            pcall(function() gui.Parent = gethui() end)
        end
        if not gui.Parent or gui.Parent == nil then
            pcall(function() gui.Parent = game:GetService("CoreGui") end)
        end
        if not gui.Parent or gui.Parent == nil then
            gui.Parent = Player:WaitForChild("PlayerGui")
        end
    end
    safeParent(SG)

    -- Close popups when clicking outside (UserInputService, not SG.InputBegan)
    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            for _, popup in ipairs(OpenPopups) do
                if popup and popup.Parent and popup.Visible then
                    local abs = popup.AbsolutePosition
                    local sz  = popup.AbsoluteSize
                    local pos = i.Position
                    if pos.X < abs.X or pos.X > abs.X+sz.X or pos.Y < abs.Y or pos.Y > abs.Y+sz.Y then
                        popup.Visible = false
                    end
                end
            end
        end
    end)

    -- ── Main Window ────────────────────────
    local Main = New("Frame", {
        Name = "Main", Size = UDim2.new(WSize.X.Scale,WSize.X.Offset,0,0),
        Position = WPos, BackgroundColor3 = TH.Bg,
        BorderSizePixel = 0, ClipsDescendants = false, Parent = SG,
    })
    Corner(Main, 14)
    Stroke(Main, TH.Border, 1.5)

    New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,8), Size = UDim2.new(1,40,1,40),
        BackgroundTransparency = 1, Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0,0,0), ImageTransparency = 0.55,
        ZIndex = 0, Parent = Main,
    })

    -- ── TopBar ─────────────────────────────
    local TopBar = New("Frame", {
        Size = UDim2.new(1,0,0,48), BackgroundColor3 = TH.Bg2,
        BorderSizePixel = 0, ZIndex = 2, Parent = Main,
    })
    Corner(TopBar, 14)
    New("Frame", { Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,1,-14),
        BackgroundColor3 = TH.Bg2, BorderSizePixel = 0, ZIndex = 2, Parent = TopBar })

    local LogoBox = New("Frame", {
        Size = UDim2.new(0,32,0,32), Position = UDim2.new(0,12,0.5,-16),
        BackgroundColor3 = Accent, ZIndex = 3, Parent = TopBar,
    })
    Corner(LogoBox, 8)
    local LogoLbl = New("TextLabel", {
        Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Text = cfg.LogoText or "N", TextColor3 = Color3.new(1,1,1),
        TextScaled = true, Font = Enum.Font.GothamBold, ZIndex = 4, Parent = LogoBox,
    })
    if cfg.Logo then
        LogoLbl.Text = ""
        New("ImageLabel", { Size = UDim2.new(0.85,0,0.85,0), Position = UDim2.new(0.075,0,0.075,0),
            BackgroundTransparency = 1, Image = cfg.Logo, ZIndex = 5, Parent = LogoBox })
    end

    New("TextLabel", {
        Position = UDim2.new(0,52,0,6), Size = UDim2.new(0.55,0,0,20),
        BackgroundTransparency = 1, Text = cfg.Title or "NexusUI",
        TextColor3 = TH.Text, TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold, TextSize = 15, ZIndex = 3, Parent = TopBar,
    })
    New("TextLabel", {
        Position = UDim2.new(0,52,0,26), Size = UDim2.new(0.55,0,0,14),
        BackgroundTransparency = 1, Text = cfg.SubTitle or "",
        TextColor3 = TH.TextDim, TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham, TextSize = 11, ZIndex = 3, Parent = TopBar,
    })

    -- Control buttons
    local CtrlF = New("Frame", {
        Position = UDim2.new(1,-96,0.5,-12), Size = UDim2.new(0,88,0,24),
        BackgroundTransparency = 1, ZIndex = 3, Parent = TopBar,
    })
    List(CtrlF, Enum.FillDirection.Horizontal, 6)

    local function CtrlBtn(icon, hcol)
        local b = New("TextButton", {
            Size = UDim2.new(0,24,0,24), BackgroundColor3 = TH.Surface,
            Text = icon, TextColor3 = TH.TextDim, Font = Enum.Font.GothamBold,
            TextSize = 11, ZIndex = 4, Parent = CtrlF,
        })
        Corner(b, 6)
        b.MouseEnter:Connect(function() Tween(b, TI.Fast, { BackgroundColor3 = hcol or Accent, TextColor3 = Color3.new(1,1,1) }) end)
        b.MouseLeave:Connect(function() Tween(b, TI.Fast, { BackgroundColor3 = TH.Surface, TextColor3 = TH.TextDim }) end)
        return b
    end
    local CloseBtn = CtrlBtn("✕", TH.Error)
    local MinBtn   = CtrlBtn("—")

    -- ── Tab Bar ────────────────────────────
    local TabBar = New("ScrollingFrame", {
        Position = UDim2.new(0,0,0,48), Size = UDim2.new(0,150,1,-48),
        BackgroundColor3 = TH.Bg2, BorderSizePixel = 0,
        ScrollBarThickness = 0, ZIndex = 2, Parent = Main,
    })
    List(TabBar, Enum.FillDirection.Vertical, 3)
    Pad(TabBar, 8,8,8,8)

    New("Frame", {
        Position = UDim2.new(0,150,0,48), Size = UDim2.new(0,1,1,-48),
        BackgroundColor3 = TH.Border, BorderSizePixel = 0, ZIndex = 2, Parent = Main,
    })

    -- ── Content ────────────────────────────
    local Content = New("Frame", {
        Position = UDim2.new(0,151,0,48), Size = UDim2.new(1,-151,1,-48),
        BackgroundColor3 = TH.Bg, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 2, Parent = Main,
    })

    Drag(TopBar, Main)

    -- Animate in
    task.defer(function()
        Tween(Main, TI.Bounce, { Size = WSize })
    end)

    local Minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        Tween(Main, TI.Med, { Size = Minimized and UDim2.new(WSize.X.Scale,WSize.X.Offset,0,48) or WSize })
        MinBtn.Text = Minimized and "□" or "—"
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, TI.Med, { Size = UDim2.new(WSize.X.Scale,WSize.X.Offset,0,0) })
        task.delay(0.3, function() SG:Destroy() end)
    end)

    -- ── Popup factory (parented to SG, not clipped) ──────
    local function MakePopup(w, maxH)
        local f = New("Frame", {
            Size = UDim2.new(0, w, 0, 0),
            BackgroundColor3 = TH.Bg3, BorderSizePixel = 0,
            ClipsDescendants = true, ZIndex = 200, Visible = false, Parent = SG,
        })
        Corner(f, 8)
        Stroke(f, Accent, 1.2)
        local scroll = New("ScrollingFrame", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = 2,
            ScrollBarImageColor3 = Accent, ZIndex = 201, Parent = f,
        })
        List(scroll, Enum.FillDirection.Vertical, 2)
        Pad(scroll, 4,4,4,4)
        table.insert(OpenPopups, f)
        return f, scroll
    end

    local function OpenPopup(popup, anchor, h)
        -- close others
        for _, p in ipairs(OpenPopups) do
            if p ~= popup and p.Visible then
                p.Visible = false
            end
        end
        local abs = anchor.AbsolutePosition
        local asz = anchor.AbsoluteSize
        local screenH = SG.AbsoluteSize.Y
        -- decide open up or down
        local spaceBelow = screenH - (abs.Y + asz.Y)
        if spaceBelow < h + 10 then
            popup.Position = UDim2.new(0, abs.X, 0, abs.Y - h - 4)
        else
            popup.Position = UDim2.new(0, abs.X, 0, abs.Y + asz.Y + 4)
        end
        popup.Size = UDim2.new(0, asz.X, 0, 0)
        popup.Visible = true
        Tween(popup, TI.Med, { Size = UDim2.new(0, asz.X, 0, h) })
    end

    local function ClosePopup(popup)
        Tween(popup, TI.Fast, { Size = UDim2.new(0, popup.Size.X.Offset, 0, 0) })
        task.delay(0.18, function() popup.Visible = false end)
    end

    -- ════════════════════════════════════════
    --              ADD TAB
    -- ════════════════════════════════════════
    function W:AddTab(tc)
        tc = tc or {}
        local Tab = {}

        local TBtn = New("TextButton", {
            Size = UDim2.new(1,0,0,38), BackgroundColor3 = TH.Bg3,
            BorderSizePixel = 0, Text = "", ZIndex = 3, Parent = TabBar,
        })
        Corner(TBtn, 8)

        local TInd = New("Frame", {
            Size = UDim2.new(0,3,0.6,0), Position = UDim2.new(0,0,0.2,0),
            BackgroundColor3 = Accent, BackgroundTransparency = 1,
            BorderSizePixel = 0, ZIndex = 4, Parent = TBtn,
        })
        Corner(TInd, 4)

        local TIcon = New("TextLabel", {
            Position = UDim2.new(0,10,0.5,-9), Size = UDim2.new(0,18,0,18),
            BackgroundTransparency = 1, Text = tc.Icon or "●",
            TextColor3 = TH.TextMut, Font = Enum.Font.GothamBold,
            TextSize = 14, ZIndex = 4, Parent = TBtn,
        })
        local TName = New("TextLabel", {
            Position = UDim2.new(0,32,0.5,-8), Size = UDim2.new(1,-36,0,16),
            BackgroundTransparency = 1, Text = tc.Name or "Tab",
            TextColor3 = TH.TextDim, TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 4, Parent = TBtn,
        })

        -- Page (ScrollingFrame)
        local Page = New("ScrollingFrame", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = IsMobile and 5 or 3,
            ScrollBarImageColor3 = Accent, ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(0,0,0,0), Visible = false, ZIndex = 3, Parent = Content,
        })
        local PageLayout = List(Page, Enum.FillDirection.Vertical, 6)
        Pad(Page, 10,10,10,10)

        -- ── SCROLL FIX: poll canvas size ──────
        -- This is the most reliable method across all executors
        local function RefreshCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RefreshCanvas)

        -- Also use a loop as backup (catches AutomaticSize changes)
        task.spawn(function()
            while Page and Page.Parent do
                RefreshCanvas()
                task.wait(0.1)
            end
        end)

        local function SelectTab()
            for _, t in ipairs(Tabs) do
                Tween(t.btn,  TI.Fast, { BackgroundColor3 = TH.Bg3 })
                Tween(t.icon, TI.Fast, { TextColor3 = TH.TextMut })
                Tween(t.name, TI.Fast, { TextColor3 = TH.TextDim })
                t.name.Font = Enum.Font.Gotham
                Tween(t.ind,  TI.Fast, { BackgroundTransparency = 1 })
                t.page.Visible = false
            end
            Tween(TBtn,  TI.Fast, { BackgroundColor3 = TH.Surface })
            Tween(TIcon, TI.Fast, { TextColor3 = Accent })
            Tween(TName, TI.Fast, { TextColor3 = TH.Text })
            TName.Font = Enum.Font.GothamBold
            Tween(TInd,  TI.Fast, { BackgroundTransparency = 0 })
            Page.Visible = true
            ActiveTab = Tab
        end

        TBtn.MouseButton1Click:Connect(function() Ripple(TBtn, Accent); SelectTab() end)
        TBtn.MouseEnter:Connect(function() if ActiveTab ~= Tab then Tween(TBtn, TI.Fast, { BackgroundColor3 = TH.SurfaceHov }) end end)
        TBtn.MouseLeave:Connect(function() if ActiveTab ~= Tab then Tween(TBtn, TI.Fast, { BackgroundColor3 = TH.Bg3 }) end end)

        table.insert(Tabs, { btn = TBtn, icon = TIcon, name = TName, ind = TInd, page = Page })
        if #Tabs == 1 then SelectTab() end

        -- ══════════════════════════════════════
        --           ADD SECTION
        -- ══════════════════════════════════════
        function Tab:AddSection(sc)
            sc = sc or {}
            local Sec = {}

            local SF = New("Frame", {
                Size = UDim2.new(1,0,0,0), BackgroundColor3 = TH.Bg2,
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 4, Parent = Page,
            })
            Corner(SF, 10)
            Stroke(SF, TH.Border, 1)

            local SHead = New("Frame", {
                Size = UDim2.new(1,0,0,32), BackgroundColor3 = TH.Bg3,
                BorderSizePixel = 0, ZIndex = 4, Parent = SF,
            })
            Corner(SHead, 10)
            New("Frame", { Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,1,-10),
                BackgroundColor3 = TH.Bg3, BorderSizePixel = 0, ZIndex = 4, Parent = SHead })
            New("Frame", {
                Size = UDim2.new(0,3,0.6,0), Position = UDim2.new(0,10,0.2,0),
                BackgroundColor3 = Accent, BorderSizePixel = 0, ZIndex = 5, Parent = SHead,
            })
            New("TextLabel", {
                Position = UDim2.new(0,18,0,0), Size = UDim2.new(1,-28,1,0),
                BackgroundTransparency = 1, Text = sc.Name or "Section",
                TextColor3 = TH.Text, TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 5, Parent = SHead,
            })

            local EC = New("Frame", {
                Position = UDim2.new(0,0,0,32), Size = UDim2.new(1,0,0,0),
                BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 4, Parent = SF,
            })
            local ECLayout = List(EC, Enum.FillDirection.Vertical, 2)
            Pad(EC, 4,8,8,8)

            -- propagate EC size changes up
            ECLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                task.defer(RefreshCanvas)
            end)

            local function Elem(h)
                local f = New("Frame", {
                    Size = UDim2.new(1,0,0,h or 40), BackgroundColor3 = TH.Bg3,
                    BorderSizePixel = 0, ZIndex = 5, Parent = EC,
                })
                Corner(f, 8)
                return f
            end

            -- ══════════════════════════
            --        BUTTON
            -- ══════════════════════════
            function Sec:AddButton(c)
                c = c or {}
                local f = Elem(38)
                local cover = New("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=7, Parent=f })
                New("TextLabel", {
                    Position = UDim2.new(0, c.Icon and 34 or 12, 0,0), Size = UDim2.new(0.6,0,1,0),
                    BackgroundTransparency=1, Text=c.Name or "Button", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f,
                })
                if c.Icon then New("TextLabel", { Position=UDim2.new(0,12,0,0), Size=UDim2.new(0,18,1,0),
                    BackgroundTransparency=1, Text=c.Icon, TextColor3=Accent, Font=Enum.Font.GothamBold, TextSize=14, ZIndex=6, Parent=f }) end

                local pill = New("TextButton", {
                    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.new(0,72,0,26),
                    BackgroundColor3=Accent, Text=c.BtnText or "Run", TextColor3=Color3.new(1,1,1),
                    Font=Enum.Font.GothamBold, TextSize=12, ZIndex=6, Parent=f,
                })
                Corner(pill, 7)

                local function click()
                    Ripple(f, Accent)
                    Tween(pill, TI.Fast, { BackgroundColor3 = Color3.new(1,1,1) })
                    task.delay(0.15, function() Tween(pill, TI.Fast, { BackgroundColor3 = Accent }) end)
                    if c.Callback then c.Callback() end
                end
                cover.MouseButton1Click:Connect(click)
                pill.MouseButton1Click:Connect(click)
                cover.MouseEnter:Connect(function() Tween(f, TI.Fast, { BackgroundColor3 = TH.SurfaceHov }) end)
                cover.MouseLeave:Connect(function() Tween(f, TI.Fast, { BackgroundColor3 = TH.Bg3 }) end)
                return { Frame = f }
            end

            -- ══════════════════════════
            --        TOGGLE
            -- ══════════════════════════
            function Sec:AddToggle(c)
                c = c or {}
                local val = c.Default or false
                local f = Elem(40)
                New("TextLabel", { Position=UDim2.new(0,12,0,0), Size=UDim2.new(0.65,0,1,0),
                    BackgroundTransparency=1, Text=c.Name or "Toggle", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f })

                local track = New("Frame", {
                    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0), Size=UDim2.new(0,44,0,24),
                    BackgroundColor3=TH.Surface, ZIndex=6, Parent=f,
                })
                Corner(track, 12)
                Stroke(track, TH.Border, 1)
                local knob = New("Frame", {
                    Position=UDim2.new(0,3,0.5,-9), Size=UDim2.new(0,18,0,18),
                    BackgroundColor3=TH.TextMut, ZIndex=7, Parent=track,
                })
                Corner(knob, 9)

                local function Upd(anim)
                    local ti = anim and TI.Med or TI.Fast
                    if val then
                        Tween(track, ti, { BackgroundColor3 = Accent })
                        Tween(knob, ti, { Position = UDim2.new(0,23,0.5,-9), BackgroundColor3 = Color3.new(1,1,1) })
                    else
                        Tween(track, ti, { BackgroundColor3 = TH.Surface })
                        Tween(knob, ti, { Position = UDim2.new(0,3,0.5,-9), BackgroundColor3 = TH.TextMut })
                    end
                end
                Upd(false)

                local btn = New("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=8, Parent=f })
                btn.MouseButton1Click:Connect(function()
                    val = not val; Upd(true)
                    if c.Callback then c.Callback(val) end
                end)
                btn.MouseEnter:Connect(function() Tween(f, TI.Fast, { BackgroundColor3 = TH.SurfaceHov }) end)
                btn.MouseLeave:Connect(function() Tween(f, TI.Fast, { BackgroundColor3 = TH.Bg3 }) end)

                local E = { Frame=f }
                function E:Set(v) val=v; Upd(true); if c.Callback then c.Callback(val) end end
                function E:Get() return val end
                return E
            end

            -- ══════════════════════════
            --        SLIDER
            -- ══════════════════════════
            function Sec:AddSlider(c)
                c = c or {}
                local mn, mx = c.Min or 0, c.Max or 100
                local val = math.clamp(c.Default or mn, mn, mx)
                local sfx = c.Suffix or ""
                local f = Elem(54)

                New("TextLabel", { Position=UDim2.new(0,12,0,4), Size=UDim2.new(0.6,0,0,18),
                    BackgroundTransparency=1, Text=c.Name or "Slider", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f })
                local VLbl = New("TextLabel", { Position=UDim2.new(0.6,0,0,4), Size=UDim2.new(0.36,-12,0,18),
                    BackgroundTransparency=1, Text=tostring(val)..sfx, TextColor3=Accent,
                    TextXAlignment=Enum.TextXAlignment.Right, Font=Enum.Font.GothamBold, TextSize=13, ZIndex=6, Parent=f })

                local track = New("Frame", { Position=UDim2.new(0,12,0,32), Size=UDim2.new(1,-24,0,6),
                    BackgroundColor3=TH.Surface, ZIndex=6, Parent=f })
                Corner(track, 3)
                local fill = New("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=Accent, ZIndex=7, Parent=track })
                Corner(fill, 3)
                local thumb = New("Frame", {
                    AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(0,0,0.5,0), Size=UDim2.new(0,16,0,16),
                    BackgroundColor3=Color3.new(1,1,1), ZIndex=8, Parent=track,
                })
                Corner(thumb, 8)
                Stroke(thumb, Accent, 2)

                local function Upd(pct, fire)
                    val = math.floor(mn + (mx-mn)*pct + 0.5)
                    VLbl.Text = tostring(val)..sfx
                    Tween(fill,  TI.Fast, { Size = UDim2.new(pct,0,1,0) })
                    Tween(thumb, TI.Fast, { Position = UDim2.new(pct,0,0.5,0) })
                    if fire and c.Callback then c.Callback(val) end
                end
                Upd((val-mn)/(mx-mn), false)

                local dragging = false
                local function getPos(i)
                    local abs = track.AbsolutePosition.X
                    return math.clamp((i.Position.X - abs) / track.AbsoluteSize.X, 0, 1)
                end
                track.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; Upd(getPos(i), false)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        Upd(getPos(i), false)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                        dragging = false; Upd(getPos(i), true)
                    end
                end)

                local E = { Frame=f }
                function E:Set(v) Upd(math.clamp((v-mn)/(mx-mn),0,1), true) end
                function E:Get() return val end
                return E
            end

            -- ══════════════════════════
            --       DROPDOWN
            -- ══════════════════════════
            function Sec:AddDropdown(c)
                c = c or {}
                local opts = c.Options or {}
                local val = c.Default or opts[1] or ""
                local isOpen = false
                local f = Elem(40)

                New("TextLabel", { Position=UDim2.new(0,12,0,0), Size=UDim2.new(0.48,0,1,0),
                    BackgroundTransparency=1, Text=c.Name or "Dropdown", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f })

                local dbtn = New("TextButton", {
                    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
                    Size=UDim2.new(0.47,-10,0,28), BackgroundColor3=TH.Surface, Text="", ZIndex=6, Parent=f,
                })
                Corner(dbtn, 7)
                Stroke(dbtn, TH.Border, 1)
                local dlbl = New("TextLabel", { Position=UDim2.new(0,8,0,0), Size=UDim2.new(1,-26,1,0),
                    BackgroundTransparency=1, Text=val, TextColor3=Accent, TextXAlignment=Enum.TextXAlignment.Left,
                    Font=Enum.Font.Gotham, TextSize=12, ZIndex=7, Parent=dbtn })
                local arrow = New("TextLabel", { AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-5,0.5,0),
                    Size=UDim2.new(0,14,0,14), BackgroundTransparency=1, Text="▾",
                    TextColor3=TH.TextDim, Font=Enum.Font.GothamBold, TextSize=11, ZIndex=7, Parent=dbtn })

                -- Popup (at ScreenGui level - no clipping issues)
                local popupH = math.min(#opts * 30 + 8, 160)
                local popup, scroll = MakePopup(0, popupH) -- width set on open
                scroll.CanvasSize = UDim2.new(0,0,0,#opts*30+8)

                local optBtns = {}
                for _, opt in ipairs(opts) do
                    local row = New("TextButton", { Size=UDim2.new(1,0,0,28), BackgroundColor3=TH.Bg3,
                        Text="", ZIndex=202, Parent=scroll })
                    Corner(row, 6)
                    local rlbl = New("TextLabel", { Position=UDim2.new(0,10,0,0), Size=UDim2.new(1,-10,1,0),
                        BackgroundTransparency=1, Text=opt,
                        TextColor3=opt==val and Accent or TH.TextDim,
                        Font=opt==val and Enum.Font.GothamBold or Enum.Font.Gotham,
                        TextXAlignment=Enum.TextXAlignment.Left, TextSize=12, ZIndex=203, Parent=row })
                    table.insert(optBtns, { btn=row, lbl=rlbl, opt=opt })
                    row.MouseEnter:Connect(function() Tween(row, TI.Fast, { BackgroundColor3=TH.SurfaceHov }) end)
                    row.MouseLeave:Connect(function() Tween(row, TI.Fast, { BackgroundColor3=TH.Bg3 }) end)
                    row.MouseButton1Click:Connect(function()
                        val = opt; dlbl.Text = opt
                        for _, ob in ipairs(optBtns) do
                            ob.lbl.TextColor3 = ob.opt==val and Accent or TH.TextDim
                            ob.lbl.Font = ob.opt==val and Enum.Font.GothamBold or Enum.Font.Gotham
                        end
                        isOpen = false
                        ClosePopup(popup)
                        Tween(arrow, TI.Fast, { Rotation=0 })
                        if c.Callback then c.Callback(val) end
                    end)
                end

                dbtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        OpenPopup(popup, dbtn, popupH)
                        Tween(arrow, TI.Fast, { Rotation=180 })
                    else
                        ClosePopup(popup)
                        Tween(arrow, TI.Fast, { Rotation=0 })
                    end
                end)

                local E = { Frame=f }
                function E:Set(v)
                    val=v; dlbl.Text=v
                    for _, ob in ipairs(optBtns) do
                        ob.lbl.TextColor3 = ob.opt==v and Accent or TH.TextDim
                    end
                end
                function E:Get() return val end
                return E
            end

            -- ══════════════════════════
            --     MULTI DROPDOWN
            -- ══════════════════════════
            function Sec:AddMultiDropdown(c)
                c = c or {}
                local opts = c.Options or {}
                local sel = {}
                if c.Default then for _, v in ipairs(c.Default) do sel[v]=true end end
                local isOpen = false
                local f = Elem(40)

                New("TextLabel", { Position=UDim2.new(0,12,0,0), Size=UDim2.new(0.48,0,1,0),
                    BackgroundTransparency=1, Text=c.Name or "Multi Select", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f })

                local dbtn = New("TextButton", {
                    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
                    Size=UDim2.new(0.47,-10,0,28), BackgroundColor3=TH.Surface, Text="", ZIndex=6, Parent=f,
                })
                Corner(dbtn, 7)
                Stroke(dbtn, TH.Border, 1)
                local dlbl = New("TextLabel", { Position=UDim2.new(0,8,0,0), Size=UDim2.new(1,-26,1,0),
                    BackgroundTransparency=1, Text="Select...", TextColor3=TH.TextDim,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=11, ZIndex=7, Parent=dbtn })
                New("TextLabel", { AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-5,0.5,0),
                    Size=UDim2.new(0,14,0,14), BackgroundTransparency=1, Text="▾",
                    TextColor3=TH.TextDim, Font=Enum.Font.GothamBold, TextSize=11, ZIndex=7, Parent=dbtn })

                local function UpdLabel()
                    local t={}; for k in pairs(sel) do table.insert(t,k) end
                    if #t==0 then dlbl.Text="Select..."; dlbl.TextColor3=TH.TextDim
                    else dlbl.Text=table.concat(t,", "); dlbl.TextColor3=Accent end
                end

                local popupH = math.min(#opts*32+8, 160)
                local popup, scroll = MakePopup(0, popupH)
                scroll.CanvasSize = UDim2.new(0,0,0,#opts*32+8)

                for _, opt in ipairs(opts) do
                    local row = New("Frame", { Size=UDim2.new(1,0,0,30), BackgroundColor3=TH.Bg3, ZIndex=202, Parent=scroll })
                    Corner(row, 6)
                    local chk = New("Frame", { Position=UDim2.new(0,7,0.5,-9), Size=UDim2.new(0,18,0,18),
                        BackgroundColor3=sel[opt] and Accent or TH.Surface, ZIndex=203, Parent=row })
                    Corner(chk, 5); Stroke(chk, Accent, 1)
                    local tick = New("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                        Text="✓", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12,
                        TextTransparency=sel[opt] and 0 or 1, ZIndex=204, Parent=chk })
                    New("TextLabel", { Position=UDim2.new(0,30,0,0), Size=UDim2.new(1,-34,1,0),
                        BackgroundTransparency=1, Text=opt, TextColor3=TH.Text,
                        TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=12, ZIndex=203, Parent=row })
                    local rbtn = New("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=205, Parent=row })
                    rbtn.MouseEnter:Connect(function() Tween(row, TI.Fast, { BackgroundColor3=TH.SurfaceHov }) end)
                    rbtn.MouseLeave:Connect(function() Tween(row, TI.Fast, { BackgroundColor3=TH.Bg3 }) end)
                    rbtn.MouseButton1Click:Connect(function()
                        if sel[opt] then
                            sel[opt]=nil
                            Tween(chk, TI.Fast, { BackgroundColor3=TH.Surface })
                            Tween(tick, TI.Fast, { TextTransparency=1 })
                        else
                            sel[opt]=true
                            Tween(chk, TI.Fast, { BackgroundColor3=Accent })
                            Tween(tick, TI.Fast, { TextTransparency=0 })
                        end
                        UpdLabel()
                        if c.Callback then
                            local t={}; for k in pairs(sel) do table.insert(t,k) end; c.Callback(t)
                        end
                    end)
                end
                UpdLabel()

                dbtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then OpenPopup(popup, dbtn, popupH)
                    else ClosePopup(popup) end
                end)

                local E = { Frame=f }
                function E:Get() local t={}; for k in pairs(sel) do table.insert(t,k) end; return t end
                return E
            end

            -- ══════════════════════════
            --       TEXTBOX
            -- ══════════════════════════
            function Sec:AddTextbox(c)
                c = c or {}
                local f = Elem(40)
                New("TextLabel", { Position=UDim2.new(0,12,0,0), Size=UDim2.new(0.38,0,1,0),
                    BackgroundTransparency=1, Text=c.Name or "Input", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f })
                local box = New("TextBox", {
                    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.new(0.57,-10,0,28),
                    BackgroundColor3=TH.Surface, Text=c.Default or "", PlaceholderText=c.PlaceHolder or "Type...",
                    PlaceholderColor3=TH.TextMut, TextColor3=TH.Text, TextXAlignment=Enum.TextXAlignment.Left,
                    Font=Enum.Font.Gotham, TextSize=12, ClearTextOnFocus=c.Clear or false, ZIndex=6, Parent=f,
                })
                Corner(box, 7); Pad(box, 0,6,0,8)
                local sk = Stroke(box, TH.Border, 1)
                box.Focused:Connect(function() Tween(sk, TI.Fast, { Color=Accent }); Tween(box, TI.Fast, { BackgroundColor3=TH.SurfaceHov }) end)
                box.FocusLost:Connect(function(enter)
                    Tween(sk, TI.Fast, { Color=TH.Border }); Tween(box, TI.Fast, { BackgroundColor3=TH.Surface })
                    if c.Callback then c.Callback(box.Text, enter) end
                end)
                local E = { Frame=f, Input=box }
                function E:Set(v) box.Text=v end
                function E:Get() return box.Text end
                return E
            end

            -- ══════════════════════════
            --      PARAGRAPH
            -- ══════════════════════════
            function Sec:AddParagraph(c)
                c = c or {}
                local f = New("Frame", { Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundColor3=TH.Bg3, BorderSizePixel=0, ZIndex=5, Parent=EC })
                Corner(f, 8); Pad(f, 8,12,8,12)
                local inner = New("Frame", { Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1, ZIndex=6, Parent=f })
                List(inner, Enum.FillDirection.Vertical, 4)
                if c.Title and c.Title ~= "" then
                    New("TextLabel", { Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, Text=c.Title,
                        TextColor3=Accent, TextXAlignment=Enum.TextXAlignment.Left,
                        Font=Enum.Font.GothamBold, TextSize=13, ZIndex=7, Parent=inner })
                end
                local clbl = New("TextLabel", { Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1, Text=c.Content or "", TextColor3=TH.TextDim,
                    TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Font=Enum.Font.Gotham,
                    TextSize=12, ZIndex=7, Parent=inner })
                local E = { Frame=f }
                function E:SetContent(t) clbl.Text=t end
                return E
            end

            -- ══════════════════════════
            --    COLOR PICKER
            -- ══════════════════════════
            function Sec:AddColorPicker(c)
                c = c or {}
                local h, s, v = 0, 1, 1
                if c.Default then
                    h, s, v = Color3.toHSV(c.Default)
                end
                local val = Color3.fromHSV(h, s, v)
                local isOpen = false
                local f = Elem(40)

                New("TextLabel", { Position=UDim2.new(0,12,0,0), Size=UDim2.new(0.65,0,1,0),
                    BackgroundTransparency=1, Text=c.Name or "Color", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f })
                local preview = New("TextButton", {
                    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.new(0,36,0,26),
                    BackgroundColor3=val, Text="", ZIndex=6, Parent=f,
                })
                Corner(preview, 7); Stroke(preview, TH.Border, 1)

                -- Popup at SG level
                local pickerPopup = New("Frame", {
                    Size=UDim2.new(0,0,0,0), BackgroundColor3=TH.Bg3,
                    BorderSizePixel=0, ClipsDescendants=true, ZIndex=200, Visible=false, Parent=SG,
                })
                Corner(pickerPopup, 10); Stroke(pickerPopup, Accent, 1.2)
                table.insert(OpenPopups, pickerPopup)

                local pickerInner = New("Frame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                    ZIndex=201, Parent=pickerPopup })
                Pad(pickerInner, 10,10,10,10)

                -- SV picker (square)
                local svBox = New("Frame", { Size=UDim2.new(1,0,0,110),
                    BackgroundColor3=Color3.fromHSV(h,1,1), ZIndex=202, Parent=pickerInner })
                Corner(svBox, 6)
                -- White gradient (left to right: white to transparent)
                local wg = Instance.new("UIGradient")
                wg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1)) })
                wg.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) })
                wg.Parent = svBox
                -- Black gradient overlay (top to bottom: transparent to black)
                local blackOverlay = New("Frame", { Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
                    BackgroundTransparency=0, ZIndex=203, Parent=svBox })
                Corner(blackOverlay, 6)
                local bg2 = Instance.new("UIGradient")
                bg2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color3.new(0,0,0)) })
                bg2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0) })
                bg2.Rotation = 90
                bg2.Parent = blackOverlay

                local svThumb = New("Frame", {
                    AnchorPoint=Vector2.new(0.5,0.5),
                    Position=UDim2.new(s, 0, 1-v, 0), Size=UDim2.new(0,12,0,12),
                    BackgroundColor3=Color3.new(1,1,1), ZIndex=205, Parent=svBox,
                })
                Corner(svThumb, 6); Stroke(svThumb, Color3.new(0,0,0), 1.5)

                -- Hue bar
                local hueBar = New("Frame", { Position=UDim2.new(0,0,0,118), Size=UDim2.new(1,0,0,18),
                    BackgroundColor3=Color3.new(1,1,1), ZIndex=202, Parent=pickerInner })
                Corner(hueBar, 5)
                local hg = Instance.new("UIGradient")
                hg.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,     Color3.fromHSV(0,    1,1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
                    ColorSequenceKeypoint.new(0.5,   Color3.fromHSV(0.5,  1,1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
                    ColorSequenceKeypoint.new(1,     Color3.fromHSV(1,    1,1)),
                })
                hg.Parent = hueBar
                local hueThumb = New("Frame", {
                    AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(h,0,0.5,0), Size=UDim2.new(0,10,1,4),
                    BackgroundColor3=Color3.new(1,1,1), ZIndex=203, Parent=hueBar,
                })
                Corner(hueThumb, 4); Stroke(hueThumb, Color3.new(0,0,0), 1.5)

                -- Hex label
                local function toHex(col)
                    return string.format("#%02X%02X%02X", math.floor(col.R*255), math.floor(col.G*255), math.floor(col.B*255))
                end
                local hexLbl = New("TextLabel", { Position=UDim2.new(0,0,0,144), Size=UDim2.new(1,0,0,20),
                    BackgroundTransparency=1, Text=toHex(val), TextColor3=TH.TextDim,
                    Font=Enum.Font.Code, TextSize=12, ZIndex=202, Parent=pickerInner })

                local function UpdateColor()
                    val = Color3.fromHSV(h, s, v)
                    Tween(preview, TI.Fast, { BackgroundColor3=val })
                    Tween(svBox, TI.Fast, { BackgroundColor3=Color3.fromHSV(h,1,1) })
                    svThumb.Position = UDim2.new(s,0,1-v,0)
                    hueThumb.Position = UDim2.new(h,0,0.5,0)
                    hexLbl.Text = toHex(val)
                    if c.Callback then c.Callback(val) end
                end

                -- SV drag
                local svDrag = false
                local svCover = New("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=206, Parent=svBox })
                svCover.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        svDrag=true
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then svDrag=false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if svDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                        local ax,ay = svBox.AbsolutePosition.X, svBox.AbsolutePosition.Y
                        local aw,ah = svBox.AbsoluteSize.X, svBox.AbsoluteSize.Y
                        s = math.clamp((i.Position.X-ax)/aw, 0, 1)
                        v = 1 - math.clamp((i.Position.Y-ay)/ah, 0, 1)
                        UpdateColor()
                    end
                end)

                -- Hue drag
                local hueDrag = false
                local hueCover = New("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=204, Parent=hueBar })
                hueCover.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        hueDrag=true; h=math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1); UpdateColor()
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then hueDrag=false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if hueDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                        h = math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X, 0, 1)
                        UpdateColor()
                    end
                end)

                preview.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        for _, p in ipairs(OpenPopups) do if p~=pickerPopup and p.Visible then p.Visible=false end end
                        local abs = preview.AbsolutePosition
                        local asz = preview.AbsoluteSize
                        local pH = 172
                        local spaceBelow = SG.AbsoluteSize.Y - (abs.Y + asz.Y)
                        pickerPopup.Position = UDim2.new(0, abs.X - 180 + asz.X, 0,
                            spaceBelow < pH+10 and abs.Y - pH - 4 or abs.Y + asz.Y + 4)
                        pickerPopup.Size = UDim2.new(0,0,0,0)
                        pickerPopup.Visible = true
                        Tween(pickerPopup, TI.Med, { Size = UDim2.new(0, 200, 0, pH) })
                    else
                        Tween(pickerPopup, TI.Fast, { Size = UDim2.new(0, pickerPopup.Size.X.Offset, 0, 0) })
                        task.delay(0.18, function() pickerPopup.Visible=false end)
                    end
                end)

                local E = { Frame=f }
                function E:Set(col) h,s,v=Color3.toHSV(col); UpdateColor() end
                function E:Get() return val end
                return E
            end

            -- ══════════════════════════
            --       KEYBIND
            -- ══════════════════════════
            function Sec:AddKeybind(c)
                c = c or {}
                local val = c.Default or Enum.KeyCode.Unknown
                local listening = false
                local f = Elem(40)
                New("TextLabel", { Position=UDim2.new(0,12,0,0), Size=UDim2.new(0.6,0,1,0),
                    BackgroundTransparency=1, Text=c.Name or "Keybind", TextColor3=TH.Text,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=13, ZIndex=6, Parent=f })
                local kbtn = New("TextButton", {
                    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.new(0,82,0,26),
                    BackgroundColor3=TH.Surface, Text=val==Enum.KeyCode.Unknown and "None" or val.Name,
                    TextColor3=Accent, Font=Enum.Font.GothamBold, TextSize=11, ZIndex=6, Parent=f,
                })
                Corner(kbtn, 7); Stroke(kbtn, Accent, 1)
                kbtn.MouseButton1Click:Connect(function()
                    listening=true; kbtn.Text="..."
                    Tween(kbtn, TI.Fast, { BackgroundColor3=Accent, TextColor3=Color3.new(1,1,1) })
                end)
                UserInputService.InputBegan:Connect(function(i, gp)
                    if gp then return end
                    if listening and i.UserInputType==Enum.UserInputType.Keyboard then
                        val=i.KeyCode; kbtn.Text=val.Name; listening=false
                        Tween(kbtn, TI.Fast, { BackgroundColor3=TH.Surface, TextColor3=Accent })
                        if c.Callback then c.Callback(val) end
                    elseif not listening and i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==val then
                        if c.PressCallback then c.PressCallback() end
                    end
                end)
                local E={Frame=f}; function E:Get() return val end; return E
            end

            -- ══════════════════════════
            --      INFO BOX
            -- ══════════════════════════
            function Sec:AddBox(c)
                c = c or {}
                local col = c.Color or TH.Info
                local f = New("Frame", { Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundColor3=Color3.new(col.R*0.12, col.G*0.12, col.B*0.12),
                    BorderSizePixel=0, ZIndex=5, Parent=EC })
                Corner(f, 8); Stroke(f, col, 1)
                Pad(f, 8,10,8,38)
                New("TextLabel", { Position=UDim2.new(0,10,0.5,-9), Size=UDim2.new(0,18,0,18),
                    BackgroundTransparency=1, Text=c.Icon or "ℹ", TextColor3=col,
                    Font=Enum.Font.GothamBold, TextSize=14, ZIndex=6, Parent=f })
                local lbl = New("TextLabel", { Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1, Text=c.Text or "", TextColor3=TH.Text, TextWrapped=true,
                    TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=12, ZIndex=6, Parent=f })
                local E={Frame=f}; function E:SetText(t) lbl.Text=t end; return E
            end

            -- ══════════════════════════
            --     IMAGE BOX
            -- ══════════════════════════
            function Sec:AddImageBox(c)
                c = c or {}
                local f = New("Frame", { Size=UDim2.new(1,0,0,c.Height or 120), BackgroundColor3=TH.Surface,
                    BorderSizePixel=0, ClipsDescendants=true, ZIndex=5, Parent=EC })
                Corner(f, 8); Stroke(f, TH.Border, 1)
                if c.Image then
                    New("ImageLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Image=c.Image,
                        ScaleType=c.ScaleType or Enum.ScaleType.Crop, ZIndex=6, Parent=f })
                end
                if c.Caption then
                    local ov = New("Frame", { Position=UDim2.new(0,0,1,-28), Size=UDim2.new(1,0,0,28),
                        BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.45, ZIndex=7, Parent=f })
                    New("TextLabel", { Position=UDim2.new(0,8,0,0), Size=UDim2.new(1,-16,1,0),
                        BackgroundTransparency=1, Text=c.Caption, TextColor3=Color3.new(1,1,1),
                        TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham, TextSize=12, ZIndex=8, Parent=ov })
                end
                return { Frame=f }
            end

            return Sec
        end
        return Tab
    end

    -- ════════════════════════════════════════
    --           NOTIFICATION
    -- ════════════════════════════════════════
    local notifOffset = 0
    function W:Notify(nc)
        nc = nc or {}
        local cols = { Success=TH.Success, Warning=TH.Warning, Error=TH.Error, Info=TH.Info }
        local icns = { Success="✓", Warning="⚠", Error="✕", Info="ℹ" }
        local tp  = nc.Type or "Info"
        local col = cols[tp] or TH.Info
        local dur = nc.Duration or 4

        notifOffset = notifOffset + 82
        local yOff = notifOffset

        local nf = New("Frame", {
            AnchorPoint=Vector2.new(1,1), Position=UDim2.new(1,-12,1, yOff + 70),
            Size=UDim2.new(0,285,0,70), BackgroundColor3=TH.Bg2,
            BorderSizePixel=0, ZIndex=150, Parent=SG,
        })
        Corner(nf, 12); Stroke(nf, col, 1.5)

        local bar = New("Frame", { Position=UDim2.new(0,0,1,-3), Size=UDim2.new(1,0,0,3),
            BackgroundColor3=col, BorderSizePixel=0, ZIndex=151, Parent=nf })
        Corner(bar, 2)

        local ib = New("Frame", { Position=UDim2.new(0,10,0.5,-15), Size=UDim2.new(0,30,0,30),
            BackgroundColor3=col, BackgroundTransparency=0.82, ZIndex=151, Parent=nf })
        Corner(ib, 8)
        New("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=icns[tp] or "ℹ",
            TextColor3=col, Font=Enum.Font.GothamBold, TextSize=15, ZIndex=152, Parent=ib })
        New("TextLabel", { Position=UDim2.new(0,48,0,9), Size=UDim2.new(1,-58,0,18),
            BackgroundTransparency=1, Text=nc.Title or tp, TextColor3=TH.Text,
            TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.GothamBold, TextSize=13, ZIndex=151, Parent=nf })
        New("TextLabel", { Position=UDim2.new(0,48,0,28), Size=UDim2.new(1,-58,0,30),
            BackgroundTransparency=1, Text=nc.Message or "", TextColor3=TH.TextDim,
            TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Font=Enum.Font.Gotham, TextSize=11, ZIndex=151, Parent=nf })

        task.defer(function()
            Tween(nf, TI.Bounce, { Position = UDim2.new(1,-12,1,-yOff+62) })
        end)
        TweenService:Create(bar, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Size=UDim2.new(0,0,0,3) }):Play()

        local function dismiss()
            Tween(nf, TI.Med, { Position=UDim2.new(1,300,1,-yOff+62) })
            task.delay(0.3, function() nf:Destroy(); notifOffset = math.max(0, notifOffset-82) end)
        end
        task.delay(dur, dismiss)
        New("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=153, Parent=nf })
            .MouseButton1Click:Connect(dismiss)
    end

    -- ── Toggle Button ──────────────────────
    local togBtn = New("ImageButton", {
        Position = cfg.TogglePos or UDim2.new(0,16,0.5,-20),
        Size = UDim2.new(0,40,0,40), BackgroundColor3=Accent,
        Image = cfg.ToggleImage or "rbxassetid://6026568198",
        ImageColor3=Color3.new(1,1,1), ZIndex=50, Parent=SG,
    })
    Corner(togBtn, 10)
    local ts = Stroke(togBtn, Color3.new(1,1,1), 1.5); ts.Transparency=0.6

    local UIVisible = true
    togBtn.MouseButton1Click:Connect(function()
        UIVisible = not UIVisible
        Ripple(togBtn, Color3.new(1,1,1))
        if UIVisible then
            Main.Visible = true
            Tween(Main, TI.Bounce, { Size=WSize })
            Tween(togBtn, TI.Fast, { Rotation=0 })
        else
            Tween(Main, TI.Med, { Size=UDim2.new(WSize.X.Scale,WSize.X.Offset,0,0) })
            Tween(togBtn, TI.Fast, { Rotation=90 })
            task.delay(0.3, function() if not UIVisible then Main.Visible=false end end)
        end
    end)

    function W:SetTitle(t,s) end -- update as needed
    function W:SetSize(sz) WSize=sz; Tween(Main, TI.Med, { Size=sz }) end
    function W:SetAccent(col) Accent=col end
    function W:Destroy() SG:Destroy() end
    function W:Toggle() togBtn.MouseButton1Click:Fire() end

    return W
end

return NexusUI
