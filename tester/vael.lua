local JaelVaelorUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui") or LocalPlayer.PlayerGui
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

local function CircleClick(Button, X, Y)
	task.spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
		Circle.ImageTransparency = 0.9
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = Button
		
		local NewX = X - Circle.AbsolutePosition.X
		local NewY = Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5

		local Time = 0.5
		Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size/2, 0.5, -Size/2), "Out", "Quad", Time, false, nil)
		for i = 1, 10 do
			Circle.ImageTransparency = Circle.ImageTransparency + 0.1
			task.wait(Time/10)
		end
		Circle:Destroy()
	end)
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function UpdatePos(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
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

local ConfigSystem = {
	CurrentConfig = nil,
	Configs = {},
	ThemeColors = {
		["Default"] = Color3.fromRGB(147, 112, 219),
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
		["Vaelor"] = Color3.fromRGB(147, 112, 219)
	},
	CurrentTheme = "Vaelor",
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
	for _, toggle in pairs(self.ToggleElements) do
		if toggle and toggle:IsA("Frame") then
			local featureFrame = toggle:FindFirstChild("FeatureFrame")
			local toggleCircle = toggle:FindFirstChild("ToggleCircle")
			local frameStroke = featureFrame and featureFrame:FindFirstChild("UIStroke")
			local toggleTitle = toggle:FindFirstChild("ToggleTitle")
			
			if toggleCircle then
				local isOn = toggleCircle.Position == UDim2.new(0, 15, 0, 0)
				if isOn then
					toggleCircle.BackgroundColor3 = newColor
					if frameStroke then
						frameStroke.Color = newColor
					end
					if featureFrame then
						featureFrame.BackgroundColor3 = newColor
					end
					if toggleTitle then
						toggleTitle.TextColor3 = newColor
					end
				end
			end
		end
	end
	
	for _, slider in pairs(self.SliderElements) do
		if slider and slider:IsA("Frame") then
			local sliderFill = slider:FindFirstChild("SliderFill")
			local sliderCircle = slider:FindFirstChild("SliderCircle")
			local circleStroke = sliderCircle and sliderCircle:FindFirstChild("UIStroke")
			
			if sliderFill then
				sliderFill.BackgroundColor3 = newColor
			end
			if sliderCircle then
				sliderCircle.BackgroundColor3 = newColor
			end
			if circleStroke then
				circleStroke.Color = newColor
			end
		end
	end
	
	for _, dropdown in pairs(self.DropdownElements) do
		if dropdown and dropdown:IsA("Frame") then
			local dropdownList = dropdown:FindFirstChild("DropdownList")
			if dropdownList then
				local listScroll = dropdownList:FindFirstChild("ListScroll")
				if listScroll then
					for _, option in listScroll:GetChildren() do
						if option:IsA("Frame") and option.Name == "Option" then
							local chooseFrame = option:FindFirstChild("ChooseFrame")
							local chooseStroke = chooseFrame and chooseFrame:FindFirstChild("UIStroke")
							local optionText = option:FindFirstChild("OptionText")
							
							if chooseFrame then
								chooseFrame.BackgroundColor3 = newColor
							end
							if chooseStroke then
								chooseStroke.Color = newColor
							end
							if optionText and optionText.TextColor3.r > 0.5 then
								optionText.TextColor3 = newColor
							end
						end
					end
				end
			end
		end
	end
	
	for _, tab in pairs(self.TabElements) do
		if tab and tab:IsA("Frame") then
			local chooseFrame = tab:FindFirstChild("ChooseFrame")
			local chooseStroke = chooseFrame and chooseFrame:FindFirstChild("UIStroke")
			
			if chooseFrame then
				chooseFrame.BackgroundColor3 = newColor
			end
			if chooseStroke then
				chooseStroke.Color = newColor
			end
		end
	end
	
	for _, element in pairs(self.ThemeElements) do
		if element and element:IsA("Frame") and element:FindFirstChild("ChooseFrame") then
			local chooseFrame = element.ChooseFrame
			if chooseFrame then
				chooseFrame.BackgroundColor3 = newColor
				local stroke = chooseFrame:FindFirstChild("UIStroke")
				if stroke then
					stroke.Color = newColor
				end
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
		Title = "Config",
		Description = "Saved",
		Content = "Config '" .. name .. "' saved successfully!",
		Color = self.ThemeColors[self.CurrentTheme],
		Delay = 3
	}
end

function ConfigSystem:LoadConfig(name)
	if self.Configs[name] then
		local config = self.Configs[name]
		self.CurrentTheme = config.Theme
		self.CurrentConfig = name
		
		return {
			Title = "Config",
			Description = "Loaded",
			Content = "Config '" .. name .. "' loaded successfully!",
			Color = self.ThemeColors[self.CurrentTheme],
			Delay = 3
		}, config.Data
	else
		return {
			Title = "Config",
			Description = "Error",
			Content = "Config '" .. name .. "' not found!",
			Color = Color3.fromRGB(255, 50, 50),
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
			Title = "Config",
			Description = "Deleted",
			Content = "Config '" .. name .. "' deleted successfully!",
			Color = self.ThemeColors[self.CurrentTheme],
			Delay = 3
		}
	else
		return {
			Title = "Config",
			Description = "Error",
			Content = "Config '" .. name .. "' not found!",
			Color = Color3.fromRGB(255, 50, 50),
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

local function MakeNotify(NotifyConfig)
	local NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "Notification"
	NotifyConfig.Description = NotifyConfig.Description or "Description"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(147, 112, 219)
	NotifyConfig.Time = NotifyConfig.Time or 0.5
	NotifyConfig.Delay = NotifyConfig.Delay or 5
	
	local NotifyFunction = {}
	
	task.spawn(function()
		if not CoreGui:FindFirstChild("JaelVaelorNotify") then
			local NotifyGui = Instance.new("ScreenGui")
			NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotifyGui.Name = "JaelVaelorNotify"
			NotifyGui.Parent = CoreGui
		end
		
		if not CoreGui.JaelVaelorNotify:FindFirstChild("NotifyLayout") then
			local NotifyLayout = Instance.new("Frame")
			NotifyLayout.AnchorPoint = Vector2.new(1, 1)
			NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotifyLayout.BackgroundTransparency = 0.999
			NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyLayout.BorderSizePixel = 0
			NotifyLayout.Position = UDim2.new(1, -20, 1, -20)
			NotifyLayout.Size = UDim2.new(0, 340, 1, 0)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = CoreGui.JaelVaelorNotify
			
			local Count = 0
			CoreGui.JaelVaelorNotify.NotifyLayout.ChildRemoved:Connect(function()
				Count = 0
				for i, v in CoreGui.JaelVaelorNotify.NotifyLayout:GetChildren() do
					if v:IsA("Frame") then
						TweenService:Create(
							v,
							TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
							{Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12)*(Count)))}
						):Play()
						Count = Count + 1
					end
				end
			end)
		end
		
		local NotifyPosHeigh = 0
		for i, v in CoreGui.JaelVaelorNotify.NotifyLayout:GetChildren() do
			if v:IsA("Frame") then
				NotifyPosHeigh = NotifyPosHeigh + v.Size.Y.Offset + 12
			end
		end
		
		local NotifyFrame = Instance.new("Frame")
		local NotifyFrameReal = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local DropShadowHolder = Instance.new("Frame")
		local DropShadow = Instance.new("ImageLabel")
		local Top = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")
		local UIStroke = Instance.new("UIStroke")
		local UICorner1 = Instance.new("UICorner")
		local TextLabel1 = Instance.new("TextLabel")
		local UIStroke1 = Instance.new("UIStroke")
		local Close = Instance.new("TextButton")
		local ImageLabel = Instance.new("ImageLabel")
		local TextLabel2 = Instance.new("TextLabel")

		NotifyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
		NotifyFrame.Name = "NotifyFrame"
		NotifyFrame.BackgroundTransparency = 1
		NotifyFrame.Parent = CoreGui.JaelVaelorNotify.NotifyLayout
		NotifyFrame.AnchorPoint = Vector2.new(0, 1)
		NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)

		NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrameReal.BorderSizePixel = 0
		NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
		NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
		NotifyFrameReal.Name = "NotifyFrameReal"
		NotifyFrameReal.Parent = NotifyFrame

		UICorner.CornerRadius = UDim.new(0, 12)
		UICorner.Parent = NotifyFrameReal

		DropShadowHolder.BackgroundTransparency = 1
		DropShadowHolder.BorderSizePixel = 0
		DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
		DropShadowHolder.ZIndex = 0
		DropShadowHolder.Name = "DropShadowHolder"
		DropShadowHolder.Parent = NotifyFrameReal

		DropShadow.Image = "rbxassetid://6015897843"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 0.5
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Size = UDim2.new(1, 47, 1, 47)
		DropShadow.ZIndex = 0
		DropShadow.Name = "DropShadow"
		DropShadow.Parent = DropShadowHolder

		Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Top.BackgroundTransparency = 0.999
		Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 36)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextSize = 14
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 0.999
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Parent = Top
		TextLabel.Position = UDim2.new(0, 10, 0, 0)

		UIStroke.Color = Color3.fromRGB(255, 255, 255)
		UIStroke.Thickness = 0.3
		UIStroke.Parent = TextLabel

		UICorner1.CornerRadius = UDim.new(0, 8)
		UICorner1.Parent = Top

		TextLabel1.Font = Enum.Font.GothamBold
		TextLabel1.Text = NotifyConfig.Description
		TextLabel1.TextColor3 = NotifyConfig.Color
		TextLabel1.TextSize = 14
		TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel1.BackgroundTransparency = 0.999
		TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1, 0, 1, 0)
		TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
		TextLabel1.Parent = Top

		UIStroke1.Color = NotifyConfig.Color
		UIStroke1.Thickness = 0.4
		UIStroke1.Parent = TextLabel1

		Close.Font = Enum.Font.SourceSans
		Close.Text = ""
		Close.TextColor3 = Color3.fromRGB(0, 0, 0)
		Close.TextSize = 14
		Close.AnchorPoint = Vector2.new(1, 0.5)
		Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Close.BackgroundTransparency = 0.999
		Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Close.BorderSizePixel = 0
		Close.Position = UDim2.new(1, -8, 0.5, 0)
		Close.Size = UDim2.new(0, 25, 0, 25)
		Close.Name = "Close"
		Close.Parent = Top

		ImageLabel.Image = "rbxassetid://9886659671"
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 0.999
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(1, -8, 1, -8)
		ImageLabel.Parent = Close

		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.TextSize = 13
		TextLabel2.Text = NotifyConfig.Content
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.BackgroundTransparency = 0.999
		TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
		TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0, 15, 0, 45)
		TextLabel2.Parent = NotifyFrameReal
		TextLabel2.Size = UDim2.new(1, -30, 0, 13)

		TextLabel2.Size = UDim2.new(1, -30, 0, 13 + (13 * math.floor(TextLabel2.TextBounds.X / (TextLabel2.AbsoluteSize.X - 30))))
		TextLabel2.TextWrapped = true

		if TextLabel2.AbsoluteSize.Y < 27 then
			NotifyFrame.Size = UDim2.new(1, 0, 0, 80)
		else
			NotifyFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 50)
		end
		
		local waitbruh = false
		function NotifyFunction:Close()
			if waitbruh then
				return false
			end
			waitbruh = true
			TweenService:Create(
				NotifyFrameReal,
				TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
				{Position = UDim2.new(0, 400, 0, 0)}
			):Play()
			task.wait(tonumber(NotifyConfig.Time) / 1.2)
			NotifyFrame:Destroy()
		end
		
		Close.Activated:Connect(function()
			NotifyFunction:Close()
		end)
		
		TweenService:Create(
			NotifyFrameReal,
			TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
			{Position = UDim2.new(0, 0, 0, 0)}
		):Play()
		task.wait(tonumber(NotifyConfig.Delay))
		NotifyFunction:Close()
	end)
	
	return NotifyFunction
