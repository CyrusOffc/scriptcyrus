

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextService")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Remove annoying portals in certain games
task.spawn(function()
    pcall(function()
        if game.PlaceId == 3623096087 then
            if game.Workspace:FindFirstChild("RobloxForwardPortals") then
                game.Workspace.RobloxForwardPortals:Destroy()
            end
        end
    end)
end)

-- GUI Protection
local ProtectGui = protectgui or (syn and syn.protect_gui) or (function(f) end)

-- Enhanced Theme System with Gradient Support
local Themes = {
    Names = {"CyberX", "NeonDream", "DarkMatter", "SolarFlare", "OceanDepth"},
    
    CyberX = {
        Name = "CyberX",
        Accent = Color3.fromRGB(0, 255, 255),
        AccentSecondary = Color3.fromRGB(255, 0, 255),
        
        Background = Color3.fromRGB(10, 15, 25),
        BackgroundSecondary = Color3.fromRGB(15, 20, 35),
        BackgroundTertiary = Color3.fromRGB(20, 25, 45),
        
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 200),
        TextDisabled = Color3.fromRGB(100, 100, 120),
        
        Element = Color3.fromRGB(30, 40, 60),
        ElementHover = Color3.fromRGB(40, 50, 80),
        ElementActive = Color3.fromRGB(50, 60, 100),
        
        Border = Color3.fromRGB(0, 150, 255),
        BorderSecondary = Color3.fromRGB(100, 200, 255),
        
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(255, 50, 50),
        Info = Color3.fromRGB(0, 150, 255),
        
        -- Acrylic Properties
        AcrylicMain = Color3.fromRGB(15, 20, 35),
        AcrylicBorder = Color3.fromRGB(0, 150, 255),
        AcrylicNoise = 0.6,
        
        -- Gradient Profiles
        GradientPrimary = ColorSequence.new(
            Color3.fromRGB(0, 100, 255),
            Color3.fromRGB(150, 0, 255)
        ),
        GradientSecondary = ColorSequence.new(
            Color3.fromRGB(255, 0, 150),
            Color3.fromRGB(0, 200, 255)
        ),
        
        -- Glow Effects
        GlowColor = Color3.fromRGB(0, 200, 255),
        GlowIntensity = 0.3,
        
        -- Transparencies
        ElementTransparency = 0.1,
        BackgroundTransparency = 0.05,
        BlurIntensity = 0.95,
        
        -- Animation Speeds
        HoverSpeed = 0.15,
        ClickSpeed = 0.1,
        TransitionSpeed = 0.25,
    },
    
    NeonDream = {
        Name = "NeonDream",
        Accent = Color3.fromRGB(255, 20, 147),
        AccentSecondary = Color3.fromRGB(0, 255, 255),
        
        Background = Color3.fromRGB(20, 5, 30),
        BackgroundSecondary = Color3.fromRGB(30, 10, 40),
        BackgroundTertiary = Color3.fromRGB(40, 15, 50),
        
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 180, 220),
        TextDisabled = Color3.fromRGB(120, 100, 140),
        
        Element = Color3.fromRGB(40, 20, 60),
        ElementHover = Color3.fromRGB(60, 30, 80),
        ElementActive = Color3.fromRGB(80, 40, 100),
        
        Border = Color3.fromRGB(255, 20, 147),
        BorderSecondary = Color3.fromRGB(0, 255, 255),
        
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 50, 100),
        Info = Color3.fromRGB(0, 200, 255),
        
        -- Neon Glow Properties
        GlowColor = Color3.fromRGB(255, 20, 147),
        GlowIntensity = 0.4,
        
        GradientPrimary = ColorSequence.new(
            Color3.fromRGB(255, 20, 147),
            Color3.fromRGB(0, 255, 255)
        ),
        
        ElementTransparency = 0.05,
        BackgroundTransparency = 0.02,
        BlurIntensity = 0.9,
        
        HoverSpeed = 0.12,
        ClickSpeed = 0.08,
        TransitionSpeed = 0.2,
    }
}

-- Advanced Library Core
local Library = {
    Version = "2.0.0",
    Theme = "CyberX",
    UseAcrylic = true,
    DialogOpen = false,
    Minimized = false,
    Maximized = false,
    
    -- Animation Settings
    AnimationEnabled = true,
    AnimationSpeed = 1.0,
    
    -- Mobile Detection
    IsMobile = UserInputService.TouchEnabled,
    IsConsole = UserInputService.GamepadEnabled,
    
    -- Performance
    UseDebounce = true,
    DebounceTime = 0.1,
    
    -- Storage
    Options = {},
    OpenFrames = {},
    Signals = {},
    
    -- Window Management
    Windows = {},
    ActiveWindow = nil,
    
    -- Notification System
    Notifications = {},
    MaxNotifications = 5,
    
    -- Sound Effects
    Sounds = {
        Click = "rbxassetid://9117826386",
        Hover = "rbxassetid://9117826677",
        Toggle = "rbxassetid://9117826901",
        Notification = "rbxassetid://9117827102",
        Error = "rbxassetid://9117827303"
    },
    
    -- Icon System
    Icons = {
        Close = "rbxassetid://9924339735",
        Minimize = "rbxassetid://9924340001",
        Maximize = "rbxassetid://9924340234",
        Restore = "rbxassetid://9924340456",
        Settings = "rbxassetid://9924340678",
        Info = "rbxassetid://9924340890",
        Warning = "rbxassetid://9924341112",
        Success = "rbxassetid://9924341334",
        ArrowDown = "rbxassetid://9924341556",
        ArrowUp = "rbxassetid://9924341778",
        Check = "rbxassetid://9924342000",
        Cross = "rbxassetid://9924342222"
    }
}

