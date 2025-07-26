-- Eps1llon Hub Premium UI Library - Mobile Optimized
-- Modern, sleek design with smooth animations, mobile-friendly interface

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Mobile Detection
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        Secondary = Color3.fromRGB(30, 30, 30),
        Tertiary = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(255, 255, 255),
        SectionHighlight = Color3.fromRGB(100, 100, 255)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(255, 255, 255),
        Tertiary = Color3.fromRGB(230, 230, 230),
        Accent = Color3.fromRGB(50, 50, 200),
        Text = Color3.fromRGB(0, 0, 0),
        TextDark = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(200, 200, 200),
        SectionHighlight = Color3.fromRGB(50, 50, 200)
    },
    Purple = {
        Background = Color3.fromRGB(25, 20, 35),
        Secondary = Color3.fromRGB(35, 30, 45),
        Tertiary = Color3.fromRGB(45, 40, 55),
        Accent = Color3.fromRGB(150, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 200),
        Border = Color3.fromRGB(255, 255, 255),
        SectionHighlight = Color3.fromRGB(150, 100, 255)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 35),
        Secondary = Color3.fromRGB(25, 35, 45),
        Tertiary = Color3.fromRGB(35, 45, 55),
        Accent = Color3.fromRGB(100, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 220),
        Border = Color3.fromRGB(255, 255, 255),
        SectionHighlight = Color3.fromRGB(100, 200, 255)
    }
}

-- Utility Functions
local function CreateInstance(class, properties, parent)
    local instance = Instance.new(class)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    instance.Parent = parent
    return instance
end

local function Tween(instance, properties, duration, easingStyle)
    easingStyle = easingStyle or Enum.EasingStyle.Exponential
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, easingStyle, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function AddDragging(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    local isMobile = IsMobile()
    
    local function InputBegan(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseButton1 or (isMobile and inputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
    
    local function InputChanged(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseMovement or (isMobile and inputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end
    
    handle.InputBegan:Connect(InputBegan)
    handle.InputChanged:Connect(InputChanged)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

-- Main Library Functions
function Library:Create(config)
    config = config or {}
    local self = setmetatable({}, Library)
    
    self.Theme = Themes[config.Theme or "Dark"]
    self.Sections = {}
    self.CurrentSection = nil
    self.Minimized = false
    self.IsMobile = IsMobile()
    
    -- Mobile-friendly sizing
    local initialWidth = self.IsMobile and 320 or 400
    local initialHeight = self.IsMobile and 250 or 300
    
    self.MinSize = Vector2.new(self.IsMobile and 280 or 350, self.IsMobile and 200 or 250)
    self.MaxSize = Vector2.new(self.IsMobile and 400 or 600, self.IsMobile and 500 or 700)
    
    -- Create ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "Eps1llonHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, CoreGui)
    
    -- Main Frame with mobile-friendly size
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, initialWidth, 0, initialHeight),
        Position = UDim2.new(0.5, -initialWidth/2, 0.5, -initialHeight/2),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = false
    }, self.ScreenGui)
    
    -- Add rounded corners
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 12 or 8)
    }, self.MainFrame)
    
    -- Edge glow effect
    local EdgeGlow = CreateInstance("ImageLabel", {
        Name = "EdgeGlow",
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = self.Theme.Accent,
        ImageTransparency = 0.9,
        ZIndex = -1
    }, self.MainFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 16 or 12)
    }, EdgeGlow)
    
    -- Title Bar
    local titleBarHeight = self.IsMobile and 40 or 35
    self.TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, titleBarHeight),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Title
    self.Title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "Eps1llon Hub",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, self.TitleBar)
    
    -- Close Button (X) - Larger for mobile
    local buttonSize = self.IsMobile and 28 or 20
    self.CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, -buttonSize - 10, 0.5, -buttonSize/2),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 28 or 22,
        Font = Enum.Font.Ubuntu
    }, self.TitleBar)
    
    self.CloseButton.MouseEnter:Connect(function()
        Tween(self.CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        Tween(self.CloseButton, {TextColor3 = self.Theme.Text}, 0.2)
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Minimize Button (-) - Larger for mobile
    self.MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, -buttonSize*2 - 15, 0.5, -buttonSize/2),
        BackgroundTransparency = 1,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 20 or 16,
        Font = Enum.Font.Ubuntu
    }, self.TitleBar)
    
    self.MinimizeButton.MouseEnter:Connect(function()
        Tween(self.MinimizeButton, {TextColor3 = self.Theme.Accent}, 0.2)
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        Tween(self.MinimizeButton, {TextColor3 = self.Theme.Text}, 0.2)
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    -- Top divider line
    self.TopDivider = CreateInstance("Frame", {
        Name = "TopDivider",
        Size = UDim2.new(1, -30, 0, 1),
        Position = UDim2.new(0, 15, 0, titleBarHeight),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Mobile layout - Stack sections vertically instead of sidebar
    if self.IsMobile then
        -- Mobile Section Tabs (horizontal scroll)
        self.SectionContainer = CreateInstance("ScrollingFrame", {
            Name = "SectionContainer",
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, titleBarHeight + 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0,
            ScrollingDirection = Enum.ScrollingDirection.X,
            CanvasSize = UDim2.new(0, 0, 1, 0)
        }, self.MainFrame)
        
        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            FillDirection = Enum.FillDirection.Horizontal
        }, self.SectionContainer)
        
        -- Content Container (full width on mobile)
        self.ContentContainer = CreateInstance("Frame", {
            Name = "ContentContainer",
            Size = UDim2.new(1, -20, 1, -(titleBarHeight + 65)),
            Position = UDim2.new(0, 10, 0, titleBarHeight + 55),
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        }, self.MainFrame)
    else
        -- Desktop layout (original sidebar)
        self.SectionContainer = CreateInstance("ScrollingFrame", {
            Name = "SectionContainer",
            Size = UDim2.new(0, 120, 1, -(titleBarHeight + 10)),
            Position = UDim2.new(0, 10, 0, titleBarHeight + 5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0
        }, self.MainFrame)
        
        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        }, self.SectionContainer)
        
        -- Vertical divider line
        self.VerticalDivider = CreateInstance("Frame", {
            Name = "VerticalDivider",
            Size = UDim2.new(0, 1, 1, -(titleBarHeight + 10)),
            Position = UDim2.new(0, 140, 0, titleBarHeight + 5),
            BackgroundColor3 = self.Theme.Border,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0
        }, self.MainFrame)
        
        -- Content Container
        self.ContentContainer = CreateInstance("Frame", {
            Name = "ContentContainer",
            Size = UDim2.new(1, -160, 1, -(titleBarHeight + 15)),
            Position = UDim2.new(0, 150, 0, titleBarHeight + 5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        }, self.MainFrame)
    end
    
    -- Minimized Frame (Mobile-friendly)
    local minFrameSize = self.IsMobile and 120 or 150
    self.MinimizedFrame = CreateInstance("Frame", {
        Name = "MinimizedFrame",
        Size = UDim2.new(0, minFrameSize, 0, self.IsMobile and 50 : 40),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Visible = false
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, self.MinimizedFrame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.5,
        Thickness = 1
    }, self.MinimizedFrame)
    
    self.MinimizedTitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "Eps1llon Hub",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 12 or 14,
        Font = Enum.Font.Ubuntu
    }, self.MinimizedFrame)
    
    self.MinimizedButton = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    }, self.MinimizedFrame)
    
    self.MinimizedButton.MouseButton1Click:Connect(function()
        self:Restore()
    end)
    
    -- Make frames draggable
    AddDragging(self.MainFrame, self.TitleBar)
    AddDragging(self.MinimizedFrame)
    
    -- Add resizing (disabled on mobile)
    if not self.IsMobile then
        self:AddResizing()
    end
    
    return self
