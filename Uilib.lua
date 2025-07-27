-- Eps1llon Hub Premium UI Library (Enhanced Version)
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
        Border = Color3.fromRGB(80, 80, 80),
        SectionHighlight = Color3.fromRGB(100, 100, 255),
        SectionBackground = Color3.fromRGB(25, 25, 25)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(255, 255, 255),
        Tertiary = Color3.fromRGB(230, 230, 230),
        Accent = Color3.fromRGB(50, 50, 200),
        Text = Color3.fromRGB(0, 0, 0),
        TextDark = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(180, 180, 180),
        SectionHighlight = Color3.fromRGB(50, 50, 200),
        SectionBackground = Color3.fromRGB(250, 250, 250)
    },
    Purple = {
        Background = Color3.fromRGB(25, 20, 35),
        Secondary = Color3.fromRGB(35, 30, 45),
        Tertiary = Color3.fromRGB(45, 40, 55),
        Accent = Color3.fromRGB(150, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 200),
        Border = Color3.fromRGB(70, 60, 85),
        SectionHighlight = Color3.fromRGB(150, 100, 255),
        SectionBackground = Color3.fromRGB(30, 25, 40)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 35),
        Secondary = Color3.fromRGB(25, 35, 45),
        Tertiary = Color3.fromRGB(35, 45, 55),
        Accent = Color3.fromRGB(100, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 220),
        Border = Color3.fromRGB(60, 80, 95),
        SectionHighlight = Color3.fromRGB(100, 200, 255),
        SectionBackground = Color3.fromRGB(20, 30, 40)
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
            }, 0.05, Enum.EasingStyle.Linear)
        end
    end)
end

-- Main Library Functions
function Library:Create(config)
    config = config or {}
    local self = setmetatable({}, Library)
    
    self.Theme = Themes[config.Theme or "Ocean"] -- Default theme changed to Ocean
    self.Sections = {}
    self.CurrentSection = nil
    self.Minimized = false
    self.MinSize = Vector2.new(500, 400)
    self.MaxSize = Vector2.new(800, 600)
    self.ActiveFunctions = {}
    self.OriginalSize = UDim2.new(0, 650, 0, 450) -- Store original size
    self.ShowActiveFunctions = false
    
    -- Create ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "Eps1llonHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, CoreGui)
    
    -- Main Frame with transparency effect
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = self.OriginalSize,
        Position = UDim2.new(0.5, -325, 0.5, -225),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = false
    }, self.ScreenGui)
    
    -- Add background image to main frame
    CreateInstance("ImageLabel", {
        Name = "BackgroundImage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://98784591713474",
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = -2
    }, self.MainFrame)
    
    -- Add slight rounded corners
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, self.MainFrame)
    
    -- Apply corner to background image too
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, self.MainFrame.BackgroundImage)
    
    -- Edge glow effect
    local EdgeGlow = CreateInstance("ImageLabel", {
        Name = "EdgeGlow",
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = self.Theme.Accent,
        ImageTransparency = 0.9,
        ZIndex = -1
    }, self.MainFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10)
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
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -32, 0.5, -12.5),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 26,
        Font = Enum.Font.Ubuntu
    }, self.TitleBar)
    
    self.CloseButton.MouseEnter:Connect(function()
        Tween(self.CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
        Mouse.Icon = "rbxassetid://86509207249522"
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        Tween(self.CloseButton, {TextColor3 = self.Theme.Text}, 0.2)
        Mouse.Icon = ""
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Minimize Button (-)
    self.MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 20, 0, 18),
        Position = UDim2.new(1, -62, 0.5, -9),
        BackgroundTransparency = 1,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.Ubuntu
    }, self.TitleBar)
    
    self.MinimizeButton.MouseEnter:Connect(function()
        Tween(self.MinimizeButton, {TextColor3 = self.Theme.Accent}, 0.2)
        Mouse.Icon = "rbxassetid://86509207249522"
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        Tween(self.MinimizeButton, {TextColor3 = self.Theme.Text}, 0.2)
        Mouse.Icon = ""
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    -- Top divider line
    self.TopDivider = CreateInstance("Frame", {
        Name = "TopDivider",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
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
        Padding = UDim.new(0, 8)
    }, self.SectionContainer)
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    }, self.SectionContainer)
    
    -- Vertical divider line
    self.VerticalDivider = CreateInstance("Frame", {
        Name = "VerticalDivider",
        Size = UDim2.new(0, 1, 1, -35),
        Position = UDim2.new(0, 170, 0, 35),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
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
    
    -- Add background image to minimized frame
    CreateInstance("ImageLabel", {
        Name = "MinimizedBackgroundImage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://98784591713474",
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = -1
    }, self.MinimizedFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, self.MinimizedFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, self.MinimizedFrame.MinimizedBackgroundImage)
    
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
    
    -- Create Active Functions Display (hidden by default)
    self:CreateActiveFunctionsDisplay()
    
    -- Make frames draggable
    AddDragging(self.MainFrame, self.TitleBar)
    AddDragging(self.MinimizedFrame) -- Make minimized frame draggable
    
    -- Add resizing
    self:AddResizing()
    
    return self
end

-- Active Functions Display (hidden by default)
function Library:CreateActiveFunctionsDisplay()
    self.ActiveFunctionsFrame = CreateInstance("Frame", {
        Name = "ActiveFunctionsFrame",
        Size = UDim2.new(0, 200, 0, 150),
        Position = UDim2.new(1, -220, 0, 20),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false -- Hidden by default
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, self.ActiveFunctionsFrame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.6,
        Thickness = 1
    }, self.ActiveFunctionsFrame)
    
    -- Header
    local header = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "Active Functions",
        TextColor3 = self.Theme.Accent,
        TextSize = 14,
        Font = Enum.Font.Ubuntu,
        TextXAlignment = Enum.TextXAlignment.Center
    }, self.ActiveFunctionsFrame)
    
    -- Divider
    CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 25),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, self.ActiveFunctionsFrame)
    
    -- Content area
    self.ActiveFunctionsContent = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -10, 1, -35),
        Position = UDim2.new(0, 5, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent
    }, self.ActiveFunctionsFrame)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3)
    }, self.ActiveFunctionsContent)
    
    -- Make draggable
    AddDragging(self.ActiveFunctionsFrame)
    
    -- Update content
    self:UpdateActiveFunctions()