-- Performance Optimizations
local lastRenderTime = 0
local renderDelta = 0
local frameCount = 0
local fps = 60

-- FPS Counter (for debugging)
task.spawn(function()
    while task.wait(1) do
        fps = frameCount
        frameCount = 0
    end
end)

RunService.RenderStepped:Connect(function(delta)
    frameCount = frameCount + 1
    renderDelta = delta
end)

-- Sound System
local SoundSystem = {
    Enabled = true,
    Volume = 0.5,
    Sounds = {}
}

function SoundSystem:Play(soundId)
    if not self.Enabled then return end
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = self.Volume
    sound.Parent = workspace
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 5)
end

-- Enhanced Creator Class
local Creator = {
    Objects = {},
    Motions = {},
    Effects = {}
}

function Creator.New(className, properties, children)
    local obj = Instance.new(className)
    
    -- Apply default properties
    local defaults = {
        Frame = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0
        },
        TextLabel = {
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham,
            TextSize = 14
        },
        TextButton = {
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham,
            TextSize = 14
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        },
        ImageButton = {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        },
        ScrollingFrame = {
            BackgroundTransparency = 1,
            ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
            ScrollBarThickness = 3,
            BorderSizePixel = 0
        },
        UIStroke = {
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        },
        UICorner = {
            CornerRadius = UDim.new(0, 8)
        }
    }
    
    if defaults[className] then
        for prop, value in pairs(defaults[className]) do
            obj[prop] = value
        end
    end
    
    -- Apply custom properties
    if properties then
        for prop, value in pairs(properties) do
            if prop ~= "ThemeTag" then
                obj[prop] = value
            end
        end
    end
    
    -- Add children
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    
    -- Theme support
    if properties and properties.ThemeTag then
        Creator.ApplyTheme(obj, properties.ThemeTag)
    end
    
    table.insert(Creator.Objects, obj)
    return obj
end

function Creator.ApplyTheme(object, themeTags)
    local theme = Themes[Library.Theme] or Themes.CyberX
    
    for property, tag in pairs(themeTags) do
        if theme[tag] then
            object[property] = theme[tag]
        end
    end
end

-- Advanced Animation System
local AnimationSystem = {
    Springs = {},
    Tweens = {},
    Sequences = {}
}

function AnimationSystem:CreateSpring(target, property, speed, damping)
    local spring = {
        target = target,
        property = property,
        velocity = 0,
        position = target[property],
        speed = speed or 10,
        damping = damping or 0.7,
        active = true
    }
    
    table.insert(self.Springs, spring)
    return spring
end

function AnimationSystem:Update(delta)
    for i, spring in ipairs(self.Springs) do
        if spring.active and spring.target and spring.target.Parent then
            local goal = spring.position
            local current = spring.target[spring.property]
            
            if typeof(current) == "number" then
                local force = (goal - current) * spring.speed
                spring.velocity = spring.velocity * (1 - spring.damping * delta) + force * delta
                spring.target[spring.property] = current + spring.velocity * delta
                
                if math.abs(spring.velocity) < 0.001 and math.abs(goal - current) < 0.001 then
                    spring.target[spring.property] = goal
                    spring.active = false
                end
            end
        else
            table.remove(self.Springs, i)
        end
    end
end

RunService.RenderStepped:Connect(function(delta)
    AnimationSystem:Update(delta)
end)

-- Particle System for Effects
local ParticleSystem = {
    Particles = {},
    Templates = {}
}

function ParticleSystem:Emit(position, count, template)
    for i = 1, count do
        local particle = Creator.New("Frame", {
            Size = UDim2.new(0, 4, 0, 4),
            Position = UDim2.new(0, position.X, 0, position.Y),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Library.GUI
        }, {
            Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Creator.New("UIStroke", {
                Thickness = 1,
                Color = Color3.fromRGB(255, 255, 255)
            })
        })
        
        local velocity = Vector2.new(
            (math.random() - 0.5) * 200,
            (math.random() - 0.5) * 200 - 100
        )
        
        table.insert(self.Particles, {
            object = particle,
            velocity = velocity,
            life = 1,
            maxLife = 1
        })
    end
end

function ParticleSystem:Update(delta)
    for i = #self.Particles, 1, -1 do
        local particle = self.Particles[i]
        particle.life = particle.life - delta
        
        if particle.life <= 0 then
            particle.object:Destroy()
            table.remove(self.Particles, i)
        else
            local alpha = particle.life / particle.maxLife
            particle.object.BackgroundTransparency = 1 - alpha * 0.5
            particle.object.UIStroke.Transparency = 1 - alpha
            
            local pos = particle.object.Position
            particle.object.Position = UDim2.new(
                0, pos.X.Offset + particle.velocity.X * delta,
                0, pos.Y.Offset + particle.velocity.Y * delta
            )
            
            particle.velocity = particle.velocity * 0.95
        end
    end
end

RunService.RenderStepped:Connect(function(delta)
    ParticleSystem:Update(delta)
end)

-- Advanced Component System
local Components = {}

