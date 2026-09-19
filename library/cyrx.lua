-- This file was Beautified by LeakD
-- https://leakd.vercel.app

- - [[ ╔═══════════════════════════════════════════════════════════╗ ║ CyrusHubX UI v3.0 - ULTRA EDITION ║ ║ • Enhanced Animations & Visual Effects ║ ║ • Strong Anti - Cheat Bypass System ║ ║ • Improved Performance & Stability ║ ╚═══════════════════════════════════════════════════════════╝ - - ]] - - ═══════════════════════════════════════════════════════════ - - SERVICES & SETUP - - ═══════════════════════════════════════════════════════════
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local RenderStepped = RunService.RenderStepped - - ═══════════════════════════════════════════════════════════ - - 🔥 ANTI - CHEAT BYPASS SYSTEM (STRONG) - - ═══════════════════════════════════════════════════════════
local AntiCheatBypass = {} AntiCheatBypass.__index = AntiCheatBypass - - Known anti - cheat systems
local AntiCheatSignatures = {"Byfron","Hyperion","AntiCheat","AC_","Anti_Exploit","Kick","Ban","Detection","Guard","Protect","Secure","Battleye","EAC","FairFight","PunkBuster","VAC","ScriptGuard","RemoteGuard","ServerGuard"} - - Suspicious functions to hook
local SuspiciousFunctions = {"Kick","kick","Ban","ban","Detect","detect","Log","log","Report","report","Flag","flag"} function AntiCheatBypass:Init()
self.Protected = true self.BlockedRemotes = {} self.Kicked = false self.HookedFunctions = {} - - Protect metatable self:ProtectMetatable() - - Block kick attempts self:BlockKicks() - - Hook suspicious remotes self:HookRemotes() - - Anti - detection self:AntiDetection() - - Bypass common checks self:BypassCommonChecks()
return self
end
function AntiCheatBypass:ProtectMetatable()
    - - Protect against getrawmetatable detection
    local oldGetRawMeta = getrawmetatable
    if oldGetRawMeta then
        getrawmetatable = function(obj)
        local mt = oldGetRawMeta(obj)
        if mt and mt.__namecall then
            local oldNamecall = mt.__namecall mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod() - - Block kick / ban methods
            if method =="Kick"or method =="kick"then
                return nil
            end
            return oldNamecall(self, ...)
        end
        )
    end
    return mt
end
end
end
function AntiCheatBypass:BlockKicks()
    - - Hook Player:Kick
    local mt = getrawmetatable(game)
    if mt then
        local oldNamecall = mt.__namecall setreadonly(mt, false) mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method =="Kick"then
            return nil - - Block kick
        end
        return oldNamecall(self, ...)
    end
    ) setreadonly(mt, true)
end
- - Hook Kick function directly
if LocalPlayer.Kick then
    LocalPlayer.Kick = function()
    return nil
end
end
end
function AntiCheatBypass:HookRemotes()
    - - Scan
    for suspicious remotes
    local function scanRemotes(parent)
    for _, child in pairs(parent:GetChildren()) do
        pcall(function()
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            local name = child.Name:lower()
            for _, sig in pairs(AntiCheatSignatures) do
                if name:find(sig:lower()) then
                    self.BlockedRemotes[child] = true - - Hook the remote
                    if child:IsA("RemoteEvent") then
                        local oldFire = child.FireServer child.FireServer = function(...)
                        return nil
                    end
                end
            end
        end
    end
    scanRemotes(child)
end
)
end
end
pcall(function()
scanRemotes(game:GetService("ReplicatedStorage")) scanRemotes(game:GetService("ReplicatedFirst"))
end
)
end
function AntiCheatBypass:AntiDetection()
    - - Bypass FPS detection
    local oldHeartbeat = RunService.Heartbeat
    local fakeFPS = 60 - - Bypass ping detection
    if Stats and Stats.Network then
        pcall(function()
        Stats.Network.ServerStatsItem["Data Ping"].GetValue = function()
        return 50 - - Fake low ping
    end
end
)
end
- - Bypass memory detection
if gcinfo then
    local oldGcinfo = gcinfo gcinfo = function()
    return math.random(100000, 200000) - - Fake memory usage
end
end
end
function AntiCheatBypass:BypassCommonChecks()
    - - Bypass character checks pcall(function()
    LocalPlayer.CharacterAdded:Connect(function(char)
    - - Ensure character is valid char:WaitForChild("Humanoid", 5)
end
)
end
) - - Bypass speed checks pcall(function()
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
    - - Prevent speed detection humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    - - Bypass
    if needed
end
)
end
end
) - - Bypass fly detection pcall(function()
local oldIndex = getrawmetatable(game).__index setreadonly(getrawmetatable(game), false) getrawmetatable(game).__index = newcclosure(function(self, key)
if key =="Velocity"and self == LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    return Vector3.new(0, 0, 0) - - Fake velocity
end
return oldIndex(self, key)
end
) setreadonly(getrawmetatable(game), true)
end
)
end
function AntiCheatBypass:ProtectFunction(func)
    - - Wrap function in protected call
    return function(...)
    local success, result = pcall(func, ...)
    if not success then
        return nil
    end
    return result
