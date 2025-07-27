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

-- Background Images
local BackgroundImages = {
    ["Blue Sky"] = "rbxassetid://98784591713474",
    ["Mountains"] = "rbxassetid://128738385973775",
    ["Blurred Stars"] = "rbxassetid://83743690094319"
}

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
    ArialBold = Enum.Font.ArialBold
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
    local clickThreshold = 0.3 -- Time threshold for click vs drag
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then -- Only start dragging after 5 pixels of movement
                Tween(frame, {
                    Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
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
    
    self.Theme = Themes[config.Theme or "Ocean"]
    self.Sections = {}
    self.CurrentSection = nil
    self.Minimized = false
    self.MinSize = Vector2.new(500, 400)
    self.MaxSize = Vector2.new(800, 600)
    self.OriginalSize = UDim2.new(0, 650, 0, 450)
    self.ActiveFunctions = {}
    self.UIVisible = true
    self.ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    self.ToggleDebounce = false -- Fix for toggle key issue
    self.CurrentBackground = config.Background or "Blue Sky"
    
    -- Customization Options
    self.ButtonDarkness = config.ButtonDarkness or 0.5  -- 0 = fully transparent, 1 = fully opaque
    self.StrokeThickness = config.StrokeThickness or 1  -- Default stroke thickness
    self.Font = Fonts[config.Font] or Fonts.Ubuntu      -- Default font
    self.SectionHeaderEnabled = config.SectionHeaderEnabled ~= false  -- Default true
    self.SectionHeaderWhite = config.SectionHeaderWhite or false  -- Default colored
    self.DropdownSections = config.DropdownSections or false  -- Default false (normal sections)
    
    -- Section Header Customization
    self.SectionHeaderSize = config.SectionHeaderSize or 22
    self.SectionHeaderAlignment = config.SectionHeaderAlignment or Enum.TextXAlignment.Center
    self.SectionHeaderFont = Fonts[config.SectionHeaderFont] or Enum.Font.GothamBold
    self.SectionHeaderColor = config.SectionHeaderColor -- If nil, uses theme accent
    self.SectionHeaderYOffset = config.SectionHeaderYOffset or 5
    
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
    
    -- Add background image to main frame
    self.BackgroundImage = CreateInstance("ImageLabel", {
        Name = "BackgroundImage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = BackgroundImages[self.CurrentBackground],
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
    }, self.BackgroundImage)
    
    -- Edge glow effect (made shorter)
    self.EdgeGlow = CreateInstance("ImageLabel", {
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
    }, self.EdgeGlow)
    
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
        Font = self.Font
    }, self.TitleBar)
    
    -- Close Button (X) - Made bigger
    self.CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -32, 0.5, -12.5),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 26,
        Font = self.Font
    }, self.TitleBar)
    
    self.CloseButton.MouseEnter:Connect(function()
        Tween(self.CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        Tween(self.CloseButton, {TextColor3 = self.Theme.Text}, 0.2)
        Mouse.Icon = ""
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Minimize Button (-) - Moved left and made shorter
    self.MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 20, 0, 18),
        Position = UDim2.new(1, -62, 0.5, -9),
        BackgroundTransparency = 1,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        Font = self.Font
    }, self.TitleBar)
    
    self.MinimizeButton.MouseEnter:Connect(function()
        Tween(self.MinimizeButton, {TextColor3 = self.Theme.Accent}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        Tween(self.MinimizeButton, {TextColor3 = self.Theme.Text}, 0.2)
        Mouse.Icon = ""
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    -- Top divider line (connects all the way)
    self.TopDivider = CreateInstance("Frame", {
        Name = "TopDivider",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, self.MainFrame)
    
    -- Left Section Container WITHOUT background (transparent)
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
    
    -- Vertical divider line (connects all the way)
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
    
    -- Minimized Frame (Floating Square) - FIXED with proper dragging
    self.MinimizedFrame = CreateInstance("Frame", {
        Name = "MinimizedFrame",
        Size = UDim2.new(0, 150, 0, 40),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 999,
        Active = true,
        Selectable = true
    }, self.ScreenGui)
    
    -- Add background image to minimized frame (same as main frame)
    CreateInstance("ImageLabel", {
        Name = "MinimizedBackgroundImage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = BackgroundImages[self.CurrentBackground],
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 998
    }, self.MinimizedFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, self.MinimizedFrame)
    
    -- Apply corner to minimized background image too
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, self.MinimizedFrame.MinimizedBackgroundImage)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.3,
        Thickness = 1.5
    }, self.MinimizedFrame)
    
    -- Add subtle glow effect to minimized frame
    local minimizedGlow = CreateInstance("ImageLabel", {
        Name = "MinimizedGlow",
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = self.Theme.Accent,
        ImageTransparency = 0.8,
        ZIndex = 997
    }, self.MinimizedFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10)
    }, minimizedGlow)
    
    self.MinimizedTitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "Eps1llon Hub",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font,
        ZIndex = 1000
    }, self.MinimizedFrame)
    
    -- Improved minimized frame dragging and clicking
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local clickStart = 0
    
    self.MinimizedFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MinimizedFrame.Position
            clickStart = tick()
        end
    end)
    
    self.MinimizedFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local clickDuration = tick() - clickStart
            local dragDistance = (input.Position - dragStart).Magnitude
            
            -- Only restore if it was a quick click without much movement
            if clickDuration < 0.3 and dragDistance < 5 then
                self:ToggleUI()
            end
            
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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
        Tween(self.MinimizedFrame, {BackgroundTransparency = 0.05}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    self.MinimizedFrame.MouseLeave:Connect(function()
        Tween(self.MinimizedFrame, {BackgroundTransparency = 0.1}, 0.2)
        Mouse.Icon = ""
    end)
    
    -- Create Active Functions Display
    self:CreateActiveFunctionsDisplay()
    
    -- Make main frame draggable
    AddDragging(self.MainFrame, self.TitleBar)
    
    -- Add resizing
    self:AddResizing()
    
    -- Setup toggle keybind
    self:SetupToggleKeybind()
    
    return self
end

-- New toggle keybind setup with debounce fix
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

-- Method to change background image
function Library:SetBackground(backgroundName)
    if BackgroundImages[backgroundName] then
        self.CurrentBackground = backgroundName
        self.BackgroundImage.Image = BackgroundImages[backgroundName]
        if self.MinimizedFrame:FindFirstChild("MinimizedBackgroundImage") then
            self.MinimizedFrame.MinimizedBackgroundImage.Image = BackgroundImages[backgroundName]
        end
    end
end

-- New Active Functions Display
function Library:CreateActiveFunctionsDisplay()
    self.ActiveFunctionsFrame = CreateInstance("Frame", {
        Name = "ActiveFunctionsFrame",
        Size = UDim2.new(0, 200, 0, 150),
        Position = UDim2.new(1, -220, 0, 20),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, self.ActiveFunctionsFrame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, self.ActiveFunctionsFrame)
    
    -- Header
    local header = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "Active Functions",
        TextColor3 = self.Theme.Accent,
        TextSize = 14,
        Font = self.Font,
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
    
    -- Floating animation
    local floatTween1 = TweenService:Create(
        self.ActiveFunctionsFrame,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(1, -220, 0, 30)}
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
    if not self.ActiveFunctionsContent then return end
    
    -- Clear existing
    for _, child in pairs(self.ActiveFunctionsContent:GetChildren()) do
        if child:IsA("Frame") then
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
            Font = self.Font,
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
    section.Open = not self.DropdownSections -- If dropdown sections, start closed
    
    if self.DropdownSections then
        -- Create dropdown section
        section.Button = CreateInstance("TextButton", {
            Name = name .. "Section",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = self.Theme.SectionBackground,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Text = "",
            ClipsDescendants = true
        }, self.SectionContainer)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }, section.Button)
        
        -- Dropdown arrow
        section.Arrow = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0.5, -10),
            BackgroundTransparency = 1,
            Text = "▶",
            TextColor3 = self.Theme.Text,
            TextSize = 12,
            Font = self.Font,
            Rotation = 0
        }, section.Button)
        
        -- Section Label
        section.Label = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = self.Font
        }, section.Button)
        
        -- Section Content Container (inside the button for dropdown)
        section.ContentContainer = CreateInstance("Frame", {
            Name = "ContentContainer",
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 35),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true
        }, section.Button)
        
        -- Section Content
        section.Content = CreateInstance("ScrollingFrame", {
            Name = name .. "Content",
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            Visible = true
        }, section.ContentContainer)
        
        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        }, section.Content)
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
        }, section.Content)
        
        -- Toggle dropdown
        section.Label.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                section.Open = not section.Open
                
                if section.Open then
                    -- Calculate content height
                    local contentHeight = 0
                    for _, child in pairs(section.Content:GetChildren()) do
                        if child:IsA("GuiObject") then
                            contentHeight = contentHeight + child.AbsoluteSize.Y + 8
                        end
                    end
                    contentHeight = math.min(contentHeight, 300) -- Max height
                    
                    -- Animate opening
                    Tween(section.Arrow, {Rotation = 90}, 0.3, Enum.EasingStyle.Back)
                    Tween(section.ContentContainer, {Size = UDim2.new(1, 0, 0, contentHeight)}, 0.3, Enum.EasingStyle.Back)
                    Tween(section.Button, {Size = UDim2.new(1, 0, 0, 35 + contentHeight)}, 0.3, Enum.EasingStyle.Back)
                else
                    -- Animate closing
                    Tween(section.Arrow, {Rotation = 0}, 0.3, Enum.EasingStyle.Back)
                    Tween(section.ContentContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
                    Tween(section.Button, {Size = UDim2.new(1, 0, 0, 35)}, 0.3, Enum.EasingStyle.Back)
                end
            end
        end)
        
        section.Label.MouseEnter:Connect(function()
            Tween(section.Button, {BackgroundTransparency = 0.1}, 0.2)
            Mouse.Icon = "rbxasset://SystemCursors/Hand"
        end)
        
        section.Label.MouseLeave:Connect(function()
            Tween(section.Button, {BackgroundTransparency = 0.3}, 0.2)
            Mouse.Icon = ""
        end)
        
    else
        -- Normal section (non-dropdown)
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
            Font = self.Font
        }, section.Button)
        
        -- Section Content
        local yOffset = self.SectionHeaderEnabled and (self.SectionHeaderYOffset + 40) or 5
        local ySize = self.SectionHeaderEnabled and (self.SectionHeaderYOffset + 45) or 10
        
        section.Content = CreateInstance("ScrollingFrame", {
            Name = name .. "Content",
            Size = UDim2.new(1, -20, 1, -ySize),
            Position = UDim2.new(0, 10, 0, yOffset),
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
        
        -- Section Header (if enabled)
        if self.SectionHeaderEnabled then
            section.Header = CreateInstance("TextLabel", {
                Name = "SectionHeader",
                Size = UDim2.new(1, -20, 0, 35),
                Position = UDim2.new(0, 10, 0, self.SectionHeaderYOffset),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = self.SectionHeaderColor or (self.SectionHeaderWhite and Color3.fromRGB(255, 255, 255) or self.Theme.Accent),
                TextSize = self.SectionHeaderSize,
                Font = self.SectionHeaderFont,
                TextXAlignment = self.SectionHeaderAlignment,
                Visible = false
            }, self.ContentContainer)
            
            -- Header Underline
            section.HeaderUnderline = CreateInstance("Frame", {
                Size = UDim2.new(0.5, 0, 0, 2),
                Position = UDim2.new(self.SectionHeaderAlignment == Enum.TextXAlignment.Center and 0.25 or 0, 0, 0, 35),
                BackgroundColor3 = self.SectionHeaderColor or (self.SectionHeaderWhite and Color3.fromRGB(255, 255, 255) or self.Theme.Accent),
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Visible = false
            }, section.Header)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 1)
            }, section.HeaderUnderline)
        end
        
        -- Section Selection
        section.Button.MouseButton1Click:Connect(function()
            self:SelectSection(section)
        end)
        
        section.Button.MouseEnter:Connect(function()
            if self.CurrentSection ~= section then
                Tween(section.Label, {TextColor3 = self.Theme.Text}, 0.2)
                Tween(section.Button, {BackgroundTransparency = 0.1}, 0.2)
            end
            Mouse.Icon = "rbxasset://SystemCursors/Hand"
        end)
        
        section.Button.MouseLeave:Connect(function()
            if self.CurrentSection ~= section then
                Tween(section.Label, {TextColor3 = self.Theme.TextDark}, 0.2)
                Tween(section.Button, {BackgroundTransparency = 0.3}, 0.2)
            end
            Mouse.Icon = ""
        end)
    end
    
    -- Update content size when elements are added
    section.UpdateContentSize = function()
        if self.DropdownSections and section.Open then
            local contentHeight = 0
            for _, child in pairs(section.Content:GetChildren()) do
                if child:IsA("GuiObject") then
                    contentHeight = contentHeight + child.AbsoluteSize.Y + 8
                end
            end
            contentHeight = math.min(contentHeight, 300)
            
            Tween(section.ContentContainer, {Size = UDim2.new(1, 0, 0, contentHeight)}, 0.2)
            Tween(section.Button, {Size = UDim2.new(1, 0, 0, 35 + contentHeight)}, 0.2)
        end
    end
    
    table.insert(self.Sections, section)
    
    if #self.Sections == 1 and not self.DropdownSections then
        self:SelectSection(section)
    end
    
    return section