-- Enhanced Button with Ripple Effect
Components.Button = function(config)
    local button = Creator.New("TextButton", {
        Name = config.Name or "Button",
        Size = config.Size or UDim2.new(0, 120, 0, 40),
        Position = config.Position,
        Parent = config.Parent,
        Text = config.Text or "Button",
        AutoButtonColor = false,
        ThemeTag = {
            BackgroundColor3 = "Element",
            TextColor3 = "Text"
        }
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Creator.New("UIStroke", {
            ThemeTag = {
                Color = "Border"
            }
        }),
        Creator.New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8)
        })
    })
    
    -- Ripple Effect Container
    local rippleContainer = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    rippleContainer.Parent = button
    
    -- Hover Animation
    local hoverAnimation = AnimationSystem:CreateSpring(button, "BackgroundTransparency", 15, 0.7)
    local strokeAnimation = AnimationSystem:CreateSpring(button.UIStroke, "Transparency", 15, 0.7)
    
    button.BackgroundTransparency = 0.8
    button.UIStroke.Transparency = 0.5
    
    -- Mouse Events
    button.MouseEnter:Connect(function()
        if Library.AnimationEnabled then
            hoverAnimation.position = 0.7
            strokeAnimation.position = 0.3
            SoundSystem:Play(Library.Sounds.Hover)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if Library.AnimationEnabled then
            hoverAnimation.position = 0.8
            strokeAnimation.position = 0.5
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        if Library.AnimationEnabled then
            hoverAnimation.position = 0.6
            strokeAnimation.position = 0.2
            
            -- Create ripple effect
            local ripple = Creator.New("Frame", {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.7,
                Parent = rippleContainer
            }, {
                Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(2, 0, 2, 0),
                BackgroundTransparency = 1
            }):Play()
            
            task.delay(0.5, function()
                ripple:Destroy()
            end)
            
            SoundSystem:Play(Library.Sounds.Click)
            ParticleSystem:Emit(Vector2.new(button.AbsolutePosition.X + button.AbsoluteSize.X/2, 
                                           button.AbsolutePosition.Y + button.AbsoluteSize.Y/2), 5)
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        if Library.AnimationEnabled then
            hoverAnimation.position = 0.7
            strokeAnimation.position = 0.3
        end
    end)
    
    -- Click Event
    if config.Callback then
        button.MouseButton1Click:Connect(function()
            if Library.UseDebounce then
                local lastClick = button:GetAttribute("LastClick") or 0
                if tick() - lastClick < Library.DebounceTime then return end
                button:SetAttribute("LastClick", tick())
            end
            
            pcall(config.Callback)
        end)
    end
    
    return button
end

-- Enhanced Toggle with Smooth Animation
Components.Toggle = function(config)
    local toggle = {
        Value = config.Default or false,
        Callback = config.Callback
    }
    
    local container = Creator.New("Frame", {
        Size = config.Size or UDim2.new(1, -20, 0, 50),
        Position = config.Position,
        Parent = config.Parent,
        BackgroundTransparency = 1
    })
    
    local toggleFrame = Creator.New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = container
    })
    
    -- Background
    local background = Creator.New("Frame", {
        Size = UDim2.new(0, 50, 0, 24),
        Position = UDim2.new(1, -60, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        ThemeTag = {
            BackgroundColor3 = "Element"
        }
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Creator.New("UIStroke", {
            ThemeTag = {
                Color = "Border"
            }
        })
    })
    background.Parent = toggleFrame
    
    -- Knob
    local knob = Creator.New("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Creator.New("UIStroke", {
            Thickness = 2,
            Color = Color3.fromRGB(100, 100, 100)
        })
    })
    knob.Parent = background
    
    -- Label
    local label = Creator.New("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Text = config.Text or "Toggle",
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = {
            TextColor3 = "Text"
        }
    }, {
        Creator.New("UIPadding", {
            PaddingLeft = UDim.new(0, 10)
        })
    })
    label.Parent = toggleFrame
    
    -- Description
    if config.Description then
        label.TextSize = 12
        local desc = Creator.New("TextLabel", {
            Size = UDim2.new(1, -60, 0, 14),
            Position = UDim2.new(0, 10, 1, -18),
            Text = config.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 11,
            ThemeTag = {
                TextColor3 = "SubText"
            }
        })
        desc.Parent = toggleFrame
    end
    
    -- Animation
    local knobSpring = AnimationSystem:CreateSpring(knob, "Position", 20, 0.7)
    local bgSpring = AnimationSystem:CreateSpring(background, "BackgroundColor3", 15, 0.7)
    
    function toggle:SetValue(value)
        toggle.Value = value
        
        if Library.AnimationEnabled then
            if value then
                knobSpring.position = UDim2.new(1, -22, 0.5, 0)
                bgSpring.position = Themes[Library.Theme].Success
            else
                knobSpring.position = UDim2.new(0, 2, 0.5, 0)
                bgSpring.position = Themes[Library.Theme].Element
            end
            
            SoundSystem:Play(Library.Sounds.Toggle)
        else
            knob.Position = value and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            background.BackgroundColor3 = value and Themes[Library.Theme].Success or Themes[Library.Theme].Element
        end
        
        if toggle.Callback then
            pcall(toggle.Callback, value)
        end
    end
    
    -- Click Event
    toggleFrame.MouseButton1Click:Connect(function()
        toggle:SetValue(not toggle.Value)
    end)
    
    -- Initialize
    toggle:SetValue(toggle.Value)
    
    return toggle
end

