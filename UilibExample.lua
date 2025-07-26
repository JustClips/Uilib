-- Comprehensive Uilib Example Script
-- This script demonstrates ALL available UI components from the Uilib library
-- Loadstring compatible - can be loaded with loadstring()

-- Load the Uilib library (assumes Uilib.lua is available)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()
end)

if not success then
    warn("Failed to load Uilib library. Make sure the library is accessible.")
    return
end

-- Create the main window with compact size
local Window = Library:Create({
    Theme = "Dark" -- Start with Dark theme
})

-- Override the default size for a more compact interface
Window.MainFrame.Size = UDim2.new(0, 550, 0, 400)
Window.MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
Window.MinSize = Vector2.new(500, 350)
Window.MaxSize = Vector2.new(700, 500)

-- Update window title
Window.Title.Text = "Uilib Complete Demo"

--[[ 
    SECTION 1: BASIC CONTROLS
    Demonstrates buttons, toggles, and labels
]]
local BasicSection = Window:CreateSection("Basic Controls")

-- Notification function for demonstrations
local function ShowNotification(title, text)
    spawn(function()
        Window:Notify({
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

-- Demo Labels with different colors
Window:CreateLabel(BasicSection, {
    Text = "📋 Basic UI Components",
    Color = Color3.fromRGB(100, 200, 255)
})

Window:CreateSeparator(BasicSection)

-- Standard Button
Window:CreateButton(BasicSection, {
    Text = "🚀 Standard Button",
    Callback = function()
        ShowNotification("Button Clicked!", "This is a standard button demonstration")
    end
})

-- Action Button
Window:CreateButton(BasicSection, {
    Text = "⚡ Action Button",
    Callback = function()
        ShowNotification("Action!", "Performing some action...")
    end
})

-- Basic Toggle
local basicToggle = Window:CreateToggle(BasicSection, {
    Text = "🔄 Basic Toggle",
    Default = false,
    Callback = function(value)
        ShowNotification("Toggle Changed", "Toggle is now: " .. (value and "ON" or "OFF"))
    end
})

-- Feature Toggle
local featureToggle = Window:CreateToggle(BasicSection, {
    Text = "⭐ Feature Toggle",
    Default = true,
    Callback = function(value)
        ShowNotification("Feature", "Feature is " .. (value and "enabled" or "disabled"))
    end
})

-- Status Label
local statusLabel = Window:CreateLabel(BasicSection, {
    Text = "Status: Ready",
    Color = Color3.fromRGB(100, 255, 100)
})

--[[ 
    SECTION 2: INPUT CONTROLS
    Demonstrates sliders, inputs, and advanced controls
]]
local InputSection = Window:CreateSection("Input Controls")

Window:CreateLabel(InputSection, {
    Text = "🎮 Interactive Input Elements",
    Color = Color3.fromRGB(255, 200, 100)
})

Window:CreateSeparator(InputSection)

-- Speed Slider
Window:CreateSlider(InputSection, {
    Text = "🏃 Speed",
    Min = 1,
    Max = 100,
    Default = 50,
    Callback = function(value)
        ShowNotification("Speed Changed", "Speed set to: " .. value)
    end
})

-- Volume Slider
Window:CreateSlider(InputSection, {
    Text = "🔊 Volume",
    Min = 0,
    Max = 10,
    Default = 5,
    Callback = function(value)
        ShowNotification("Volume", "Volume: " .. value .. "/10")
    end
})

-- Username Input
Window:CreateInput(InputSection, {
    Text = "👤 Username",
    Placeholder = "Enter username...",
    Default = "",
    Callback = function(text, enterPressed)
        if enterPressed then
            ShowNotification("Username Set", "Username: " .. (text ~= "" and text or "Not set"))
        end
    end
})

-- Number Input
Window:CreateInput(InputSection, {
    Text = "🔢 Player ID",
    Placeholder = "Enter player ID...",
    Default = "",
    Callback = function(text, enterPressed)
        local num = tonumber(text)
        if enterPressed then
            if num then
                ShowNotification("Valid ID", "Player ID: " .. num)
            else
                ShowNotification("Invalid ID", "Please enter a valid number")
            end
        end
    end
})

--[[ 
    SECTION 3: SELECTION CONTROLS
    Demonstrates dropdowns and search functionality
]]
local SelectionSection = Window:CreateSection("Selection Controls")

Window:CreateLabel(SelectionSection, {
    Text = "📝 Selection & Search Elements",
    Color = Color3.fromRGB(200, 100, 255)
})

Window:CreateSeparator(SelectionSection)

-- Game Mode Dropdown
Window:CreateDropdown(SelectionSection, {
    Text = "🎯 Game Mode",
    Options = {"Classic", "Arcade", "Survival", "Creative", "Custom"},
    Default = "Classic",
    Callback = function(option)
        ShowNotification("Mode Selected", "Game mode: " .. option)
    end
})

-- Difficulty Dropdown
Window:CreateDropdown(SelectionSection, {
    Text = "⚔️ Difficulty",
    Options = {"Easy", "Normal", "Hard", "Expert", "Nightmare"},
    Default = "Normal",
    Callback = function(option)
        ShowNotification("Difficulty Set", "Difficulty: " .. option)
    end
})

-- Player Search
Window:CreateSearchBox(SelectionSection, {
    Placeholder = "🔍 Search players...",
    Items = {
        "PlayerOne", "PlayerTwo", "PlayerThree", "AdminUser", "GuestPlayer",
        "ProGamer", "Newbie123", "VeteranPlayer", "RandomUser", "TestPlayer",
        "Developer", "Moderator", "Helper", "VIPMember", "RegularUser"
    },
    Callback = function(selected)
        ShowNotification("Player Selected", "Selected: " .. selected)
    end
})

-- Item Search
Window:CreateSearchBox(SelectionSection, {
    Placeholder = "🎒 Search items...",
    Items = {
        "Sword", "Shield", "Bow", "Arrow", "Potion", "Armor", "Helmet",
        "Boots", "Ring", "Amulet", "Key", "Gem", "Scroll", "Book", "Tool"
    },
    Callback = function(selected)
        ShowNotification("Item Found", "Item: " .. selected)
    end
})

--[[ 
    SECTION 4: THEME & VISUAL
    Demonstrates theme switching and visual elements
]]
local ThemeSection = Window:CreateSection("Themes & Visual")

Window:CreateLabel(ThemeSection, {
    Text = "🎨 Visual Customization",
    Color = Color3.fromRGB(255, 100, 150)
})

Window:CreateSeparator(ThemeSection)

-- Theme Selection Dropdown
Window:CreateDropdown(ThemeSection, {
    Text = "🎭 Theme",
    Options = {"Dark", "Light", "Purple", "Ocean"},
    Default = "Dark",
    Callback = function(theme)
        Window:SetTheme(theme)
        ShowNotification("Theme Changed", "Theme: " .. theme)
    end
})

-- Color Labels
Window:CreateLabel(ThemeSection, {
    Text = "🔴 Red Status",
    Color = Color3.fromRGB(255, 100, 100)
})

Window:CreateLabel(ThemeSection, {
    Text = "🟢 Green Status", 
    Color = Color3.fromRGB(100, 255, 100)
})

Window:CreateLabel(ThemeSection, {
    Text = "🔵 Blue Status",
    Color = Color3.fromRGB(100, 100, 255)
})

-- Notification Test Button
Window:CreateButton(ThemeSection, {
    Text = "🔔 Test Notification",
    Callback = function()
        ShowNotification("Test Notification", "This is a test notification with longer text to demonstrate the notification system!")
    end
})

--[[ 
    SECTION 5: ADVANCED FEATURES
    Demonstrates advanced functionality and combinations
]]
local AdvancedSection = Window:CreateSection("Advanced Features")

Window:CreateLabel(AdvancedSection, {
    Text = "⚙️ Advanced Functionality",
    Color = Color3.fromRGB(255, 200, 50)
})

Window:CreateSeparator(AdvancedSection)

-- Complex Toggle with dependent controls
local advancedMode = false
local advancedToggle = Window:CreateToggle(AdvancedSection, {
    Text = "🧠 Advanced Mode",
    Default = false,
    Callback = function(value)
        advancedMode = value
        ShowNotification("Advanced Mode", value and "Enabled" or "Disabled")
        
        -- Update status based on advanced mode
        if statusLabel then
            statusLabel.Label.Text = "Status: " .. (value and "Advanced" or "Basic")
            statusLabel.Label.TextColor3 = value and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 255, 100)
        end
    end
})

-- Precision Slider (only relevant in advanced mode)
Window:CreateSlider(AdvancedSection, {
    Text = "🎯 Precision",
    Min = 1,
    Max = 1000,
    Default = 100,
    Callback = function(value)
        if advancedMode then
            ShowNotification("Precision Set", "High precision: " .. value)
        else
            ShowNotification("Precision", "Basic precision: " .. math.floor(value/10)*10)
        end
    end
})

-- Configuration Input
Window:CreateInput(AdvancedSection, {
    Text = "⚙️ Config",
    Placeholder = "Enter config string...",
    Default = "",
    Callback = function(text, enterPressed)
        if enterPressed and text ~= "" then
            ShowNotification("Config Applied", "Config: " .. text:sub(1, 20) .. (text:len() > 20 and "..." or ""))
        end
    end
})

-- Multi-action Button
Window:CreateButton(AdvancedSection, {
    Text = "🔄 Multi-Action",
    Callback = function()
        ShowNotification("Multi-Action", "Performing multiple actions...")
        
        -- Simulate complex operation
        spawn(function()
            wait(1)
            ShowNotification("Progress", "Step 1 complete...")
            wait(1)
            ShowNotification("Progress", "Step 2 complete...")
            wait(1)
            ShowNotification("Complete", "All actions finished!")
        end)
    end
})

-- Final separator and info
Window:CreateSeparator(AdvancedSection)

Window:CreateLabel(AdvancedSection, {
    Text = "✨ Demo Complete - All components shown!",
    Color = Color3.fromRGB(100, 255, 200)
})

-- Welcome notification
spawn(function()
    wait(1)
    Window:Notify({
        Title = "Welcome!",
        Text = "Explore all UI components in this comprehensive demo",
        Duration = 3
    })
end)

-- Return the window for external access
return Window