end

function Library:SelectSection(section)
    if self.DropdownSections then return end -- Dropdown sections don't use selection
    
    local animationTime = 0.15 -- Synchronized animation time
    
    -- Hide all sections with synchronized fade out
    for _, s in pairs(self.Sections) do
        if s.Content.Visible and s ~= section then
            s.Content.Visible = false
            if s.Header then
                s.Header.Visible = false
                s.HeaderUnderline.Visible = false
            end
            s.Highlight.Visible = false
            Tween(s.Label, {TextColor3 = self.Theme.TextDark}, animationTime)
            Tween(s.Button, {BackgroundTransparency = 0.3}, animationTime)
        end
    end
    
    -- Show selected section with synchronized fade in
    if section and not section.Content.Visible then
        self.CurrentSection = section
        
        section.Content.Visible = true
        if section.Header then
            section.Header.Visible = true
            section.HeaderUnderline.Visible = true
        end
        section.Highlight.Visible = true
        
        Tween(section.Label, {TextColor3 = self.Theme.Text}, animationTime)
        Tween(section.Button, {BackgroundTransparency = 0.1}, animationTime)
        Tween(section.Highlight, {BackgroundTransparency = 0}, animationTime)
        
        -- Update canvas size
        local contentHeight = 0
        for _, child in pairs(section.Content:GetChildren()) do
            if child:IsA("GuiObject") then
                contentHeight = contentHeight + child.AbsoluteSize.Y + 8
            end
        end
        section.Content.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    end
