-- Eps1llon Hub Premium UI Library
-- Modern, sleek design with smooth animations and resizable interface

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
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
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
    self.MinSize = Vector2.new(500, 400)
    self.MaxSize = Vector2.new(800, 600)
    
    -- Create ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "Eps1llonHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, CoreGui)
    
    -- Main Frame with transparency effect
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, -325, 0.5, -225),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = false
    }, self.ScreenGui)
    
    -- Add slight rounded corners
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
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
        CornerRadius = UDim.new(0, 12)
    }, EdgeGlow)
    
    -- Title Bar
    self.TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 35),
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
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, self.TitleBar)
    
    -- Close Button (X)
    self.CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 22,
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
    
    -- Minimize Button (-)
    self.MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -55, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
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
        Position = UDim2.new(0, 15, 0, 35),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Left Section Container
    self.SectionContainer = CreateInstance("ScrollingFrame", {
        Name = "SectionContainer",
        Size = UDim2.new(0, 150, 1, -45),
        Position = UDim2.new(0, 10, 0, 40),
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
        Size = UDim2.new(0, 1, 1, -45),
        Position = UDim2.new(0, 170, 0, 40),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Content Container
    self.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -190, 1, -50),
        Position = UDim2.new(0, 180, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Minimized Frame (Floating Square)
    self.MinimizedFrame = CreateInstance("Frame", {
        Name = "MinimizedFrame",
        Size = UDim2.new(0, 150, 0, 40),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Visible = false
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
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
        TextSize = 14,
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
    
    -- Add resizing
    self:AddResizing()
    
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
    
    -- Section Button
    section.Button = CreateInstance("TextButton", {
        Name = name .. "Section",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = ""
    }, self.SectionContainer)
    
    -- Section Highlight (left line)
    section.Highlight = CreateInstance("Frame", {
        Name = "Highlight",
        Size = UDim2.new(0, 3, 1, -10),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundColor3 = self.Theme.SectionHighlight,
        BorderSizePixel = 0,
        Visible = false
    }, section.Button)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 2)
    }, section.Highlight)
    
    -- Section Label
    section.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Theme.TextDark,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, section.Button)
    
    -- Section Content
    section.Content = CreateInstance("ScrollingFrame", {
        Name = name .. "Content",
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        Visible = false
    }, self.ContentContainer)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    }, section.Content)
    
    -- Section Selection
    section.Button.MouseButton1Click:Connect(function()
        self:SelectSection(section)
    end)
    
    section.Button.MouseEnter:Connect(function()
        if self.CurrentSection ~= section then
            Tween(section.Label, {TextColor3 = self.Theme.Text}, 0.2)
        end
    end)
    
    section.Button.MouseLeave:Connect(function()
        if self.CurrentSection ~= section then
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
        s.Highlight.Visible = false
        Tween(s.Label, {TextColor3 = self.Theme.TextDark}, 0.2)
    end
    
    section.Content.Visible = true
    section.Highlight.Visible = true
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
    Tween(self.MainFrame, {Size = UDim2.new(0, 650, 0, 450), BackgroundTransparency = 0.05}, 0.3)
end

-- UI Elements
function Library:CreateButton(section, config)
    config = config or {}
    local button = {}
    
    button.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, button.Frame)
    
    button.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = config.Text or "Button",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
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
    
    toggle.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, toggle.Frame)
    
    toggle.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Toggle",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, toggle.Frame)
    
    toggle.Button = CreateInstance("TextButton", {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -46, 0.5, -9),
        BackgroundColor3 = toggle.Enabled and self.Theme.Accent or self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = ""
    }, toggle.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, toggle.Button)
    
    toggle.Indicator = CreateInstance("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = toggle.Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0
    }, toggle.Button)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, toggle.Indicator)
    
    local function SetToggle(value)
        toggle.Enabled = value
        
        if toggle.Enabled then
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            Tween(toggle.Indicator, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2)
        else
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Tertiary}, 0.2)
            Tween(toggle.Indicator, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2)
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
    
    slider.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, slider.Frame)
    
    slider.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -70, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Text or "Slider",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, slider.Frame)
    
    slider.ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -60, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(slider.Value),
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu
    }, slider.Frame)
    
    slider.SliderFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 4),
        Position = UDim2.new(0, 10, 0, 33),
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
    
    slider.Knob = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -6, 0.5, -6),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0
    }, slider.SliderFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, slider.Knob)
    
    local dragging = false
    
    local function UpdateSlider(input)
        local mousePos = UserInputService:GetMouseLocation()
        local relativePos = mousePos.X - slider.SliderFrame.AbsolutePosition.X
        local percentage = math.clamp(relativePos / slider.SliderFrame.AbsoluteSize.X, 0, 1)
        
        slider.Value = math.floor(slider.Min + (slider.Max - slider.Min) * percentage)
        slider.ValueLabel.Text = tostring(slider.Value)
        
        Tween(slider.Fill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
        Tween(slider.Knob, {Position = UDim2.new(percentage, -6, 0.5, -6)}, 0.1)
        
        if config.Callback then
            config.Callback(slider.Value)
        end
    end
    
    slider.SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    slider.Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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
    
    input.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, input.Frame)
    
    input.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.35, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Input",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, input.Frame)
    
    input.TextBox = CreateInstance("TextBox", {
        Size = UDim2.new(0.65, -10, 1, -8),
        Position = UDim2.new(0.35, 0, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = config.Default or "",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu,
        PlaceholderText = config.Placeholder or "Enter text...",
        PlaceholderColor3 = self.Theme.TextDark,
        ClearTextOnFocus = false
    }, input.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
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
    
    dropdown.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, dropdown.Frame)
    
    dropdown.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.35, -10, 0, 35),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Dropdown",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, dropdown.Frame)
    
    dropdown.Button = CreateInstance("TextButton", {
        Size = UDim2.new(0.65, -10, 0, 27),
        Position = UDim2.new(0.35, 0, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = dropdown.Selected,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu
    }, dropdown.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, dropdown.Button)
    
    dropdown.Arrow = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = self.Theme.Text,
        TextSize = 10,
        Font = Enum.Font.Ubuntu
    }, dropdown.Button)
    
    dropdown.OptionContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(0.65, -10, 0, 0),
        Position = UDim2.new(0.35, 0, 0, 35),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = true
    }, dropdown.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
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
            local optionButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundColor3 = self.Theme.Secondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Text = option,
                TextColor3 = self.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Ubuntu
            }, dropdown.OptionContainer)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 3)
            }, optionButton)
            
            optionButton.MouseEnter:Connect(function()
                Tween(optionButton, {BackgroundTransparency = 0.2}, 0.2)
            end)
            
            optionButton.MouseLeave:Connect(function()
                Tween(optionButton, {BackgroundTransparency = 0.5}, 0.2)
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Selected = option
                dropdown.Button.Text = option
                dropdown.Open = false
                
                local optionCount = #dropdown.Options
                local maxHeight = math.min(optionCount * 24 + 6, 150)
                
                Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                Tween(dropdown.Arrow, {Rotation = 0}, 0.2)
                Tween(dropdown.OptionContainer, {Size = UDim2.new(0.65, -10, 0, 0)}, 0.2)
                
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
            local maxHeight = math.min(optionCount * 24 + 6, 150)
            local newSize = 35 + maxHeight + 5
            
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, newSize)}, 0.2)
            Tween(dropdown.Arrow, {Rotation = 180}, 0.2)
            Tween(dropdown.OptionContainer, {Size = UDim2.new(0.65, -10, 0, maxHeight)}, 0.2)
        else
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
            Tween(dropdown.Arrow, {Rotation = 0}, 0.2)
            Tween(dropdown.OptionContainer, {Size = UDim2.new(0.65, -10, 0, 0)}, 0.2)
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
    
    label.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, label.Frame)
    
    label.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Label",
        TextColor3 = config.Color or self.Theme.Text,
        TextSize = 14,
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
    
    keybind.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, keybind.Frame)
    
    keybind.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.65, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Keybind",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, keybind.Frame)
    
    keybind.Button = CreateInstance("TextButton", {
        Size = UDim2.new(0.35, -10, 0, 27),
        Position = UDim2.new(0.65, 0, 0.5, -13.5),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = keybind.Key.Name,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu
    }, keybind.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
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
    
    colorPicker.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, colorPicker.Frame)
    
    colorPicker.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Color Picker",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, colorPicker.Frame)
    
    colorPicker.ColorDisplay = CreateInstance("TextButton", {
        Size = UDim2.new(0, 40, 0, 25),
        Position = UDim2.new(1, -50, 0.5, -12.5),
        BackgroundColor3 = colorPicker.Color,
        BorderSizePixel = 0,
        Text = ""
    }, colorPicker.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, colorPicker.ColorDisplay)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.5,
        Thickness = 1
    }, colorPicker.ColorDisplay)
    
    -- Color picker content
    colorPicker.PickerContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 180),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Visible = true
    }, colorPicker.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, colorPicker.PickerContainer)
    
    -- Color saturation/value picker
    colorPicker.SVPicker = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 100),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorPicker.PickerContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
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
    
    colorPicker.SVIndicator = CreateInstance("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(1, -5, 0, -5),
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
    
    -- Hue slider
    colorPicker.HueFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 15),
        Position = UDim2.new(0, 10, 0, 120),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorPicker.PickerContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
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
    
    colorPicker.HueIndicator = CreateInstance("Frame", {
        Size = UDim2.new(0, 8, 1, 4),
        Position = UDim2.new(0, -4, 0.5, 0),
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
    colorPicker.HexInput = CreateInstance("TextBox", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 145),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = string.format("#%02X%02X%02X", 
            math.floor(colorPicker.Color.R * 255),
            math.floor(colorPicker.Color.G * 255),
            math.floor(colorPicker.Color.B * 255)
        ),
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu,
        PlaceholderText = "#FFFFFF"
    }, colorPicker.PickerContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
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
    
    -- SV picker
    colorPicker.SVPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = true
        end
    end)
    
    -- Hue slider
    colorPicker.HueFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = false
            draggingHue = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if draggingSV then
                local mousePos = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mousePos.X - colorPicker.SVPicker.AbsolutePosition.X) / colorPicker.SVPicker.AbsoluteSize.X, 0, 1)
                local relativeY = math.clamp((mousePos.Y - colorPicker.SVPicker.AbsolutePosition.Y) / colorPicker.SVPicker.AbsoluteSize.Y, 0, 1)
                
                s = relativeX
                v = 1 - relativeY
                
                colorPicker.SVIndicator.Position = UDim2.new(relativeX, -5, relativeY, -5)
                UpdateColor()
            elseif draggingHue then
                local mousePos = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mousePos.X - colorPicker.HueFrame.AbsolutePosition.X) / colorPicker.HueFrame.AbsoluteSize.X, 0, 1)
                
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
                
                colorPicker.SVIndicator.Position = UDim2.new(s, -5, 1 - v, -5)
                colorPicker.HueIndicator.Position = UDim2.new(h, 0, 0.5, 0)
                
                UpdateColor()
            end
        end
    end)
    
    -- Toggle color picker
    colorPicker.ColorDisplay.MouseButton1Click:Connect(function()
        colorPicker.Open = not colorPicker.Open
        
        if colorPicker.Open then
            Tween(colorPicker.Frame, {Size = UDim2.new(1, 0, 0, 225)}, 0.3)
        else
            Tween(colorPicker.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
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
    
    notification.Frame = CreateInstance("Frame", {
        Size = UDim2.new(0, 280, 0, 70),
        Position = UDim2.new(1, 300, 1, -90),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, notification.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.5,
        Thickness = 1
    }, notification.Frame)
    
    notification.Title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, notification.Frame)
    
    notification.Text = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = config.Text or "This is a notification",
        TextColor3 = self.Theme.TextDark,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Font = Enum.Font.Ubuntu
    }, notification.Frame)
    
    -- Animate in
    Tween(notification.Frame, {Position = UDim2.new(1, -300, 1, -90)}, 0.3)
    
    -- Auto close
    task.wait(config.Duration or 3)
    
    -- Animate out
    Tween(notification.Frame, {Position = UDim2.new(1, 300, 1, -90)}, 0.3)
    task.wait(0.3)
    notification.Frame:Destroy()
end

function Library:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        
        -- Update all UI elements with new theme
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        self.TopDivider.BackgroundColor3 = self.Theme.Border
        self.VerticalDivider.BackgroundColor3 = self.Theme.Border
        
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
