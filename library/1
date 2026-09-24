local Library = {}
Library.__index = Library

-- ── SERVICES ──────────────────────────────────────────────────
local TS  = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS  = game:GetService("RunService")
local PL  = game:GetService("Players")
local HS  = game:GetService("HttpService")

-- ── ANTI-DETECT: CoreGui Injection ────────────────────────────
local GUI
local ok = pcall(function()
    GUI = Instance.new("ScreenGui")
    GUI.Name = HS:GenerateGUID(false)
    GUI.ResetOnSpawn     = false
    GUI.DisplayOrder     = 999
    GUI.IgnoreGuiInset   = true
    GUI.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    GUI.Parent = game:GetService("CoreGui")
end)
if not ok or not GUI then
    GUI = Instance.new("ScreenGui")
    GUI.Name = HS:GenerateGUID(false)
    GUI.ResetOnSpawn     = false
    GUI.DisplayOrder     = 999
    GUI.IgnoreGuiInset   = true
    GUI.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    GUI.Parent = PL.LocalPlayer:WaitForChild("PlayerGui")
end

-- ── THEME ─────────────────────────────────────────────────────
local T = {
    -- Backgrounds (darkest → lightest)
    BG0 = Color3.fromRGB(5,  8,  22),
    BG1 = Color3.fromRGB(8,  12, 32),
    BG2 = Color3.fromRGB(11, 17, 44),
    BG3 = Color3.fromRGB(14, 22, 56),
    BG4 = Color3.fromRGB(18, 28, 70),
    BG5 = Color3.fromRGB(24, 36, 88),
    BG6 = Color3.fromRGB(30, 46, 105),

    -- Gold palette
    Gold      = Color3.fromRGB(212, 175, 55),
    GoldBrt   = Color3.fromRGB(255, 215, 80),
    GoldDim   = Color3.fromRGB(145, 118, 38),
    GoldDark  = Color3.fromRGB(72,  58,  18),

    -- Blue palette
    Blue      = Color3.fromRGB(48,  96,  220),
    BlueBrt   = Color3.fromRGB(80,  140, 255),

    -- Text
    Text      = Color3.fromRGB(228, 234, 255),
    TextSub   = Color3.fromRGB(148, 158, 200),
    TextDim   = Color3.fromRGB(72,  82,  122),
    TextGold  = Color3.fromRGB(212, 175, 55),

    -- Status
    Red       = Color3.fromRGB(220, 58,  58),
    Green     = Color3.fromRGB(50,  200, 100),
    Yellow    = Color3.fromRGB(220, 180, 0),
    Discord   = Color3.fromRGB(88,  101, 242),

    -- Typography
    FontB   = Enum.Font.GothamBold,
    FontR   = Enum.Font.Gotham,

    -- Animation
    Spd    = 0.20,
    SpdSlow= 0.35,
    Ease   = Enum.EasingStyle.Quart,
    EaseB  = Enum.EasingStyle.Back,
    Dir    = Enum.EasingDirection.Out,
}

-- ── HELPERS ───────────────────────────────────────────────────
local function tw(obj, props, t, s, d)
    if not obj or not obj.Parent then return end
    local ti = TweenInfo.new(t or T.Spd, s or T.Ease, d or T.Dir)
    TS:Create(obj, ti, props):Play()
end

local function mk(cls, props, par)
    local i = Instance.new(cls)
    for k, v in pairs(props or {}) do
        pcall(function() i[k] = v end)
    end
    if par then i.Parent = par end
    return i
end

local function rnd(p, r)
    return mk("UICorner", { CornerRadius = UDim.new(0, r or 6) }, p)
end

local function brdr(p, c, t)
    return mk("UIStroke", {
        Color = c or T.Gold,
        Thickness = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

local function grd(p, cs, rot)
    return mk("UIGradient", { Color = cs, Rotation = rot or 90 }, p)
end

local function pad(p, top, bot, left, right)
    return mk("UIPadding", {
        PaddingTop    = UDim.new(0, top   or 0),
        PaddingBottom = UDim.new(0, bot   or 0),
        PaddingLeft   = UDim.new(0, left  or 0),
        PaddingRight  = UDim.new(0, right or 0),
    }, p)
end

local function list(p, gap, fill, halign, valign)
    return mk("UIListLayout", {
        Padding             = UDim.new(0, gap   or 4),
        FillDirection       = fill   or Enum.FillDirection.Vertical,
        HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
        VerticalAlignment   = valign or Enum.VerticalAlignment.Top,
        SortOrder           = Enum.SortOrder.LayoutOrder,
    }, p)
end

-- ColorSequence shorthand: G(pos1, col1, pos2, col2, ...)
local function G(...)
    local kps, a = {}, {...}
    for i = 1, #a, 2 do
        table.insert(kps, ColorSequenceKeypoint.new(a[i], a[i+1]))
    end
    return ColorSequence.new(kps)
end

-- Ripple effect on a frame
local function ripple(parent, zix)
    local rp = mk("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = T.Gold,
        BackgroundTransparency = 0.72,
        ZIndex = zix or 99,
        ClipsDescendants = false,
    }, parent)
    rnd(rp, 100)
    tw(rp, { Size = UDim2.new(2.5, 0, 5, 0), BackgroundTransparency = 1 }, 0.42)
    task.delay(0.42, function() pcall(function() rp:Destroy() end) end)
end

-- Shadow beneath a frame
local function shadow(parent)
    return mk("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 8),
        Size = UDim2.new(1, 28, 1, 28),
        ZIndex = (parent.ZIndex or 10) - 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 10),
        ImageTransparency = 0.38,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
    }, parent)
end