end

function Library:Minimize()
    self.Minimized = true
    self.UIVisible = false
    
    Tween(self.MainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }, 0.3, Enum.EasingStyle.Back)
    
    wait(0.3)
    self.MainFrame.Visible = false
    self.MinimizedFrame.Visible = true
    
    Tween(self.MinimizedFrame, {
        Size = UDim2.new(0, 150, 0, 40),
        BackgroundTransparency = 0.1
    }, 0.3, Enum.EasingStyle.Back)
end

function Library:Restore()
    self.Minimized = false
    self.UIVisible = true
    
    self.MinimizedFrame.Visible = false
    self.MainFrame.Visible = true
    
    Tween(self.MainFrame, {
        Size = self.OriginalSize,
        BackgroundTransparency = 0.05
    }, 0.3, Enum.EasingStyle.Back)
end

function Library:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- UI Element Creation Functions

function Library:CreateButton(section, config)
    config = config or {}
    local button = {}
    
    button.Frame = CreateInstance("Frame", {
        Name = "ButtonFrame",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1 - self.ButtonDarkness,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, button.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, button.Frame)
    
    button.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Button",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font
    }, button.Frame)
    
    button.Button.MouseEnter:Connect(function()
        Tween(button.Frame, {BackgroundTransparency = math.max(0, 1 - self.ButtonDarkness - 0.1)}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    button.Button.MouseLeave:Connect(function()
        Tween(button.Frame, {BackgroundTransparency = 1 - self.ButtonDarkness}, 0.2)
        Mouse.Icon = ""
    end)
    
    if config.Callback then
        button.Button.MouseButton1Click:Connect(config.Callback)
    end
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return button
end

function Library:CreateToggle(section, config)
    config = config or {}
    local toggle = {}
    toggle.Value = config.Default or false
    
    toggle.Frame = CreateInstance("Frame", {
        Name = "ToggleFrame",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1 - self.ButtonDarkness,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, toggle.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, toggle.Frame)
    
    toggle.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Toggle",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, toggle.Frame)
    
    toggle.Switch = CreateInstance("Frame", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = toggle.Value and self.Theme.Accent or self.Theme.Tertiary,
        BorderSizePixel = 0
    }, toggle.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10)
    }, toggle.Switch)
    
    toggle.Circle = CreateInstance("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, toggle.Value and 22 or 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, toggle.Switch)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, toggle.Circle)
    
    local function updateToggle()
        local targetColor = toggle.Value and self.Theme.Accent or self.Theme.Tertiary
        local targetPosition = toggle.Value and 22 or 2
        
        Tween(toggle.Switch, {BackgroundColor3 = targetColor}, 0.2)
        Tween(toggle.Circle, {Position = UDim2.new(0, targetPosition, 0.5, -8)}, 0.2)
        
        if config.Callback then
            config.Callback(toggle.Value)
        end
        
        if toggle.Value then
            self:AddActiveFunction(config.Text or "Toggle")
        else
            self:RemoveActiveFunction(config.Text or "Toggle")
        end
    end
    
    toggle.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    }, toggle.Frame)
    
    toggle.Button.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        updateToggle()
    end)
    
    toggle.Button.MouseEnter:Connect(function()
        Tween(toggle.Frame, {BackgroundTransparency = math.max(0, 1 - self.ButtonDarkness - 0.1)}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    toggle.Button.MouseLeave:Connect(function()
        Tween(toggle.Frame, {BackgroundTransparency = 1 - self.ButtonDarkness}, 0.2)
        Mouse.Icon = ""
    end)
    
    -- Initialize
    updateToggle()
    
    function toggle:SetValue(value)
        self.Value = value
        updateToggle()
    end
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return toggle
end

function Library:CreateSlider(section, config)
    config = config or {}
    local slider = {}
    slider.Value = config.Default or config.Min or 0
    slider.Min = config.Min or 0
    slider.Max = config.Max or 100
    slider.Increment = config.Increment or 1
    
    slider.Frame = CreateInstance("Frame", {
        Name = "SliderFrame",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1 - self.ButtonDarkness,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, slider.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, slider.Frame)
    
    slider.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 0, 25),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Slider",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, slider.Frame)
    
    slider.ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 45, 0, 25),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(slider.Value),
        TextColor3 = self.Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = self.Font
    }, slider.Frame)
    
    slider.Track = CreateInstance("Frame", {
        Size = UDim2.new(1, -30, 0, 4),
        Position = UDim2.new(0, 15, 0, 30),
        BackgroundColor3 = self.Theme.Tertiary,
        BorderSizePixel = 0
    }, slider.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 2)
    }, slider.Track)
    
    slider.Fill = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    }, slider.Track)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 2)
    }, slider.Fill)
    
    slider.Handle = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, -6, 0.5, -6),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, slider.Fill)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0.5, 0)
    }, slider.Handle)
    
    local function updateSlider()
        local percentage = (slider.Value - slider.Min) / (slider.Max - slider.Min)
        local trackWidth = slider.Track.AbsoluteSize.X
        local fillWidth = trackWidth * percentage
        
        Tween(slider.Fill, {Size = UDim2.new(0, fillWidth, 1, 0)}, 0.1)
        slider.ValueLabel.Text = tostring(slider.Value)
        
        if config.Callback then
            config.Callback(slider.Value)
        end
    end
    
    local dragging = false
    
    slider.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local function update()
                local mousePos = UserInputService:GetMouseLocation().X
                local trackPos = slider.Track.AbsolutePosition.X
                local trackWidth = slider.Track.AbsoluteSize.X
                local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
                
                local newValue = slider.Min + (percentage * (slider.Max - slider.Min))
                newValue = math.floor(newValue / slider.Increment + 0.5) * slider.Increment
                slider.Value = math.clamp(newValue, slider.Min, slider.Max)
                updateSlider()
            end
            update()
            
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    update()
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    function slider:SetValue(value)
        self.Value = math.clamp(value, self.Min, self.Max)
        updateSlider()
    end
    
    -- Initialize
    updateSlider()
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return slider
end

