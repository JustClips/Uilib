local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local CoreGui = game:GetService('CoreGui')

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Mobile Detection
local IsMobile = UserInputService.TouchEnabled
    and not UserInputService.MouseEnabled

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
        SectionBackground = Color3.fromRGB(25, 25, 25),
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
        SectionBackground = Color3.fromRGB(250, 250, 250),
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
        SectionBackground = Color3.fromRGB(30, 25, 40),
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
        SectionBackground = Color3.fromRGB(20, 30, 40),
    },
}

-- Available Fonts
local Fonts = {
    Ubuntu = Enum.Font.Ubuntu,
    Gotham = Enum.Font.Gotham,
    GothamBold = Enum.Font.GothamBold,
    SourceSans = Enum.Font.SourceSans,
    SourceSansBold = Enum.Font.SourceSansBold,
    Code = Enum.Font.Code,
    Highway = Enum.Font.Highway,
    SciFi = Enum.Font.SciFi,
    Arial = Enum.Font.Arial,
    ArialBold = Enum.Font.ArialBold,
}

-- Available Backgrounds
local Backgrounds = {
    ['Blue Sky'] = 'rbxassetid://98784591713474',
    ['Mountains'] = 'rbxassetid://128738385973775',
    ['Blurred Stars'] = 'rbxassetid://83743690094319',
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
    local clickTime = 0
    local clickThreshold = 0.3

    -- Mobile Support
    handle.InputBegan:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            clickTime = tick()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                Tween(frame, {
                    Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    ),
                }, 0.1, Enum.EasingStyle.Linear)
            end
        end
    end)

    return clickTime, clickThreshold
end

