-- CyrusHubX UI Library v3.0.0 - Modern Upgrade
-- Improvements: Modern UI, Better Animations, Driver+Section, Box Element

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local httpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextService")
local RenderStepped = RunService.RenderStepped

LocalPlayer.Idled:connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

task.spawn(function()
	pcall(function()
		if game.PlaceId == 3623096087 then
			if game.Workspace:FindFirstChild("RobloxForwardPortals") then
				game.Workspace.RobloxForwardPortals:Destroy()
			end
		end
	end)
end)

local ProtectGui = protectgui or (syn and syn.protect_gui) or function(f) end

local Themes = {
	Names = { "CyrusHubX", "Midnight", "Ocean" },
	CyrusHubX = {
		Name = "CyrusHubX",
		Accent          = Color3.fromRGB(255, 70, 70),
		AcrylicMain     = Color3.fromRGB(5, 5, 5),
		AcrylicBorder   = Color3.fromRGB(35, 35, 35),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(18,18,18), Color3.fromRGB(0,0,0)),
		AcrylicNoise    = 0.7,
		TitleBarLine    = Color3.fromRGB(255, 70, 70),
		Tab             = Color3.fromRGB(255, 70, 70),
		Element         = Color3.fromRGB(180, 40, 40),
		ElementBorder   = Color3.fromRGB(100, 20, 20),
		InElementBorder = Color3.fromRGB(220, 60, 60),
		ElementTransparency = 0.75,
		ToggleSlider    = Color3.fromRGB(220, 60, 60),
		ToggleToggled   = Color3.fromRGB(255, 255, 255),
		SliderRail      = Color3.fromRGB(220, 60, 60),
		DropdownFrame   = Color3.fromRGB(15, 15, 15),
		DropdownHolder  = Color3.fromRGB(25, 25, 25),
		DropdownBorder  = Color3.fromRGB(255, 70, 70),
		DropdownOption  = Color3.fromRGB(200, 50, 50),
		Keybind         = Color3.fromRGB(200, 50, 50),
		Input           = Color3.fromRGB(255, 220, 220),
		InputFocused    = Color3.fromRGB(255, 255, 255),
		InputIndicator  = Color3.fromRGB(255, 70, 70),
		Dialog          = Color3.fromRGB(15, 15, 15),
		DialogHolder    = Color3.fromRGB(25, 25, 25),
		DialogHolderLine= Color3.fromRGB(255, 70, 70),
		DialogButton    = Color3.fromRGB(30, 30, 30),
		DialogButtonBorder = Color3.fromRGB(255, 70, 70),
		DialogBorder    = Color3.fromRGB(220, 60, 60),
		DialogInput     = Color3.fromRGB(20, 20, 20),
		DialogInputLine = Color3.fromRGB(200, 50, 50),
		Text            = Color3.fromRGB(255, 255, 255),
		SubText         = Color3.fromRGB(220, 200, 200),
		Hover           = Color3.fromRGB(220, 60, 60),
		HoverChange     = 0.08,
		BoxBackground   = Color3.fromRGB(12, 12, 12),
		BoxBorder       = Color3.fromRGB(255, 70, 70),
		SectionHeader   = Color3.fromRGB(255, 70, 70),
	},
	Midnight = {
		Name = "Midnight",
		Accent          = Color3.fromRGB(130, 90, 255),
		AcrylicMain     = Color3.fromRGB(8, 6, 18),
		AcrylicBorder   = Color3.fromRGB(40, 35, 60),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(18,14,35), Color3.fromRGB(5,3,12)),
		AcrylicNoise    = 0.65,
		TitleBarLine    = Color3.fromRGB(130, 90, 255),
		Tab             = Color3.fromRGB(130, 90, 255),
		Element         = Color3.fromRGB(80, 55, 160),
		ElementBorder   = Color3.fromRGB(50, 35, 110),
		InElementBorder = Color3.fromRGB(110, 75, 200),
		ElementTransparency = 0.78,
		ToggleSlider    = Color3.fromRGB(110, 75, 200),
		ToggleToggled   = Color3.fromRGB(255, 255, 255),
		SliderRail      = Color3.fromRGB(110, 75, 200),
		DropdownFrame   = Color3.fromRGB(12, 10, 22),
		DropdownHolder  = Color3.fromRGB(20, 16, 38),
		DropdownBorder  = Color3.fromRGB(130, 90, 255),
		DropdownOption  = Color3.fromRGB(100, 70, 180),
		Keybind         = Color3.fromRGB(100, 70, 180),
		Input           = Color3.fromRGB(200, 190, 255),
		InputFocused    = Color3.fromRGB(255, 255, 255),
		InputIndicator  = Color3.fromRGB(130, 90, 255),
		Dialog          = Color3.fromRGB(12, 10, 22),
		DialogHolder    = Color3.fromRGB(20, 16, 38),
		DialogHolderLine= Color3.fromRGB(130, 90, 255),
		DialogButton    = Color3.fromRGB(25, 20, 45),
		DialogButtonBorder = Color3.fromRGB(130, 90, 255),
		DialogBorder    = Color3.fromRGB(110, 75, 200),
		DialogInput     = Color3.fromRGB(15, 12, 28),
		DialogInputLine = Color3.fromRGB(100, 70, 180),
		Text            = Color3.fromRGB(255, 255, 255),
		SubText         = Color3.fromRGB(200, 190, 230),
		Hover           = Color3.fromRGB(110, 75, 200),
		HoverChange     = 0.08,
		BoxBackground   = Color3.fromRGB(10, 8, 20),
		BoxBorder       = Color3.fromRGB(130, 90, 255),
		SectionHeader   = Color3.fromRGB(130, 90, 255),
	},
	Ocean = {
		Name = "Ocean",
		Accent          = Color3.fromRGB(0, 180, 255),
		AcrylicMain     = Color3.fromRGB(4, 10, 18),
		AcrylicBorder   = Color3.fromRGB(20, 40, 60),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(8,20,35), Color3.fromRGB(2,6,14)),
		AcrylicNoise    = 0.6,
		TitleBarLine    = Color3.fromRGB(0, 180, 255),
		Tab             = Color3.fromRGB(0, 180, 255),
		Element         = Color3.fromRGB(0, 100, 160),
		ElementBorder   = Color3.fromRGB(0, 60, 100),
		InElementBorder = Color3.fromRGB(0, 140, 220),
		ElementTransparency = 0.76,
		ToggleSlider    = Color3.fromRGB(0, 140, 220),
		ToggleToggled   = Color3.fromRGB(255, 255, 255),
		SliderRail      = Color3.fromRGB(0, 140, 220),
		DropdownFrame   = Color3.fromRGB(6, 14, 22),
		DropdownHolder  = Color3.fromRGB(10, 22, 35),
		DropdownBorder  = Color3.fromRGB(0, 180, 255),
		DropdownOption  = Color3.fromRGB(0, 120, 200),
		Keybind         = Color3.fromRGB(0, 120, 200),
		Input           = Color3.fromRGB(180, 230, 255),
		InputFocused    = Color3.fromRGB(255, 255, 255),
		InputIndicator  = Color3.fromRGB(0, 180, 255),
		Dialog          = Color3.fromRGB(6, 14, 22),
		DialogHolder    = Color3.fromRGB(10, 22, 35),
		DialogHolderLine= Color3.fromRGB(0, 180, 255),
		DialogButton    = Color3.fromRGB(12, 28, 44),
		DialogButtonBorder = Color3.fromRGB(0, 180, 255),
		DialogBorder    = Color3.fromRGB(0, 140, 220),
		DialogInput     = Color3.fromRGB(8, 18, 30),
		DialogInputLine = Color3.fromRGB(0, 120, 200),
		Text            = Color3.fromRGB(255, 255, 255),
		SubText         = Color3.fromRGB(180, 220, 240),
		Hover           = Color3.fromRGB(0, 140, 220),
		HoverChange     = 0.08,
		BoxBackground   = Color3.fromRGB(5, 12, 20),
		BoxBorder       = Color3.fromRGB(0, 180, 255),
		SectionHeader   = Color3.fromRGB(0, 180, 255),
	},
}

local Library = {
	Version = "3.0.0",
	OpenFrames = {},
	Options = {},
	Themes = Themes.Names,
	Window = nil,
	WindowFrame = nil,
	Unloaded = false,
	Creator = nil,
	DialogOpen = false,
	UseAcrylic = false,
	Acrylic = false,
	Transparency = true,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.LeftControl,
}

do
	local GUI = game:GetService("CoreGui"):FindFirstChild("OpenClose")
	if GUI then GUI:Destroy() end
	local GUI1 = game:GetService("CoreGui"):FindFirstChild("Cyrus_Hub_X_ScreenGui")
	if GUI1 then GUI1:Destroy() end
end

