-- Premium UI Library for Roblox
-- Supports multiple themes, smooth animations, and comprehensive UI components

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
        Background = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(35, 35, 35),
        Tertiary = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(50, 50, 50),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(255, 255, 255),
        Tertiary = Color3.fromRGB(230, 230, 230),
        Accent = Color3.fromRGB(50, 50, 200),
        Text = Color3.fromRGB(0, 0, 0),
        TextDark = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(100, 100, 100)
    },
    Midnight = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 40),
        Tertiary = Color3.fromRGB(35, 35, 55),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 200),
        Border = Color3.fromRGB(40, 40, 60),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Rose = {
        Background = Color3.fromRGB(30, 20, 25),
        Secondary = Color3.fromRGB(45, 30, 40),
        Tertiary = Color3.fromRGB(60, 40, 55),
        Accent = Color3.fromRGB(255, 100, 150),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 190),
        Border = Color3.fromRGB(70, 50, 65),
        Shadow = Color3.fromRGB(10, 5, 10)
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
    easingStyle = easingStyle or Enum.EasingStyle.Quart
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
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Main Library Functions
function Library:Create(config)
    config = config or {}
    local self = setmetatable({}, Library)
    
    self.Theme = Themes[config.Theme or "Dark"]
    self.Title = config.Title or "UI Library"
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Create ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "UILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, CoreGui)
    
    -- Main Frame
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 600, 0, 450),
        Position = UDim2.new(0.5, -300, 0.5, -225),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, self.ScreenGui)
    
    -- Add rounded corners
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12)
    }, self.MainFrame)
    
    -- Shadow
    local Shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = self.Theme.Shadow,
        ImageTransparency = 0.5,
        ZIndex = -1
    }, self.MainFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
    }, Shadow)
    
    -- Title Bar
    self.TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12)
    }, self.TitleBar)
    
    -- Fix title bar corners
    CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    }, self.TitleBar)
    
    -- Title
    CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, self.TitleBar)
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = self.Theme.Tertiary,
        Text = "Ã—",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0
    }, self.TitleBar)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, CloseButton)
    
    CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Minimize Button
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0.5, -15),
        BackgroundColor3 = self.Theme.Tertiary,
        Text = "â€”",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0
    }, self.TitleBar)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, MinimizeButton)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
        else
            Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.3)
        end
    end)
    
    -- Tab Container
    self.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 150, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Content Container
    self.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -150, 1, -40),
        Position = UDim2.new(0, 150, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Tab List Layout
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    }, self.TabContainer)
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    }, self.TabContainer)
    
    -- Make draggable
    AddDragging(self.MainFrame, self.TitleBar)
    
    return self
end

function Library:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Icon = icon
    
    -- Tab Button
    tab.Button = CreateInstance("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    }, self.TabContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, tab.Button)
    
    -- Tab Label
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Theme.TextDark,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, tab.Button)
    
    -- Tab Content
    tab.Content = CreateInstance("ScrollingFrame", {
        Name = name .. "Content",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = false
    }, self.ContentContainer)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    }, tab.Content)
    
    -- Tab Selection
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Library:SelectTab(tab)
    for _, t in pairs(self.Tabs) do
        t.Content.Visible = false
        Tween(t.Button, {BackgroundColor3 = self.Theme.Tertiary}, 0.2)
    end
    
    tab.Content.Visible = true
    Tween(tab.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2)
    self.CurrentTab = tab
end

-- UI Elements
function Library:CreateButton(tab, config)
    config = config or {}
    local button = {}
    
    button.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, button.Frame)
    
    button.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Text = config.Text or "Button",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, button.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, button.Button)
    
    button.Button.MouseButton1Click:Connect(function()
        Tween(button.Button, {BackgroundColor3 = self.Theme.Secondary}, 0.1)
        wait(0.1)
        Tween(button.Button, {BackgroundColor3 = self.Theme.Accent}, 0.1)
        
        if config.Callback then
            config.Callback()
        end
    end)
    
    return button
end

function Library:CreateToggle(tab, config)
    config = config or {}
    local toggle = {}
    toggle.Enabled = config.Default or false
    
    toggle.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, toggle.Frame)
    
    toggle.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Toggle",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, toggle.Frame)
    
    toggle.Button = CreateInstance("TextButton", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = toggle.Enabled and self.Theme.Accent or self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = ""
    }, toggle.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, toggle.Button)
    
    toggle.Indicator = CreateInstance("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = toggle.Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0
    }, toggle.Button)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, toggle.Indicator)
    
    toggle.Button.MouseButton1Click:Connect(function()
        toggle.Enabled = not toggle.Enabled
        
        if toggle.Enabled then
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            Tween(toggle.Indicator, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
        else
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Secondary}, 0.2)
            Tween(toggle.Indicator, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
        end
        
        if config.Callback then
            config.Callback(toggle.Enabled)
        end
    end)
    
    return toggle