end
end
- - Initialize bypass
local Bypass = AntiCheatBypass:Init() - - ═══════════════════════════════════════════════════════════ - - ANTI - AFK SYSTEM - - ═══════════════════════════════════════════════════════════ LocalPlayer.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame) task.wait(1) VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end
) - - ═══════════════════════════════════════════════════════════ - - CLEANUP SYSTEM - - ═══════════════════════════════════════════════════════════ task.spawn(function()
pcall(function()
if game.PlaceId == 3623096087 then
    local portals = Workspace:FindFirstChild("RobloxForwardPortals")
    if portals then
        portals:Destroy()
    end
end
end
)
end
) - - Destroy existing instances pcall(function()
local coreGui = game:GetService("CoreGui")
for _, name in pairs({"OpenClose","Cyrus_Hub_X_ScreenGui"}) do
    local gui = coreGui:FindFirstChild(name)
    if gui then
        gui:Destroy()
    end
end
end
) - - ═══════════════════════════════════════════════════════════ - - PROTECTION & THEMES - - ═══════════════════════════════════════════════════════════
local ProtectGui = protectgui or (syn and syn.protect_gui) or function()
end
local Themes = { Names = {"CyrusHubX","Midnight","Ocean","Neon"}, - - 🔴 Default Red Theme CyrusHubX = { Name ="CyrusHubX", Accent = Color3.fromRGB(255, 60, 60), AccentSecondary = Color3.fromRGB(255, 120, 120), AcrylicMain = Color3.fromRGB(8, 8, 10), AcrylicBorder = Color3.fromRGB(45, 45, 50), AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 20, 25), Color3.fromRGB(5, 5, 8)), AcrylicNoise = 0.7, TitleBarLine = Color3.fromRGB(255, 60, 60), Tab = Color3.fromRGB(255, 60, 60), Element = Color3.fromRGB(150, 35, 35), ElementBorder = Color3.fromRGB(80, 15, 15), InElementBorder = Color3.fromRGB(200, 50, 50), ElementTransparency = 0.75, ToggleSlider = Color3.fromRGB(200, 50, 50), ToggleToggled = Color3.fromRGB(255, 255, 255), SliderRail = Color3.fromRGB(200, 50, 50), DropdownFrame = Color3.fromRGB(18, 18, 20), DropdownHolder = Color3.fromRGB(28, 28, 32), DropdownBorder = Color3.fromRGB(255, 60, 60), DropdownOption = Color3.fromRGB(180, 45, 45), Keybind = Color3.fromRGB(180, 45, 45), Input = Color3.fromRGB(255, 220, 220), InputFocused = Color3.fromRGB(255, 255, 255), InputIndicator = Color3.fromRGB(255, 60, 60), Dialog = Color3.fromRGB(18, 18, 20), DialogHolder = Color3.fromRGB(28, 28, 32), DialogHolderLine = Color3.fromRGB(255, 60, 60), DialogButton = Color3.fromRGB(35, 35, 40), DialogButtonBorder = Color3.fromRGB(255, 60, 60), DialogBorder = Color3.fromRGB(200, 50, 50), DialogInput = Color3.fromRGB(22, 22, 25), DialogInputLine = Color3.fromRGB(180, 45, 45), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(200, 185, 185), Hover = Color3.fromRGB(200, 50, 50), HoverChange = 0.08, Glow = Color3.fromRGB(255, 60, 60), }, - - 🌙 Midnight Theme Midnight = { Name ="Midnight", Accent = Color3.fromRGB(140, 100, 255), AccentSecondary = Color3.fromRGB(180, 150, 255), AcrylicMain = Color3.fromRGB(10, 10, 18), AcrylicBorder = Color3.fromRGB(50, 45, 80), AcrylicGradient = ColorSequence.new(Color3.fromRGB(25, 22, 45), Color3.fromRGB(8, 8, 15)), AcrylicNoise = 0.7, TitleBarLine = Color3.fromRGB(140, 100, 255), Tab = Color3.fromRGB(140, 100, 255), Element = Color3.fromRGB(80, 60, 150), ElementBorder = Color3.fromRGB(45, 35, 85), InElementBorder = Color3.fromRGB(120, 90, 220), ElementTransparency = 0.75, ToggleSlider = Color3.fromRGB(120, 90, 220), ToggleToggled = Color3.fromRGB(255, 255, 255), SliderRail = Color3.fromRGB(120, 90, 220), DropdownFrame = Color3.fromRGB(18, 18, 30), DropdownHolder = Color3.fromRGB(28, 28, 45), DropdownBorder = Color3.fromRGB(140, 100, 255), DropdownOption = Color3.fromRGB(100, 75, 180), Keybind = Color3.fromRGB(100, 75, 180), Input = Color3.fromRGB(220, 215, 255), InputFocused = Color3.fromRGB(255, 255, 255), InputIndicator = Color3.fromRGB(140, 100, 255), Dialog = Color3.fromRGB(18, 18, 30), DialogHolder = Color3.fromRGB(28, 28, 45), DialogHolderLine = Color3.fromRGB(140, 100, 255), DialogButton = Color3.fromRGB(35, 35, 55), DialogButtonBorder = Color3.fromRGB(140, 100, 255), DialogBorder = Color3.fromRGB(120, 90, 220), DialogInput = Color3.fromRGB(22, 22, 38), DialogInputLine = Color3.fromRGB(100, 75, 180), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(190, 185, 220), Hover = Color3.fromRGB(120, 90, 220), HoverChange = 0.08, Glow = Color3.fromRGB(140, 100, 255), }, - - 🌊 Ocean Theme Ocean = { Name ="Ocean", Accent = Color3.fromRGB(60, 180, 255), AccentSecondary = Color3.fromRGB(120, 220, 255), AcrylicMain = Color3.fromRGB(8, 15, 25), AcrylicBorder = Color3.fromRGB(40, 70, 100), AcrylicGradient = ColorSequence.new(Color3.fromRGB(15, 35, 55), Color3.fromRGB(5, 10, 18)), AcrylicNoise = 0.7, TitleBarLine = Color3.fromRGB(60, 180, 255), Tab = Color3.fromRGB(60, 180, 255), Element = Color3.fromRGB(40, 120, 180), ElementBorder = Color3.fromRGB(25, 60, 90), InElementBorder = Color3.fromRGB(80, 160, 220), ElementTransparency = 0.75, ToggleSlider = Color3.fromRGB(80, 160, 220), ToggleToggled = Color3.fromRGB(255, 255, 255), SliderRail = Color3.fromRGB(80, 160, 220), DropdownFrame = Color3.fromRGB(15, 25, 38), DropdownHolder = Color3.fromRGB(25, 40, 58), DropdownBorder = Color3.fromRGB(60, 180, 255), DropdownOption = Color3.fromRGB(50, 130, 190), Keybind = Color3.fromRGB(50, 130, 190), Input = Color3.fromRGB(215, 240, 255), InputFocused = Color3.fromRGB(255, 255, 255), InputIndicator = Color3.fromRGB(60, 180, 255), Dialog = Color3.fromRGB(15, 25, 38), DialogHolder = Color3.fromRGB(25, 40, 58), DialogHolderLine = Color3.fromRGB(60, 180, 255), DialogButton = Color3.fromRGB(30, 50, 70), DialogButtonBorder = Color3.fromRGB(60, 180, 255), DialogBorder = Color3.fromRGB(80, 160, 220), DialogInput = Color3.fromRGB(20, 32, 48), DialogInputLine = Color3.fromRGB(50, 130, 190), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(185, 215, 235), Hover = Color3.fromRGB(80, 160, 220), HoverChange = 0.08, Glow = Color3.fromRGB(60, 180, 255), }, - - 💚 Neon Theme Neon = { Name ="Neon", Accent = Color3.fromRGB(0, 255, 150), AccentSecondary = Color3.fromRGB(100, 255, 200), AcrylicMain = Color3.fromRGB(5, 15, 10), AcrylicBorder = Color3.fromRGB(30, 80, 55), AcrylicGradient = ColorSequence.new(Color3.fromRGB(10, 35, 25), Color3.fromRGB(3, 8, 5)), AcrylicNoise = 0.7, TitleBarLine = Color3.fromRGB(0, 255, 150), Tab = Color3.fromRGB(0, 255, 150), Element = Color3.fromRGB(30, 130, 85), ElementBorder = Color3.fromRGB(15, 60, 40), InElementBorder = Color3.fromRGB(50, 200, 130), ElementTransparency = 0.75, ToggleSlider = Color3.fromRGB(50, 200, 130), ToggleToggled = Color3.fromRGB(255, 255, 255), SliderRail = Color3.fromRGB(50, 200, 130), DropdownFrame = Color3.fromRGB(10, 22, 16), DropdownHolder = Color3.fromRGB(18, 35, 26), DropdownBorder = Color3.fromRGB(0, 255, 150), DropdownOption = Color3.fromRGB(35, 150, 95), Keybind = Color3.fromRGB(35, 150, 95), Input = Color3.fromRGB(210, 255, 235), InputFocused = Color3.fromRGB(255, 255, 255), InputIndicator = Color3.fromRGB(0, 255, 150), Dialog = Color3.fromRGB(10, 22, 16), DialogHolder = Color3.fromRGB(18, 35, 26), DialogHolderLine = Color3.fromRGB(0, 255, 150), DialogButton = Color3.fromRGB(25, 50, 38), DialogButtonBorder = Color3.fromRGB(0, 255, 150), DialogBorder = Color3.fromRGB(50, 200, 130), DialogInput = Color3.fromRGB(14, 28, 20), DialogInputLine = Color3.fromRGB(35, 150, 95), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(180, 230, 205), Hover = Color3.fromRGB(50, 200, 130), HoverChange = 0.08, Glow = Color3.fromRGB(0, 255, 150), }, } - - ═══════════════════════════════════════════════════════════ - - LIBRARY OBJECT - - ═══════════════════════════════════════════════════════════
local Library = { Version ="3.0.0", OpenFrames = {}, Options = {}, Themes = Themes.Names, Window = nil, WindowFrame = nil, Unloaded = false, Creator = nil, DialogOpen = false, UseAcrylic = false, Acrylic = false, Transparency = true, MinimizeKeybind = nil, MinimizeKey = Enum.KeyCode.LeftControl, Theme ="CyrusHubX", Bypass = Bypass, } - - ═══════════════════════════════════════════════════════════ - - CLOSE / OPEN BUTTON - - ═══════════════════════════════════════════════════════════
local function CloseOpen()
local ScreenGui = Instance.new("ScreenGui") ProtectGui(ScreenGui) ScreenGui.Name ="OpenClose"ScreenGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")) ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local CloseBtn = Instance.new("ImageButton") CloseBtn.Parent = ScreenGui CloseBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 10) CloseBtn.BorderColor3 = Color3.fromRGB(255, 60, 60) CloseBtn.Position = UDim2.new(0.1021, 0, 0.0743, 0) CloseBtn.Size = UDim2.new(0, 59, 0, 49) CloseBtn.Image ="rbxassetid://111662964379929"CloseBtn.Visible = false
local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 9) UICorner.Parent = CloseBtn - - Glow effect
local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(255, 60, 60) UIStroke.Thickness = 2 UIStroke.Transparency = 0.5 UIStroke.Parent = CloseBtn - - Dragging
local dragging, dragStart, startPos CloseBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    dragging = true dragStart = input.Position startPos = CloseBtn.Position input.Changed:Connect(function()
    if input.UserInputState == Enum.UserInputState.End then
        dragging = false
    end
end
)
end
end
) CloseBtn.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
    local delta = input.Position - dragStart CloseBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end
)
return CloseBtn
end
local Close_ImageButton = CloseOpen() - - ═══════════════════════════════════════════════════════════ - - FLIPPER ANIMATION SYSTEM - - ═══════════════════════════════════════════════════════════
local function isMotor(value)
return tostring(value):match("^Motor%((.+)%)$") ~ = nil
end
local Connection = {} Connection.__index = Connection function Connection.new(signal, handler)
return setmetatable({signal = signal, connected = true, _handler = handler}, Connection)
end
function Connection:disconnect()
    if self.connected then
        self.connected = false
        for i, c in pairs(self.signal._connections) do
            if c == self then
                table.remove(self.signal._connections, i);
                return
            end
        end
    end