-- ============ CLOSE BUTTON ============
local function CloseOpen()
	local ScreenGui = Instance.new("ScreenGui")
	local Close_ImageButton = Instance.new("ImageButton")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	ProtectGui(ScreenGui)
	ScreenGui.Name = "OpenClose"
	ScreenGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui
		or (gethui and gethui() or (cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")))
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Close_ImageButton.Parent = ScreenGui
	Close_ImageButton.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Close_ImageButton.Position = UDim2.new(0.1021, 0, 0.0743, 0)
	Close_ImageButton.Size = UDim2.new(0, 62, 0, 52)
	Close_ImageButton.Image = "rbxassetid://111662964379929"
	Close_ImageButton.Visible = false
	Close_ImageButton.BackgroundTransparency = 0.3
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Close_ImageButton
	UIStroke.Thickness = 1.5
	UIStroke.Color = Color3.fromRGB(255, 70, 70)
	UIStroke.Transparency = 0.4
	UIStroke.Parent = Close_ImageButton
	-- Dragging
	local dragging, dragStart, startPos = false
	Close_ImageButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Close_ImageButton.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	Close_ImageButton.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			Close_ImageButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	return Close_ImageButton
end
local Close_ImageButton = CloseOpen()

-- ============ MOTOR / SIGNAL SYSTEM ============
local function isMotor(v)
	local t = tostring(v):match("^Motor%((.+)%)$")
	return t and true or false, t
end

local Connection = {}
Connection.__index = Connection
function Connection.new(signal, handler)
	return setmetatable({ signal=signal, connected=true, _handler=handler }, Connection)
end
function Connection:disconnect()
	if self.connected then
		self.connected = false
		for i,c in pairs(self.signal._connections) do
			if c == self then table.remove(self.signal._connections, i) return end
		end
	end
end

local Signal = {}
Signal.__index = Signal
function Signal.new()
	return setmetatable({ _connections={}, _threads={} }, Signal)
end
function Signal:fire(...)
	for _,c in pairs(self._connections) do c._handler(...) end
	for _,t in pairs(self._threads) do coroutine.resume(t,...) end
	self._threads = {}
end
function Signal:connect(h)
	local c = Connection.new(self, h)
	table.insert(self._connections, c)
	return c
end
function Signal:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

local Linear = {}
Linear.__index = Linear
function Linear.new(t, o)
	o = o or {}
	return setmetatable({ _targetValue=t, _velocity=o.velocity or 1 }, Linear)
end
function Linear:step(s, dt)
	local p, g = s.value, self._targetValue
	local dp = dt * self._velocity
	local c = dp >= math.abs(g - p)
	p = p + dp * (g > p and 1 or -1)
	if c then p = g end
	return { complete=c, value=p, velocity=c and 0 or self._velocity }
end

local Instant = {}
Instant.__index = Instant
function Instant.new(t) return setmetatable({ _targetValue=t }, Instant) end
function Instant:step() return { complete=true, value=self._targetValue } end

local EPS = 0.0001
local Spring = {}
Spring.__index = Spring
function Spring.new(t, o)
	o = o or {}
	return setmetatable({ _targetValue=t, _frequency=o.frequency or 4, _dampingRatio=o.dampingRatio or 1 }, Spring)
end
function Spring:step(s, dt)
	local d,f,g = self._dampingRatio, self._frequency*2*math.pi, self._targetValue
	local p0,v0 = s.value, s.velocity or 0
	local off = p0-g
	local decay = math.exp(-d*f*dt)
	local p1,v1
	if d == 1 then
		p1 = (off*(1+f*dt)+v0*dt)*decay+g
		v1 = (v0*(1-f*dt)-off*(f*f*dt))*decay
	elseif d < 1 then
		local c = math.sqrt(1-d*d)
		local i,j = math.cos(f*c*dt), math.sin(f*c*dt)
		local z = c > EPS and j/c or (function()
			local a=dt*f; return a+((a*a)*(c*c)*(c*c)/20-c*c)*(a*a*a)/6
		end)()
		local y = f*c > EPS and j/(f*c) or (function()
			local b=f*c; return dt+((dt*dt)*(b*b)*(b*b)/20-b*b)*(dt*dt*dt)/6
		end)()
		p1=(off*(i+d*z)+v0*y)*decay+g
		v1=(v0*(i-z*d)-off*(z*f))*decay
	else
		local c=math.sqrt(d*d-1)
		local r1,r2=-f*(d-c),-f*(d+c)
		local co2=(v0-off*r1)/(2*f*c)
		local co1=off-co2
		local e1,e2=co1*math.exp(r1*dt),co2*math.exp(r2*dt)
		p1=e1+e2+g; v1=e1*r1+e2*r2
	end
	local done = math.abs(v1)<0.001 and math.abs(p1-g)<0.001
	return { complete=done, value=done and g or p1, velocity=v1 }
end

local noop = function() end
local BaseMotor = {}
BaseMotor.__index = BaseMotor
function BaseMotor.new()
	return setmetatable({ _onStep=Signal.new(), _onStart=Signal.new(), _onComplete=Signal.new() }, BaseMotor)
end
function BaseMotor:onStep(h) return self._onStep:connect(h) end
function BaseMotor:onStart(h) return self._onStart:connect(h) end
function BaseMotor:onComplete(h) return self._onComplete:connect(h) end
function BaseMotor:start()
	if not self._connection then
		self._connection = RunService.RenderStepped:Connect(function(dt) self:step(dt) end)
	end
end
function BaseMotor:stop()
	if self._connection then self._connection:Disconnect(); self._connection=nil end
end
BaseMotor.destroy = BaseMotor.stop
BaseMotor.step = noop; BaseMotor.getValue = noop; BaseMotor.setGoal = noop
function BaseMotor:__tostring() return "Motor" end

local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor
function SingleMotor.new(init, useImpl)
	assert(init and typeof(init)=="number")
	local s = setmetatable(BaseMotor.new(), SingleMotor)
	s._useImplicitConnections = useImpl ~= nil and useImpl or true
	s._goal = nil
	s._state = { complete=true, value=init }
	return s
end
function SingleMotor:step(dt)
	if self._state.complete then return true end
	local ns = self._goal:step(self._state, dt)
	self._state = ns; self._onStep:fire(ns.value)
	if ns.complete then
		if self._useImplicitConnections then self:stop() end
		self._onComplete:fire()
	end
	return ns.complete
end
function SingleMotor:getValue() return self._state.value end
function SingleMotor:setGoal(g)
	self._state.complete = false; self._goal = g; self._onStart:fire()
	if self._useImplicitConnections then self:start() end
end
function SingleMotor:__tostring() return "Motor(Single)" end

local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor
local function toMotor(v)
	if isMotor(v) then return v end
	local vt = typeof(v)
	if vt == "number" then return SingleMotor.new(v, false)
	elseif vt == "table" then return GroupMotor.new(v, false) end
	error("Cannot convert to motor")
end
function GroupMotor.new(init, useImpl)
	local s = setmetatable(BaseMotor.new(), GroupMotor)
	s._useImplicitConnections = useImpl ~= nil and useImpl or true
	s._complete = true; s._motors = {}
	for k,v in pairs(init) do s._motors[k] = toMotor(v) end
	return s
end
function GroupMotor:step(dt)
	if self._complete then return true end
	local all = true
	for _,m in pairs(self._motors) do
		if not m:step(dt) then all = false end
	end
	self._onStep:fire(self:getValue())
	if all then
		if self._useImplicitConnections then self:stop() end
		self._complete = true; self._onComplete:fire()
	end
	return all
end
function GroupMotor:setGoal(goals)
	self._complete = false; self._onStart:fire()
	for k,g in pairs(goals) do
		local m = self._motors[k]
		assert(m); m:setGoal(g)
	end
	if self._useImplicitConnections then self:start() end
end
function GroupMotor:getValue()
	local v={}; for k,m in pairs(self._motors) do v[k]=m:getValue() end return v
end
function GroupMotor:__tostring() return "Motor(Group)" end

local Flipper = {
	SingleMotor=SingleMotor, GroupMotor=GroupMotor,
	Instant=Instant, Linear=Linear, Spring=Spring, isMotor=isMotor,
}

-- ============ CREATOR ============
local Creator = {
	Registry = {},
	Signals = {},
	TransparencyMotors = {},
	DefaultProperties = {
		ScreenGui = { ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling },
		Frame = { BackgroundColor3=Color3.fromRGB(5,5,5), BorderColor3=Color3.fromRGB(35,35,35), BorderSizePixel=0 },
		ScrollingFrame = { BackgroundColor3=Color3.fromRGB(5,5,5), BorderColor3=Color3.fromRGB(35,35,35),
			ScrollBarImageColor3=Color3.fromRGB(255,70,70), BorderSizePixel=0 },
		TextLabel = { BackgroundColor3=Color3.fromRGB(5,5,5), Font=Enum.Font.SourceSansSemibold,
			Text="", TextColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=1, TextSize=14 },
		TextButton = { BackgroundColor3=Color3.fromRGB(180,40,40), AutoButtonColor=false,
			Font=Enum.Font.SourceSansSemibold, Text="", TextColor3=Color3.fromRGB(255,255,255), TextSize=14 },
		TextBox = { BackgroundColor3=Color3.fromRGB(20,20,20), ClearTextOnFocus=false,
			Font=Enum.Font.SourceSansSemibold, Text="", TextColor3=Color3.fromRGB(255,255,255), TextSize=14 },
		ImageLabel = { BackgroundTransparency=1, BackgroundColor3=Color3.fromRGB(5,5,5),
			BorderColor3=Color3.fromRGB(35,35,35), BorderSizePixel=0 },
		ImageButton = { BackgroundColor3=Color3.fromRGB(180,40,40), AutoButtonColor=false },
		CanvasGroup = { BackgroundColor3=Color3.fromRGB(5,5,5), BorderSizePixel=0 },
	},
}

local function ApplyCustomProps(obj, props)
	if props.ThemeTag then Creator.AddThemeObject(obj, props.ThemeTag) end
end

function Creator.AddSignal(sig, fn)
	local c = sig:Connect(fn)
	table.insert(Creator.Signals, c)
	return c
end
function Creator.Disconnect()
	for i=#Creator.Signals, 1, -1 do
		local c = table.remove(Creator.Signals, i)
		if c.Disconnect then c:Disconnect() end
	end
end
function Creator.UpdateTheme()
	for inst, obj in next, Creator.Registry do
		for prop, colorIdx in next, obj.Properties do
			inst[prop] = Creator.GetThemeProperty(colorIdx)
		end
	end
	for _, m in next, Creator.TransparencyMotors do
		m:setGoal(Flipper.Instant.new(Creator.GetThemeProperty("ElementTransparency")))
	end
end
function Creator.AddThemeObject(obj, props)
	Creator.Registry[obj] = { Object=obj, Properties=props, Idx=#Creator.Registry+1 }
	Creator.UpdateTheme()
	return obj
end
function Creator.OverrideTag(obj, props)
	if Creator.Registry[obj] then Creator.Registry[obj].Properties = props end
end
function Creator.GetThemeProperty(prop)
	if Themes[Library.Theme] and Themes[Library.Theme][prop] then
		return Themes[Library.Theme][prop]
	end
	return Themes["CyrusHubX"][prop]
end
function Creator.New(name, props, children)
	local obj = Instance.new(name)
	for n,v in next, Creator.DefaultProperties[name] or {} do obj[n]=v end
	for n,v in next, props or {} do if n~="ThemeTag" then obj[n]=v end end
	for _, c in next, children or {} do c.Parent = obj end
	ApplyCustomProps(obj, props or {})
	return obj
end
function Creator.SpringMotor(init, inst, prop, ignoreDialog, resetOnTheme)
	local m = Flipper.SingleMotor.new(init)
	m:onStep(function(v) inst[prop]=v end)
	if resetOnTheme then table.insert(Creator.TransparencyMotors, m) end
	local function Set(val, ignore)
		if not ignoreDialog and not ignore and prop=="BackgroundTransparency" and Library.DialogOpen then return end
		m:setGoal(Flipper.Spring.new(val, { frequency=9 }))
	end
	return m, Set
end

Library.Creator = Creator
local New = Creator.New

local GUI = New("ScreenGui", {
	Name = "Cyrus_Hub_X_ScreenGui",
	Parent = RunService:IsStudio() and LocalPlayer.PlayerGui
		or (gethui and gethui() or (cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui"))),
})
Library.GUI = GUI
ProtectGui(GUI)

-- ============ LIBRARY UTILITIES ============
function Library:SafeCallback(fn, ...)
	if not fn then return end
	local ok, err = pcall(fn, ...)
	if not ok then
		local _, i = err:find(":%d+: ")
		self:Notify({ Title="Interface", Content="Callback error",
			SubContent = i and err:sub(i+1) or err, Duration=5 })
	end
end
function Library:Round(n, f)
	if f == 0 then return math.floor(n) end
	n = tostring(n)
	return n:find("%.") and tonumber(n:sub(1, n:find("%.") + f)) or n
end

local function map(v, inMin, inMax, outMin, outMax)
	return (v-inMin)*(outMax-outMin)/(inMax-inMin)+outMin
end
local function viewportPointToWorld(loc, dist)
	local r = workspace.CurrentCamera:ScreenPointToRay(loc.X, loc.Y)
	return r.Origin + r.Direction * dist
end
local function getOffset()
	return map(workspace.CurrentCamera.ViewportSize.Y, 0, 2560, 8, 56)
end

-- ============ ACRYLIC ============
local BlurFolder = Instance.new("Folder", workspace.CurrentCamera)
local function createAcrylic()
	return Creator.New("Part", {
		Name="Body", Color=Color3.new(0,0,0), Material=Enum.Material.Glass,
		Size=Vector3.new(1,1,0), Anchored=true, CanCollide=false,
		Locked=true, CastShadow=false, Transparency=0.98,
	}, {
		Creator.New("SpecialMesh", { MeshType=Enum.MeshType.Brick, Offset=Vector3.new(0,0,-0.000001) }),
	})
end

function AcrylicBlur()
	local function createAcrylicBlur(dist)
		local cleanups = {}
		dist = dist or 0.001
		local pos = { topLeft=Vector2.new(), topRight=Vector2.new(), bottomRight=Vector2.new() }
		local model = createAcrylic()
		model.Parent = BlurFolder
		local function updPos(sz, p)
			pos.topLeft=p; pos.topRight=p+Vector2.new(sz.X,0); pos.bottomRight=p+sz
		end
		local function render()
			local cam = workspace.CurrentCamera
			if not cam then return end
			local cf = cam.CFrame
			local tl3 = viewportPointToWorld(pos.topLeft, dist)
			local tr3 = viewportPointToWorld(pos.topRight, dist)
			local br3 = viewportPointToWorld(pos.bottomRight, dist)
			local w = (tr3-tl3).Magnitude
			local h = (tr3-br3).Magnitude
			model.CFrame = CFrame.fromMatrix((tl3+br3)/2, cf.XVector, cf.YVector, cf.ZVector)
			model.Mesh.Scale = Vector3.new(w, h, 0)
		end
		local function onChange(rbx)
			local off = getOffset()
			local sz = rbx.AbsoluteSize - Vector2.new(off, off)
			local p = rbx.AbsolutePosition + Vector2.new(off/2, off/2)
			updPos(sz, p); task.spawn(render)
		end
		local function renderOnChange()
			local cam = workspace.CurrentCamera
			if not cam then return end
			table.insert(cleanups, cam:GetPropertyChangedSignal("CFrame"):Connect(render))
			table.insert(cleanups, cam:GetPropertyChangedSignal("ViewportSize"):Connect(render))
			table.insert(cleanups, cam:GetPropertyChangedSignal("FieldOfView"):Connect(render))
			task.spawn(render)
		end
		model.Destroying:Connect(function()
			for _,c in cleanups do pcall(function() c:Disconnect() end) end
		end)
		renderOnChange()
		return onChange, model
	end
	return function(dist)
		local Blur = {}
		local onChange, model = createAcrylicBlur(dist)
		local comp = Creator.New("Frame", { BackgroundTransparency=1, Size=UDim2.fromScale(1,1) })
		Creator.AddSignal(comp:GetPropertyChangedSignal("AbsolutePosition"), function() onChange(comp) end)
		Creator.AddSignal(comp:GetPropertyChangedSignal("AbsoluteSize"), function() onChange(comp) end)
		Blur.AddParent = function(p)
			Creator.AddSignal(p:GetPropertyChangedSignal("Visible"), function() Blur.SetVisibility(p.Visible) end)
		end
		Blur.SetVisibility = function(v) model.Transparency = v and 0.98 or 1 end
		Blur.Frame = comp; Blur.Model = model
		return Blur
	end
end

function AcrylicPaint()
	local AcrylicBlur = AcrylicBlur()
	return function(props)
		local AP = {}
		AP.Frame = New("Frame", {
			Size=UDim2.fromScale(1,1), BackgroundTransparency=0.9,
			BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0,
		}, {
			New("ImageLabel", {
				Image="rbxassetid://8992230677", ScaleType="Slice",
				SliceCenter=Rect.new(Vector2.new(99,99),Vector2.new(99,99)),
				AnchorPoint=Vector2.new(0.5,0.5),
				Size=UDim2.new(1,120,1,116), Position=UDim2.new(0.5,0,0.5,0),
				BackgroundTransparency=1, ImageColor3=Color3.fromRGB(0,0,0), ImageTransparency=0.7,
			}),
			New("UICorner", { CornerRadius=UDim.new(0,8) }),
			New("Frame", {
				BackgroundTransparency=0.45, Size=UDim2.fromScale(1,1), Name="Background",
				ThemeTag={ BackgroundColor3="AcrylicMain" },
			}, { New("UICorner",{CornerRadius=UDim.new(0,8)}) }),
			New("Frame", {
				BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=0.4,
				Size=UDim2.fromScale(1,1),
			}, {
				New("UICorner",{CornerRadius=UDim.new(0,8)}),
				New("UIGradient",{ Rotation=90, ThemeTag={Color="AcrylicGradient"} }),
			}),
			New("ImageLabel", {
				Image="rbxassetid://9968344105", ImageTransparency=0.98,
				ScaleType=Enum.ScaleType.Tile, TileSize=UDim2.new(0,128,0,128),
				Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
			},{ New("UICorner",{CornerRadius=UDim.new(0,8)}) }),
			New("ImageLabel", {
				Image="rbxassetid://9968344227", ImageTransparency=0.9,
				ScaleType=Enum.ScaleType.Tile, TileSize=UDim2.new(0,128,0,128),
				Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
				ThemeTag={ ImageTransparency="AcrylicNoise" },
			},{ New("UICorner",{CornerRadius=UDim.new(0,8)}) }),
			New("Frame", {
				BackgroundTransparency=1, Size=UDim2.fromScale(1,1), ZIndex=2,
			},{
				New("UICorner",{CornerRadius=UDim.new(0,8)}),
				New("UIStroke",{
					Transparency=0.5, Thickness=1, ThemeTag={Color="AcrylicBorder"},
				}),
			}),
		})
		local Blur
		if Library.UseAcrylic then
			Blur = AcrylicBlur()
			Blur.Frame.Parent = AP.Frame
			AP.Model = Blur.Model
			AP.AddParent = Blur.AddParent
			AP.SetVisibility = Blur.SetVisibility
		end
		return AP
	end
end

local Acrylic = {
	AcrylicBlur = AcrylicBlur(),
	CreateAcrylic = createAcrylic,
	AcrylicPaint = AcrylicPaint(),
}
function Acrylic.init()
	local baseEffect = Instance.new("DepthOfFieldEffect")
	baseEffect.FarIntensity=0; baseEffect.InFocusRadius=0.1; baseEffect.NearIntensity=1
	local defaults = {}
	function Acrylic.Enable()
		for _,e in pairs(defaults) do e.Enabled=false end
		baseEffect.Parent = game:GetService("Lighting")
	end
	function Acrylic.Disable()
		for e,d in pairs(defaults) do e.Enabled=d.enabled end
		baseEffect.Parent = nil
	end
	local function reg(obj)
		if obj:IsA("DepthOfFieldEffect") then defaults[obj]={enabled=obj.Enabled} end
	end
	for _,c in pairs(game:GetService("Lighting"):GetChildren()) do reg(c) end
	if workspace.CurrentCamera then
		for _,c in pairs(workspace.CurrentCamera:GetChildren()) do reg(c) end
	end
	Acrylic.Enable()
end

-- ============ COMPONENTS ============
local Components = {
	Assets = {
		Close = "rbxassetid://9886659671",
		Min   = "rbxassetid://9886659276",
		Max   = "rbxassetid://9886659406",
		Restore = "rbxassetid://9886659001",
	},
}

-- ===== ELEMENT COMPONENT =====
Components.Element = (function()
	local Spr = Flipper.Spring.new
	return function(Title, Desc, Parent, Hover, Options)
		local El = {}
		Options = Options or {}
		El.TitleLabel = New("TextLabel", {
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			Text=Title, TextColor3=Color3.fromRGB(240,240,240), TextSize=13,
			TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1,0,0,14),
			BackgroundTransparency=1, ThemeTag={TextColor3="Text"},
		})
		El.DescLabel = New("TextLabel", {
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text=Desc, TextColor3=Color3.fromRGB(200,200,200), TextSize=12,
			TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left,
			BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y,
			Size=UDim2.new(1,0,0,14), ThemeTag={TextColor3="SubText"},
		})
		El.LabelHolder = New("Frame", {
			AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1,
			Position=UDim2.fromOffset(10,0), Size=UDim2.new(1,-28,0,0),
		},{
			New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder, VerticalAlignment=Enum.VerticalAlignment.Center}),
			New("UIPadding",{PaddingBottom=UDim.new(0,13), PaddingTop=UDim.new(0,13)}),
			El.TitleLabel, El.DescLabel,
		})
		El.Border = New("UIStroke",{
			Transparency=0.5, ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
			ThemeTag={Color="ElementBorder"},
		})
		El.Frame = New("TextButton",{
			Visible=Options.Visible ~= false, Size=UDim2.new(1,0,0,0),
			BackgroundTransparency=0.89, BackgroundColor3=Color3.fromRGB(130,130,130),
			Parent=Parent, AutomaticSize=Enum.AutomaticSize.Y, Text="", LayoutOrder=7,
			ThemeTag={BackgroundColor3="Element", BackgroundTransparency="ElementTransparency"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,6)}),
			El.Border, El.LabelHolder,
		})
		function El:SetTitle(s) El.TitleLabel.Text=s end
		function El:Visible(b) El.Frame.Visible=b end
		function El:SetDesc(s)
			s=s or ""
			El.DescLabel.Visible = s~=""
			El.DescLabel.Text = s
		end
		function El:GetTitle() return El.TitleLabel.Text end
		function El:GetDesc() return El.DescLabel.Text end
		function El:Destroy() El.Frame:Destroy() end
		El:SetTitle(Title); El:SetDesc(Desc)
		if Hover then
			local _, SetT = Creator.SpringMotor(
				Creator.GetThemeProperty("ElementTransparency"), El.Frame, "BackgroundTransparency", false, true)
			Creator.AddSignal(El.Frame.MouseEnter, function()
				SetT(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
			end)
			Creator.AddSignal(El.Frame.MouseLeave, function()
				SetT(Creator.GetThemeProperty("ElementTransparency"))
			end)
			Creator.AddSignal(El.Frame.MouseButton1Down, function()
				SetT(Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange"))
			end)
			Creator.AddSignal(El.Frame.MouseButton1Up, function()
				SetT(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
			end)
		end
		return El
	end
end)()

-- ===== SECTION COMPONENT (UPGRADED) =====
Components.Section = (function()
	local Spr = Flipper.Spring.new
	return function(Title, Parent, defaultOpen)
		local S = {}
		S.IsOpen = defaultOpen ~= false

		-- Animated arrow
		S.Arrow = New("TextButton", {
			Text = S.IsOpen and "▼" or "▶",
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			TextSize = 11, TextColor3 = Color3.fromRGB(200,200,200),
			BackgroundTransparency = 1, Size = UDim2.new(0,22,0,22),
			Position = UDim2.new(1,-10,0,4), AnchorPoint = Vector2.new(1,0),
			TextXAlignment = Enum.TextXAlignment.Center, AutoButtonColor = false,
			ThemeTag = { TextColor3 = "Text" },
		})

		S.Layout = New("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder })

		S.Container = New("Frame", {
			Size = UDim2.new(1,-16,0,0), Position = UDim2.fromOffset(8,34),
			BackgroundTransparency = 1, ClipsDescendants = true,
		},{ S.Layout })

		-- Modern header with gradient accent
		S.HeaderAccent = New("Frame", {
			Size = UDim2.new(0,3,1,-8), Position = UDim2.fromOffset(0,4),
			BorderSizePixel = 0, ThemeTag = { BackgroundColor3 = "SectionHeader" },
		},{ New("UICorner",{CornerRadius=UDim.new(0,2)}) })

		S.Background = New("Frame", {
			Size = UDim2.fromScale(1,1), BackgroundTransparency = 0.93,
			ThemeTag = { BackgroundColor3 = "Element" },
		},{
			New("UICorner",{CornerRadius=UDim.new(0,10)}),
		})

		S.OuterStroke = New("UIStroke", {
			Thickness = 1.5, Transparency = 0.75, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = { Color = "ElementBorder" },
		})

		S.TitleLine = New("Frame", {
			Size = UDim2.new(1,-20,0,1), Position = UDim2.fromOffset(10,29),
			BackgroundTransparency = 0.5, ThemeTag = { BackgroundColor3 = "ElementBorder" },
		})

		S.TitleButton = New("TextButton", {
			Text = Title,
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
			TextSize = 14, TextXAlignment = "Left", TextYAlignment = "Center",
			Size = UDim2.new(1,-40,0,22), Position = UDim2.fromOffset(14,5),
			BackgroundTransparency = 1, AutoButtonColor = false,
			ThemeTag = { TextColor3 = "Text" },
		})

		S.Root = New("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1,0,0,32),
			LayoutOrder = 7, Parent = Parent,
		},{
			S.Background, S.OuterStroke, S.HeaderAccent,
			S.TitleButton, S.Arrow, S.TitleLine, S.Container,
		})

		local SizeM = Flipper.SingleMotor.new(0)
		local RootHM = Flipper.SingleMotor.new(32)
		local LineM  = Flipper.SingleMotor.new(0.5)

		SizeM:onStep(function(v) S.Container.Size = UDim2.new(1,-16,0,v) end)
		RootHM:onStep(function(v) S.Root.Size = UDim2.new(1,0,0,v) end)
		LineM:onStep(function(v) S.TitleLine.BackgroundTransparency = v end)

		local function updateSize()
			if S.IsOpen then
				local ch = S.Layout.AbsoluteContentSize.Y
				if ch > 0 then
					SizeM:setGoal(Spr(ch,{frequency=8,dampingRatio=0.82}))
					RootHM:setGoal(Spr(ch+42,{frequency=8,dampingRatio=0.82}))
					LineM:setGoal(Spr(0.5,{frequency=7}))
					S.Container.Visible = true
				end
			else
				SizeM:setGoal(Spr(0,{frequency=8,dampingRatio=0.82}))
				RootHM:setGoal(Spr(32,{frequency=8,dampingRatio=0.82}))
				LineM:setGoal(Spr(1,{frequency=7}))
				task.delay(0.25, function() if not S.IsOpen then S.Container.Visible=false end end)
			end
		end

		function S:Toggle()
			S.IsOpen = not S.IsOpen
			S.Arrow.Text = S.IsOpen and "▼" or "▶"
			updateSize()
		end

		Creator.AddSignal(S.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			if S.IsOpen then updateSize() end
		end)
		Creator.AddSignal(S.Arrow.MouseButton1Click, function() S:Toggle() end)
		Creator.AddSignal(S.TitleButton.MouseButton1Click, function() S:Toggle() end)

		-- Hover
		local _, setBtnT = Creator.SpringMotor(0, S.Arrow, "TextTransparency")
		Creator.AddSignal(S.Arrow.MouseEnter, function() setBtnT(0.4) end)
		Creator.AddSignal(S.Arrow.MouseLeave, function() setBtnT(0) end)
		local _, setTitleT = Creator.SpringMotor(0, S.TitleButton, "TextTransparency")
		Creator.AddSignal(S.TitleButton.MouseEnter, function() setTitleT(0.3) end)
		Creator.AddSignal(S.TitleButton.MouseLeave, function() setTitleT(0) end)

		task.spawn(function()
			task.wait(0.15)
			local ch = S.Layout.AbsoluteContentSize.Y
			if ch > 0 and S.IsOpen then
				S.Container.Visible = true
				SizeM:setGoal(Flipper.Instant.new(ch))
				RootHM:setGoal(Flipper.Instant.new(ch+42))
				S.Container.Size = UDim2.new(1,-16,0,ch)
				S.Root.Size = UDim2.new(1,0,0,ch+42)
			elseif not S.IsOpen then
				S.Container.Visible = false
			end
		end)

		function S:SetTitle(t) S.TitleButton.Text = t end
		function S:SetVisible(v) S.Root.Visible = v end
		function S:Destroy() S.Root:Destroy() end
		return S
	end
end)()

-- ===== BOX COMPONENT (NEW) =====
-- A styled container box that groups elements visually
Components.Box = (function()
	local Spr = Flipper.Spring.new
	return function(Title, Icon, Parent, defaultOpen)
		local B = {}
		B.IsOpen = defaultOpen ~= false

		-- Glow top line
		B.TopGlow = New("Frame", {
			Size = UDim2.new(1,0,0,2), Position = UDim2.fromOffset(0,0),
			BorderSizePixel = 0, ThemeTag = { BackgroundColor3 = "Accent" },
		},{ New("UICorner",{CornerRadius=UDim.new(0,2)}) })

		-- Icon (optional)
		local iconOffset = 10
		if Icon then
			B.IconLabel = New("ImageLabel", {
				Size = UDim2.fromOffset(18,18), Position = UDim2.fromOffset(12,11),
				BackgroundTransparency = 1, Image = Icon,
				ThemeTag = { ImageColor3 = "Accent" },
			})
			iconOffset = 36
		end

		B.TitleLabel = New("TextLabel", {
			Text = Title or "Box",
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
			TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(iconOffset, 7),
			Size = UDim2.new(1,-iconOffset-35,0,18),
			ThemeTag = { TextColor3 = "Text" },
		})

		B.CountLabel = New("TextLabel", {
			Text = "0 items", FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, TextTransparency = 0.5,
			BackgroundTransparency = 1, Position = UDim2.new(1,-36,0,8),
			Size = UDim2.new(0,60,0,16),
			ThemeTag = { TextColor3 = "SubText" },
		})

		B.Arrow = New("ImageLabel", {
			Size = UDim2.fromOffset(14,14), Position = UDim2.new(1,-12,0.5,0),
			AnchorPoint = Vector2.new(1,0.5), BackgroundTransparency = 1,
			Image = "rbxassetid://10709790948",
			Rotation = B.IsOpen and 180 or 0,
			ThemeTag = { ImageColor3 = "Accent" },
		})

		B.Header = New("TextButton", {
			Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1,
			Text = "", AutoButtonColor = false,
		})

		B.Divider = New("Frame", {
			Size = UDim2.new(1,-20,0,1), Position = UDim2.fromOffset(10,36),
			BackgroundTransparency = 0.6, ThemeTag = { BackgroundColor3 = "BoxBorder" },
		})

		B.Layout = New("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder })
		B.Padding = New("UIPadding", { PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4),
			PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,8) })

		B.Container = New("Frame", {
			Size = UDim2.new(1,-12,0,0), Position = UDim2.fromOffset(6,40),
			BackgroundTransparency = 1, ClipsDescendants = true,
		},{ B.Layout, B.Padding })

		-- Main frame
		B.Background = New("Frame", {
			Size = UDim2.fromScale(1,1), BackgroundTransparency = 0.88,
			ThemeTag = { BackgroundColor3 = "BoxBackground" },
		},{ New("UICorner",{CornerRadius=UDim.new(0,10)}) })

		B.Stroke = New("UIStroke", {
			Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Transparency = 0.55,
			ThemeTag = { Color = "BoxBorder" },
		})

		local headerChildren = { B.TitleLabel, B.Arrow, B.CountLabel }
		if B.IconLabel then table.insert(headerChildren, B.IconLabel) end

		B.Root = New("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1,0,0,40),
			LayoutOrder = 7, Parent = Parent,
		},{
			B.Background, B.Stroke, B.TopGlow,
			B.Header, B.Divider, B.Container,
			table.unpack(headerChildren),
		})

		local HeightM   = Flipper.SingleMotor.new(40)
		local RotationM = Flipper.SingleMotor.new(B.IsOpen and 180 or 0)
		local DividerM  = Flipper.SingleMotor.new(B.IsOpen and 0.6 or 1)

		HeightM:onStep(function(v) B.Root.Size = UDim2.new(1,0,0,v) end)
		RotationM:onStep(function(v) B.Arrow.Rotation = v end)
		DividerM:onStep(function(v) B.Divider.BackgroundTransparency = v end)

		local itemCount = 0
		local function updateCount()
			B.CountLabel.Text = itemCount .. (itemCount==1 and " item" or " items")
		end

		local function updateSize()
			if B.IsOpen then
				local ch = B.Layout.AbsoluteContentSize.Y
				local totalH = ch + 52
				HeightM:setGoal(Spr(totalH,{frequency=9,dampingRatio=0.82}))
				DividerM:setGoal(Spr(0.6,{frequency=8}))
				B.Container.Visible = true
			else
				HeightM:setGoal(Spr(40,{frequency=9,dampingRatio=0.82}))
				DividerM:setGoal(Spr(1,{frequency=8}))
				task.delay(0.25, function() if not B.IsOpen then B.Container.Visible=false end end)
			end
			RotationM:setGoal(Spr(B.IsOpen and 180 or 0, {frequency=8}))
		end

		function B:Toggle()
			B.IsOpen = not B.IsOpen
			updateSize()
		end

		Creator.AddSignal(B.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			if B.IsOpen then updateSize() end
		end)
		Creator.AddSignal(B.Header.MouseButton1Click, function() B:Toggle() end)

		-- Hover on header
		local _, setHoverT = Creator.SpringMotor(0.88, B.Background, "BackgroundTransparency")
		Creator.AddSignal(B.Header.MouseEnter, function() setHoverT(0.82) end)
		Creator.AddSignal(B.Header.MouseLeave, function() setHoverT(0.88) end)
		Creator.AddSignal(B.Header.MouseButton1Down, function() setHoverT(0.8) end)
		Creator.AddSignal(B.Header.MouseButton1Up, function() setHoverT(0.82) end)

		task.spawn(function()
			task.wait(0.15)
			local ch = B.Layout.AbsoluteContentSize.Y
			if B.IsOpen and ch > 0 then
				B.Container.Visible = true
				HeightM:setGoal(Flipper.Instant.new(ch+52))
				B.Root.Size = UDim2.new(1,0,0,ch+52)
				B.Container.Size = UDim2.new(1,-12,0,ch)
			elseif not B.IsOpen then
				B.Container.Visible = false
			end
		end)

		-- Public
		function B:SetTitle(t) B.TitleLabel.Text = t end
		function B:SetOpen(state) if B.IsOpen~=state then B:Toggle() end end
		function B:IsOpenState() return B.IsOpen end
		function B:AddItem()
			itemCount = itemCount + 1
			updateCount()
		end
		function B:SetVisible(v) B.Root.Visible = v end
		function B:Destroy() B.Root:Destroy() end

		return B
	end
end)()

-- ===== TAB COMPONENT =====
Components.Tab = (function()
	local Spr = Flipper.Spring.new
	local Inst = Flipper.Instant.new

	local TabModule = {
		Window=nil, Tabs={}, Containers={}, SelectedTab=0, TabCount=0,
	}
	function TabModule:Init(w) TabModule.Window=w; return TabModule end
	function TabModule:GetCurrentTabPos()
		local hp = TabModule.Window.TabHolder.AbsolutePosition.Y
		local tp = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y
		return tp - hp
	end
	function TabModule:New(Title, Icon, Parent)
		local W = TabModule.Window
		local Elements = Library.Elements
		TabModule.TabCount = TabModule.TabCount + 1
		local idx = TabModule.TabCount
		local Tab = { Selected=false, Name=Title, Type="Tab" }
		if Library:GetIcon(Icon) then Icon=Library:GetIcon(Icon) end
		if Icon=="" or Icon==nil then Icon=nil end

		Tab.Frame = New("TextButton", {
			Size=UDim2.new(1,0,0,34), BackgroundTransparency=1, Parent=Parent,
			ThemeTag={BackgroundColor3="Tab"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,6)}),
			New("TextLabel",{
				AnchorPoint=Vector2.new(0,0.5),
				Position=Icon and UDim2.new(0,30,0.5,0) or UDim2.new(0,12,0.5,0),
				Text=Title, RichText=true, TextColor3=Color3.fromRGB(255,255,255),
				TextTransparency=0,
				FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Regular),
				TextSize=12, TextXAlignment="Left", TextYAlignment="Center",
				Size=UDim2.new(1,-12,1,0), BackgroundTransparency=1,
				ThemeTag={TextColor3="Text"},
			}),
			New("ImageLabel",{
				AnchorPoint=Vector2.new(0,0.5), Size=UDim2.fromOffset(16,16),
				Position=UDim2.new(0,8,0.5,0), BackgroundTransparency=1,
				Image=Icon or "", ThemeTag={ImageColor3="Text"},
			}),
		})

		local ContainerLayout = New("UIListLayout",{Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})

		Tab.ContainerFrame = New("Frame",{
			Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Parent=W.ContainerHolder,
			Visible=false, ClipsDescendants=true,
		})
		Tab.InnerFrame = New("Frame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Parent=Tab.ContainerFrame})
		Tab.ScrollFrame = New("ScrollingFrame",{
			Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
			BottomImage="rbxassetid://6889812791", MidImage="rbxassetid://6889812721",
			TopImage="rbxassetid://6276641225",
			ScrollBarImageColor3=Color3.fromRGB(255,255,255), ScrollBarImageTransparency=0.95,
			ScrollBarThickness=3, BorderSizePixel=0, CanvasSize=UDim2.fromScale(0,0),
			ScrollingDirection=Enum.ScrollingDirection.Y, Parent=Tab.InnerFrame,
		},{
			ContainerLayout,
			New("UIPadding",{PaddingRight=UDim.new(0,10), PaddingLeft=UDim.new(0,1),
				PaddingTop=UDim.new(0,1), PaddingBottom=UDim.new(0,1)}),
		})
		Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Tab.ScrollFrame.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y+2)
		end)

		Tab.TransitionMotor = Flipper.GroupMotor.new({PositionX=0, Opacity=1})
		Tab.TransitionMotor:onStep(function(v)
			Tab.InnerFrame.Position = UDim2.new(0,v.PositionX,0,0)
			Tab.InnerFrame.BackgroundTransparency = v.Opacity
		end)

		Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")
		Creator.AddSignal(Tab.Frame.MouseEnter, function() Tab.SetTransparency(Tab.Selected and 0.85 or 0.89) end)
		Creator.AddSignal(Tab.Frame.MouseLeave, function() Tab.SetTransparency(Tab.Selected and 0.89 or 1) end)
		Creator.AddSignal(Tab.Frame.MouseButton1Down, function() Tab.SetTransparency(0.92) end)
		Creator.AddSignal(Tab.Frame.MouseButton1Up, function() Tab.SetTransparency(Tab.Selected and 0.85 or 0.89) end)
		Creator.AddSignal(Tab.Frame.MouseButton1Click, function() TabModule:SelectTab(idx) end)

		TabModule.Containers[idx] = Tab.ContainerFrame
		TabModule.Tabs[idx] = Tab
		Tab.Container = Tab.ScrollFrame

		function Tab:AddSection(SectionTitle, defaultOpen)
			local Section = { Type="Section" }
			local SF = Components.Section(SectionTitle, Tab.Container, defaultOpen)
			Section.Container = SF.Container
			Section.ScrollFrame = Tab.Container
			Section._SectionFrame = SF
			setmetatable(Section, Elements)
			return Section
		end

		function Tab:AddBox(BoxTitle, BoxIcon, defaultOpen)
			local Box = { Type="Box" }
			local BF = Components.Box(BoxTitle, BoxIcon, Tab.Container, defaultOpen)
			Box.Container = BF.Container
			Box.ScrollFrame = Tab.Container
			Box._BoxFrame = BF
			setmetatable(Box, Elements)
			return Box
		end

		setmetatable(Tab, Elements)
		return Tab
	end
	function TabModule:SelectTab(tabIdx)
		local W = TabModule.Window
		local cur = TabModule.Tabs[TabModule.SelectedTab]
		if cur and cur.InnerFrame then
			cur.TransitionMotor:setGoal({
				PositionX=Spr(-30,{frequency=8,dampingRatio=0.8}),
				Opacity=Spr(1,{frequency=10}),
			})
			task.delay(0.15, function() if cur.ContainerFrame then cur.ContainerFrame.Visible=false end end)
		end
		TabModule.SelectedTab = tabIdx
		for _,t in next,TabModule.Tabs do t.SetTransparency(1); t.Selected=false end
		local nt = TabModule.Tabs[tabIdx]
		nt.SetTransparency(0.89); nt.Selected=true
		W.TabDisplay.Text = nt.Name
		W.SelectorPosMotor:setGoal(Spr(TabModule:GetCurrentTabPos(),{frequency=6}))
		nt.ContainerFrame.Visible=true
		nt.TransitionMotor:setGoal({ PositionX=Inst(30), Opacity=Inst(1) })
		task.wait(0.05)
		nt.TransitionMotor:setGoal({
			PositionX=Spr(0,{frequency=10,dampingRatio=0.7}),
			Opacity=Spr(0,{frequency=12}),
		})
		W.ContainerHolder.Parent = W.ContainerAnim
		W.ContainerPosMotor:setGoal(Spr(15,{frequency=10}))
		W.ContainerBackMotor:setGoal(Spr(1,{frequency=10}))
		task.wait(0.12)
		W.ContainerPosMotor:setGoal(Spr(0,{frequency=5}))
		W.ContainerBackMotor:setGoal(Spr(0,{frequency=8}))
		task.wait(0.12)
		W.ContainerHolder.Parent = W.ContainerCanvas
	end
	return TabModule