function Library:CreateDropdown(section, config)
    config = config or {}
    local dropdown = {}
    dropdown.Value = config.Default or ""
    dropdown.Options = config.Options or {}
    dropdown.Open = false
    
    dropdown.Frame = CreateInstance("Frame", {
        Name = "DropdownFrame",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1 - self.ButtonDarkness,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, dropdown.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, dropdown.Frame)
    
    dropdown.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    }, dropdown.Frame)
    
    dropdown.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Dropdown",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, dropdown.Frame)
    
    dropdown.Value = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -130, 0, 0),
        BackgroundTransparency = 1,
        Text = dropdown.Value,
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = self.Font
    }, dropdown.Frame)
    
    dropdown.Arrow = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = self.Theme.Text,
        TextSize = 10,
        Font = self.Font
    }, dropdown.Frame)
    
    dropdown.List = CreateInstance("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10
    }, dropdown.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, dropdown.List)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.4,
        Thickness = self.StrokeThickness
    }, dropdown.List)
    
    dropdown.ListContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent
    }, dropdown.List)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, dropdown.ListContainer)
    
    local function updateDropdownList()
        -- Clear existing options
        for _, child in pairs(dropdown.ListContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Add options
        for i, option in pairs(dropdown.Options) do
            local optionFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = self.Theme.Tertiary,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0
            }, dropdown.ListContainer)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4)
            }, optionFrame)
            
            local optionButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = option,
                TextColor3 = self.Theme.Text,
                TextSize = 12,
                Font = self.Font
            }, optionFrame)
            
            optionButton.MouseEnter:Connect(function()
                Tween(optionFrame, {BackgroundTransparency = 0.6}, 0.2)
                Mouse.Icon = "rbxasset://SystemCursors/Hand"
            end)
            
            optionButton.MouseLeave:Connect(function()
                Tween(optionFrame, {BackgroundTransparency = 0.8}, 0.2)
                Mouse.Icon = ""
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Value = option
                dropdown.ValueLabel.Text = option
                dropdown.Open = false
                
                Tween(dropdown.List, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                Tween(dropdown.Arrow, {Rotation = 0}, 0.3)
                
                wait(0.3)
                dropdown.List.Visible = false
                
                if config.Callback then
                    config.Callback(option)
                end
            end)
        end
        
        -- Update canvas size
        dropdown.ListContainer.CanvasSize = UDim2.new(0, 0, 0, #dropdown.Options * 32)
    end
    
    dropdown.Button.MouseButton1Click:Connect(function()
        dropdown.Open = not dropdown.Open
        
        if dropdown.Open then
            dropdown.List.Visible = true
            updateDropdownList()
            
            local listHeight = math.min(#dropdown.Options * 32, 150)
            Tween(dropdown.List, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.3)
            Tween(dropdown.Arrow, {Rotation = 180}, 0.3)
        else
            Tween(dropdown.List, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            Tween(dropdown.Arrow, {Rotation = 0}, 0.3)
            
            wait(0.3)
            dropdown.List.Visible = false
        end
    end)
    
    dropdown.Button.MouseEnter:Connect(function()
        Tween(dropdown.Frame, {BackgroundTransparency = math.max(0, 1 - self.ButtonDarkness - 0.1)}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    dropdown.Button.MouseLeave:Connect(function()
        Tween(dropdown.Frame, {BackgroundTransparency = 1 - self.ButtonDarkness}, 0.2)
        Mouse.Icon = ""
    end)
    
    function dropdown:SetOptions(options)
        self.Options = options
        updateDropdownList()
    end
    
    function dropdown:SetValue(value)
        if table.find(self.Options, value) then
            self.Value = value
            self.ValueLabel.Text = value
        end
    end
    
    -- Initialize
    dropdown.ValueLabel = dropdown.Value
    updateDropdownList()
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return dropdown
end

function Library:CreateTextbox(section, config)
    config = config or {}
    local textbox = {}
    textbox.Value = config.Default or ""
    
    textbox.Frame = CreateInstance("Frame", {
        Name = "TextboxFrame",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1 - self.ButtonDarkness,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, textbox.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, textbox.Frame)
    
    textbox.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Textbox",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, textbox.Frame)
    
    textbox.Input = CreateInstance("TextBox", {
        Size = UDim2.new(1, -130, 1, -10),
        Position = UDim2.new(0, 120, 0, 5),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = textbox.Value,
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = self.Font,
        PlaceholderText = config.Placeholder or "Enter text...",
        PlaceholderColor3 = self.Theme.TextDark,
        ClearTextOnFocus = false
    }, textbox.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, textbox.Input)
    
    CreateInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    }, textbox.Input)
    
    textbox.Input.Focused:Connect(function()
        Tween(textbox.Input, {BackgroundTransparency = 0.1}, 0.2)
        Tween(textbox.Input.UIStroke or CreateInstance("UIStroke", {
            Color = self.Theme.Accent,
            Transparency = 0.5,
            Thickness = 1
        }, textbox.Input), {Transparency = 0.3}, 0.2)
    end)
    
    textbox.Input.FocusLost:Connect(function(enterPressed)
        Tween(textbox.Input, {BackgroundTransparency = 0.3}, 0.2)
        if textbox.Input:FindFirstChild("UIStroke") then
            Tween(textbox.Input.UIStroke, {Transparency = 0.8}, 0.2)
        end
        
        textbox.Value = textbox.Input.Text
        
        if config.Callback then
            config.Callback(textbox.Value, enterPressed)
        end
    end)
    
    function textbox:SetValue(value)
        self.Value = value
        self.Input.Text = value
    end
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return textbox
end

function Library:CreateKeybind(section, config)
    config = config or {}
    local keybind = {}
    keybind.Key = config.Default or Enum.KeyCode.Unknown
    keybind.Binding = false
    
    keybind.Frame = CreateInstance("Frame", {
        Name = "KeybindFrame",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1 - self.ButtonDarkness,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, keybind.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, keybind.Frame)
    
    keybind.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Keybind",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, keybind.Frame)
    
    keybind.KeyLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 80, 0, 25),
        Position = UDim2.new(1, -90, 0.5, -12.5),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = keybind.Key.Name,
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = self.Font
    }, keybind.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, keybind.KeyLabel)
    
    keybind.Button = CreateInstance("TextButton", {
        Size = UDim2.new(0, 80, 0, 25),
        Position = UDim2.new(1, -90, 0.5, -12.5),
        BackgroundTransparency = 1,
        Text = ""
    }, keybind.Frame)
    
    local function updateKeybind()
        keybind.KeyLabel.Text = keybind.Binding and "..." or keybind.Key.Name
        keybind.KeyLabel.TextColor3 = keybind.Binding and self.Theme.Accent or self.Theme.Text
    end
    
    keybind.Button.MouseButton1Click:Connect(function()
        keybind.Binding = true
        updateKeybind()
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                keybind.Key = input.KeyCode
                keybind.Binding = false
                updateKeybind()
                connection:Disconnect()
                
                if config.Callback then
                    config.Callback(keybind.Key)
                end
            end
        end)
    end)
    
    keybind.Button.MouseEnter:Connect(function()
        Tween(keybind.KeyLabel, {BackgroundTransparency = 0.1}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    keybind.Button.MouseLeave:Connect(function()
        Tween(keybind.KeyLabel, {BackgroundTransparency = 0.3}, 0.2)
        Mouse.Icon = ""
    end)
    
    -- Key press detection
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == keybind.Key and not keybind.Binding then
            if config.OnPress then
                config.OnPress()
            end
        end
    end)
    
    function keybind:SetKey(key)
        self.Key = key
        updateKeybind()
    end
    
    -- Initialize
    updateKeybind()
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return keybind
end

function Library:CreateColorpicker(section, config)
    config = config or {}
    local colorpicker = {}
    colorpicker.Color = config.Default or Color3.fromRGB(255, 255, 255)
    colorpicker.Open = false
    
    colorpicker.Frame = CreateInstance("Frame", {
        Name = "ColorpickerFrame",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1 - self.ButtonDarkness,
        BorderSizePixel = 0
    }, section.Content)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, colorpicker.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.6,
        Thickness = self.StrokeThickness
    }, colorpicker.Frame)
    
    colorpicker.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Color",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, colorpicker.Frame)
    
    colorpicker.Preview = CreateInstance("Frame", {
        Size = UDim2.new(0, 30, 0, 20),
        Position = UDim2.new(1, -45, 0.5, -10),
        BackgroundColor3 = colorpicker.Color,
        BorderSizePixel = 0
    }, colorpicker.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, colorpicker.Preview)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Border,
        Transparency = 0.5,
        Thickness = 1
    }, colorpicker.Preview)
    
    colorpicker.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    }, colorpicker.Frame)
    
    -- Color picker window
    colorpicker.Window = CreateInstance("Frame", {
        Name = "ColorWindow",
        Size = UDim2.new(0, 250, 0, 300),
        Position = UDim2.new(0.5, -125, 0.5, -150),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, colorpicker.Window)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.3,
        Thickness = 2
    }, colorpicker.Window)
    
    -- Color picker title
    local title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "Color Picker",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        Font = self.Font
    }, colorpicker.Window)
    
    -- Hue/Saturation picker
    local hsvFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -40, 0, 180),
        Position = UDim2.new(0, 20, 0, 40),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0
    }, colorpicker.Window)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, hsvFrame)
    
    -- Saturation overlay
    local saturationOverlay = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0,
        BorderSizePixel = 0
    }, hsvFrame)
    
    CreateInstance("UIGradient", {
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        },
        Rotation = 90
    }, saturationOverlay)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, saturationOverlay)
    
    -- Value overlay
    local valueOverlay = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0,
        BorderSizePixel = 0
    }, hsvFrame)
    
    CreateInstance("UIGradient", {
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        },
        Rotation = 0
    }, valueOverlay)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, valueOverlay)
    
    -- Hue bar
    local hueBar = CreateInstance("Frame", {
        Size = UDim2.new(0, 20, 0, 180),
        Position = UDim2.new(1, -35, 0, 40),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, colorpicker.Window)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, hueBar)
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        },
        Rotation = 90
    }, hueBar)
    
    -- RGB inputs
    local rgbFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 1, -80),
        BackgroundTransparency = 1
    }, colorpicker.Window)
    
    local rInput = CreateInstance("TextBox", {
        Size = UDim2.new(0.3, -5, 0, 25),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "255",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = self.Font,
        PlaceholderText = "R"
    }, rgbFrame)
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4)}, rInput)
    
    local gInput = CreateInstance("TextBox", {
        Size = UDim2.new(0.3, -5, 0, 25),
        Position = UDim2.new(0.35, 0, 0, 0),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "255",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = self.Font,
        PlaceholderText = "G"
    }, rgbFrame)
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4)}, gInput)
    
    local bInput = CreateInstance("TextBox", {
        Size = UDim2.new(0.3, -5, 0, 25),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundColor3 = self.Theme.Tertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "255",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = self.Font,
        PlaceholderText = "B"
    }, rgbFrame)
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4)}, bInput)
    
    -- OK/Cancel buttons
    local okButton = CreateInstance("TextButton", {
        Size = UDim2.new(0.45, 0, 0, 25),
        Position = UDim2.new(0, 10, 1, -45),
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = "OK",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = self.Font
    }, colorpicker.Window)
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4)}, okButton)
    
    local cancelButton = CreateInstance("TextButton", {
        Size = UDim2.new(0.45, 0, 0, 25),
        Position = UDim2.new(0.55, 0, 1, -45),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "Cancel",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = self.Font
    }, colorpicker.Window)
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4)}, cancelButton)
    
    -- Color picker functionality
    local currentHue = 0
    local currentSat = 1
    local currentVal = 1
    
    local function updateColorFromHSV()
        local function HSVtoRGB(h, s, v)
            local r, g, b
            local i = math.floor(h * 6)
            local f = h * 6 - i
            local p = v * (1 - s)
            local q = v * (1 - f * s)
            local t = v * (1 - (1 - f) * s)
            
            i = i % 6
            
            if i == 0 then
                r, g, b = v, t, p
            elseif i == 1 then
                r, g, b = q, v, p
            elseif i == 2 then
                r, g, b = p, v, t
            elseif i == 3 then
                r, g, b = p, q, v
            elseif i == 4 then
                r, g, b = t, p, v
            elseif i == 5 then
                r, g, b = v, p, q
            end
            
            return r, g, b
        end
        
        local r, g, b = HSVtoRGB(currentHue, currentSat, currentVal)
        colorpicker.Color = Color3.fromRGB(r * 255, g * 255, b * 255)
        
        colorpicker.Preview.BackgroundColor3 = colorpicker.Color
        rInput.Text = tostring(math.floor(r * 255))
        gInput.Text = tostring(math.floor(g * 255))
        bInput.Text = tostring(math.floor(b * 255))
        
        -- Update hue background
        local hueColor = Color3.fromHSV(currentHue, 1, 1)
        hsvFrame.BackgroundColor3 = hueColor
    end
    
    -- Make draggable
    AddDragging(colorpicker.Window, title)
    
    colorpicker.Button.MouseButton1Click:Connect(function()
        colorpicker.Open = not colorpicker.Open
        colorpicker.Window.Visible = colorpicker.Open
        
        if colorpicker.Open then
            updateColorFromHSV()
        end
    end)
    
    okButton.MouseButton1Click:Connect(function()
        colorpicker.Open = false
        colorpicker.Window.Visible = false
        
        if config.Callback then
            config.Callback(colorpicker.Color)
        end
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        colorpicker.Open = false
        colorpicker.Window.Visible = false
    end)
    
    colorpicker.Button.MouseEnter:Connect(function()
        Tween(colorpicker.Frame, {BackgroundTransparency = math.max(0, 1 - self.ButtonDarkness - 0.1)}, 0.2)
        Mouse.Icon = "rbxasset://SystemCursors/Hand"
    end)
    
    colorpicker.Button.MouseLeave:Connect(function()
        Tween(colorpicker.Frame, {BackgroundTransparency = 1 - self.ButtonDarkness}, 0.2)
        Mouse.Icon = ""
    end)
    
    function colorpicker:SetColor(color)
        self.Color = color
        self.Preview.BackgroundColor3 = color
    end
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return colorpicker
end