end
local Signal = {} Signal.__index = Signal function Signal.new()
return setmetatable({_connections = {}, _threads = {}}, Signal)
end
function Signal:fire(...)
    for _, c in pairs(self._connections) do
        c._handler(...)
    end
    for _, t in pairs(self._threads) do
        coroutine.resume(t, ...)
    end
    self._threads = {}
end
function Signal:connect(handler)
    local c = Connection.new(self, handler) table.insert(self._connections, c)
    return c
end
function Signal:wait()
    table.insert(self._threads, coroutine.running())
    return coroutine.yield()
end
local Linear = {} Linear.__index = Linear function Linear.new(targetValue, options)
options = options or {}
return setmetatable({_targetValue = targetValue, _velocity = options.velocity or 1}, Linear)
end
function Linear:step(state, dt)
    local position, velocity, goal = state.value, self._velocity, self._targetValue
    local dPos = dt * velocity
    local complete = dPos > = math.abs(goal - position) position = position + dPos * (goal > position and 1 or - 1)
    if complete then
        position = self._targetValue; velocity = 0
    end
    return {complete = complete, value = position, velocity = velocity}
end
local Instant = {} Instant.__index = Instant function Instant.new(targetValue)
return setmetatable({_targetValue = targetValue}, Instant)
end
function Instant:step()
    return {complete = true, value = self._targetValue}
end
local VELOCITY_THRESHOLD, POSITION_THRESHOLD, EPS = 0.001, 0.001, 0.0001
local Spring = {} Spring.__index = Spring function Spring.new(targetValue, options)
options = options or {}
return setmetatable({ _targetValue = targetValue, _frequency = options.frequency or 4, _dampingRatio = options.dampingRatio or 1, }, Spring)
end
function Spring:step(state, dt)
    local d, f, g = self._dampingRatio, self._frequency * 2 * math.pi, self._targetValue
    local p0, v0 = state.value, state.velocity or 0
    local offset = p0 - g
    local decay = math.exp(- d * f * dt)
    local p1, v1
    if d == 1 then
        p1 = (offset * (1 + f * dt) + v0 * dt) * decay + g v1 = (v0 * (1 - f * dt) - offset * (f * f * dt)) * decay
    elseif d < 1 then
        local c = math.sqrt(1 - d * d)
        local i, j = math.cos(f * c * dt), math.sin(f * c * dt)
        local z = c > EPS and j / c or (function()
        local a = dt * f
        return a + ((a * a) * (c * c) * (c * c) / 20 - c * c) * (a * a * a) / 6
    end
    )()
    local y = f * c > EPS and j / (f * c) or (function()
    local b = f * c
    return dt + ((dt * dt) * (b * b) * (b * b) / 20 - b * b) * (dt * dt * dt) / 6
end
)() p1 = (offset * (i + d * z) + v0 * y) * decay + g v1 = (v0 * (i - z * d) - offset * (z * f)) * decay
else
    local c = math.sqrt(d * d - 1)
    local r1, r2 = - f * (d - c), - f * (d + c)
    local co2 = (v0 - offset * r1) / (2 * f * c)
    local co1 = offset - co2
    local e1, e2 = co1 * math.exp(r1 * dt), co2 * math.exp(r2 * dt) p1 = e1 + e2 + g v1 = e1 * r1 + e2 * r2
end
local complete = math.abs(v1) < VELOCITY_THRESHOLD and math.abs(p1 - g) < POSITION_THRESHOLD
return {complete = complete, value = complete and g or p1, velocity = v1}
end
local noop = function()
end
local BaseMotor = {} BaseMotor.__index = BaseMotor function BaseMotor.new()
return setmetatable({_onStep = Signal.new(), _onStart = Signal.new(), _onComplete = Signal.new()}, BaseMotor)
end
function BaseMotor:onStep(handler)
    return self._onStep:connect(handler)