end

function Library:ShowActiveFunctions()
    self.ShowActiveFunctions = true
    self.ActiveFunctionsFrame.Visible = true
    
    -- Floating animation
    local floatTween1 = TweenService:Create(
        self.ActiveFunctionsFrame,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(1, -220, 0, 30)}
    )
    floatTween1:Play()
end

function Library:HideActiveFunctions()
    self.ShowActiveFunctions = false
    self.ActiveFunctionsFrame.Visible = false
end

function Library:AddActiveFunction(name)
    if not table.find(self.ActiveFunctions, name) then
        table.insert(self.ActiveFunctions, name)
        self:UpdateActiveFunctions()
    end
end

function Library:RemoveActiveFunction(name)
    local index = table.find(self.ActiveFunctions, name)
    if index then
        table.remove(self.ActiveFunctions, index)
        self:UpdateActiveFunctions()
    end
end

function Library:UpdateActiveFunctions()
    if not self.ActiveFunctionsContent then return end
    
    -- Clear existing
    for _, child in pairs(self.ActiveFunctionsContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add active functions
    for i, func in pairs(self.ActiveFunctions) do
        local funcFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, -5, 0, 20),
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0
        }, self.ActiveFunctionsContent)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4)
        }, funcFrame)
        
        -- Status indicator
        CreateInstance("Frame", {
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(0, 8, 0.5, -3),
            BackgroundColor3 = Color3.fromRGB(0, 255, 0),
            BorderSizePixel = 0
        }, funcFrame)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0.5, 0)
        }, funcFrame:GetChildren()[2])
        
        -- Function name
        CreateInstance("TextLabel", {
            Size = UDim2.new(1, -25, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = func,
            TextColor3 = self.Theme.Text,
            TextSize = 11,
            Font = Enum.Font.Ubuntu,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, funcFrame)
    end
    
    -- Update canvas size
    self.ActiveFunctionsContent.CanvasSize = UDim2.new(0, 0, 0, #self.ActiveFunctions * 23)
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
            
            -- Update original size
            self.OriginalSize = UDim2.new(0, newWidth, 0, newHeight)
            
            Tween(self.MainFrame, {
                Size = self.OriginalSize
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

function Library:CreateSection(name)
    local section = {}
    section.Name = name
    section.Elements = {}
    
    -- Individual Section Button with its own background
    section.Button = CreateInstance("TextButton", {
        Name = name .. "Section",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.SectionBackground,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = ""
    }, self.SectionContainer)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, section.Button)
    
    -- Section Highlight (left line) with smooth animation
    section.Highlight = CreateInstance("Frame", {
        Name = "Highlight",
        Size = UDim2.new(0, 3, 0, 0), -- Start with 0 height
        Position = UDim2.new(0, 0, 0.5, 0), -- Start from center
        AnchorPoint = Vector2.new(0, 0.5),
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
    
    -- Cursor icon on the right side
    section.CursorIcon = CreateInstance("TextLabel", {
        Name = "CursorIcon",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -18, 0.5, -6),
        BackgroundTransparency = 1,
        Text = "👆",
        TextSize = 10,
        TextTransparency = 0.7
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
            Tween(section.Button, {BackgroundTransparency = 0.1}, 0.2)
        end
        Mouse.Icon = "rbxassetid://86509207249522"
    end)
    
    section.Button.MouseLeave:Connect(function()
        if self.CurrentSection ~= section then
            Tween(section.Label, {TextColor3 = self.Theme.TextDark}, 0.2)
            Tween(section.Button, {BackgroundTransparency = 0.3}, 0.2)
        end
        Mouse.Icon = ""
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
        Tween(s.Button, {BackgroundTransparency = 0.3}, 0.2)
        -- Animate highlight out
        Tween(s.Highlight, {
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0.5, 0)
        }, 0.3, Enum.EasingStyle.Quint)
    end
    
    section.Content.Visible = true
    section.Highlight.Visible = true
    Tween(section.Label, {TextColor3 = self.Theme.Text}, 0.2)
    Tween(section.Button, {BackgroundTransparency = 0.1}, 0.2)
    
    -- Animate highlight in smoothly
    Tween(section.Highlight, {
        Size = UDim2.new(0, 3, 1, -10),
        Position = UDim2.new(0, 0, 0, 5)
    }, 0.4, Enum.EasingStyle.Quint)
    
    self.CurrentSection = section
end

function Library:Minimize()
    self.Minimized = true
    Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
    if self.ShowActiveFunctions then
        Tween(self.ActiveFunctionsFrame, {Position = UDim2.new(1, 50, 0, 20)}, 0.3)
    end
    wait(0.3)
    self.MainFrame.Visible = false
    self.MinimizedFrame.Visible = true
    Tween(self.MinimizedFrame, {BackgroundTransparency = 0.3}, 0.2)
end

function Library:Restore()
    self.Minimized = false
    self.MinimizedFrame.Visible = false
    self.MainFrame.Visible = true
    -- Use stored original size instead of fixed size
    Tween(self.MainFrame, {Size = self.OriginalSize, BackgroundTransparency = 0.05}, 0.3)
    if self.ShowActiveFunctions then
        Tween(self.ActiveFunctionsFrame, {Position = UDim2.new(1, -220, 0, 20)}, 0.3)
    end
end

-- Enhanced UI Elements
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
        Size = UDim2.new(1, -25, 1, 0), -- Make room for cursor icon
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = config.Text or "Button",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu
    }, button.Frame)
    
    -- Cursor icon on the right side
    CreateInstance("TextLabel", {
        Name = "CursorIcon",
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -20, 0.5, -7.5),
        BackgroundTransparency = 1,
        Text = "👆",
        TextSize = 12,
        TextTransparency = 0.7
    }, button.Frame)
    
    button.Button.MouseEnter:Connect(function()
        Tween(button.Frame, {BackgroundTransparency = 0.3}, 0.2)
        Mouse.Icon = "rbxassetid://86509207249522"
    end)
    
    button.Button.MouseLeave:Connect(function()
        Tween(button.Frame, {BackgroundTransparency = 0.5}, 0.2)
        Mouse.Icon = ""
    end)
    
    button.Button.MouseButton1Click:Connect(function()
        -- No color change animation
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
        Size = UDim2.new(1, -70, 1, 0),
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
    
    -- Cursor icon on the right side
    CreateInstance("TextLabel", {
        Name = "CursorIcon",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, -6),
        BackgroundTransparency = 1,
        Text = "👆",
        TextSize = 10,
        TextTransparency = 0.7
    }, toggle.Frame)
    
    local function SetToggle(value)
        toggle.Enabled = value
        
        if toggle.Enabled then
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            Tween(toggle.Indicator, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2)
            self:AddActiveFunction(config.Text or "Toggle")
            if not self.ShowActiveFunctions then
                self:ShowActiveFunctions()
            end
        else
            Tween(toggle.Button, {BackgroundColor3 = self.Theme.Tertiary}, 0.2)
            Tween(toggle.Indicator, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2)
            self:RemoveActiveFunction(config.Text or "Toggle")
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
        Mouse.Icon = "rbxassetid://86509207249522"
    end)
    
    toggle.Frame.MouseLeave:Connect(function()
        Tween(toggle.Frame, {BackgroundTransparency = 0.5}, 0.2)
        Mouse.Icon = ""
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
        Size = UDim2.new(1, -35, 0, 4), -- Make room for cursor icon
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
    
    -- Cursor icon on the right side
    CreateInstance("TextLabel", {
        Name = "CursorIcon",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0, 33),
        BackgroundTransparency = 1,
        Text = "👆",
        TextSize = 10,
        TextTransparency = 0.7
    }, slider.Frame)
    
    local dragging = false
    
    local function UpdateSlider(input)
        local mousePos = UserInputService:GetMouseLocation()
        local relativePos = mousePos.X - slider.SliderFrame.AbsolutePosition.X
        local percentage = math.clamp(relativePos / slider.SliderFrame.AbsoluteSize.X, 0, 1)
        
        slider.Value = math.floor(slider.Min + (slider.Max - slider.Min) * percentage)
        slider.ValueLabel.Text = tostring(slider.Value)
        
        -- Smoother animation
        Tween(slider.Fill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.05, Enum.EasingStyle.Linear)
        Tween(slider.Knob, {Position = UDim2.new(percentage, -6, 0.5, -6)}, 0.05, Enum.EasingStyle.Linear)
        
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
        Mouse.Icon = "rbxassetid://86509207249522"
    end)
    
    slider.Frame.MouseLeave:Connect(function()
        Tween(slider.Frame, {BackgroundTransparency = 0.5}, 0.2)
        Mouse.Icon = ""
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
        Position = UDim2.new(0.35, 5, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
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
        Mouse.Icon = "rbxasset://SystemCursors/IBeam"
    end)
    
    input.Frame.MouseLeave:Connect(function()
        Tween(input.Frame, {BackgroundTransparency = 0.5}, 0.2)
        Mouse.Icon = ""
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
        Size = UDim2.new(0.65, -25, 0, 27), -- Make room for cursor icon
        Position = UDim2.new(0.35, 5, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = dropdown.Selected,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu,
        TextTruncate = Enum.TextTruncate.AtEnd
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
    
    -- Cursor icon on the right side
    CreateInstance("TextLabel", {
        Name = "CursorIcon",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, -6),
        BackgroundTransparency = 1,
        Text = "👆",
        TextSize = 10,
        TextTransparency = 0.7
    }, dropdown.Frame)
    
    -- Dropdown options container (no background container)
    dropdown.OptionContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(0.65, -10, 0, 0),
        Position = UDim2.new(0.35, 5, 0, 35),
        BackgroundTransparency = 1, -- Remove background
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = true
    }, dropdown.Frame)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3) -- Spacing between options
    }, dropdown.OptionContainer)
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 0),
        PaddingRight = UDim.new(0, 0)
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
                BackgroundColor3 = self.Theme.SectionBackground, -- Individual background
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Text = option,
                TextColor3 = self.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Ubuntu
            }, dropdown.OptionContainer)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4)
            }, optionButton)
            
            optionButton.MouseEnter:Connect(function()
                Tween(optionButton, {BackgroundTransparency = 0.1}, 0.2)
                Mouse.Icon = "rbxassetid://86509207249522"
            end)
            
            optionButton.MouseLeave:Connect(function()
                Tween(optionButton, {BackgroundTransparency = 0.3}, 0.2)
                Mouse.Icon = ""
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Selected = option
                dropdown.Button.Text = option
                dropdown.Open = false
                
                local optionCount = #dropdown.Options
                local maxHeight = math.min(optionCount * 25 + 9, 120) -- Account for spacing
                
                Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                Tween(dropdown.Arrow, {Rotation = 0}, 0.3)
                
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
            local maxHeight = math.min(optionCount * 25 + 9, 120) -- Account for spacing
            local newSize = 35 + maxHeight + 5
            
            dropdown.OptionContainer.Size = UDim2.new(0.65, -10, 0, maxHeight)
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, newSize)}, 0.3)
            Tween(dropdown.Arrow, {Rotation = 180}, 0.3)
        else
            Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
            Tween(dropdown.Arrow, {Rotation = 0}, 0.3)
        end
    end)
    
    dropdown.Frame.MouseEnter:Connect(function()
        Tween(dropdown.Frame, {BackgroundTransparency = 0.3}, 0.2)
        Mouse.Icon = "rbxassetid://86509207249522"
    end)
    
    dropdown.Frame.MouseLeave:Connect(function()
        Tween(dropdown.Frame, {BackgroundTransparency = 0.5}, 0.2)
        Mouse.Icon = ""
    end)
    
    return dropdown