-- Enhanced Slider with Visual Feedback
Components.Slider = function(config)
    local slider = {
        Value = config.Default or config.Min or 0,
        Min = config.Min or 0,
        Max = config.Max or 100,
        Callback = config.Callback
    }
    
    local container = Creator.New("Frame", {
        Size = config.Size or UDim2.new(1, -20, 0, 70),
        Position = config.Position,
        Parent = config.Parent,
        BackgroundTransparency = 1
    })
    
    -- Title
    local title = Creator.New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Text = config.Text or "Slider",
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = {
            TextColor3 = "Text"
        }
    }, {
        Creator.New("UIPadding", {
            PaddingLeft = UDim.new(0, 5)
        })
    })
    title.Parent = container
    
    -- Value Display
    local valueDisplay = Creator.New("TextLabel", {
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(1, -65, 0, 0),
        Text = tostring(slider.Value),
        TextXAlignment = Enum.TextXAlignment.Right,
        ThemeTag = {
            TextColor3 = "SubText"
        }
    })
    valueDisplay.Parent = container
    
    -- Track
    local track = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 30),
        ThemeTag = {
            BackgroundColor3 = "Element"
        }
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Creator.New("UIStroke", {
            ThemeTag = {
                Color = "Border"
            }
        })
    })
    track.Parent = container
    
    -- Fill
    local fill = Creator.New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        ThemeTag = {
            BackgroundColor3 = "Accent"
        }
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    fill.Parent = track
    
    -- Handle
    local handle = Creator.New("TextButton", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, -10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        ZIndex = 2
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Creator.New("UIStroke", {
            Thickness = 3,
            Color = Themes[Library.Theme].Accent
        }),
        Creator.New("UIGradient", {
            Color = Themes[Library.Theme].GradientPrimary,
            Rotation = 45
        })
    })
    handle.Parent = track
    
    -- Handle Glow
    local glow = Creator.New("ImageLabel", {
        Size = UDim2.new(2, 0, 2, 0),
        Position = UDim2.new(-0.5, 0, -0.5, 0),
        Image = "rbxassetid://9924343111",
        ImageTransparency = 0.7,
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit
    })
    glow.Parent = handle
    
    -- Dragging Logic
    local isDragging = false
    
    local function updateSlider(xPosition)
        local relativeX = math.clamp((xPosition - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        slider.Value = math.floor(slider.Min + (slider.Max - slider.Min) * relativeX)
        
        -- Update display
        valueDisplay.Text = tostring(slider.Value)
        
        -- Update visuals
        local fillWidth = track.AbsoluteSize.X * relativeX
        fill.Size = UDim2.new(0, fillWidth, 1, 0)
        handle.Position = UDim2.new(relativeX, -10, 0.5, 0)
        
        -- Pulse effect on drag
        if isDragging then
            TweenService:Create(handle, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 24, 0, 24)
            }):Play()
        end
        
        if slider.Callback then
            pcall(slider.Callback, slider.Value)
        end
    end
    
    handle.MouseButton1Down:Connect(function()
        isDragging = true
        SoundSystem:Play(Library.Sounds.Click)
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if isDragging then
                updateSlider(UserInputService:GetMouseLocation().X)
            else
                connection:Disconnect()
            end
        end)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            TweenService:Create(handle, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 20, 0, 20)
            }):Play()
        end
    end)
    
    track.MouseButton1Down:Connect(function(x, y)
        updateSlider(x)
        SoundSystem:Play(Library.Sounds.Click)
    end)
    
    -- Initialize
    updateSlider(track.AbsolutePosition.X + track.AbsoluteSize.X * ((slider.Value - slider.Min) / (slider.Max - slider.Min)))
    
    return slider
end