end)()

-- ===== BUTTON DIALOG COMPONENT =====
Components.Button = (function()
	return function(theme, Parent, DialogCheck)
		DialogCheck = DialogCheck or false
		local B = {}
		B.Title = New("TextLabel",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			TextColor3=Color3.fromRGB(200,200,200), TextSize=14, TextWrapped=true,
			TextXAlignment=Enum.TextXAlignment.Center, TextYAlignment=Enum.TextYAlignment.Center,
			BackgroundTransparency=1, Size=UDim2.fromScale(1,1), ThemeTag={TextColor3="Text"},
		})
		B.HoverFrame = New("Frame",{
			Size=UDim2.fromScale(1,1), BackgroundTransparency=1, ThemeTag={BackgroundColor3="Hover"},
		},{ New("UICorner",{CornerRadius=UDim.new(0,6)}) })
		B.Frame = New("TextButton",{
			Size=UDim2.new(0,0,0,32), Parent=Parent, ThemeTag={BackgroundColor3="DialogButton"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,6)}),
			New("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Transparency=0.65,
				ThemeTag={Color="DialogButtonBorder"}}),
			B.HoverFrame, B.Title,
		})
		local _, SetT = Creator.SpringMotor(1, B.HoverFrame, "BackgroundTransparency", DialogCheck)
		Creator.AddSignal(B.Frame.MouseEnter, function() SetT(0.97) end)
		Creator.AddSignal(B.Frame.MouseLeave, function() SetT(1) end)
		Creator.AddSignal(B.Frame.MouseButton1Down, function() SetT(1) end)
		Creator.AddSignal(B.Frame.MouseButton1Up, function() SetT(0.97) end)
		return B
	end
end)()

-- ===== DIALOG COMPONENT =====
Components.Dialog = (function()
	local Spr = Flipper.Spring.new
	local Inst = Flipper.Instant.new
	local Dialog = { Window=nil }
	function Dialog:Init(w) Dialog.Window=w; return Dialog end
	function Dialog:Create()
		local ND = { Buttons=0 }
		ND.TintFrame = New("TextButton",{
			Text="", Size=UDim2.fromScale(1,1),
			BackgroundColor3=Color3.fromRGB(0,0,0), BackgroundTransparency=1,
			Parent=Dialog.Window.Root,
		},{ New("UICorner",{CornerRadius=UDim.new(0,8)}) })
		local _, TintT = Creator.SpringMotor(1, ND.TintFrame, "BackgroundTransparency", true)
		ND.ButtonHolder = New("Frame",{
			Size=UDim2.new(1,-40,1,-40), AnchorPoint=Vector2.new(0.5,0.5),
			Position=UDim2.fromScale(0.5,0.5), BackgroundTransparency=1,
		},{
			New("UIListLayout",{Padding=UDim.new(0,10), FillDirection=Enum.FillDirection.Horizontal,
				HorizontalAlignment=Enum.HorizontalAlignment.Center, SortOrder=Enum.SortOrder.LayoutOrder}),
		})
		ND.ButtonHolderFrame = New("Frame",{
			Size=UDim2.new(1,0,0,70), Position=UDim2.new(0,0,1,-70),
			ThemeTag={BackgroundColor3="DialogHolder"},
		},{
			New("Frame",{Size=UDim2.new(1,0,0,1), ThemeTag={BackgroundColor3="DialogHolderLine"}}),
			ND.ButtonHolder,
		})
		ND.Title = New("TextLabel",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.SemiBold),
			Text="Dialog", TextColor3=Color3.fromRGB(240,240,240), TextSize=22,
			TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1,0,0,22),
			Position=UDim2.fromOffset(20,25), BackgroundTransparency=1, ThemeTag={TextColor3="Text"},
		})
		ND.Scale = New("UIScale",{Scale=1})
		local _, Scale = Creator.SpringMotor(1.1, ND.Scale, "Scale")
		ND.Root = New("CanvasGroup",{
			Size=UDim2.fromOffset(300,165), AnchorPoint=Vector2.new(0.5,0.5),
			Position=UDim2.fromScale(0.5,0.5), GroupTransparency=1, Parent=ND.TintFrame,
			ThemeTag={BackgroundColor3="Dialog"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,10)}),
			New("UIStroke",{Transparency=0.5, ThemeTag={Color="DialogBorder"}}),
			ND.Scale, ND.Title, ND.ButtonHolderFrame,
		})
		local _, RootT = Creator.SpringMotor(1, ND.Root, "GroupTransparency")
		function ND:Open()
			Library.DialogOpen=true; ND.Scale.Scale=1.1
			TintT(0.72); RootT(0); Scale(1)
		end
		function ND:Close()
			Library.DialogOpen=false; TintT(1); RootT(1); Scale(1.1)
			pcall(function() ND.Root.UIStroke:Destroy() end)
			task.wait(0.15); ND.TintFrame:Destroy()
		end
		function ND:Button(Title, Callback)
			ND.Buttons = ND.Buttons+1; Title=Title or "Button"; Callback=Callback or function() end
			local Btn = Components.Button("", ND.ButtonHolder, true)
			Btn.Title.Text = Title
			for _,b in next, ND.ButtonHolder:GetChildren() do
				if b:IsA("TextButton") then
					b.Size = UDim2.new(1/ND.Buttons, -(((ND.Buttons-1)*10)/ND.Buttons), 0, 32)
				end
			end
			Creator.AddSignal(Btn.Frame.MouseButton1Click, function()
				Library:SafeCallback(Callback)
				pcall(function() ND:Close() end)
			end)
			return Btn
		end
		return ND
	end
	return Dialog
end)()

