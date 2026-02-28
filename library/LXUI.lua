--[[
  ██╗     ██╗  ██╗██╗   ██╗██╗
  ██║     ╚██╗██╔╝██║   ██║██║
  ██║      ╚███╔╝ ██║   ██║██║
  ██║      ██╔██╗ ██║   ██║██║
  ███████╗██╔╝ ██╗╚██████╔╝██║
  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝
  LXUI – Modern Roblox UI Library v2.0
  Animated • Dark • Mobile+PC • Multi-Executor
]]

local LXUI = {}

-- // Services
local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local Players = game:GetService("Players")
local TXS     = game:GetService("TextService")
local LP      = Players.LocalPlayer
local Mouse   = LP:GetMouse()

--================================================================
-- HELPERS
--================================================================
local function tw(o, t, p, sty, dir)
    local ok, _ = pcall(function()
        TS:Create(o, TweenInfo.new(t, sty or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), p):Play()
    end)
end

local function N(cls, props)
    local o   = Instance.new(cls)
    local par = nil
    for k, v in pairs(props or {}) do
        if k == "Parent" then par = v
        else pcall(function() o[k] = v end) end
    end
    if par then o.Parent = par end
    return o
end

local function Corner(p, r)
    N("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p })
end

local function Stroke(p, col, thick, trans)
    return N("UIStroke", {
        Color        = col   or Color3.fromRGB(45,45,70),
        Thickness    = thick or 1.4,
        Transparency = trans or 0,
        Parent       = p,
    })
end

local function DropShadow(p, sz, alpha)
    N("ImageLabel", {
        Image              = "rbxassetid://6015897843",
        ImageColor3        = Color3.new(0,0,0),
        ImageTransparency  = alpha or 0.45,
        ScaleType          = Enum.ScaleType.Slice,
        SliceCenter        = Rect.new(49,49,450,450),
        AnchorPoint        = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Position           = UDim2.new(0.5,0,0.5,0),
        Size               = UDim2.new(1,sz or 50,1,sz or 50),
        ZIndex             = 0,
        Parent             = p,
    })
end

local function Ripple(btn, mx, my)
    task.spawn(function()
        btn.ClipsDescendants = true
        local c = N("ImageLabel", {
            Image              = "rbxassetid://266543268",
            ImageColor3        = Color3.fromRGB(255,255,255),
            ImageTransparency  = 0.80,
            BackgroundTransparency = 1,
            ZIndex             = btn.ZIndex + 10,
            Parent             = btn,
        })
        local nx = mx - c.AbsolutePosition.X
        local ny = my - c.AbsolutePosition.Y
        c.Position = UDim2.new(0,nx,0,ny)
        local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.4
        tw(c, 0.48, {
            Size               = UDim2.new(0,sz,0,sz),
            Position           = UDim2.new(0.5,-sz/2,0.5,-sz/2),
            ImageTransparency  = 1,
        }, Enum.EasingStyle.Quad)
        task.wait(0.5)
        c:Destroy()
    end)
end

-- PC Drag
local function MakeDraggable(handle, target)
    local drag, di, ds, sp = false,nil,nil,nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag, ds, sp = true, i.Position, target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and drag then
            local d = i.Position - ds
            target.Position = UDim2.new(
                sp.X.Scale, sp.X.Offset + d.X,
                sp.Y.Scale, sp.Y.Offset + d.Y
            )
        end
    end)
end

-- Mobile Drag (returns isDragging fn)
local function MobileDrag(btn, frame, screen)
    local drag, isDrag = false, false
    local ds, sp, sc   = nil,nil,nil
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag, isDrag, ds, sp, sc = true, false, i.Position, frame.Position, i.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType ~= Enum.UserInputType.Touch
        and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if (i.Position - sc).Magnitude > 7 then isDrag = true end
        if isDrag then
            local d  = i.Position - ds
            local ss = screen.AbsoluteSize
            local bs = frame.AbsoluteSize
            frame.Position = UDim2.new(0,
                math.clamp(sp.X.Offset + d.X, 10, ss.X - bs.X - 10),
                0,
                math.clamp(sp.Y.Offset + d.Y, 10, ss.Y - bs.Y - 10)
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    return function() return isDrag end
end

-- Multi-executor ScreenGui
local function MakeGui(name)
    local gui = N("ScreenGui", {
        Name           = name,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn   = false,
        DisplayOrder   = 999,
        IgnoreGuiInset = true,
    })
    local ok = pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
        gui.Parent = game:GetService("CoreGui")
    end)
    if not ok then ok = pcall(function() gui.Parent = gethui() end) end
    if not ok then ok = pcall(function() gui.Parent = game:GetService("CoreGui") end) end
    if not gui.Parent then gui.Parent = LP.PlayerGui end
    return gui
end

--================================================================
-- THEME SYSTEM
--================================================================
local ThemeList = {
    Default  = Color3.fromRGB(118,68,255),
    Blue     = Color3.fromRGB(35,140,255),
    Red      = Color3.fromRGB(255,50,70),
    Green    = Color3.fromRGB(40,210,90),
    Orange   = Color3.fromRGB(255,130,20),
    Purple   = Color3.fromRGB(172,30,255),
    Cyan     = Color3.fromRGB(20,210,255),
    Pink     = Color3.fromRGB(255,70,175),
    Gold     = Color3.fromRGB(255,192,20),
    Emerald  = Color3.fromRGB(20,200,150),
    Crimson  = Color3.fromRGB(210,20,60),
    Neon     = Color3.fromRGB(20,255,175),
    Rose     = Color3.fromRGB(255,90,145),
    Sky      = Color3.fromRGB(90,185,255),
    Amber    = Color3.fromRGB(255,175,0),
    Lavender = Color3.fromRGB(175,125,255),
    Teal     = Color3.fromRGB(0,175,165),
    Forest   = Color3.fromRGB(20,155,75),
    Royal    = Color3.fromRGB(90,10,215),
    Sunset   = Color3.fromRGB(255,90,40),
    Ocean    = Color3.fromRGB(0,155,195),
    Midnight = Color3.fromRGB(30,50,135),
}
local ThemeState = { Name = "Default", Color = ThemeList["Default"], Callbacks = {} }

local function ThemeColor() return ThemeState.Color end

local function ApplyTheme(name)
    if not ThemeList[name] then return false, nil end
    ThemeState.Name  = name
    ThemeState.Color = ThemeList[name]
    for _, fn in ipairs(ThemeState.Callbacks) do pcall(fn, ThemeState.Color) end
    return true, ThemeState.Color
end

local function OnTheme(fn)
    table.insert(ThemeState.Callbacks, fn)
    pcall(fn, ThemeState.Color)
end