-- Enhanced Dropdown with Search
Components.Dropdown = function(config)
    local dropdown = {
        Values = config.Values or {},
        Value = config.Default,
        Multi = config.Multi or false,
        Callback = config.Callback,
        Open = false
    }
    
    local container = Creator.New("Frame", {
        Size = config.Size or UDim2.new(1, -20, 0, 50),
        Position = config.Position,
        Parent = config.Parent,
        BackgroundTransparency = 1
    })
    
    -- Main Button
    local mainButton = Creator.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        Text = "",
        AutoButtonColor = false,
        ThemeTag = {
            BackgroundColor3 = "Element"
        }
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Creator.New("UIStroke", {
            ThemeTag = {
                Color = "Border"
            }
        })
    })
    mainButton.Parent = container
    
    -- Selected Text
    local selectedText = Creator.New("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = dropdown.Value or "Select...",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ThemeTag = {
            TextColor3 = "Text"
        }
    })
    selectedText.Parent = mainButton
    
    -- Arrow Icon
    local arrow = Creator.New("ImageLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = Library.Icons.ArrowDown,
        ThemeTag = {
            ImageColor3 = "SubText"
        }
    })
    arrow.Parent = mainButton
    
    -- Dropdown List
    local listContainer = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundTransparency = 1,
        Visible = false,
        ClipsDescendants = true
    })
    listContainer.Parent = container
    
    local listScroller = Creator.New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 200),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ThemeTag = {
            ScrollBarImageColor3 = "Border",
            BackgroundColor3 = "BackgroundSecondary"
        }
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Creator.New("UIStroke", {
            ThemeTag = {
                Color = "Border"
            }
        }),
        Creator.New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2)
        })
    })
    listScroller.Parent = listContainer
    
    -- Search Box
    local searchBox = Creator.New("TextBox", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        PlaceholderText = "Search...",
        ClearTextOnFocus = false,
        ThemeTag = {
            BackgroundColor3 = "Element",
            TextColor3 = "Text",
            PlaceholderColor3 = "SubText"
        }
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Creator.New("UIStroke", {
            ThemeTag = {
                Color = "Border"
            }
        }),
        Creator.New("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })
    })
    searchBox.Parent = listContainer
    
    -- Function to update list
    local function updateList(searchTerm)
        searchTerm = searchTerm or ""
        
        -- Clear existing items
        for _, child in ipairs(listScroller:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Add filtered items
        local itemHeight = 35
        local visibleCount = 0
        
        for _, value in ipairs(dropdown.Values) do
            if string.find(string.lower(value), string.lower(searchTerm)) then
                local item = Creator.New("TextButton", {
                    Size = UDim2.new(1, -20, 0, itemHeight),
                    Position = UDim2.new(0, 10, 0, 50 + visibleCount * (itemHeight + 2)),
                    Text = value,
                    AutoButtonColor = false,
                    LayoutOrder = visibleCount,
                    ThemeTag = {
                        BackgroundColor3 = "Element",
                        TextColor3 = "Text"
                    }
                }, {
                    Creator.New("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    Creator.New("UIStroke", {
                        ThemeTag = {
                            Color = "Border"
                        }
                    }),
                    Creator.New("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10)
                    })
                })
                item.Parent = listScroller
                
                -- Selection indicator
                if value == dropdown.Value then
                    item.BackgroundColor3 = Themes[Library.Theme].Accent
                    item.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                
                -- Click event
                item.MouseButton1Click:Connect(function()
                    dropdown.Value = value
                    selectedText.Text = value
                    dropdown.Open = false
                    listContainer.Visible = false
                    
                    TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                    
                    TweenService:Create(listContainer, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    
                    if dropdown.Callback then
                        pcall(dropdown.Callback, value)
                    end
                end)
                
                visibleCount = visibleCount + 1
            end
        end
        
        -- Update scroller size
        local totalHeight = math.min(visibleCount * (itemHeight + 2) + 50, 250)
        listScroller.CanvasSize = UDim2.new(0, 0, 0, visibleCount * (itemHeight + 2) + 50)
        listContainer.Size = UDim2.new(1, 0, 0, totalHeight)
    end
    
    -- Search functionality
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateList(searchBox.Text)
    end)
    
    -- Toggle dropdown
    mainButton.MouseButton1Click:Connect(function()
        dropdown.Open = not dropdown.Open
        
        if dropdown.Open then
            updateList("")
            listContainer.Visible = true
            
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 180
            }):Play()
            
            TweenService:Create(listContainer, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 250)
            }):Play()
        else
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
            
            TweenService:Create(listContainer, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            task.delay(0.2, function()
                listContainer.Visible = false
            end)
        end
    end)
    
    -- Close dropdown when clicking outside
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdown.Open then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = listContainer.AbsolutePosition
            local absSize = listContainer.AbsoluteSize
            
            if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
               mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                dropdown.Open = false
                listContainer.Visible = false
                
                TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = 0
                }):Play()
            end
        end
    end)
    
    return dropdown
end

-- Enhanced Color Picker with Gradient
Components.ColorPicker = function(config)
    local colorPicker = {
        Color = config.Default or Color3.fromRGB(255, 0, 0),
        Callback = config.Callback
    }
    
    local container = Creator.New("Frame", {
        Size = config.Size or UDim2.new(1, -20, 0, 50),
        Position = config.Position,
        Parent = config.Parent,
        BackgroundTransparency = 1
    })
    
    -- Preview Box
    local preview = Creator.New("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -50, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = colorPicker.Color,
        AutoButtonColor = false
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Creator.New("UIStroke", {
            Thickness = 2,
            Color = Color3.fromRGB(255, 255, 255)
        })
    })
    preview.Parent = container
    
    -- Title
    local title = Creator.New("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Text = config.Text or "Color Picker",
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = {
            TextColor3 = "Text"
        }
    }, {
        Creator.New("UIPadding", {
            PaddingLeft = UDim.new(0, 10)
        })
    })
    title.Parent = container
    
    -- Color Picker Dialog
    local dialog = Creator.New("Frame", {
        Size = UDim2.new(0, 300, 0, 350),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        Visible = false,
        ZIndex = 100,
        Parent = container
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Creator.New("UIStroke", {
            Thickness = 2,
            Color = Color3.fromRGB(100, 100, 120)
        })
    })
    
    -- Hue Slider
    local hueSlider = Creator.New("Frame", {
        Size = UDim2.new(0, 20, 0, 256),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Creator.New("UIGradient", {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }
        })
    })
    hueSlider.Parent = dialog
    
    -- Open Dialog
    preview.MouseButton1Click:Connect(function()
        dialog.Visible = not dialog.Visible
    end)
    
    return colorPicker
end