end

function Library:CreateSlider(tab, config)
    config = config or {}
    local slider = {}
    slider.Min = config.Min or 0
    slider.Max = config.Max or 100
    slider.Value = config.Default or slider.Min
    
    slider.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, slider.Frame)
    
    slider.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Text or "Slider",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, slider.Frame)
    
    slider.Value_Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -60, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(slider.Value),
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, slider.Frame)
    
    slider.SliderFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
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
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -8, 0.5, -8),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0
    }, slider.SliderFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, slider.Knob)
    
    local dragging = false
    
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
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = mousePos.X - slider.SliderFrame.AbsolutePosition.X
            local percentage = math.clamp(relativePos / slider.SliderFrame.AbsoluteSize.X, 0, 1)
            
            slider.Value = math.floor(slider.Min + (slider.Max - slider.Min) * percentage)
            slider.Value_Label.Text = tostring(slider.Value)
            
            Tween(slider.Fill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
            Tween(slider.Knob, {Position = UDim2.new(percentage, -8, 0.5, -8)}, 0.1)
            
            if config.Callback then
                config.Callback(slider.Value)
            end
        end
    end)
    
    return slider
end

function Library:CreateInput(tab, config)
    config = config or {}
    local input = {}
    
    input.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, input.Frame)
    
    input.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.4, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Input",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, input.Frame)
    
    input.TextBox = CreateInstance("TextBox", {
        Size = UDim2.new(0.6, -10, 1, -10),
        Position = UDim2.new(0.4, 0, 0, 5),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = config.Default or "",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham,
        PlaceholderText = config.Placeholder or "Enter text...",
        PlaceholderColor3 = self.Theme.TextDark
    }, input.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, input.TextBox)
    
    input.TextBox.FocusLost:Connect(function(enterPressed)
        if config.Callback then
            config.Callback(input.TextBox.Text, enterPressed)
        end
    end)
    
    return input
end

function Library:CreateDropdown(tab, config)
    config = config or {}
    local dropdown = {}
    dropdown.Options = config.Options or {}
    dropdown.Selected = config.Default or (dropdown.Options[1] or "None")
    dropdown.Open = false
    
    dropdown.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, dropdown.Frame)
    
    dropdown.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.4, -10, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Dropdown",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, dropdown.Frame)
    
    dropdown.Button = CreateInstance("TextButton", {
        Size = UDim2.new(0.6, -10, 0, 30),
        Position = UDim2.new(0.4, 0, 0, 5),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = dropdown.Selected,
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, dropdown.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, dropdown.Button)
    
    dropdown.Arrow = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "â–¼",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, dropdown.Button)
    
    dropdown.OptionContainer = CreateInstance("Frame", {
        Size = UDim2.new(0.6, -10, 0, 0),
        Position = UDim2.new(0.4, 0, 0, 40),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Visible = true
    }, dropdown.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, dropdown.OptionContainer)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, dropdown.OptionContainer)
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    }, dropdown.OptionContainer)
    
    local function UpdateOptions()
        for _, child in pairs(dropdown.OptionContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for _, option in pairs(dropdown.Options) do
            local optionButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = self.Theme.Tertiary,
                BorderSizePixel = 0,
                Text = option,
                TextColor3 = self.Theme.Text,
                TextScaled = true,
                Font = Enum.Font.Gotham
            }, dropdown.OptionContainer)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4)
            }, optionButton)
            
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Selected = option
                dropdown.Button.Text = option
                dropdown.Open = false
                Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                Tween(dropdown.Arrow, {Rotation = 0}, 0.2)
                
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
            local newSize = 40 + (optionCount * 27) + 15
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, newSize)}, 0.2)
            Tween(dropdown.Arrow, {Rotation = 180}, 0.2)
        else
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
            Tween(dropdown.Arrow, {Rotation = 0}, 0.2)
        end
    end)
    
    return dropdown
end