function Library:CreateLabel(section, config)
    config = config or {}
    local label = {}
    
    label.Frame = CreateInstance("Frame", {
        Name = "LabelFrame",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, section.Content)
    
    label.Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Label",
        TextColor3 = config.Color or self.Theme.Text,
        TextSize = config.Size or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, label.Frame)
    
    function label:SetText(text)
        self.Label.Text = text
    end
    
    function label:SetColor(color)
        self.Label.TextColor3 = color
    end
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return label
end

function Library:CreateSeparator(section)
    local separator = {}
    
    separator.Frame = CreateInstance("Frame", {
        Name = "SeparatorFrame",
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, section.Content)
    
    separator.Line = CreateInstance("Frame", {
        Size = UDim2.new(1, -40, 0, 1),
        Position = UDim2.new(0, 20, 0.5, 0),
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, separator.Frame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 0.5)
    }, separator.Line)
    
    -- Update section content size
    if section.UpdateContentSize then
        section.UpdateContentSize()
    end
    
    return separator
end

-- Theme Management
function Library:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        self:UpdateTheme()
    end
end

function Library:UpdateTheme()
    -- Update main frame colors
    if self.MainFrame then
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        self.Title.TextColor3 = self.Theme.Text
        self.CloseButton.TextColor3 = self.Theme.Text
        self.MinimizeButton.TextColor3 = self.Theme.Text
        self.TopDivider.BackgroundColor3 = self.Theme.Border
        self.VerticalDivider.BackgroundColor3 = self.Theme.Border
    end
    
    -- Update minimized frame colors
    if self.MinimizedFrame then
        self.MinimizedFrame.BackgroundColor3 = self.Theme.Background
        self.MinimizedTitle.TextColor3 = self.Theme.Text
        if self.MinimizedFrame:FindFirstChild("UIStroke") then
            self.MinimizedFrame.UIStroke.Color = self.Theme.Accent
        end
    end
    
    -- Update section colors
    for _, section in pairs(self.Sections) do
        if section.Button then
            section.Button.BackgroundColor3 = self.Theme.SectionBackground
        end
        if section.Label then
            section.Label.TextColor3 = self.CurrentSection == section and self.Theme.Text or self.Theme.TextDark
        end
        if section.Highlight then
            section.Highlight.BackgroundColor3 = self.Theme.SectionHighlight
        end
        if section.Header then
            section.Header.TextColor3 = self.SectionHeaderColor or (self.SectionHeaderWhite and Color3.fromRGB(255, 255, 255) or self.Theme.Accent)
        end
        if section.HeaderUnderline then
            section.HeaderUnderline.BackgroundColor3 = self.SectionHeaderColor or (self.SectionHeaderWhite and Color3.fromRGB(255, 255, 255) or self.Theme.Accent)
        end
    end
    
    -- Update active functions frame
    if self.ActiveFunctionsFrame then
        self.ActiveFunctionsFrame.BackgroundColor3 = self.Theme.Background
        if self.ActiveFunctionsFrame:FindFirstChild("UIStroke") then
            self.ActiveFunctionsFrame.UIStroke.Color = self.Theme.Accent
        end
    end
    
    -- Update edge glow
    if self.EdgeGlow then
        self.EdgeGlow.ImageColor3 = self.Theme.Accent
    end