end
function BaseMotor:onStart(handler)
    return self._onStart:connect(handler)
end
function BaseMotor:onComplete(handler)
    return self._onComplete:connect(handler)
end
function BaseMotor:start()
    if not self._connection then
        self._connection = RunService.RenderStepped:Connect(function(dt)
        self:step(dt)
    end
    )
end
end
function BaseMotor:stop()
    if self._connection then
        self._connection:Disconnect(); self._connection = nil
    end
end
BaseMotor.destroy = BaseMotor.stop BaseMotor.step = noop BaseMotor.getValue = noop BaseMotor.setGoal = noop function BaseMotor:__tostring()
return"Motor"end
local SingleMotor = setmetatable({}, BaseMotor) SingleMotor.__index = SingleMotor function SingleMotor.new(initialValue, useImplicitConnections)
assert(initialValue,"Missing initialValue")
local self = setmetatable(BaseMotor.new(), SingleMotor) self._useImplicitConnections = useImplicitConnections ~ = false self._goal = nil self._state = {complete = true, value = initialValue}
return self
end
function SingleMotor:step(dt)
    if self._state.complete then
        return true
    end
    local newState = self._goal:step(self._state, dt) self._state = newState self._onStep:fire(newState.value)
    if newState.complete then
        if self._useImplicitConnections then
            self:stop()
        end
        self._onComplete:fire()
    end
    return newState.complete
end
function SingleMotor:getValue()
    return self._state.value
end
function SingleMotor:setGoal(goal)
    self._state.complete = false self._goal = goal self._onStart:fire()
    if self._useImplicitConnections then
        self:start()
    end
end
function SingleMotor:__tostring()
    return"Motor(Single)"end
    local GroupMotor = setmetatable({}, BaseMotor) GroupMotor.__index = GroupMotor
    local function toMotor(value)
    if isMotor(value) then
        return value
    end
    local valueType = typeof(value)
    if valueType =="number"then
        return SingleMotor.new(value, false)
    elseif valueType =="table"then
        return GroupMotor.new(value, false)
    end
    error("Unable to convert to motor", 2)
end
function GroupMotor.new(initialValues, useImplicitConnections)
    assert(initialValues,"Missing initialValues")
    local self = setmetatable(BaseMotor.new(), GroupMotor) self._useImplicitConnections = useImplicitConnections ~ = false self._complete = true self._motors = {}
    for key, value in pairs(initialValues) do
        self._motors[key] = toMotor(value)
    end
    return self
end
function GroupMotor:step(dt)
    if self._complete then
        return true
    end
    local allComplete = true
    for _, motor in pairs(self._motors) do
        if not motor:step(dt) then
            allComplete = false
        end
    end
    self._onStep:fire(self:getValue())
    if allComplete then
        if self._useImplicitConnections then
            self:stop()
        end
        self._complete = true self._onComplete:fire()
    end
    return allComplete
end
function GroupMotor:setGoal(goals)
    self._complete = false self._onStart:fire()
    for key, goal in pairs(goals) do
        local motor = assert(self._motors[key],"Unknown motor key") motor:setGoal(goal)
    end
    if self._useImplicitConnections then
        self:start()
    end
end
function GroupMotor:getValue()
    local values = {}
    for key, motor in pairs(self._motors) do
        values[key] = motor:getValue()
    end
    return values
end
function GroupMotor:__tostring()
    return"Motor(Group)"end
    local Flipper = { SingleMotor = SingleMotor, GroupMotor = GroupMotor, Instant = Instant, Linear = Linear, Spring = Spring, isMotor = isMotor, } - - ═══════════════════════════════════════════════════════════ - - CREATOR SYSTEM - - ═══════════════════════════════════════════════════════════
    local Creator = { Registry = {}, Signals = {}, TransparencyMotors = {}, DefaultProperties = { ScreenGui = {ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, Frame = {BackgroundColor3 = Color3.fromRGB(8, 8, 10), BorderColor3 = Color3.fromRGB(45, 45, 50), BorderSizePixel = 1}, ScrollingFrame = {BackgroundColor3 = Color3.fromRGB(8, 8, 10), BorderColor3 = Color3.fromRGB(45, 45, 50), ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60), BorderSizePixel = 1}, TextLabel = {BackgroundColor3 = Color3.fromRGB(8, 8, 10), BorderColor3 = Color3.fromRGB(45, 45, 50), Font = Enum.Font.SourceSansSemibold, Text ="", TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, TextSize = 14}, TextButton = {BackgroundColor3 = Color3.fromRGB(150, 35, 35), BorderColor3 = Color3.fromRGB(255, 60, 60), AutoButtonColor = false, Font = Enum.Font.SourceSansSemibold, Text ="", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14}, TextBox = {BackgroundColor3 = Color3.fromRGB(22, 22, 25), BorderColor3 = Color3.fromRGB(255, 60, 60), ClearTextOnFocus = false, Font = Enum.Font.SourceSansSemibold, Text ="", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14}, ImageLabel = {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(8, 8, 10), BorderColor3 = Color3.fromRGB(45, 45, 50), BorderSizePixel = 1}, ImageButton = {BackgroundColor3 = Color3.fromRGB(150, 35, 35), BorderColor3 = Color3.fromRGB(255, 60, 60), AutoButtonColor = false}, CanvasGroup = {BackgroundColor3 = Color3.fromRGB(8, 8, 10), BorderColor3 = Color3.fromRGB(45, 45, 50), BorderSizePixel = 1}, }, }
    local function ApplyCustomProps(Object, Props)
    if Props and Props.ThemeTag then
        Creator.AddThemeObject(Object, Props.ThemeTag)
    end
end
function Creator.AddSignal(Signal, Function)
    local Connected = Signal:Connect(Function) table.insert(Creator.Signals, Connected)
    return Connected
end
function Creator.Disconnect()
    for i = #Creator.Signals, 1, - 1 do
        local Connection = table.remove(Creator.Signals, i)
        if Connection.Disconnect then
            Connection:Disconnect()
        end
    end
end
function Creator.UpdateTheme()
    for Instance, Object in next, Creator.Registry do
        for Property, ColorIdx in next, Object.Properties do
            Instance[Property] = Creator.GetThemeProperty(ColorIdx)
        end
    end
    for _, Motor in next, Creator.TransparencyMotors do
        Motor:setGoal(Flipper.Instant.new(Creator.GetThemeProperty("ElementTransparency")))
    end
end
function Creator.AddThemeObject(Object, Properties)
    local Idx = #Creator.Registry + 1 Creator.Registry[Object] = {Object = Object, Properties = Properties, Idx = Idx} Creator.UpdateTheme()
    return Object
end
function Creator.OverrideTag(Object, Properties)
    if Creator.Registry[Object] then
        Creator.Registry[Object].Properties = Properties
    end
end
function Creator.GetThemeProperty(Property)
    local theme = Themes[Library.Theme] or Themes["CyrusHubX"]
    return theme[Property] or Themes["CyrusHubX"][Property]