end

function Library:AddResizing()
    local resizing = false
    local startSize, startPos
    
    -- Resize handle (bottom-right corner)
    self.ResizeHandle = CreateInstance("Frame", {
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -15, 1, -15),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    self.ResizeHandle.MouseEnter:Connect(function()
        Mouse.Icon = "rbxasset://SystemCursors/SizeNWSE"
    end)
    
    self.ResizeHandle.MouseLeave:Connect(function()
        if not resizing then
            Mouse.Icon = ""
        end
    end)
    
    self.ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            startSize = self.MainFrame.AbsoluteSize
            startPos = UserInputService:GetMouseLocation()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
            Mouse.Icon = ""
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - startPos
            
            local newWidth = math.clamp(startSize.X + delta.X, self.MinSize.X, self.MaxSize.X)
            local newHeight = math.clamp(startSize.Y + delta.Y, self.MinSize.Y, self.MaxSize.Y)
            
            Tween(self.MainFrame, {
                Size = UDim2.new(0, newWidth, 0, newHeight)
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

function Library:CreateSection(name)
    local section = {}
    section.Name = name
    section.Elements = {}
    
    if self.IsMobile then
        -- Mobile section tab
        section.Button = CreateInstance("TextButton", {
            Name = name .. "Section",
            Size = UDim2.new(0, 80, 1, 0),
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Text = ""
        }, self.SectionContainer)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }, section.Button)
        
        section.Label = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.TextDark,
            TextSize = 12,
            Font = Enum.Font.Ubuntu,
            TextScaled = true
        }, section.Button)
        
        CreateInstance("UITextSizeConstraint", {
            MaxTextSize = 12
        }, section.Label)
    else
        -- Desktop section button
        section.Button = CreateInstance("TextButton", {
            Name = name .. "Section",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = ""
        }, self.SectionContainer)
        
        -- Section Highlight (left line)
        section.Highlight = CreateInstance("Frame", {
            Name = "Highlight",
            Size = UDim2.new(0, 3, 1, -8),
            Position = UDim2.new(0, 0, 0, 4),
            BackgroundColor3 = self.Theme.SectionHighlight,
            BorderSizePixel = 0,
            Visible = false
        }, section.Button)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 2)
        }, section.Highlight)
        
        section.Label = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -15, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Ubuntu
        }, section.Button)
    end
    
    -- Section Content
    section.Content = CreateInstance("ScrollingFrame", {
        Name = name .. "Content",
        Size = UDim2.new(1, -10, 1, -5),
        Position = UDim2.new(0, 5, 0, 2),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = self.IsMobile and 4 or 3,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        Visible = false
    }, self.ContentContainer)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, self.IsMobile and 6 or 8)
    }, section.Content)
    
    -- Update canvas size for mobile tabs
    if self.IsMobile then
        local layout = self.SectionContainer:FindFirstChild("UIListLayout")
        layout.Changed:Connect(function()
            self.SectionContainer.CanvasSize = UDim2.new(0, layout.AbsoluteContentSize.X, 0, 0)
        end)
    end
    
    -- Section Selection
    section.Button.MouseButton1Click:Connect(function()
        self:SelectSection(section)
    end)
    
    section.Button.MouseEnter:Connect(function()
        if self.CurrentSection ~= section then
            if self.IsMobile then
                Tween(section.Button, {BackgroundTransparency = 0.5}, 0.2)
            end
            Tween(section.Label, {TextColor3 = self.Theme.Text}, 0.2)
        end
    end)
    
    section.Button.MouseLeave:Connect(function()
        if self.CurrentSection ~= section then
            if self.IsMobile then
                Tween(section.Button, {BackgroundTransparency = 0.7}, 0.2)
            end
            Tween(section.Label, {TextColor3 = self.Theme.TextDark}, 0.2)
        end
    end)
    
    table.insert(self.Sections, section)
    
    if #self.Sections == 1 then
        self:SelectSection(section)
    end
    
    return section