--================================================================
-- NOTIFICATION
--================================================================
local NotifyGui = MakeGui("LXNotify")
N("UIListLayout", {
    Padding           = UDim.new(0,8),
    SortOrder         = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Parent = N("Frame", {
        AnchorPoint        = Vector2.new(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel    = 0,
        Position           = UDim2.new(1,-14,1,-14),
        Size               = UDim2.new(0,348,1,-14),
        Name               = "NotifyHolder",
        Parent             = NotifyGui,
    }),
})

local NotifyHolder = NotifyGui:WaitForChild("NotifyHolder")
local nIdx = 0

local function Notify(cfg)
    cfg          = cfg or {}
    cfg.Title    = cfg.Title    or "LXUI"
    cfg.Desc     = cfg.Desc     or cfg.Description or ""
    cfg.Content  = cfg.Content  or ""
    cfg.Color    = cfg.Color    or ThemeColor()
    cfg.Duration = cfg.Duration or cfg.Delay or 5
    cfg.AniTime  = cfg.AniTime  or 0.38
    nIdx = nIdx + 1
    local handle = {}

    task.spawn(function()
        -- Wrapper keeps correct size for the list
        local Wrap = N("Frame", {
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Size                   = UDim2.new(1,0,0,80),
            LayoutOrder            = nIdx,
            ClipsDescendants       = true,
            Parent                 = NotifyHolder,
        })
        -- Card
        local Card = N("Frame", {
            BackgroundColor3 = Color3.fromRGB(12,12,22),
            BorderSizePixel  = 0,
            Position         = UDim2.new(0,420,0,0),
            Size             = UDim2.new(1,0,1,0),
            Parent           = Wrap,
        })
        Corner(Card, 11)
        Stroke(Card, Color3.fromRGB(32,32,56), 1.2)
        DropShadow(Card, 28, 0.52)

        -- Left accent bar
        local AccentBar = N("Frame", {
            BackgroundColor3 = cfg.Color,
            BorderSizePixel  = 0,
            Size             = UDim2.new(0,3,1,0),
            Parent           = Card,
        })
        Corner(AccentBar, 3)

        -- Icon
        local IcoBG = N("Frame", {
            BackgroundColor3       = cfg.Color,
            BackgroundTransparency = 0.82,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(0,0.5),
            Position               = UDim2.new(0,14,0.5,0),
            Size                   = UDim2.new(0,30,0,30),
            Parent                 = Card,
        })
        Corner(IcoBG, 8)
        N("ImageLabel", {
            Image                  = "rbxassetid://16932740082",
            ImageColor3            = cfg.Color,
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(0.5,0.5),
            Position               = UDim2.new(0.5,0,0.5,0),
            Size                   = UDim2.new(0.6,0,0.6,0),
            ZIndex                 = 2,
            Parent                 = IcoBG,
        })

        N("TextLabel", {
            Font                   = Enum.Font.GothamBold,
            Text                   = cfg.Title,
            TextColor3             = Color3.fromRGB(225,225,255),
            TextSize               = 13,
            TextXAlignment         = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position               = UDim2.new(0,54,0,10),
            Size                   = UDim2.new(1,-80,0,15),
            Parent                 = Card,
        })

        local descY = 27
        if cfg.Desc ~= "" then
            N("TextLabel", {
                Font                   = Enum.Font.GothamBold,
                Text                   = cfg.Desc,
                TextColor3             = cfg.Color,
                TextSize               = 11,
                TextXAlignment         = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position               = UDim2.new(0,54,0,27),
                Size                   = UDim2.new(1,-70,0,12),
                Parent                 = Card,
            })
            descY = 41
        end

        local ctSz = TXS:GetTextSize(cfg.Content, 11, Enum.Font.Gotham, Vector2.new(280,9999))
        N("TextLabel", {
            Font                   = Enum.Font.Gotham,
            Text                   = cfg.Content,
            TextColor3             = Color3.fromRGB(128,128,165),
            TextSize               = 11,
            TextWrapped            = true,
            TextXAlignment         = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position               = UDim2.new(0,54,0,descY),
            Size                   = UDim2.new(1,-64,0,ctSz.Y),
            Parent                 = Card,
        })

        local cardH = math.max(72, descY + ctSz.Y + 14)
        Wrap.Size = UDim2.new(1,0,0,cardH)

        -- Progress bar
        local PBG = N("Frame", {
            BackgroundColor3 = Color3.fromRGB(22,22,40),
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(0,1),
            Position         = UDim2.new(0,0,1,0),
            Size             = UDim2.new(1,0,0,3),
            Parent           = Card,
        })
        Corner(PBG, 2)
        local PFill = N("Frame", {
            BackgroundColor3 = cfg.Color,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1,0,1,0),
            Parent           = PBG,
        })
        Corner(PFill, 2)

        -- Close btn
        local CBtn = N("TextButton", {
            Text                   = "",
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(1,0),
            Position               = UDim2.new(1,-6,0,6),
            Size                   = UDim2.new(0,20,0,20),
            ZIndex                 = 5,
            Parent                 = Card,
        })
        N("ImageLabel", {
            Image                  = "rbxassetid://9886659671",
            ImageColor3            = Color3.fromRGB(88,88,120),
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(0.5,0.5),
            Position               = UDim2.new(0.5,0,0.5,0),
            Size                   = UDim2.new(0.75,0,0.75,0),
            Parent                 = CBtn,
        })

        local closed = false
        local function CloseNotify()
            if closed then return end; closed = true
            tw(Card, 0.30, {Position=UDim2.new(0,420,0,0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.34); Wrap:Destroy()
        end
        handle.Close = CloseNotify
        CBtn.Activated:Connect(CloseNotify)

        -- Animate in
        tw(Card,  cfg.AniTime, {Position=UDim2.new(0,0,0,0)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        -- Progress drain
        tw(PFill, cfg.Duration - 0.04, {Size=UDim2.new(0,0,1,0)}, Enum.EasingStyle.Linear)
        task.wait(cfg.Duration)
        CloseNotify()
    end)
    return handle
end

--================================================================
-- CONFIG SYSTEM
--================================================================
local ConfigStore = {
    Saved   = {},
    Current = nil,
}

--================================================================
-- CREATE WINDOW
--================================================================
function LXUI:CreateWindow(cfg)
    cfg = cfg or {}
    local Title       = cfg.Title        or "LXUI"
    local SubTitle    = cfg.SubTitle     or "v2.0"
    local ThemeName   = cfg.Theme        or "Default"
    local WSize       = cfg.Size         or UDim2.fromOffset(548, 438)
    local Centered    = cfg.Center       ~= false
    local CanDrag     = cfg.Draggable    ~= false
    local ToggleKey   = cfg.ToggleKey    or Enum.KeyCode.RightShift
    local MobileBtn   = cfg.MobileButton ~= false
    local MobileImg   = cfg.MobileImage  or "rbxassetid://16932740082"

    ApplyTheme(ThemeName)

    ---- ScreenGui
    local Screen = MakeGui("LXUI_Window")

    ---- Container (drag + scale root)
    local Container = N("Frame", {
        Name                   = "LXContainer",
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Size                   = WSize,
        Position               = Centered
            and UDim2.new(0.5, -WSize.X.Offset/2, 0.5, -WSize.Y.Offset/2)
            or  UDim2.new(0.08, 0, 0.08, 0),
        Parent                 = Screen,
    })
    local UIScale = N("UIScale", { Scale = 0.88, Parent = Container })
    DropShadow(Container, 60, 0.30)

    ---- Main Panel
    local Main = N("Frame", {
        Name                   = "Main",
        BackgroundColor3       = Color3.fromRGB(10,10,18),
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Size                   = UDim2.new(1,0,1,0),
        Parent                 = Container,
    })
    Corner(Main, 12)
    local MainStroke = Stroke(Main, Color3.fromRGB(35,35,60), 1.5)

    ---- Top Bar
    local TopBar = N("Frame", {
        BackgroundColor3 = Color3.fromRGB(6,6,12),
        BorderSizePixel  = 0,
        Size             = UDim2.new(1,0,0,46),
        ZIndex           = 5,
        Parent           = Main,
    })
    Corner(TopBar, 12)
    -- Square off bottom corners of topbar
    N("Frame", {
        BackgroundColor3 = Color3.fromRGB(6,6,12),
        BorderSizePixel  = 0,
        Position         = UDim2.new(0,0,0.5,0),
        Size             = UDim2.new(1,0,0.5,0),
        ZIndex           = 4,
        Parent           = TopBar,
    })
    -- Bottom border line
    N("Frame", {
        BackgroundColor3 = Color3.fromRGB(22,22,44),
        BorderSizePixel  = 0,
        Position         = UDim2.new(0,0,0,46),
        Size             = UDim2.new(1,0,0,1),
        ZIndex           = 4,
        Parent           = Main,
    })

    -- Accent circle + glow in title
    local AccentDot = N("Frame", {
        BackgroundColor3 = ThemeColor(),
        BorderSizePixel  = 0,
        AnchorPoint      = Vector2.new(0,0.5),
        Position         = UDim2.new(0,13,0.5,0),
        Size             = UDim2.new(0,8,0,8),
        ZIndex           = 7,
        Parent           = TopBar,
    })
    Corner(AccentDot, 5)
    local AccentGlow = N("ImageLabel", {
        Image                  = "rbxassetid://5028857084",
        ImageColor3            = ThemeColor(),
        ImageTransparency      = 0.55,
        BackgroundTransparency = 1,
        AnchorPoint            = Vector2.new(0.5,0.5),
        Position               = UDim2.new(0.5,0,0.5,0),
        Size                   = UDim2.new(3,0,3,0),
        ZIndex                 = 6,
        Parent                 = AccentDot,
    })
    OnTheme(function(c)
        AccentDot.BackgroundColor3 = c
        AccentGlow.ImageColor3     = c
    end)

    N("TextLabel", {
        Font                   = Enum.Font.GothamBold,
        Text                   = Title,
        TextColor3             = Color3.fromRGB(225,225,255),
        TextSize               = 13,
        TextXAlignment         = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position               = UDim2.new(0,28,0,0),
        Size                   = UDim2.new(0,140,1,0),
        ZIndex                 = 7,
        Parent                 = TopBar,
    })
    N("TextLabel", {
        Font                   = Enum.Font.Gotham,
        Text                   = SubTitle,
        TextColor3             = Color3.fromRGB(55,55,88),
        TextSize               = 11,
        TextXAlignment         = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position               = UDim2.new(0,172,0,0),
        Size                   = UDim2.new(0,80,1,0),
        ZIndex                 = 7,
        Parent                 = TopBar,
    })

    -- Window buttons: Maximize, Minimize, Close
    local function MkWinBtn(ox, ico, hoverColor)
        local f = N("Frame", {
            BackgroundColor3 = Color3.fromRGB(22,22,36),
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(1,0.5),
            Position         = UDim2.new(1,ox,0.5,0),
            Size             = UDim2.new(0,26,0,26),
            ZIndex           = 7,
            Parent           = TopBar,
        })
        Corner(f, 7)
        N("ImageLabel", {
            Image                  = ico,
            ImageColor3            = Color3.fromRGB(148,148,185),
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(0.5,0.5),
            Position               = UDim2.new(0.5,0,0.5,0),
            Size                   = UDim2.new(0.6,0,0.6,0),
            ZIndex                 = 8,
            Parent                 = f,
        })
        local btn = N("TextButton", {
            Text                   = "",
            BackgroundTransparency = 1,
            Size                   = UDim2.new(1,0,1,0),
            ZIndex                 = 9,
            Parent                 = f,
        })
        btn.MouseEnter:Connect(function() tw(f,0.12,{BackgroundColor3=hoverColor}) end)
        btn.MouseLeave:Connect(function() tw(f,0.12,{BackgroundColor3=Color3.fromRGB(22,22,36)}) end)
        return btn, f
    end

    local BtnClose, BtnCloseF = MkWinBtn(-8,  "rbxassetid://9886659671", Color3.fromRGB(180,38,52))
    local BtnMin,   BtnMinF   = MkWinBtn(-40, "rbxassetid://9886659276", Color3.fromRGB(36,36,56))
    local BtnMax,   BtnMaxF   = MkWinBtn(-72, "rbxassetid://9886659406", Color3.fromRGB(36,36,56))

    ---- Tab Sidebar
    local TabSide = N("Frame", {
        BackgroundColor3       = Color3.fromRGB(7,7,14),
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        Position               = UDim2.new(0,8,0,54),
        Size                   = UDim2.new(0,122,1,-62),
        ZIndex                 = 3,
        Parent                 = Main,
    })
    Corner(TabSide, 9)
    Stroke(TabSide, Color3.fromRGB(22,22,40), 1.2)

    local TabScroll = N("ScrollingFrame", {
        CanvasSize             = UDim2.new(0,0,0,0),
        ScrollBarThickness     = 0,
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Size                   = UDim2.new(1,-8,1,-12),
        Position               = UDim2.new(0,4,0,6),
        Parent                 = TabSide,
    })
    local TabLayout = N("UIListLayout", {
        Padding   = UDim.new(0,4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent    = TabScroll,
    })
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0,0,0,TabLayout.AbsoluteContentSize.Y+4)
    end)

    ---- Content area
    local ContentArea = N("Frame", {
        BackgroundColor3       = Color3.fromRGB(7,7,14),
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        Position               = UDim2.new(0,138,0,54),
        Size                   = UDim2.new(1,-146,1,-62),
        ZIndex                 = 3,
        Parent                 = Main,
    })
    Corner(ContentArea, 9)
    Stroke(ContentArea, Color3.fromRGB(22,22,40), 1.2)

    local ContentHeader = N("TextLabel", {
        Font                   = Enum.Font.GothamBold,
        Text                   = "",
        TextColor3             = Color3.fromRGB(215,215,255),
        TextSize               = 18,
        TextXAlignment         = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Position               = UDim2.new(0,12,0,0),
        Size                   = UDim2.new(1,-24,0,36),
        ZIndex                 = 4,
        Parent                 = ContentArea,
    })
    N("Frame", {
        BackgroundColor3 = Color3.fromRGB(22,22,40),
        BorderSizePixel  = 0,
        Position         = UDim2.new(0,0,0,36),
        Size             = UDim2.new(1,0,0,1),
        ZIndex           = 4,
        Parent           = ContentArea,
    })

    local ContentScroll = N("ScrollingFrame", {
        ScrollBarImageColor3   = Color3.fromRGB(55,55,88),
        ScrollBarThickness     = 3,
        CanvasSize             = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Position               = UDim2.new(0,8,0,44),
        Size                   = UDim2.new(1,-16,1,-52),
        ZIndex                 = 4,
        Parent                 = ContentArea,
    })
    local ContentLayout = N("UIListLayout", {
        Padding   = UDim.new(0,7),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent    = ContentScroll,
    })
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentScroll.CanvasSize = UDim2.new(0,0,0, ContentLayout.AbsoluteContentSize.Y + 8)
    end)

    ---- State
    local TabContainers  = {}
    local CurrentTabName = nil
    local AllElements    = {}
    local TabCount       = 0

    -- Open animation on first show
    task.spawn(function()
        task.wait(0.05)
        Main.BackgroundTransparency = 0
        tw(UIScale, 0.38, {Scale=1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    ---- Window visibility
    local isVisible = true
    local oldPos    = Container.Position
    local oldSize   = Container.Size

    local function ShowWindow(v)
        isVisible = v
        if v then
            Container.Visible = true
            tw(UIScale, 0.35, {Scale=1},   Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            tw(Main,    0.22, {BackgroundTransparency=0})
        else
            tw(UIScale, 0.28, {Scale=0.88}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tw(Main,    0.22, {BackgroundTransparency=1})
            task.wait(0.30)
            Container.Visible = false
        end
    end

    -- Toggle key
    UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == ToggleKey then
            ShowWindow(not isVisible)
        end
    end)

    -- Draggable
    if CanDrag then MakeDraggable(TopBar, Container) end

    -- Close
    BtnClose.Activated:Connect(function()
        Ripple(BtnClose, Mouse.X, Mouse.Y)
        ShowWindow(false)
    end)

    -- Minimize
    BtnMin.Activated:Connect(function()
        Ripple(BtnMin, Mouse.X, Mouse.Y)
        ShowWindow(false)
    end)

    -- Maximize / Restore
    local maximized = false
    BtnMax.Activated:Connect(function()
        Ripple(BtnMax, Mouse.X, Mouse.Y)
        if not maximized then
            oldPos  = Container.Position
            oldSize = Container.Size
            maximized = true
            local ico = BtnMaxF:FindFirstChildOfClass("ImageLabel")
            if ico then ico.Image = "rbxassetid://9886659001" end
            tw(Container, 0.30, {Position=UDim2.new(0,0,0,0)}, Enum.EasingStyle.Quad)
            tw(Container, 0.30, {Size=UDim2.new(1,0,1,0)},     Enum.EasingStyle.Quad)
        else
            maximized = false
            local ico = BtnMaxF:FindFirstChildOfClass("ImageLabel")
            if ico then ico.Image = "rbxassetid://9886659406" end
            tw(Container, 0.30, {Position=oldPos}, Enum.EasingStyle.Quad)
            tw(Container, 0.30, {Size=oldSize},    Enum.EasingStyle.Quad)
        end
    end)

    ---- Mobile Float Button
    if MobileBtn then
        local Fab = N("Frame", {
            Name             = "LXFab",
            BackgroundColor3 = Color3.fromRGB(14,14,24),
            BorderSizePixel  = 0,
            Size             = UDim2.new(0,52,0,52),
            Position         = UDim2.new(0,18,0.72,0),
            ZIndex           = 200,
            Parent           = Screen,
        })
        Corner(Fab, 26)
        Stroke(Fab, ThemeColor(), 1.8)
        OnTheme(function(c)
            local s = Fab:FindFirstChildOfClass("UIStroke")
            if s then s.Color = c end
        end)
        DropShadow(Fab, 22, 0.50)

        N("ImageLabel", {
            Image                  = MobileImg,
            ImageColor3            = ThemeColor(),
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(0.5,0.5),
            Position               = UDim2.new(0.5,0,0.5,0),
            Size                   = UDim2.new(0.60,0,0.60,0),
            ZIndex                 = 201,
            Name                   = "FabIcon",
            Parent                 = Fab,
        })
        OnTheme(function(c)
            local ico = Fab:FindFirstChild("FabIcon")
            if ico then ico.ImageColor3 = c end
        end)

        local FabDetect = N("TextButton", {
            Text                   = "",
            BackgroundTransparency = 1,
            Size                   = UDim2.new(1,0,1,0),
            ZIndex                 = 202,
            Parent                 = Fab,
        })

        local isDragging = MobileDrag(FabDetect, Fab, Screen)
        local lastTap = 0

        FabDetect.Activated:Connect(function()
            if isDragging() then return end
            local now = tick()
            if now - lastTap < 0.25 then return end
            lastTap = now
            ShowWindow(not isVisible)
            -- Pulse animation on FAB
            tw(Fab, 0.10, {Size=UDim2.new(0,46,0,46)}, Enum.EasingStyle.Quad)
            task.wait(0.10)
            tw(Fab, 0.14, {Size=UDim2.new(0,52,0,52)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end)
    end

    --================================================================
    -- ELEMENT BUILDERS
    --================================================================

    -- Base frame shared by most elements
    local function ElemBase(container, h)
        local f = N("Frame", {
            BackgroundColor3       = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.93,
            BorderSizePixel        = 0,
            Size                   = UDim2.new(1,0,0,h or 48),
            Parent                 = container,
        })
        Corner(f, 6)
        return f
    end

    -- Label helpers inside an element
    local function ElemTitle(parent, text, xOff, yOff, wOff)
        return N("TextLabel", {
            Font                   = Enum.Font.GothamBold,
            Text                   = text,
            TextColor3             = Color3.fromRGB(218,218,255),
            TextSize               = 13,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextYAlignment         = Enum.TextYAlignment.Top,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, xOff or 12, 0, yOff or 10),
            Size                   = UDim2.new(1, wOff or -14, 0, 14),
            ZIndex                 = 5,
            Parent                 = parent,
        })
    end

    local function ElemDesc(parent, text, xOff, yOff, wOff)
        if not text or text == "" then return nil end
        return N("TextLabel", {
            Font                   = Enum.Font.Gotham,
            Text                   = text,
            TextColor3             = Color3.fromRGB(105,105,145),
            TextSize               = 11,
            TextWrapped            = true,
            TextXAlignment         = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, xOff or 12, 0, yOff or 26),
            Size                   = UDim2.new(1, wOff or -14, 0, 11),
            ZIndex                 = 5,
            Parent                 = parent,
        })
    end

    -- Invisible click overlay
    local function ElemClick(parent)
        return N("TextButton", {
            Text                   = "",
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Size                   = UDim2.new(1,0,1,0),
            ZIndex                 = 6,
            Parent                 = parent,
        })
    end

    ------------------------------------------------------------------
    -- PARAGRAPH
    ------------------------------------------------------------------
    local function CreateParagraph(container, title, body)
        local tSz = TXS:GetTextSize(body or "", 11, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X-30, 9999))
        local h   = math.max(50, tSz.Y + 36)
        local f   = ElemBase(container, h)
        ElemTitle(f, title or "")
        local bl = ElemDesc(f, body or "")
        if bl then bl.Size = UDim2.new(1,-14,0,tSz.Y) end
        return f
    end

    ------------------------------------------------------------------
    -- BUTTON
    ------------------------------------------------------------------
    local function CreateButton(container, title, desc, icon, cb, elemId)
        local f   = ElemBase(container, 48)
        ElemTitle(f, title or "", 12, 10, -110)
        ElemDesc(f,  desc  or "", 12, 26, -110)
        ElemClick(f) -- handled below

        -- Right icon frame
        local IcoF = N("Frame", {
            BackgroundColor3       = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.88,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(1,0.5),
            Position               = UDim2.new(1,-12,0.5,0),
            Size                   = UDim2.new(0,32,0,32),
            ZIndex                 = 5,
            Parent                 = f,
        })
        Corner(IcoF, 8)
        N("ImageLabel", {
            Image                  = icon or "rbxassetid://16932740082",
            ImageColor3            = ThemeColor(),
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(0.5,0.5),
            Position               = UDim2.new(0.5,0,0.5,0),
            Size                   = UDim2.new(0.62,0,0.62,0),
            ZIndex                 = 6,
            Parent                 = IcoF,
        })
        OnTheme(function(c)
            local img = IcoF:FindFirstChildOfClass("ImageLabel")
            if img then img.ImageColor3 = c end
        end)

        local btn = ElemClick(f)
        btn.Activated:Connect(function()
            Ripple(btn, Mouse.X, Mouse.Y)
            tw(f, 0.08, {BackgroundTransparency=0.80})
            task.wait(0.08)
            tw(f, 0.14, {BackgroundTransparency=0.93})
            if cb then cb() end
        end)
        local elem = {Type="Button", Id=elemId}
        if elemId then AllElements[elemId] = elem end
        return elem
    end

    ------------------------------------------------------------------
    -- TOGGLE
    ------------------------------------------------------------------
    local function CreateToggle(container, title, desc, default, cb, elemId)
        local f   = ElemBase(container, 48)
        local tl  = ElemTitle(f, title or "", 12, 10, -90)
        ElemDesc(f, desc or "", 12, 26, -90)

        -- Track BG
        local Track = N("Frame", {
            BackgroundColor3 = Color3.fromRGB(32,32,50),
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(1,0.5),
            Position         = UDim2.new(1,-12,0.5,0),
            Size             = UDim2.new(0,38,0,20),
            ZIndex           = 5,
            Parent           = f,
        })
        Corner(Track, 10)
        local TrackStroke = Stroke(Track, Color3.fromRGB(55,55,80), 1.3)

        -- Thumb
        local Thumb = N("Frame", {
            BackgroundColor3 = Color3.fromRGB(160,160,190),
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(0,0.5),
            Position         = UDim2.new(0,3,0.5,0),
            Size             = UDim2.new(0,14,0,14),
            ZIndex           = 6,
            Parent           = Track,
        })
        Corner(Thumb, 7)

        local state = default == true
        local function SetState(v, silent)
            state = v
            local c = ThemeColor()
            if v then
                tw(Thumb, 0.20, {Position=UDim2.new(0,21,0.5,0), BackgroundColor3=Color3.fromRGB(255,255,255)})
                tw(Track, 0.20, {BackgroundColor3=c})
                tw(TrackStroke, 0.20, {Color=c})
                tw(tl,   0.20, {TextColor3=c})
            else
                tw(Thumb, 0.20, {Position=UDim2.new(0,3,0.5,0),  BackgroundColor3=Color3.fromRGB(130,130,165)})
                tw(Track, 0.20, {BackgroundColor3=Color3.fromRGB(24,24,40)})
                tw(TrackStroke, 0.20, {Color=Color3.fromRGB(45,45,72)})
                tw(tl,   0.20, {TextColor3=Color3.fromRGB(218,218,255)})
            end
            if not silent and cb then cb(state) end
        end
        SetState(state, true)
        OnTheme(function() if state then SetState(true, true) end end)

        local btn = ElemClick(f)
        btn.Activated:Connect(function()
            Ripple(btn, Mouse.X, Mouse.Y)
            SetState(not state)
        end)

        local elem = {
            Value = state, Type = "Toggle", Id = elemId,
            Set   = function(self, v) SetState(v) self.Value = state end,
        }
        if elemId then AllElements[elemId] = elem end
        return elem
    end

    ------------------------------------------------------------------
    -- SLIDER
    ------------------------------------------------------------------
    local function CreateSlider(container, title, desc, minV, maxV, defV, cb, elemId)
        minV = minV or 0
        maxV = maxV or 100
        defV = defV or minV

        local tSz = TXS:GetTextSize(desc or "", 11, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X-70, 9999))
        local h   = math.max(62, tSz.Y + 46)
        local f   = ElemBase(container, h)
        ElemTitle(f, title or "", 12, 10, -58)
        if desc and desc ~= "" then
            local dl = ElemDesc(f, desc, 12, 26, -58)
            if dl then dl.Size = UDim2.new(1,-58,0,tSz.Y) end
        end

        -- Value label
        local ValL = N("TextLabel", {
            Font                   = Enum.Font.GothamBold,
            Text                   = tostring(defV),
            TextColor3             = ThemeColor(),
            TextSize               = 12,
            TextXAlignment         = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(1,0),
            Position               = UDim2.new(1,-12,0,9),
            Size                   = UDim2.new(0,42,0,16),
            ZIndex                 = 5,
            Parent                 = f,
        })
        OnTheme(function(c) ValL.TextColor3 = c end)

        -- Track
        local TrackBG = N("Frame", {
            BackgroundColor3       = Color3.fromRGB(28,28,46),
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(0,0),
            Position               = UDim2.new(0,12,0,h-18),
            Size                   = UDim2.new(1,-24,0,4),
            ZIndex                 = 5,
            Parent                 = f,
        })
        Corner(TrackBG, 2)

        local TrackFill = N("Frame", {
            BackgroundColor3 = ThemeColor(),
            BorderSizePixel  = 0,
            Size             = UDim2.new(0,0,1,0),
            ZIndex           = 6,
            Parent           = TrackBG,
        })
        Corner(TrackFill, 2)
        OnTheme(function(c) TrackFill.BackgroundColor3 = c end)

        -- Thumb
        local Knob = N("Frame", {
            BackgroundColor3 = ThemeColor(),
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(0.5,0.5),
            Position         = UDim2.new(0,0,0.5,0),
            Size             = UDim2.new(0,14,0,14),
            ZIndex           = 7,
            Parent           = TrackBG,
        })
        Corner(Knob, 7)
        Stroke(Knob, Color3.fromRGB(200,200,255), 1.2, 0.5)
        OnTheme(function(c) Knob.BackgroundColor3 = c end)

        local sData = {Min=minV, Max=maxV, Value=defV, Dragging=false}

        local function SetVal(v, instant)
            v = math.clamp(math.floor(v+0.5), sData.Min, sData.Max)
            sData.Value = v
            ValL.Text   = tostring(v)
            local pct   = (v - sData.Min) / (sData.Max - sData.Min)
            if instant then
                TrackFill.Size     = UDim2.new(pct, 0, 1, 0)
                Knob.Position      = UDim2.new(pct, 0, 0.5, 0)
            else
                tw(TrackFill, 0.10, {Size=UDim2.new(pct,0,1,0)})
                tw(Knob,      0.10, {Position=UDim2.new(pct,0,0.5,0)})
            end
            if cb then cb(v) end
        end
        SetVal(defV, true)

        local function SliderInput(i)
            local ap = TrackBG.AbsolutePosition
            local as = TrackBG.AbsoluteSize
            local pct = math.clamp((i.Position.X - ap.X) / as.X, 0, 1)
            SetVal(sData.Min + pct*(sData.Max-sData.Min))
        end

        TrackBG.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch then
                sData.Dragging = true
                SliderInput(i)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if sData.Dragging
            and (i.UserInputType==Enum.UserInputType.MouseMovement
              or i.UserInputType==Enum.UserInputType.Touch) then
                SliderInput(i)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch then
                sData.Dragging = false
            end
        end)

        local elem = {
            Value = sData.Value, Type="Slider", Id=elemId,
            Set   = function(self, v) SetVal(v) self.Value = sData.Value end,
        }
        if elemId then AllElements[elemId] = elem end
        return elem
    end

    ------------------------------------------------------------------
    -- INPUT
    ------------------------------------------------------------------
    local function CreateInput(container, title, desc, placeholder, cb, elemId)
        local f = ElemBase(container, 48)
        ElemTitle(f, title or "", 12, 10, -170)
        ElemDesc(f,  desc  or "", 12, 26, -170)

        local InputBG = N("Frame", {
            BackgroundColor3       = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.92,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(1,0.5),
            Position               = UDim2.new(1,-8,0.5,0),
            Size                   = UDim2.new(0,148,0,30),
            ClipsDescendants       = true,
            ZIndex                 = 5,
            Parent                 = f,
        })
        Corner(InputBG, 7)
        local InputStroke = Stroke(InputBG, Color3.fromRGB(38,38,62), 1.2)

        local TB = N("TextBox", {
            Font                   = Enum.Font.Gotham,
            PlaceholderText        = placeholder or "Enter text…",
            PlaceholderColor3      = Color3.fromRGB(68,68,98),
            Text                   = "",
            TextColor3             = Color3.fromRGB(210,210,255),
            TextSize               = 12,
            TextXAlignment         = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(0,0.5),
            Position               = UDim2.new(0,8,0.5,0),
            Size                   = UDim2.new(1,-16,1,-8),
            ClearTextOnFocus       = false,
            ZIndex                 = 6,
            Parent                 = InputBG,
        })

        TB.Focused:Connect(function()
            tw(InputStroke, 0.15, {Color=ThemeColor(), Transparency=0})
        end)
        TB.FocusLost:Connect(function()
            tw(InputStroke, 0.15, {Color=Color3.fromRGB(38,38,62), Transparency=0})
            if cb then cb(TB.Text) end
        end)

        local elem = {
            Value = TB.Text, Type="Input", Id=elemId,
            Set   = function(self, v)
                TB.Text  = v
                self.Value = v
                if cb then cb(v) end
            end,
        }
        TB:GetPropertyChangedSignal("Text"):Connect(function()
            elem.Value = TB.Text
        end)
        if elemId then AllElements[elemId] = elem end
        return elem
    end

    ------------------------------------------------------------------
    -- DROPDOWN
    ------------------------------------------------------------------
    local function CreateDropdown(container, title, desc, options, multi, defVal, cb, elemId)
        local f = ElemBase(container, 48)
        ElemTitle(f, title or "", 12, 10, -170)
        ElemDesc(f,  desc  or "", 12, 26, -170)

        local SelBox = N("Frame", {
            BackgroundColor3       = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.92,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(1,0.5),
            Position               = UDim2.new(1,-8,0.5,0),
            Size                   = UDim2.new(0,148,0,30),
            ZIndex                 = 5,
            Parent                 = f,
        })
        Corner(SelBox, 7)
        Stroke(SelBox, Color3.fromRGB(38,38,62), 1.2)

        local SelText = N("TextLabel", {
            Font                   = Enum.Font.Gotham,
            Text                   = "Select…",
            TextColor3             = Color3.fromRGB(88,88,122),
            TextSize               = 11,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextTruncate           = Enum.TextTruncate.AtEnd,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(0,0.5),
            Position               = UDim2.new(0,8,0.5,0),
            Size                   = UDim2.new(1,-30,1,-8),
            ZIndex                 = 6,
            Parent                 = SelBox,
        })
        local ChevImg = N("ImageLabel", {
            Image                  = "rbxassetid://16851841101",
            ImageColor3            = Color3.fromRGB(120,120,160),
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(1,0.5),
            Position               = UDim2.new(1,-2,0.5,0),
            Size                   = UDim2.new(0,22,0,22),
            ZIndex                 = 6,
            Parent                 = SelBox,
        })

        -- Dropdown list (parented to Screen so it floats above everything)
        local DDList = N("Frame", {
            BackgroundColor3       = Color3.fromRGB(14,14,24),
            BorderSizePixel        = 0,
            Size                   = UDim2.new(0,160,0,0),
            ClipsDescendants       = true,
            ZIndex                 = 50,
            Visible                = false,
            Parent                 = Screen,
        })
        Corner(DDList, 8)
        Stroke(DDList, Color3.fromRGB(38,38,62), 1.3)
        DropShadow(DDList, 22, 0.46)

        local DDScroll = N("ScrollingFrame", {
            ScrollBarThickness     = 0,
            CanvasSize             = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0,5,0,5),
            Size                   = UDim2.new(1,-10,1,-10),
            ZIndex                 = 51,
            Parent                 = DDList,
        })
        N("UIListLayout", {
            Padding   = UDim.new(0,3),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent    = DDScroll,
        })

        local ddData = {
            Options  = options or {},
            Value    = multi and (defVal or {}) or defVal or nil,
            Multi    = multi or false,
            Open     = false,
        }

        local function UpdateSelText()
            if ddData.Multi then
                SelText.Text = #ddData.Value>0 and table.concat(ddData.Value,", "):sub(1,24) or "Select…"
            else
                SelText.Text = ddData.Value or "Select…"
            end
            SelText.TextColor3 = (SelText.Text~="Select…")
                and Color3.fromRGB(210,210,255) or Color3.fromRGB(88,88,122)
        end
        UpdateSelText()

        local function RebuildListSize()
            local tot = 0
            for _, c in DDScroll:GetChildren() do
                if c:IsA("Frame") then tot = tot + c.Size.Y.Offset + 3 end
            end
            DDScroll.CanvasSize = UDim2.new(0,0,0,tot)
            DDList.Size         = UDim2.new(0,160,0, math.min(180, tot+10))
        end

        local function ToggleDrop()
            ddData.Open = not ddData.Open
            if ddData.Open then
                local ap = SelBox.AbsolutePosition
                local as = SelBox.AbsoluteSize
                DDList.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 5)
                DDList.Size     = UDim2.new(0,160,0,0)
                DDList.Visible  = true
                tw(DDList, 0.22, {Size=UDim2.new(0,160,0,math.min(180,DDScroll.CanvasSize.Y.Offset+10))}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                tw(ChevImg,0.18, {Rotation=180})
            else
                tw(DDList, 0.18, {Size=UDim2.new(0,160,0,0)}, Enum.EasingStyle.Quad)
                tw(ChevImg,0.18, {Rotation=0})
                task.wait(0.20)
                DDList.Visible = false
            end
        end

        local function MakeOption(name)
            local opt = N("Frame", {
                BackgroundColor3       = Color3.fromRGB(255,255,255),
                BackgroundTransparency = 0.999,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1,0,0,30),
                ZIndex                 = 52,
                Parent                 = DDScroll,
            })
            Corner(opt, 5)

            local AccLine = N("Frame", {
                BackgroundColor3 = ThemeColor(),
                BorderSizePixel  = 0,
                AnchorPoint      = Vector2.new(0,0.5),
                Position         = UDim2.new(0,2,0.5,0),
                Size             = UDim2.new(0,0,0,0),
                ZIndex           = 53,
                Parent           = opt,
            })
            Corner(AccLine, 2)
            OnTheme(function(c) AccLine.BackgroundColor3 = c end)

            local OText = N("TextLabel", {
                Font                   = Enum.Font.Gotham,
                Text                   = name,
                TextColor3             = Color3.fromRGB(168,168,205),
                TextSize               = 12,
                TextXAlignment         = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Position               = UDim2.new(0,12,0,8),
                Size                   = UDim2.new(1,-14,0,14),
                ZIndex                 = 54,
                Parent                 = opt,
            })

            local OBtn = N("TextButton", {
                Text                   = "",
                BackgroundTransparency = 1,
                Size                   = UDim2.new(1,0,1,0),
                ZIndex                 = 55,
                Parent                 = opt,
            })

            local function VisualSelect(sel)
                if sel then
                    tw(AccLine, 0.18, {Size=UDim2.new(0,2,0,14)})
                    tw(opt,     0.18, {BackgroundTransparency=0.93})
                    tw(OText,   0.18, {TextColor3=ThemeColor()})
                else
                    tw(AccLine, 0.18, {Size=UDim2.new(0,0,0,0)})
                    tw(opt,     0.18, {BackgroundTransparency=0.999})
                    tw(OText,   0.18, {TextColor3=Color3.fromRGB(168,168,205)})
                end
            end
            OnTheme(function(c)
                local sel = ddData.Multi
                    and table.find(ddData.Value, name)~=nil
                    or  ddData.Value==name
                if sel then
                    OText.TextColor3 = c
                    AccLine.BackgroundColor3 = c
                end
            end)

            -- Sync visual on init
            task.spawn(function()
                task.wait()
                local sel = ddData.Multi
                    and table.find(ddData.Value, name)~=nil
                    or  ddData.Value==name
                VisualSelect(sel)
            end)

            OBtn.Activated:Connect(function()
                Ripple(OBtn, Mouse.X, Mouse.Y)
                if ddData.Multi then
                    local idx = table.find(ddData.Value, name)
                    if idx then table.remove(ddData.Value, idx) else table.insert(ddData.Value, name) end
                    VisualSelect(table.find(ddData.Value, name)~=nil)
                else
                    -- Deselect others
                    for _, c in DDScroll:GetChildren() do
                        if c:IsA("Frame") then
                            local at = c:FindFirstChildWhichIsA("TextLabel")
                            local ac = c:FindFirstChild("Frame")
                            if at and at.Text ~= name then
                                tw(c,  0.14, {BackgroundTransparency=0.999})
                                tw(at, 0.14, {TextColor3=Color3.fromRGB(168,168,205)})
                                if ac then tw(ac,0.14,{Size=UDim2.new(0,0,0,0)}) end
                            end
                        end
                    end
                    ddData.Value = name
                    VisualSelect(true)
                    ToggleDrop()
                end
                UpdateSelText()
                if cb then cb(ddData.Value) end
            end)
            return opt
        end

        for _, o in ipairs(ddData.Options) do MakeOption(o) end
        RebuildListSize()

        local SelBtn = ElemClick(SelBox)
        SelBtn.Activated:Connect(function()
            Ripple(SelBtn, Mouse.X, Mouse.Y)
            ToggleDrop()
        end)
        -- Close on outside click
        local conn
        conn = UIS.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
            and i.UserInputType ~= Enum.UserInputType.Touch then return end
            if not ddData.Open then return end
            local mp = i.Position
            local function inside(fr)
                local ap = fr.AbsolutePosition; local as = fr.AbsoluteSize
                return mp.X>=ap.X and mp.X<=ap.X+as.X and mp.Y>=ap.Y and mp.Y<=ap.Y+as.Y
            end
            if not inside(DDList) and not inside(SelBox) then ToggleDrop() end
        end)
        f.Destroying:Connect(function() if conn then conn:Disconnect() end; DDList:Destroy() end)

        local elem = {
            Value   = ddData.Value,
            Options = ddData.Options,
            Type    = "Dropdown",
            Id      = elemId,
            Set = function(self, v)
                ddData.Value = v; self.Value = v
                UpdateSelText()
                for _, c in DDScroll:GetChildren() do
                    if c:IsA("Frame") then
                        local at = c:FindFirstChildWhichIsA("TextLabel")
                        local ac = c:FindFirstChildOfClass("Frame")
                        if at then
                            local sel = ddData.Multi and table.find(ddData.Value,at.Text)~=nil
                                or ddData.Value==at.Text
                            tw(c,  0.14, {BackgroundTransparency=sel and 0.93 or 0.999})
                            tw(at, 0.14, {TextColor3=sel and ThemeColor() or Color3.fromRGB(168,168,205)})
                            if ac then tw(ac,0.14,{Size=sel and UDim2.new(0,2,0,14) or UDim2.new(0,0,0,0)}) end
                        end
                    end
                end
            end,
            Refresh = function(self, newOpts, newVal)
                for _, c in DDScroll:GetChildren() do if c:IsA("Frame") then c:Destroy() end end
                ddData.Options = newOpts or {}
                ddData.Value   = newVal or (ddData.Multi and {} or nil)
                for _, o in ipairs(ddData.Options) do MakeOption(o) end
                RebuildListSize()
                UpdateSelText()
                self.Value   = ddData.Value
                self.Options = ddData.Options
            end,
        }
        if elemId then AllElements[elemId] = elem end
        return elem
    end

    --================================================================
    -- TAB BUILDER
    --================================================================
    local function CreateTab(name, icon)
        TabCount = TabCount + 1
        local order = TabCount

        -- Tab button
        local Tab = N("Frame", {
            BackgroundColor3       = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.999,
            BorderSizePixel        = 0,
            Size                   = UDim2.new(1,0,0,32),
            LayoutOrder            = order,
            ZIndex                 = 4,
            Parent                 = TabScroll,
        })
        Corner(Tab, 7)

        -- Active indicator pill
        local Pill = N("Frame", {
            BackgroundColor3 = ThemeColor(),
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(0,0.5),
            Position         = UDim2.new(0,4,0.5,0),
            Size             = UDim2.new(0,0,0,0),
            ZIndex           = 5,
            Parent           = Tab,
        })
        Corner(Pill, 3)
        OnTheme(function(c) Pill.BackgroundColor3 = c end)

        local IcoL = N("ImageLabel", {
            Image                  = icon or "",
            ImageColor3            = Color3.fromRGB(88,88,125),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0,10,0.5,-8),
            Size                   = UDim2.new(0,16,0,16),
            ZIndex                 = 5,
            Parent                 = Tab,
        })
        local TxtL = N("TextLabel", {
            Font                   = Enum.Font.GothamBold,
            Text                   = name,
            TextColor3             = Color3.fromRGB(88,88,125),
            TextSize               = 12,
            TextXAlignment         = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0,32,0,0),
            Size                   = UDim2.new(1,-34,1,0),
            ZIndex                 = 5,
            Parent                 = Tab,
        })

        -- Content container
        local Content = N("Frame", {
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Size                   = UDim2.new(1,0,0,0),
            Visible                = false,
            LayoutOrder            = order,
            Parent                 = ContentScroll,
        })
        N("UIListLayout", {
            Padding   = UDim.new(0,7),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent    = Content,
        })
        Content:FindFirstChildOfClass("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Content.Size = UDim2.new(1,0,0, Content:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y)
        end)
        TabContainers[name] = Content

        local function Activate()
            -- Deactivate all tabs
            for _, t in TabScroll:GetChildren() do
                if t:IsA("Frame") then
                    local p = t:FindFirstChildOfClass("Frame")
                    local il = t:FindFirstChildOfClass("ImageLabel")
                    local tl2 = t:FindFirstChildOfClass("TextLabel")
                    tw(t, 0.15, {BackgroundTransparency=0.999})
                    if p  then tw(p,  0.15, {Size=UDim2.new(0,0,0,0)}) end
                    if il then tw(il, 0.15, {ImageColor3=Color3.fromRGB(70,70,105)}) end
                    if tl2 then tw(tl2,0.15, {TextColor3=Color3.fromRGB(70,70,105)}) end
                end
            end
            for _, c in ContentScroll:GetChildren() do
                if c:IsA("Frame") then c.Visible = false end
            end
            -- Activate this tab
            tw(Tab,  0.18, {BackgroundTransparency=0.91})
            tw(Pill, 0.18, {Size=UDim2.new(0,3,0,16)})
            tw(IcoL, 0.18, {ImageColor3=ThemeColor()})
            tw(TxtL, 0.18, {TextColor3=ThemeColor()})
            Content.Visible   = true
            CurrentTabName    = name
            ContentHeader.Text = name
            ContentScroll.CanvasPosition = Vector2.new(0,0)
        end
        OnTheme(function(c)
            if CurrentTabName == name then
                Pill.BackgroundColor3 = c
                IcoL.ImageColor3      = c
                TxtL.TextColor3       = c
            end
        end)

        local TabBtn = ElemClick(Tab)
        TabBtn.Activated:Connect(function()
            Ripple(TabBtn, Mouse.X, Mouse.Y)
            Activate()
        end)

        -- Auto-select first tab
        if TabCount == 1 then
            task.spawn(function() task.wait(0.05); Activate() end)
        end

        -- Return tab API
        local T = {}
        function T:AddParagraph(ttl, body)      return CreateParagraph(Content, ttl, body)                          end
        function T:AddButton(ttl, dsc, ico, cb)  return CreateButton(Content, ttl, dsc, ico, cb)                    end
        function T:AddToggle(ttl, dsc, def, cb, id) return CreateToggle(Content, ttl, dsc, def, cb, id)             end
        function T:AddSlider(ttl, dsc, mn, mx, def, cb, id) return CreateSlider(Content, ttl, dsc, mn, mx, def, cb, id) end
        function T:AddInput(ttl, dsc, ph, cb, id) return CreateInput(Content, ttl, dsc, ph, cb, id)                end
        function T:AddDropdown(ttl, dsc, opts, mul, def, cb, id) return CreateDropdown(Content, ttl, dsc, opts, mul, def, cb, id) end
        function T:Select() Activate() end
        T.Container = Content
        return T
    end

    --================================================================
    -- BUILT-IN CONFIG TAB
    --================================================================
    local CfgTab = CreateTab("Configs", "rbxassetid://16932740082")

    CfgTab:AddParagraph("Configuration", "Save, load and delete setting profiles. Configs persist for this session.")

    local themeNames = {}
    for k in pairs(ThemeList) do table.insert(themeNames, k) end
    table.sort(themeNames)

    local ThemeDrop = CfgTab:AddDropdown("Theme", "Pick accent colour", themeNames, false, ThemeState.Name, function(v)
        local ok, col = ApplyTheme(v)
        if ok then
            Notify({Title="Theme", Desc="Changed", Content="Theme set to "..v, Color=col, Duration=3})
        end
    end, "_ThemeDrop")

    CfgTab:AddToggle("UI Transparency", "Make the window background more transparent", false, function(v)
        if v then
            tw(Main, 0.30, {BackgroundTransparency=0.50})
            tw(MainStroke, 0.30, {Transparency=0.65})
        else
            tw(Main, 0.30, {BackgroundTransparency=0})
            tw(MainStroke, 0.30, {Transparency=0})
        end
    end)

    local cfgName = ""
    local CfgInput = CfgTab:AddInput("Config Name", "Name for this preset", "MyConfig", function(v) cfgName = v end, "_CfgName")

    local LoadDrop, DelDrop

    CfgTab:AddButton("Save Config", "Save current element values", "rbxassetid://16932740082", function()
        if cfgName == "" then
            Notify({Title="Config", Desc="Error", Content="Enter a config name first.", Color=Color3.fromRGB(220,40,55), Duration=3})
            return
        end
        local data = {}
        for id, el in pairs(AllElements) do
            if id:sub(1,1) ~= "_" then data[id] = el.Value end
        end
        ConfigStore.Saved[cfgName] = {Theme=ThemeState.Name, Data=data}
        ConfigStore.Current        = cfgName
        Notify({Title="Config", Desc="Saved", Content="'"..cfgName.."' saved.", Color=ThemeColor(), Duration=3})
        -- Refresh dropdowns
        local list = {}
        for k in pairs(ConfigStore.Saved) do table.insert(list, k) end
        if LoadDrop then LoadDrop:Refresh(list) end
        if DelDrop  then DelDrop:Refresh(list)  end
    end)

    LoadDrop = CfgTab:AddDropdown("Load Config", "Select a saved preset", {}, false, nil, function(v)
        if not v or not ConfigStore.Saved[v] then return end
        local preset = ConfigStore.Saved[v]
        ApplyTheme(preset.Theme)
        ThemeDrop:Set(preset.Theme)
        for id, val in pairs(preset.Data) do
            if AllElements[id] then pcall(function() AllElements[id]:Set(val) end) end
        end
        ConfigStore.Current = v
        Notify({Title="Config", Desc="Loaded", Content="'"..v.."' loaded.", Color=ThemeColor(), Duration=3})
    end, "_LoadDrop")

    DelDrop = CfgTab:AddDropdown("Delete Config", "Remove a saved preset", {}, false, nil, function(v)
        if not v or not ConfigStore.Saved[v] then return end
        ConfigStore.Saved[v] = nil
        if ConfigStore.Current == v then ConfigStore.Current = nil end
        local list = {}
        for k in pairs(ConfigStore.Saved) do table.insert(list, k) end
        if LoadDrop then LoadDrop:Refresh(list) end
        if DelDrop  then DelDrop:Refresh(list)  end
        Notify({Title="Config", Desc="Deleted", Content="'"..v.."' deleted.", Color=ThemeColor(), Duration=3})
    end, "_DelDrop")

    CfgTab:AddParagraph("Note", "Configs are session-only. Integrate writefile() / readfile() for persistent storage.")

    --================================================================
    -- WINDOW API
    --================================================================
    local Win = {}

    function Win:CreateTab(name, icon)       return CreateTab(name, icon) end
    function Win:Notify(nc)                  return Notify(nc) end
    function Win:SetTheme(name)              return ApplyTheme(name) end
    function Win:Show()                      ShowWindow(true) end
    function Win:Hide()                      ShowWindow(false) end
    function Win:Toggle()                    ShowWindow(not isVisible) end
    function Win:Destroy()                   Screen:Destroy() end
    function Win:SetTitle(t)                 ContentHeader.Text = t end
    function Win:GetElement(id)              return AllElements[id] end
    function Win:SaveConfig(name)
        local data = {}
        for id, el in pairs(AllElements) do
            if id:sub(1,1)~="_" then data[id]=el.Value end
        end
        ConfigStore.Saved[name] = {Theme=ThemeState.Name, Data=data}
        ConfigStore.Current     = name
    end
    function Win:LoadConfig(name)
        if not ConfigStore.Saved[name] then return end
        local p = ConfigStore.Saved[name]
        ApplyTheme(p.Theme)
        for id, v in pairs(p.Data) do
            if AllElements[id] then pcall(function() AllElements[id]:Set(v) end) end
        end
    end

    return Win
end

-- Expose Notify globally too
function LXUI:Notify(nc) return Notify(nc) end

return LXUI