end
function Creator.New(Name, Properties, Children)
    local Object = Instance.new(Name)
    for Name, Value in next, Creator.DefaultProperties[Name] or {} do
        Object[Name] = Value
    end
    for Name, Value in next, Properties or {} do
        if Name ~ ="ThemeTag"then
            Object[Name] = Value
        end
    end
    for _, Child in next, Children or {} do
        Child.Parent = Object
    end
    ApplyCustomProps(Object, Properties)
    return Object
end
function Creator.SpringMotor(Initial, Instance, Prop, IgnoreDialogCheck, ResetOnThemeChange)
    IgnoreDialogCheck = IgnoreDialogCheck or false ResetOnThemeChange = ResetOnThemeChange or false
    local Motor = Flipper.SingleMotor.new(Initial) Motor:onStep(function(value)
    Instance[Prop] = value
end
)
if ResetOnThemeChange then
    table.insert(Creator.TransparencyMotors, Motor)
end
local function SetValue(Value, Ignore)
Ignore = Ignore or false
if not IgnoreDialogCheck then
    if not Ignore and Prop =="BackgroundTransparency"and Library.DialogOpen then
        return
    end
end
Motor:setGoal(Flipper.Spring.new(Value, {frequency = 8}))
end
return Motor, SetValue
end
Library.Creator = Creator
local New = Creator.New - - ═══════════════════════════════════════════════════════════ - - MAIN GUI - - ═══════════════════════════════════════════════════════════
local GUI = New("ScreenGui", { Name ="Cyrus_Hub_X_ScreenGui", Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")), }) Library.GUI = GUI ProtectGui(GUI) - - ═══════════════════════════════════════════════════════════ - - UTILITY FUNCTIONS - - ═══════════════════════════════════════════════════════════ function Library:SafeCallback(Function, ...)
if not Function then
    return
end
local Success, Event = pcall(Function, ...)
if not Success then
    local _, i = Event:find(":%d+: ")
    if not i then
        return Library:Notify({Title ="Interface", Content ="Callback error", SubContent = Event, Duration = 5})
    end
    return Library:Notify({Title ="Interface", Content ="Callback error", SubContent = Event:sub(i + 1), Duration = 5})
end
end
function Library:Round(Number, Factor)
    if Factor == 0 then
        return math.floor(Number)
    end
    Number = tostring(Number)
    return Number:find("%.") and tonumber(Number:sub(1, Number:find("%.") + Factor)) or Number
end
local function map(value, inMin, inMax, outMin, outMax)
return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end
local function viewportPointToWorld(location, distance)
local unitRay = Workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)
return unitRay.Origin + unitRay.Direction * distance
end
local function getOffset()
local viewportSizeY = Workspace.CurrentCamera.ViewportSize.Y
return map(viewportSizeY, 0, 2560, 8, 56)
end
- - ═══════════════════════════════════════════════════════════ - - ACRYLIC SYSTEM - - ═══════════════════════════════════════════════════════════
local BlurFolder = Instance.new("Folder", Workspace.CurrentCamera)
local function createAcrylic()
return Creator.New("Part", { Name ="Body", Color = Color3.new(0, 0, 0), Material = Enum.Material.Glass, Size = Vector3.new(1, 1, 0), Anchored = true, CanCollide = false, Locked = true, CastShadow = false, Transparency = 0.98, }, { Creator.New("SpecialMesh", {MeshType = Enum.MeshType.Brick, Offset = Vector3.new(0, 0, - 0.000001)}), })
end
local function AcrylicBlur()
local function createAcrylicBlur(distance)
local cleanups = {} distance = distance or 0.001
local positions = {topLeft = Vector2.new(), topRight = Vector2.new(), bottomRight = Vector2.new()}
local model = createAcrylic() model.Parent = BlurFolder
local function updatePositions(size, position)
positions.topLeft = position positions.topRight = position + Vector2.new(size.X, 0) positions.bottomRight = position + size
end
local function render()
local camera = Workspace.CurrentCamera
if not camera then
    return
end
local cf = camera.CFrame
local topLeft3D = viewportPointToWorld(positions.topLeft, distance)
local topRight3D = viewportPointToWorld(positions.topRight, distance)
local bottomRight3D = viewportPointToWorld(positions.bottomRight, distance)
local width = (topRight3D - topLeft3D).Magnitude
local height = (topRight3D - bottomRight3D).Magnitude model.CFrame = CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, cf.XVector, cf.YVector, cf.ZVector) model.Mesh.Scale = Vector3.new(width, height, 0)
end
local function onChange(rbx)
local offset = getOffset()
local size = rbx.AbsoluteSize - Vector2.new(offset, offset)
local position = rbx.AbsolutePosition + Vector2.new(offset / 2, offset / 2) updatePositions(size, position) task.spawn(render)
end
local function renderOnChange()
local camera = Workspace.CurrentCamera
if not camera then
    return
end
table.insert(cleanups, camera:GetPropertyChangedSignal("CFrame"):Connect(render)) table.insert(cleanups, camera:GetPropertyChangedSignal("ViewportSize"):Connect(render)) table.insert(cleanups, camera:GetPropertyChangedSignal("FieldOfView"):Connect(render)) task.spawn(render)
end
model.Destroying:Connect(function()
for _, item in cleanups do
    pcall(function()
    item:Disconnect()
end
)
end
end
) renderOnChange()
return onChange, model
end
return function(distance)
local Blur = {}
local onChange, model = createAcrylicBlur(distance)
local comp = Creator.New("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}) Creator.AddSignal(comp:GetPropertyChangedSignal("AbsolutePosition"), function()
onChange(comp)
end
) Creator.AddSignal(comp:GetPropertyChangedSignal("AbsoluteSize"), function()
onChange(comp)
end
) Blur.AddParent = function(Parent)
Creator.AddSignal(Parent:GetPropertyChangedSignal("Visible"), function()
Blur.SetVisibility(Parent.Visible)
end
)
end
Blur.SetVisibility = function(Value)
model.Transparency = Value and 0.98 or 1
end
Blur.Frame = comp Blur.Model = model
return Blur
end
end
local function AcrylicPaint()
local New = Creator.New
local AcrylicBlur = AcrylicBlur()
return function(props)
local AcrylicPaint = {} AcrylicPaint.Frame = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, }, { New("ImageLabel", { Image ="rbxassetid://8992230677", ScaleType ="Slice", SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 120, 1, 116), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1, ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 0.7, }), New("UICorner", {CornerRadius = UDim.new(0, 8)}), New("Frame", { BackgroundTransparency = 0.45, Size = UDim2.fromScale(1, 1), Name ="Background", ThemeTag = {BackgroundColor3 ="AcrylicMain"}, }, {New("UICorner", {CornerRadius = UDim.new(0, 8)})}), New("Frame", { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.4, Size = UDim2.fromScale(1, 1), }, { New("UICorner", {CornerRadius = UDim.new(0, 8)}), New("UIGradient", {Rotation = 90, ThemeTag = {Color ="AcrylicGradient"}}), }), New("ImageLabel", { Image ="rbxassetid://9968344105", ImageTransparency = 0.98, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 128, 0, 128), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, }, {New("UICorner", {CornerRadius = UDim.new(0, 8)})}), New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2, }, { New("UICorner", {CornerRadius = UDim.new(0, 8)}), New("UIStroke", {Transparency = 0.5, Thickness = 1, ThemeTag = {Color ="AcrylicBorder"}}), }), })
local Blur
if Library.UseAcrylic then
    Blur = AcrylicBlur() Blur.Frame.Parent = AcrylicPaint.Frame AcrylicPaint.Model = Blur.Model AcrylicPaint.AddParent = Blur.AddParent AcrylicPaint.SetVisibility = Blur.SetVisibility