end

-- Notification System
function Library:CreateNotification(config)
    config = config or {}
    local notification = {}
    
    notification.Frame = CreateInstance("Frame", {
        Name = "Notification",
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, -320, 1, -100),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0
    }, self.ScreenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, notification.Frame)
    
    CreateInstance("UIStroke", {
        Color = self.Theme.Accent,
        Transparency = 0.5,
        Thickness = 1
    }, notification.Frame)
    
    -- Icon
    local icon = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundTransparency = 1,
        Text = config.Icon or "ℹ",
        TextColor3 = self.Theme.Accent,
        TextSize = 20,
        Font = self.Font
    }, notification.Frame)
    
    -- Title
    local title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 0, 25),
        Position = UDim2.new(0, 50, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = self.Font
    }, notification.Frame)
    
    -- Description
    local description = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 0, 40),
        Position = UDim2.new(0, 50, 0, 25),
        BackgroundTransparency = 1,
        Text = config.Description or "Description",
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Font = self.Font
    }, notification.Frame)
    
    -- Animate in
    notification.Frame.Position = UDim2.new(1, 0, 1, -100)
    Tween(notification.Frame, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back)
    
    -- Auto dismiss
    local duration = config.Duration or 3
    wait(duration)
    
    -- Animate out
    Tween(notification.Frame, {
        Position = UDim2.new(1, 0, 1, -100),
        BackgroundTransparency = 1
    }, 0.3)
    
    wait(0.3)
    notification.Frame:Destroy()
    
    return notification