-- Enhanced Notification System
Components.Notification = function(config)
    local notification = Creator.New("Frame", {
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(1, -320, 1, -80),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        ClipsDescendants = true
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Creator.New("UIStroke", {
            Thickness = 2,
            Color = Color3.fromRGB(100, 100, 120)
        }),
        Creator.New("UIGradient", {
            Color = Themes[Library.Theme].GradientPrimary,
            Rotation = 90,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(1, 0.9)
            }
        })
    })
    notification.Parent = Library.GUI
    
    -- Icon
    local iconType = config.Type or "Info"
    local icon = Creator.New("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 15, 0, 15),
        Image = Library.Icons[iconType] or Library.Icons.Info,
        BackgroundTransparency = 1
    })
    icon.Parent = notification
    
    -- Title
    local title = Creator.New("TextLabel", {
        Size = UDim2.new(1, -60, 0, 24),
        Position = UDim2.new(0, 50, 0, 15),
        Text = config.Title or "Notification",
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })
    title.Parent = notification
    
    -- Message
    local message = Creator.New("TextLabel", {
        Size = UDim2.new(1, -30, 0, 0),
        Position = UDim2.new(0, 15, 0, 45),
        Text = config.Message or "",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 1
    })
    message.Parent = notification
    
    -- Calculate height based on message
    local textSize = TextService:GetTextSize(message.Text, message.TextSize, message.Font, Vector2.new(270, math.huge))
    local height = math.max(80, 60 + textSize.Y)
    
    -- Animate in
    notification.Size = UDim2.new(0, 300, 0, 0)
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, height)
    }):Play()
    
    -- Play sound
    SoundSystem:Play(Library.Sounds.Notification)
    
    -- Auto remove after duration
    local duration = config.Duration or 5
    if duration > 0 then
        task.delay(duration, function()
            TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 300, 0, 0)
            }):Play()
            
            task.delay(0.3, function()
                notification:Destroy()
            end)
        end)
    end
    
    return notification
end

-- Enhanced Tab System
Components.TabSystem = function(config)
    local tabSystem = {
        Tabs = {},
        ActiveTab = nil
    }
    
    local container = Creator.New("Frame", {
        Size = config.Size or UDim2.new(1, -20, 1, -20),
        Position = config.Position or UDim2.new(0, 10, 0, 10),
        Parent = config.Parent,
        BackgroundTransparency = 1
    })
    
    -- Tab Buttons Container
    local tabButtons = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    }, {
        Creator.New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 5)
        })
    })
    tabButtons.Parent = container
    
    -- Content Container
    local contentContainer = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })
    contentContainer.Parent = container
    
    -- Active Tab Indicator
    local indicator = Creator.New("Frame", {
        Size = UDim2.new(0, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Themes[Library.Theme].Accent,
        BorderSizePixel = 0
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    indicator.Parent = tabButtons
    
    -- Add Tab Function
    function tabSystem:AddTab(name, icon)
        local tab = {
            Name = name,
            Content = Creator.New("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = false,
                ScrollBarThickness = 3
            }, {
                Creator.New("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 10)
                }),
                Creator.New("UIPadding", {
                    PaddingTop = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10)
                })
            })
        }
        tab.Content.Parent = contentContainer
        
        -- Tab Button
        local tabButton = Creator.New("TextButton", {
            Size = UDim2.new(0, 100, 1, 0),
            Text = name,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            TextColor3 = Themes[Library.Theme].SubText
        })
        tabButton.Parent = tabButtons
        
        if icon then
            local iconImage = Creator.New("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 10, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = icon,
                BackgroundTransparency = 1,
                ImageColor3 = Themes[Library.Theme].SubText
            })
            iconImage.Parent = tabButton
            
            tabButton.Text = ""
            
            local textLabel = Creator.New("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 40, 0, 0),
                Text = name,
                BackgroundTransparency = 1,
                TextColor3 = Themes[Library.Theme].SubText,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            textLabel.Parent = tabButton
        end
        
        -- Click Event
        tabButton.MouseButton1Click:Connect(function()
            tabSystem:SelectTab(tab)
        end)
        
        tab.Button = tabButton
        table.insert(tabSystem.Tabs, tab)
        
        -- Select first tab
        if #tabSystem.Tabs == 1 then
            tabSystem:SelectTab(tab)
        end
        
        return tab
    end
    
    -- Select Tab Function
    function tabSystem:SelectTab(tab)
        if tabSystem.ActiveTab == tab then return end
        
        -- Update previous active tab
        if tabSystem.ActiveTab then
            tabSystem.ActiveTab.Content.Visible = false
            if tabSystem.ActiveTab.Button then
                TweenService:Create(tabSystem.ActiveTab.Button, TweenInfo.new(0.2), {
                    TextColor3 = Themes[Library.Theme].SubText
                }):Play()
                
                if tabSystem.ActiveTab.Button:FindFirstChildOfClass("ImageLabel") then
                    TweenService:Create(tabSystem.ActiveTab.Button:FindFirstChildOfClass("ImageLabel"), TweenInfo.new(0.2), {
                        ImageColor3 = Themes[Library.Theme].SubText
                    }):Play()
                end
            end
        end
        
        -- Set new active tab
        tabSystem.ActiveTab = tab
        tab.Content.Visible = true
        
        -- Animate button
        if tab.Button then
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                TextColor3 = Themes[Library.Theme].Accent
            }):Play()
            
            if tab.Button:FindFirstChildOfClass("ImageLabel") then
                TweenService:Create(tab.Button:FindFirstChildOfClass("ImageLabel"), TweenInfo.new(0.2), {
                    ImageColor3 = Themes[Library.Theme].Accent
                }):Play()
            end
            
            -- Animate indicator
            TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Position = UDim2.new(tab.Button.Position.X.Scale, tab.Button.Position.X.Offset, 1, -3),
                Size = UDim2.new(tab.Button.Size.X.Scale, tab.Button.Size.X.Offset, 0, 3)
            }):Play()
        end
    end
    
    return tabSystem