end

function JaelVaelorUI:CreateWindow(config)
	config = config or {}
	local Title = config.Title or "Jael Vaelor UI"
	local Theme = config.Theme or "Vaelor"
	local Size = config.Size or UDim2.fromOffset(580, 480)
	local Center = config.Center ~= false
	local Draggable = config.Draggable ~= false
	local MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightShift
	local MinimizeIcon = config.MinimizeIcon or "rbxassetid://9886659276"
	local RestoreIcon = config.RestoreIcon or "rbxassetid://16851841101"
	local ConfigData = config.Config or {}
	
	local isMinimized = false
	local MinimizeButton = nil
	
	if ConfigSystem.ThemeColors[Theme] then
		ConfigSystem.CurrentTheme = Theme
	end
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Name = "JaelVaelorUI"
	ScreenGui.Parent = CoreGui
	ScreenGui.ResetOnSpawn = false

	local DropShadowHolder = Instance.new("Frame")
	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.Size = Size
	DropShadowHolder.ZIndex = 0
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = ScreenGui
	
	if Center then
		DropShadowHolder.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
	end

	local DropShadow = Instance.new("ImageLabel")
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(10, 10, 10)
	DropShadow.ImageTransparency = 0.4
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder

	local Main = Instance.new("Frame")
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	Main.BackgroundTransparency = 0
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(1, -47, 1, -47)
	Main.Name = "Main"
	Main.Parent = DropShadow

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 16)
	UICorner.Parent = Main

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.fromRGB(60, 60, 70)
	UIStroke.Thickness = 1.6
	UIStroke.Parent = Main

	local Top = Instance.new("Frame")
	Top.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	Top.BackgroundTransparency = 0
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 45)
	Top.Name = "Top"
	Top.Parent = Main

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 16)
	TopCorner.Parent = Top

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = Title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 15
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.BackgroundTransparency = 0.999
	TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TitleLabel.BorderSizePixel = 0
	TitleLabel.Size = UDim2.new(1, -120, 1, 0)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.Parent = Top

	local Close = Instance.new("TextButton")
	Close.Font = Enum.Font.SourceSans
	Close.Text = ""
	Close.TextColor3 = Color3.fromRGB(0, 0, 0)
	Close.TextSize = 14
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Close.BackgroundTransparency = 0.999
	Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Close.BorderSizePixel = 0
	Close.Position = UDim2.new(1, -15, 0.5, 0)
	Close.Size = UDim2.new(0, 30, 0, 30)
	Close.Name = "Close"
	Close.Parent = Top

	local CloseIcon = Instance.new("ImageLabel")
	CloseIcon.Image = "rbxassetid://9886659671"
	CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseIcon.BackgroundTransparency = 0.999
	CloseIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseIcon.BorderSizePixel = 0
	CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseIcon.Size = UDim2.new(0, 18, 0, 18)
	CloseIcon.Parent = Close

	local Min = Instance.new("TextButton")
	Min.Font = Enum.Font.SourceSans
	Min.Text = ""
	Min.TextColor3 = Color3.fromRGB(0, 0, 0)
	Min.TextSize = 14
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Min.BackgroundTransparency = 0.999
	Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Min.BorderSizePixel = 0
	Min.Position = UDim2.new(1, -55, 0.5, 0)
	Min.Size = UDim2.new(0, 30, 0, 30)
	Min.Name = "Min"
	Min.Parent = Top

	local MinIcon = Instance.new("ImageLabel")
	MinIcon.Image = MinimizeIcon
	MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	MinIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MinIcon.BackgroundTransparency = 0.999
	MinIcon.ImageTransparency = 0.2
	MinIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MinIcon.BorderSizePixel = 0
	MinIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	MinIcon.Size = UDim2.new(0, 18, 0, 18)
	MinIcon.Parent = Min

	local MaxRestore = Instance.new("TextButton")
	MaxRestore.Font = Enum.Font.SourceSans
	MaxRestore.Text = ""
	MaxRestore.TextColor3 = Color3.fromRGB(0, 0, 0)
	MaxRestore.TextSize = 14
	MaxRestore.AnchorPoint = Vector2.new(1, 0.5)
	MaxRestore.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MaxRestore.BackgroundTransparency = 0.999
	MaxRestore.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MaxRestore.BorderSizePixel = 0
	MaxRestore.Position = UDim2.new(1, -95, 0.5, 0)
	MaxRestore.Size = UDim2.new(0, 30, 0, 30)
	MaxRestore.Name = "MaxRestore"
	MaxRestore.Parent = Top

	local MaxIcon = Instance.new("ImageLabel")
	MaxIcon.Image = "rbxassetid://9886659406"
	MaxIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	MaxIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MaxIcon.BackgroundTransparency = 0.999
	MaxIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MaxIcon.BorderSizePixel = 0
	MaxIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	MaxIcon.Size = UDim2.new(0, 18, 0, 18)
	MaxIcon.Parent = MaxRestore

	local TabFrame = Instance.new("Frame")
	TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	TabFrame.BackgroundTransparency = 0
	TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabFrame.BorderSizePixel = 0
	TabFrame.Position = UDim2.new(0, 12, 0, 60)
	TabFrame.Size = UDim2.new(0, 140, 1, -72)
	TabFrame.Name = "TabFrame"
	TabFrame.Parent = Main

	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 12)
	TabCorner.Parent = TabFrame

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
	TabScroll.ScrollBarThickness = 4
	TabScroll.Active = true
	TabScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabScroll.BackgroundTransparency = 0.999
	TabScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabScroll.BorderSizePixel = 0
	TabScroll.Size = UDim2.new(1, -10, 1, -10)
	TabScroll.Position = UDim2.new(0, 5, 0, 5)
	TabScroll.Name = "TabScroll"
	TabScroll.Parent = TabFrame

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 5)
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Parent = TabScroll

	local ContentFrame = Instance.new("Frame")
	ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	ContentFrame.BackgroundTransparency = 0
	ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ContentFrame.BorderSizePixel = 0
	ContentFrame.Position = UDim2.new(0, 162, 0, 60)
	ContentFrame.Size = UDim2.new(1, -174, 1, -72)
	ContentFrame.Name = "ContentFrame"
	ContentFrame.Parent = Main

	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 12)
	ContentCorner.Parent = ContentFrame

	local ContentTitle = Instance.new("TextLabel")
	ContentTitle.Font = Enum.Font.GothamBold
	ContentTitle.Text = "Main"
	ContentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	ContentTitle.TextSize = 22
	ContentTitle.TextWrapped = true
	ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
	ContentTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ContentTitle.BackgroundTransparency = 0.999
	ContentTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ContentTitle.BorderSizePixel = 0
	ContentTitle.Size = UDim2.new(1, -20, 0, 35)
	ContentTitle.Position = UDim2.new(0, 15, 0, 10)
	ContentTitle.Name = "ContentTitle"
	ContentTitle.Parent = ContentFrame

	local ContentScroll = Instance.new("ScrollingFrame")
	ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
	ContentScroll.ScrollBarThickness = 6
	ContentScroll.Active = true
	ContentScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ContentScroll.BackgroundTransparency = 0.999
	ContentScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ContentScroll.BorderSizePixel = 0
	ContentScroll.ClipsDescendants = true
	ContentScroll.Position = UDim2.new(0, 15, 0, 50)
	ContentScroll.Size = UDim2.new(1, -30, 1, -60)
	ContentScroll.Name = "ContentScroll"
	ContentScroll.Parent = ContentFrame

	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.Padding = UDim.new(0, 10)
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Parent = ContentScroll

	local TabContents = {}
	local CurrentTab = nil
	local TabCount = 0
	local AllElements = {}

	local function UpdateTabSize()
		local OffsetY = 0
		for _, child in TabScroll:GetChildren() do
			if child:IsA("Frame") then
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
					OffsetY = OffsetY + 10 + child.Size.Y.Offset
				end
			end
			ContentScroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
		end
	end

	TabScroll.ChildAdded:Connect(UpdateTabSize)
	TabScroll.ChildRemoved:Connect(UpdateTabSize)
	ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateContentSize)

	local function CreateMinimizeButton()
		local MinimizeBtnFrame = Instance.new("Frame")
		MinimizeBtnFrame.Name = "MinimizeButton"
		MinimizeBtnFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
		MinimizeBtnFrame.BackgroundTransparency = 0
		MinimizeBtnFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MinimizeBtnFrame.BorderSizePixel = 0
		MinimizeBtnFrame.Size = UDim2.new(0, 50, 0, 50)
		MinimizeBtnFrame.Position = UDim2.new(1, -70, 1, -70)
		MinimizeBtnFrame.AnchorPoint = Vector2.new(1, 1)
		MinimizeBtnFrame.Visible = false
		MinimizeBtnFrame.ZIndex = 10
		MinimizeBtnFrame.Parent = ScreenGui
		
		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 12)
		BtnCorner.Parent = MinimizeBtnFrame
		
		local BtnStroke = Instance.new("UIStroke")
		BtnStroke.Color = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		BtnStroke.Thickness = 2
		BtnStroke.Transparency = 0.5
		BtnStroke.Parent = MinimizeBtnFrame
		
		local DropShadow = Instance.new("ImageLabel")
		DropShadow.Image = "rbxassetid://6015897843"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 0.5
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Size = UDim2.new(1, 37, 1, 37)
		DropShadow.ZIndex = 9
		DropShadow.Name = "DropShadow"
		DropShadow.Parent = MinimizeBtnFrame
		
		local BtnImage = Instance.new("ImageLabel")
		BtnImage.Name = "BtnImage"
		BtnImage.Image = RestoreIcon
		BtnImage.AnchorPoint = Vector2.new(0.5, 0.5)
		BtnImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BtnImage.BackgroundTransparency = 0.999
		BtnImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BtnImage.BorderSizePixel = 0
		BtnImage.Position = UDim2.new(0.5, 0, 0.5, 0)
		BtnImage.Size = UDim2.new(0, 24, 0, 24)
		BtnImage.Parent = MinimizeBtnFrame
		
		local BtnButton = Instance.new("TextButton")
		BtnButton.Name = "BtnButton"
		BtnButton.Font = Enum.Font.SourceSans
		BtnButton.Text = ""
		BtnButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		BtnButton.TextSize = 14
		BtnButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BtnButton.BackgroundTransparency = 0.999
		BtnButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BtnButton.BorderSizePixel = 0
		BtnButton.Size = UDim2.new(1, 0, 1, 0)
		BtnButton.ZIndex = 11
		BtnButton.Parent = MinimizeBtnFrame
		
		local dragging = false
		local dragStart = nil
		local startPos = nil
		
		BtnButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = MinimizeBtnFrame.Position
				
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		
		BtnButton.InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
				local delta = input.Position - dragStart
				MinimizeBtnFrame.Position = UDim2.new(
					startPos.X.Scale, 
					startPos.X.Offset + delta.X,
					startPos.Y.Scale, 
					startPos.Y.Offset + delta.Y
				)
			end
		end)
		
		BtnButton.MouseEnter:Connect(function()
			TweenService:Create(MinimizeBtnFrame, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			}):Play()
			TweenService:Create(BtnStroke, TweenInfo.new(0.2), {
				Transparency = 0
			}):Play()
		end)
		
		BtnButton.MouseLeave:Connect(function()
			TweenService:Create(MinimizeBtnFrame, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(25, 25, 30)
			}):Play()
			TweenService:Create(BtnStroke, TweenInfo.new(0.2), {
				Transparency = 0.5
			}):Play()
		end)
		
		BtnButton.Activated:Connect(function()
			CircleClick(BtnButton, Mouse.X, Mouse.Y)
			isMinimized = false
			DropShadowHolder.Visible = true
			MinimizeBtnFrame.Visible = false
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = Size,
				Position = Center and UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2) or DropShadowHolder.Position
			}):Play()
		end)
		
		return MinimizeBtnFrame
	end

	Close.Activated:Connect(function()
		CircleClick(Close, Mouse.X, Mouse.Y)
		DropShadowHolder.Visible = false
		if MinimizeButton then
			MinimizeButton.Visible = false
		end
	end)

	Min.Activated:Connect(function()
		CircleClick(Min, Mouse.X, Mouse.Y)
		isMinimized = true
		DropShadowHolder.Visible = false
		if MinimizeButton then
			MinimizeButton.Visible = true
			TweenService:Create(MinimizeButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 50, 0, 50)
			}):Play()
		end
	end)

	local OldPos = DropShadowHolder.Position
	local OldSize = DropShadowHolder.Size
	
	MaxRestore.Activated:Connect(function()
		CircleClick(MaxRestore, Mouse.X, Mouse.Y)
		if MaxIcon.Image == "rbxassetid://9886659406" then
			MaxIcon.Image = "rbxassetid://9886659001"
			OldPos = DropShadowHolder.Position
			OldSize = DropShadowHolder.Size
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
		else
			MaxIcon.Image = "rbxassetid://9886659406"
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = OldPos}):Play()
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = OldSize}):Play()
		end
	end)

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == MinimizeKey then
			isMinimized = not isMinimized
			DropShadowHolder.Visible = not isMinimized
			if MinimizeButton then
				MinimizeButton.Visible = isMinimized
				if isMinimized then
					TweenService:Create(MinimizeButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 50, 0, 50)
					}):Play()
				end
			end
		end
	end)

	if Draggable then
		MakeDraggable(Top, DropShadowHolder)
	end

	MinimizeButton = CreateMinimizeButton()

	local function CreateParagraph(tabContainer, title, content)
		if not tabContainer or not tabContainer:IsA("Frame") then return end
		
		local Paragraph = Instance.new("Frame")
		Paragraph.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		Paragraph.BackgroundTransparency = 0
		Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Paragraph.BorderSizePixel = 0
		Paragraph.Size = UDim2.new(1, 0, 0, 46)
		Paragraph.Name = "Paragraph"
		Paragraph.Parent = tabContainer

		local ParagraphCorner = Instance.new("UICorner")
		ParagraphCorner.CornerRadius = UDim.new(0, 12)
		ParagraphCorner.Parent = Paragraph

		local ParagraphTitle = Instance.new("TextLabel")
		ParagraphTitle.Font = Enum.Font.GothamBold
		ParagraphTitle.Text = title
		ParagraphTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		ParagraphTitle.TextSize = 14
		ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
		ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
		ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ParagraphTitle.BackgroundTransparency = 0.999
		ParagraphTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ParagraphTitle.BorderSizePixel = 0
		ParagraphTitle.Position = UDim2.new(0, 15, 0, 12)
		ParagraphTitle.Size = UDim2.new(1, -30, 0, 16)
		ParagraphTitle.Name = "ParagraphTitle"
		ParagraphTitle.Parent = Paragraph

		local ParagraphContent = Instance.new("TextLabel")
		ParagraphContent.Font = Enum.Font.Gotham
		ParagraphContent.Text = content
		ParagraphContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		ParagraphContent.TextSize = 13
		ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
		ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
		ParagraphContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ParagraphContent.BackgroundTransparency = 0.999
		ParagraphContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ParagraphContent.BorderSizePixel = 0
		ParagraphContent.Position = UDim2.new(0, 15, 0, 32)
		ParagraphContent.Name = "ParagraphContent"
		ParagraphContent.Parent = Paragraph

		local textSize = TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X - 60, math.huge))
		
		ParagraphContent.Size = UDim2.new(1, -30, 0, textSize.Y)
		ParagraphContent.TextWrapped = true
		Paragraph.Size = UDim2.new(1, 0, 0, math.max(60, textSize.Y + 44))
		
		task.wait(0.1)
		UpdateContentSize()
		
		return Paragraph
	end

	local function CreateButton(tabContainer, title, content, iconId, callback)
		if not tabContainer or not tabContainer:IsA("Frame") then return end
		
		local Button = Instance.new("Frame")
		Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		Button.BackgroundTransparency = 0
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Size = UDim2.new(1, 0, 0, 46)
		Button.Name = "Button"
		Button.Parent = tabContainer

		local ButtonCorner = Instance.new("UICorner")
		ButtonCorner.CornerRadius = UDim.new(0, 12)
		ButtonCorner.Parent = Button

		local ButtonTitle = Instance.new("TextLabel")
		ButtonTitle.Font = Enum.Font.GothamBold
		ButtonTitle.Text = title
		ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		ButtonTitle.TextSize = 14
		ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
		ButtonTitle.TextYAlignment = Enum.TextYAlignment.Top
		ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ButtonTitle.BackgroundTransparency = 0.999
		ButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonTitle.BorderSizePixel = 0
		ButtonTitle.Position = UDim2.new(0, 15, 0, 12)
		ButtonTitle.Size = UDim2.new(1, -80, 0, 16)
		ButtonTitle.Name = "ButtonTitle"
		ButtonTitle.Parent = Button

		local ButtonContent = Instance.new("TextLabel")
		ButtonContent.Font = Enum.Font.Gotham
		ButtonContent.Text = content
		ButtonContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		ButtonContent.TextSize = 13
		ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
		ButtonContent.TextYAlignment = Enum.TextYAlignment.Top
		ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ButtonContent.BackgroundTransparency = 0.999
		ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonContent.BorderSizePixel = 0
		ButtonContent.Position = UDim2.new(0, 15, 0, 32)
		ButtonContent.Name = "ButtonContent"
		ButtonContent.Parent = Button
		
		local textSize = TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X - 100, math.huge))
		
		ButtonContent.Size = UDim2.new(1, -80, 0, textSize.Y)
		ButtonContent.TextWrapped = true
		Button.Size = UDim2.new(1, 0, 0, math.max(60, textSize.Y + 44))

		local ButtonButton = Instance.new("TextButton")
		ButtonButton.Font = Enum.Font.SourceSans
		ButtonButton.Text = ""
		ButtonButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		ButtonButton.TextSize = 14
		ButtonButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ButtonButton.BackgroundTransparency = 0.999
		ButtonButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonButton.BorderSizePixel = 0
		ButtonButton.Size = UDim2.new(1, 0, 1, 0)
		ButtonButton.Name = "ButtonButton"
		ButtonButton.Parent = Button

		local FeatureFrame = Instance.new("Frame")
		FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
		FeatureFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		FeatureFrame.BackgroundTransparency = 0.999
		FeatureFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FeatureFrame.BorderSizePixel = 0
		FeatureFrame.Position = UDim2.new(1, -20, 0.5, 0)
		FeatureFrame.Size = UDim2.new(0, 32, 0, 32)
		FeatureFrame.Name = "FeatureFrame"
		FeatureFrame.Parent = Button

		local FeatureImg = Instance.new("ImageLabel")
		FeatureImg.Image = iconId or "rbxassetid://16932740082"
		FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
		FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FeatureImg.BackgroundTransparency = 0.999
		FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FeatureImg.BorderSizePixel = 0
		FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
		FeatureImg.Size = UDim2.new(0, 22, 0, 22)
		FeatureImg.Name = "FeatureImg"
		FeatureImg.Parent = FeatureFrame

		ButtonButton.Activated:Connect(function()
			CircleClick(ButtonButton, Mouse.X, Mouse.Y)
			if callback then
				callback()
			end
		end)
		
		task.wait(0.1)
		UpdateContentSize()

		return Button
	end

	local function CreateToggle(tabContainer, title, content, defaultValue, callback, elementId)
		if not tabContainer or not tabContainer:IsA("Frame") then return end
		
		local Toggle = Instance.new("Frame")
		Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		Toggle.BackgroundTransparency = 0
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(1, 0, 0, 46)
		Toggle.Name = "Toggle"
		Toggle.Parent = tabContainer

		local ToggleCorner = Instance.new("UICorner")
		ToggleCorner.CornerRadius = UDim.new(0, 12)
		ToggleCorner.Parent = Toggle

		local ToggleTitle = Instance.new("TextLabel")
		ToggleTitle.Font = Enum.Font.GothamBold
		ToggleTitle.Text = title
		ToggleTitle.TextSize = 14
		ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
		ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
		ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleTitle.BackgroundTransparency = 0.999
		ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleTitle.BorderSizePixel = 0
		ToggleTitle.Position = UDim2.new(0, 15, 0, 12)
		ToggleTitle.Size = UDim2.new(1, -100, 0, 16)
		ToggleTitle.Name = "ToggleTitle"
		ToggleTitle.Parent = Toggle

		local ToggleContent = Instance.new("TextLabel")
		ToggleContent.Font = Enum.Font.Gotham
		ToggleContent.Text = content
		ToggleContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		ToggleContent.TextSize = 13
		ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
		ToggleContent.TextYAlignment = Enum.TextYAlignment.Top
		ToggleContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleContent.BackgroundTransparency = 0.999
		ToggleContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleContent.BorderSizePixel = 0
		ToggleContent.Position = UDim2.new(0, 15, 0, 32)
		ToggleContent.Size = UDim2.new(1, -100, 0, 13)
		ToggleContent.Name = "ToggleContent"
		ToggleContent.Parent = Toggle
		
		local textSize = TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X - 130, math.huge))
		
		ToggleContent.Size = UDim2.new(1, -100, 0, textSize.Y)
		ToggleContent.TextWrapped = true
		Toggle.Size = UDim2.new(1, 0, 0, math.max(60, textSize.Y + 44))

		local ToggleButton = Instance.new("TextButton")
		ToggleButton.Font = Enum.Font.SourceSans
		ToggleButton.Text = ""
		ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		ToggleButton.TextSize = 14
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleButton.BackgroundTransparency = 0.999
		ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleButton.BorderSizePixel = 0
		ToggleButton.Size = UDim2.new(1, 0, 1, 0)
		ToggleButton.Name = "ToggleButton"
		ToggleButton.Parent = Toggle

		local FeatureFrame = Instance.new("Frame")
		FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
		FeatureFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		FeatureFrame.BackgroundTransparency = 0
		FeatureFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FeatureFrame.BorderSizePixel = 0
		FeatureFrame.Position = UDim2.new(1, -25, 0.5, 0)
		FeatureFrame.Size = UDim2.new(0, 40, 0, 22)
		FeatureFrame.Name = "FeatureFrame"
		FeatureFrame.Parent = Toggle

		local FrameCorner = Instance.new("UICorner")
		FrameCorner.CornerRadius = UDim.new(1, 0)
		FrameCorner.Parent = FeatureFrame

		local FrameStroke = Instance.new("UIStroke")
		FrameStroke.Color = Color3.fromRGB(80, 80, 90)
		FrameStroke.Thickness = 1.5
		FrameStroke.Transparency = 0
		FrameStroke.Parent = FeatureFrame

		local ToggleCircle = Instance.new("Frame")
		ToggleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
		ToggleCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleCircle.BorderSizePixel = 0
		ToggleCircle.Position = defaultValue and UDim2.new(0, 20, 0, 2) or UDim2.new(0, 2, 0, 2)
		ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
		ToggleCircle.Name = "ToggleCircle"
		ToggleCircle.Parent = FeatureFrame

		local CircleCorner = Instance.new("UICorner")
		CircleCorner.CornerRadius = UDim.new(1, 0)
		CircleCorner.Parent = ToggleCircle
		
		table.insert(ConfigSystem.ToggleElements, Toggle)
		
		local state = defaultValue or false
		
		local function SetState(value)
			state = value
			local themeColor = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
			if value then
				TweenService:Create(
					ToggleTitle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{TextColor3 = themeColor}
				):Play()
				TweenService:Create(
					ToggleCircle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{Position = UDim2.new(0, 20, 0, 2), BackgroundColor3 = themeColor}
				):Play()
				TweenService:Create(
					FrameStroke,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{Color = themeColor}
				):Play()
				TweenService:Create(
					FeatureFrame,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{BackgroundColor3 = themeColor:lerp(Color3.fromRGB(45, 45, 50), 0.3)}
				):Play()
			else
				TweenService:Create(
					ToggleTitle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{TextColor3 = Color3.fromRGB(255, 255, 255)}
				):Play()
				TweenService:Create(
					ToggleCircle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(220, 220, 220)}
				):Play()
				TweenService:Create(
					FrameStroke,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{Color = Color3.fromRGB(80, 80, 90)}
				):Play()
				TweenService:Create(
					FeatureFrame,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{BackgroundColor3 = Color3.fromRGB(45, 45, 50)}
				):Play()
			end
			if callback then
				callback(state)
			end
		end
		
		SetState(state)
		
		ToggleButton.Activated:Connect(function()
			CircleClick(ToggleButton, Mouse.X, Mouse.Y) 
			SetState(not state)
		end)
		
		task.wait(0.1)
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

	local function CreateInput(tabContainer, title, content, placeholder, callback, elementId)
		if not tabContainer or not tabContainer:IsA("Frame") then return end
		
		local Input = Instance.new("Frame")
		Input.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		Input.BackgroundTransparency = 0
		Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Input.BorderSizePixel = 0
		Input.Size = UDim2.new(1, 0, 0, 46)
		Input.Name = "Input"
		Input.Parent = tabContainer

		local InputCorner = Instance.new("UICorner")
		InputCorner.CornerRadius = UDim.new(0, 12)
		InputCorner.Parent = Input

		local InputTitle = Instance.new("TextLabel")
		InputTitle.Font = Enum.Font.GothamBold
		InputTitle.Text = title
		InputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		InputTitle.TextSize = 14
		InputTitle.TextXAlignment = Enum.TextXAlignment.Left
		InputTitle.TextYAlignment = Enum.TextYAlignment.Top
		InputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		InputTitle.BackgroundTransparency = 0.999
		InputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputTitle.BorderSizePixel = 0
		InputTitle.Position = UDim2.new(0, 15, 0, 12)
		InputTitle.Size = UDim2.new(1, -200, 0, 16)
		InputTitle.Name = "InputTitle"
		InputTitle.Parent = Input

		local InputContent = Instance.new("TextLabel")
		InputContent.Font = Enum.Font.Gotham
		InputContent.Text = content
		InputContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		InputContent.TextSize = 13
		InputContent.TextWrapped = true
		InputContent.TextXAlignment = Enum.TextXAlignment.Left
		InputContent.TextYAlignment = Enum.TextYAlignment.Top
		InputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		InputContent.BackgroundTransparency = 0.999
		InputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputContent.BorderSizePixel = 0
		InputContent.Position = UDim2.new(0, 15, 0, 32)
		InputContent.Size = UDim2.new(1, -200, 0, 13)
		InputContent.Name = "InputContent"
		InputContent.Parent = Input
		
		local textSize = TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X - 230, math.huge))
		
		InputContent.Size = UDim2.new(1, -200, 0, textSize.Y)
		InputContent.TextWrapped = true
		Input.Size = UDim2.new(1, 0, 0, math.max(60, textSize.Y + 44))

		local InputFrame = Instance.new("Frame")
		InputFrame.AnchorPoint = Vector2.new(1, 0.5)
		InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		InputFrame.BackgroundTransparency = 0
		InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputFrame.BorderSizePixel = 0
		InputFrame.ClipsDescendants = true
		InputFrame.Position = UDim2.new(1, -15, 0.5, 0)
		InputFrame.Size = UDim2.new(0, 160, 0, 36)
		InputFrame.Name = "InputFrame"
		InputFrame.Parent = Input

		local FrameCorner = Instance.new("UICorner")
		FrameCorner.CornerRadius = UDim.new(0, 8)
		FrameCorner.Parent = InputFrame

		local FrameStroke = Instance.new("UIStroke")
		FrameStroke.Color = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		FrameStroke.Thickness = 1.5
		FrameStroke.Transparency = 0.7
		FrameStroke.Parent = InputFrame

		local InputTextBox = Instance.new("TextBox")
		InputTextBox.CursorPosition = -1
		InputTextBox.Font = Enum.Font.Gotham
		InputTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
		InputTextBox.PlaceholderText = placeholder or "Write here..."
		InputTextBox.Text = ""
		InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		InputTextBox.TextSize = 13
		InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
		InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
		InputTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		InputTextBox.BackgroundTransparency = 0.999
		InputTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputTextBox.BorderSizePixel = 0
		InputTextBox.Position = UDim2.new(0, 10, 0.5, 0)
		InputTextBox.Size = UDim2.new(1, -20, 1, -8)
		InputTextBox.Name = "InputTextBox"
		InputTextBox.Parent = InputFrame
		
		local inputFunc = {
			Value = "",
			Type = "Input",
			Id = elementId
		}
		
		function inputFunc:Set(value)
			InputTextBox.Text = value
			inputFunc.Value = value
			if callback then
				callback(value)
			end
		end
		
		InputTextBox.FocusLost:Connect(function(enterPressed)
			inputFunc:Set(InputTextBox.Text)
			TweenService:Create(FrameStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
		end)
		
		InputTextBox.Focused:Connect(function()
			TweenService:Create(FrameStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
		end)
		
		task.wait(0.1)
		UpdateContentSize()

		if elementId then
			AllElements[elementId] = inputFunc
		end
		
		return inputFunc
	end

	local function CreateDropdown(tabContainer, title, content, options, multi, defaultValue, callback, elementId)
		if not tabContainer or not tabContainer:IsA("Frame") then return end
		
		local Dropdown = Instance.new("Frame")
		Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		Dropdown.BackgroundTransparency = 0
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.Size = UDim2.new(1, 0, 0, 46)
		Dropdown.Name = "Dropdown"
		Dropdown.Parent = tabContainer

		local DropdownCorner = Instance.new("UICorner")
		DropdownCorner.CornerRadius = UDim.new(0, 12)
		DropdownCorner.Parent = Dropdown

		local DropdownButton = Instance.new("TextButton")
		DropdownButton.Font = Enum.Font.SourceSans
		DropdownButton.Text = ""
		DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		DropdownButton.TextSize = 14
		DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownButton.BackgroundTransparency = 0.999
		DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownButton.BorderSizePixel = 0
		DropdownButton.Size = UDim2.new(1, 0, 1, 0)
		DropdownButton.Name = "DropdownButton"
		DropdownButton.Parent = Dropdown

		local DropdownTitle = Instance.new("TextLabel")
		DropdownTitle.Font = Enum.Font.GothamBold
		DropdownTitle.Text = title
		DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		DropdownTitle.TextSize = 14
		DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
		DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
		DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownTitle.BackgroundTransparency = 0.999
		DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownTitle.BorderSizePixel = 0
		DropdownTitle.Position = UDim2.new(0, 15, 0, 12)
		DropdownTitle.Size = UDim2.new(1, -200, 0, 16)
		DropdownTitle.Name = "DropdownTitle"
		DropdownTitle.Parent = Dropdown

		local DropdownContent = Instance.new("TextLabel")
		DropdownContent.Font = Enum.Font.Gotham
		DropdownContent.Text = content
		DropdownContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		DropdownContent.TextSize = 13
		DropdownContent.TextWrapped = true
		DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
		DropdownContent.TextYAlignment = Enum.TextYAlignment.Top
		DropdownContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownContent.BackgroundTransparency = 0.999
		DropdownContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownContent.BorderSizePixel = 0
		DropdownContent.Position = UDim2.new(0, 15, 0, 32)
		DropdownContent.Size = UDim2.new(1, -200, 0, 13)
		DropdownContent.Name = "DropdownContent"
		DropdownContent.Parent = Dropdown
		
		local textSize = TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X - 230, math.huge))
		
		DropdownContent.Size = UDim2.new(1, -200, 0, textSize.Y)
		DropdownContent.TextWrapped = true
		Dropdown.Size = UDim2.new(1, 0, 0, math.max(60, textSize.Y + 44))

		local SelectOptionsFrame = Instance.new("Frame")
		SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
		SelectOptionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		SelectOptionsFrame.BackgroundTransparency = 0
		SelectOptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SelectOptionsFrame.BorderSizePixel = 0
		SelectOptionsFrame.Position = UDim2.new(1, -15, 0.5, 0)
		SelectOptionsFrame.Size = UDim2.new(0, 160, 0, 36)
		SelectOptionsFrame.Name = "SelectOptionsFrame"
		SelectOptionsFrame.Parent = Dropdown

		local FrameCorner = Instance.new("UICorner")
		FrameCorner.CornerRadius = UDim.new(0, 8)
		FrameCorner.Parent = SelectOptionsFrame

		local FrameStroke = Instance.new("UIStroke")
		FrameStroke.Color = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		FrameStroke.Thickness = 1.5
		FrameStroke.Transparency = 0.7
		FrameStroke.Parent = SelectOptionsFrame

		local OptionSelecting = Instance.new("TextLabel")
		OptionSelecting.Font = Enum.Font.Gotham
		OptionSelecting.Text = "Select Option"
		OptionSelecting.TextColor3 = Color3.fromRGB(200, 200, 200)
		OptionSelecting.TextSize = 13
		OptionSelecting.TextWrapped = true
		OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
		OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
		OptionSelecting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionSelecting.BackgroundTransparency = 0.999
		OptionSelecting.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionSelecting.BorderSizePixel = 0
		OptionSelecting.Position = UDim2.new(0, 10, 0.5, 0)
		OptionSelecting.Size = UDim2.new(1, -40, 1, -8)
		OptionSelecting.Name = "OptionSelecting"
		OptionSelecting.Parent = SelectOptionsFrame

		local OptionImg = Instance.new("ImageLabel")
		OptionImg.Image = "rbxassetid://16851841101"
		OptionImg.ImageColor3 = Color3.fromRGB(200, 200, 200)
		OptionImg.AnchorPoint = Vector2.new(1, 0.5)
		OptionImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionImg.BackgroundTransparency = 0.999
		OptionImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionImg.BorderSizePixel = 0
		OptionImg.Position = UDim2.new(1, -10, 0.5, 0)
		OptionImg.Size = UDim2.new(0, 18, 0, 18)
		OptionImg.Name = "OptionImg"
		OptionImg.Parent = SelectOptionsFrame
		
		local DropdownList = Instance.new("Frame")
		DropdownList.AnchorPoint = Vector2.new(1, 0)
		DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		DropdownList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownList.BorderSizePixel = 0
		DropdownList.Position = UDim2.new(1, -15, 0, 45)
		DropdownList.Size = UDim2.new(0, 180, 0, 0)
		DropdownList.Name = "DropdownList"
		DropdownList.Visible = false
		DropdownList.ClipsDescendants = true
		DropdownList.ZIndex = 10
		DropdownList.Parent = ScreenGui

		local ListCorner = Instance.new("UICorner")
		ListCorner.CornerRadius = UDim.new(0, 12)
		ListCorner.Parent = DropdownList

		local ListStroke = Instance.new("UIStroke")
		ListStroke.Color = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		ListStroke.Thickness = 2
		ListStroke.Transparency = 0.5
		ListStroke.Parent = DropdownList

		local ListScroll = Instance.new("ScrollingFrame")
		ListScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
		ListScroll.ScrollBarThickness = 4
		ListScroll.Active = true
		ListScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ListScroll.BackgroundTransparency = 0.999
		ListScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ListScroll.BorderSizePixel = 0
		ListScroll.Size = UDim2.new(1, -10, 1, -10)
		ListScroll.Position = UDim2.new(0, 5, 0, 5)
		ListScroll.Name = "ListScroll"
		ListScroll.ZIndex = 11
		ListScroll.Parent = DropdownList

		local ListLayout = Instance.new("UIListLayout")
		ListLayout.Padding = UDim.new(0, 3)
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
					totalHeight = totalHeight + child.Size.Y.Offset + 3
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
						if i > 3 then
							displayText = displayText .. ", ..."
							break
						end
						displayText = displayText .. (i > 1 and ", " or "") .. v
					end
					OptionSelecting.Text = displayText
				else
					OptionSelecting.Text = "Select Option"
				end
			else
				OptionSelecting.Text = dropdownData.Value or "Select Option"
			end
		end
		
		local function ToggleDropdown()
			dropdownData.Open = not dropdownData.Open
			if dropdownData.Open then
				local dropdownAbsPos = Dropdown.AbsolutePosition
				local dropdownAbsSize = Dropdown.AbsoluteSize
				local screenSize = UserInputService:GetScaledInnerPosition().Y + UserInputService:GetScreenResolution().Y
				
				local posY = dropdownAbsPos.Y + dropdownAbsSize.Y + 5
				if posY + 200 > screenSize then
					DropdownList.Position = UDim2.new(1, -15, 0, -DropdownList.Size.Y.Offset - 5)
				else
					DropdownList.Position = UDim2.new(1, -15, 0, 45)
				end
				
				DropdownList.Visible = true
				TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 180, 0, math.min(200, ListScroll.CanvasSize.Y.Offset + 15))
				}):Play()
				TweenService:Create(OptionImg, TweenInfo.new(0.3), {Rotation = 180}):Play()
			else
				TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 180, 0, 0)
				}):Play()
				TweenService:Create(OptionImg, TweenInfo.new(0.3), {Rotation = 0}):Play()
				task.wait(0.3)
				DropdownList.Visible = false
			end
		end
		
		local function CreateOption(optionName)
			local Option = Instance.new("Frame")
			Option.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
			Option.BackgroundTransparency = 0
			Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Option.BorderSizePixel = 0
			Option.Size = UDim2.new(1, 0, 0, 36)
			Option.Name = "Option"
			Option.ZIndex = 12
			Option.Parent = ListScroll

			local OptionCorner = Instance.new("UICorner")
			OptionCorner.CornerRadius = UDim.new(0, 6)
			OptionCorner.Parent = Option

			local OptionButton = Instance.new("TextButton")
			OptionButton.Font = Enum.Font.Gotham
			OptionButton.Text = ""
			OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			OptionButton.TextSize = 13
			OptionButton.TextXAlignment = Enum.TextXAlignment.Left
			OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OptionButton.BackgroundTransparency = 0.999
			OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OptionButton.BorderSizePixel = 0
			OptionButton.Size = UDim2.new(1, 0, 1, 0)
			OptionButton.Name = "OptionButton"
			OptionButton.ZIndex = 13
			OptionButton.Parent = Option

			local OptionText = Instance.new("TextLabel")
			OptionText.Font = Enum.Font.Gotham
			OptionText.Text = optionName
			OptionText.TextSize = 13
			OptionText.TextColor3 = Color3.fromRGB(230, 230, 230)
			OptionText.TextXAlignment = Enum.TextXAlignment.Left
			OptionText.TextYAlignment = Enum.TextYAlignment.Center
			OptionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OptionText.BackgroundTransparency = 0.999
			OptionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OptionText.BorderSizePixel = 0
			OptionText.Position = UDim2.new(0, 10, 0, 0)
			OptionText.Size = UDim2.new(1, -40, 1, 0)
			OptionText.Name = "OptionText"
			OptionText.ZIndex = 14
			OptionText.Parent = Option

			local ChooseFrame = Instance.new("Frame")
			ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
			ChooseFrame.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
			ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ChooseFrame.BorderSizePixel = 0
			ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
			ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
			ChooseFrame.Name = "ChooseFrame"
			ChooseFrame.ZIndex = 15
			ChooseFrame.Parent = Option
			
			local ChooseStroke = Instance.new("UIStroke")
			ChooseStroke.Color = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
			ChooseStroke.Thickness = 1.6
			ChooseStroke.Transparency = 0.999
			ChooseStroke.ZIndex = 16
			ChooseStroke.Parent = ChooseFrame
			
			local ChooseCorner = Instance.new("UICorner")
			ChooseCorner.Parent = ChooseFrame
			
			local function UpdateOptionVisual()
				local isSelected = false
				if dropdownData.Multi then
					isSelected = table.find(dropdownData.Value, optionName) ~= nil
				else
					isSelected = dropdownData.Value == optionName
				end
				
				if isSelected then
					TweenService:Create(ChooseStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
					TweenService:Create(ChooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 18)}):Play()
					TweenService:Create(Option, TweenInfo.new(0.2), {BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]:lerp(Color3.fromRGB(45, 45, 50), 0.3)}):Play()
					TweenService:Create(OptionText, TweenInfo.new(0.2), {TextColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]}):Play()
				else
					TweenService:Create(ChooseStroke, TweenInfo.new(0.2), {Transparency = 0.999}):Play()
					TweenService:Create(ChooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
					TweenService:Create(Option, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
					TweenService:Create(OptionText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
				end
			end
			
			OptionButton.Activated:Connect(function()
				CircleClick(OptionButton, Mouse.X, Mouse.Y)
				
				if dropdownData.Multi then
					local index = table.find(dropdownData.Value, optionName)
					if index then
						table.remove(dropdownData.Value, index)
					else
						table.insert(dropdownData.Value, optionName)
					end
				else
					for _, child in ListScroll:GetChildren() do
						if child:IsA("Frame") and child.Name == "Option" then
							local childChooseFrame = child:FindFirstChild("ChooseFrame")
							local childChooseStroke = childChooseFrame and childChooseFrame:FindFirstChild("UIStroke")
							local childOptionText = child:FindFirstChild("OptionText")
							
							if childOptionText and childOptionText.Text ~= optionName then
								if childChooseStroke then
									TweenService:Create(childChooseStroke, TweenInfo.new(0.2), {Transparency = 0.999}):Play()
								end
								if childChooseFrame then
									TweenService:Create(childChooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
								end
								TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
								TweenService:Create(childOptionText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
							end
						end
					end
					
					dropdownData.Value = optionName
				end
				
				UpdateOptionVisual()
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
		
		DropdownButton.Activated:Connect(function()
			CircleClick(DropdownButton, Mouse.X, Mouse.Y)
			ToggleDropdown()
		end)
		
		local dropdownConnection
		dropdownConnection = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if dropdownData.Open and DropdownList.Visible then
					local mousePos = input.Position
					local dropdownPos = DropdownList.AbsolutePosition
					local dropdownSize = DropdownList.AbsoluteSize
					local selectFramePos = SelectOptionsFrame.AbsolutePosition
					local selectFrameSize = SelectOptionsFrame.AbsoluteSize
					
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
		
		task.wait(0.1)
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
					local optionName = child.OptionText.Text
					local isSelected = false
					if dropdownData.Multi then
						isSelected = table.find(dropdownData.Value, optionName) ~= nil
					else
						isSelected = dropdownData.Value == optionName
					end
					
					local chooseFrame = child:FindFirstChild("ChooseFrame")
					local chooseStroke = chooseFrame and chooseFrame:FindFirstChild("UIStroke")
					local optionText = child:FindFirstChild("OptionText")
					if chooseFrame and chooseStroke and optionText then
						if isSelected then
							TweenService:Create(chooseStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
							TweenService:Create(chooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 18)}):Play()
							TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]:lerp(Color3.fromRGB(45, 45, 50), 0.3)}):Play()
							TweenService:Create(optionText, TweenInfo.new(0.2), {TextColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]}):Play()
						else
							TweenService:Create(chooseStroke, TweenInfo.new(0.2), {Transparency = 0.999}):Play()
							TweenService:Create(chooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
							TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
							TweenService:Create(optionText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
						end
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

	local function CreateSlider(tabContainer, title, content, minValue, maxValue, defaultValue, callback, elementId)
		if not tabContainer or not tabContainer:IsA("Frame") then return end
		
		local Slider = Instance.new("Frame")
		Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		Slider.BackgroundTransparency = 0
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.Size = UDim2.new(1, 0, 0, 46)
		Slider.Name = "Slider"
		Slider.Parent = tabContainer

		local SliderCorner = Instance.new("UICorner")
		SliderCorner.CornerRadius = UDim.new(0, 12)
		SliderCorner.Parent = Slider

		local SliderTitle = Instance.new("TextLabel")
		SliderTitle.Font = Enum.Font.GothamBold
		SliderTitle.Text = title
		SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		SliderTitle.TextSize = 14
		SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
		SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
		SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SliderTitle.BackgroundTransparency = 0.999
		SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderTitle.BorderSizePixel = 0
		SliderTitle.Position = UDim2.new(0, 15, 0, 12)
		SliderTitle.Size = UDim2.new(1, -100, 0, 16)
		SliderTitle.Name = "SliderTitle"
		SliderTitle.Parent = Slider

		local SliderContent = Instance.new("TextLabel")
		SliderContent.Font = Enum.Font.Gotham
		SliderContent.Text = content
		SliderContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		SliderContent.TextSize = 13
		SliderContent.TextXAlignment = Enum.TextXAlignment.Left
		SliderContent.TextYAlignment = Enum.TextYAlignment.Top
		SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SliderContent.BackgroundTransparency = 0.999
		SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderContent.BorderSizePixel = 0
		SliderContent.Position = UDim2.new(0, 15, 0, 32)
		SliderContent.Size = UDim2.new(1, -100, 0, 13)
		SliderContent.Name = "SliderContent"
		SliderContent.Parent = Slider
		
		local textSize = TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(ContentScroll.AbsoluteSize.X - 130, math.huge))
		
		SliderContent.Size = UDim2.new(1, -100, 0, textSize.Y)
		SliderContent.TextWrapped = true
		
		local ValueDisplay = Instance.new("TextLabel")
		ValueDisplay.Font = Enum.Font.GothamBold
		ValueDisplay.Text = tostring(defaultValue or minValue)
		ValueDisplay.TextColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		ValueDisplay.TextSize = 14
		ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
		ValueDisplay.AnchorPoint = Vector2.new(1, 0)
		ValueDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueDisplay.BackgroundTransparency = 0.999
		ValueDisplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueDisplay.BorderSizePixel = 0
		ValueDisplay.Position = UDim2.new(1, -15, 0, 12)
		ValueDisplay.Size = UDim2.new(0, 50, 0, 16)
		ValueDisplay.Name = "ValueDisplay"
		ValueDisplay.Parent = Slider

		Slider.Size = UDim2.new(1, 0, 0, math.max(80, textSize.Y + 54))
		
		local SliderFrame = Instance.new("Frame")
		SliderFrame.AnchorPoint = Vector2.new(0, 0)
		SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		SliderFrame.BackgroundTransparency = 0
		SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderFrame.BorderSizePixel = 0
		SliderFrame.Position = UDim2.new(0, 15, 0, textSize.Y + 44)
		SliderFrame.Size = UDim2.new(1, -30, 0, 6)
		SliderFrame.Name = "SliderFrame"
		SliderFrame.Parent = Slider

		local FrameCorner = Instance.new("UICorner")
		FrameCorner.CornerRadius = UDim.new(0, 3)
		FrameCorner.Parent = SliderFrame

		local SliderFill = Instance.new("Frame")
		SliderFill.AnchorPoint = Vector2.new(0, 0.5)
		SliderFill.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderFill.BorderSizePixel = 0
		SliderFill.Position = UDim2.new(0, 0, 0.5, 0)
		SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
		SliderFill.Name = "SliderFill"
		SliderFill.Parent = SliderFrame

		local FillCorner = Instance.new("UICorner")
		FillCorner.CornerRadius = UDim.new(0, 3)
		FillCorner.Parent = SliderFill

		local SliderCircle = Instance.new("Frame")
		SliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		SliderCircle.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderCircle.BorderSizePixel = 0
		SliderCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
		SliderCircle.Size = UDim2.new(0, 16, 0, 16)
		SliderCircle.Name = "SliderCircle"
		SliderCircle.Parent = SliderFrame

		local CircleCorner = Instance.new("UICorner")
		CircleCorner.CornerRadius = UDim.new(1, 0)
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
			Dragging = false,
			TouchInput = nil
		}
		
		local function Round(num, decimalPlaces)
			local mult = 10^(decimalPlaces or 0)
			return math.floor(num * mult + 0.5) / mult
		end
		
		local function SetValue(value, instant)
			value = math.clamp(value, sliderData.Min, sliderData.Max)
			sliderData.Value = Round(value, 0)
			
			ValueDisplay.Text = tostring(sliderData.Value)
			
			local percentage = (sliderData.Value - sliderData.Min) / (sliderData.Max - sliderData.Min)
			
			if instant then
				SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
				SliderCircle.Position = UDim2.new(percentage, 0, 0.5, 0)
			else
				TweenService:Create(
					SliderFill,
					TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Size = UDim2.new(percentage, 0, 1, 0)}
				):Play()
				TweenService:Create(
					SliderCircle,
					TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Position = UDim2.new(percentage, 0, 0.5, 0)}
				):Play()
			end
			
			if callback then
				callback(sliderData.Value)
			end
		end
		
		local startValue = defaultValue or minValue or 0
		SetValue(startValue, true)
		
		local function UpdateSliderFromInput(input)
			local inputPos
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				inputPos = input.Position
			elseif input.UserInputType == Enum.UserInputType.Touch then
				inputPos = input.Position
			else
				return
			end
			
			local sliderPos = SliderFrame.AbsolutePosition
			local sliderSize = SliderFrame.AbsoluteSize
			
			local percentage = math.clamp((inputPos.X - sliderPos.X) / sliderSize.X, 0, 1)
			local value = sliderData.Min + (percentage * (sliderData.Max - sliderData.Min))
			
			SetValue(value)
		end
		
		SliderFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				sliderData.Dragging = true
				sliderData.TouchInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
				UpdateSliderFromInput(input)
			end
		end)
		
		local connection
		connection = UserInputService.InputChanged:Connect(function(input)
			if sliderData.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
			   (input.UserInputType == Enum.UserInputType.Touch and sliderData.TouchInput and input == sliderData.TouchInput)) then
				UpdateSliderFromInput(input)
			end
		end)
		
		UserInputService.InputEnded:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 and sliderData.Dragging) or
			   (input.UserInputType == Enum.UserInputType.Touch and sliderData.TouchInput and input == sliderData.TouchInput) then
				sliderData.Dragging = false
				sliderData.TouchInput = nil
			end
		end)
		
		Slider.Destroying:Connect(function()
			if connection then
				connection:Disconnect()
			end
		end)
		
		task.wait(0.1)
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

	local function CreateTabButton(tabName, iconId, isConfigTab)
		TabCount = TabCount + 1
		
		local Tab = Instance.new("Frame")
		Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		Tab.BackgroundTransparency = 0.999
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.Size = UDim2.new(1, -10, 0, 40)
		Tab.LayoutOrder = isConfigTab and 999 or TabCount
		Tab.Name = "Tab"
		Tab.Parent = TabScroll

		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 8)
		TabCorner.Parent = Tab

		local TabButton = Instance.new("TextButton")
		TabButton.Font = Enum.Font.GothamBold
		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.TextSize = 13
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundTransparency = 0.999
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Name = "TabButton"
		TabButton.Parent = Tab

		local TabNameLabel = Instance.new("TextLabel")
		TabNameLabel.Font = Enum.Font.Gotham
		TabNameLabel.Text = tabName
		TabNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabNameLabel.TextSize = 13
		TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabNameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabNameLabel.BackgroundTransparency = 0.999
		TabNameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabNameLabel.BorderSizePixel = 0
		TabNameLabel.Size = UDim2.new(1, -45, 1, 0)
		TabNameLabel.Position = UDim2.new(0, 40, 0, 0)
		TabNameLabel.Name = "TabName"
		TabNameLabel.Parent = Tab

		local FeatureImg = Instance.new("ImageLabel")
		FeatureImg.Image = iconId or "rbxassetid://16932740082"
		FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FeatureImg.BackgroundTransparency = 0.999
		FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FeatureImg.BorderSizePixel = 0
		FeatureImg.Position = UDim2.new(0, 12, 0, 10)
		FeatureImg.Size = UDim2.new(0, 20, 0, 20)
		FeatureImg.Name = "FeatureImg"
		FeatureImg.Parent = Tab

		local ChooseFrame = Instance.new("Frame")
		ChooseFrame.BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ChooseFrame.BorderSizePixel = 0
		ChooseFrame.Position = UDim2.new(0, 2, 0, 14)
		ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
		ChooseFrame.Name = "ChooseFrame"
		ChooseFrame.Parent = Tab

		local ChooseStroke = Instance.new("UIStroke")
		ChooseStroke.Color = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]
		ChooseStroke.Thickness = 2
		ChooseStroke.Parent = ChooseFrame

		local ChooseCorner = Instance.new("UICorner")
		ChooseCorner.Parent = ChooseFrame
		
		table.insert(ConfigSystem.TabElements, Tab)
		
		local TabContentContainer = Instance.new("Frame")
		TabContentContainer.BackgroundTransparency = 1
		TabContentContainer.Size = UDim2.new(1, 0, 0, 0)
		TabContentContainer.Visible = false
		TabContentContainer.LayoutOrder = isConfigTab and 999 or TabCount
		TabContentContainer.Name = tabName.."Content"
		TabContentContainer.Parent = ContentScroll
		
		local Layout = Instance.new("UIListLayout")
		Layout.Padding = UDim.new(0, 10)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Parent = TabContentContainer

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContentContainer.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
			ContentScroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
		end)
		
		TabContents[tabName] = TabContentContainer
		
		local function SwitchToTab()
			for name, container in pairs(TabContents) do
				container.Visible = false
			end
			
			for _, tabFrame in TabScroll:GetChildren() do
				if tabFrame:IsA("Frame") and tabFrame.Name == "Tab" then
					local chooseFrame = tabFrame:FindFirstChild("ChooseFrame")
					if chooseFrame then
						TweenService:Create(chooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
					end
					TweenService:Create(tabFrame, TweenInfo.new(0.2), {
						BackgroundTransparency = 0.999,
						BackgroundColor3 = Color3.fromRGB(35, 35, 40)
					}):Play()
				end
			end
			
			TabContentContainer.Visible = true
			TweenService:Create(ChooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 18)}):Play()
			TweenService:Create(Tab, TweenInfo.new(0.2), {
				BackgroundTransparency = 0,
				BackgroundColor3 = ConfigSystem.ThemeColors[ConfigSystem.CurrentTheme]:lerp(Color3.fromRGB(35, 35, 40), 0.3)
			}):Play()
			ContentTitle.Text = tabName
			CurrentTab = tabName
			UpdateContentSize()
		end

		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			SwitchToTab()
		end)

		return TabContentContainer, SwitchToTab
	end

	local ConfigTabContainer, SwitchToConfigTab = CreateTabButton("Configs", "rbxassetid://16932740082", true)
	
	CreateParagraph(ConfigTabContainer, "Configuration Settings", "Manage your UI settings and themes here.")
	
	local themeNames = {}
	for themeName, _ in pairs(ConfigSystem.ThemeColors) do
		table.insert(themeNames, themeName)
	end
	
	local CurrentConfigName = ""
	
	local ThemeDropdown = CreateDropdown(ConfigTabContainer, "Theme", "Select UI theme color", themeNames, false, ConfigSystem.CurrentTheme, function(value)
		local success, themeColor = ConfigSystem:SetTheme(value)
		if success then
			MakeNotify({
				Title = "Theme",
				Description = "Changed",
				Content = "Theme changed to " .. value .. "!",
				Color = themeColor,
				Delay = 3
			})
			if MinimizeButton and MinimizeButton:FindFirstChild("UIStroke") then
				TweenService:Create(MinimizeButton.UIStroke, TweenInfo.new(0.3), {Color = themeColor}):Play()
			end
		end
	end, "ThemeDropdown")
	
	local TransparencyToggle = CreateToggle(ConfigTabContainer, "UI Transparency", "Toggle UI background transparency", false, function(state)
		if state then
			TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
			TweenService:Create(TabFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
			TweenService:Create(ContentFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
		else
			TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
			TweenService:Create(TabFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
			TweenService:Create(ContentFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
		end
	end, "TransparencyToggle")
	
	local ConfigNameInput = CreateInput(ConfigTabContainer, "Config Name", "Enter name for your config", "MyConfig", function(value)
		CurrentConfigName = value
	end, "ConfigNameInput")
	
	CreateButton(ConfigTabContainer, "Save Config", "Save current settings to config", "rbxassetid://16932740082", function()
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
			MakeNotify(notifyData)
			
			local configList = ConfigSystem:GetConfigList()
			LoadConfigDropdown:Refresh(configList)
			DeleteConfigDropdown:Refresh(configList)
		else
			MakeNotify({
				Title = "Config",
				Description = "Error",
				Content = "Please enter a config name first!",
				Color = Color3.fromRGB(255, 50, 50),
				Delay = 3
			})
		end
	end)
	
	local LoadConfigDropdown = CreateDropdown(ConfigTabContainer, "Load Config", "Select config to load", {}, false, nil, function(value)
		if value then
			local notifyData, configData = ConfigSystem:LoadConfig(value)
			MakeNotify(notifyData)
			
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
	
	local DeleteConfigDropdown = CreateDropdown(ConfigTabContainer, "Delete Config", "Select config to delete", {}, false, nil, function(value)
		if value then
			local notifyData = ConfigSystem:DeleteConfig(value)
			MakeNotify(notifyData)
			
			local configList = ConfigSystem:GetConfigList()
			LoadConfigDropdown:Refresh(configList)
			DeleteConfigDropdown:Refresh(configList)
		end
	end, "DeleteConfigDropdown")
	
	CreateParagraph(ConfigTabContainer, "Note", "Configs are saved locally for this session. In a full implementation, they would be saved to DataStore.")

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

	function Window:AddToggle(tabContainer, title, content, defaultValue, callback, elementId)
		return CreateToggle(tabContainer, title, content, defaultValue, callback, elementId)
	end

	function Window:AddInput(tabContainer, title, content, placeholder, callback, elementId)
		return CreateInput(tabContainer, title, content, placeholder, callback, elementId)
	end

	function Window:AddDropdown(tabContainer, title, content, options, multi, defaultValue, callback, elementId)
		return CreateDropdown(tabContainer, title, content, options, multi, defaultValue, callback, elementId)
	end

	function Window:AddSlider(tabContainer, title, content, minValue, maxValue, defaultValue, callback, elementId)
		return CreateSlider(tabContainer, title, content, minValue, maxValue, defaultValue, callback, elementId)
	end

	function Window:Notify(notifyConfig)
		return MakeNotify(notifyConfig)
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
		MakeNotify(notifyData)
	end

	function Window:LoadConfig(name)
		local notifyData, configData = ConfigSystem:LoadConfig(name)
		MakeNotify(notifyData)
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
		MakeNotify(notifyData)
	end

	function Window:GetConfigs()
		return ConfigSystem:GetConfigList()
	end

	function Window:Destroy()
		ScreenGui:Destroy()
	end

	function Window:Minimize()
		isMinimized = true
		DropShadowHolder.Visible = false
		if MinimizeButton then
			MinimizeButton.Visible = true
			TweenService:Create(MinimizeButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 50, 0, 50)
			}):Play()
		end
	end

	function Window:Restore()
		isMinimized = false
		DropShadowHolder.Visible = true
		if MinimizeButton then
			MinimizeButton.Visible = false
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = Size,
				Position = Center and UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2) or DropShadowHolder.Position
			}):Play()
		end
	end

	return Window
end

return JaelVaelorUI