-- ── CREATE WINDOW ─────────────────────────────────────────────
function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local W_WIDTH  = cfg.Width  or 740
    local W_HEIGHT = cfg.Height or 470
    local title    = cfg.Title    or "CHRMINAL UI"
    local subtitle = cfg.Subtitle or "v2.0 | Blue & Gold"
    local togKey   = cfg.ToggleKey or Enum.KeyCode.RightShift

    local win = {
        _pages  = {},
        _open   = true,
        _mini   = false,
    }

    -- ── MAIN FRAME ────────────────────────────────────────────
    local Main = mk("Frame", {
        Name             = "ChrmnalMain",
        Size             = UDim2.new(0, W_WIDTH, 0, 0),
        Position         = UDim2.new(0.5, -W_WIDTH/2, 0.5, -W_HEIGHT/2),
        BackgroundColor3 = T.BG0,
        BorderSizePixel  = 0,
        ZIndex           = 10,
        GroupTransparency = 1,
        ClipsDescendants = false,
    }, GUI)
    rnd(Main, 10)
    brdr(Main, T.Gold, 1)
    grd(Main, G(0, T.BG0, 1, Color3.fromRGB(7, 11, 30)), 135)
    shadow(Main)

    -- ── HEADER ────────────────────────────────────────────────
    local Hdr = mk("Frame", {
        Size             = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = T.BG1,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Main)
    rnd(Hdr, 10)
    -- Fix bottom-rounded corners
    mk("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0), Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = T.BG1, BorderSizePixel = 0, ZIndex = 12,
    }, Hdr)
    grd(Hdr, G(
        0,   Color3.fromRGB(7, 12, 36),
        0.5, Color3.fromRGB(10, 16, 46),
        1,   Color3.fromRGB(7, 12, 36)
    ), 0)

    -- Logo badge
    local logoBG = mk("Frame", {
        Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 10, 0.5, -15),
        BackgroundColor3 = T.Gold, ZIndex = 14,
    }, Hdr)
    rnd(logoBG, 7)
    grd(logoBG, G(0, T.GoldBrt, 1, T.Gold))
    mk("TextLabel", {
        Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Text = "⚡", TextSize = 15, TextColor3 = T.BG0,
        Font = T.FontB, ZIndex = 15,
    }, logoBG)

    -- Title + Subtitle
    mk("TextLabel", {
        Size = UDim2.new(0, 200, 0, 22), Position = UDim2.new(0, 48, 0, 7),
        BackgroundTransparency = 1, Text = title,
        TextSize = 14, TextColor3 = T.Text,
        Font = T.FontB, TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true, ZIndex = 14,
    }, Hdr)
    mk("TextLabel", {
        Size = UDim2.new(0, 220, 0, 13), Position = UDim2.new(0, 48, 0, 27),
        BackgroundTransparency = 1, Text = subtitle,
        TextSize = 10, TextColor3 = T.Gold,
        Font = T.FontR, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
    }, Hdr)

    -- Gold accent line
    local acLine = mk("Frame", {
        Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,1,-1),
        BackgroundColor3 = T.Gold, ZIndex = 13,
    }, Hdr)
    grd(acLine, G(0,T.BG0, 0.12,T.GoldDim, 0.5,T.Gold, 0.88,T.GoldDim, 1,T.BG0))

    -- Close Button
    local CloseBtn = mk("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -36, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(152, 38, 38),
        Text = "✕", TextSize = 12, TextColor3 = Color3.fromRGB(255,255,255),
        Font = T.FontB, ZIndex = 15, AutoButtonColor = false,
    }, Hdr)
    rnd(CloseBtn, 5)

    -- Minimize Button
    local MinBtn = mk("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -68, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(175, 138, 20),
        Text = "−", TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255),
        Font = T.FontB, ZIndex = 15, AutoButtonColor = false,
    }, Hdr)
    rnd(MinBtn, 5)

    -- ── LEFT NAV ──────────────────────────────────────────────
    local NavW  = 150
    local NavPan = mk("Frame", {
        Name = "Nav",
        Size = UDim2.new(0, NavW, 1, -46), Position = UDim2.new(0, 0, 0, 46),
        BackgroundColor3 = T.BG1, BorderSizePixel = 0, ZIndex = 11,
    }, Main)
    grd(NavPan, G(0, Color3.fromRGB(7, 11, 30), 1, Color3.fromRGB(5, 8, 22)), 180)

    -- Right border of nav
    local navBdr = mk("Frame", {
        Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = T.GoldDark, ZIndex = 12,
    }, NavPan)
    grd(navBdr, G(0,T.BG0, 0.25,T.GoldDark, 0.75,T.GoldDark, 1,T.BG0), 180)

    local NavScroll = mk("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 12,
    }, NavPan)
    list(NavScroll, 3)
    pad(NavScroll, 10, 8, 6, 6)

    -- ── CONTENT AREA ──────────────────────────────────────────
    local ContentArea = mk("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -NavW, 1, -46), Position = UDim2.new(0, NavW, 0, 46),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 11,
    }, Main)

    -- ── FLOAT BUTTON ──────────────────────────────────────────
    local FloatBtn = mk("TextButton", {
        Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 14, 0.5, -25),
        BackgroundColor3 = T.BG0,
        Text = "⚡", TextSize = 24, TextColor3 = T.Gold,
        Font = T.FontB, Visible = false, ZIndex = 100,
        AutoButtonColor = false,
    }, GUI)
    rnd(FloatBtn, 13)
    brdr(FloatBtn, T.Gold, 1.5)
    grd(FloatBtn, G(0, Color3.fromRGB(12,20,56), 1, T.BG0))

    -- ── NOTIFICATION HOLDER ────────────────────────────────────
    local NHolder = mk("Frame", {
        Size = UDim2.new(0, 290, 1, 0), Position = UDim2.new(1, -300, 0, 0),
        BackgroundTransparency = 1, ZIndex = 200,
    }, GUI)
    mk("UIListLayout", {
        VerticalAlignment   = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, NHolder)
    pad(NHolder, 0, 14, 0, 10)

    -- ── DRAGGING (Header) ──────────────────────────────────────
    local drag = {}
    Hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
           or inp.UserInputType == Enum.UserInputType.Touch then
            drag = { on = true, s = inp.Position, o = Main.Position }
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag.on and (inp.UserInputType == Enum.UserInputType.MouseMovement
                     or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - drag.s
            Main.Position = UDim2.new(drag.o.X.Scale, drag.o.X.Offset + d.X,
                                      drag.o.Y.Scale, drag.o.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
           or inp.UserInputType == Enum.UserInputType.Touch then
            drag.on = false
        end
    end)

    -- Float button drag
    local fbD = {}
    FloatBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
           or inp.UserInputType == Enum.UserInputType.Touch then
            fbD = { on = true, moved = false, s = inp.Position, o = FloatBtn.Position }
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if fbD.on and (inp.UserInputType == Enum.UserInputType.MouseMovement
                    or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - fbD.s
            if d.Magnitude > 5 then fbD.moved = true end
            FloatBtn.Position = UDim2.new(fbD.o.X.Scale, fbD.o.X.Offset + d.X,
                                          fbD.o.Y.Scale, fbD.o.Y.Offset + d.Y)
        end
    end)

    -- Float click → open
    FloatBtn.MouseButton1Click:Connect(function()
        if not fbD.moved then
            FloatBtn.Visible = false
            Main.Visible = true
            Main.GroupTransparency = 1
            tw(Main, { GroupTransparency = 0 }, 0.28)
            win._open = true
        end
        fbD.moved = false
    end)

    -- ── CLOSE / MINIMIZE ──────────────────────────────────────
    CloseBtn.MouseButton1Click:Connect(function()
        tw(Main, { GroupTransparency = 1 }, 0.22)
        task.delay(0.22, function()
            Main.Visible = false
            FloatBtn.Visible = true
            win._open = false
        end)
    end)
    CloseBtn.MouseEnter:Connect(function()
        tw(CloseBtn, { BackgroundColor3 = Color3.fromRGB(210,55,55) }, 0.12)
    end)
    CloseBtn.MouseLeave:Connect(function()
        tw(CloseBtn, { BackgroundColor3 = Color3.fromRGB(152,38,38) }, 0.12)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        if not win._mini then
            win._mini = true
            NavPan.Visible     = false
            ContentArea.Visible = false
            tw(Main, { Size = UDim2.new(0, W_WIDTH, 0, 46) }, 0.22)
        else
            win._mini = false
            tw(Main, { Size = UDim2.new(0, W_WIDTH, 0, W_HEIGHT) }, 0.32, T.EaseB)
            task.delay(0.15, function()
                NavPan.Visible     = true
                ContentArea.Visible = true
            end)
        end
    end)
    MinBtn.MouseEnter:Connect(function()
        tw(MinBtn, { BackgroundColor3 = Color3.fromRGB(215,168,30) }, 0.12)
    end)
    MinBtn.MouseLeave:Connect(function()
        tw(MinBtn, { BackgroundColor3 = Color3.fromRGB(175,138,20) }, 0.12)
    end)

    -- Keyboard toggle
    UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == togKey then
            win:Toggle()
        end
    end)

    -- Open animation
    task.spawn(function()
        task.wait()
        tw(Main, {
            Size             = UDim2.new(0, W_WIDTH, 0, W_HEIGHT),
            GroupTransparency = 0,
        }, 0.42, T.EaseB)
    end)

    -- ── NOTIFY ────────────────────────────────────────────────
    function win:Notify(cfg2)
        cfg2 = cfg2 or {}
        local typeMap = {
            Info    = { col = T.Gold,    ic = "ℹ" },
            Success = { col = T.Green,   ic = "✓" },
            Warning = { col = T.Yellow,  ic = "⚠" },
            Error   = { col = T.Red,     ic = "✕" },
        }
        local tm  = typeMap[cfg2.Type or "Info"] or typeMap.Info
        local c   = tm.col
        local ic  = tm.ic
        local dur = cfg2.Duration or 3

        local nf = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 68),
            BackgroundColor3 = T.BG1, ZIndex = 201,
        }, NHolder)
        rnd(nf, 8)
        brdr(nf, c, 1)
        grd(nf, G(0,Color3.fromRGB(10,17,46), 1,Color3.fromRGB(7,11,30)), 135)

        -- Left accent bar
        local ab = mk("Frame", {
            Size = UDim2.new(0, 3, 1, -18), Position = UDim2.new(0, 8, 0, 9),
            BackgroundColor3 = c, ZIndex = 202,
        }, nf)
        rnd(ab, 2)

        -- Icon circle
        local icBG = mk("Frame", {
            Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 18, 0, 9),
            BackgroundColor3 = c, BackgroundTransparency = 0.72, ZIndex = 202,
        }, nf)
        rnd(icBG, 13)
        mk("TextLabel", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            Text = ic, TextSize = 13, TextColor3 = c,
            Font = T.FontB, ZIndex = 203,
        }, icBG)

        mk("TextLabel", {
            Size = UDim2.new(1,-52,0,20), Position = UDim2.new(0,50,0,8),
            BackgroundTransparency = 1,
            Text = cfg2.Title or "Notification",
            TextSize = 12, TextColor3 = c,
            Font = T.FontB, TextXAlignment = Enum.TextXAlignment.Left,
            RichText = true, ZIndex = 202,
        }, nf)

        mk("TextLabel", {
            Size = UDim2.new(1,-52,0,28), Position = UDim2.new(0,50,0,30),
            BackgroundTransparency = 1,
            Text = cfg2.Message or "",
            TextSize = 10, TextColor3 = T.TextSub,
            Font = T.FontR, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true, RichText = true, ZIndex = 202,
        }, nf)

        -- Progress bar
        local pbg = mk("Frame", {
            Size = UDim2.new(1,-16,0,2), Position = UDim2.new(0,8,1,-5),
            BackgroundColor3 = T.BG4, ZIndex = 202,
        }, nf)
        rnd(pbg, 1)
        local pfill = mk("Frame", {
            Size = UDim2.new(1,0,1,0), BackgroundColor3 = c, ZIndex = 203,
        }, pbg)
        rnd(pfill, 1)

        -- Slide in
        nf.Position = UDim2.new(1, 20, 1, 0)
        tw(nf, { Position = UDim2.new(0, 0, 1, 0) }, 0.30, T.EaseB)
        tw(pfill, { Size = UDim2.new(0, 0, 1, 0) }, dur, Enum.EasingStyle.Linear)

        task.delay(dur, function()
            tw(nf, { Position = UDim2.new(1, 20, 1, 0) }, 0.22)
            task.delay(0.22, function() pcall(function() nf:Destroy() end) end)
        end)
    end

    -- ── TOGGLE WINDOW ─────────────────────────────────────────
    function win:Toggle()
        if win._open then
            win._open = false
            tw(Main, { GroupTransparency = 1 }, 0.22)
            task.delay(0.22, function()
                Main.Visible    = false
                FloatBtn.Visible = true
            end)
        else
            win._open = true
            FloatBtn.Visible = false
            Main.Visible    = true
            Main.GroupTransparency = 1
            tw(Main, { GroupTransparency = 0 }, 0.28)
        end
    end

    -- ── ADD NAV GROUP ─────────────────────────────────────────
    function win:AddNavGroup(groupName)
        local group = { _pages = {} }

        -- Group header
        mk("TextLabel", {
            Size = UDim2.new(1,-4, 0, 18),
            BackgroundTransparency = 1,
            Text = (groupName or ""):upper(),
            TextSize = 8, TextColor3 = T.TextDim,
            Font = T.FontB, TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13,
        }, NavScroll)

        -- Thin separator
        local sep = mk("Frame", {
            Size = UDim2.new(1,0,0,1),
            BackgroundColor3 = T.BG4, ZIndex = 13,
        }, NavScroll)
        grd(sep, G(0,T.BG0, 0.5,T.BG4, 1,T.BG0))

        -- ── ADD PAGE ──────────────────────────────────────────
        function group:AddPage(cfg3)
            cfg3 = cfg3 or {}
            local pName = cfg3.Name or "Page"
            local pIcon = cfg3.Icon or "○"

            local page = { _cols = {} }

            -- Nav button
            local navBtn = mk("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = T.BG1,
                Text = "", ZIndex = 14, AutoButtonColor = false,
            }, NavScroll)
            rnd(navBtn, 6)

            -- Active indicator (left edge)
            local indBar = mk("Frame", {
                Size = UDim2.new(0, 2, 0.5, 0),
                Position = UDim2.new(0, 0, 0.25, 0),
                BackgroundColor3 = T.Gold,
                BackgroundTransparency = 1,
                ZIndex = 15,
            }, navBtn)
            rnd(indBar, 1)

            local iconLbl = mk("TextLabel", {
                Size = UDim2.new(0, 22, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = pIcon, TextSize = 13, TextColor3 = T.TextDim,
                Font = T.FontB, ZIndex = 15,
            }, navBtn)

            local nameLbl = mk("TextLabel", {
                Size = UDim2.new(1,-36,1,0), Position = UDim2.new(0, 32, 0, 0),
                BackgroundTransparency = 1,
                Text = pName, TextSize = 11, TextColor3 = T.TextSub,
                Font = T.FontB, TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
            }, navBtn)

            -- Page scroll content
            local pgScroll = mk("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 3, ScrollBarImageColor3 = T.GoldDark,
                CanvasSize = UDim2.new(0,0,0,0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible = false, ZIndex = 12,
            }, ContentArea)
            pad(pgScroll, 8, 10, 8, 8)

            -- Two-column holder
            local colHolder = mk("Frame", {
                Size = UDim2.new(1,0,0,0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, ZIndex = 12,
            }, pgScroll)
            list(colHolder, 6, Enum.FillDirection.Horizontal,
                 Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top)

            -- ── ADD COLUMN ────────────────────────────────────
            function page:AddColumn()
                local col = { _secs = {} }

                local colFrame = mk("Frame", {
                    Size = UDim2.new(0.5, -3, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, ZIndex = 13,
                }, colHolder)
                list(colFrame, 6)

                table.insert(page._cols, col)

                -- ── ADD SECTION ───────────────────────────────
                function col:AddSection(cfg4)
                    cfg4 = cfg4 or {}
                    local secName  = cfg4.Name or "Section"
                    local collapsed = false
                    local sec      = {}

                    local secFrame = mk("Frame", {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = T.BG2,
                        BorderSizePixel = 0, ZIndex = 14,
                        ClipsDescendants = false,
                    }, colFrame)
                    rnd(secFrame, 7)
                    brdr(secFrame, Color3.fromRGB(22, 35, 84), 1)
                    grd(secFrame, G(0,Color3.fromRGB(12,19,50), 1,Color3.fromRGB(7,11,30)), 145)

                    -- Section header bar
                    local secHdr = mk("Frame", {
                        Size = UDim2.new(1,0,0,34),
                        BackgroundColor3 = Color3.fromRGB(9,14,38),
                        ZIndex = 15,
                    }, secFrame)
                    rnd(secHdr, 7)
                    -- Fix bottom corners of section header
                    mk("Frame", {
                        Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0),
                        BackgroundColor3 = Color3.fromRGB(9,14,38),
                        BorderSizePixel = 0, ZIndex = 15,
                    }, secHdr)

                    -- Gold dot (like VoidHub's colored circle)
                    local dot = mk("Frame", {
                        Size = UDim2.new(0, 7, 0, 7),
                        Position = UDim2.new(0, 10, 0.5, -3.5),
                        BackgroundColor3 = T.Gold, ZIndex = 16,
                    }, secHdr)
                    rnd(dot, 4)
                    -- Dot glow
                    mk("ImageLabel", {
                        AnchorPoint = Vector2.new(0.5,0.5),
                        Size = UDim2.new(0,18,0,18), Position = UDim2.new(0.5,0,0.5,0),
                        BackgroundTransparency = 1, ZIndex = 15,
                        Image = "rbxassetid://5028857472",
                        ImageColor3 = T.Gold, ImageTransparency = 0.6,
                    }, dot)

                    mk("TextLabel", {
                        Size = UDim2.new(1,-62,1,0), Position = UDim2.new(0,22,0,0),
                        BackgroundTransparency = 1,
                        Text = secName, TextSize = 11, TextColor3 = T.Text,
                        Font = T.FontB, TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 16,
                    }, secHdr)

                    -- Thin separator under header
                    local hdrLine = mk("Frame", {
                        Size = UDim2.new(1,-12,0,1), Position = UDim2.new(0,6,1,-1),
                        BackgroundColor3 = T.BG4, ZIndex = 15,
                    }, secHdr)
                    grd(hdrLine, G(0,T.BG0, 0.5,T.BG4, 1,T.BG0))

                    -- Collapse button
                    local colBtn = mk("TextButton", {
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new(1, -26, 0.5, -10),
                        BackgroundColor3 = T.BG4,
                        Text = "−", TextSize = 14, TextColor3 = T.TextDim,
                        Font = T.FontB, ZIndex = 17, AutoButtonColor = false,
                    }, secHdr)
                    rnd(colBtn, 4)

                    -- Section content
                    local secCnt = mk("Frame", {
                        Size = UDim2.new(1,0,0,0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1, ZIndex = 15,
                    }, secFrame)
                    list(secCnt, 4)
                    pad(secCnt, 38, 7, 7, 7)

                    colBtn.MouseButton1Click:Connect(function()
                        collapsed = not collapsed
                        if collapsed then
                            colBtn.Text = "+"
                            tw(colBtn, { TextColor3 = T.Gold }, 0.14)
                            tw(secFrame, { AutomaticSize = Enum.AutomaticSize.None,
                                          Size = UDim2.new(1,0,0,34) }, 0.18)
                            secCnt.Visible = false
                        else
                            secCnt.Visible = true
                            colBtn.Text = "−"
                            tw(colBtn, { TextColor3 = T.TextDim }, 0.14)
                            tw(secFrame, { AutomaticSize = Enum.AutomaticSize.Y }, 0.18)
                        end
                    end)
                    colBtn.MouseEnter:Connect(function() tw(colBtn,{BackgroundColor3=T.BG5},0.12) end)
                    colBtn.MouseLeave:Connect(function() tw(colBtn,{BackgroundColor3=T.BG4},0.12) end)

                    -- ── BUTTON ────────────────────────────────
                    function sec:AddButton(cfg5)
                        cfg5 = cfg5 or {}
                        local name = cfg5.Name or "Button"
                        local desc = cfg5.Description or ""
                        local cb   = cfg5.Callback or function() end

                        local h = desc ~= "" and 44 or 30
                        local bf = mk("Frame", {
                            Size = UDim2.new(1,0,0,h),
                            BackgroundColor3 = T.BG3, ZIndex = 16,
                        }, secCnt)
                        rnd(bf, 5)

                        mk("TextLabel", {
                            Size = UDim2.new(1,-26,0,18), Position = UDim2.new(0,10,0,desc~="" and 5 or 6),
                            BackgroundTransparency=1, Text=name,
                            TextSize=11, TextColor3=T.Text,
                            Font=T.FontB, TextXAlignment=Enum.TextXAlignment.Left,
                            RichText=true, ZIndex=17,
                        }, bf)
                        if desc ~= "" then
                            mk("TextLabel",{
                                Size=UDim2.new(1,-26,0,14), Position=UDim2.new(0,10,0,24),
                                BackgroundTransparency=1, Text=desc,
                                TextSize=9, TextColor3=T.TextDim,
                                Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                                TextWrapped=true, ZIndex=17,
                            }, bf)
                        end
                        mk("TextLabel",{
                            Size=UDim2.new(0,14,1,0), Position=UDim2.new(1,-18,0,0),
                            BackgroundTransparency=1, Text="›",
                            TextSize=16, TextColor3=T.GoldDim,
                            Font=T.FontB, ZIndex=17,
                        }, bf)

                        local bb = mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=18,AutoButtonColor=false},bf)
                        bb.MouseEnter:Connect(function() tw(bf,{BackgroundColor3=T.BG4},0.12) end)
                        bb.MouseLeave:Connect(function() tw(bf,{BackgroundColor3=T.BG3},0.12) end)
                        bb.MouseButton1Down:Connect(function() tw(bf,{BackgroundColor3=T.BG5},0.08) end)
                        bb.MouseButton1Click:Connect(function()
                            ripple(bf, 19)
                            cb()
                        end)
                        return bf
                    end

                    -- ── TOGGLE ────────────────────────────────
                    function sec:AddToggle(cfg5)
                        cfg5 = cfg5 or {}
                        local name = cfg5.Name     or "Toggle"
                        local def  = cfg5.Default  or false
                        local desc = cfg5.Description or ""
                        local cb   = cfg5.Callback or function() end

                        local tog = { Value = def }
                        local h   = desc ~= "" and 44 or 30

                        local tf = mk("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=T.BG3,ZIndex=16},secCnt)
                        rnd(tf, 5)

                        mk("TextLabel",{
                            Size=UDim2.new(1,-56,0,18), Position=UDim2.new(0,10,0,desc~="" and 5 or 6),
                            BackgroundTransparency=1, Text=name,
                            TextSize=11, TextColor3=T.Text,
                            Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                            ZIndex=17,
                        }, tf)
                        if desc ~= "" then
                            mk("TextLabel",{
                                Size=UDim2.new(1,-56,0,14), Position=UDim2.new(0,10,0,24),
                                BackgroundTransparency=1, Text=desc,
                                TextSize=9, TextColor3=T.TextDim,
                                Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                                TextWrapped=true, ZIndex=17,
                            }, tf)
                        end

                        -- Switch background
                        local swBG = mk("Frame",{
                            Size=UDim2.new(0,38,0,18),
                            Position=UDim2.new(1,-46,0.5,-9),
                            BackgroundColor3 = def and T.Gold or T.BG5,
                            ZIndex=17,
                        }, tf)
                        rnd(swBG, 9)

                        -- Knob
                        local knob = mk("Frame",{
                            Size=UDim2.new(0,12,0,12),
                            Position=UDim2.new(0, def and 22 or 3, 0.5,-6),
                            BackgroundColor3 = def and T.BG0 or T.TextDim,
                            ZIndex=18,
                        }, swBG)
                        rnd(knob, 6)

                        local function updateTog()
                            if tog.Value then
                                tw(swBG, {BackgroundColor3=T.Gold}, 0.18)
                                tw(knob, {Position=UDim2.new(0,22,0.5,-6),BackgroundColor3=T.BG0}, 0.18)
                            else
                                tw(swBG, {BackgroundColor3=T.BG5}, 0.18)
                                tw(knob, {Position=UDim2.new(0,3,0.5,-6),BackgroundColor3=T.TextDim}, 0.18)
                            end
                        end

                        local cl = mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=19,AutoButtonColor=false},tf)
                        cl.MouseButton1Click:Connect(function()
                            tog.Value = not tog.Value
                            updateTog()
                            cb(tog.Value)
                        end)
                        cl.MouseEnter:Connect(function() tw(tf,{BackgroundColor3=T.BG4},0.12) end)
                        cl.MouseLeave:Connect(function() tw(tf,{BackgroundColor3=T.BG3},0.12) end)

                        function tog:Set(v)
                            tog.Value = v; updateTog(); cb(v)
                        end
                        return tog
                    end

                    -- ── SLIDER ────────────────────────────────
                    function sec:AddSlider(cfg5)
                        cfg5 = cfg5 or {}
                        local name  = cfg5.Name     or "Slider"
                        local smin  = cfg5.Min      or 0
                        local smax  = cfg5.Max      or 100
                        local def   = math.clamp(cfg5.Default or smin, smin, smax)
                        local suf   = cfg5.Suffix   or ""
                        local cb    = cfg5.Callback or function() end

                        local sl = { Value = def }

                        local sf = mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundColor3=T.BG3,ZIndex=16},secCnt)
                        rnd(sf, 5)

                        mk("TextLabel",{
                            Size=UDim2.new(1,-65,0,18), Position=UDim2.new(0,10,0,5),
                            BackgroundTransparency=1, Text=name,
                            TextSize=10, TextColor3=T.TextSub,
                            Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                            ZIndex=17,
                        }, sf)
                        local valLbl = mk("TextLabel",{
                            Size=UDim2.new(0,58,0,18), Position=UDim2.new(1,-65,0,5),
                            BackgroundTransparency=1, Text=tostring(def)..suf,
                            TextSize=10, TextColor3=T.Gold,
                            Font=T.FontB, TextXAlignment=Enum.TextXAlignment.Right,
                            ZIndex=17,
                        }, sf)

                        -- Track
                        local track = mk("Frame",{
                            Size=UDim2.new(1,-16,0,4), Position=UDim2.new(0,8,0,30),
                            BackgroundColor3=T.BG5, ZIndex=17,
                        }, sf)
                        rnd(track, 2)

                        local rel = (def-smin)/(smax-smin)
                        local fill = mk("Frame",{Size=UDim2.new(rel,0,1,0),BackgroundColor3=T.Gold,ZIndex=18},track)
                        rnd(fill, 2)
                        grd(fill, G(0,T.Gold, 1,T.GoldBrt))

                        -- Knob
                        local sk = mk("Frame",{
                            Size=UDim2.new(0,12,0,12),
                            Position=UDim2.new(rel,-6,0.5,-6),
                            BackgroundColor3=Color3.fromRGB(255,255,255),
                            ZIndex=19,
                        }, track)
                        rnd(sk, 6)
                        brdr(sk, T.Gold, 1.5)

                        local sdrag = false
                        local function updateSl(inp)
                            local r = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                            local v = math.floor(smin + (smax - smin) * r)
                            sl.Value = v
                            valLbl.Text = tostring(v)..suf
                            fill.Size = UDim2.new(r,0,1,0)
                            sk.Position = UDim2.new(r,-6,0.5,-6)
                            cb(v)
                        end

                        track.InputBegan:Connect(function(inp)
                            if inp.UserInputType==Enum.UserInputType.MouseButton1
                            or inp.UserInputType==Enum.UserInputType.Touch then
                                sdrag = true; updateSl(inp)
                            end
                        end)
                        UIS.InputChanged:Connect(function(inp)
                            if sdrag and (inp.UserInputType==Enum.UserInputType.MouseMovement
                                       or inp.UserInputType==Enum.UserInputType.Touch) then
                                updateSl(inp)
                            end
                        end)
                        UIS.InputEnded:Connect(function(inp)
                            if inp.UserInputType==Enum.UserInputType.MouseButton1
                            or inp.UserInputType==Enum.UserInputType.Touch then
                                sdrag = false
                            end
                        end)

                        sf.MouseEnter:Connect(function()
                            tw(sk,{Size=UDim2.new(0,16,0,16)},0.10)
                        end)
                        sf.MouseLeave:Connect(function()
                            tw(sk,{Size=UDim2.new(0,12,0,12)},0.10)
                        end)

                        function sl:Set(v)
                            v = math.clamp(v, smin, smax)
                            sl.Value = v
                            local r2 = (v-smin)/(smax-smin)
                            valLbl.Text = tostring(v)..suf
                            tw(fill,{Size=UDim2.new(r2,0,1,0)},0.18)
                            tw(sk,{Position=UDim2.new(r2,-6,0.5,-6)},0.18)
                        end
                        return sl
                    end

                    -- ── DROPDOWN ──────────────────────────────
                    function sec:AddDropdown(cfg5)
                        cfg5 = cfg5 or {}
                        local name = cfg5.Name    or "Dropdown"
                        local opts = cfg5.Options or {}
                        local def  = cfg5.Default or "None selected"
                        local cb   = cfg5.Callback or function() end

                        local dd   = { Value = def }
                        local open2 = false

                        local df = mk("Frame",{
                            Size=UDim2.new(1,0,0,30),
                            BackgroundTransparency=1, ZIndex=16, ClipsDescendants=false,
                        }, secCnt)

                        if name ~= "" then
                            mk("TextLabel",{
                                Size=UDim2.new(0.44,0,1,0),
                                BackgroundTransparency=1, Text=name,
                                TextSize=10, TextColor3=T.TextSub,
                                Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                                ZIndex=17,
                            }, df)
                        end

                        local selBox = mk("Frame",{
                            Size=UDim2.new(0.56,0,0,24),
                            Position=UDim2.new(0.44,0,0.5,-12),
                            BackgroundColor3=T.BG4, ZIndex=17,
                        }, selBox or df)
                        rnd(selBox, 4)
                        brdr(selBox, T.BG5, 1)

                        -- Re-assign correctly after first use
                        selBox = (function()
                            local s = mk("Frame",{
                                Size=UDim2.new(0.56,0,0,24),
                                Position=UDim2.new(0.44,0,0.5,-12),
                                BackgroundColor3=T.BG4, ZIndex=17,
                            }, df)
                            rnd(s, 4)
                            brdr(s, T.BG5, 1)
                            return s
                        end)()

                        local selTxt = mk("TextLabel",{
                            Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,6,0,0),
                            BackgroundTransparency=1, Text=def,
                            TextSize=10, TextColor3=T.TextSub,
                            Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                            TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=18,
                        }, selBox)
                        local arrow = mk("TextLabel",{
                            Size=UDim2.new(0,14,1,0), Position=UDim2.new(1,-15,0,0),
                            BackgroundTransparency=1, Text="⌄",
                            TextSize=10, TextColor3=T.TextDim,
                            Font=T.FontB, ZIndex=18,
                        }, selBox)

                        -- List
                        local dlist = mk("Frame",{
                            Size=UDim2.new(0.56,0,0,0),
                            Position=UDim2.new(0.44,0,1,3),
                            BackgroundColor3=T.BG1,
                            Visible=false, ZIndex=55, ClipsDescendants=true,
                        }, df)
                        rnd(dlist, 5)
                        brdr(dlist, T.Gold, 1)
                        grd(dlist, G(0,Color3.fromRGB(9,15,42), 1,Color3.fromRGB(6,9,26)), 135)

                        local dscroll = mk("ScrollingFrame",{
                            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                            BorderSizePixel=0, ScrollBarThickness=2,
                            ScrollBarImageColor3=T.GoldDark,
                            CanvasSize=UDim2.new(0,0,0,0),
                            AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=56,
                        }, dlist)
                        list(dscroll, 2)
                        pad(dscroll, 3,3,3,3)

                        local function pop()
                            for _, ch in pairs(dscroll:GetChildren()) do
                                if ch:IsA("TextButton") then ch:Destroy() end
                            end
                            for _, opt in ipairs(opts) do
                                local sel = opt == dd.Value
                                local ob = mk("TextButton",{
                                    Size=UDim2.new(1,0,0,24),
                                    BackgroundColor3 = sel and T.BG5 or T.BG3,
                                    Text=opt, TextSize=10,
                                    TextColor3 = sel and T.Gold or T.TextSub,
                                    Font = sel and T.FontB or T.FontR,
                                    ZIndex=57, AutoButtonColor=false,
                                }, dscroll)
                                rnd(ob, 3)
                                ob.MouseEnter:Connect(function() tw(ob,{BackgroundColor3=T.BG6,TextColor3=T.Text},0.10) end)
                                ob.MouseLeave:Connect(function() tw(ob,{BackgroundColor3=sel and T.BG5 or T.BG3,TextColor3=sel and T.Gold or T.TextSub},0.10) end)
                                ob.MouseButton1Click:Connect(function()
                                    dd.Value = opt
                                    selTxt.Text = opt
                                    open2 = false
                                    tw(dlist,{Size=UDim2.new(0.56,0,0,0)},0.15)
                                    task.delay(0.15,function() dlist.Visible=false df.Size=UDim2.new(1,0,0,30) end)
                                    tw(arrow,{Rotation=0},0.15)
                                    pop()
                                    cb(opt)
                                end)
                            end
                        end
                        pop()

                        local cl = mk("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Text="",ZIndex=20,AutoButtonColor=false},df)
                        cl.MouseButton1Click:Connect(function()
                            open2 = not open2
                            if open2 then
                                local h2 = math.min(#opts*26, 130)
                                dlist.Visible=true dlist.Size=UDim2.new(0.56,0,0,0)
                                df.Size=UDim2.new(1,0,0,30+h2+5)
                                tw(dlist,{Size=UDim2.new(0.56,0,0,h2)},0.22,T.EaseB)
                                tw(arrow,{Rotation=180},0.16)
                            else
                                tw(dlist,{Size=UDim2.new(0.56,0,0,0)},0.15)
                                task.delay(0.15,function() dlist.Visible=false df.Size=UDim2.new(1,0,0,30) end)
                                tw(arrow,{Rotation=0},0.15)
                            end
                        end)

                        function dd:Set(v) dd.Value=v selTxt.Text=v pop() cb(v) end
                        function dd:Refresh(o) opts=o pop() end
                        return dd
                    end

                    -- ── MULTI DROPDOWN ────────────────────────
                    function sec:AddMultiDropdown(cfg5)
                        cfg5 = cfg5 or {}
                        local name = cfg5.Name    or "Multi Select"
                        local opts = cfg5.Options or {}
                        local def  = cfg5.Default or {}
                        local cb   = cfg5.Callback or function() end

                        local mdd  = { Value = {} }
                        for _, v in ipairs(def) do mdd.Value[v] = true end
                        local open3 = false

                        local mf = mk("Frame",{
                            Size=UDim2.new(1,0,0,30),
                            BackgroundTransparency=1, ZIndex=16, ClipsDescendants=false,
                        }, secCnt)

                        if name ~= "" then
                            mk("TextLabel",{
                                Size=UDim2.new(0.44,0,1,0),
                                BackgroundTransparency=1, Text=name,
                                TextSize=10, TextColor3=T.TextSub,
                                Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                                ZIndex=17,
                            }, mf)
                        end

                        local mBox = mk("Frame",{
                            Size=UDim2.new(0.56,0,0,24),
                            Position=UDim2.new(0.44,0,0.5,-12),
                            BackgroundColor3=T.BG4, ZIndex=17,
                        }, mf)
                        rnd(mBox, 4)
                        brdr(mBox, T.BG5, 1)

                        local mTxt = mk("TextLabel",{
                            Size=UDim2.new(1,-36,1,0), Position=UDim2.new(0,6,0,0),
                            BackgroundTransparency=1, Text="None selected",
                            TextSize=10, TextColor3=T.TextSub,
                            Font=T.FontR, TextXAlignment=Enum.TextXAlignment.Left,
                            TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=18,
                        }, mBox)

                        local badge = mk("Frame",{
                            Size=UDim2.new(0,18,0,18), Position=UDim2.new(1,-22,0.5,-9),
                            BackgroundColor3=T.BG5, ZIndex=18,
                        }, mBox)
                        rnd(badge, 9)
                        local badgeTxt = mk("TextLabel",{
                            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                            Text="0", TextSize=9, TextColor3=T.TextDim,
                            Font=T.FontB, ZIndex=19,
                        }, badge)

                        local marrow = mk("TextLabel",{
                            Size=UDim2.new(0,13,1,0), Position=UDim2.new(1,1,0,0),
                            BackgroundTransparency=1, Text="⌄",
                            TextSize=10, TextColor3=T.TextDim,
                            Font=T.FontB, ZIndex=18,
                        }, mBox)

                        local function updateBadge()
                            local cnt, names = 0, {}
                            for k, v in pairs(mdd.Value) do
                                if v then cnt = cnt+1 table.insert(names,k) end
                            end
                            badgeTxt.Text = tostring(cnt)
                            if cnt > 0 then
                                tw(badge,{BackgroundColor3=T.Gold},0.12)
                                tw(badgeTxt,{TextColor3=T.BG0},0.12)
                                mTxt.Text = table.concat(names, ", ")
                            else
                                tw(badge,{BackgroundColor3=T.BG5},0.12)
                                tw(badgeTxt,{TextColor3=T.TextDim},0.12)
                                mTxt.Text = "None selected"
                            end
                        end
                        updateBadge()

                        local ml = mk("Frame",{
                            Size=UDim2.new(0.56,0,0,0),
                            Position=UDim2.new(0.44,0,1,3),
                            BackgroundColor3=T.BG1,
                            Visible=false, ZIndex=55, ClipsDescendants=true,
                        }, mf)
                        rnd(ml, 5)
                        brdr(ml, T.Gold, 1)

                        local mscroll = mk("ScrollingFrame",{
                            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                            BorderSizePixel=0, ScrollBarThickness=2,
                            ScrollBarImageColor3=T.GoldDark,
                            CanvasSize=UDim2.new(0,0,0,0),
                            AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=56,
                        }, ml)
                        list(mscroll, 2)
                        pad(mscroll, 3,3,3,3)

                        local function popMDD()
                            for _, ch in pairs(mscroll:GetChildren()) do
                                if ch:IsA("Frame") then ch:Destroy() end
                            end
                            for _, opt in ipairs(opts) do
                                local sel = mdd.Value[opt] == true
                                local oF = mk("Frame",{
                                    Size=UDim2.new(1,0,0,24),
                                    BackgroundColor3 = sel and T.BG5 or T.BG3,
                                    ZIndex=57,
                                }, mscroll)
                                rnd(oF, 3)

                                local chk = mk("Frame",{
                                    Size=UDim2.new(0,14,0,14), Position=UDim2.new(0,5,0.5,-7),
                                    BackgroundColor3 = sel and T.Gold or T.BG5,
                                    ZIndex=58,
                                }, oF)
                                rnd(chk, 3)
                                mk("TextLabel",{
                                    Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                                    Text=sel and "✓" or "", TextSize=9, TextColor3=T.BG0,
                                    Font=T.FontB, ZIndex=59,
                                }, chk)
                                mk("TextLabel",{
                                    Size=UDim2.new(1,-26,1,0), Position=UDim2.new(0,24,0,0),
                                    BackgroundTransparency=1, Text=opt,
                                    TextSize=10, TextColor3=sel and T.Gold or T.TextSub,
                                    Font=sel and T.FontB or T.FontR,
                                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=58,
                                }, oF)

                                local oc = mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=60,AutoButtonColor=false},oF)
                                oc.MouseEnter:Connect(function() tw(oF,{BackgroundColor3=T.BG6},0.10) end)
                                oc.MouseLeave:Connect(function() tw(oF,{BackgroundColor3=mdd.Value[opt] and T.BG5 or T.BG3},0.10) end)
                                oc.MouseButton1Click:Connect(function()
                                    if mdd.Value[opt] then mdd.Value[opt]=nil else mdd.Value[opt]=true end
                                    updateBadge(); popMDD(); cb(mdd.Value)
                                end)
                            end
                        end
                        popMDD()

                        local mcl = mk("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Text="",ZIndex=20,AutoButtonColor=false},mf)
                        mcl.MouseButton1Click:Connect(function()
                            open3 = not open3
                            if open3 then
                                local h2 = math.min(#opts*26, 130)
                                ml.Visible=true ml.Size=UDim2.new(0.56,0,0,0)
                                mf.Size=UDim2.new(1,0,0,30+h2+5)
                                tw(ml,{Size=UDim2.new(0.56,0,0,h2)},0.22,T.EaseB)
                                tw(marrow,{Rotation=180},0.16)
                            else
                                tw(ml,{Size=UDim2.new(0.56,0,0,0)},0.15)
                                task.delay(0.15,function() ml.Visible=false mf.Size=UDim2.new(1,0,0,30) end)
                                tw(marrow,{Rotation=0},0.15)
                            end
                        end)

                        function mdd:Set(v) mdd.Value=v updateBadge() popMDD() cb(v) end
                        return mdd
                    end

                    -- ── INPUT ─────────────────────────────────
                    function sec:AddInput(cfg5)
                        cfg5 = cfg5 or {}
                        local name = cfg5.Name        or ""
                        local ph   = cfg5.Placeholder or "Type here..."
                        local def  = cfg5.Default     or ""
                        local cb   = cfg5.Callback    or function() end

                        local inp = { Value = def }
                        local h2  = name~="" and 44 or 30

                        local inf = mk("Frame",{Size=UDim2.new(1,0,0,h2),BackgroundColor3=T.BG3,ZIndex=16},secCnt)
                        rnd(inf, 5)

                        if name~="" then
                            mk("TextLabel",{
                                Size=UDim2.new(1,-10,0,16),Position=UDim2.new(0,8,0,4),
                                BackgroundTransparency=1,Text=name,
                                TextSize=9,TextColor3=T.Gold,Font=T.FontB,
                                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=17,
                            },inf)
                        end

                        local inBG = mk("Frame",{
                            Size=UDim2.new(1,-12,0,22),
                            Position=UDim2.new(0,6,0,name~="" and 20 or 4),
                            BackgroundColor3=T.BG1, ZIndex=17,
                        },inf)
                        rnd(inBG, 4)
                        brdr(inBG, T.BG5, 1)

                        local tb = mk("TextBox",{
                            Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,5,0,0),
                            BackgroundTransparency=1,Text=def,
                            PlaceholderText=ph,PlaceholderColor3=T.TextDim,
                            TextSize=10,TextColor3=T.Text,Font=T.FontR,
                            TextXAlignment=Enum.TextXAlignment.Left,
                            ClearTextOnFocus=false,ZIndex=18,
                        },inBG)

                        tb.Focused:Connect(function()
                            for _,v in pairs(inBG:GetDescendants()) do
                                if v:IsA("UIStroke") then tw(v,{Color=T.Gold},0.18) end
                            end
                        end)
                        tb.FocusLost:Connect(function(enter)
                            for _,v in pairs(inBG:GetDescendants()) do
                                if v:IsA("UIStroke") then tw(v,{Color=T.BG5},0.18) end
                            end
                            inp.Value=tb.Text
                            if enter then cb(tb.Text) end
                        end)
                        tb:GetPropertyChangedSignal("Text"):Connect(function()
                            inp.Value=tb.Text; cb(tb.Text)
                        end)

                        function inp:Set(v) tb.Text=v inp.Value=v end
                        return inp
                    end

                    -- ── PARAGRAPH ─────────────────────────────
                    function sec:AddParagraph(cfg5)
                        cfg5 = cfg5 or {}
                        local ptit = cfg5.Title   or ""
                        local pcon = cfg5.Content or ""

                        local pf = mk("Frame",{
                            Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                            BackgroundColor3=Color3.fromRGB(8,12,34),ZIndex=16,
                        },secCnt)
                        rnd(pf, 5)
                        list(pf, 3)
                        pad(pf, 7,7,8,8)

                        local ptL, pcL
                        if ptit~="" then
                            ptL = mk("TextLabel",{
                                Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                                BackgroundTransparency=1,Text=ptit,
                                TextSize=11,TextColor3=T.Gold,Font=T.FontB,
                                TextXAlignment=Enum.TextXAlignment.Left,
                                TextWrapped=true,RichText=true,ZIndex=17,
                            },pf)
                        end
                        if pcon~="" then
                            pcL = mk("TextLabel",{
                                Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                                BackgroundTransparency=1,Text=pcon,
                                TextSize=10,TextColor3=T.TextSub,Font=T.FontR,
                                TextXAlignment=Enum.TextXAlignment.Left,
                                TextWrapped=true,RichText=true,ZIndex=17,
                            },pf)
                        end
                        local para = {}
                        function para:Set(t2,c2)
                            if ptL and t2 then ptL.Text=t2 end
                            if pcL and c2 then pcL.Text=c2 end
                        end
                        return para
                    end

                    -- ── LABEL ─────────────────────────────────
                    function sec:AddLabel(cfg5)
                        cfg5 = cfg5 or {}
                        local lf = mk("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,ZIndex=16},secCnt)
                        local ll = mk("TextLabel",{
                            Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,4,0,0),
                            BackgroundTransparency=1,Text=cfg5.Text or "Label",
                            TextSize=10,TextColor3=T.TextSub,Font=T.FontR,
                            TextXAlignment=Enum.TextXAlignment.Left,
                            TextWrapped=true,RichText=true,ZIndex=17,
                        },lf)
                        local lbl={}
                        function lbl:Set(t2) ll.Text=t2 end
                        return lbl
                    end

                    -- ── SEPARATOR ─────────────────────────────
                    function sec:AddSeparator()
                        local sf2 = mk("Frame",{Size=UDim2.new(1,0,0,10),BackgroundTransparency=1,ZIndex=16},secCnt)
                        local sl2 = mk("Frame",{
                            Size=UDim2.new(0.88,0,0,1),Position=UDim2.new(0.06,0,0.5,0),
                            BackgroundColor3=T.BG5,ZIndex=17,
                        },sf2)
                        grd(sl2, G(0,T.BG0, 0.5,T.BG5, 1,T.BG0))
                    end

                    -- ── DISCORD BUTTON ────────────────────────
                    function sec:AddDiscord(cfg5)
                        cfg5 = cfg5 or {}
                        local inv = cfg5.Invite  or ""
                        local mem = cfg5.Members or ""
                        local cb2 = cfg5.Callback or function() end

                        local dcf = mk("Frame",{
                            Size=UDim2.new(1,0,0,46),
                            BackgroundColor3=T.Discord,ZIndex=16,
                        },secCnt)
                        rnd(dcf, 6)
                        grd(dcf, G(0,Color3.fromRGB(100,115,255), 1,Color3.fromRGB(65,78,208)), 135)

                        mk("TextLabel",{
                            Size=UDim2.new(0,28,0,28),Position=UDim2.new(0,8,0.5,-14),
                            BackgroundTransparency=1,Text="💬",TextSize=20,ZIndex=17,
                        },dcf)
                        mk("TextLabel",{
                            Size=UDim2.new(1,-84,0,18),Position=UDim2.new(0,40,0,6),
                            BackgroundTransparency=1,Text="Join Discord",
                            TextSize=12,TextColor3=Color3.fromRGB(255,255,255),
                            Font=T.FontB,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=17,
                        },dcf)
                        if mem~="" then
                            mk("TextLabel",{
                                Size=UDim2.new(1,-84,0,14),Position=UDim2.new(0,40,0,26),
                                BackgroundTransparency=1,Text="🟢 "..mem,
                                TextSize=9,TextColor3=Color3.fromRGB(200,215,255),
                                Font=T.FontR,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=17,
                            },dcf)
                        end

                        local jb = mk("TextButton",{
                            Size=UDim2.new(0,54,0,24),Position=UDim2.new(1,-62,0.5,-12),
                            BackgroundColor3=Color3.fromRGB(255,255,255),
                            Text="Join",TextSize=11,TextColor3=T.Discord,
                            Font=T.FontB,ZIndex=18,AutoButtonColor=false,
                        },dcf)
                        rnd(jb, 5)

                        jb.MouseButton1Click:Connect(function()
                            tw(jb,{BackgroundColor3=Color3.fromRGB(220,225,255)},0.08)
                            task.delay(0.15,function() tw(jb,{BackgroundColor3=Color3.fromRGB(255,255,255)},0.10) end)
                            if inv~="" then
                                pcall(function() setclipboard("discord.gg/"..inv) end)
                                win:Notify({Title="Discord",Message="Copied! discord.gg/"..inv,Type="Info",Duration=3})
                            end
                            cb2(inv)
                        end)
                        jb.MouseEnter:Connect(function() tw(jb,{BackgroundColor3=Color3.fromRGB(238,240,255)},0.10) end)
                        jb.MouseLeave:Connect(function() tw(jb,{BackgroundColor3=Color3.fromRGB(255,255,255)},0.10) end)
                        return dcf
                    end

                    -- ── KEYBIND ───────────────────────────────
                    function sec:AddKeybind(cfg5)
                        cfg5 = cfg5 or {}
                        local name = cfg5.Name    or "Keybind"
                        local def  = cfg5.Default or Enum.KeyCode.Unknown
                        local cb   = cfg5.Callback or function() end

                        local kb   = { Value = def }
                        local klis = false

                        local kf = mk("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=T.BG3,ZIndex=16},secCnt)
                        rnd(kf, 5)
                        mk("TextLabel",{
                            Size=UDim2.new(1,-72,1,0),Position=UDim2.new(0,10,0,0),
                            BackgroundTransparency=1,Text=name,
                            TextSize=10,TextColor3=T.TextSub,Font=T.FontR,
                            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=17,
                        },kf)

                        local kb2 = mk("TextButton",{
                            Size=UDim2.new(0,62,0,20),Position=UDim2.new(1,-70,0.5,-10),
                            BackgroundColor3=T.BG4,
                            Text=def==Enum.KeyCode.Unknown and "NONE" or def.Name,
                            TextSize=9,TextColor3=T.Gold,Font=T.FontB,
                            ZIndex=18,AutoButtonColor=false,
                        },kf)
                        rnd(kb2, 4)
                        brdr(kb2, T.GoldDark, 1)

                        kb2.MouseButton1Click:Connect(function()
                            if not klis then klis=true kb2.Text="..." tw(kb2,{TextColor3=T.GoldBrt},0.12) end
                        end)
                        UIS.InputBegan:Connect(function(inp,gpe)
                            if klis and not gpe and inp.UserInputType==Enum.UserInputType.Keyboard then
                                kb.Value=inp.KeyCode kb2.Text=inp.KeyCode.Name
                                tw(kb2,{TextColor3=T.Gold},0.12) klis=false
                            elseif not klis and inp.KeyCode==kb.Value then cb(kb.Value) end
                        end)

                        function kb:Set(v) kb.Value=v kb2.Text=v.Name end
                        return kb
                    end

                    table.insert(col._secs, sec)
                    return sec
                end -- AddSection

                return col
            end -- AddColumn

            -- Page Select
            function page:Select()
                for _, inf in pairs(win._pages) do
                    inf.content.Visible = false
                    tw(inf.btn,   {BackgroundColor3 = T.BG1},    0.18)
                    tw(inf.nameL, {TextColor3 = T.TextSub},      0.18)
                    tw(inf.iconL, {TextColor3 = T.TextDim},      0.18)
                    tw(inf.ind,   {BackgroundTransparency = 1},  0.18)
                end
                pgScroll.Visible = true
                tw(navBtn,  {BackgroundColor3 = T.BG4},   0.18)
                tw(nameLbl, {TextColor3 = T.Gold},         0.18)
                tw(iconLbl, {TextColor3 = T.Gold},         0.18)
                tw(indBar,  {BackgroundTransparency = 0},  0.18)
            end

            navBtn.MouseButton1Click:Connect(function() page:Select() end)
            navBtn.MouseEnter:Connect(function()
                if not pgScroll.Visible then tw(navBtn,{BackgroundColor3=T.BG2},0.12) end
            end)
            navBtn.MouseLeave:Connect(function()
                if not pgScroll.Visible then tw(navBtn,{BackgroundColor3=T.BG1},0.12) end
            end)

            table.insert(win._pages, {
                btn    = navBtn,
                content= pgScroll,
                nameL  = nameLbl,
                iconL  = iconLbl,
                ind    = indBar,
            })
            table.insert(group._pages, page)

            -- Auto-select first
            if #win._pages == 1 then
                task.spawn(function() task.wait(0.06) page:Select() end)
            end

            return page
        end -- AddPage

        return group
    end -- AddNavGroup

    function win:Destroy() GUI:Destroy() end

    return win
end -- CreateWindow

return Library