end

-- Enhanced Window System
Components.Window = function(config)
    local window = {
        Title = config.Title or "Window",
        Size = config.Size or UDim2.new(0, 500, 0, 400),
        Position = config.Position or UDim2.new(0.5, 0, 0.5, 0),
        Minimized = false,
        Maximized = false,
        Draggable = true
    }
    
    -- Main Window Frame
    local windowFrame = Creator.New("Frame", {
        Size = window.Size,
        Position = window.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Themes[Library.Theme].Background,
        Parent = config.Parent or Library.GUI,
        Active = true
    }, {
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Creator.New("UIStroke", {
            Thickness = 2,
            Color = Themes[Library.Theme].Border
        }),
        Creator.New("UIGradient", {
            Color = Themes[Library.Theme].GradientPrimary,
            Rotation = 90,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.9),
                NumberSequenceKeypoint.new(1, 0.95)
            }
        })
    })
    
    -- Title Bar
    local titleBar = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    }, {
        Creator.New("UIStroke", {
            Thickness = 0,
            Color = Themes[Library.Theme].Border
        })
    })
    titleBar.Parent = windowFrame
    
    -- Title Text
    local titleText = Creator.New("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = window.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        TextColor3 = Themes[Library.Theme].Text,
        BackgroundTransparency = 1
    })
    titleText.Parent = titleBar
    
    -- Control Buttons
    local buttonContainer = Creator.New("Frame", {
        Size = UDim2.new(0, 90, 1, 0),
        Position = UDim2.new(1, -95, 0, 0),
        BackgroundTransparency = 1
    }, {
        Creator.New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 5)
        })
    })
    buttonContainer.Parent = titleBar
    
    -- Minimize Button
    local minimizeButton = Components.Button({
        Size = UDim2.new(0, 25, 0, 25),
        Text = "",
        Parent = buttonContainer,
        Callback = function()
            window.Minimized = not window.Minimized
            if window.Minimized then
                TweenService:Create(windowFrame, TweenInfo.new(0.3), {
                    Size = UDim2.new(window.Size.X.Scale, window.Size.X.Offset, 0, 40)
                }):Play()
            else
                TweenService:Create(windowFrame, TweenInfo.new(0.3), {
                    Size = window.Size
                }):Play()
            end
        end
    })
    
    local minimizeIcon = Creator.New("ImageLabel", {
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = Library.Icons.Minimize,
        BackgroundTransparency = 1,
        ImageColor3 = Themes[Library.Theme].Text
    })
    minimizeIcon.Parent = minimizeButton
    
    -- Close Button
    local closeButton = Components.Button({
        Size = UDim2.new(0, 25, 0, 25),
        Text = "",
        Parent = buttonContainer,
        Callback = function()
            TweenService:Create(windowFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, windowFrame.AbsoluteSize.X/2, 0.5, windowFrame.AbsoluteSize.Y/2)
            }):Play()
            
            task.delay(0.3, function()
                windowFrame:Destroy()
            end)
        end
    })
    
    local closeIcon = Creator.New("ImageLabel", {
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = Library.Icons.Close,
        BackgroundTransparency = 1,
        ImageColor3 = Themes[Library.Theme].Error
    })
    closeIcon.Parent = closeButton
    
    -- Content Area
    local contentArea = Creator.New("Frame", {
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1
    })
    contentArea.Parent = windowFrame
    
    -- Dragging Logic
    if window.Draggable then
        local dragging = false
        local dragInput, dragStart, startPos
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = windowFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                windowFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
    
    -- Window Functions
    function window:SetTitle(newTitle)
        titleText.Text = newTitle
        window.Title = newTitle
    end
    
    function window:SetSize(newSize)
        window.Size = newSize
        windowFrame.Size = newSize
    end
    
    function window:SetPosition(newPosition)
        window.Position = newPosition
        windowFrame.Position = newPosition
    end
    
    function window:AddContent(content)
        content.Parent = contentArea
        return content
    end
    
    function window:Destroy()
        windowFrame:Destroy()
    end
    
    return window
end