end

function Library:SelectSection(section)
    for _, s in pairs(self.Sections) do
        s.Content.Visible = false
        if self.IsMobile then
            Tween(s.Button, {BackgroundTransparency = 0.7}, 0.2)
        else
            if s.Highlight then
                s.Highlight.Visible = false
            end
        end
        Tween(s.Label, {TextColor3 = self.Theme.TextDark}, 0.2)
    end
    
    section.Content.Visible = true
    if self.IsMobile then
        Tween(section.Button, {BackgroundTransparency = 0.3}, 0.2)
    else
        if section.Highlight then
            section.Highlight.Visible = true
        end
    end
    Tween(section.Label, {TextColor3 = self.Theme.Text}, 0.2)
    self.CurrentSection = section
end

function Library:Minimize()
    self.Minimized = true
    Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
    wait(0.3)
    self.MainFrame.Visible = false
    self.MinimizedFrame.Visible = true
    Tween(self.MinimizedFrame, {BackgroundTransparency = 0.3}, 0.2)
end

function Library:Restore()
    self.Minimized = false
    self.MinimizedFrame.Visible = false
    self.MainFrame.Visible = true
    local initialWidth = self.IsMobile and 320 or 400
    local initialHeight = self.IsMobile and 250 or 300
    Tween(self.MainFrame, {Size = UDim2.new(0, initialWidth, 0, initialHeight), BackgroundTransparency = 0.05}, 0.3)
end