end

function Library:CreateSearchBox(section, config)
    config = config or {}
    local search = {}
    search.Items = config.Items or {}
    search.FilteredItems = {}
    
    search.Frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, search.Frame)
    
    search.SearchBox = CreateInstance("TextBox", {
        Size = UDim2.new(1, -20, 0, 27),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Ubuntu,
        PlaceholderText = config.Placeholder or "Search...",
        PlaceholderColor3 = self.Theme.TextDark,
        ClearTextOnFocus = false
    }, search.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, search.SearchBox)
    
    search.Icon = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "🔍",
        TextColor3 = self.Theme.TextDark,
        TextSize = 12
    }, search.SearchBox)
    
    -- Results container (no background container)
    search.ResultsContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundTransparency = 1, -- Remove background
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = false
    }, search.Frame)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3) -- Spacing between results
    }, search.ResultsContainer)
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 0),
        PaddingRight = UDim.new(0, 0)
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
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundColor3 = self.Theme.SectionBackground, -- Individual background
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Text = item,
                TextColor3 = self.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Ubuntu
            }, search.ResultsContainer)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4)
            }, resultButton)
            
            resultButton.MouseEnter:Connect(function()
                Tween(resultButton, {BackgroundTransparency = 0.1}, 0.2)
                Mouse.Icon = "rbxassetid://86509207249522"
            end)
            
            resultButton.MouseLeave:Connect(function()
                Tween(resultButton, {BackgroundTransparency = 0.3}, 0.2)
                Mouse.Icon = ""
            end)
            
            resultButton.MouseButton1Click:Connect(function()
                search.SearchBox.Text = item
                search.ResultsContainer.Visible = false
                Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                
                if config.Callback then
                    config.Callback(item)
                end
            end)
        end
        
        if resultCount > 0 then
            local maxHeight = math.min(resultCount * 25 + 9, 120) -- Account for spacing
            local newSize = 35 + maxHeight + 5
            
            search.ResultsContainer.Visible = true
            search.ResultsContainer.Size = UDim2.new(1, -20, 0, maxHeight)
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, newSize)}, 0.3)
        else
            search.ResultsContainer.Visible = false
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
        end
    end
    
    search.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = search.SearchBox.Text:lower()
        search.FilteredItems = {}
        
        if searchText == "" then
            search.ResultsContainer.Visible = false
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
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
            Tween(search.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
        end
    end)
    
    search.Frame.MouseEnter:Connect(function()
        Tween(search.Frame, {BackgroundTransparency = 0.3}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/IBeam"
    end)
    
    search.Frame.MouseLeave:Connect(function()
        Tween(search.Frame, {BackgroundTransparency = 0.5}, 0.2)
        Mouse.Icon = ""
    end)
    
    return search
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

function Library:CreateSeparator(section)
    local separator = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, section.Content)
    
    return separator