-- Main Library Functions
function Library:CreateWindow(config)
    config = config or {}
    
    -- Create ScreenGUI
    Library.GUI = Creator.New("ScreenGui", {
        Name = "CyrusHubX_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if ProtectGui then
        ProtectGui(Library.GUI)
    end
    
    Library.GUI.Parent = game:GetService("CoreGui")
    
    -- Create Main Window
    local window = Components.Window({
        Title = config.Title or "Cyrus Hub X",
        Size = config.Size or (Library.IsMobile and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 500, 0, 400)),
        Position = config.Position or UDim2.new(0.5, 0, 0.5, 0),
        Parent = Library.GUI
    })
    
    Library.ActiveWindow = window
    
    -- Add Example Content
    local tabSystem = Components.TabSystem({
        Parent = window:AddContent(Creator.New("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        }))
    })
    
    -- Example Tab 1: Controls
    local controlsTab = tabSystem:AddTab("Controls", Library.Icons.Settings)
    
    -- Add example components
    controlsTab.Content:AddContent(Components.Button({
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        Text = "Click Me!",
        Callback = function()
            Components.Notification({
                Title = "Success",
                Message = "Button clicked successfully!",
                Type = "Success",
                Duration = 3
            })
        end
    }))
    
    controlsTab.Content:AddContent(Components.Toggle({
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 60),
        Text = "Enable Feature",
        Description = "Turn this feature on/off",
        Default = true,
        Callback = function(value)
            print("Toggle:", value)
        end
    }))
    
    controlsTab.Content:AddContent(Components.Slider({
        Size = UDim2.new(1, -20, 0, 70),
        Position = UDim2.new(0, 10, 0, 120),
        Text = "Volume",
        Min = 0,
        Max = 100,
        Default = 50,
        Callback = function(value)
            print("Volume:", value)
        end
    }))
    
    controlsTab.Content:AddContent(Components.Dropdown({
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 200),
        Text = "Select Option",
        Values = {"Option 1", "Option 2", "Option 3", "Option 4"},
        Default = "Option 1",
        Callback = function(value)
            print("Selected:", value)
        end
    }))
    
    -- Example Tab 2: Settings
    local settingsTab = tabSystem:AddTab("Settings", Library.Icons.Settings)
    
    -- Theme Selector
    settingsTab.Content:AddContent(Components.Dropdown({
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 10),
        Text = "Theme",
        Values = Library.Themes.Names,
        Default = Library.Theme,
        Callback = function(value)
            Library:SetTheme(value)
            Components.Notification({
                Title = "Theme Changed",
                Message = "Theme updated to " .. value,
                Type = "Info",
                Duration = 3
            })
        end
    }))
    
    -- Animation Toggle
    settingsTab.Content:AddContent(Components.Toggle({
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 70),
        Text = "Enable Animations",
        Description = "Smooth UI animations",
        Default = true,
        Callback = function(value)
            Library.AnimationEnabled = value
            Components.Notification({
                Title = "Animations " .. (value and "Enabled" or "Disabled"),
                Message = value and "Smooth animations activated" or "Animations turned off",
                Type = value and "Success" or "Warning",
                Duration = 3
            })
        end
    }))
    
    -- Sound Toggle
    settingsTab.Content:AddContent(Components.Toggle({
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 130),
        Text = "Enable Sounds",
        Description = "UI sound effects",
        Default = true,
        Callback = function(value)
            SoundSystem.Enabled = value
            Components.Notification({
                Title = "Sounds " .. (value and "Enabled" or "Disabled"),
                Message = value and "Sound effects activated" or "Sounds turned off",
                Type = value and "Success" or "Warning",
                Duration = 3
            })
        end
    }))
    
    -- Add a welcome notification
    task.wait(0.5)
    Components.Notification({
        Title = "Cyrus Hub X Loaded",
        Message = "Welcome to the enhanced interface!",
        Type = "Success",
        Duration = 5
    })
    
    return window
end

function Library:SetTheme(themeName)
    if Themes[themeName] then
        Library.Theme = themeName
        
        -- Update all themed objects
        for _, obj in ipairs(Creator.Objects) do
            if obj:GetAttribute("ThemeTags") then
                local tags = obj:GetAttribute("ThemeTags")
                for property, tag in pairs(tags) do
                    if Themes[themeName][tag] then
                        obj[property] = Themes[themeName][tag]
                    end
                end
            end
        end
        
        -- Update any gradient themes
        for _, obj in ipairs(Creator.Objects) do
            local gradient = obj:FindFirstChildOfClass("UIGradient")
            if gradient and gradient:GetAttribute("ThemeTag") then
                local tag = gradient:GetAttribute("ThemeTag")
                if Themes[themeName][tag] then
                    gradient.Color = Themes[themeName][tag]
                end
            end
        end
    end
end

function Library:Notify(config)
    return Components.Notification(config)
end

function Library:Destroy()
    if Library.GUI then
        Library.GUI:Destroy()
        Library.GUI = nil
    end
    
    -- Clean up animations
    for _, spring in ipairs(AnimationSystem.Springs) do
        spring.active = false
    end
    
    -- Clean up particles
    for _, particle in ipairs(ParticleSystem.Particles) do
        particle.object:Destroy()
    end
    
    ParticleSystem.Particles = {}
    
    -- Clean up sounds
    for _, sound in ipairs(SoundSystem.Sounds) do
        sound:Destroy()
    end
    
    SoundSystem.Sounds = {}
end

-- Mobile Optimization
if Library.IsMobile then
    -- Adjust UI for touch
    Library.UseDebounce = true
    Library.DebounceTime = 0.2
    
    -- Larger touch targets
    for _, obj in ipairs(Creator.Objects) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            local padding = obj:FindFirstChildOfClass("UIPadding")
            if not padding then
                padding = Creator.New("UIPadding", {
                    PaddingLeft = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 15),
                    PaddingTop = UDim.new(0, 15),
                    PaddingBottom = UDim.new(0, 15)
                })
                padding.Parent = obj
            end
        end
    end
end

-- Keyboard Shortcuts
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Library.ActiveWindow then
            Library.ActiveWindow.Minimized = not Library.ActiveWindow.Minimized
        end
    elseif input.KeyCode == Enum.KeyCode.F11 then
        Library.AnimationEnabled = not Library.AnimationEnabled
        Library:Notify({
            Title = "Animations " .. (Library.AnimationEnabled and "Enabled" or "Disabled"),
            Type = Library.AnimationEnabled and "Success" or "Warning",
            Duration = 2
        })
    end
end)

-- Initialize Library
getgenv().CyrusHubX = Library

return Library