-- ===== NOTIFICATION COMPONENT =====
Components.Notification = (function()
	local Spr = Flipper.Spring.new
	local Notif = {}
	function Notif:Init(g)
		Notif.Holder = New("Frame",{
			Position=UDim2.new(1,-20,1,-20), Size=UDim2.new(0,340,1,-20),
			AnchorPoint=Vector2.new(1,1), BackgroundTransparency=1, Parent=g,
		},{
			New("UIListLayout",{
				HorizontalAlignment=Enum.HorizontalAlignment.Center,
				SortOrder=Enum.SortOrder.LayoutOrder,
				VerticalAlignment=Enum.VerticalAlignment.Bottom,
				Padding=UDim.new(0,10),
			}),
		})
	end
	function Notif:New(Config)
		Config.Title    = Config.Title or "Notification"
		Config.Content  = Config.Content or ""
		Config.SubContent = Config.SubContent or ""
		Config.Duration = Config.Duration or nil
		local N = { Closed=false }
		N.AcrylicPaint = Acrylic.AcrylicPaint()

		N.Title = New("TextLabel",{
			Position=UDim2.fromOffset(44,14), Text=Config.Title, RichText=true,
			TextColor3=Color3.fromRGB(255,255,255),
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Bold),
			TextSize=14, TextXAlignment="Left", TextYAlignment="Center",
			Size=UDim2.new(1,-80,0,18), TextWrapped=true, BackgroundTransparency=1,
			ThemeTag={TextColor3="Text"},
		})
		N.TypeIcon = New("ImageLabel",{
			Size=UDim2.fromOffset(20,20), Position=UDim2.fromOffset(14,14),
			BackgroundTransparency=1, Image="rbxassetid://10709752035",
			ThemeTag={ImageColor3="Accent"},
		})
		N.ContentLabel = New("TextLabel",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text=Config.Content, TextColor3=Color3.fromRGB(230,230,230),
			TextSize=13, TextXAlignment=Enum.TextXAlignment.Left,
			AutomaticSize=Enum.AutomaticSize.Y, Size=UDim2.new(1,0,0,16),
			BackgroundTransparency=1, TextWrapped=true, RichText=true,
			ThemeTag={TextColor3="Text"},
		})
		N.SubContentLabel = New("TextLabel",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text=Config.SubContent, TextColor3=Color3.fromRGB(200,200,200),
			TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
			AutomaticSize=Enum.AutomaticSize.Y, Size=UDim2.new(1,0,0,14),
			BackgroundTransparency=1, TextWrapped=true,
			ThemeTag={TextColor3="SubText"},
		})
		N.LabelHolder = New("Frame",{
			AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1,
			Position=UDim2.fromOffset(14,40), Size=UDim2.new(1,-62,0,0),
		},{
			New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4)}),
			N.ContentLabel, N.SubContentLabel,
		})

		-- Progress bar for duration
		local showProgress = Config.Duration and Config.Duration > 0
		if showProgress then
			N.ProgressBG = New("Frame",{
				Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,1,-2),
				BackgroundTransparency=0.8, BackgroundColor3=Color3.fromRGB(60,60,60), BorderSizePixel=0,
			},{ New("UICorner",{CornerRadius=UDim.new(0,1)}) })
			N.ProgressFill = New("Frame",{
				Size=UDim2.new(1,0,1,0), BackgroundTransparency=0, BorderSizePixel=0,
				ThemeTag={BackgroundColor3="Accent"}, Parent=N.ProgressBG,
			},{ New("UICorner",{CornerRadius=UDim.new(0,1)}) })
		end

		N.CloseButton = New("ImageButton",{
			Position=UDim2.new(1,-14,0,14), Size=UDim2.fromOffset(20,20),
			AnchorPoint=Vector2.new(1,0), BackgroundTransparency=1,
			Image=Components.Assets.Close,
			ThemeTag={ImageColor3="Accent"},
		})
		N.AccentBar = New("Frame",{
			Size=UDim2.new(0,3,1,0), BackgroundColor3=Color3.fromRGB(255,70,70),
			BorderSizePixel=0, ThemeTag={BackgroundColor3="Accent"},
		},{ New("UICorner",{CornerRadius=UDim.new(0,2)}) })

		local rootChildren = {
			New("UICorner",{CornerRadius=UDim.new(0,10)}),
			New("UIStroke",{Thickness=1.2, ThemeTag={Color="AcrylicBorder"}, Transparency=0.4}),
			N.AcrylicPaint.Frame, N.AccentBar, N.Title, N.TypeIcon,
			N.CloseButton, N.LabelHolder,
		}
		if showProgress then table.insert(rootChildren, N.ProgressBG) end

		N.Root = New("Frame",{
			BackgroundTransparency=1, Size=UDim2.new(1,0,1,0),
			Position=UDim2.fromScale(1,0),
		}, rootChildren)

		N.Holder = New("Frame",{
			BackgroundTransparency=1, Size=UDim2.new(1,0,0,90),
			Parent=Notif.Holder,
		},{ N.Root })

		local RootMotor = Flipper.GroupMotor.new({Scale=1, Offset=80})
		RootMotor:onStep(function(v)
			N.Root.Position = UDim2.new(v.Scale, v.Offset, 0, 0)
		end)

		Creator.AddSignal(N.CloseButton.MouseButton1Click, function() N:Close() end)
		-- Hover close
		Creator.AddSignal(N.CloseButton.MouseEnter, function()
			TweenService:Create(N.CloseButton, TweenInfo.new(0.15), {ImageTransparency=0.3}):Play()
		end)
		Creator.AddSignal(N.CloseButton.MouseLeave, function()
			TweenService:Create(N.CloseButton, TweenInfo.new(0.15), {ImageTransparency=0}):Play()
		end)

		function N:Open()
			local ch = N.LabelHolder.AbsoluteSize.Y
			local total = 50 + math.max(ch, 20)
			N.Holder.Size = UDim2.new(1,0,0,total+10)
			RootMotor:setGoal({
				Scale=Spr(0,{frequency=6,dampingRatio=0.75}),
				Offset=Spr(0,{frequency=6,dampingRatio=0.75}),
			})
			if showProgress then
				TweenService:Create(N.ProgressFill, TweenInfo.new(Config.Duration, Enum.EasingStyle.Linear),
					{Size=UDim2.new(0,0,1,0)}):Play()
			end
		end

		function N:Close()
			if N.Closed then return end
			N.Closed = true
			task.spawn(function()
				RootMotor:setGoal({
					Scale=Spr(1,{frequency=7}),
					Offset=Spr(60,{frequency=7}),
				})
				local m,setT = Creator.SpringMotor(0, N.Holder, "BackgroundTransparency")
				-- fade out holder height
				TweenService:Create(N.Holder, TweenInfo.new(0.22, Enum.EasingStyle.Quint),
					{Size=UDim2.new(1,0,0,0)}):Play()
				task.wait(0.25)
				if Library.UseAcrylic and N.AcrylicPaint.Model then
					N.AcrylicPaint.Model:Destroy()
				end
				N.Holder:Destroy()
			end)
		end

		N:Open()
		if Config.Duration then
			task.delay(Config.Duration, function() N:Close() end)
		end
		return N
	end
	return Notif
end)()

-- ===== TEXTBOX COMPONENT =====
Components.Textbox = (function()
	return function(Parent, Acr)
		Acr = Acr or false
		local T = {}
		T.Input = New("TextBox",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			TextColor3=Color3.fromRGB(200,200,200), TextSize=14,
			TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Center,
			BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y,
			Size=UDim2.fromScale(1,1), Position=UDim2.fromOffset(10,0),
			ThemeTag={TextColor3="Text", PlaceholderColor3="SubText"},
		})
		T.Container = New("Frame",{
			BackgroundTransparency=1, ClipsDescendants=true,
			Position=UDim2.new(0,6,0,0), Size=UDim2.new(1,-12,1,0),
		},{ T.Input })
		T.Indicator = New("Frame",{
			Size=UDim2.new(1,-4,0,1), Position=UDim2.new(0,2,1,0),
			AnchorPoint=Vector2.new(0,1), BackgroundTransparency=Acr and 0.5 or 0,
			ThemeTag={BackgroundColor3=Acr and "InputIndicator" or "DialogInputLine"},
		})
		T.Frame = New("Frame",{
			Size=UDim2.new(0,0,0,30), BackgroundTransparency=Acr and 0.9 or 0,
			Parent=Parent, ThemeTag={BackgroundColor3=Acr and "Input" or "DialogInput"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,5)}),
			New("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
				Transparency=Acr and 0.5 or 0.65,
				ThemeTag={Color=Acr and "InElementBorder" or "DialogButtonBorder"}}),
			T.Indicator, T.Container,
		})
		local function Update()
			local PAD, Rev = 2, T.Container.AbsoluteSize.X
			if not T.Input:IsFocused() or T.Input.TextBounds.X <= Rev-2*PAD then
				T.Input.Position = UDim2.new(0,PAD,0,0)
			else
				local cur = T.Input.CursorPosition
				if cur ~= -1 then
					local sub = string.sub(T.Input.Text, 1, cur-1)
					local w = TextService:GetTextSize(sub, T.Input.TextSize, T.Input.Font,
						Vector2.new(math.huge,math.huge)).X
					local cp = T.Input.Position.X.Offset + w
					if cp < PAD then T.Input.Position = UDim2.fromOffset(PAD-w, 0)
					elseif cp > Rev-PAD-1 then T.Input.Position = UDim2.fromOffset(Rev-w-PAD-1, 0) end
				end
			end
		end
		task.spawn(Update)
		Creator.AddSignal(T.Input:GetPropertyChangedSignal("Text"), Update)
		Creator.AddSignal(T.Input:GetPropertyChangedSignal("CursorPosition"), Update)
		Creator.AddSignal(T.Input.Focused, function()
			Update()
			T.Indicator.Size = UDim2.new(1,-2,0,2)
			T.Indicator.Position = UDim2.new(0,1,1,0)
			T.Indicator.BackgroundTransparency = 0
			Creator.OverrideTag(T.Frame, {BackgroundColor3=Acr and "InputFocused" or "DialogHolder"})
		end)
		Creator.AddSignal(T.Input.FocusLost, function()
			Update()
			T.Indicator.Size = UDim2.new(1,-4,0,1)
			T.Indicator.Position = UDim2.new(0,2,1,0)
			T.Indicator.BackgroundTransparency = 0.5
			Creator.OverrideTag(T.Frame, {BackgroundColor3=Acr and "Input" or "DialogInput"})
			Creator.OverrideTag(T.Indicator, {BackgroundColor3=Acr and "InputIndicator" or "DialogInputLine"})
		end)
		return T
	end
end)()

-- ===== TITLEBAR COMPONENT =====
Components.TitleBar = (function()
	local function BarButton(Icon, Pos, Parent, Callback)
		local B = { Callback = Callback or function() end }
		B.Frame = New("TextButton",{
			Size=UDim2.new(0,32,1,-8), AnchorPoint=Vector2.new(1,0),
			BackgroundTransparency=1, Parent=Parent, Position=Pos, Text="",
			ThemeTag={BackgroundColor3="Text"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,7)}),
			New("ImageLabel",{
				Image=Icon, Size=UDim2.fromOffset(15,15),
				Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5),
				BackgroundTransparency=1, Name="Icon", ThemeTag={ImageColor3="Text"},
			}),
		})
		local _, SetT = Creator.SpringMotor(1, B.Frame, "BackgroundTransparency")
		Creator.AddSignal(B.Frame.MouseEnter, function() SetT(0.94) end)
		Creator.AddSignal(B.Frame.MouseLeave, function() SetT(1,true) end)
		Creator.AddSignal(B.Frame.MouseButton1Down, function() SetT(0.96) end)
		Creator.AddSignal(B.Frame.MouseButton1Up, function() SetT(0.94) end)
		Creator.AddSignal(B.Frame.MouseButton1Click, B.Callback)
		B.SetCallback = function(f) B.Callback = f end
		return B
	end

	return function(Config)
		local TitleBar = {}
		TitleBar.Frame = New("Frame",{
			Size=UDim2.new(1,0,0,42), BackgroundTransparency=1, Parent=Config.Parent,
		},{
			New("Frame",{
				Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,16,0,0), BackgroundTransparency=1,
			},{
				New("UIListLayout",{Padding=UDim.new(0,5), FillDirection=Enum.FillDirection.Horizontal,
					SortOrder=Enum.SortOrder.LayoutOrder}),
				New("TextLabel",{
					RichText=true, Text=Config.Title,
					FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Regular),
					TextSize=12, TextXAlignment="Left", TextYAlignment="Center",
					Size=UDim2.fromScale(0,1), AutomaticSize=Enum.AutomaticSize.X,
					BackgroundTransparency=1, ThemeTag={TextColor3="Text"},
				}),
				New("TextLabel",{
					RichText=true, Text=Config.SubTitle, TextTransparency=0.45,
					FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Regular),
					TextSize=12, TextXAlignment="Left", TextYAlignment="Center",
					Size=UDim2.fromScale(0,1), AutomaticSize=Enum.AutomaticSize.X,
					BackgroundTransparency=1, ThemeTag={TextColor3="Text"},
				}),
			}),
			New("Frame",{
				BackgroundTransparency=0.5, Size=UDim2.new(1,0,0,1),
				Position=UDim2.new(0,0,1,0), ThemeTag={BackgroundColor3="TitleBarLine"},
			}),
		})

		TitleBar.CloseButton = BarButton(Components.Assets.Close, UDim2.new(1,-4,0,4), TitleBar.Frame, function()
			Library.Window:Dialog({
				Title="Close",
				Content="Are you sure you want to unload the interface?",
				Buttons={
					{ Title="Yes", Callback=function() Library:Destroy() end },
					{ Title="No" },
				},
			})
		end)
		TitleBar.MaxButton = BarButton(Components.Assets.Max, UDim2.new(1,-38,0,4), TitleBar.Frame, function()
			Config.Window.Maximize(not Config.Window.Maximized)
		end)
		TitleBar.MinButton = BarButton(Components.Assets.Min, UDim2.new(1,-72,0,4), TitleBar.Frame, function()
			Library.Window:Minimize()
			if not Close_ImageButton.Visible then Close_ImageButton.Visible=true end
		end)

		Close_ImageButton.Activated:Connect(function()
			Library.Window:Minimize()
			Close_ImageButton.Visible = false
		end)
		return TitleBar
	end
end)()

-- ===== WINDOW COMPONENT =====
Components.Window = (function()
	local Spr = Flipper.Spring.new
	local Inst = Flipper.Instant.new
	return function(Config)
		local W = {
			Minimized=false, Maximized=false,
			Size=Config.Size,
			CurrentPos=0, TabWidth=0,
			Position=UDim2.fromOffset(
				Camera.ViewportSize.X/2 - Config.Size.X.Offset/2,
				Camera.ViewportSize.Y/2 - Config.Size.Y.Offset/2
			),
		}
		local Dragging, DragInput, MousePos, StartPos = false
		local Resizing, ResizePos = false

		W.AcrylicPaint = Acrylic.AcrylicPaint()
		W.TabWidth = Config.TabWidth

		local Selector = New("Frame",{
			Size=UDim2.fromOffset(4,0), BackgroundColor3=Color3.fromRGB(76,194,255),
			Position=UDim2.fromOffset(0,17), AnchorPoint=Vector2.new(0,0.5),
			ThemeTag={BackgroundColor3="Accent"},
		},{ New("UICorner",{CornerRadius=UDim.new(0,2)}) })

		local ResizeStartFrame = New("Frame",{
			Size=UDim2.fromOffset(20,20), BackgroundTransparency=1,
			Position=UDim2.new(1,-20,1,-20),
		})

		W.TabHolder = New("ScrollingFrame",{
			Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
			ScrollBarImageTransparency=1, ScrollBarThickness=0,
			BorderSizePixel=0, CanvasSize=UDim2.fromScale(0,0),
			ScrollingDirection=Enum.ScrollingDirection.Y,
		},{ New("UIListLayout",{Padding=UDim.new(0,4)}) })

		local TabFrame = New("Frame",{
			Size=UDim2.new(0,W.TabWidth,1,-66), Position=UDim2.new(0,12,0,54),
			BackgroundTransparency=1, ClipsDescendants=true,
		},{ W.TabHolder, Selector })

		W.TabDisplay = New("TextLabel",{
			RichText=true, Text="Tab", TextTransparency=0,
			FontFace=Font.new("rbxassetid://12187365364",Enum.FontWeight.SemiBold),
			TextSize=28, TextXAlignment="Left", TextYAlignment="Center",
			Size=UDim2.new(1,-16,0,28), Position=UDim2.fromOffset(W.TabWidth+26,56),
			BackgroundTransparency=1, ThemeTag={TextColor3="Text"},
		})

		W.ContainerHolder = New("Frame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1})
		W.ContainerAnim = New("CanvasGroup",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1})
		W.ContainerCanvas = New("Frame",{
			Size=UDim2.new(1,-W.TabWidth-32,1,-102),
			Position=UDim2.fromOffset(W.TabWidth+26,90), BackgroundTransparency=1,
		},{ W.ContainerAnim, W.ContainerHolder })

		W.Root = New("Frame",{
			BackgroundTransparency=1, Size=W.Size, Position=W.Position, Parent=Config.Parent,
		},{
			W.AcrylicPaint.Frame, W.TabDisplay, W.ContainerCanvas, TabFrame, ResizeStartFrame,
		})

		W.TitleBar = Components.TitleBar({ Title=Config.Title, SubTitle=Config.SubTitle, Parent=W.Root, Window=W })

		if Library.UseAcrylic then W.AcrylicPaint.AddParent(W.Root) end

		local SizeMotor = Flipper.GroupMotor.new({X=W.Size.X.Offset, Y=W.Size.Y.Offset})
		local PosMotor  = Flipper.GroupMotor.new({X=W.Position.X.Offset, Y=W.Position.Y.Offset})
		W.SelectorPosMotor  = Flipper.SingleMotor.new(17)
		W.SelectorSizeMotor = Flipper.SingleMotor.new(0)
		W.ContainerBackMotor = Flipper.SingleMotor.new(0)
		W.ContainerPosMotor  = Flipper.SingleMotor.new(94)

		SizeMotor:onStep(function(v) W.Root.Size = UDim2.new(0,v.X,0,v.Y) end)
		PosMotor:onStep(function(v) W.Root.Position = UDim2.new(0,v.X,0,v.Y) end)

		local LastVal, LastTime = 0, 0
		W.SelectorPosMotor:onStep(function(v)
			Selector.Position = UDim2.new(0,0,0,v+17)
			local now = tick(); local dt = now-LastTime
			if LastVal ~= nil then
				W.SelectorSizeMotor:setGoal(Spr((math.abs(v-LastVal)/(dt*60))+16))
				LastVal = v
			end; LastTime = now
		end)
		W.SelectorSizeMotor:onStep(function(v) Selector.Size = UDim2.new(0,4,0,v) end)
		W.ContainerBackMotor:onStep(function(v) W.ContainerAnim.GroupTransparency=v end)
		W.ContainerPosMotor:onStep(function(v) W.ContainerAnim.Position=UDim2.fromOffset(0,v) end)

		local OldSX, OldSY
		W.Maximize = function(val, noPos, instant)
			W.Maximized = val
			W.TitleBar.MaxButton.Frame.Icon.Image = val and Components.Assets.Restore or Components.Assets.Max
			if val then OldSX=W.Size.X.Offset; OldSY=W.Size.Y.Offset end
			local sx = val and Camera.ViewportSize.X or OldSX
			local sy = val and Camera.ViewportSize.Y or OldSY
			SizeMotor:setGoal({
				X=Flipper[instant and "Instant" or "Spring"].new(sx,{frequency=6}),
				Y=Flipper[instant and "Instant" or "Spring"].new(sy,{frequency=6}),
			})
			W.Size = UDim2.fromOffset(sx,sy)
			if not noPos then
				PosMotor:setGoal({
					X=Spr(val and 0 or W.Position.X.Offset,{frequency=6}),
					Y=Spr(val and 0 or W.Position.Y.Offset,{frequency=6}),
				})
			end
		end

		Creator.AddSignal(W.TitleBar.Frame.InputBegan, function(Input)
			if Input.UserInputType==Enum.UserInputType.MouseButton1
				or Input.UserInputType==Enum.UserInputType.Touch then
				Dragging=true; MousePos=Input.Position; StartPos=W.Root.Position
				if W.Maximized then
					StartPos = UDim2.fromOffset(
						Mouse.X-(Mouse.X*((OldSX-100)/W.Root.AbsoluteSize.X)),
						Mouse.Y-(Mouse.Y*(OldSY/W.Root.AbsoluteSize.Y))
					)
				end
				Input.Changed:Connect(function()
					if Input.UserInputState==Enum.UserInputState.End then Dragging=false end
				end)
			end
		end)
		Creator.AddSignal(W.TitleBar.Frame.InputChanged, function(Input)
			if Input.UserInputType==Enum.UserInputType.MouseMovement
				or Input.UserInputType==Enum.UserInputType.Touch then DragInput=Input end
		end)
		Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
			if Input.UserInputType==Enum.UserInputType.MouseButton1
				or Input.UserInputType==Enum.UserInputType.Touch then
				Resizing=true; ResizePos=Input.Position
			end
		end)
		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if Input==DragInput and Dragging then
				local D = Input.Position - MousePos
				W.Position = UDim2.fromOffset(StartPos.X.Offset+D.X, StartPos.Y.Offset+D.Y)
				PosMotor:setGoal({X=Inst(W.Position.X.Offset), Y=Inst(W.Position.Y.Offset)})
				if W.Maximized then W.Maximize(false,true,true) end
			end
			if (Input.UserInputType==Enum.UserInputType.MouseMovement
				or Input.UserInputType==Enum.UserInputType.Touch) and Resizing then
				local D = Input.Position - ResizePos
				local SS = W.Size
				local TS = Vector3.new(SS.X.Offset,SS.Y.Offset,0)+Vector3.new(1,1,0)*D
				local TSC = Vector2.new(math.clamp(TS.X,470,2048), math.clamp(TS.Y,380,2048))
				SizeMotor:setGoal({X=Flipper.Instant.new(TSC.X), Y=Flipper.Instant.new(TSC.Y)})
			end
		end)
		Creator.AddSignal(UserInputService.InputEnded, function(Input)
			if Resizing==true or Input.UserInputType==Enum.UserInputType.Touch then
				Resizing=false
				W.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
			end
		end)
		Creator.AddSignal(W.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			W.TabHolder.CanvasSize=UDim2.new(0,0,0,W.TabHolder.UIListLayout.AbsoluteContentSize.Y)
		end)

		function W:Minimize()
			W.Minimized = not W.Minimized
			W.Root.Visible = not W.Minimized
		end
		function W:Destroy()
			if Library.UseAcrylic then W.AcrylicPaint.Model:Destroy() end
			W.Root:Destroy()
		end

		local DlgModule = Components.Dialog:Init(W)
		function W:Dialog(Config)
			local D = DlgModule:Create()
			D.Title.Text = Config.Title
			local Content = New("TextLabel",{
				FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text=Config.Content, TextColor3=Color3.fromRGB(240,240,240),
				TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top,
				Size=UDim2.new(1,-40,1,0), Position=UDim2.fromOffset(20,60),
				BackgroundTransparency=1, Parent=D.Root, ThemeTag={TextColor3="Text"},
			})
			New("UISizeConstraint",{MinSize=Vector2.new(300,165), MaxSize=Vector2.new(620,math.huge), Parent=D.Root})
			D.Root.Size = UDim2.fromOffset(Content.TextBounds.X+40, 165)
			if Content.TextBounds.X+40 > W.Size.X.Offset-120 then
				D.Root.Size = UDim2.fromOffset(W.Size.X.Offset-120, 165)
				Content.TextWrapped=true
				D.Root.Size = UDim2.fromOffset(W.Size.X.Offset-120, Content.TextBounds.Y+150)
			end
			for _,Btn in next, Config.Buttons do D:Button(Btn.Title, Btn.Callback) end
			D:Open()
		end

		local TabModule = Components.Tab:Init(W)
		function W:AddTab(TC)
			return TabModule:New(TC.Title, TC.Icon, W.TabHolder)
		end
		function W:SelectTab(t) TabModule:SelectTab(t) end

		Creator.AddSignal(W.TabHolder:GetPropertyChangedSignal("CanvasPosition"), function()
			LastVal = TabModule:GetCurrentTabPos()+16; LastTime=0
			W.SelectorPosMotor:setGoal(Inst(TabModule:GetCurrentTabPos()))
		end)
		return W
	end