function Library:CreateSearchBox(tab, config)
    config = config or {}
    local search = {}
    search.Items = config.Items or {}
    search.FilteredItems = {}
    
    search.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, search.Frame)
    
    search.SearchBox = CreateInstance("TextBox", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham,
        PlaceholderText = config.Placeholder or "Search...",
        PlaceholderColor3 = self.Theme.TextDark
    }, search.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, search.SearchBox)
    
    search.Icon = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "ðŸ”",
        TextColor3 = self.Theme.TextDark,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, search.SearchBox)
    
    search.ResultsContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = false
    }, search.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, search.ResultsContainer)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, search.ResultsContainer)
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    }, search.ResultsContainer)
    
    local function UpdateResults()
        for _, child in pairs(search.ResultsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local resultCount = 0
        for _, item in pairs(search.FilteredItems) do
            resultCount = resultCount + 1
            
            local resultButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = self.Theme.Tertiary,
                BorderSizePixel = 0,
                Text = item,
                TextColor3 = self.Theme.Text,
                TextScaled = true,
                Font = Enum.Font.Gotham
            }, search.ResultsContainer)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4)
            }, resultButton)
            
            resultButton.MouseButton1Click:Connect(function()
                search.SearchBox.Text = item
                search.ResultsContainer.Visible = false
                Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                
                if config.Callback then
                    config.Callback(item)
                end
            end)
        end
        
        if resultCount > 0 then
            local newSize = 40 + math.min(resultCount * 27 + 15, 150)
            search.ResultsContainer.Visible = true
            search.ResultsContainer.Size = UDim2.new(1, -20, 0, math.min(resultCount * 27 + 10, 150))
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, newSize)}, 0.2)
        else
            search.ResultsContainer.Visible = false
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
        end
    end
    
    search.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = search.SearchBox.Text:lower()
        search.FilteredItems = {}
        
        if searchText == "" then
            search.ResultsContainer.Visible = false
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
        else
            for _, item in pairs(search.Items) do
                if item:lower():find(searchText) then
                    table.insert(search.FilteredItems, item)
                end
            end
            UpdateResults()
        end
    end)
    
    search.SearchBox.FocusLost:Connect(function()
        wait(0.1)
        if search.SearchBox.Text == "" then
            search.ResultsContainer.Visible = false
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
        end
    end)
    
    return search
end

function Library:CreateLabel(tab, config)
    config = config or {}
    local label = {}
    
    label.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, label.Frame)
    
    label.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Label",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, label.Frame)
    
    return label
end

function Library:CreateSeparator(tab)
    local separator = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = self.Theme.Border,
        BorderSizePixel = 0
    }, tab.Content)
    
    return separator
end