-- UI Elements
function Library:CreateButton(section, config)
    config = config or {}
    local button = {}
    
    local buttonHeight = self.IsMobile and 40 or 35
    button.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, buttonHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, button.Frame)
    
    button.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = config.Text or "Button",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Ubuntu
    }, button.Frame)
    
    button.Button.MouseEnter:Connect(function()
        Tween(button.Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    button.Button.MouseLeave:Connect(function()
        Tween(button.Frame, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    button.Button.MouseButton1Click:Connect(function()
        Tween(button.Frame, {BackgroundColor3 = self.Theme.Accent}, 0.1)
        wait(0.1)
        Tween(button.Frame, {BackgroundColor3 = self.Theme.Secondary}, 0.1)
        
        if config.Callback then
            config.Callback()
        end
    end)
    
    return button
end

function Library:CreateToggle(section, config)
    config = config or {}
    local toggle = {}
    toggle.Enabled = config.Default or false
    
    local toggleHeight = self.IsMobile and 40 or 35
    toggle.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, toggleHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, toggle.Frame)
    
    toggle.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -(self.IsMobile and 60 or 50), 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Toggle",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, toggle.Frame)
    
    local toggleWidth = self.IsMobile and 44 or 36
    local toggleSwitchHeight = self.IsMobile and 22 or 18
    toggle.Button = CreateInstance("TextButton", {
        Size = UDim2.new(0, toggleWidth, 0, toggleSwitchHeight),
        Position = UDim2.new(1, -toggleWidth - 10, 0.5, -toggleSwitchHeight/2),
        BackgroundColor3 = toggle.Enabled and self.Theme.Accent or self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = ""
    }, toggle.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, toggle.Button)
    
    local indicatorSize = self.IsMobile and 18 or 14
    toggle.Indicator = CreateInstance("Frame", {
        Size = UDim2.new(0, indicatorSize, 0, indicatorSize),
        Position = toggle.Enabled and UDim2.new(1, -indicatorSize - 2, 0.5, -indicatorSize/2) or UDim2.new(0, 2, 0.5, -indicatorSize/2),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0
    }, toggle.Button)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, toggle.Indicator)
    
    local function SetToggle(value)
        toggle.Enabled = value
        
        if toggle.Enabled then
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Accent}, 0.3, Enum.EasingStyle.Back)
            Tween(toggle.Indicator, {Position = UDim2.new(1, -indicatorSize - 2, 0.5, -indicatorSize/2)}, 0.3, Enum.EasingStyle.Back)
        else
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Tertiary}, 0.3, Enum.EasingStyle.Back)
            Tween(toggle.Indicator, {Position = UDim2.new(0, 2, 0.5, -indicatorSize/2)}, 0.3, Enum.EasingStyle.Back)
        end
        
        if config.Callback then
            config.Callback(toggle.Enabled)
        end
    end
    
    toggle.Button.MouseButton1Click:Connect(function()
        SetToggle(not toggle.Enabled)
    end)
    
    toggle.Frame.MouseEnter:Connect(function()
        Tween(toggle.Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    toggle.Frame.MouseLeave:Connect(function()
        Tween(toggle.Frame, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    toggle.Set = SetToggle
    
    return toggle
end

function Library:CreateSlider(section, config)
    config = config or {}
    local slider = {}
    slider.Min = config.Min or 0
    slider.Max = config.Max or 100
    slider.Value = config.Default or slider.Min
    
    local sliderHeight = self.IsMobile and 65 or 55
    slider.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, sliderHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, slider.Frame)
    
    slider.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -70, 0, self.IsMobile and 25 or 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Text or "Slider",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, slider.Frame)
    
    slider.ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 50, 0, self.IsMobile and 25 or 20),
        Position = UDim2.new(1, -60, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(slider.Value),
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Ubuntu
    }, slider.Frame)
    
    local sliderTrackHeight = self.IsMobile and 6 : 4
    local sliderY = self.IsMobile and 38 or 33
    slider.SliderFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, sliderTrackHeight),
        Position = UDim2.new(0, 10, 0, sliderY),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0
    }, slider.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, slider.SliderFrame)
    
    slider.Fill = CreateInstance("Frame", {
        Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    }, slider.SliderFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, slider.Fill)
    
    local knobSize = self.IsMobile and 16 or 12
    slider.Knob = CreateInstance("Frame", {
        Size = UDim2.new(0, knobSize, 0, knobSize),
        Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -knobSize/2, 0.5, -knobSize/2),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0
    }, slider.SliderFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, slider.Knob)
    
    local dragging = false
    
    local function UpdateSlider(input)
        local inputPos = self.IsMobile and input.Position or UserInputService:GetMouseLocation()
        local relativePos = inputPos.X - slider.SliderFrame.AbsolutePosition.X
        local percentage = math.clamp(relativePos / slider.SliderFrame.AbsoluteSize.X, 0, 1)
        
        slider.Value = math.floor(slider.Min + (slider.Max - slider.Min) * percentage)
        slider.ValueLabel.Text = tostring(slider.Value)
        
        Tween(slider.Fill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.15, Enum.EasingStyle.Quad)
        Tween(slider.Knob, {Position = UDim2.new(percentage, -knobSize/2, 0.5, -knobSize/2)}, 0.15, Enum.EasingStyle.Quad)
        
        if config.Callback then
            config.Callback(slider.Value)
        end
    end
    
    local function InputBegan(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseButton1 or (self.IsMobile and inputType == Enum.UserInputType.Touch) then
            dragging = true
            UpdateSlider(input)
        end
    end
    
    slider.SliderFrame.InputBegan:Connect(InputBegan)
    slider.Knob.InputBegan:Connect(InputBegan)
    
    UserInputService.InputEnded:Connect(function(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseButton1 or (self.IsMobile and inputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        local inputType = input.UserInputType
        if dragging and (inputType == Enum.UserInputType.MouseMovement or (self.IsMobile and inputType == Enum.UserInputType.Touch)) then
            UpdateSlider(input)
        end
    end)
    
    slider.Frame.MouseEnter:Connect(function()
        Tween(slider.Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    slider.Frame.MouseLeave:Connect(function()
        Tween(slider.Frame, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    return slider
end

function Library:CreateInput(section, config)
    config = config or {}
    local input = {}
    
    local inputHeight = self.IsMobile and 40 or 35
    input.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, inputHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, input.Frame)
    
    local labelWidth = self.IsMobile and 0.4 or 0.35
    input.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(labelWidth, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Input",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, input.Frame)
    
    input.TextBox = CreateInstance("TextBox", {
        Size = UDim2.new(1 - labelWidth, -10, 1, -8),
        Position = UDim2.new(labelWidth, 0, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = config.Default or "",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Ubuntu,
        PlaceholderText = config.Placeholder or "Enter text...",
        PlaceholderColor3 = self.Theme.TextDark,
        ClearTextOnFocus = false
    }, input.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, input.TextBox)
    
    input.TextBox.FocusLost:Connect(function(enterPressed)
        if config.Callback then
            config.Callback(input.TextBox.Text, enterPressed)
        end
    end)
    
    input.Frame.MouseEnter:Connect(function()
        Tween(input.Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    input.Frame.MouseLeave:Connect(function()
        Tween(input.Frame, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    return input
end

function Library:CreateDropdown(section, config)
    config = config or {}
    local dropdown = {}
    dropdown.Options = config.Options or {}
    dropdown.Selected = config.Default or (dropdown.Options[1] or "None")
    dropdown.Open = false
    
    local dropdownHeight = self.IsMobile and 40 or 35
    dropdown.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, dropdownHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, dropdown.Frame)
    
    local labelWidth = self.IsMobile and 0.4 or 0.35
    dropdown.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(labelWidth, -10, 0, dropdownHeight),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Dropdown",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, dropdown.Frame)
    
    local buttonHeight = self.IsMobile and 32 or 27
    dropdown.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1 - labelWidth, -10, 0, buttonHeight),
        Position = UDim2.new(labelWidth, 0, 0, (dropdownHeight - buttonHeight) / 2),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = dropdown.Selected,
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Ubuntu
    }, dropdown.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, dropdown.Button)
    
    dropdown.Arrow = CreateInstance("TextLabel", {
        Size = UDim2.new(0, self.IsMobile and 25 or 20, 1, 0),
        Position = UDim2.new(1, -(self.IsMobile and 30 or 25), 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 12 or 10,
        Font = Enum.Font.Ubuntu
    }, dropdown.Button)
    
    dropdown.OptionContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1 - labelWidth, -10, 0, 0),
        Position = UDim2.new(labelWidth, 0, 0, dropdownHeight + 5),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        ScrollBarThickness = self.IsMobile and 4 or 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = true
    }, dropdown.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, dropdown.OptionContainer)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, dropdown.OptionContainer)
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3)
    }, dropdown.OptionContainer)
    
    local function UpdateOptions()
        for _, child in pairs(dropdown.OptionContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for _, option in pairs(dropdown.Options) do
            local optionHeight = self.IsMobile and 28 or 22
            local optionButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, optionHeight),
                BackgroundColor3 = self.Theme.Secondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Text = option,
                TextColor3 = self.Theme.Text,
                TextSize = self.IsMobile and 15 or 13,
                Font = Enum.Font.Ubuntu
            }, dropdown.OptionContainer)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 3)
            }, optionButton)
            
            optionButton.MouseEnter:Connect(function()
                Tween(optionButton, {BackgroundTransparency = 0.2}, 0.15)
            end)
            
            optionButton.MouseLeave:Connect(function()
                Tween(optionButton, {BackgroundTransparency = 0.5}, 0.15)
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Selected = option
                dropdown.Button.Text = option
                dropdown.Open = false
                
                -- Smooth close animation
                local optionCount = #dropdown.Options
                local maxHeight = math.min(optionCount * (optionHeight + 2) + 6, self.IsMobile and 200 or 150)
                
                Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, dropdownHeight)}, 0.4, Enum.EasingStyle.Back)
                Tween(dropdown.Arrow, {Rotation = 0}, 0.4, Enum.EasingStyle.Back)
                Tween(dropdown.OptionContainer, {Size = UDim2.new(1 - labelWidth, -10, 0, 0)}, 0.4, Enum.EasingStyle.Back)
                
                if config.Callback then
                    config.Callback(option)
                end
            end)
        end
    end
    
    UpdateOptions()
    
    dropdown.Button.MouseButton1Click:Connect(function()
        dropdown.Open = not dropdown.Open
        
        if dropdown.Open then
            local optionCount = #dropdown.Options
            local optionHeight = self.IsMobile and 28 or 22
            local maxHeight = math.min(optionCount * (optionHeight + 2) + 6, self.IsMobile and 200 or 150)
            local newSize = dropdownHeight + maxHeight + 10
            
            -- Smooth open animation
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, newSize)}, 0.4, Enum.EasingStyle.Back)
            Tween(dropdown.Arrow, {Rotation = 180}, 0.4, Enum.EasingStyle.Back)
            Tween(dropdown.OptionContainer, {Size = UDim2.new(1 - labelWidth, -10, 0, maxHeight)}, 0.4, Enum.EasingStyle.Back)
        else
            -- Smooth close animation
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, dropdownHeight)}, 0.4, Enum.EasingStyle.Back)
            Tween(dropdown.Arrow, {Rotation = 0}, 0.4, Enum.EasingStyle.Back)
            Tween(dropdown.OptionContainer, {Size = UDim2.new(1 - labelWidth, -10, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        end
    end)
    
    dropdown.Frame.MouseEnter:Connect(function()
        Tween(dropdown.Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    dropdown.Frame.MouseLeave:Connect(function()
        Tween(dropdown.Frame, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    return dropdown
end

function Library:CreateLabel(section, config)
    config = config or {}
    local label = {}
    
    local labelHeight = self.IsMobile and 30 or 25
    label.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, labelHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, label.Frame)
    
    label.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Label",
        TextColor3 = config.Color or self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, label.Frame)
    
    return label
end

function Library:CreateKeybind(section, config)
    config = config or {}
    local keybind = {}
    keybind.Key = config.Default or Enum.KeyCode.Unknown
    keybind.Binding = false
    
    local keybindHeight = self.IsMobile and 40 or 35
    keybind.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, keybindHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, keybind.Frame)
    
    local labelWidth = self.IsMobile and 0.55 or 0.65
    keybind.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(labelWidth, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Keybind",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, keybind.Frame)
    
    local buttonHeight = self.IsMobile and 32 or 27
    keybind.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1 - labelWidth, -10, 0, buttonHeight),
        Position = UDim2.new(labelWidth, 0, 0.5, -buttonHeight/2),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = keybind.Key.Name,
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Ubuntu
    }, keybind.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, keybind.Button)
    
    keybind.Button.MouseButton1Click:Connect(function()
        keybind.Binding = true
        keybind.Button.Text = "..."
        keybind.Button.TextColor3 = self.Theme.Accent
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if keybind.Binding then
            keybind.Key = input.KeyCode
            keybind.Button.Text = input.KeyCode.Name
            keybind.Button.TextColor3 = self.Theme.Text
            keybind.Binding = false
            
            if config.Callback then
                config.Callback(input.KeyCode)
            end
        elseif not gameProcessed and input.KeyCode == keybind.Key and config.Callback then
            config.Callback(input.KeyCode, true)
        end
    end)
    
    keybind.Frame.MouseEnter:Connect(function()
        Tween(keybind.Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    keybind.Frame.MouseLeave:Connect(function()
        Tween(keybind.Frame, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    return keybind
end

function Library:CreateColorPicker(section, config)
    config = config or {}
    local colorPicker = {}
    colorPicker.Color = config.Default or Color3.fromRGB(255, 255, 255)
    colorPicker.Open = false
    
    local colorPickerHeight = self.IsMobile and 40 or 35
    colorPicker.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, colorPickerHeight),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, colorPicker.Frame)
    
    colorPicker.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -(self.IsMobile and 70 or 60), 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Color Picker",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, colorPicker.Frame)
    
    local colorDisplaySize = self.IsMobile and 50 or 40
    local colorDisplayHeight = self.IsMobile and 30 or 25
    colorPicker.ColorDisplay = CreateInstance("TextButton", {
        Size = UDim2.new(0, colorDisplaySize, 0, colorDisplayHeight),
        Position = UDim2.new(1, -colorDisplaySize - 10, 0.5, -colorDisplayHeight/2),
        BackgroundColor3 = colorPicker.Color,
        BorderSizePixel = 0,
        Text = ""
    }, colorPicker.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, colorPicker.ColorDisplay)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.5,
        Thickness = 1
    }, colorPicker.ColorDisplay)
    
    -- Color picker content
    local pickerContainerHeight = self.IsMobile and 220 : 180
    colorPicker.PickerContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, pickerContainerHeight),
        Position = UDim2.new(0, 10, 0, colorPickerHeight + 10),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Visible = true
    }, colorPicker.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, colorPicker.PickerContainer)
    
    -- Color saturation/value picker
    local svPickerHeight = self.IsMobile and 120 or 100
    colorPicker.SVPicker = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, svPickerHeight),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorPicker.PickerContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, colorPicker.SVPicker)
    
    local saturationGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1))
        }
    }, colorPicker.SVPicker)
    
    local valueGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        },
        Rotation = 90,
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }
    }, colorPicker.SVPicker)
    
    local indicatorSize = self.IsMobile and 14 or 10
    colorPicker.SVIndicator = CreateInstance("Frame", {
        Size = UDim2.new(0, indicatorSize, 0, indicatorSize),
        Position = UDim2.new(1, -indicatorSize/2, 0, -indicatorSize/2),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorPicker.SVPicker)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, colorPicker.SVIndicator)
    
    CreateInstance("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 2
    }, colorPicker.SVIndicator)
    
    -- [Previous code continues...]

    -- Hue slider
    local hueSliderHeight = self.IsMobile and 20 or 15
    local hueY = self.IsMobile and 140 or 120
    colorPicker.HueFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, hueSliderHeight),
        Position = UDim2.new(0, 10, 0, hueY),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorPicker.PickerContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, colorPicker.HueFrame)
    
    local hueGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }
    }, colorPicker.HueFrame)
    
    local hueIndicatorSize = self.IsMobile and 12 or 8
    colorPicker.HueIndicator = CreateInstance("Frame", {
        Size = UDim2.new(0, hueIndicatorSize, 1, 4),
        Position = UDim2.new(0, -hueIndicatorSize/2, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorPicker.HueFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 2)
    }, colorPicker.HueIndicator)
    
    CreateInstance("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1
    }, colorPicker.HueIndicator)
    
    -- Hex input
    local hexInputHeight = self.IsMobile and 35 or 25
    local hexY = self.IsMobile and 170 or 145
    colorPicker.HexInput = CreateInstance("TextBox", {
        Size = UDim2.new(1, -20, 0, hexInputHeight),
        Position = UDim2.new(0, 10, 0, hexY),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = string.format("#%02X%02X%02X", 
            math.floor(colorPicker.Color.R * 255),
            math.floor(colorPicker.Color.G * 255),
            math.floor(colorPicker.Color.B * 255)
        ),
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Ubuntu,
        PlaceholderText = "#FFFFFF"
    }, colorPicker.PickerContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 6 or 4)
    }, colorPicker.HexInput)
    
    -- Color picker logic
    local h, s, v = Color3.toHSV(colorPicker.Color)
    local hue = h
    local draggingSV = false
    local draggingHue = false
    
    local function UpdateColor()
        colorPicker.Color = Color3.fromHSV(hue, s, v)
        colorPicker.ColorDisplay.BackgroundColor3 = colorPicker.Color
        saturationGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, 1))
        }
        
        colorPicker.HexInput.Text = string.format("#%02X%02X%02X", 
            math.floor(colorPicker.Color.R * 255),
            math.floor(colorPicker.Color.G * 255),
            math.floor(colorPicker.Color.B * 255)
        )
        
        if config.Callback then
            config.Callback(colorPicker.Color)
        end
    end
    
    -- SV picker with mobile support
    colorPicker.SVPicker.InputBegan:Connect(function(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseButton1 or (self.IsMobile and inputType == Enum.UserInputType.Touch) then
            draggingSV = true
        end
    end)
    
    -- Hue slider with mobile support
    colorPicker.HueFrame.InputBegan:Connect(function(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseButton1 or (self.IsMobile and inputType == Enum.UserInputType.Touch) then
            draggingHue = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseButton1 or (self.IsMobile and inputType == Enum.UserInputType.Touch) then
            draggingSV = false
            draggingHue = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseMovement or (self.IsMobile and inputType == Enum.UserInputType.Touch) then
            if draggingSV then
                local inputPos = self.IsMobile and input.Position or UserInputService:GetMouseLocation()
                local relativeX = math.clamp((inputPos.X - colorPicker.SVPicker.AbsolutePosition.X) / colorPicker.SVPicker.AbsoluteSize.X, 0, 1)
                local relativeY = math.clamp((inputPos.Y - colorPicker.SVPicker.AbsolutePosition.Y) / colorPicker.SVPicker.AbsoluteSize.Y, 0, 1)
                
                s = relativeX
                v = 1 - relativeY
                
                colorPicker.SVIndicator.Position = UDim2.new(relativeX, -indicatorSize/2, relativeY, -indicatorSize/2)
                UpdateColor()
            elseif draggingHue then
                local inputPos = self.IsMobile and input.Position or UserInputService:GetMouseLocation()
                local relativeX = math.clamp((inputPos.X - colorPicker.HueFrame.AbsolutePosition.X) / colorPicker.HueFrame.AbsoluteSize.X, 0, 1)
                
                hue = relativeX
                colorPicker.HueIndicator.Position = UDim2.new(relativeX, 0, 0.5, 0)
                UpdateColor()
            end
        end
    end)
    
    -- Hex input
    colorPicker.HexInput.FocusLost:Connect(function()
        local hex = colorPicker.HexInput.Text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            
            if r and g and b then
                colorPicker.Color = Color3.fromRGB(r, g, b)
                h, s, v = Color3.toHSV(colorPicker.Color)
                hue = h
                
                colorPicker.SVIndicator.Position = UDim2.new(s, -indicatorSize/2, 1 - v, -indicatorSize/2)
                colorPicker.HueIndicator.Position = UDim2.new(h, 0, 0.5, 0)
                
                UpdateColor()
            end
        end
    end)
    
    -- Toggle color picker with smooth animation
    colorPicker.ColorDisplay.MouseButton1Click:Connect(function()
        colorPicker.Open = not colorPicker.Open
        
        if colorPicker.Open then
            local totalHeight = colorPickerHeight + pickerContainerHeight + 15
            Tween(colorPicker.Frame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.4, Enum.EasingStyle.Back)
        else
            Tween(colorPicker.Frame, {Size = UDim2.new(1, 0, 0, colorPickerHeight)}, 0.4, Enum.EasingStyle.Back)
        end
    end)
    
    colorPicker.Frame.MouseEnter:Connect(function()
        Tween(colorPicker.Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    colorPicker.Frame.MouseLeave:Connect(function()
        Tween(colorPicker.Frame, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    return colorPicker
end

function Library:Notify(config)
    config = config or {}
    local notification = {}
    
    local notifWidth = self.IsMobile and 250 or 280
    local notifHeight = self.IsMobile and 80 or 70
    
    notification.Frame = CreateInstance("Frame", {
        Size = UDim2.new(0, notifWidth, 0, notifHeight),
        Position = UDim2.new(1, notifWidth + 20, 1, -(notifHeight + 20)),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, self.IsMobile and 8 or 6)
    }, notification.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.5,
        Thickness = 1
    }, notification.Frame)
    
    notification.Title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, self.IsMobile and 25 or 20),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = self.Theme.Text,
        TextSize = self.IsMobile and 18 or 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, notification.Frame)
    
    notification.Text = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, self.IsMobile and 30 or 25),
        Position = UDim2.new(0, 10, 0, self.IsMobile and 35 or 30),
        BackgroundTransparency = 1,
        Text = config.Text or "This is a notification",
        TextColor3 = self.Theme.TextDark,
        TextSize = self.IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Font = Enum.Font.Ubuntu
    }, notification.Frame)
    
    -- Animate in with bounce
    Tween(notification.Frame, {Position = UDim2.new(1, -(notifWidth + 20), 1, -(notifHeight + 20))}, 0.4, Enum.EasingStyle.Back)
    
    -- Auto close
    task.spawn(function()
        task.wait(config.Duration or 3)
        
        -- Animate out
        Tween(notification.Frame, {Position = UDim2.new(1, notifWidth + 20, 1, -(notifHeight + 20))}, 0.3)
        task.wait(0.3)
        if notification.Frame then
            notification.Frame:Destroy()
        end
    end)
    
    return notification
end

function Library:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        
        -- Update all UI elements with new theme
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        if self.TopDivider then
            self.TopDivider.BackgroundColor3 = self.Theme.Border
        end
        if self.VerticalDivider then
            self.VerticalDivider.BackgroundColor3 = self.Theme.Border
        end
        
        -- Update all existing elements
        for _, descendant in pairs(self.ScreenGui:GetDescendants()) do
            if descendant:IsA("Frame") then
                if descendant.BackgroundColor3 == self.Theme.Tertiary then
                    descendant.BackgroundColor3 = self.Theme.Tertiary
                elseif descendant.BackgroundColor3 == self.Theme.Secondary then
                    descendant.BackgroundColor3 = self.Theme.Secondary
                end
            elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                if descendant.TextColor3 == self.Theme.Text then
                    descendant.TextColor3 = self.Theme.Text
                elseif descendant.TextColor3 == self.Theme.TextDark then
                    descendant.TextColor3 = self.Theme.TextDark
                end
            elseif descendant:IsA("ScrollingFrame") then
                descendant.ScrollBarImageColor3 = self.Theme.Accent
            elseif descendant.Name == "Highlight" then
                descendant.BackgroundColor3 = self.Theme.SectionHighlight
            end
        end
    end
end

function Library:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Library