end)()

-- ============ DRIVER COMPONENT (MAJOR UPGRADE) ============
-- Now supports: AddSection, AddBox, and all standard elements
Components.Driver = (function()
	local Spr = Flipper.Spring.new
	return function(Config)
		local D = {}
		Config = Config or {}
		Config.Title = Config.Title or "DRIVER"
		Config.DefaultOpen = Config.DefaultOpen ~= false

		-- Header
		D.Arrow = New("ImageLabel",{
			Size=UDim2.fromOffset(16,16), Position=UDim2.new(1,-10,0.5,0),
			AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1,
			Image="rbxassetid://10709790948",
			Rotation = Config.DefaultOpen and 180 or 0,
			ThemeTag={ImageColor3="Accent"},
		})

		local iconOffset = 12
		if Config.Icon then
			D.IconLabel = New("ImageLabel",{
				Size=UDim2.fromOffset(20,20), Position=UDim2.fromOffset(12,11),
				BackgroundTransparency=1, Image=Config.Icon,
				ThemeTag={ImageColor3="Text"},
			})
			iconOffset = 36
		end

		D.TitleLabel = New("TextLabel",{
			Text=Config.Title,
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Bold),
			TextSize=15, TextColor3=Color3.fromRGB(255,255,255),
			TextXAlignment=Enum.TextXAlignment.Left,
			Position=UDim2.fromOffset(iconOffset,7), Size=UDim2.new(1,-iconOffset-30,0,20),
			BackgroundTransparency=1, ThemeTag={TextColor3="Text"},
		})

		if Config.Description and Config.Description ~= "" then
			D.DescLabel = New("TextLabel",{
				Text=Config.Description,
				FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
				TextSize=11, TextColor3=Color3.fromRGB(200,200,200),
				TextXAlignment=Enum.TextXAlignment.Left,
				Position=UDim2.fromOffset(iconOffset,26), Size=UDim2.new(1,-iconOffset-30,0,14),
				BackgroundTransparency=1, ThemeTag={TextColor3="SubText"},
			})
		end

		-- Accent left bar
		D.AccentLine = New("Frame",{
			Size=UDim2.new(0,3,1,-8), Position=UDim2.fromOffset(0,4),
			BorderSizePixel=0, ThemeTag={BackgroundColor3="Accent"},
		},{ New("UICorner",{CornerRadius=UDim.new(0,2)}) })

		D.Background = New("Frame",{
			Size=UDim2.fromScale(1,1), BackgroundTransparency=0.9,
			ThemeTag={BackgroundColor3="Element"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,10)}),
			New("UIStroke",{Thickness=1.5, Transparency=0.55, ThemeTag={Color="Accent"}}),
		})

		D.HeaderBtn = New("TextButton",{
			Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
			Text="", AutoButtonColor=false,
		})

		D.Divider = New("Frame",{
			Size=UDim2.new(1,-16,0,1), Position=UDim2.fromOffset(8,40),
			BackgroundTransparency=0.55, ThemeTag={BackgroundColor3="Accent"},
		})

		-- Content layout & container
		D.Layout = New("UIListLayout",{Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder})
		D.LayoutPad = New("UIPadding",{
			PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,8),
			PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4),
		})

		D.ContentContainer = New("Frame",{
			Size=UDim2.new(1,-8,0,0), Position=UDim2.fromOffset(4,46),
			BackgroundTransparency=1, ClipsDescendants=true,
			Visible=Config.DefaultOpen,
		},{ D.Layout, D.LayoutPad })

		local headerChildren = { D.AccentLine, D.HeaderBtn, D.TitleLabel, D.Arrow, D.Divider }
		if D.IconLabel then table.insert(headerChildren, D.IconLabel) end
		if D.DescLabel then table.insert(headerChildren, D.DescLabel) end

		D.Container = New("Frame",{
			Size=UDim2.new(1,0,0,44), BackgroundTransparency=1,
			AutomaticSize=Enum.AutomaticSize.None,
		},{
			D.Background, table.unpack(headerChildren),
			D.ContentContainer,
		})

		local HeightM   = Flipper.SingleMotor.new(Config.DefaultOpen and 200 or 44)
		local RotM      = Flipper.SingleMotor.new(Config.DefaultOpen and 180 or 0)
		local DividerM  = Flipper.SingleMotor.new(Config.DefaultOpen and 0.55 or 1)

		HeightM:onStep(function(v) D.Container.Size = UDim2.new(1,0,0,v) end)
		RotM:onStep(function(v) D.Arrow.Rotation = v end)
		DividerM:onStep(function(v) D.Divider.BackgroundTransparency = v end)

		local isOpen = Config.DefaultOpen

		local function updateSize()
			if isOpen then
				local ch = D.Layout.AbsoluteContentSize.Y
				local total = ch + 60
				HeightM:setGoal(Spr(total,{frequency=9,dampingRatio=0.8}))
				DividerM:setGoal(Spr(0.55,{frequency=8}))
				D.ContentContainer.Visible = true
			else
				HeightM:setGoal(Spr(44,{frequency=9,dampingRatio=0.8}))
				DividerM:setGoal(Spr(1,{frequency=8}))
				task.delay(0.25, function() if not isOpen then D.ContentContainer.Visible=false end end)
			end
			RotM:setGoal(Spr(isOpen and 180 or 0,{frequency=8}))
		end

		Creator.AddSignal(D.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			if isOpen then updateSize() end
		end)

		function D:Toggle()
			isOpen = not isOpen
			updateSize()
			if D._ToggleCB then Library:SafeCallback(D._ToggleCB, isOpen) end
		end
		function D:SetOpen(s) if isOpen~=s then D:Toggle() end end
		function D:IsOpen() return isOpen end
		function D:OnToggle(cb) D._ToggleCB = cb end
		function D:SetTitle(t) D.TitleLabel.Text=t end
		function D:SetVisible(v) D.Container.Visible=v end
		function D:Destroy() D.Container:Destroy() end

		Creator.AddSignal(D.HeaderBtn.MouseButton1Click, function() D:Toggle() end)

		-- Hover
		local _, setHoverT = Creator.SpringMotor(0.9, D.Background, "BackgroundTransparency")
		Creator.AddSignal(D.HeaderBtn.MouseEnter, function() setHoverT(0.84) end)
		Creator.AddSignal(D.HeaderBtn.MouseLeave, function() setHoverT(0.9) end)
		Creator.AddSignal(D.HeaderBtn.MouseButton1Down, function() setHoverT(0.82) end)
		Creator.AddSignal(D.HeaderBtn.MouseButton1Up, function() setHoverT(0.84) end)

		task.spawn(function()
			task.wait(0.15)
			local ch = D.Layout.AbsoluteContentSize.Y
			if ch > 0 and isOpen then
				D.ContentContainer.Visible=true
				D.Container.Size = UDim2.new(1,0,0,ch+60)
				HeightM:setGoal(Flipper.Instant.new(ch+60))
			elseif not isOpen then
				D.ContentContainer.Visible=false
			end
		end)

		-- ===== DRIVER INTERNAL SECTION =====
		-- A section that renders inside the driver's content container
		D.AddSection = function(self, sectionTitle, defaultOpen)
			local SF = Components.Section(sectionTitle, D.ContentContainer, defaultOpen)
			-- Return a wrapper that looks like a Tab/Section for element adding
			local SectionWrapper = { Type="Section", _SectionFrame=SF }
			SectionWrapper.Container = SF.Container
			SectionWrapper.ScrollFrame = D.ContentContainer
			setmetatable(SectionWrapper, Library.Elements)
			return SectionWrapper
		end

		-- ===== DRIVER INTERNAL BOX =====
		D.AddBox = function(self, boxTitle, boxIcon, defaultOpen)
			local BF = Components.Box(boxTitle, boxIcon, D.ContentContainer, defaultOpen)
			local BoxWrapper = { Type="Box", _BoxFrame=BF }
			BoxWrapper.Container = BF.Container
			BoxWrapper.ScrollFrame = D.ContentContainer
			setmetatable(BoxWrapper, Library.Elements)
			return BoxWrapper
		end

		return D
	end
end)()

-- ============ ELEMENTS TABLE ============
local ElementsTable = {}
local AddSignal = Creator.AddSignal

-- ===== BUTTON =====
ElementsTable.Button = (function()
	local E = {}; E.__index=E; E.__type="Button"
	function E:New(Config)
		assert(Config.Title, "Button - Missing Title")
		Config.Callback = Config.Callback or function() end
		local BF = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		New("ImageLabel",{
			Image=Components.Assets.Close,
			Size=UDim2.fromOffset(10,10), AnchorPoint=Vector2.new(1,0.5),
			Position=UDim2.new(1,-10,0.5,0), BackgroundTransparency=1,
			Rotation=45, Parent=BF.Frame, ThemeTag={ImageColor3="Accent"},
		})
		Creator.AddSignal(BF.Frame.MouseButton1Click, function()
			Library:SafeCallback(Config.Callback)
		end)
		return BF
	end
	return E
end)()

-- ===== TOGGLE =====
ElementsTable.Toggle = (function()
	local E = {}; E.__index=E; E.__type="Toggle"
	function E:New(Idx, Config)
		assert(Config.Title, "Toggle - Missing Title")
		local Toggle = {
			Value=Config.Default or false,
			Callback=Config.Callback or function() end,
			Type="Toggle",
		}
		local TF = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		TF.DescLabel.Size = UDim2.new(1,-54,0,14)
		Toggle.SetTitle=TF.SetTitle; Toggle.SetDesc=TF.SetDesc
		Toggle.Visible=TF.Visible; Toggle.Elements=TF

		local Circle = New("ImageLabel",{
			AnchorPoint=Vector2.new(0,0.5), Size=UDim2.fromOffset(14,14),
			Position=UDim2.new(0,2,0.5,0), Image="http://www.roblox.com/asset/?id=12266946128",
			ImageTransparency=0.5, ThemeTag={ImageColor3="ToggleSlider"},
		})
		local Border = New("UIStroke",{Transparency=0.5, ThemeTag={Color="ToggleSlider"}})
		local Slider = New("Frame",{
			Size=UDim2.fromOffset(36,18), AnchorPoint=Vector2.new(1,0.5),
			Position=UDim2.new(1,-10,0.5,0), Parent=TF.Frame,
			BackgroundTransparency=1, ThemeTag={BackgroundColor3="Accent"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,9)}), Border, Circle,
		})

		function Toggle:OnChanged(fn) Toggle.Changed=fn; fn(Toggle.Value) end
		function Toggle:SetValue(v)
			v = not not v; Toggle.Value=v
			Creator.OverrideTag(Border,{Color=v and "Accent" or "ToggleSlider"})
			Creator.OverrideTag(Circle,{ImageColor3=v and "ToggleToggled" or "ToggleSlider"})
			TweenService:Create(Circle, TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
				{Position=UDim2.new(0,v and 19 or 2,0.5,0)}):Play()
			TweenService:Create(Slider, TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
				{BackgroundTransparency=v and 0.4 or 1}):Play()
			Circle.ImageTransparency = v and 0 or 0.5
			Library:SafeCallback(Toggle.Callback, v)
			Library:SafeCallback(Toggle.Changed, v)
		end
		function Toggle:Destroy() TF:Destroy(); Library.Options[Idx]=nil end
		Creator.AddSignal(TF.Frame.MouseButton1Click, function() Toggle:SetValue(not Toggle.Value) end)
		Toggle:SetValue(Toggle.Value)
		Library.Options[Idx] = Toggle
		return Toggle
	end
	return E
end)()