function Library:CreateColorPicker(tab, config)
    config = config or {}
    local colorPicker = {}
    colorPicker.Color = config.Default or Color3.fromRGB(255, 255, 255)
    colorPicker.Open = false
    
    colorPicker.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, tab.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, colorPicker.Frame)
    
    colorPicker.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Color Picker",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, colorPicker.Frame)
    
    colorPicker.ColorDisplay = CreateInstance("TextButton", {
        Size = UDim2.new(0, 40, 0, 25),
        Position = UDim2.new(1, -50, 0.5, -12.5),
        BackgroundColor3 = colorPicker.Color,
        BorderSizePixel = 0,
        Text = ""
    }, colorPicker.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, colorPicker.ColorDisplay)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Thickness = 2
    }, colorPicker.ColorDisplay)
    
    colorPicker.PickerContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 200),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Visible = true
    }, colorPicker.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, colorPicker.PickerContainer)
    
    -- HSV Gradient
    colorPicker.HueFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
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
    
    colorPicker.HueKnob = CreateInstance("Frame", {
        Size = UDim2.new(0, 10, 1, 4),
        Position = UDim2.new(0, -5, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorPicker.HueFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 2)
    }, colorPicker.HueKnob)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Thickness = 1
    }, colorPicker.HueKnob)
    
    -- RGB Inputs
    local rgbContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 80),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1
    }, colorPicker.PickerContainer)
    
    local function createRGBInput(name, yPos, defaultValue)
        local container = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, yPos),
            BackgroundTransparency = 1
        }, rgbContainer)
        
        CreateInstance("TextLabel", {
            Size = UDim2.new(0, 30, 1, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Text,
            TextScaled = true,
            Font = Enum.Font.Gotham
        }, container)
        
        local input = CreateInstance("TextBox", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            BackgroundColor3 = self.Theme.Tertiary,
            BorderSizePixel = 0,
            Text = tostring(defaultValue),
            TextColor3 = self.Theme.Text,
            TextScaled = true,
            Font = Enum.Font.Gotham
        }, container)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4)
        }, input)
        
        return input
    end
    
    colorPicker.RInput = createRGBInput("R", 0, math.floor(colorPicker.Color.R * 255))
    colorPicker.GInput = createRGBInput("G", 27, math.floor(colorPicker.Color.G * 255))
    colorPicker.BInput = createRGBInput("B", 54, math.floor(colorPicker.Color.B * 255))
    
    -- Hex Input
    local hexContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 130),
        BackgroundTransparency = 1
    }, colorPicker.PickerContainer)
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        BackgroundTransparency = 1,
        Text = "#",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, hexContainer)
    
    colorPicker.HexInput = CreateInstance("TextBox", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = string.format("%02X%02X%02X", 
            math.floor(colorPicker.Color.R * 255),
            math.floor(colorPicker.Color.G * 255),
            math.floor(colorPicker.Color.B * 255)
        ),
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, hexContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, colorPicker.HexInput)
    
    -- Apply Button
    colorPicker.ApplyButton = CreateInstance("TextButton", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 165),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Text = "Apply",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        Font = Enum.Font.Gotham
    }, colorPicker.PickerContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, colorPicker.ApplyButton)
    
    -- Functions
    local function updateColor()
        local r = tonumber(colorPicker.RInput.Text) or 0
        local g = tonumber(colorPicker.GInput.Text) or 0
        local b = tonumber(colorPicker.BInput.Text) or 0
        
        r = math.clamp(r, 0, 255)
        g = math.clamp(g, 0, 255)
        b = math.clamp(b, 0, 255)
        
        colorPicker.Color = Color3.fromRGB(r, g, b)
        colorPicker.ColorDisplay.BackgroundColor3 = colorPicker.Color
        
        colorPicker.HexInput.Text = string.format("%02X%02X%02X", r, g, b)
    end
    
    local function updateFromHex()
        local hex = colorPicker.HexInput.Text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16) or 0
            local g = tonumber(hex:sub(3, 4), 16) or 0
            local b = tonumber(hex:sub(5, 6), 16) or 0
            
            colorPicker.RInput.Text = tostring(r)
            colorPicker.GInput.Text = tostring(g)
            colorPicker.BInput.Text = tostring(b)
            
            updateColor()
        end
    end
    
    -- Hue dragging
    local hueDragging = false
    
    colorPicker.HueFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = mousePos.X - colorPicker.HueFrame.AbsolutePosition.X
            local percentage = math.clamp(relativePos / colorPicker.HueFrame.AbsoluteSize.X, 0, 1)
            
            colorPicker.HueKnob.Position = UDim2.new(percentage, 0, 0.5, 0)
            
            local hue = percentage
            local color = Color3.fromHSV(hue, 1, 1)
            
            colorPicker.RInput.Text = tostring(math.floor(color.R * 255))
            colorPicker.GInput.Text = tostring(math.floor(color.G * 255))
            colorPicker.BInput.Text = tostring(math.floor(color.B * 255))
            
            updateColor()
        end
    end)
    
    -- Connect inputs
    colorPicker.RInput.FocusLost:Connect(updateColor)
    colorPicker.GInput.FocusLost:Connect(updateColor)
    colorPicker.BInput.FocusLost:Connect(updateColor)
    colorPicker.HexInput.FocusLost:Connect(updateFromHex)
    
    -- Toggle picker
    colorPicker.ColorDisplay.MouseButton1Click:Connect(function()
        colorPicker.Open = not colorPicker.Open
        
        if colorPicker.Open then
            Tween(colorPicker.Frame, {Size = UDim2.new(1, 0, 0, 250)}, 0.2)
        else
            Tween(colorPicker.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
        end
    end)
    
    -- Apply button
    colorPicker.ApplyButton.MouseButton1Click:Connect(function()
        colorPicker.Open = false
        Tween(colorPicker.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
        
        if config.Callback then
            config.Callback(colorPicker.Color)
        end
    end)
    
    return colorPicker
end

function Library:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        
        -- Update all UI elements with new theme
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        self.TitleBar.BackgroundColor3 = self.Theme.Secondary
        self.TabContainer.BackgroundColor3 = self.Theme.Secondary
        
        -- Update all existing elements
        for _, descendant in pairs(self.ScreenGui:GetDescendants()) do
            if descendant:IsA("Frame") then
                if descendant.Name == "Shadow" then
                    -- Skip shadow
                elseif descendant.BackgroundColor3 == self.Theme.Tertiary then
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
            end
        end
    end
end

function Library:Notify(config)
    config = config or {}
    local notification = {}
    
    notification.Frame = CreateInstance("Frame", {
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, 320, 1, -100),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, notification.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Thickness = 2
    }, notification.Frame)
    
    notification.Title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = self.Theme.Text,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    }, notification.Frame)
    
    notification.Text = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = config.Text or "This is a notification",
        TextColor3 = self.Theme.TextDark,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Font = Enum.Font.Gotham
    }, notification.Frame)
    
    -- Animate in
    Tween(notification.Frame, {Position = UDim2.new(1, -320, 1, -100)}, 0.3)
    
    -- Auto close
    task.wait(config.Duration or 3)
    
    -- Animate out
    Tween(notification.Frame, {Position = UDim2.new(1, 320, 1, -100)}, 0.3)
    task.wait(0.3)
    notification.Frame:Destroy()
end

function Library:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Library