end

function Library:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        
        -- Update main elements
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        self.EdgeGlow.ImageColor3 = self.Theme.Accent
        self.TopDivider.BackgroundColor3 = self.Theme.Border
        self.VerticalDivider.BackgroundColor3 = self.Theme.Border
        
        -- Update all existing elements
        for _, descendant in pairs(self.ScreenGui:GetDescendants()) do
            if descendant.Name == "Highlight" then
                descendant.BackgroundColor3 = self.Theme.SectionHighlight
            elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                if descendant.TextColor3 ~= self.Theme.TextDark then
                    descendant.TextColor3 = self.Theme.Text
                end
            elseif descendant:IsA("ScrollingFrame") then
                descendant.ScrollBarImageColor3 = self.Theme.Accent
            end
        end
    end
end

function Library:Notify(config)
    config = config or {}
    
    local notification = CreateInstance("Frame", {
        Size = UDim2.new(0, 250, 0, 70),
        Position = UDim2.new(1, 270, 1, -90),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, notification)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.5,
        Thickness = 1
    }, notification)
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Ubuntu
    }, notification)
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = config.Text or "Notification text",
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Font = Enum.Font.Ubuntu
    }, notification)
    
    -- Animate in
    Tween(notification, {Position = UDim2.new(1, -270, 1, -90)}, 0.5)
    
    -- Auto close
    spawn(function()
        wait(config.Duration or 3)
        
        -- Animate out
        Tween(notification, {Position = UDim2.new(1, 270, 1, -90)}, 0.5)
        wait(0.5)
        notification:Destroy()
    end)
end

function Library:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Library