-- ===== DROPDOWN =====
ElementsTable.Dropdown = (function()
	local E = {}; E.__index=E; E.__type="Dropdown"
	function E:New(Idx, Config)
		local Drop = {
			Values=Config.Values, Value=Config.Default, Multi=Config.Multi,
			Buttons={}, Opened=false, Type="Dropdown",
			Callback=Config.Callback or function() end, SearchText="",
		}
		if Drop.Multi and Config.AllowNull then Drop.Value={} end
		local DF = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		DF.DescLabel.Size = UDim2.new(1,-170,0,14)
		Drop.SetTitle=DF.SetTitle; Drop.SetDesc=DF.SetDesc; Drop.Visible=DF.Visible; Drop.Elements=DF

		local Display = New("TextLabel",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text="Value", TextColor3=Color3.fromRGB(240,240,240), TextSize=13,
			TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1,-30,0,14),
			Position=UDim2.new(0,8,0.5,0), AnchorPoint=Vector2.new(0,0.5),
			BackgroundTransparency=1, TextTruncate=Enum.TextTruncate.AtEnd,
			ThemeTag={TextColor3="Text"},
		})
		local Ico = New("ImageLabel",{
			Image="rbxassetid://10709790948", Size=UDim2.fromOffset(14,14),
			AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-7,0.5,0),
			BackgroundTransparency=1, ThemeTag={ImageColor3="SubText"},
		})
		local Inner = New("TextButton",{
			Size=UDim2.fromOffset(160,30), Position=UDim2.new(1,-10,0.5,0),
			AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=0.9,
			Parent=DF.Frame, ThemeTag={BackgroundColor3="DropdownFrame"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,6)}),
			New("UIStroke",{Transparency=0.5, ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
				ThemeTag={Color="InElementBorder"}}),
			Ico, Display,
		})

		-- Search
		Drop.SearchBox = New("TextBox",{
			PlaceholderText="🔍 Search...", Text="",
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			TextSize=13, TextColor3=Color3.fromRGB(240,240,240),
			BackgroundTransparency=0.9, Size=UDim2.new(1,-10,0,28),
			Position=UDim2.new(0,5,0,4),
			ThemeTag={TextColor3="Text", PlaceholderColor3="SubText"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,6)}),
			New("UIStroke",{Transparency=0.5, ThemeTag={Color="InElementBorder"}}),
		})

		local ListLayout = New("UIListLayout",{Padding=UDim.new(0,3)})
		Drop.ScrollFrame = New("ScrollingFrame",{
			Size=UDim2.new(1,-5,1,-42), Position=UDim2.fromOffset(5,38),
			BackgroundTransparency=1,
			ScrollBarImageColor3=Color3.fromRGB(255,255,255), ScrollBarImageTransparency=0.75,
			ScrollBarThickness=4, BorderSizePixel=0, CanvasSize=UDim2.fromScale(0,0),
			ScrollingDirection=Enum.ScrollingDirection.Y,
		},{ ListLayout })

		Drop.HolderFrame = New("Frame",{
			Size=UDim2.fromScale(1,0.6), ThemeTag={BackgroundColor3="DropdownHolder"},
		},{
			Drop.SearchBox, Drop.ScrollFrame,
			New("UICorner",{CornerRadius=UDim.new(0,8)}),
			New("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border, ThemeTag={Color="DropdownBorder"}}),
		})

		Drop.HolderCanvas = New("Frame",{
			BackgroundTransparency=1, Size=UDim2.fromOffset(170,280),
			Parent=Library.GUI, Visible=false, ZIndex=100,
		},{ Drop.HolderFrame, New("UISizeConstraint",{MinSize=Vector2.new(170,0)}) })
		table.insert(Library.OpenFrames, Drop.HolderCanvas)

		local function RecalcPos()
			local add = 0
			if Camera.ViewportSize.Y - Inner.AbsolutePosition.Y < Drop.HolderCanvas.AbsoluteSize.Y-5 then
				add = Drop.HolderCanvas.AbsoluteSize.Y-5-(Camera.ViewportSize.Y-Inner.AbsolutePosition.Y)+40
			end
			Drop.HolderCanvas.Position = UDim2.fromOffset(Inner.AbsolutePosition.X-1,
				Inner.AbsolutePosition.Y-5-add)
		end
		local ListSizeX = 170
		local function RecalcSize()
			local vis = 0
			for _,c in ipairs(Drop.ScrollFrame:GetChildren()) do
				if c:IsA("TextButton") and c.Visible then vis=vis+1 end
			end
			local h = math.min(vis*33+46, 360)
			Drop.HolderCanvas.Size = UDim2.fromOffset(ListSizeX, h)
		end
		local function RecalcCanvas()
			local total=0
			for _,c in ipairs(Drop.ScrollFrame:GetChildren()) do
				if c:IsA("TextButton") and c.Visible then total=total+c.AbsoluteSize.Y+3 end
			end
			Drop.ScrollFrame.CanvasSize = UDim2.new(0,0,0,total)
		end

		Creator.AddSignal(Inner:GetPropertyChangedSignal("AbsolutePosition"), RecalcPos)
		Creator.AddSignal(Inner.MouseButton1Click, function() Drop:Open() end)
		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if Input.UserInputType==Enum.UserInputType.MouseButton1
				or Input.UserInputType==Enum.UserInputType.Touch then
				local ap,as = Drop.HolderFrame.AbsolutePosition, Drop.HolderFrame.AbsoluteSize
				if Mouse.X<ap.X or Mouse.X>ap.X+as.X or Mouse.Y<(ap.Y-20) or Mouse.Y>ap.Y+as.Y then
					Drop:Close()
				end
			end
		end)
		Creator.AddSignal(Drop.SearchBox:GetPropertyChangedSignal("Text"), function()
			Drop.SearchText = string.lower(Drop.SearchBox.Text)
			Drop:UpdateVisible()
		end)

		function Drop:Open()
			if Drop.Opened then return end; Drop.Opened=true
			Drop.SearchBox.Text=""; Drop.SearchText=""
			Drop.HolderCanvas.Visible=true
			RecalcPos()
		end
		function Drop:Close()
			if not Drop.Opened then return end; Drop.Opened=false
			Drop.HolderCanvas.Visible=false
		end
		function Drop:Display()
			local str=""
			if Config.Multi then
				for _,v in ipairs(Drop.Values) do
					if Drop.Value[v] then str=str..v..", " end
				end
				str=str:sub(1,#str-2)
			else str=Drop.Value or "" end
			Display.Text = str=="" and "--" or (#str>18 and str:sub(1,18).."..." or str)
		end
		function Drop:GetActiveValues()
			if Config.Multi then
				local t={}; for v,b in pairs(Drop.Value) do if b then table.insert(t,v) end end; return t
			else return Drop.Value and 1 or 0 end
		end
		function Drop:UpdateVisible()
			for _,bd in pairs(Drop.Buttons) do
				local vis = Drop.SearchText=="" or string.find(string.lower(bd.Value),Drop.SearchText,1,true)
				bd.Button.Visible = vis ~= nil
				if Config.Multi then bd.Selected=Drop.Value[bd.Value]
				else bd.Selected=Drop.Value==bd.Value end
				bd:Update()
			end
			RecalcCanvas(); RecalcSize()
		end
		function Drop:Build()
			Drop.Buttons={}
			for _,c in ipairs(Drop.ScrollFrame:GetChildren()) do
				if not c:IsA("UIListLayout") then c:Destroy() end
			end
			ListSizeX=170
			for _,Val in ipairs(Drop.Values) do
				local bd={}
				local Sel = New("Frame",{
					Size=UDim2.fromOffset(3,12), BackgroundColor3=Color3.fromRGB(76,194,255),
					Position=UDim2.fromOffset(-1,10), AnchorPoint=Vector2.new(0,0.5),
					ThemeTag={BackgroundColor3="Accent"},
				},{ New("UICorner",{CornerRadius=UDim.new(0,2)}) })
				local Lbl = New("TextLabel",{
					FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
					Text=Val, TextColor3=Color3.fromRGB(200,200,200), TextSize=12,
					TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1,
					AutomaticSize=Enum.AutomaticSize.X, Size=UDim2.new(1,-14,1,0),
					Position=UDim2.fromOffset(10,0), ThemeTag={TextColor3="Text"},
				})
				local Btn = New("TextButton",{
					Size=UDim2.new(1,-5,0,30), BackgroundTransparency=1, ZIndex=23, Text="",
					Parent=Drop.ScrollFrame, Visible=true,
					ThemeTag={BackgroundColor3="DropdownOption"},
				},{ Sel, Lbl, New("UICorner",{CornerRadius=UDim.new(0,6)}) })
				task.spawn(function()
					task.wait()
					if Lbl.TextBounds.X+30>ListSizeX then ListSizeX=Lbl.TextBounds.X+30; RecalcSize() end
				end)
				local selected = Config.Multi and (Drop.Value[Val] or false) or Drop.Value==Val
				local _, SetBT = Creator.SpringMotor(1, Btn, "BackgroundTransparency")
				local _, SetST = Creator.SpringMotor(1, Sel, "BackgroundTransparency")
				local SzM = Flipper.SingleMotor.new(6)
				SzM:onStep(function(v) Sel.Size=UDim2.new(0,3,0,v) end)
				Creator.AddSignal(Btn.MouseEnter, function() SetBT(selected and 0.85 or 0.89) end)
				Creator.AddSignal(Btn.MouseLeave, function() SetBT(selected and 0.89 or 1) end)
				Creator.AddSignal(Btn.MouseButton1Down, function() SetBT(0.92) end)
				Creator.AddSignal(Btn.MouseButton1Up, function() SetBT(selected and 0.85 or 0.89) end)
				function bd:Update()
					SetBT(bd.Selected and 0.89 or 1)
					SzM:setGoal(Flipper.Spring.new(bd.Selected and 12 or 6,{frequency=8,dampingRatio=0.7}))
					SetST(bd.Selected and 0 or 1)
				end
				Creator.AddSignal(Btn.MouseButton1Click, function()
					local try = not selected
					if Config.Multi then
						if Drop:GetActiveValues()==1 and not try and not Config.AllowNull then return end
						selected=try; Drop.Value[Val]=selected and true or nil
					else
						if not try and not Config.AllowNull then return end
						selected=try; Drop.Value=selected and Val or nil
						for _,ob in pairs(Drop.Buttons) do ob:Update() end
					end
					bd.Selected=selected; bd:Update(); Drop:Display()
					Library:SafeCallback(Drop.Callback, Drop.Value)
					Library:SafeCallback(Drop.Changed, Drop.Value)
				end)
				bd.Button=Btn; bd.Value=Val; bd.Selected=selected; bd:Update()
				Drop.Buttons[Val]=bd
			end
			RecalcCanvas(); RecalcSize(); RecalcPos()
		end
		function Drop:SetValues(nv)
			if nv then Drop.Values=nv end; Drop:Build()
		end
		function Drop:OnChanged(fn) Drop.Changed=fn; fn(Drop.Value) end
		function Drop:SetValue(v)
			if Drop.Multi then
				local nt={}
				for _,val in ipairs(Drop.Values) do if v[val] then nt[val]=true end end
				Drop.Value=nt
			else
				Drop.Value = (not v or not table.find(Drop.Values,v)) and nil or v
			end
			for _,bd in pairs(Drop.Buttons) do bd:Update() end
			Drop:Display()
			Library:SafeCallback(Drop.Callback, Drop.Value)
			Library:SafeCallback(Drop.Changed, Drop.Value)
		end
		function Drop:Destroy()
			DF:Destroy()
			if Drop.HolderCanvas then Drop.HolderCanvas:Destroy() end
			Library.Options[Idx]=nil
		end
		Drop:Build(); Drop:Display()
		if Config.Default then
			if Config.Multi and type(Config.Default)=="table" then
				for _,v in ipairs(Config.Default) do
					if table.find(Drop.Values,v) then Drop.Value[v]=true end
				end
			elseif not Config.Multi then
				local idx2 = type(Config.Default)=="number" and Config.Default or table.find(Drop.Values,Config.Default)
				if idx2 and Drop.Values[idx2] then Drop.Value=Drop.Values[idx2] end
			end
			for _,bd in pairs(Drop.Buttons) do bd:Update() end
			Drop:Display()
		end
		Library.Options[Idx]=Drop
		return Drop
	end
	return E
end)()

-- ===== SLIDER =====
ElementsTable.Slider = (function()
	local E = {}; E.__index=E; E.__type="Slider"
	function E:New(Idx, Config)
		assert(Config.Title,"Slider - Missing Title")
		assert(Config.Default,"Slider - Missing default")
		assert(Config.Min,"Slider - Missing min")
		assert(Config.Max,"Slider - Missing max")
		assert(Config.Rounding ~= nil,"Slider - Missing rounding")
		local S = {
			Value=nil, Min=Config.Min, Max=Config.Max,
			Rounding=Config.Rounding, Callback=Config.Callback or function() end,
			Type="Slider", Dragging=false,
		}
		local SF = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		SF.DescLabel.Size = UDim2.new(1,-140,0,14)
		S.Elements=SF; S.SetTitle=SF.SetTitle; S.SetDesc=SF.SetDesc; S.Visible=SF.Visible

		S.Rail = New("Frame",{
			Size=UDim2.new(0,120,0,30), AnchorPoint=Vector2.new(1,0.5),
			Position=UDim2.new(1,-10,0.5,0), BackgroundTransparency=1, Parent=SF.Frame,
		})
		S.RailBG = New("Frame",{
			Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0.5,0),
			AnchorPoint=Vector2.new(0,0.5), BackgroundTransparency=0.55,
			ThemeTag={BackgroundColor3="SliderRail"}, Parent=S.Rail,
		},{ New("UICorner",{CornerRadius=UDim.new(1,0)}) })
		S.Fill = New("Frame",{
			Size=UDim2.new(0,0,1,0), ThemeTag={BackgroundColor3="Accent"},
			Parent=S.RailBG,
		},{ New("UICorner",{CornerRadius=UDim.new(1,0)}) })
		S.Dot = New("TextButton",{
			Size=UDim2.fromOffset(18,18), Position=UDim2.new(0,-9,0.5,0),
			AnchorPoint=Vector2.new(0,0.5), BackgroundTransparency=1,
			AutoButtonColor=false, Text="", ZIndex=2, Parent=S.Rail,
		},{
			New("Frame",{
				Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(255,255,255),
				ThemeTag={BackgroundColor3="ToggleToggled"},
			},{
				New("UICorner",{CornerRadius=UDim.new(1,0)}),
				New("UIStroke",{Thickness=2, ThemeTag={Color="Accent"}}),
			}),
		})
		S.ValueDisplay = New("TextLabel",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Medium),
			Text="0", TextSize=12, TextXAlignment=Enum.TextXAlignment.Center,
			BackgroundTransparency=1, Size=UDim2.new(0,42,0,16),
			Position=UDim2.new(0,-48,0.5,0), AnchorPoint=Vector2.new(1,0.5),
			ThemeTag={TextColor3="Text"}, Parent=S.Rail,
		})

		local function updSlider(scale)
			scale=math.clamp(scale,0,1)
			local rw = S.RailBG.AbsoluteSize.X
			S.Dot.Position = UDim2.new(0,scale*rw-9,0.5,0)
			S.Fill.Size = UDim2.new(scale,0,1,0)
			local val = S.Min+((S.Max-S.Min)*scale)
			return Library:Round(val, S.Rounding)
		end

		local function startDrag(input)
			S.Dragging=true
			local conn
			conn = RunService.RenderStepped:Connect(function()
				if S.Dragging then
					local mp = UserInputService:GetMouseLocation()
					local ap = S.RailBG.AbsolutePosition
					local as = S.RailBG.AbsoluteSize
					local rel = math.clamp((mp.X-ap.X)/as.X,0,1)
					local nv = updSlider(rel)
					if S.Value~=nv then
						S.Value=nv; S.ValueDisplay.Text=tostring(nv)
						Library:SafeCallback(S.Callback, nv)
						Library:SafeCallback(S.Changed, nv)
					end
				else conn:Disconnect() end
			end)
		end

		local function handleInput(input)
			local ok = input.UserInputType==Enum.UserInputType.MouseButton1
				or input.UserInputType==Enum.UserInputType.Touch
			if ok then
				startDrag(input)
				input.Changed:Connect(function()
					if input.UserInputState==Enum.UserInputState.End then S.Dragging=false end
				end)
			end
		end

		Creator.AddSignal(S.Dot.InputBegan, handleInput)
		Creator.AddSignal(S.RailBG.InputBegan, function(input)
			local ok = input.UserInputType==Enum.UserInputType.MouseButton1
				or input.UserInputType==Enum.UserInputType.Touch
			if ok then
				local ap,as = S.RailBG.AbsolutePosition, S.RailBG.AbsoluteSize
				local rel = math.clamp((input.Position.X-ap.X)/as.X,0,1)
				local nv = updSlider(rel)
				S.Value=nv; S.ValueDisplay.Text=tostring(nv)
				Library:SafeCallback(S.Callback, nv)
				Library:SafeCallback(S.Changed, nv)
			end
		end)
		Creator.AddSignal(UserInputService.InputEnded, function(input)
			if input.UserInputType==Enum.UserInputType.MouseButton1
				or input.UserInputType==Enum.UserInputType.Touch then
				S.Dragging=false
			end
		end)

		function S:OnChanged(fn) S.Changed=fn; if S.Value then fn(S.Value) end end
		function S:SetValue(v)
			local r = Library:Round(math.clamp(v,S.Min,S.Max), S.Rounding)
			if self.Value~=r then
				self.Value=r
				local sc = (r-S.Min)/(S.Max-S.Min)
				updSlider(sc); S.ValueDisplay.Text=tostring(r)
				Library:SafeCallback(S.Callback, r)
				Library:SafeCallback(S.Changed, r)
			end
		end
		function S:Destroy() SF:Destroy(); Library.Options[Idx]=nil end
		S:SetValue(Config.Default)
		Library.Options[Idx]=S
		return S
	end
	return E
end)()

-- ===== KEYBIND =====
ElementsTable.Keybind = (function()
	local E = {}; E.__index=E; E.__type="Keybind"
	function E:New(Idx, Config)
		assert(Config.Title,"KeyBind - Missing Title")
		assert(Config.Default,"KeyBind - Missing default")
		local KB = {
			Value=Config.Default, Toggled=false, Mode=Config.Mode or "Toggle",
			Type="Keybind", Callback=Config.Callback or function() end,
			ChangedCallback=Config.ChangedCallback or function() end,
		}
		local Picking=false
		local KF = Components.Element(Config.Title, Config.Description, self.Container, true)
		KB.SetTitle=KF.SetTitle; KB.SetDesc=KF.SetDesc; KB.Visible=KF.Visible; KB.Elements=KF

		local DisplayLbl = New("TextLabel",{
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text=Config.Default, TextColor3=Color3.fromRGB(240,240,240), TextSize=13,
			TextXAlignment=Enum.TextXAlignment.Center, Size=UDim2.new(0,0,0,14),
			Position=UDim2.new(0,0,0.5,0), AnchorPoint=Vector2.new(0,0.5),
			BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.X,
			ThemeTag={TextColor3="Text"},
		})
		local DisplayFrame = New("TextButton",{
			Size=UDim2.fromOffset(0,30), Position=UDim2.new(1,-10,0.5,0),
			AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=0.9,
			Parent=KF.Frame, AutomaticSize=Enum.AutomaticSize.X,
			ThemeTag={BackgroundColor3="Keybind"},
		},{
			New("UICorner",{CornerRadius=UDim.new(0,6)}),
			New("UIPadding",{PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)}),
			New("UIStroke",{Transparency=0.5, ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
				ThemeTag={Color="InElementBorder"}}),
			DisplayLbl,
		})

		function KB:GetState()
			if UserInputService:GetFocusedTextBox() and KB.Mode~="Always" then return false end
			if KB.Mode=="Always" then return true
			elseif KB.Mode=="Hold" then
				if KB.Value=="None" then return false end
				if KB.Value=="MouseLeft" or KB.Value=="MouseRight" then
					return KB.Value=="MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						or KB.Value=="MouseRight" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
				else return UserInputService:IsKeyDown(Enum.KeyCode[KB.Value]) end
			else return KB.Toggled end
		end
		function KB:SetValue(k, m)
			DisplayLbl.Text=k or KB.Value; KB.Value=k or KB.Value; KB.Mode=m or KB.Mode
		end
		function KB:OnClick(cb) KB.Clicked=cb end
		function KB:OnChanged(cb) KB.Changed=cb; cb(KB.Value) end
		function KB:DoClick()
			Library:SafeCallback(KB.Callback, KB.Toggled)
			Library:SafeCallback(KB.Clicked, KB.Toggled)
		end
		function KB:Destroy() KF:Destroy(); Library.Options[Idx]=nil end

		Creator.AddSignal(DisplayFrame.InputBegan, function(Input)
			if Input.UserInputType==Enum.UserInputType.MouseButton1
				or Input.UserInputType==Enum.UserInputType.Touch then
				Picking=true; DisplayLbl.Text="..."
				wait(0.2)
				local ev
				ev = UserInputService.InputBegan:Connect(function(Input)
					local Key
					if Input.UserInputType==Enum.UserInputType.Keyboard then Key=Input.KeyCode.Name
					elseif Input.UserInputType==Enum.UserInputType.MouseButton1 then Key="MouseLeft"
					elseif Input.UserInputType==Enum.UserInputType.MouseButton2 then Key="MouseRight" end
					local ev2
					ev2 = UserInputService.InputEnded:Connect(function(Input)
						if Input.KeyCode.Name==Key
							or Key=="MouseLeft" and Input.UserInputType==Enum.UserInputType.MouseButton1
							or Key=="MouseRight" and Input.UserInputType==Enum.UserInputType.MouseButton2 then
							Picking=false; DisplayLbl.Text=Key; KB.Value=Key
							Library:SafeCallback(KB.ChangedCallback, Input.KeyCode or Input.UserInputType)
							Library:SafeCallback(KB.Changed, Input.KeyCode or Input.UserInputType)
							ev:Disconnect(); ev2:Disconnect()
						end
					end)
				end)
			end
		end)
		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if not Picking and not UserInputService:GetFocusedTextBox() then
				if KB.Mode=="Toggle" then
					local k=KB.Value
					if k=="MouseLeft" or k=="MouseRight" then
						if k=="MouseLeft" and Input.UserInputType==Enum.UserInputType.MouseButton1
							or k=="MouseRight" and Input.UserInputType==Enum.UserInputType.MouseButton2 then
							KB.Toggled=not KB.Toggled; KB:DoClick()
						end
					elseif Input.UserInputType==Enum.UserInputType.Keyboard then
						if Input.KeyCode.Name==k then KB.Toggled=not KB.Toggled; KB:DoClick() end
					end
				end
			end
		end)
		Library.Options[Idx]=KB
		return KB
	end
	return E
end)()