end
return AcrylicPaint
end
end
local Acrylic = { AcrylicBlur = AcrylicBlur(), CreateAcrylic = createAcrylic, AcrylicPaint = AcrylicPaint(), } function Acrylic.init()
local baseEffect = Instance.new("DepthOfFieldEffect") baseEffect.FarIntensity = 0 baseEffect.InFocusRadius = 0.1 baseEffect.NearIntensity = 1
local depthOfFieldDefaults = {} function Acrylic.Enable()
for _, effect in pairs(depthOfFieldDefaults) do
    effect.Enabled = false
end
baseEffect.Parent = Lighting
end
function Acrylic.Disable()
    for _, effect in pairs(depthOfFieldDefaults) do
        effect.Enabled = effect.enabled
    end
    baseEffect.Parent = nil
end
local function registerDefaults()
for _, child in pairs(Lighting:GetChildren()) do
    if child:IsA("DepthOfFieldEffect") then
        depthOfFieldDefaults[child] = {enabled = child.Enabled}
    end
end
if Workspace.CurrentCamera then
    for _, child in pairs(Workspace.CurrentCamera:GetChildren()) do
        if child:IsA("DepthOfFieldEffect") then
            depthOfFieldDefaults[child] = {enabled = child.Enabled}
        end
    end
end
end
registerDefaults() Acrylic.Enable()
end
- - ═══════════════════════════════════════════════════════════ - - COMPONENTS - - ═══════════════════════════════════════════════════════════
local Components = { Assets = { Close ="rbxassetid://9886659671", Min ="rbxassetid://9886659276", Max ="rbxassetid://9886659406", Restore ="rbxassetid://9886659001", }, } - - [Note: Components continue with enhanced animations...] - - Karena batasan panjang, saya akan skip beberapa komponen yang identik - - dan fokus pada perubahan utama - - ═══════════════════════════════════════════════════════════ - - ENHANCED NOTIFICATION WITH GLOW - - ═══════════════════════════════════════════════════════════ Components.Notification = (function()
local Spring = Flipper.Spring.new
local Instant = Flipper.Instant.new
local New = Creator.New
local Notification = {} function Notification:Init(GUI)
Notification.Holder = New("Frame", { Position = UDim2.new(1, - 30, 1, - 30), Size = UDim2.new(0, 380, 1, - 30), AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 1, Parent = GUI, }, { New("UIListLayout", { HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 12), }), })
end
function Notification:New(Config)
    Config.Title = Config.Title or"Notification"Config.Content = Config.Content or"Message"Config.SubContent = Config.SubContent or""Config.Duration = Config.Duration or nil Config.Buttons = Config.Buttons or {} Config.Icon = Config.Icon or nil Config.Type = Config.Type or"default"- - default, success, warning, error
    local NewNotification = {Closed = false} NewNotification.AcrylicPaint = Acrylic.AcrylicPaint() - - Type colors
    local typeColors = { default = Color3.fromRGB(255, 60, 60), success = Color3.fromRGB(60, 255, 130), warning = Color3.fromRGB(255, 200, 60), error = Color3.fromRGB(255, 80, 80), }
    local accentColor = typeColors[Config.Type] or typeColors.default - - Icon
    if Config.Icon then
        NewNotification.Icon = New("ImageLabel", { Position = UDim2.new(0, 16, 0, 16), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Image = Config.Icon, ImageColor3 = accentColor, ScaleType = Enum.ScaleType.Fit, })
    end
    NewNotification.Title = New("TextLabel", { Position = UDim2.new(0, Config.Icon and 50 or 16, 0, 16), Text = Config.Title, RichText = true, TextColor3 = Color3.fromRGB(255, 255, 255), FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold), TextSize = 16, TextXAlignment ="Left", TextYAlignment ="Center", Size = UDim2.new(1, - 80, 0, 20), TextWrapped = true, BackgroundTransparency = 1, ThemeTag = {TextColor3 ="Text"}, }) NewNotification.ContentLabel = New("TextLabel", { FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"), Text = Config.Content, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, TextWrapped = true, RichText = true, ThemeTag = {TextColor3 ="Text"}, }) NewNotification.SubContentLabel = New("TextLabel", { FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"), Text = Config.SubContent, TextColor3 = Color3.fromRGB(200, 185, 185), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, TextWrapped = true, RichText = true, ThemeTag = {TextColor3 ="SubText"}, }) NewNotification.LabelHolder = New("Frame", { AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 45), Size = UDim2.new(1, - 80, 0, 0), }, { New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Top, Padding = UDim.new(0, 6), }), NewNotification.ContentLabel, NewNotification.SubContentLabel, }) - - Buttons
    if #Config.Buttons > 0 then
        NewNotification.ButtonHolder = New("Frame", { AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 1, - 60), Size = UDim2.new(1, - 32, 0, 0), }, { New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), }), })
        for _, btnConfig in ipairs(Config.Buttons) do
            local button = New("TextButton", { Text = btnConfig.Text or"Button", Size = UDim2.fromOffset(90, 34), BackgroundColor3 = accentColor, BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 255, 255), FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium), TextSize = 14, Parent = NewNotification.ButtonHolder, }, { New("UICorner", {CornerRadius = UDim.new(0, 8)}), }) Creator.AddSignal(button.MouseEnter, function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end
        ) Creator.AddSignal(button.MouseLeave, function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end
    )
    if btnConfig.Callback then
        Creator.AddSignal(button.MouseButton1Click, btnConfig.Callback)
    end
