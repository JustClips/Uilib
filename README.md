# 🎨 Eps1llon Hub Premium UI Library

A modern, feature-rich UI library for Roblox with smooth animations, customizable themes, and advanced functionality.

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Roblox](https://img.shields.io/badge/platform-Roblox-red)

## 📋 Table of Contents
- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Configuration Options](#-configuration-options)
- [UI Elements](#-ui-elements)
- [Advanced Features](#-advanced-features)
- [Themes](#-themes)
- [Customization](#-customization)
- [Full Example](#-full-example)
- [Troubleshooting](#-troubleshooting)

## ✨ Features

- 🎨 **Multiple Themes** - Dark, Light, Purple, and Ocean themes
- 🎯 **Dropdown Sections** - Collapsible sections for better organization
- ⌨️ **Customizable Keybinds** - Set any key to toggle the UI
- 📱 **Resizable Interface** - Drag corners to resize (500x400 to 800x600)
- 🔍 **Advanced Search** - Functional search with custom callbacks
- 💫 **Smooth Animations** - All elements have polished transitions
- 🎪 **Active Functions Display** - Real-time view of active features
- 🔧 **Highly Customizable** - Adjust darkness, stroke thickness, fonts, and more

## 📥 Installation

```lua
local Library = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_HERE"))()
```

## 🚀 Quick Start

```lua
-- Load the library
local Library = loadstring(game:HttpGet("YOUR_URL"))()

-- Create window with default settings
local Window = Library:Create({
    Theme = "Ocean"
})

-- Create a section
local MainSection = Window:CreateSection("Main")

-- Add a button
Window:CreateButton(MainSection, {
    Text = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})
```

## ⚙️ Configuration Options

When creating a window, you can customize various options:

```lua
local Window = Library:Create({
    Theme = "Ocean",                    -- "Dark", "Light", "Purple", "Ocean"
    ToggleKey = Enum.KeyCode.RightShift, -- Key to toggle UI visibility
    ButtonDarkness = 0.5,               -- 0 = transparent, 1 = opaque
    StrokeThickness = 1,                -- Border thickness (0-5)
    Font = "Ubuntu",                    -- Font name (see Fonts section)
    SectionHeaderEnabled = true,        -- Show section headers in content area
    SectionHeaderWhite = false,         -- Make headers white instead of colored
    DropdownSections = false            -- Enable collapsible sections
})
```

## 🧩 UI Elements

### Button
```lua
Window:CreateButton(section, {
    Text = "Button Name",
    Callback = function()
        print("Button clicked!")
    end
})
```

### Toggle
```lua
local toggle = Window:CreateToggle(section, {
    Text = "Toggle Name",
    Default = false,
    Callback = function(value)
        print("Toggle is now:", value)
    end
})

-- Set toggle programmatically
toggle.Set(true)
```

### Slider
```lua
local slider = Window:CreateSlider(section, {
    Text = "Slider Name",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})
```

### Input Box
```lua
Window:CreateInput(section, {
    Text = "Input Name",
    Placeholder = "Type here...",
    Default = "Default text",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("User entered:", text)
        end
    end
})
```

### Dropdown
```lua
Window:CreateDropdown(section, {
    Text = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

### Search Box
```lua
local searchBox = Window:CreateSearchBox(section, {
    Placeholder = "Search items...",
    Items = {"Apple", "Banana", "Cherry", "Date"},
    OnSelected = function(item)
        print("Selected:", item)
    end,
    OnSearch = function(searchText, items)
        -- Custom search logic (optional)
        local filtered = {}
        for _, item in pairs(items) do
            if item:lower():find(searchText:lower()) then
                table.insert(filtered, item)
            end
        end
        return filtered
    end
})

-- Update search items dynamically
searchBox.UpdateItems({"New", "Items", "Here"})
```

### Keybind
```lua
Window:CreateKeybind(section, {
    Text = "Keybind Name",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Keybind pressed!")
    end
})
```

### Label
```lua
Window:CreateLabel(section, {
    Text = "This is a label",
    Color = Color3.fromRGB(255, 255, 0) -- Optional color
})
```

### Separator
```lua
Window:CreateSeparator(section)
```

## 🎯 Advanced Features

### Dropdown Sections
Enable collapsible sections that start closed and expand when clicked:

```lua
local Window = Library:Create({
    DropdownSections = true
})

-- Sections will now have a dropdown arrow and collapse/expand functionality
```

### Custom Section Headers
Display section names prominently at the top of content area:

```lua
local Window = Library:Create({
    SectionHeaderEnabled = true,
    SectionHeaderWhite = true  -- Makes headers white instead of accent color
})
```

### Notifications
```lua
Window:Notify({
    Title = "Success!",
    Text = "Operation completed successfully",
    Duration = 3  -- seconds
})
```

### Runtime Customization
```lua
-- Change theme
Window:SetTheme("Purple")

-- Adjust button darkness
Window:SetButtonDarkness(0.3)  -- More transparent

-- Change stroke thickness
Window:SetStrokeThickness(2)

-- Change font
Window:SetFont("Gotham")

-- Change toggle key
Window:SetToggleKey(Enum.KeyCode.Tab)
```

## 🎨 Themes

Available themes:
- **Dark** - Classic dark theme with blue accents
- **Light** - Clean light theme for daytime use  
- **Purple** - Elegant purple theme
- **Ocean** - Cool ocean blue theme (default)

## 🛠️ Customization

### Available Fonts
- Ubuntu (default)
- Gotham
- GothamBold
- SourceSans
- SourceSansBold
- Code
- Highway
- SciFi
- Arial
- ArialBold

### Button Darkness
Adjust the opacity of all UI elements:
```lua
Window:SetButtonDarkness(0.2)  -- Very transparent
Window:SetButtonDarkness(0.8)  -- Nearly opaque
```

### Stroke Thickness
Control border thickness:
```lua
Window:SetStrokeThickness(0)  -- No borders
Window:SetStrokeThickness(3)  -- Thick borders
```

## 📖 Full Example

```lua
-- Eps1llon Hub Example Script
-- Created by: JustClips
-- Date: 2025-07-27

-- Load the library
local Library = loadstring(game:HttpGet("YOUR_URL"))()

-- Create window with custom configuration
local Window = Library:Create({
    Theme = "Ocean",
    ToggleKey = Enum.KeyCode.RightShift,
    ButtonDarkness = 0.5,
    StrokeThickness = 1,
    Font = "Ubuntu",
    SectionHeaderEnabled = true,
    SectionHeaderWhite = false,
    DropdownSections = false  -- Set to true for collapsible sections
})

-- Create sections
local MainSection = Window:CreateSection("Main")
local PlayerSection = Window:CreateSection("Player")
local VisualsSection = Window:CreateSection("Visuals")
local MiscSection = Window:CreateSection("Misc")
local SettingsSection = Window:CreateSection("Settings")

-- Main Section
Window:CreateLabel(MainSection, {
    Text = "Main Features",
    Color = Color3.fromRGB(100, 200, 255)
})

Window:CreateButton(MainSection, {
    Text = "Execute Main Script",
    Callback = function()
        Window:Notify({
            Title = "Executed!",
            Text = "Main script has been executed",
            Duration = 2
        })
    end
})

local autoFarm = Window:CreateToggle(MainSection, {
    Text = "Auto Farm",
    Default = false,
    Callback = function(value)
        getgenv().AutoFarm = value
        if value then
            -- Start auto farm
            print("Auto farm enabled")
        else
            -- Stop auto farm
            print("Auto farm disabled")
        end
    end
})

Window:CreateSlider(MainSection, {
    Text = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        getgenv().FarmSpeed = value
    end
})

Window:CreateSeparator(MainSection)

-- Player Section
local speedSlider = Window:CreateSlider(PlayerSection, {
    Text = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

local jumpSlider = Window:CreateSlider(PlayerSection, {
    Text = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

Window:CreateToggle(PlayerSection, {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(value)
        getgenv().InfiniteJump = value
    end
})

Window:CreateButton(PlayerSection, {
    Text = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- Visuals Section
Window:CreateToggle(VisualsSection, {
    Text = "ESP Enabled",
    Default = false,
    Callback = function(value)
        -- ESP code here
    end
})

Window:CreateDropdown(VisualsSection, {
    Text = "ESP Type",
    Options = {"Box", "Name", "Health", "Distance", "All"},
    Default = "Box",
    Callback = function(selected)
        print("ESP Type:", selected)
    end
})

Window:CreateToggle(VisualsSection, {
    Text = "Tracers",
    Default = false,
    Callback = function(value)
        -- Tracer code here
    end
})

Window:CreateSeparator(VisualsSection)

Window:CreateLabel(VisualsSection, {
    Text = "Visual Settings"
})

Window:CreateSlider(VisualsSection, {
    Text = "Field of View",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- Misc Section
Window:CreateInput(MiscSection, {
    Text = "Custom Command",
    Placeholder = "Enter command...",
    Callback = function(text, enterPressed)
        if enterPressed then
            -- Execute custom command
            print("Command:", text)
        end
    end
})

local playerSearch = Window:CreateSearchBox(MiscSection, {
    Placeholder = "Search players...",
    Items = {},  -- Will be updated
    OnSelected = function(playerName)
        print("Selected player:", playerName)
    end
})

-- Update player list
spawn(function()
    while true do
        local players = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(players, player.Name)
        end
        playerSearch.UpdateItems(players)
        wait(5)
    end
end)

Window:CreateKeybind(MiscSection, {
    Text = "Panic Key",
    Default = Enum.KeyCode.P,
    Callback = function()
        -- Disable all features
        autoFarm.Set(false)
        Window:Notify({
            Title = "Panic!",
            Text = "All features disabled",
            Duration = 2
        })
    end
})

-- Settings Section
Window:CreateLabel(SettingsSection, {
    Text = "UI Settings"
})

Window:CreateDropdown(SettingsSection, {
    Text = "Theme",
    Options = {"Dark", "Light", "Purple", "Ocean"},
    Default = "Ocean",
    Callback = function(selected)
        Window:SetTheme(selected)
    end
})

Window:CreateSlider(SettingsSection, {
    Text = "Button Transparency",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        Window:SetButtonDarkness(value / 100)
    end
})

Window:CreateSlider(SettingsSection, {
    Text = "Border Thickness",
    Min = 0,
    Max = 5,
    Default = 1,
    Callback = function(value)
        Window:SetStrokeThickness(value)
    end
})

Window:CreateDropdown(SettingsSection, {
    Text = "Font",
    Options = {"Ubuntu", "Gotham", "GothamBold", "SourceSans", "Code", "Arial"},
    Default = "Ubuntu",
    Callback = function(selected)
        Window:SetFont(selected)
    end
})

Window:CreateSeparator(SettingsSection)

Window:CreateButton(SettingsSection, {
    Text = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})

-- Show welcome notification
Window:Notify({
    Title = "Welcome " .. game.Players.LocalPlayer.Name .. "!",
    Text = "Eps1llon Hub loaded successfully",
    Duration = 5
})

-- Keybind hint
Window:Notify({
    Title = "Tip",
    Text = "Press Right Shift to toggle UI",
    Duration = 3
})
```

## 🔧 Troubleshooting

### UI won't toggle with keybind
- Make sure you're not in chat or another text input
- Try changing the toggle key: `Window:SetToggleKey(Enum.KeyCode.Tab)`

### Sections not showing
- If using dropdown sections, click on the section name to expand
- Check that you've created elements in the section

### Search not working
- Ensure you've provided items to search through
- Check your custom search callback returns a table

### UI looks wrong
- Try a different theme
- Adjust button darkness and stroke thickness
- Some games may interfere with UI rendering

## 📄 License

This UI library is free to use and modify. Created by the Eps1llon Hub Team.

---

**Last Updated:** 2025-07-27 | **Version:** 2.0.0 | **Author:** JustClips