-- Main Library Functions
function Library:Create(config)
    config = config or {}
    local self = setmetatable({}, Library)

    self.Theme = Themes[config.Theme or 'Ocean']
    self.Sections = {}
    self.CurrentSection = nil
    self.Minimized = false
    self.MinSize = Vector2.new(500, 400)
    self.MaxSize = Vector2.new(800, 600)
    self.OriginalSize = UDim2.new(0, 650, 0, 450)
    self.ActiveFunctions = {}
    self.UIVisible = true
    self.ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    self.ToggleDebounce = false
    self.CurrentBackground = config.Background or 'Blue Sky'
    self.SettingsOpen = false
    self.IgnoreNextMinimizedClick = false
    self.LastToggleTime = 0

    -- Customization Options
    self.ButtonDarkness = config.ButtonDarkness or 0.5
    self.StrokeThickness = config.StrokeThickness or 1
    self.Font = Fonts[config.Font] or Fonts.Ubuntu
    self.SectionHeaderEnabled = config.SectionHeaderEnabled ~= false
    self.SectionHeaderWhite = config.SectionHeaderWhite or false
    self.HideUISettings = config.HideUISettings or false

    -- Size Customization Options (New)
    self.ElementSizes = config.ElementSizes
        or {
            Button = 35,
            Toggle = 35,
            Slider = 55,
            Input = 35,
            Dropdown = 35,
            Label = 25,
            BigDropdown = 40,
            Spacing = 8,
        }

    -- Section Header Customization
    self.SectionHeaderConfig = config.SectionHeaderConfig
        or {
            Size = 22,
            Font = Enum.Font.GothamBold,
            Color = nil,
            Position = 'Center',
            UnderlineEnabled = true,
            UnderlineSize = 0.5,
            UnderlineThickness = 2,
        }

    -- Create ScreenGui
    self.ScreenGui = CreateInstance('ScreenGui', {
        Name = 'Eps1llonHub',
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true, -- Important for mobile
    }, CoreGui)

    -- Main Frame with transparency effect
    local screenSize = workspace.CurrentCamera.ViewportSize
    local frameSize = IsMobile
            and UDim2.new(
                0,
                math.min(screenSize.X * 0.9, 600),
                0,
                math.min(screenSize.Y * 0.8, 400)
            )
        or UDim2.new(0, 650, 0, 450)

    self.MainFrame = CreateInstance('Frame', {
        Name = 'MainFrame',
        Size = frameSize,
        Position = UDim2.new(
            0.5,
            -frameSize.X.Offset / 2,
            0.5,
            -frameSize.Y.Offset / 2
        ),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Active = true, -- Important for mobile
    }, self.ScreenGui)

    -- Add background image to main frame
    self.BackgroundImage = CreateInstance('ImageLabel', {
        Name = 'BackgroundImage',
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = Backgrounds[self.CurrentBackground],
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = -2,
    }, self.MainFrame)

    -- Add slight rounded corners
    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, self.MainFrame)

    -- Apply corner to background image too
    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, self.BackgroundImage)

    -- Edge glow effect (made shorter)
    self.EdgeGlow = CreateInstance('ImageLabel', {
        Name = 'EdgeGlow',
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png',
        ImageColor3 = self.Theme.Accent,
        ImageTransparency = 0.9,
        ZIndex = -1,
    }, self.MainFrame)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 10),
    }, self.EdgeGlow)

    -- Title Bar
    self.TitleBar = CreateInstance('Frame', {
        Name = 'TitleBar',
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, self.MainFrame)

    -- Title
    self.Title = CreateInstance('TextLabel', {
        Name = 'Title',
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = 'Eps1llon Hub',
        TextColor3 = self.Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, self.TitleBar)

    -- Close Button (X) - Made bigger
    self.CloseButton = CreateInstance('TextButton', {
        Name = 'CloseButton',
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -32, 0.5, -12.5),
        BackgroundTransparency = 1,
        Text = '×',
        TextColor3 = self.Theme.Text,
        TextSize = 26,
        Font = self.Font,
    }, self.TitleBar)

    self.CloseButton.MouseEnter:Connect(function()
        Tween(
            self.CloseButton,
            { TextColor3 = Color3.fromRGB(255, 100, 100) },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    self.CloseButton.MouseLeave:Connect(function()
        Tween(self.CloseButton, { TextColor3 = self.Theme.Text }, 0.2)
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    -- Minimize Button (-) - Moved left
    self.MinimizeButton = CreateInstance('TextButton', {
        Name = 'MinimizeButton',
        Size = UDim2.new(0, 20, 0, 18),
        Position = UDim2.new(1, -92, 0.5, -9),
        BackgroundTransparency = 1,
        Text = '—',
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        Font = self.Font,
    }, self.TitleBar)

    self.MinimizeButton.MouseEnter:Connect(function()
        Tween(self.MinimizeButton, { TextColor3 = self.Theme.Accent }, 0.2)
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    self.MinimizeButton.MouseLeave:Connect(function()
        Tween(self.MinimizeButton, { TextColor3 = self.Theme.Text }, 0.2)
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)

    -- UI Settings Button (Repositioned between - and X, made bigger)
    if not self.HideUISettings then
        self.SettingsButton = CreateInstance('ImageButton', {
            Name = 'SettingsButton',
            Size = UDim2.new(0, 24, 0, 24), -- Made bigger
            Position = UDim2.new(1, -62, 0.5, -12),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://109055678065801',
            ImageColor3 = self.Theme.Text,
            ImageTransparency = 0,
            ScaleType = Enum.ScaleType.Fit,
        }, self.TitleBar)

        self.SettingsButton.MouseEnter:Connect(function()
            Tween(self.SettingsButton, { ImageColor3 = self.Theme.Accent }, 0.2)
            if not IsMobile then
                Mouse.Icon = 'rbxasset://SystemCursors/Hand'
            end
        end)

        self.SettingsButton.MouseLeave:Connect(function()
            Tween(self.SettingsButton, { ImageColor3 = self.Theme.Text }, 0.2)
            if not IsMobile then
                Mouse.Icon = ''
            end
        end)

        self.SettingsButton.MouseButton1Click:Connect(function()
            self:ToggleSettingsPanel()
        end)
    end

    -- Top divider line (connects all the way)
    self.TopDivider = CreateInstance('Frame', {
        Name = 'TopDivider',
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, self.MainFrame)

    -- Left Section Container WITHOUT background (transparent)
    self.SectionContainer = CreateInstance('ScrollingFrame', {
        Name = 'SectionContainer',
        Size = UDim2.new(0, 150, 1, -45),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = IsMobile and 6 or 0, -- Visible scrollbar on mobile
        ScrollBarImageColor3 = self.Theme.Accent,
    }, self.MainFrame)

    self.SectionLayout = CreateInstance('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, self.ElementSizes.Spacing),
    }, self.SectionContainer)

    CreateInstance('UIPadding', {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
    }, self.SectionContainer)

    -- Vertical divider line (connects all the way)
    self.VerticalDivider = CreateInstance('Frame', {
        Name = 'VerticalDivider',
        Size = UDim2.new(0, 1, 1, -35),
        Position = UDim2.new(0, 170, 0, 35),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, self.MainFrame)

    -- Content Container
    self.ContentContainer = CreateInstance('Frame', {
        Name = 'ContentContainer',
        Size = UDim2.new(1, -190, 1, -50),
        Position = UDim2.new(0, 180, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, self.MainFrame)

    -- Create Settings Panel (Floating Panel)
    self:CreateSettingsPanel()

    -- Minimized Frame (Floating Square) - FIXED with proper dragging
    self.MinimizedFrame = CreateInstance('Frame', {
        Name = 'MinimizedFrame',
        Size = UDim2.new(0, 150, 0, 40),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 999,
        Active = true,
        Selectable = true,
    }, self.ScreenGui)

    -- Add background image to minimized frame (same as main frame)
    CreateInstance('ImageLabel', {
        Name = 'MinimizedBackgroundImage',
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = Backgrounds[self.CurrentBackground],
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 998,
    }, self.MinimizedFrame)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, self.MinimizedFrame)

    -- Apply corner to minimized background image too
    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, self.MinimizedFrame.MinimizedBackgroundImage)

    CreateInstance('UIStroke', {
        Color = self.Theme.Accent,
        Transparency = 0.3,
        Thickness = 1.5,
    }, self.MinimizedFrame)

    -- Add subtle glow effect to minimized frame
    local minimizedGlow = CreateInstance('ImageLabel', {
        Name = 'MinimizedGlow',
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png',
        ImageColor3 = self.Theme.Accent,
        ImageTransparency = 0.8,
        ZIndex = 997,
    }, self.MinimizedFrame)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 10),
    }, minimizedGlow)

    self.MinimizedTitle = CreateInstance('TextLabel', {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = 'Eps1llon Hub',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font,
        ZIndex = 1000,
    }, self.MinimizedFrame)

    -- Improved minimized frame dragging and clicking (with mobile support)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local clickStart = 0

    self.MinimizedFrame.InputBegan:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            dragStart = input.Position
            startPos = self.MinimizedFrame.Position
            clickStart = tick()
        end
    end)

    self.MinimizedFrame.InputEnded:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            local clickDuration = tick() - clickStart
            local dragDistance = (input.Position - dragStart).Magnitude

            if self.IgnoreNextMinimizedClick then return end

            -- Only restore if it was a quick click without much movement
            if clickDuration < 0.3 and dragDistance < 5 then
                self:ToggleUI()
            end

            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if
            dragging
            and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            )
        then
            local delta = input.Position - dragStart
            self.MinimizedFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    self.MinimizedFrame.MouseEnter:Connect(function()
        Tween(self.MinimizedFrame, { BackgroundTransparency = 0.05 }, 0.2)
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    self.MinimizedFrame.MouseLeave:Connect(function()
        Tween(self.MinimizedFrame, { BackgroundTransparency = 0.1 }, 0.2)
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    -- Create Active Functions Display
    self:CreateActiveFunctionsDisplay()

    -- Make main frame draggable
    AddDragging(self.MainFrame, self.TitleBar)

    -- Add resizing (disabled on mobile)
    if not IsMobile then
        self:AddResizing()
    end

    -- Setup toggle keybind with debounce (desktop only)
    if not IsMobile then
        self:SetupToggleKeybind()
    end

    return self
end

function Library:CreateButton(section, config)
    config = config or {}
    local button = {}

    button.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Button),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
    }, section.Content)

    -- Store original transparency
    button.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, button.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, button.Frame)
    end

    button.Button = CreateInstance('TextButton', {
        Size = UDim2.new(1, -30, 1, 0), -- Made room for click indicator
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = config.Text or 'Button',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font,
    }, button.Frame)

    -- Click Indicator (RBX Asset Pointer) - Always white
    button.ClickIndicator = CreateInstance('ImageLabel', {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -24, 0.5, -9),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://86509207249522',
        ImageColor3 = self.Theme.TextDark, -- Changed to TextDark
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Fit,
    }, button.Frame)

    button.ClickIndicator:SetAttribute('OriginalImageTransparency', 0.5)

    button.Button.MouseEnter:Connect(function()
        Tween(
            button.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        Tween(button.ClickIndicator, { ImageTransparency = 0.2 }, 0.2) -- Make it more visible on hover
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    button.Button.MouseLeave:Connect(function()
        Tween(
            button.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        Tween(button.ClickIndicator, { ImageTransparency = 0.5 }, 0.2) -- Slightly transparent when not hovered
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    button.Button.MouseButton1Click:Connect(function()
        -- Smoother click animation
        local originalColor = button.Frame.BackgroundColor3
        Tween(
            button.Frame,
            { BackgroundColor3 = self.Theme.Accent },
            0.15,
            Enum.EasingStyle.Sine
        )
        -- Animate click indicator
        Tween(button.ClickIndicator, {
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(1, -26, 0.5, -11),
        }, 0.15, Enum.EasingStyle.Sine)
        wait(0.15)
        Tween(
            button.Frame,
            { BackgroundColor3 = originalColor },
            0.15,
            Enum.EasingStyle.Sine
        )
        Tween(button.ClickIndicator, {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(1, -24, 0.5, -9),
        }, 0.15, Enum.EasingStyle.Sine)

        if config.Callback then
            config.Callback()
        end
    end)

    return button
end

-- NEW Rayfield-style BigDropdown (Fixed)
function Library:CreateBigDropdown(section, config)
    config = config or {}
    local bigDropdown = {}
    bigDropdown.Open = false
    bigDropdown.Elements = {}
    bigDropdown.FirstElement = nil

    -- Main container that will expand
    bigDropdown.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.BigDropdown),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, section.Content)

    -- Store original transparency
    bigDropdown.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, bigDropdown.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, bigDropdown.Frame)
    end

    -- Header container (the main pill that's always visible) - Fixed colors
    bigDropdown.HeaderContainer = CreateInstance('Frame', {
        Size = UDim2.new(1, -10, 0, 35),
        Position = UDim2.new(0, 5, 0, 2.5),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
    }, bigDropdown.Frame)

    bigDropdown.HeaderContainer:SetAttribute(
        'OriginalBackgroundTransparency',
        self.ButtonDarkness
    )

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, bigDropdown.HeaderContainer)

    -- Left side - Dropdown name
    bigDropdown.NameLabel = CreateInstance('TextLabel', {
        Size = UDim2.new(0.5, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or 'Dropdown',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, bigDropdown.HeaderContainer)

    -- Right side container for preview content
    bigDropdown.PreviewContainer = CreateInstance('Frame', {
        Size = UDim2.new(0.5, -10, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, bigDropdown.HeaderContainer)

    -- Preview text (will show first element info)
    bigDropdown.PreviewText = CreateInstance('TextLabel', {
        Size = UDim2.new(1, -25, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = 'Empty',
        TextColor3 = self.Theme.TextDark,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = self.Font,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, bigDropdown.PreviewContainer)

    -- Dropdown arrow
    bigDropdown.Arrow = CreateInstance('TextLabel', {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 0.5, -10),
        BackgroundTransparency = 1,
        Text = '▼',
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = self.Font,
        Rotation = 0,
    }, bigDropdown.PreviewContainer)

    -- Content container for dropdown elements - Fixed with proper background
    bigDropdown.ContentContainer = CreateInstance('ScrollingFrame', {
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 0, 42),
        BackgroundColor3 = self.Theme.Background, -- Added background color
        BackgroundTransparency = self.ButtonDarkness, -- Made slightly visible
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = true,
        ClipsDescendants = true,
    }, bigDropdown.Frame)

    bigDropdown.ContentContainer:SetAttribute(
        'OriginalBackgroundTransparency',
        self.ButtonDarkness
    )

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, bigDropdown.ContentContainer)

    CreateInstance('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
    }, bigDropdown.ContentContainer)

    CreateInstance('UIPadding', {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
    }, bigDropdown.ContentContainer)

    -- Update preview text function
    local function UpdatePreview()
        if bigDropdown.FirstElement then
            -- Check what type of element it is and update preview accordingly
            local elementType = bigDropdown.FirstElement.Type
            if
                elementType == 'Toggle'
                and bigDropdown.FirstElement.Enabled ~= nil
            then
                bigDropdown.PreviewText.Text = bigDropdown.FirstElement.Enabled
                        and 'Enabled'
                    or 'Disabled'
                bigDropdown.PreviewText.TextColor3 = bigDropdown.FirstElement.Enabled
                        and self.Theme.Accent
                    or self.Theme.TextDark
            elseif
                elementType == 'Slider' and bigDropdown.FirstElement.Value
            then
                bigDropdown.PreviewText.Text = tostring(
                    bigDropdown.FirstElement.Value
                )
                bigDropdown.PreviewText.TextColor3 = self.Theme.Text
            elseif
                elementType == 'Input' and bigDropdown.FirstElement.TextBox
            then
                local text = bigDropdown.FirstElement.TextBox.Text
                bigDropdown.PreviewText.Text = text ~= '' and text or 'Empty'
                bigDropdown.PreviewText.TextColor3 = text ~= ''
                        and self.Theme.Text
                    or self.Theme.TextDark
            elseif
                elementType == 'Dropdown' and bigDropdown.FirstElement.Selected
            then
                bigDropdown.PreviewText.Text = bigDropdown.FirstElement.Selected
                bigDropdown.PreviewText.TextColor3 = self.Theme.Text
            elseif
                elementType == 'Button' and bigDropdown.FirstElement.Button
            then
                bigDropdown.PreviewText.Text = bigDropdown.FirstElement.Button.Text or 'Button'
                bigDropdown.PreviewText.TextColor3 = self.Theme.Text
            elseif
                elementType == 'Label' and bigDropdown.FirstElement.Label
            then
                bigDropdown.PreviewText.Text = bigDropdown.FirstElement.Label.Text or 'Label'
                bigDropdown.PreviewText.TextColor3 = self.Theme.Text
            else
                bigDropdown.PreviewText.Text = '...'
                bigDropdown.PreviewText.TextColor3 = self.Theme.TextDark
            end
        else
            bigDropdown.PreviewText.Text = 'Empty'
            bigDropdown.PreviewText.TextColor3 = self.Theme.TextDark
        end
    end

    -- Methods to add elements to the big dropdown (fixed wrapper section)
    local wrapperSection = { Content = bigDropdown.ContentContainer }

    bigDropdown.AddToggle = function(toggleConfig)
        local toggle = self:CreateToggle(wrapperSection, toggleConfig)
        toggle.Type = 'Toggle'
        table.insert(bigDropdown.Elements, toggle)
        if not bigDropdown.FirstElement then
            bigDropdown.FirstElement = toggle
            UpdatePreview()
        end
        -- Update preview when toggle changes
        local originalCallback = toggleConfig.Callback
        local newCallback = function(value)
            if originalCallback then
                originalCallback(value)
            end
            if bigDropdown.FirstElement == toggle then
                UpdatePreview()
            end
        end
        toggle.Set(toggle.Enabled) -- Reapply with new callback
        return toggle
    end

    bigDropdown.AddSlider = function(sliderConfig)
        local slider = self:CreateSlider(wrapperSection, sliderConfig)
        slider.Type = 'Slider'
        table.insert(bigDropdown.Elements, slider)
        if not bigDropdown.FirstElement then
            bigDropdown.FirstElement = slider
            UpdatePreview()
        end
        return slider
    end

    bigDropdown.AddButton = function(buttonConfig)
        local button = self:CreateButton(wrapperSection, buttonConfig)
        button.Type = 'Button'
        table.insert(bigDropdown.Elements, button)
        if not bigDropdown.FirstElement then
            bigDropdown.FirstElement = button
            bigDropdown.PreviewText.Text = buttonConfig.Text or 'Button'
            bigDropdown.PreviewText.TextColor3 = self.Theme.Text
        end
        return button
    end

    bigDropdown.AddInput = function(inputConfig)
        local input = self:CreateInput(wrapperSection, inputConfig)
        input.Type = 'Input'
        table.insert(bigDropdown.Elements, input)
        if not bigDropdown.FirstElement then
            bigDropdown.FirstElement = input
            UpdatePreview()
        end
        -- Update preview when input changes
        input.TextBox:GetPropertyChangedSignal('Text'):Connect(function()
            if bigDropdown.FirstElement == input then
                UpdatePreview()
            end
        end)
        return input
    end

    bigDropdown.AddLabel = function(labelConfig)
        local label = self:CreateLabel(wrapperSection, labelConfig)
        label.Type = 'Label'
        table.insert(bigDropdown.Elements, label)
        if not bigDropdown.FirstElement then
            bigDropdown.FirstElement = label
            bigDropdown.PreviewText.Text = labelConfig.Text or 'Label'
            bigDropdown.PreviewText.TextColor3 = labelConfig.Color
                or self.Theme.Text
        end
        return label
    end

    bigDropdown.AddDropdown = function(dropdownConfig)
        local dropdown = self:CreateDropdown(wrapperSection, dropdownConfig)
        dropdown.Type = 'Dropdown'
        table.insert(bigDropdown.Elements, dropdown)
        if not bigDropdown.FirstElement then
            bigDropdown.FirstElement = dropdown
            UpdatePreview()
        end
        return dropdown
    end

    bigDropdown.AddSeparator = function()
        local separator = self:CreateSeparator(wrapperSection)
        table.insert(bigDropdown.Elements, separator)
        return separator
    end

    -- Update content size
    local function UpdateContentSize()
        local contentHeight = 0
        for _, child in pairs(bigDropdown.ContentContainer:GetChildren()) do
            if
                child:IsA('GuiObject')
                and not child:IsA('UIListLayout')
                and not child:IsA('UIPadding')
            then
                contentHeight = contentHeight + child.AbsoluteSize.Y + 5
            end
        end
        contentHeight = math.min(contentHeight + 10, 300) -- Max height of 300

        if bigDropdown.Open then
            Tween(
                bigDropdown.ContentContainer,
                { Size = UDim2.new(1, -10, 0, contentHeight) },
                0.3,
                Enum.EasingStyle.Back
            )
            Tween(
                bigDropdown.Frame,
                { Size = UDim2.new(1, 0, 0, 47 + contentHeight) },
                0.3,
                Enum.EasingStyle.Back
            )
        end
    end

    -- Toggle dropdown (clicking the header) - with mobile support
    bigDropdown.HeaderContainer.InputBegan:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            bigDropdown.Open = not bigDropdown.Open

            if bigDropdown.Open then
                UpdateContentSize()
                Tween(
                    bigDropdown.Arrow,
                    { Rotation = 180 },
                    0.3,
                    Enum.EasingStyle.Back
                )
                -- Show elements with fade effect
                for i, element in ipairs(bigDropdown.Elements) do
                    if element.Frame then
                        element.Frame.BackgroundTransparency = 1
                        spawn(function()
                            wait(i * 0.03)
                            Tween(element.Frame, {
                                BackgroundTransparency = element.Frame:GetAttribute(
                                    'OriginalTransparency'
                                )
                                    or self.ButtonDarkness,
                            }, 0.2)
                        end)
                    end
                end
            else
                Tween(
                    bigDropdown.ContentContainer,
                    { Size = UDim2.new(1, -10, 0, 0) },
                    0.3,
                    Enum.EasingStyle.Back
                )
                Tween(
                    bigDropdown.Frame,
                    { Size = UDim2.new(1, 0, 0, self.ElementSizes.BigDropdown) },
                    0.3,
                    Enum.EasingStyle.Back
                )
                Tween(
                    bigDropdown.Arrow,
                    { Rotation = 0 },
                    0.3,
                    Enum.EasingStyle.Back
                )
            end
        end
    end)

    bigDropdown.HeaderContainer.MouseEnter:Connect(function()
        Tween(
            bigDropdown.HeaderContainer,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    bigDropdown.HeaderContainer.MouseLeave:Connect(function()
        Tween(
            bigDropdown.HeaderContainer,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    bigDropdown.Frame.MouseEnter:Connect(function()
        Tween(
            bigDropdown.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
    end)

    bigDropdown.Frame.MouseLeave:Connect(function()
        Tween(
            bigDropdown.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
    end)

    -- Call the creation callback if provided
    if config.CreateElements then
        config.CreateElements(bigDropdown)
        UpdateContentSize()
        UpdatePreview()
    end

    return bigDropdown
end

-- Add remaining methods (CreateToggle, CreateSlider, etc.) with size customization...
-- I'll include the key ones with the size changes:

function Library:CreateToggle(section, config)
    config = config or {}
    local toggle = {}
    toggle.Enabled = config.Default or false

    toggle.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Toggle),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
    }, section.Content)

    -- Store original transparency
    toggle.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, toggle.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, toggle.Frame)
    end

    toggle.Label = CreateInstance('TextLabel', {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or 'Toggle',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, toggle.Frame)

    -- Toggle background with smooth animation
    toggle.Button = CreateInstance('TextButton', {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -46, 0.5, -9),
        BackgroundColor3 = toggle.Enabled and self.Theme.Accent
            or self.Theme.Tertiary,
        BorderSizePixel = 0,
        Text = '',
    }, toggle.Frame)

    toggle.Button:SetAttribute('OriginalBackgroundTransparency', 0)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0.5, 0),
    }, toggle.Button)

    -- Toggle indicator with smooth animation
    toggle.Indicator = CreateInstance('Frame', {
        Size = UDim2.new(0, 14, 0, 14),
        Position = toggle.Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(
            0,
            2,
            0.5,
            -7
        ),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0,
    }, toggle.Button)

    toggle.Indicator:SetAttribute('OriginalBackgroundTransparency', 0)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0.5, 0),
    }, toggle.Indicator)

    -- Add shadow for depth effect
    local shadow = CreateInstance('Frame', {
        Size = UDim2.new(0, 12, 0, 12),
        Position = toggle.Enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(
            0,
            3,
            0.5,
            -6
        ),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        ZIndex = toggle.Indicator.ZIndex - 1,
    }, toggle.Button)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0.5, 0),
    }, shadow)

    local function SetToggle(value)
        toggle.Enabled = value

        if toggle.Enabled then
            -- Smooth color transition
            Tween(
                toggle.Button,
                { BackgroundColor3 = self.Theme.Accent },
                0.3,
                Enum.EasingStyle.Quart
            )
            -- Smooth position transition with bounce
            Tween(
                toggle.Indicator,
                { Position = UDim2.new(1, -16, 0.5, -7) },
                0.3,
                Enum.EasingStyle.Back
            )
            Tween(
                shadow,
                { Position = UDim2.new(1, -15, 0.5, -6) },
                0.3,
                Enum.EasingStyle.Back
            )
            self:AddActiveFunction(config.Text or 'Toggle')
        else
            Tween(
                toggle.Button,
                { BackgroundColor3 = self.Theme.Tertiary },
                0.3,
                Enum.EasingStyle.Quart
            )
            Tween(
                toggle.Indicator,
                { Position = UDim2.new(0, 2, 0.5, -7) },
                0.3,
                Enum.EasingStyle.Back
            )
            Tween(
                shadow,
                { Position = UDim2.new(0, 3, 0.5, -6) },
                0.3,
                Enum.EasingStyle.Back
            )
            self:RemoveActiveFunction(config.Text or 'Toggle')
        end

        if config.Callback then
            config.Callback(toggle.Enabled)
        end
    end

    toggle.Button.MouseButton1Click:Connect(function()
        SetToggle(not toggle.Enabled)
    end)

    toggle.Frame.MouseEnter:Connect(function()
        Tween(
            toggle.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        -- Scale up toggle slightly on hover
        Tween(toggle.Button, {
            Size = UDim2.new(0, 38, 0, 20),
            Position = UDim2.new(1, -47, 0.5, -10),
        }, 0.2)
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    toggle.Frame.MouseLeave:Connect(function()
        Tween(
            toggle.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        -- Scale back to normal
        Tween(toggle.Button, {
            Size = UDim2.new(0, 36, 0, 18),
            Position = UDim2.new(1, -46, 0.5, -9),
        }, 0.2)
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    toggle.Set = SetToggle

    -- Initialize if default is true
    if toggle.Enabled then
        self:AddActiveFunction(config.Text or 'Toggle')
    end

    return toggle
end

function Library:CreateSlider(section, config)
    config = config or {}
    local slider = {}
    slider.Min = config.Min or 0
    slider.Max = config.Max or 100
    slider.Value = config.Default or slider.Min

    slider.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Slider),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
    }, section.Content)

    -- Store original transparency
    slider.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, slider.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, slider.Frame)
    end

    slider.Label = CreateInstance('TextLabel', {
        Size = UDim2.new(1, -70, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Text or 'Slider',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, slider.Frame)

    slider.ValueLabel = CreateInstance('TextLabel', {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -60, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(slider.Value),
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font,
    }, slider.Frame)

    slider.SliderFrame = CreateInstance('Frame', {
        Size = UDim2.new(1, -20, 0, 4),
        Position = UDim2.new(0, 10, 0, 33),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0,
    }, slider.Frame)

    slider.SliderFrame:SetAttribute('OriginalBackgroundTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0.5, 0),
    }, slider.SliderFrame)

    slider.Fill = CreateInstance('Frame', {
        Size = UDim2.new(
            (slider.Value - slider.Min) / (slider.Max - slider.Min),
            0,
            1,
            0
        ),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
    }, slider.SliderFrame)

    slider.Fill:SetAttribute('OriginalBackgroundTransparency', 0)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0.5, 0),
    }, slider.Fill)

    slider.Knob = CreateInstance('Frame', {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(
            (slider.Value - slider.Min) / (slider.Max - slider.Min),
            -6,
            0.5,
            -6
        ),
        BackgroundColor3 = self.Theme.Text,
        BorderSizePixel = 0,
    }, slider.SliderFrame)

    slider.Knob:SetAttribute('OriginalBackgroundTransparency', 0)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0.5, 0),
    }, slider.Knob)

    local dragging = false

    local function UpdateSlider(input)
        local mousePos = IsMobile and input.Position
            or UserInputService:GetMouseLocation()
        local relativePos = mousePos.X - slider.SliderFrame.AbsolutePosition.X
        local percentage = math.clamp(
            relativePos / slider.SliderFrame.AbsoluteSize.X,
            0,
            1
        )

        slider.Value = math.floor(
            slider.Min + (slider.Max - slider.Min) * percentage
        )
        slider.ValueLabel.Text = tostring(slider.Value)

        -- Smooth tweening for slider components
        Tween(
            slider.Fill,
            { Size = UDim2.new(percentage, 0, 1, 0) },
            0.1,
            Enum.EasingStyle.Quad
        )
        Tween(
            slider.Knob,
            { Position = UDim2.new(percentage, -6, 0.5, -6) },
            0.1,
            Enum.EasingStyle.Quad
        )

        if config.Callback then
            config.Callback(slider.Value)
        end
    end

    slider.SliderFrame.InputBegan:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            UpdateSlider(input)
        end
    end)

    slider.Knob.InputBegan:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = false
        end
    end)

    -- Use RunService for ultra-smooth dragging
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if dragging then
            UpdateSlider()
        end
    end)

    -- Clean up connection when UI is destroyed
    slider.Frame.AncestryChanged:Connect(function()
        if not slider.Frame.Parent then
            connection:Disconnect()
        end
    end)

    slider.Frame.MouseEnter:Connect(function()
        Tween(
            slider.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    slider.Frame.MouseLeave:Connect(function()
        Tween(
            slider.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        if not dragging and not IsMobile then
            Mouse.Icon = ''
        end
    end)

    return slider
end

function Library:CreateInput(section, config)
    config = config or {}
    local input = {}

    input.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Input),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
    }, section.Content)

    -- Store original transparency
    input.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, input.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, input.Frame)
    end

    input.Label = CreateInstance('TextLabel', {
        Size = UDim2.new(0.35, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or 'Input',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, input.Frame)

    input.TextBox = CreateInstance('TextBox', {
        Size = UDim2.new(0.65, -10, 1, -8),
        Position = UDim2.new(0.35, 5, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        Text = config.Default or '',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font,
        PlaceholderText = config.Placeholder or 'Enter text...',
        PlaceholderColor3 = self.Theme.TextDark,
        ClearTextOnFocus = false,
    }, input.Frame)

    input.TextBox:SetAttribute('OriginalBackgroundTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 4),
    }, input.TextBox)

    input.TextBox.FocusLost:Connect(function(enterPressed)
        if config.Callback then
            config.Callback(input.TextBox.Text, enterPressed)
        end
    end)

    input.Frame.MouseEnter:Connect(function()
        Tween(
            input.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/IBeam'
        end
    end)

    input.Frame.MouseLeave:Connect(function()
        Tween(
            input.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    return input
end

function Library:CreateDropdown(section, config)
    config = config or {}
    local dropdown = {}
    dropdown.Options = config.Options or {}
    dropdown.Selected = config.Default or (dropdown.Options[1] or 'None')
    dropdown.Open = false

    dropdown.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Dropdown),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, section.Content)

    -- Store original transparency
    dropdown.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, dropdown.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, dropdown.Frame)
    end

    dropdown.Label = CreateInstance('TextLabel', {
        Size = UDim2.new(0.35, -10, 0, self.ElementSizes.Dropdown),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or 'Dropdown',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, dropdown.Frame)

    dropdown.Button = CreateInstance('TextButton', {
        Size = UDim2.new(0.65, -10, 0, 27),
        Position = UDim2.new(0.35, 5, 0, 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = dropdown.Selected,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, dropdown.Frame)

    CreateInstance('UIStroke', {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness,
    }, dropdown.Button)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 4),
    }, dropdown.Button)

    dropdown.Arrow = CreateInstance('TextLabel', {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = '▼',
        TextColor3 = self.Theme.Text,
        TextSize = 10,
        Font = self.Font,
    }, dropdown.Button)

    dropdown.OptionContainer = CreateInstance('ScrollingFrame', {
        Size = UDim2.new(0.65, -10, 0, 0),
        Position = UDim2.new(0.35, 5, 0, self.ElementSizes.Dropdown),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = true,
    }, dropdown.Frame)

    dropdown.OptionContainer:SetAttribute('OriginalBackgroundTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, dropdown.OptionContainer)

    CreateInstance('UIStroke', {
        Color = self.Theme.Accent,
        Transparency = 0.7,
        Thickness = self.StrokeThickness,
    }, dropdown.OptionContainer)

    CreateInstance('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    }, dropdown.OptionContainer)

    CreateInstance('UIPadding', {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
    }, dropdown.OptionContainer)

    local function UpdateOptions()
        for _, child in pairs(dropdown.OptionContainer:GetChildren()) do
            if child:IsA('TextButton') then
                child:Destroy()
            end
        end

        for _, option in pairs(dropdown.Options) do
            local optionButton = CreateInstance('TextButton', {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = option,
                TextColor3 = self.Theme.Text,
                TextSize = 13,
                Font = self.Font,
            }, dropdown.OptionContainer)

            CreateInstance('UICorner', {
                CornerRadius = UDim.new(0, 3),
            }, optionButton)

            local highlightFrame = CreateInstance('Frame', {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = self.Theme.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = optionButton.ZIndex - 1,
            }, optionButton)

            highlightFrame:SetAttribute('OriginalBackgroundTransparency', 1)

            CreateInstance('UICorner', {
                CornerRadius = UDim.new(0, 3),
            }, highlightFrame)

            optionButton.MouseEnter:Connect(function()
                Tween(highlightFrame, { BackgroundTransparency = 0.8 }, 0.2)
                if not IsMobile then
                    Mouse.Icon = 'rbxasset://SystemCursors/Hand'
                end
            end)

            optionButton.MouseLeave:Connect(function()
                Tween(highlightFrame, { BackgroundTransparency = 1 }, 0.2)
                if not IsMobile then
                    Mouse.Icon = ''
                end
            end)

            optionButton.MouseButton1Click:Connect(function()
                dropdown.Selected = option
                dropdown.Button.Text = option
                dropdown.Open = false

                local optionCount = #dropdown.Options
                local maxHeight = math.min(optionCount * 24 + 6, 120)

                Tween(
                    dropdown.Frame,
                    { Size = UDim2.new(1, 0, 0, self.ElementSizes.Dropdown) },
                    0.3,
                    Enum.EasingStyle.Back
                )
                Tween(
                    dropdown.Arrow,
                    { Rotation = 0 },
                    0.3,
                    Enum.EasingStyle.Back
                )

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
            local maxHeight = math.min(optionCount * 24 + 6, 120)
            local newSize = self.ElementSizes.Dropdown + maxHeight + 5

            dropdown.OptionContainer.Size = UDim2.new(0.65, -10, 0, maxHeight)
            Tween(
                dropdown.Frame,
                { Size = UDim2.new(1, 0, 0, newSize) },
                0.4,
                Enum.EasingStyle.Back
            )
            Tween(
                dropdown.Arrow,
                { Rotation = 180 },
                0.3,
                Enum.EasingStyle.Back
            )
        else
            Tween(
                dropdown.Frame,
                { Size = UDim2.new(1, 0, 0, self.ElementSizes.Dropdown) },
                0.3,
                Enum.EasingStyle.Back
            )
            Tween(dropdown.Arrow, { Rotation = 0 }, 0.3, Enum.EasingStyle.Back)
        end
    end)

    dropdown.Frame.MouseEnter:Connect(function()
        Tween(
            dropdown.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    dropdown.Frame.MouseLeave:Connect(function()
        Tween(
            dropdown.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    return dropdown
end

function Library:CreateLabel(section, config)
    config = config or {}
    local label = {}

    label.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Label),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness + 0.2,
        BorderSizePixel = 0,
    }, section.Content)

    -- Store original transparency
    label.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness + 0.2)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, label.Frame)

    label.Label = CreateInstance('TextLabel', {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or 'Label',
        TextColor3 = config.Color or self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, label.Frame)

    return label
end

function Library:CreateSeparator(section)
    local separator = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, section.Content)

    -- Store original transparency
    separator:SetAttribute('OriginalTransparency', 0.5)

    return separator
end

function Library:CreateKeybind(section, config)
    config = config or {}
    local keybind = {}
    keybind.Key = config.Default or Enum.KeyCode.F
    keybind.Enabled = false

    keybind.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Button),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
    }, section.Content)

    -- Store original transparency
    keybind.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, keybind.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, keybind.Frame)
    end

    keybind.Label = CreateInstance('TextLabel', {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or 'Keybind',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, keybind.Frame)

    keybind.KeyLabel = CreateInstance('TextLabel', {
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -70, 0, 0),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        Text = keybind.Key.Name,
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = self.Font,
    }, keybind.Frame)

    keybind.KeyLabel:SetAttribute('OriginalBackgroundTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 4),
    }, keybind.KeyLabel)

    -- Add to active functions when created
    self:AddActiveFunction(config.Text or 'Keybind')

    -- Handle key press
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == keybind.Key then
            if config.Callback then
                config.Callback()
            end
        end
    end)

    keybind.Frame.MouseEnter:Connect(function()
        Tween(
            keybind.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    keybind.Frame.MouseLeave:Connect(function()
        Tween(
            keybind.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    return keybind
end

function Library:CreateSearchBox(section, config)
    config = config or {}
    local search = {}
    search.Items = config.Items or {}
    search.FilteredItems = {}
    search.SelectedCallback = config.OnSelected
    search.SearchCallback = config.OnSearch

    search.Frame = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, self.ElementSizes.Input),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, section.Content)

    -- Store original transparency
    search.Frame:SetAttribute('OriginalTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, search.Frame)

    -- Add stroke if thickness > 0
    if self.StrokeThickness > 0 then
        CreateInstance('UIStroke', {
            Color = self.Theme.Border,
            Transparency = 0.7,
            Thickness = self.StrokeThickness,
        }, search.Frame)
    end

    search.SearchBox = CreateInstance('TextBox', {
        Size = UDim2.new(1, -20, 0, 27),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        Text = '',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font,
        PlaceholderText = config.Placeholder or 'Search...',
        PlaceholderColor3 = self.Theme.TextDark,
        ClearTextOnFocus = false,
    }, search.Frame)

    search.SearchBox:SetAttribute('OriginalBackgroundTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 4),
    }, search.SearchBox)

    search.Icon = CreateInstance('TextLabel', {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Text = '🔍',
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
    }, search.SearchBox)

    search.ResultsContainer = CreateInstance('ScrollingFrame', {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, self.ElementSizes.Input),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = self.ButtonDarkness,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = false,
    }, search.Frame)

    search.ResultsContainer:SetAttribute('OriginalBackgroundTransparency', self.ButtonDarkness)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 4),
    }, search.ResultsContainer)

    CreateInstance('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    }, search.ResultsContainer)

    CreateInstance('UIPadding', {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
    }, search.ResultsContainer)

    -- Method to update items dynamically
    search.UpdateItems = function(newItems)
        search.Items = newItems
        if search.SearchBox.Text ~= '' then
            search.SearchBox.Text = ''
        end
    end

    local function UpdateResults()
        for _, child in pairs(search.ResultsContainer:GetChildren()) do
            if child:IsA('TextButton') then
                child:Destroy()
            end
        end

        local resultCount = 0
        for _, item in pairs(search.FilteredItems) do
            resultCount = resultCount + 1

            local resultButton = CreateInstance('TextButton', {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundColor3 = self.Theme.Secondary,
                BackgroundTransparency = self.ButtonDarkness,
                BorderSizePixel = 0,
                Text = item,
                TextColor3 = self.Theme.Text,
                TextSize = 13,
                Font = self.Font,
            }, search.ResultsContainer)

            resultButton:SetAttribute(
                'OriginalBackgroundTransparency',
                self.ButtonDarkness
            )

            CreateInstance('UICorner', {
                CornerRadius = UDim.new(0, 3),
            }, resultButton)

            resultButton.MouseEnter:Connect(function()
                Tween(
                    resultButton,
                    { BackgroundTransparency = self.ButtonDarkness - 0.3 },
                    0.2
                )
                if not IsMobile then
                    Mouse.Icon = 'rbxasset://SystemCursors/Hand'
                end
            end)

            resultButton.MouseLeave:Connect(function()
                Tween(
                    resultButton,
                    { BackgroundTransparency = self.ButtonDarkness },
                    0.2
                )
                if not IsMobile then
                    Mouse.Icon = ''
                end
            end)

            resultButton.MouseButton1Click:Connect(function()
                search.SearchBox.Text = item
                search.ResultsContainer.Visible = false
                Tween(
                    search.Frame,
                    { Size = UDim2.new(1, 0, 0, self.ElementSizes.Input) },
                    0.3,
                    Enum.EasingStyle.Back
                )

                if search.SelectedCallback then
                    search.SelectedCallback(item)
                end
            end)
        end

        if resultCount > 0 then
            local maxHeight = math.min(resultCount * 24 + 6, 120)
            local newSize = self.ElementSizes.Input + maxHeight + 5

            search.ResultsContainer.Visible = true
            search.ResultsContainer.Size = UDim2.new(1, -20, 0, maxHeight)
            Tween(
                search.Frame,
                { Size = UDim2.new(1, 0, 0, newSize) },
                0.4,
                Enum.EasingStyle.Back
            )
        else
            search.ResultsContainer.Visible = false
            Tween(
                search.Frame,
                { Size = UDim2.new(1, 0, 0, self.ElementSizes.Input) },
                0.3,
                Enum.EasingStyle.Back
            )
        end
    end

    search.SearchBox:GetPropertyChangedSignal('Text'):Connect(function()
        local searchText = search.SearchBox.Text:lower()
        search.FilteredItems = {}

        if searchText == '' then
            search.ResultsContainer.Visible = false
            Tween(
                search.Frame,
                { Size = UDim2.new(1, 0, 0, self.ElementSizes.Input) },
                0.3,
                Enum.EasingStyle.Back
            )
        else
            -- Call search callback if provided
            if search.SearchCallback then
                search.FilteredItems = search.SearchCallback(
                    searchText,
                    search.Items
                )
            else
                -- Default search behavior
                for _, item in pairs(search.Items) do
                    if tostring(item):lower():find(searchText) then
                        table.insert(search.FilteredItems, item)
                    end
                end
            end
            UpdateResults()
        end
    end)

    search.SearchBox.FocusLost:Connect(function()
        wait(0.1)
        if search.SearchBox.Text == '' then
            search.ResultsContainer.Visible = false
            Tween(
                search.Frame,
                { Size = UDim2.new(1, 0, 0, self.ElementSizes.Input) },
                0.3,
                Enum.EasingStyle.Back
            )
        end
    end)

    search.Frame.MouseEnter:Connect(function()
        Tween(
            search.Frame,
            { BackgroundTransparency = self.ButtonDarkness - 0.2 },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/IBeam'
        end
    end)

    search.Frame.MouseLeave:Connect(function()
        Tween(
            search.Frame,
            { BackgroundTransparency = self.ButtonDarkness },
            0.2
        )
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    return search
end

function Library:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]

        -- Update main elements
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        self.EdgeGlow.ImageColor3 = self.Theme.Accent
        self.TopDivider.BackgroundColor3 = self.Theme.Border
        self.VerticalDivider.BackgroundColor3 = self.Theme.Border
        self.MinimizedFrame.BackgroundColor3 = self.Theme.Background
        self.SettingsPanel.BackgroundColor3 = self.Theme.Background

        -- Update all existing elements
        for _, descendant in pairs(self.ScreenGui:GetDescendants()) do
            if descendant.Name == 'Highlight' then
                descendant.BackgroundColor3 = self.Theme.SectionHighlight
            elseif descendant.Name == 'SectionHeader' then
                if
                    not self.SectionHeaderWhite
                    and not descendant.Parent.Parent.CustomColor
                then
                    descendant.TextColor3 = self.Theme.Accent
                end
            elseif
                descendant:IsA('TextLabel')
                or descendant:IsA('TextButton')
                or descendant:IsA('TextBox')
            then
                if descendant.TextColor3 ~= self.Theme.TextDark then
                    descendant.TextColor3 = self.Theme.Text
                end
            elseif descendant:IsA('ScrollingFrame') then
                descendant.ScrollBarImageColor3 = self.Theme.Accent
            elseif descendant:IsA('UIStroke') then
                if
                    descendant.Color == self.Theme.Border
                    or descendant.Transparency > 0.5
                then
                    descendant.Color = self.Theme.Border
                else
                    descendant.Color = self.Theme.Accent
                end
            end
        end
    end
end

-- Methods to change customization settings
function Library:SetButtonDarkness(darkness)
    self.ButtonDarkness = math.clamp(darkness, 0, 1)
    -- Update all existing buttons
    for _, descendant in pairs(self.ScreenGui:GetDescendants()) do
        if
            descendant:IsA('Frame')
            and descendant:GetAttribute('OriginalTransparency')
        then
            local newTransparency = self.ButtonDarkness
            -- Special handling for labels and other elements with different base transparency
            if
                descendant.Parent
                and descendant.Parent:IsA('Frame')
                and descendant.Parent.Name:find('Label')
            then
                newTransparency = self.ButtonDarkness + 0.2
            end
            descendant.BackgroundTransparency = newTransparency
            descendant:SetAttribute('OriginalTransparency', newTransparency)
        end
    end
end

function Library:SetStrokeThickness(thickness)
    self.StrokeThickness = math.clamp(thickness, 0, 5)
    -- Update all existing strokes
    for _, descendant in pairs(self.ScreenGui:GetDescendants()) do
        if descendant:IsA('UIStroke') then
            descendant.Thickness = self.StrokeThickness
        end
    end
end

function Library:SetFont(fontName)
    if Fonts[fontName] then
        self.Font = Fonts[fontName]
        -- Update all text elements
        for _, descendant in pairs(self.ScreenGui:GetDescendants()) do
            if
                descendant:IsA('TextLabel')
                or descendant:IsA('TextButton')
                or descendant:IsA('TextBox')
            then
                descendant.Font = self.Font
            end
        end
    end
end

function Library:SetToggleKey(keyCode)
    self.ToggleKey = keyCode
end

function Library:Notify(config)
    config = config or {}

    local notification = CreateInstance('Frame', {
        Size = UDim2.new(0, 250, 0, 70),
        Position = UDim2.new(1, 270, 1, -90),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
    }, self.ScreenGui)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, notification)

    CreateInstance('UIStroke', {
        Color = self.Theme.Accent,
        Transparency = 0.5,
        Thickness = self.StrokeThickness,
    }, notification)

    CreateInstance('TextLabel', {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = config.Title or 'Notification',
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, notification)

    CreateInstance('TextLabel', {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = config.Text or 'Notification text',
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Font = self.Font,
    }, notification)

    -- Animate in
    Tween(notification, { Position = UDim2.new(1, -270, 1, -90) }, 0.5)

    -- Auto close
    spawn(function()
        wait(config.Duration or 3)

        -- Animate out
        Tween(notification, { Position = UDim2.new(1, 270, 1, -90) }, 0.5)
        wait(0.5)
        notification:Destroy()
    end)
end

function Library:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- New Settings Panel (Floating)
function Library:CreateSettingsPanel()
    self.SettingsPanel = CreateInstance('Frame', {
        Name = 'SettingsPanel',
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.5, -150, 0.5, -200),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 1000,
    }, self.ScreenGui)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, self.SettingsPanel)

    CreateInstance('UIStroke', {
        Color = self.Theme.Accent,
        Transparency = 0.5,
        Thickness = 2,
    }, self.SettingsPanel)

    -- Add background image to settings panel (same as main UI)
    CreateInstance('ImageLabel', {
        Name = 'SettingsBackgroundImage',
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = Backgrounds[self.CurrentBackground],
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = -2,
    }, self.SettingsPanel)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, self.SettingsPanel.SettingsBackgroundImage)

    -- Settings Title Bar
    local settingsTitleBar = CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, self.SettingsPanel)

    CreateInstance('TextLabel', {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = 'UI Settings',
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, settingsTitleBar)

    -- Close button for settings
    local settingsClose = CreateInstance('TextButton', {
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0.5, -12.5),
        BackgroundTransparency = 1,
        Text = '×',
        TextColor3 = self.Theme.Text,
        TextSize = 24,
        Font = self.Font,
    }, settingsTitleBar)

    settingsClose.MouseButton1Click:Connect(function()
        self:ToggleSettingsPanel()
    end)

    -- Settings divider
    CreateInstance('Frame', {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, self.SettingsPanel)

    -- Settings content
    self.SettingsContent = CreateInstance('ScrollingFrame', {
        Size = UDim2.new(1, -20, 1, -45),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
    }, self.SettingsPanel)

    CreateInstance('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    }, self.SettingsContent)

    -- Create settings section
    local settingsSection = { Content = self.SettingsContent }

    -- Add all UI settings to the panel
    self:AddUISettingsToSection(settingsSection)

    -- Make settings panel draggable
    AddDragging(self.SettingsPanel, settingsTitleBar)
end

function Library:ToggleSettingsPanel()
    self.SettingsOpen = not self.SettingsOpen

    if self.SettingsOpen then
        self.SettingsPanel.Visible = true
        self.SettingsPanel.Size = UDim2.new(0, 0, 0, 0)
        self.SettingsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
        Tween(self.SettingsPanel, {
            Size = UDim2.new(0, 300, 0, 400),
            Position = UDim2.new(0.5, -150, 0.5, -200),
        }, 0.3, Enum.EasingStyle.Back)
    else
        Tween(self.SettingsPanel, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }, 0.3, Enum.EasingStyle.Back)
        wait(0.3)
        self.SettingsPanel.Visible = false
    end
end

-- Fixed toggle keybind setup with debounce
function Library:SetupToggleKeybind()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleKey then
            if not self.ToggleDebounce then
                self.ToggleDebounce = true
                self:ToggleUI()
                wait(0.3) -- Debounce time
                self.ToggleDebounce = false
            end
        end
    end)