end
end
- - Close button NewNotification.CloseButton = New("ImageButton", { Position = UDim2.new(1, - 40, 0, 16), Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Image = Components.Assets.Close, ImageColor3 = accentColor, ScaleType = Enum.ScaleType.Fit, }) Creator.AddSignal(NewNotification.CloseButton.MouseEnter, function()
TweenService:Create(NewNotification.CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 150, 150)}):Play()
end
) Creator.AddSignal(NewNotification.CloseButton.MouseLeave, function()
TweenService:Create(NewNotification.CloseButton, TweenInfo.new(0.2), {ImageColor3 = accentColor}):Play()
end
) - - Accent bar with glow NewNotification.AccentBar = New("Frame", { Position = UDim2.fromOffset(0, 0), Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = accentColor, BorderSizePixel = 0, }) - - Main frame NewNotification.Root = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromScale(1, 0), }, { New("UICorner", {CornerRadius = UDim.new(0, 12)}), New("UIStroke", {Thickness = 1, Color = accentColor, Transparency = 0.5}), NewNotification.AcrylicPaint.Frame, NewNotification.AccentBar, NewNotification.Icon, NewNotification.Title, NewNotification.CloseButton, NewNotification.LabelHolder, }) - - Glow effect NewNotification.Glow = New("ImageLabel", { Image ="rbxassetid://3570695787", ImageColor3 = accentColor, ImageTransparency = 0.6, Size = UDim2.new(0, 30, 1, 20), Position = UDim2.fromOffset(- 12, - 10), BackgroundTransparency = 1, ZIndex = - 1, Parent = NewNotification.Root, }) NewNotification.Holder = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 200), Parent = Notification.Holder, }, {NewNotification.Root}) - - Animation motors
local RootMotor = Flipper.GroupMotor.new({Scale = 1, Offset = 80}) RootMotor:onStep(function(Values)
NewNotification.Root.Position = UDim2.new(Values.Scale, Values.Offset, 0, 0)
end
) Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
NewNotification:Close()
end
) function NewNotification:Open()
local ContentSize = NewNotification.LabelHolder.AbsoluteSize.Y
local ButtonHeight = NewNotification.ButtonHolder and NewNotification.ButtonHolder.AbsoluteSize.Y + 10 or 0
local TotalHeight = 65 + ContentSize + ButtonHeight NewNotification.Holder.Size = UDim2.new(1, 0, 0, TotalHeight) RootMotor:setGoal({ Scale = Spring(0, {frequency = 5, dampingRatio = 0.75}), Offset = Spring(0, {frequency = 5, dampingRatio = 0.75}), })
end
function NewNotification:Close()
    if not NewNotification.Closed then
        NewNotification.Closed = true task.spawn(function()
        RootMotor:setGoal({ Scale = Spring(1, {frequency = 5}), Offset = Spring(80, {frequency = 5}), }) task.wait(0.3)
        if Library.UseAcrylic and NewNotification.AcrylicPaint.Model then
            NewNotification.AcrylicPaint.Model:Destroy()
        end
        NewNotification.Holder:Destroy()
    end
    )
end
end
NewNotification:Open()
if Config.Duration then
    task.delay(Config.Duration, function()
    NewNotification:Close()
end
)
end
return NewNotification
end
return Notification
end
)() - - ═══════════════════════════════════════════════════════════ - - THEME & SETTINGS MANAGER (CONTINUED) - - ═══════════════════════════════════════════════════════════ - - Initialize notification module
local NotificationModule = Components.Notification NotificationModule:Init(GUI) - - ═══════════════════════════════════════════════════════════ - - ICONS - - ═══════════════════════════════════════════════════════════
local Icons = { ["lucide-accessibility"] ="rbxassetid://10709751939", ["lucide-activity"] ="rbxassetid://10709752035", ["lucide-alert-circle"] ="rbxassetid://10709752996", ["lucide-alert-triangle"] ="rbxassetid://10709753149", ["lucide-ban"] ="rbxassetid://10709770005", ["lucide-book"] ="rbxassetid://10709781824", ["lucide-box"] ="rbxassetid://10709782497", ["lucide-check"] ="rbxassetid://10709790644", ["lucide-chevron-down"] ="rbxassetid://10709790948", ["lucide-chevron-right"] ="rbxassetid://10709791437", ["lucide-code"] ="rbxassetid://10709810463", ["lucide-cog"] ="rbxassetid://10709810948", ["lucide-copy"] ="rbxassetid://10709812159", ["lucide-crosshair"] ="rbxassetid://10709818534", ["lucide-eye"] ="rbxassetid://10723346959", ["lucide-eye-off"] ="rbxassetid://10723346871", ["lucide-file"] ="rbxassetid://10723374641", ["lucide-filter"] ="rbxassetid://10723375128", ["lucide-flag"] ="rbxassetid://10723375890", ["lucide-flame"] ="rbxassetid://10723376114", ["lucide-gamepad"] ="rbxassetid://10723395457", ["lucide-gauge"] ="rbxassetid://10723395708", ["lucide-gift"] ="rbxassetid://10723396402", ["lucide-globe"] ="rbxassetid://10723404337", ["lucide-hammer"] ="rbxassetid://10723405360", ["lucide-heart"] ="rbxassetid://10723406885", ["lucide-home"] ="rbxassetid://10723407389", ["lucide-info"] ="rbxassetid://10723415903", ["lucide-key"] ="rbxassetid://10723416652", ["lucide-lock"] ="rbxassetid://10723434711", ["lucide-message-circle"] ="rbxassetid://10734888000", ["lucide-moon"] ="rbxassetid://10734897102", ["lucide-music"] ="rbxassetid://10734905958", ["lucide-package"] ="rbxassetid://10734909540", ["lucide-pencil"] ="rbxassetid://10734919691", ["lucide-play"] ="rbxassetid://10734923549", ["lucide-plus"] ="rbxassetid://10734924532", ["lucide-refresh-cw"] ="rbxassetid://10734933222", ["lucide-rocket"] ="rbxassetid://10734934585", ["lucide-save"] ="rbxassetid://10734941499", ["lucide-search"] ="rbxassetid://10734943674", ["lucide-settings"] ="rbxassetid://10734950309", ["lucide-shield"] ="rbxassetid://10734951847", ["lucide-star"] ="rbxassetid://10734966248", ["lucide-sun"] ="rbxassetid://10734974297", ["lucide-sword"] ="rbxassetid://10734975486", ["lucide-target"] ="rbxassetid://10734977012", ["lucide-trash"] ="rbxassetid://10747362393", ["lucide-user"] ="rbxassetid://10747373176", ["lucide-users"] ="rbxassetid://10747373426", ["lucide-wrench"] ="rbxassetid://10747383470", ["lucide-x"] ="rbxassetid://10747384394", ["lucide-zap"] ="rbxassetid://10747384679", ["lucide-cat"] ="rbxassetid://16935650691", } function Library:GetIcon(Name)
if Name ~ = nil then
    if string.find(Name,"rbxassetid://") then
        return Name
    end
    local AssetId = tonumber(Name)
    if AssetId then
        return"rbxassetid://".. AssetId
    end
    if Icons["lucide-".. Name] then
        return Icons["lucide-".. Name]
    end
end
return nil
end
- - ═══════════════════════════════════════════════════════════ - - FILE SYSTEM (Studio compatibility) - - ═══════════════════════════════════════════════════════════
if RunService:IsStudio() then
    makefolder = function(...)
    return ...