end

-- Save/Load Configuration
function Library:SaveConfig(name)
    local config = {
        Theme = self.Theme,
        Sections = {},
        ActiveFunctions = self.ActiveFunctions,
        Position = self.MainFrame.Position,
        Size = self.MainFrame.Size
    }
    
    -- Save section states and element values
    for _, section in pairs(self.Sections) do
        config.Sections[section.Name] = {
            Elements = {}
        }
        
        for _, element in pairs(section.Elements) do
            if element.Value ~= nil then
                config.Sections[section.Name].Elements[element.Name] = element.Value
            end
        end
    end
    
    writefile("EpsillonHub_" .. name .. ".json", game:GetService("HttpService"):JSONEncode(config))
end

function Library:LoadConfig(name)
    if isfile("EpsillonHub_" .. name .. ".json") then
        local success, config = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("EpsillonHub_" .. name .. ".json"))
        end)
        
        if success and config then
            -- Restore theme
            if config.Theme then
                self.Theme = config.Theme
                self:UpdateTheme()
            end
            
            -- Restore position and size
            if config.Position then
                self.MainFrame.Position = UDim2.new(config.Position.X.Scale, config.Position.X.Offset, config.Position.Y.Scale, config.Position.Y.Offset)
            end
            if config.Size then
                self.MainFrame.Size = UDim2.new(config.Size.X.Scale, config.Size.X.Offset, config.Size.Y.Scale, config.Size.Y.Offset)
            end
            
            -- Restore active functions
            if config.ActiveFunctions then
                self.ActiveFunctions = config.ActiveFunctions
                self:UpdateActiveFunctions()
            end
            
            return true
        end
    end
    return false
end

-- Return the library
return Library