-- ===== COLORPICKER =====
ElementsTable.Colorpicker = (function()
	local E = {}; E.__index=E; E.__type="Colorpicker"
	function E:New(Idx, Config)
		assert(Config.Title,"Colorpicker - Missing Title")
		assert(Config.Default,"Colorpicker - Missing default")
		local CP = {
			Value=Config.Default, Transparency=Config.Transparency or 0,
			Type="Colorpicker", Title=type(Config.Title)=="string" and Config.Title or "Colorpicker",
			Callback=Config.Callback or function() end,
		}
		function CP:SetHSV(c) local h,s,v=Color3.toHSV(c); CP.Hue=h; CP.Sat=s; CP.Vib=v end
		CP:SetHSV(CP.Value)
		local CF = Components.Element(Config.Title, Config.Description, self.Container, true)
		CP.SetTitle=CF.SetTitle; CP.SetDesc=CF.SetDesc; CP.Visible=CF.Visible; CP.Elements=CF

		local DisplayColor = New("Frame",{
			Size=UDim2.fromScale(1,1), BackgroundColor3=CP.Value,
		},{ New("UICorner",{CornerRadius=UDim.new(0,4)}) })
		local DisplayFrame = New("ImageLabel",{
			Size=UDim2.fromOffset(26,26), Position=UDim2.new(1,-10,0.5,0),
			AnchorPoint=Vector2.new(1,0.5), Parent=CF.Frame,
			Image="http://www.roblox.com/asset/?id=14204231522",
			ImageTransparency=0.45, ScaleType=Enum.ScaleType.Tile,
			TileSize=UDim2.fromOffset(40,40),
		},{
			New("UICorner",{CornerRadius=UDim.new(0,4)}),
			DisplayColor,
		})

		local function CreateDialog()
			local D = Components.Dialog:Create()
			D.Title.Text = CP.Title
			D.Root.Size = UDim2.fromOffset(430,330)
			local Hue,Sat,Vib,Trans = CP.Hue, CP.Sat, CP.Vib, CP.Transparency
			local function MkInput()
				local b = Components.Textbox()
				b.Frame.Parent=D.Root; b.Frame.Size=UDim2.new(0,90,0,32)
				return b
			end
			local function MkLabel(t,p)
				return New("TextLabel",{
					FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Medium),
					Text=t, TextColor3=Color3.fromRGB(240,240,240), TextSize=13,
					TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1,0,0,32),
					Position=p, BackgroundTransparency=1, Parent=D.Root, ThemeTag={TextColor3="Text"},
				})
			end
			local function RGB()
				local c=Color3.fromHSV(Hue,Sat,Vib)
				return {R=math.floor(c.r*255), G=math.floor(c.g*255), B=math.floor(c.b*255)}
			end
			local SatCursor = New("ImageLabel",{
				Size=UDim2.new(0,16,0,16), AnchorPoint=Vector2.new(0.5,0.5),
				BackgroundTransparency=1, Image="http://www.roblox.com/asset/?id=4805639000",
			})
			local SatMap = New("ImageLabel",{
				Size=UDim2.fromOffset(180,160), Position=UDim2.fromOffset(20,55),
				Image="rbxassetid://4155801252", BackgroundColor3=CP.Value,
				Parent=D.Root,
			},{ New("UICorner",{CornerRadius=UDim.new(0,6)}), SatCursor })

			local OldFrame = New("Frame",{BackgroundColor3=CP.Value,Size=UDim2.fromScale(1,1),BackgroundTransparency=CP.Transparency},
				{ New("UICorner",{CornerRadius=UDim.new(0,4)}) })
			New("ImageLabel",{
				Image="http://www.roblox.com/asset/?id=14204231522", ImageTransparency=0.45,
				ScaleType=Enum.ScaleType.Tile, TileSize=UDim2.fromOffset(40,40),
				BackgroundTransparency=1, Position=UDim2.fromOffset(112,220),
				Size=UDim2.fromOffset(88,24), Parent=D.Root,
			},{
				New("UICorner",{CornerRadius=UDim.new(0,4)}),
				New("UIStroke",{Thickness=1.5,Transparency=0.7}), OldFrame,
			})
			local NewFrame = New("Frame",{BackgroundColor3=CP.Value,Size=UDim2.fromScale(1,1)},
				{ New("UICorner",{CornerRadius=UDim.new(0,4)}) })
			New("ImageLabel",{
				Image="http://www.roblox.com/asset/?id=14204231522", ImageTransparency=0.45,
				ScaleType=Enum.ScaleType.Tile, TileSize=UDim2.fromOffset(40,40),
				BackgroundTransparency=1, Position=UDim2.fromOffset(20,220),
				Size=UDim2.fromOffset(88,24), Parent=D.Root,
			},{
				New("UICorner",{CornerRadius=UDim.new(0,4)}),
				New("UIStroke",{Thickness=1.5,Transparency=0.7}), NewFrame,
			})

			local seq={}
			for c=0,1,0.1 do table.insert(seq,ColorSequenceKeypoint.new(c,Color3.fromHSV(c,1,1))) end
			local HueDH = New("Frame",{Size=UDim2.new(1,0,1,-10),Position=UDim2.fromOffset(0,5),BackgroundTransparency=1})
			local HueDrag = New("ImageLabel",{Size=UDim2.fromOffset(12,12),Image="http://www.roblox.com/asset/?id=12266946128",Parent=HueDH,ThemeTag={ImageColor3="DialogInput"}})
			local HueSlider = New("Frame",{
				Size=UDim2.fromOffset(12,190), Position=UDim2.fromOffset(210,55), Parent=D.Root,
			},{
				New("UICorner",{CornerRadius=UDim.new(1,0)}),
				New("UIGradient",{Color=ColorSequence.new(seq),Rotation=90}),
				HueDH,
			})

			local xOff = Config.Transparency and 260 or 240
			local HexI  = MkInput(); HexI.Frame.Position = UDim2.fromOffset(xOff,55); MkLabel("Hex",UDim2.fromOffset(xOff+100,55))
			local RedI  = MkInput(); RedI.Frame.Position = UDim2.fromOffset(xOff,95); MkLabel("Red",UDim2.fromOffset(xOff+100,95))
			local GrnI  = MkInput(); GrnI.Frame.Position = UDim2.fromOffset(xOff,135); MkLabel("Green",UDim2.fromOffset(xOff+100,135))
			local BluI  = MkInput(); BluI.Frame.Position = UDim2.fromOffset(xOff,175); MkLabel("Blue",UDim2.fromOffset(xOff+100,175))
			local AlpI
			if Config.Transparency then
				AlpI = MkInput(); AlpI.Frame.Position = UDim2.fromOffset(260,215); MkLabel("Alpha",UDim2.fromOffset(360,215))
			end
			local TSlider, TDrag, TColor
			if Config.Transparency then
				local TDH = New("Frame",{Size=UDim2.new(1,0,1,-10),Position=UDim2.fromOffset(0,5),BackgroundTransparency=1})
				TDrag = New("ImageLabel",{Size=UDim2.fromOffset(12,12),Image="http://www.roblox.com/asset/?id=12266946128",Parent=TDH,ThemeTag={ImageColor3="DialogInput"}})
				TColor = New("Frame",{Size=UDim2.fromScale(1,1)},{
					New("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}),Rotation=270}),
					New("UICorner",{CornerRadius=UDim.new(1,0)}),
				})
				TSlider = New("Frame",{Size=UDim2.fromOffset(12,190),Position=UDim2.fromOffset(230,55),Parent=D.Root,BackgroundTransparency=1},{
					New("UICorner",{CornerRadius=UDim.new(1,0)}),
					TColor, TDH,
				})
			end

			local function Disp()
				SatMap.BackgroundColor3=Color3.fromHSV(Hue,1,1)
				HueDrag.Position=UDim2.new(0,-1,Hue,-6)
				SatCursor.Position=UDim2.new(Sat,0,1-Vib,0)
				NewFrame.BackgroundColor3=Color3.fromHSV(Hue,Sat,Vib)
				HexI.Input.Text="#"..Color3.fromHSV(Hue,Sat,Vib):ToHex()
				local r=RGB(); RedI.Input.Text=r.R; GrnI.Input.Text=r.G; BluI.Input.Text=r.B
				if Config.Transparency then
					TColor.BackgroundColor3=Color3.fromHSV(Hue,Sat,Vib)
					NewFrame.BackgroundTransparency=Trans
					TDrag.Position=UDim2.new(0,-1,1-Trans,-6)
					AlpI.Input.Text=Library:Round((1-Trans)*100,0).."%"
				end
			end

			Creator.AddSignal(HexI.Input.FocusLost,function(e)
				if e then local ok,r=pcall(Color3.fromHex,HexI.Input.Text) if ok then Hue,Sat,Vib=Color3.toHSV(r) end end; Disp()
			end)
			local function rgbFocus(box, field)
				Creator.AddSignal(box.Input.FocusLost,function(e)
					if e then
						local rgb=RGB(); rgb[field]=tonumber(box.Input.Text) or rgb[field]
						local ok,r=pcall(Color3.fromRGB,rgb.R,rgb.G,rgb.B)
						if ok then Hue,Sat,Vib=Color3.toHSV(r) end
					end; Disp()
				end)
			end
			rgbFocus(RedI,"R"); rgbFocus(GrnI,"G"); rgbFocus(BluI,"B")
			if Config.Transparency then
				Creator.AddSignal(AlpI.Input.FocusLost,function(e)
					if e then pcall(function()
						local v=tonumber(AlpI.Input.Text)
						if v and v>=0 and v<=100 then Trans=1-v*0.01 end
					end) end; Disp()
				end)
			end

			Creator.AddSignal(SatMap.InputBegan,function(Input)
				if Input.UserInputType==Enum.UserInputType.MouseButton1 then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local mx=math.clamp(Mouse.X,SatMap.AbsolutePosition.X,SatMap.AbsolutePosition.X+SatMap.AbsoluteSize.X)
						local my=math.clamp(Mouse.Y,SatMap.AbsolutePosition.Y,SatMap.AbsolutePosition.Y+SatMap.AbsoluteSize.Y)
						Sat=(mx-SatMap.AbsolutePosition.X)/SatMap.AbsoluteSize.X
						Vib=1-((my-SatMap.AbsolutePosition.Y)/SatMap.AbsoluteSize.Y)
						Disp(); RenderStepped:Wait()
					end
				end
			end)
			Creator.AddSignal(HueSlider.InputBegan,function(Input)
				if Input.UserInputType==Enum.UserInputType.MouseButton1 then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local my=math.clamp(Mouse.Y,HueSlider.AbsolutePosition.Y,HueSlider.AbsolutePosition.Y+HueSlider.AbsoluteSize.Y)
						Hue=(my-HueSlider.AbsolutePosition.Y)/HueSlider.AbsoluteSize.Y
						Disp(); RenderStepped:Wait()
					end
				end
			end)
			if Config.Transparency then
				Creator.AddSignal(TSlider.InputBegan,function(Input)
					if Input.UserInputType==Enum.UserInputType.MouseButton1 then
						while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local my=math.clamp(Mouse.Y,TSlider.AbsolutePosition.Y,TSlider.AbsolutePosition.Y+TSlider.AbsoluteSize.Y)
							Trans=1-((my-TSlider.AbsolutePosition.Y)/TSlider.AbsoluteSize.Y)
							Disp(); RenderStepped:Wait()
						end
					end
				end)
			end
			Disp()
			D:Button("Done",function() CP:SetValue({Hue,Sat,Vib},Trans) end)
			D:Button("Cancel")
			D:Open()
		end

		function CP:Display()
			CP.Value=Color3.fromHSV(CP.Hue,CP.Sat,CP.Vib)
			DisplayColor.BackgroundColor3=CP.Value
			DisplayColor.BackgroundTransparency=CP.Transparency
			Library:SafeCallback(CP.Callback,CP.Value)
			Library:SafeCallback(CP.Changed,CP.Value)
		end
		function CP:SetValue(hsv,tr)
			local c=Color3.fromHSV(hsv[1],hsv[2],hsv[3])
			CP.Transparency=tr or 0; CP:SetHSV(c); CP:Display()
		end
		function CP:SetValueRGB(c,tr)
			CP.Transparency=tr or 0; CP:SetHSV(c); CP:Display()
		end
		function CP:OnChanged(fn) CP.Changed=fn; fn(CP.Value) end
		function CP:Destroy() CF:Destroy(); Library.Options[Idx]=nil end

		Creator.AddSignal(CF.Frame.MouseButton1Click, function() CreateDialog() end)
		CP:Display()
		Library.Options[Idx]=CP
		return CP
	end
	return E
end)()

-- ===== INPUT =====
ElementsTable.Input = (function()
	local E = {}; E.__index=E; E.__type="Input"
	function E:New(Idx, Config)
		assert(Config.Title,"Input - Missing Title")
		Config.Callback=Config.Callback or function() end
		local I = {
			Value=Config.Default or "", Numeric=Config.Numeric or false,
			Finished=Config.Finished or false, Callback=Config.Callback, Type="Input",
		}
		local IF = Components.Element(Config.Title, Config.Description, self.Container, false)
		I.SetTitle=IF.SetTitle; I.SetDesc=IF.SetDesc; I.Visible=IF.Visible; I.Elements=IF

		local TB = Components.Textbox(IF.Frame, true)
		TB.Frame.Position=UDim2.new(1,-10,0.5,0); TB.Frame.AnchorPoint=Vector2.new(1,0.5)
		TB.Frame.Size=UDim2.fromOffset(160,30)
		TB.Input.Text=Config.Default or ""; TB.Input.PlaceholderText=Config.Placeholder or ""

		function I:SetValue(t)
			if Config.MaxLength and #t>Config.MaxLength then t=t:sub(1,Config.MaxLength) end
			if I.Numeric and not tonumber(t) and #t>0 then t=I.Value end
			I.Value=t; TB.Input.Text=t
			Library:SafeCallback(I.Callback, t); Library:SafeCallback(I.Changed, t)
		end
		if I.Finished then
			AddSignal(TB.Input.FocusLost,function(e) if e then I:SetValue(TB.Input.Text) end end)
		else
			AddSignal(TB.Input:GetPropertyChangedSignal("Text"),function() I:SetValue(TB.Input.Text) end)
		end
		function I:OnChanged(fn) I.Changed=fn; fn(I.Value) end
		function I:Destroy() IF:Destroy(); Library.Options[Idx]=nil end
		Library.Options[Idx]=I
		return I
	end
	return E
end)()

-- ===== PARAGRAPH =====
ElementsTable.Paragraph = (function()
	local E = {}; E.__index=E; E.__type="Paragraph"
	function E:New(Config)
		assert(Config.Title,"Paragraph - Missing Title")
		Config.Content=Config.Content or ""
		local PF = Components.Element(Config.Title,"",self.Container,false,Config)
		PF.DescLabel:Destroy()

		local ContentText = New("TextLabel",{
			RichText=Config.RichText or false, Text=Config.Content,
			FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json"),
			TextSize=13, TextColor3=Color3.fromRGB(230,230,230),
			TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left,
			TextYAlignment=Enum.TextYAlignment.Top, BackgroundTransparency=1,
			Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
			ThemeTag={TextColor3="SubText"}, Parent=PF.Frame,
		})
		ContentText.Position = UDim2.fromOffset(10,32)
		ContentText.Size = UDim2.new(1,-20,0,0)

		local function updateSize()
			task.wait(0.05)
			local h = ContentText.TextBounds.Y
			PF.Frame.Size = UDim2.new(1,0,0,h+46)
		end
		Creator.AddSignal(ContentText:GetPropertyChangedSignal("TextBounds"), updateSize)
		task.spawn(function() task.wait(0.1); updateSize() end)

		local Par = {}
		function Par:SetContent(c) ContentText.Text=c; updateSize() end
		function Par:SetTitle(t) PF.TitleLabel.Text=t end
		function Par:Destroy() PF.Frame:Destroy() end
		Par.Elements=PF
		return Par
	end
	return E
end)()

-- ===== DRIVER ELEMENT (MAJOR UPGRADE) =====
ElementsTable.Driver = (function()
	local E = {}; E.__index=E; E.__type="Driver"
	function E:New(Idx, Config)
		assert(Config.Title,"Driver - Missing Title")
		local D = { Title=Config.Title, Type="Driver", Opened=Config.DefaultOpen~=false }
		local DC = Components.Driver({
			Title=Config.Title, Description=Config.Description,
			Icon=Config.Icon and Library:GetIcon(Config.Icon) or nil,
			DefaultOpen=D.Opened,
		})
		DC.Container.Parent = self.Container
		DC.Container.LayoutOrder = Config.LayoutOrder or 0

		-- Public passthrough methods
		function D:SetTitle(t) DC:SetTitle(t) end
		function D:SetDescription(d) DC:SetDescription(d) end
		function D:SetIcon(i) if DC.IconLabel then DC.IconLabel.Image=Library:GetIcon(i) or i end end
		function D:SetOpen(s) DC:SetOpen(s); D.Opened=s end
		function D:Toggle() DC:Toggle(); D.Opened=not D.Opened end
		function D:IsOpen() return DC:IsOpen() end
		function D:OnToggle(cb) DC:OnToggle(cb) end
		function D:Destroy() DC.Container:Destroy(); Library.Options[Idx]=nil end

		-- ===========================
		-- ADD SECTION inside Driver
		-- ===========================
		function D:AddSection(SectionTitle, defaultOpen)
			local SF = Components.Section(SectionTitle, DC.ContentContainer, defaultOpen)
			local SW = { Type="Section", _SectionFrame=SF }
			SW.Container = SF.Container
			SW.ScrollFrame = DC.ContentContainer
			setmetatable(SW, Library.Elements)
			return SW
		end

		-- ===========================
		-- ADD BOX inside Driver
		-- ===========================
		function D:AddBox(BoxTitle, BoxIcon, defaultOpen)
			local BF = Components.Box(BoxTitle, BoxIcon, DC.ContentContainer, defaultOpen)
			local BW = { Type="Box", _BoxFrame=BF }
			BW.Container = BF.Container
			BW.ScrollFrame = DC.ContentContainer
			setmetatable(BW, Library.Elements)
			return BW
		end

		-- Standard elements directly inside Driver
		local function makeAdder(EType)
			return function(self2, idx2, cfg2)
				if type(idx2) == "table" then cfg2=idx2; idx2=nil end
				cfg2 = cfg2 or {}
				local elem = ElementsTable[EType]
				elem.Container = DC.ContentContainer
				elem.ScrollFrame = DC.ContentContainer
				elem.Library = Library
				if idx2 then return elem:New(idx2, cfg2) else return elem:New(cfg2) end
			end
		end
		D.AddButton    = makeAdder("Button")
		D.AddToggle    = makeAdder("Toggle")
		D.AddSlider    = makeAdder("Slider")
		D.AddDropdown  = makeAdder("Dropdown")
		D.AddInput     = makeAdder("Input")
		D.AddColorpicker = makeAdder("Colorpicker")
		D.AddKeybind   = makeAdder("Keybind")
		D.AddParagraph = makeAdder("Paragraph")

		Library.Options[Idx]=D
		return D
	end
	return E
end)()