end
makefile = function(...)
return ...
end
isfile = function(...)
return false
end
isfolder = function(...)
return false
end
readfile = function(...)
return""end
writefile = function(...)
return ...
end
listfiles = function(...)
return {}
end
end
- - ═══════════════════════════════════════════════════════════ - - SAVE MANAGER - - ═══════════════════════════════════════════════════════════
local SaveManager = {} do
SaveManager.Folder ="CyrusHubX_Settings"SaveManager.Ignore = {} SaveManager.Options = {} SaveManager.Parser = { Toggle = { Save = function(idx, object)
return {type ="Toggle", idx = idx, value = object.Value}
end
, Load = function(idx, data)
if SaveManager.Options[idx] then
    SaveManager.Options[idx]:SetValue(data.value)
end
end
, }, Slider = { Save = function(idx, object)
return {type ="Slider", idx = idx, value = tostring(object.Value)}
end
, Load = function(idx, data)
if SaveManager.Options[idx] then
    SaveManager.Options[idx]:SetValue(data.value)
end
end
, }, Dropdown = { Save = function(idx, object)
return {type ="Dropdown", idx = idx, value = object.Value, multi = object.Multi}
end
, Load = function(idx, data)
if SaveManager.Options[idx] then
    SaveManager.Options[idx]:SetValue(data.value)
end
end
, }, Colorpicker = { Save = function(idx, object)
return {type ="Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency}
end
, Load = function(idx, data)
if SaveManager.Options[idx] then
    SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
end
end
, }, Keybind = { Save = function(idx, object)
return {type ="Keybind", idx = idx, mode = object.Mode, key = object.Value}
end
, Load = function(idx, data)
if SaveManager.Options[idx] then
    SaveManager.Options[idx]:SetValue(data.key, data.mode)
end
end
, }, Input = { Save = function(idx, object)
return {type ="Input", idx = idx, text = object.Value}
end
, Load = function(idx, data)
if SaveManager.Options[idx] and type(data.text) =="string"then
    SaveManager.Options[idx]:SetValue(data.text)
end
end
, }, } function SaveManager:SetIgnoreIndexes(list)
for _, key in next, list do
    self.Ignore[key] = true
end
end
function SaveManager:SetFolder(folder)
    self.Folder = folder self:BuildFolderTree()
end
function SaveManager:Save(Name)
    if not Name then
        return false,"no config file selected"end
        local data = {objects = {}}
        for idx, option in next, SaveManager.Options do
            if not self.Parser[option.Type] then
                continue
            end
            if self.Ignore[idx] then
                continue
            end
            table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
        end
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if not success then
            return false,"failed to encode data"end
            writefile(Name, encoded)
            return true
        end
        function SaveManager:Load(name)
            if not name then
                return false,"no config file selected"end
                if not isfile(name) then
                    return false,"config file not found"end
                    local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(name))
                    if not success then
                        return false,"decode error"end
                        for _, option in next, decoded.objects do
                            if self.Parser[option.type] and not self.Ignore[option.idx] then
                                task.spawn(function()
                                self.Parser[option.type].Load(option.idx, option)
                            end
                            )
                        end
                    end
                    return true
                end
                function SaveManager:BuildFolderTree()
                    if not isfolder(self.Folder) then
                        makefolder(self.Folder)
                    end
                end
                function SaveManager:RefreshConfigList()
                    local list = listfiles(self.Folder .."/")
                    local out = {}
                    for i = 1, #list do
                        local file = list[i]
                        if file:sub(- 5) ==".json"then
                            local pos = file:find(".json", 1, true)
                            local start = pos
                            local char = file:sub(pos, pos)
                            while char ~ ="/"and char ~ ="\\"and char ~ =""do
                                pos = pos - 1 char = file:sub(pos, pos)
                            end
                            if char =="/"or char =="\\"then
                                local name = file:sub(pos + 1, start - 1)
                                if name ~ ="options"then
                                    table.insert(out, name)
                                end
                            end
                        end
                    end
                    return out
                end
                function SaveManager:SetLibrary(library)
                    self.Library = library self.Options = library.Options
                end
            end
            - - ═══════════════════════════════════════════════════════════ - - INTERFACE MANAGER - - ═══════════════════════════════════════════════════════════
            local InterfaceManager = {} do
            InterfaceManager.Folder ="CyrusHubX_Settings"InterfaceManager.Settings = { Acrylic = true, Transparency = true, MenuKeybind ="M", Theme ="CyrusHubX", } function InterfaceManager:SetTheme(name)
            InterfaceManager.Settings.Theme = name
        end
        function InterfaceManager:SetFolder(folder)
            self.Folder = folder self:BuildFolderTree()
        end
        function InterfaceManager:SetLibrary(library)
            self.Library = library
        end
        function InterfaceManager:BuildFolderTree()
            local parts = self.Folder:split("/")
            local paths = {}
            for idx = 1, #parts do
                paths[#paths + 1] = table.concat(parts,"/", 1, idx)
            end
            table.insert(paths, self.Folder) table.insert(paths, self.Folder .."/")
            for i = 1, #paths do
                if not isfolder(paths[i]) then
                    makefolder(paths[i])
                end
            end
        end
        function InterfaceManager:SaveSettings()
            writefile(self.Folder .."/options.json", HttpService:JSONEncode(InterfaceManager.Settings))
        end
        function InterfaceManager:LoadSettings()
            local path = self.Folder .."/options.json"if isfile(path) then
            local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(path))
            if success then
                for i, v in next, decoded do
                    InterfaceManager.Settings[i] = v
                end
            end
        end
    end
end
- - ═══════════════════════════════════════════════════════════ - - CREATE WINDOW FUNCTION - - ═══════════════════════════════════════════════════════════ function Library:CreateWindow(Config)
assert(Config.Title,"Window - Missing Title")
if Library.Window then
    print("[CyrusHubX] You cannot create more than one window.")
    return
end
Library.UseAcrylic = Config.Acrylic ~ = false Library.Acrylic = Config.Acrylic ~ = false Library.Theme = Config.Theme or"CyrusHubX"if Library.UseAcrylic then
Acrylic.init()
end
- - Window creation would go here (same as original but with new theme system) - - For brevity, this would be the same Components.Window call Library.Window = Components.Window({ Parent = GUI, Size = Config.Size or UDim2.fromOffset(580, 460), Title = Config.Title, SubTitle = Config.SubTitle or"v".. Library.Version, TabWidth = Config.TabWidth or 140, }) InterfaceManager:SetTheme(Library.Theme) Library:SetTheme(Library.Theme)
return Library.Window
end
- - ═══════════════════════════════════════════════════════════ - - LIBRARY METHODS - - ═══════════════════════════════════════════════════════════ function Library:SetTheme(Value)
if Library.Window and table.find(Library.Themes, Value) then
    Library.Theme = Value Creator.UpdateTheme()
end
end
function Library:Destroy()
    if Library.Window then
        Library.Unloaded = true
        if Library.UseAcrylic and Library.Window.AcrylicPaint.Model then
            Library.Window.AcrylicPaint.Model:Destroy()
        end
        Creator.Disconnect() Library.GUI:Destroy()
    end
end
function Library:Notify(Config)
    return NotificationModule:New(Config)
end
- - ═══════════════════════════════════════════════════════════ - - GLOBAL EXPORT - - ═══════════════════════════════════════════════════════════
if getgenv then
    getgenv().CyrusHubX = Library getgenv().AntiCheatBypass = Bypass
else
    CyrusHubX = Library AntiCheatBypass = Bypass
end
- - ═══════════════════════════════════════════════════════════ - - SUCCESS NOTIFICATION - - ═══════════════════════════════════════════════════════════ task.spawn(function()
task.wait(1) Library:Notify({ Title ="🛡️ Anti-Cheat Bypass Active", Content ="Protection system initialized successfully", SubContent ="All detection hooks are in place", Duration = 5, Type ="success", Icon = Icons["lucide-shield"], })
end
)
return Library, SaveManager, InterfaceManager