end

function Library:ToggleUI()
    self.UIVisible = not self.UIVisible

    if self.UIVisible then
        self:Restore()
    else
        self:Minimize()
    end
end

-- New Active Functions Display
function Library:CreateActiveFunctionsDisplay()
    self.ActiveFunctionsFrame = CreateInstance('Frame', {
        Name = 'ActiveFunctionsFrame',
        Size = UDim2.new(0, 200, 0, 150),
        Position = UDim2.new(1, -220, 0, 20),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false,
    }, self.ScreenGui)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 8),
    }, self.ActiveFunctionsFrame)

    CreateInstance('UIStroke', {
        Color = self.Theme.Accent,
        Transparency = 0.6,
        Thickness = self.StrokeThickness,
    }, self.ActiveFunctionsFrame)

    -- Header
    local header = CreateInstance('TextLabel', {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = 'Active Functions',
        TextColor3 = self.Theme.Accent,
        TextSize = 14,
        Font = self.Font,
        TextXAlignment = Enum.TextXAlignment.Center,
    }, self.ActiveFunctionsFrame)

    -- Divider
    CreateInstance('Frame', {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 25),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, self.ActiveFunctionsFrame)

    -- Content area
    self.ActiveFunctionsContent = CreateInstance('ScrollingFrame', {
        Size = UDim2.new(1, -10, 1, -35),
        Position = UDim2.new(0, 5, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
    }, self.ActiveFunctionsFrame)

    CreateInstance('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),
    }, self.ActiveFunctionsContent)

    -- Floating animation
    local floatTween1 = TweenService:Create(
        self.ActiveFunctionsFrame,
        TweenInfo.new(
            3,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ),
        { Position = UDim2.new(1, -220, 0, 30) }
    )
    floatTween1:Play()

    -- Make draggable
    AddDragging(self.ActiveFunctionsFrame)

    -- Update content
    self:UpdateActiveFunctions()
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
    if not self.ActiveFunctionsContent then
        return
    end

    -- Clear existing
    for _, child in pairs(self.ActiveFunctionsContent:GetChildren()) do
        if child:IsA('Frame') then
            child:Destroy()
        end
    end

    -- Show/hide the active functions frame based on whether there are active functions
    if #self.ActiveFunctions == 0 then
        self.ActiveFunctionsFrame.Visible = false
    else
        self.ActiveFunctionsFrame.Visible = true
    end

    -- Add active functions
    for i, func in pairs(self.ActiveFunctions) do
        local funcFrame = CreateInstance('Frame', {
            Size = UDim2.new(1, -5, 0, 20),
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
        }, self.ActiveFunctionsContent)

        CreateInstance('UICorner', {
            CornerRadius = UDim.new(0, 4),
        }, funcFrame)

        -- Status indicator
        CreateInstance('Frame', {
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(0, 8, 0.5, -3),
            BackgroundColor3 = Color3.fromRGB(0, 255, 0),
            BorderSizePixel = 0,
        }, funcFrame)

        CreateInstance('UICorner', {
            CornerRadius = UDim.new(0.5, 0),
        }, funcFrame:GetChildren()[2])

        -- Function name
        CreateInstance('TextLabel', {
            Size = UDim2.new(1, -25, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = func,
            TextColor3 = self.Theme.Text,
            TextSize = 11,
            Font = self.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, funcFrame)
    end

    -- Update canvas size
    self.ActiveFunctionsContent.CanvasSize = UDim2.new(
        0,
        0,
        0,
        #self.ActiveFunctions * 23
    )
end

function Library:AddResizing()
    local resizing = false
    local startSize, startPos

    -- Resize handle (bottom-right corner)
    self.ResizeHandle = CreateInstance('Frame', {
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -15, 1, -15),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, self.MainFrame)

    self.ResizeHandle.MouseEnter:Connect(function()
        Mouse.Icon = 'rbxasset://SystemCursors/SizeNWSE'
    end)

    self.ResizeHandle.MouseLeave:Connect(function()
        if not resizing then
            Mouse.Icon = ''
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
            Mouse.Icon = ''
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if
            resizing
            and input.UserInputType == Enum.UserInputType.MouseMovement
        then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - startPos

            local newWidth = math.clamp(
                startSize.X + delta.X,
                self.MinSize.X,
                self.MaxSize.X
            )
            local newHeight = math.clamp(
                startSize.Y + delta.Y,
                self.MinSize.Y,
                self.MaxSize.Y
            )

            Tween(self.MainFrame, {
                Size = UDim2.new(0, newWidth, 0, newHeight),
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

function Library:CreateSection(name, customColor)
    local section = {}
    section.Name = name
    section.Elements = {}
    section.Open = true
    section.CustomColor = customColor

    -- Normal section (not dropdown) - This stays in the sidebar
    section.Button = CreateInstance('TextButton', {
        Name = name .. 'Section',
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.SectionBackground,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = '',
        LayoutOrder = #self.Sections,
    }, self.SectionContainer)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 6),
    }, section.Button)

    -- Section Highlight (left line)
    section.Highlight = CreateInstance('Frame', {
        Name = 'Highlight',
        Size = UDim2.new(0, 3, 1, -10),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundColor3 = self.Theme.SectionHighlight,
        BorderSizePixel = 0,
        Visible = false,
    }, section.Button)

    CreateInstance('UICorner', {
        CornerRadius = UDim.new(0, 2),
    }, section.Highlight)

    -- Section Label
    section.Label = CreateInstance('TextLabel', {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Theme.TextDark,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font,
    }, section.Button)

    -- Section Content (This is where all elements go including BigDropdowns)
    local yOffset = self.SectionHeaderEnabled and 45 or 5
    local ySize = self.SectionHeaderEnabled and 50 or 10

    section.Content = CreateInstance('ScrollingFrame', {
        Name = name .. 'Content',
        Size = UDim2.new(1, -20, 1, -ySize),
        Position = UDim2.new(0, 10, 0, yOffset),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        Visible = false,
    }, self.ContentContainer)

    CreateInstance('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, self.ElementSizes.Spacing),
    }, section.Content)

    -- Section Header (if enabled) with customization
    if self.SectionHeaderEnabled then
        local headerAlignment = Enum.TextXAlignment.Center
        if self.SectionHeaderConfig.Position == 'Left' then
            headerAlignment = Enum.TextXAlignment.Left
        elseif self.SectionHeaderConfig.Position == 'Right' then
            headerAlignment = Enum.TextXAlignment.Right
        end

        -- Use custom color if provided, otherwise use default
        local headerColor = customColor
            or self.SectionHeaderConfig.Color
            or (
                self.SectionHeaderWhite and Color3.fromRGB(255, 255, 255)
                or self.Theme.Accent
            )

        section.Header = CreateInstance('TextLabel', {
            Name = 'SectionHeader',
            Size = UDim2.new(1, -20, 0, 35),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = headerColor,
            TextSize = self.SectionHeaderConfig.Size,
            Font = self.SectionHeaderConfig.Font,
            TextXAlignment = headerAlignment,
            Visible = false,
        }, self.ContentContainer)

        -- Store header config state
        section.HeaderConfig = {
            UnderlineEnabled = self.SectionHeaderConfig.UnderlineEnabled,
            Color = headerColor,
        }

        -- Header Underline
        if section.HeaderConfig.UnderlineEnabled then
            section.HeaderUnderline = CreateInstance('Frame', {
                Size = UDim2.new(
                    self.SectionHeaderConfig.UnderlineSize,
                    0,
                    0,
                    self.SectionHeaderConfig.UnderlineThickness
                ),
                Position = UDim2.new(
                    (1 - self.SectionHeaderConfig.UnderlineSize) / 2,
                    0,
                    0,
                    35
                ),
                BackgroundColor3 = headerColor,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Visible = false,
            }, section.Header)

            CreateInstance('UICorner', {
                CornerRadius = UDim.new(0, 1),
            }, section.HeaderUnderline)
        end
    end

    -- Section Selection
    section.Button.MouseButton1Click:Connect(function()
        self:SelectSection(section)
    end)

    section.Button.MouseEnter:Connect(function()
        if self.CurrentSection ~= section then
            Tween(section.Label, { TextColor3 = self.Theme.Text }, 0.2)
            Tween(section.Button, { BackgroundTransparency = 0.1 }, 0.2)
        end
        if not IsMobile then
            Mouse.Icon = 'rbxasset://SystemCursors/Hand'
        end
    end)

    section.Button.MouseLeave:Connect(function()
        if self.CurrentSection ~= section then
            Tween(section.Label, { TextColor3 = self.Theme.TextDark }, 0.2)
            Tween(section.Button, { BackgroundTransparency = 0.3 }, 0.2)
        end
        if not IsMobile then
            Mouse.Icon = ''
        end
    end)

    table.insert(self.Sections, section)

    if #self.Sections == 1 then
        self:SelectSection(section)
    end

    return section
end

function Library:SelectSection(section)
    local animationTime = 0.15 -- Synchronized animation time

    -- Hide all sections with synchronized fade out
    for _, s in pairs(self.Sections) do
        if s.Content.Visible and s ~= section then
            -- Fade out header if exists
            if s.Header and s.Header.Visible then
                Tween(
                    s.Header,
                    { TextTransparency = 1 },
                    animationTime,
                    Enum.EasingStyle.Quad
                )
                if s.HeaderUnderline and s.HeaderConfig.UnderlineEnabled then
                    Tween(
                        s.HeaderUnderline,
                        { BackgroundTransparency = 1 },
                        animationTime,
                        Enum.EasingStyle.Quad
                    )
                end
            end

            -- Fade out all content elements at the same time
            for _, child in pairs(s.Content:GetChildren()) do
                if child:IsA('Frame') then
                    spawn(function()
                        -- Store transparency values for inner elements
                        local transparencies = {}
                        for _, innerChild in pairs(child:GetDescendants()) do
                            if
                                innerChild:IsA('Frame')
                                or innerChild:IsA('TextBox')
                            then
                                transparencies[innerChild] =
                                    innerChild.BackgroundTransparency
                            elseif
                                innerChild:IsA('TextLabel')
                                or innerChild:IsA('TextButton')
                            then
                                transparencies[innerChild] = innerChild.TextTransparency
                                    or 0
                            elseif
                                innerChild:IsA('ImageLabel')
                                or innerChild:IsA('ImageButton')
                            then
                                transparencies[innerChild] = innerChild.ImageTransparency
                                    or 0
                            end
                        end

                        -- Fade out main frame
                        Tween(
                            child,
                            { BackgroundTransparency = 1 },
                            animationTime,
                            Enum.EasingStyle.Quad
                        )

                        -- Fade out inner elements
                        for element, _ in pairs(transparencies) do
                            if
                                element:IsA('Frame') or element:IsA('TextBox')
                            then
                                Tween(
                                    element,
                                    { BackgroundTransparency = 1 },
                                    animationTime,
                                    Enum.EasingStyle.Quad
                                )
                            elseif
                                element:IsA('TextLabel')
                                or element:IsA('TextButton')
                            then
                                Tween(
                                    element,
                                    { TextTransparency = 1 },
                                    animationTime,
                                    Enum.EasingStyle.Quad
                                )
                            elseif
                                element:IsA('ImageLabel')
                                or element:IsA('ImageButton')
                            then
                                Tween(
                                    element,
                                    { ImageTransparency = 1 },
                                    animationTime,
                                    Enum.EasingStyle.Quad
                                )
                            end
                        end
                    end)
                end
            end

            -- Hide highlight with animation
            if s.Highlight and s.Highlight.Visible then
                Tween(
                    s.Highlight,
                    { Size = UDim2.new(0, 0, 1, -10) },
                    animationTime
                )
                spawn(function()
                    wait(animationTime)
                    s.Highlight.Visible = false
                    s.Highlight.Size = UDim2.new(0, 3, 1, -10)
                    if s.Header then
                        s.Header.Visible = false
                        if s.HeaderUnderline then
                            s.HeaderUnderline.Visible = false
                        end
                    end
                end)
            end

            Tween(s.Label, { TextColor3 = self.Theme.TextDark }, animationTime)
            Tween(s.Button, { BackgroundTransparency = 0.3 }, animationTime)

            spawn(function()
                wait(animationTime)
                s.Content.Visible = false
            end)
        end
    end

    -- Show selected section with synchronized fade in
    wait(animationTime)
    section.Content.Visible = true
    if section.Highlight then
        section.Highlight.Visible = true
    end
    if section.Header then
        section.Header.Visible = true
        if
            section.HeaderUnderline and section.HeaderConfig.UnderlineEnabled
        then
            section.HeaderUnderline.Visible = true
        end
        -- Reset header transparency
        section.Header.TextTransparency = 0
        if
            section.HeaderUnderline and section.HeaderConfig.UnderlineEnabled
        then
            section.HeaderUnderline.BackgroundTransparency = 0.3
        end
    end

    -- Animate highlight appearing
    if section.Highlight then
        section.Highlight.Size = UDim2.new(0, 0, 1, -10)
        Tween(
            section.Highlight,
            { Size = UDim2.new(0, 3, 1, -10) },
            animationTime * 1.5
        )
    end

    -- Animate header underline
    if section.HeaderUnderline and section.HeaderConfig.UnderlineEnabled then
        section.HeaderUnderline.Size = UDim2.new(
            0,
            0,
            0,
            self.SectionHeaderConfig.UnderlineThickness
        )
        Tween(section.HeaderUnderline, {
            Size = UDim2.new(
                self.SectionHeaderConfig.UnderlineSize,
                0,
                0,
                self.SectionHeaderConfig.UnderlineThickness
            ),
        }, animationTime * 2, Enum.EasingStyle.Back)
    end

    -- Animate section button
    Tween(section.Label, { TextColor3 = self.Theme.Text }, animationTime)
    Tween(section.Button, { BackgroundTransparency = 0.1 }, animationTime)

    -- Fade in content elements with synchronized timing
    for i, child in pairs(section.Content:GetChildren()) do
        if child:IsA('Frame') then
            spawn(function()
                wait(i * 0.02) -- Slight stagger for visual appeal

                -- Restore transparency values for inner elements
                for _, innerChild in pairs(child:GetDescendants()) do
                    if innerChild:IsA('Frame') or innerChild:IsA('TextBox') then
                        local originalTransparency = innerChild:GetAttribute(
                            'OriginalBackgroundTransparency'
                        ) or self.ButtonDarkness
                        if
                            innerChild.BackgroundTransparency
                            ~= originalTransparency
                        then
                            Tween(
                                innerChild,
                                {
                                    BackgroundTransparency = originalTransparency,
                                },
                                animationTime,
                                Enum.EasingStyle.Quad
                            )
                        end
                    elseif
                        innerChild:IsA('TextLabel')
                        or innerChild:IsA('TextButton')
                    then
                        if innerChild.TextTransparency ~= 0 then
                            Tween(
                                innerChild,
                                { TextTransparency = 0 },
                                animationTime,
                                Enum.EasingStyle.Quad
                            )
                        end
                    elseif
                        innerChild:IsA('ImageLabel')
                        or innerChild:IsA('ImageButton')
                    then
                        local originalTransparency = innerChild:GetAttribute(
                            'OriginalImageTransparency'
                        ) or 0
                        if
                            innerChild.ImageTransparency
                            ~= originalTransparency
                        then
                            Tween(
                                innerChild,
                                { ImageTransparency = originalTransparency },
                                animationTime,
                                Enum.EasingStyle.Quad
                            )
                        end
                    end
                end

                -- Fade in main frame
                local originalTransparency = child:GetAttribute(
                    'OriginalTransparency'
                ) or self.ButtonDarkness
                Tween(
                    child,
                    { BackgroundTransparency = originalTransparency },
                    animationTime,
                    Enum.EasingStyle.Quad
                )
            end)
        end
    end

    self.CurrentSection = section
end

-- Fixed minimize function with synchronized animations
function Library:Minimize()
    self.Minimized = true
    self.UIVisible = false
    -- Store current size before minimizing
    self.OriginalSize = self.MainFrame.Size

    -- Fade out all elements at once
    local animationTime = 0.3

    -- First hide section content and headers immediately
    for _, section in pairs(self.Sections) do
        if section.Header then
            section.Header.Visible = false
        end
        if section.HeaderUnderline then
            section.HeaderUnderline.Visible = false
        end
        section.Content.Visible = false
    end

    -- Main frame elements
    Tween(self.MainFrame, { BackgroundTransparency = 1 }, animationTime)
    Tween(self.Title, { TextTransparency = 1 }, animationTime)
    Tween(self.CloseButton, { TextTransparency = 1 }, animationTime)
    Tween(self.MinimizeButton, { TextTransparency = 1 }, animationTime)
    if self.SettingsButton then
        Tween(self.SettingsButton, { ImageTransparency = 1 }, animationTime)
    end
    Tween(self.TopDivider, { BackgroundTransparency = 1 }, animationTime)
    Tween(self.VerticalDivider, { BackgroundTransparency = 1 }, animationTime)
    Tween(self.EdgeGlow, { ImageTransparency = 1 }, animationTime)
    Tween(self.BackgroundImage, { ImageTransparency = 1 }, animationTime)

    -- Hide all section buttons
    for _, section in pairs(self.Sections) do
        Tween(section.Button, { BackgroundTransparency = 1 }, animationTime)
        Tween(section.Label, { TextTransparency = 1 }, animationTime)
    end

    -- Shrink frame
    Tween(self.MainFrame, { Size = UDim2.new(0, 0, 0, 0) }, animationTime)

    -- Move active functions frame
    Tween(
        self.ActiveFunctionsFrame,
        { Position = UDim2.new(1, 50, 0, 20) },
        animationTime
    )

    wait(animationTime)
    self.MainFrame.Visible = false

    -- Hide section buttons after animation
    for _, section in pairs(self.Sections) do
        section.Button.Visible = false
    end

    self.MinimizedFrame.Visible = true
    Tween(self.MinimizedFrame, { BackgroundTransparency = 0.1 }, 0.2)

    self.IgnoreNextMinimizedClick = true
    spawn(function()
        wait(0.5)
        self.IgnoreNextMinimizedClick = false
    end)
end

function Library:Restore()
    self.Minimized = false
    self.UIVisible = true
    self.MinimizedFrame.Visible = false
    self.MainFrame.Visible = true

    -- Reset transparencies
    self.MainFrame.BackgroundTransparency = 0.05
    self.Title.TextTransparency = 0
    self.CloseButton.TextTransparency = 0
    self.MinimizeButton.TextTransparency = 0
    if self.SettingsButton then
        self.SettingsButton.ImageTransparency = 0
    end
    self.TopDivider.BackgroundTransparency = 0.5
    self.VerticalDivider.BackgroundTransparency = 0.5
    self.EdgeGlow.ImageTransparency = 0.9
    self.BackgroundImage.ImageTransparency = 0.8

    -- Show all sections
    for _, section in pairs(self.Sections) do
        section.Button.Visible = true
        section.Button.BackgroundTransparency = 0.3
        section.Label.TextTransparency = 0
    end

    -- Show current section content and header
    if self.CurrentSection then
        self.CurrentSection.Content.Visible = true
        if self.CurrentSection.Header then
            self.CurrentSection.Header.Visible = true
            if
                self.CurrentSection.HeaderUnderline
                and self.CurrentSection.HeaderConfig.UnderlineEnabled
            then
                self.CurrentSection.HeaderUnderline.Visible = true
            end
        end
        -- Restore current section highlighting
        self.CurrentSection.Button.BackgroundTransparency = 0.1
        self.CurrentSection.Label.TextColor3 = self.Theme.Text
        if self.CurrentSection.Highlight then
            self.CurrentSection.Highlight.Visible = true
        end
    end

    -- Restore to the original size
    Tween(self.MainFrame, { Size = self.OriginalSize }, 0.3)
    Tween(
        self.ActiveFunctionsFrame,
        { Position = UDim2.new(1, -220, 0, 20) },
        0.3
    )
end

-- Update Section Headers (Fixed to respect individual section settings)
function Library:UpdateSectionHeaders()
    for _, section in pairs(self.Sections) do
        if section.Header then
            section.Header.TextSize = self.SectionHeaderConfig.Size
            section.Header.Font = self.SectionHeaderConfig.Font

            local headerAlignment = Enum.TextXAlignment.Center
            if self.SectionHeaderConfig.Position == 'Left' then
                headerAlignment = Enum.TextXAlignment.Left
            elseif self.SectionHeaderConfig.Position == 'Right' then
                headerAlignment = Enum.TextXAlignment.Right
            end
            section.Header.TextXAlignment = headerAlignment

            -- Update header config
            section.HeaderConfig.UnderlineEnabled =
                self.SectionHeaderConfig.UnderlineEnabled

            if section.HeaderUnderline then
                section.HeaderUnderline.Visible = section.HeaderConfig.UnderlineEnabled
                    and section.Header.Visible
                section.HeaderUnderline.Size = UDim2.new(
                    self.SectionHeaderConfig.UnderlineSize,
                    0,
                    0,
                    self.SectionHeaderConfig.UnderlineThickness
                )
                section.HeaderUnderline.Position = UDim2.new(
                    (1 - self.SectionHeaderConfig.UnderlineSize) / 2,
                    0,
                    0,
                    35
                )
            elseif section.HeaderConfig.UnderlineEnabled then
                -- Create underline if it doesn't exist but is now enabled
                section.HeaderUnderline = CreateInstance('Frame', {
                    Size = UDim2.new(
                        self.SectionHeaderConfig.UnderlineSize,
                        0,
                        0,
                        self.SectionHeaderConfig.UnderlineThickness
                    ),
                    Position = UDim2.new(
                        (1 - self.SectionHeaderConfig.UnderlineSize) / 2,
                        0,
                        0,
                        35
                    ),
                    BackgroundColor3 = section.HeaderConfig.Color,
                    BackgroundTransparency = 0.3,
                    BorderSizePixel = 0,
                    Visible = section.Header.Visible,
                }, section.Header)

                CreateInstance('UICorner', {
                    CornerRadius = UDim.new(0, 1),
                }, section.HeaderUnderline)
            end
        end
    end
end

-- Method to add UI settings to any section
function Library:AddUISettingsToSection(section)
    -- Add UI Settings label
    self:CreateLabel(section, {
        Text = 'UI Settings',
        Color = self.Theme.Accent,
    })

    -- Button Darkness Slider
    self:CreateSlider(section, {
        Text = 'Button Darkness',
        Min = 0,
        Max = 100,
        Default = self.ButtonDarkness * 100,
        Callback = function(value)
            self:SetButtonDarkness(value / 100)
        end,
    })

    -- Stroke Thickness Slider
    self:CreateSlider(section, {
        Text = 'Stroke Thickness',
        Min = 0,
        Max = 5,
        Default = self.StrokeThickness,
        Callback = function(value)
            self:SetStrokeThickness(value)
        end,
    })

    -- Font Dropdown
    local fontNames = {}
    for name, _ in pairs(Fonts) do
        table.insert(fontNames, name)
    end

    self:CreateDropdown(section, {
        Text = 'Font',
        Options = fontNames,
        Default = 'Ubuntu',
        Callback = function(font)
            self:SetFont(font)
        end,
    })

    -- Theme Dropdown
    local themeNames = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNames, name)
    end

    self:CreateDropdown(section, {
        Text = 'Theme',
        Options = themeNames,
        Default = 'Ocean',
        Callback = function(theme)
            self:SetTheme(theme)
        end,
    })

    -- Background Dropdown
    local backgroundNames = {}
    for name, _ in pairs(Backgrounds) do
        table.insert(backgroundNames, name)
    end

    self:CreateDropdown(section, {
        Text = 'Background',
        Options = backgroundNames,
        Default = self.CurrentBackground,
        Callback = function(background)
            self:SetBackground(background)
        end,
    })

    self:CreateSeparator(section)

    -- Section Header Settings
    self:CreateLabel(section, {
        Text = 'Section Header Settings',
        Color = self.Theme.Accent,
    })

    -- Header Size Slider
    self:CreateSlider(section, {
        Text = 'Header Size',
        Min = 14,
        Max = 30,
        Default = self.SectionHeaderConfig.Size,
        Callback = function(value)
            self.SectionHeaderConfig.Size = value
            self:UpdateSectionHeaders()
        end,
    })

    -- Header Position Dropdown
    self:CreateDropdown(section, {
        Text = 'Header Position',
        Options = { 'Center', 'Left', 'Right' },
        Default = self.SectionHeaderConfig.Position,
        Callback = function(position)
            self.SectionHeaderConfig.Position = position
            self:UpdateSectionHeaders()
        end,
    })

    -- Header Font Dropdown
    self:CreateDropdown(section, {
        Text = 'Header Font',
        Options = fontNames,
        Default = 'GothamBold',
        Callback = function(font)
            self.SectionHeaderConfig.Font = Fonts[font]
            self:UpdateSectionHeaders()
        end,
    })

    -- Underline Toggle
    self:CreateToggle(section, {
        Text = 'Header Underline',
        Default = self.SectionHeaderConfig.UnderlineEnabled,
        Callback = function(enabled)
            self.SectionHeaderConfig.UnderlineEnabled = enabled
            self:UpdateSectionHeaders()
        end,
    })

    -- Underline Size Slider
    self:CreateSlider(section, {
        Text = 'Underline Size',
        Min = 10,
        Max = 100,
        Default = self.SectionHeaderConfig.UnderlineSize * 100,
        Callback = function(value)
            self.SectionHeaderConfig.UnderlineSize = value / 100
            self:UpdateSectionHeaders()
        end,
    })

    self:CreateSeparator(section)

    -- Element Size Settings
    self:CreateLabel(section, {
        Text = 'Element Sizes',
        Color = self.Theme.Accent,
    })

    -- Button Size Slider
    self:CreateSlider(section, {
        Text = 'Button Size',
        Min = 25,
        Max = 50,
        Default = self.ElementSizes.Button,
        Callback = function(value)
            self.ElementSizes.Button = value
        end,
    })

    -- Toggle Size Slider
    self:CreateSlider(section, {
        Text = 'Toggle Size',
        Min = 25,
        Max = 50,
        Default = self.ElementSizes.Toggle,
        Callback = function(value)
            self.ElementSizes.Toggle = value
        end,
    })

    -- Slider Size Slider
    self:CreateSlider(section, {
        Text = 'Slider Size',
        Min = 40,
        Max = 70,
        Default = self.ElementSizes.Slider,
        Callback = function(value)
            self.ElementSizes.Slider = value
        end,
    })

    -- Input Size Slider
    self:CreateSlider(section, {
        Text = 'Input Size',
        Min = 25,
        Max = 50,
        Default = self.ElementSizes.Input,
        Callback = function(value)
            self.ElementSizes.Input = value
        end,
    })

    -- Dropdown Size Slider
    self:CreateSlider(section, {
        Text = 'Dropdown Size',
        Min = 25,
        Max = 50,
        Default = self.ElementSizes.Dropdown,
        Callback = function(value)
            self.ElementSizes.Dropdown = value
        end,
    })

    -- Spacing Slider
    self:CreateSlider(section, {
        Text = 'Element Spacing',
        Min = 4,
        Max = 20,
        Default = self.ElementSizes.Spacing,
        Callback = function(value)
            self.ElementSizes.Spacing = value
            -- Update all section layouts
            for _, s in pairs(self.Sections) do
                if s.Content:FindFirstChild('UIListLayout') then
                    s.Content.UIListLayout.Padding = UDim.new(0, value)
                end
            end
        end,
    })
end

-- New method to set background
function Library:SetBackground(backgroundName)
    if Backgrounds[backgroundName] then
        self.CurrentBackground = backgroundName
        self.BackgroundImage.Image = Backgrounds[backgroundName]
        self.MinimizedFrame.MinimizedBackgroundImage.Image =
            Backgrounds[backgroundName]
        if self.SettingsPanel:FindFirstChild('SettingsBackgroundImage') then
            self.SettingsPanel.SettingsBackgroundImage.Image = Backgrounds[backgroundName]
        end
    end
end

return Library