-- ===== BOX ELEMENT =====
ElementsTable.Box = (function()
	local E = {}; E.__index=E; E.__type="Box"
	function E:New(Idx, Config)
		assert(Config.Title,"Box - Missing Title")
		local B = { Title=Config.Title, Type="Box", Opened=Config.DefaultOpen~=false }
		local BC = Components.Box(Config.Title,
			Config.Icon and Library:GetIcon(Config.Icon) or nil,
			self.Container, B.Opened)

		function B:SetTitle(t) BC:SetTitle(t) end
		function B:SetOpen(s) BC:SetOpen(s); B.Opened=s end
		function B:Toggle() BC:Toggle(); B.Opened=not B.Opened end
		function B:IsOpen() return BC:IsOpenState() end
		function B:SetVisible(v) BC:SetVisible(v) end
		function B:Destroy() BC:Destroy(); Library.Options[Idx]=nil end

		local function makeAdder(EType)
			return function(self2, idx2, cfg2)
				if type(idx2)=="table" then cfg2=idx2; idx2=nil end
				cfg2=cfg2 or {}
				local elem = ElementsTable[EType]
				elem.Container = BC.Container
				elem.ScrollFrame = BC.Container
				elem.Library = Library
				BC:AddItem()
				if idx2 then return elem:New(idx2,cfg2) else return elem:New(cfg2) end
			end
		end
		B.AddButton    = makeAdder("Button")
		B.AddToggle    = makeAdder("Toggle")
		B.AddSlider    = makeAdder("Slider")
		B.AddDropdown  = makeAdder("Dropdown")
		B.AddInput     = makeAdder("Input")
		B.AddColorpicker = makeAdder("Colorpicker")
		B.AddKeybind   = makeAdder("Keybind")
		B.AddParagraph = makeAdder("Paragraph")

		Library.Options[Idx]=B
		return B
	end
	return E
end)()

-- ============ ELEMENTS METATABLE ============
local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(T, K, ...) return Elements[K](T, ...) end

for _, EC in pairs(ElementsTable) do
	local name = "Add" .. EC.__type
	Elements[name] = function(self, Idx, Config)
		EC.Container = self.Container
		EC.Type = self.Type
		EC.ScrollFrame = self.ScrollFrame
		EC.Library = Library
		return EC:New(Idx, Config)
	end
end

-- Also add AddSection / AddBox to Elements metatable for Tabs
Elements.AddSection = function(self, Title, defaultOpen)
	local SF = Components.Section(Title, self.Container, defaultOpen)
	local SW = { Type="Section", _SectionFrame=SF }
	SW.Container = SF.Container
	SW.ScrollFrame = self.Container
	setmetatable(SW, Elements)
	return SW
end

Elements.AddBox = function(self, Title, Icon, defaultOpen)
	local BF = Components.Box(Title, Icon, self.Container, defaultOpen)
	local BW = { Type="Box", _BoxFrame=BF }
	BW.Container = BF.Container
	BW.ScrollFrame = self.Container
	setmetatable(BW, Elements)
	return BW
end

Library.Elements = Elements

-- ============ NOTIFICATIONS ============
local NotificationModule = Components.Notification
NotificationModule:Init(GUI)

-- ============ ICONS ============
local Icons = {
	["lucide-accessibility"]="rbxassetid://10709751939",
	["lucide-activity"]="rbxassetid://10709752035",
	["lucide-alert-circle"]="rbxassetid://10709752996",
	["lucide-alert-triangle"]="rbxassetid://10709753149",
	["lucide-arrow-down"]="rbxassetid://10709767827",
	["lucide-arrow-left"]="rbxassetid://10709768114",
	["lucide-arrow-right"]="rbxassetid://10709768347",
	["lucide-arrow-up"]="rbxassetid://10709768939",
	["lucide-bell"]="rbxassetid://10709775704",
	["lucide-bot"]="rbxassetid://10709782230",
	["lucide-box"]="rbxassetid://10709782497",
	["lucide-calendar"]="rbxassetid://10709789505",
	["lucide-check"]="rbxassetid://10709790644",
	["lucide-chevron-down"]="rbxassetid://10709790948",
	["lucide-chevron-right"]="rbxassetid://10709791437",
	["lucide-clock"]="rbxassetid://10709805144",
	["lucide-cog"]="rbxassetid://10709810948",
	["lucide-copy"]="rbxassetid://10709812159",
	["lucide-crown"]="rbxassetid://10709818626",
	["lucide-database"]="rbxassetid://10709818996",
	["lucide-download"]="rbxassetid://10723344270",
	["lucide-edit"]="rbxassetid://10734883598",
	["lucide-eye"]="rbxassetid://10723346959",
	["lucide-flag"]="rbxassetid://10723375890",
	["lucide-flame"]="rbxassetid://10723376114",
	["lucide-folder"]="rbxassetid://10723387563",
	["lucide-gamepad"]="rbxassetid://10723395457",
	["lucide-gem"]="rbxassetid://10723396000",
	["lucide-ghost"]="rbxassetid://10723396107",
	["lucide-globe"]="rbxassetid://10723404337",
	["lucide-heart"]="rbxassetid://10723406885",
	["lucide-home"]="rbxassetid://10723407389",
	["lucide-info"]="rbxassetid://10723415903",
	["lucide-key"]="rbxassetid://10723416652",
	["lucide-layers"]="rbxassetid://10723424505",
	["lucide-layout-dashboard"]="rbxassetid://10723424646",
	["lucide-lock"]="rbxassetid://10723434711",
	["lucide-mail"]="rbxassetid://10734885430",
	["lucide-map-pin"]="rbxassetid://10734886004",
	["lucide-maximize"]="rbxassetid://10734886735",
	["lucide-menu"]="rbxassetid://10734887784",
	["lucide-mic"]="rbxassetid://10734888864",
	["lucide-minimize"]="rbxassetid://10734895698",
	["lucide-minus"]="rbxassetid://10734896206",
	["lucide-moon"]="rbxassetid://10734897102",
	["lucide-music"]="rbxassetid://10734905958",
	["lucide-package"]="rbxassetid://10734909540",
	["lucide-pencil"]="rbxassetid://10734919691",
	["lucide-phone"]="rbxassetid://10734921524",
	["lucide-play"]="rbxassetid://10734923549",
	["lucide-plus"]="rbxassetid://10734924532",
	["lucide-power"]="rbxassetid://10734930466",
	["lucide-rocket"]="rbxassetid://10734934585",
	["lucide-save"]="rbxassetid://10734941499",
	["lucide-search"]="rbxassetid://10734943674",
	["lucide-settings"]="rbxassetid://10734950309",
	["lucide-share"]="rbxassetid://10734950813",
	["lucide-shield"]="rbxassetid://10734951847",
	["lucide-skull"]="rbxassetid://10734962068",
	["lucide-sliders"]="rbxassetid://10734963400",
	["lucide-smartphone"]="rbxassetid://10734963940",
	["lucide-star"]="rbxassetid://10734966248",
	["lucide-sun"]="rbxassetid://10734974297",
	["lucide-sword"]="rbxassetid://10734975486",
	["lucide-swords"]="rbxassetid://10734975692",
	["lucide-tag"]="rbxassetid://10734976528",
	["lucide-target"]="rbxassetid://10734977012",
	["lucide-terminal"]="rbxassetid://10734982144",
	["lucide-timer"]="rbxassetid://10734984606",
	["lucide-toggle-right"]="rbxassetid://10734985040",
	["lucide-trash"]="rbxassetid://10747362393",
	["lucide-trending-up"]="rbxassetid://10747363465",
	["lucide-trophy"]="rbxassetid://10747363809",
	["lucide-user"]="rbxassetid://10747373176",
	["lucide-users"]="rbxassetid://10747373426",
	["lucide-video"]="rbxassetid://10747374938",
	["lucide-wifi"]="rbxassetid://10747382504",
	["lucide-wrench"]="rbxassetid://10747383470",
	["lucide-x"]="rbxassetid://10747384394",
	["lucide-zap"]="rbxassetid://10723345749",
	["lucide-cat"]="rbxassetid://16935650691",
	["lucide-bot-2"]="rbxassetid://10709782230",
	["lucide-webhook"]="rbxassetid://17320556264",
}
function Library:GetIcon(Name)
	if Name ~= nil then
		if string.find(tostring(Name),"rbxassetid://") then return Name end
		local n = tonumber(Name)
		if n then return "rbxassetid://"..n end
		if Icons["lucide-"..Name] then return Icons["lucide-"..Name] end
	end
	return nil
end

-- ============ SAVE/INTERFACE MANAGERS ============
if RunService:IsStudio() then
	makefolder  = function(...) return ... end
	makefile    = function(...) return ... end
	isfile      = function(...) return false end
	isfolder    = function(...) return false end
	readfile    = function(...) return "" end
	writefile   = function(...) end
	listfiles   = function(...) return {} end
end

local SaveManager = {} do
	SaveManager.Folder = "FluentSettings"
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle    = { Save=function(i,o) return{type="Toggle",idx=i,value=o.Value} end,
					  Load=function(i,d) if SaveManager.Options[i] then SaveManager.Options[i]:SetValue(d.value) end end },
		Slider    = { Save=function(i,o) return{type="Slider",idx=i,value=tostring(o.Value)} end,
					  Load=function(i,d) if SaveManager.Options[i] then SaveManager.Options[i]:SetValue(d.value) end end },
		Dropdown  = { Save=function(i,o) return{type="Dropdown",idx=i,value=o.Value,multi=o.Multi} end,
					  Load=function(i,d) if SaveManager.Options[i] then SaveManager.Options[i]:SetValue(d.value) end end },
		Colorpicker={Save=function(i,o) return{type="Colorpicker",idx=i,value=o.Value:ToHex(),transparency=o.Transparency} end,
					  Load=function(i,d) if SaveManager.Options[i] then SaveManager.Options[i]:SetValueRGB(Color3.fromHex(d.value),d.transparency) end end },
		Keybind   = { Save=function(i,o) return{type="Keybind",idx=i,mode=o.Mode,key=o.Value} end,
					  Load=function(i,d) if SaveManager.Options[i] then SaveManager.Options[i]:SetValue(d.key,d.mode) end end },
		Input     = { Save=function(i,o) return{type="Input",idx=i,text=o.Value} end,
					  Load=function(i,d) if SaveManager.Options[i] and type(d.text)=="string" then SaveManager.Options[i]:SetValue(d.text) end end },
	}
	function SaveManager:SetIgnoreIndexes(l) for _,k in next,l do self.Ignore[k]=true end end
	function SaveManager:SetFolder(f) self.Folder=f; self:BuildFolderTree() end
	function SaveManager:Save(Name)
		if not Name then return false,"no config selected" end
		local data={objects={}}
		for idx,opt in next,SaveManager.Options do
			if not self.Parser[opt.Type] then continue end
			if self.Ignore[idx] then continue end
			table.insert(data.objects, self.Parser[opt.Type].Save(idx,opt))
		end
		local ok,enc=pcall(httpService.JSONEncode,httpService,data)
		if not ok then return false,"encode error" end
		writefile(Name,enc); return true
	end
	function SaveManager:Load(name)
		if not name then return false,"no config selected" end
		if not isfile(name) then return false,"file not found" end
		local ok,dec=pcall(httpService.JSONDecode,httpService,readfile(name))
		if not ok then return false,"decode error" end
		for _,opt in next,dec.objects do
			if self.Parser[opt.type] and not self.Ignore[opt.idx] then
				task.spawn(function() self.Parser[opt.type].Load(opt.idx,opt) end)
			end
		end
		return true
	end
	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({"InterfaceTheme","AcrylicToggle","TransparentToggle","MenuKeybind"})
	end
	function SaveManager:BuildFolderTree()
		for _,p in ipairs({self.Folder, self.Folder.."/"}) do
			if not isfolder(p) then makefolder(p) end
		end
	end
	function SaveManager:RefreshConfigList()
		local list=listfiles(self.Folder.."/"); local out={}
		for _,f in ipairs(list) do
			if f:sub(-5)==".json" then
				local pos=f:find(".json",1,true); local s=pos
				local char=f:sub(pos,pos)
				while char~="/" and char~="\\" and char~="" do pos=pos-1; char=f:sub(pos,pos) end
				if char=="/" or char=="\\" then
					local n=f:sub(pos+1,s-1)
					if n~="options" then table.insert(out,n) end
				end
			end
		end
		return out
	end
	function SaveManager:SetLibrary(lib) self.Library=lib; self.Options=lib.Options end
	function SaveManager:LoadAutoloadConfig()
		if isfile(self.Folder.."/autoload.txt") then
			local name=readfile(self.Folder.."/autoload.txt")
			local ok,err=self:Load(name)
			if not ok then
				return self.Library:Notify({Title="Interface",Content="Config loader",SubContent="Failed autoload: "..err,Duration=7})
			end
			self.Library:Notify({Title="Interface",Content="Config loader",SubContent=('Auto loaded "%s"'):format(name),Duration=7})
		end
	end
	function SaveManager:BuildConfigSection(tab)
		assert(self.Library,"Must set SaveManager.Library")
		local section=tab:AddSection("Configuration")
		section:AddInput("SaveManager_ConfigName",{Title="Config name"})
		section:AddDropdown("SaveManager_ConfigList",{Title="Config list",Values=self:RefreshConfigList(),AllowNull=true})
		section:AddButton({Title="Create config",Callback=function()
			local name=SaveManager.Options.SaveManager_ConfigName.Value
			if name:gsub(" ","")=="" then
				return self.Library:Notify({Title="Interface",Content="Config loader",SubContent="Invalid config name",Duration=7})
			end
			local ok,err=self:Save(name)
			if not ok then return self.Library:Notify({Title="Interface",Content="Config loader",SubContent="Failed: "..err,Duration=7}) end
			self.Library:Notify({Title="Interface",Content="Config loader",SubContent=('Created "%s"'):format(name),Duration=7})
			SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
		end})
		section:AddButton({Title="Load config",Callback=function()
			local name=SaveManager.Options.SaveManager_ConfigList.Value
			local ok,err=self:Load(name)
			if not ok then return self.Library:Notify({Title="Interface",Content="Config loader",SubContent="Failed: "..err,Duration=7}) end
			self.Library:Notify({Title="Interface",Content="Config loader",SubContent=('Loaded "%s"'):format(name),Duration=7})
		end})
		section:AddButton({Title="Save config",Callback=function()
			local name=SaveManager.Options.SaveManager_ConfigList.Value
			local ok,err=self:Save(name)
			if not ok then return self.Library:Notify({Title="Interface",Content="Config loader",SubContent="Failed: "..err,Duration=7}) end
			self.Library:Notify({Title="Interface",Content="Config loader",SubContent=('Saved "%s"'):format(name),Duration=7})
		end})
		section:AddButton({Title="Refresh list",Callback=function()
			SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
		end})
		local AutoBtn
		AutoBtn=section:AddButton({Title="Set autoload",Description="Autoload: none",Callback=function()
			local name=SaveManager.Options.SaveManager_ConfigList.Value
			writefile(self.Folder.."/autoload.txt",name)
			AutoBtn:SetDesc("Autoload: "..name)
			self.Library:Notify({Title="Interface",Content="Config loader",SubContent=('Set "%s" as autoload'):format(name),Duration=7})
		end})
		if isfile(self.Folder.."/autoload.txt") then
			AutoBtn:SetDesc("Autoload: "..readfile(self.Folder.."/autoload.txt"))
		end
		SaveManager:SetIgnoreIndexes({"SaveManager_ConfigList","SaveManager_ConfigName"})
	end
end

local InterfaceManager = {} do
	InterfaceManager.Folder = "Cyrus_Hub_X_Config"
	InterfaceManager.Settings = { Acrylic=true, Transparency=true, MenuKeybind="M" }
	function InterfaceManager:SetTheme(n) InterfaceManager.Settings.Theme=n end
	function InterfaceManager:SetFolder(f) self.Folder=f; self:BuildFolderTree() end
	function InterfaceManager:SetLibrary(lib) self.Library=lib end
	function InterfaceManager:BuildFolderTree()
		local paths={}
		local parts=self.Folder:split("/")
		for i=1,#parts do paths[#paths+1]=table.concat(parts,"/",1,i) end
		table.insert(paths,self.Folder); table.insert(paths,self.Folder.."/")
		for _,s in ipairs(paths) do if not isfolder(s) then makefolder(s) end end
	end
	function InterfaceManager:SaveSettings()
		writefile(self.Folder.."/options.json", httpService:JSONEncode(InterfaceManager.Settings))
	end
	function InterfaceManager:LoadSettings()
		local p=self.Folder.."/options.json"
		if isfile(p) then
			local ok,dec=pcall(httpService.JSONDecode,httpService,readfile(p))
			if ok then for k,v in next,dec do InterfaceManager.Settings[k]=v end end
		end
	end
	function InterfaceManager:BuildInterfaceSection(tab)
		assert(self.Library,"Must set InterfaceManager.Library")
		local Lib=self.Library; local S=InterfaceManager.Settings
		InterfaceManager:LoadSettings()
		local section=tab:AddSection("Interface")
		local ThemeDrop=section:AddDropdown("InterfaceTheme",{
			Title="Theme", Description="Changes the interface theme.",
			Values=Lib.Themes, Default=Lib.Theme,
			Callback=function(v) Lib:SetTheme(v); S.Theme=v; InterfaceManager:SaveSettings() end
		})
		ThemeDrop:SetValue(S.Theme)
		if Lib.UseAcrylic then
			section:AddToggle("AcrylicToggle",{
				Title="Acrylic", Description="Requires graphic quality 8+",
				Default=S.Acrylic,
				Callback=function(v) Lib:ToggleAcrylic(v); S.Acrylic=v; InterfaceManager:SaveSettings() end
			})
		end
		section:AddToggle("TransparentToggle",{
			Title="Transparency", Description="Makes the interface transparent.",
			Default=S.Transparency,
			Callback=function(v) Lib:ToggleTransparency(v); S.Transparency=v; InterfaceManager:SaveSettings() end
		})
		local MKB=section:AddKeybind("MenuKeybind",{Title="Minimize Bind",Default=S.MenuKeybind})
		MKB:OnChanged(function() S.MenuKeybind=MKB.Value; InterfaceManager:SaveSettings() end)
		Lib.MinimizeKeybind=MKB
	end
end

-- ============ LIBRARY MAIN FUNCTIONS ============
function Library:CreateWindow(Config)
	assert(Config.Title,"Window - Missing Title")
	if Library.Window then print("Cannot create more than one window."); return end
	Library.UseAcrylic = Config.Acrylic or false
	Library.Acrylic    = Config.Acrylic or false
	Library.Theme      = Config.Theme or "CyrusHubX"
	if Config.Acrylic then Acrylic.init() end
	local W = Components.Window({
		Parent=GUI, Size=Config.Size, Title=Config.Title,
		SubTitle=Config.SubTitle, TabWidth=Config.TabWidth,
	})
	Library.Window=W
	InterfaceManager:SetTheme(Config.Theme)
	Library:SetTheme(Config.Theme)
	return W
end

function Library:SetTheme(v)
	if Library.Window and table.find(Library.Themes,v) then
		Library.Theme=v; Creator.UpdateTheme()
	end
end
function Library:Destroy()
	if Library.Window then
		Library.Unloaded=true
		if Library.UseAcrylic then Library.Window.AcrylicPaint.Model:Destroy() end
		Creator.Disconnect(); Library.GUI:Destroy()
	end
end
function Library:ToggleAcrylic(v)
	if Library.Window and Library.UseAcrylic then
		Library.Acrylic=v
		Library.Window.AcrylicPaint.Model.Transparency=v and 0.98 or 1
		if v then Acrylic.Enable() else Acrylic.Disable() end
	end
end
function Library:ToggleTransparency(v)
	if Library.Window then
		Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency=v and 0.35 or 0
	end
end
function Library:Notify(Config)
	return NotificationModule:New(Config)
end

if getgenv then getgenv().Fluent=Library else Fluent=Library end

return Library, SaveManager, InterfaceManager
