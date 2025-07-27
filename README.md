# Eps1llon Hub Premium UI Library

A modern, feature-rich UI library for Roblox with smooth animations, resizable interface, and multiple themes.

## 🌟 Key Features

- **Multiple Themes**: Dark, Light, Purple, and Ocean themes
- **Ultra-Smooth Animations**: Synchronized fade transitions and smooth toggle animations
- **Resizable Window**: Drag from bottom-right corner to resize
- **Smart Minimization**: Click to restore, drag to move the minimized window
- **Active Functions Display**: Real-time display of active toggles/functions
- **Advanced UI Elements**: Buttons, Toggles, Sliders, Dropdowns, Input fields, Search boxes, and more
- **Custom Background**: Includes custom background image with proper transparency

## 🛠️ Latest Updates (2025-07-27)

1. **Synchronized Section Animations**: All elements fade in/out at the same speed (0.15s)
2. **Fixed Minimized Window**: Proper drag detection - only restores on quick clicks, not while dragging
3. **Enhanced Toggle Animation**: Smooth color transitions with bounce effect and shadow
4. **Improved Element Transparency**: Proper handling of all element transparencies during transitions

## 📥 Installation

```lua
local Library = loadstring(game:HttpGet("YOUR_LIBRARY_URL"))()
```

## 📚 Complete Usage Example

```lua
-- Load the library
local Library = loadstring(game:HttpGet("YOUR_LIBRARY_URL"))()

-- Create main window with Ocean theme
local Window = Library:Create({
    Theme = "Ocean" -- Options: "Dark", "Light", "Purple", "Ocean"
})

-- Create sections
local MainSection = Window:CreateSection("Main")
local CombatSection = Window:CreateSection("Combat")
local VisualsSection = Window:CreateSection("Visuals")
local SettingsSection = Window:CreateSection("Settings")

-- Main Section Elements
Window:CreateButton(MainSection, {
    Text = "Execute Script",
    Callback = function()
        print("Script executed!")
        Window:Notify({
            Title = "Success",
            Text = "Script has been executed successfully!",
            Duration = 3
        })
    end
})

local autoFarmToggle = Window:CreateToggle(MainSection, {
    Text = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
        -- Your auto farm code here
    end
})

Window:CreateSlider(MainSection, {
    Text = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        print("Farm Speed:", value)
        -- Adjust farm speed
    end
})

-- Combat Section Elements
Window:CreateToggle(CombatSection, {
    Text = "Kill Aura",
    Default = false,
    Callback = function(value)
        print("Kill Aura:", value)
        -- Your kill aura code
    end
})

Window:CreateSlider(CombatSection, {
    Text = "Aura Range",
    Min = 5,
    Max = 50,
    Default = 15,
    Callback = function(value)
        print("Aura Range:", value)
        -- Adjust aura range
    end
})

Window:CreateDropdown(CombatSection, {
    Text = "Target Priority",
    Options = {"Closest", "Lowest Health", "Highest Health", "Random"},
    Default = "Closest",
    Callback = function(selected)
        print("Target Priority:", selected)
    end
})

-- Visuals Section Elements
Window:CreateToggle(VisualsSection, {
    Text = "ESP",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
        -- Your ESP code
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

Window:CreateLabel(VisualsSection, {
    Text = "Visual Settings",
    Color = Color3.fromRGB(255, 255, 0)
})

Window:CreateSeparator(VisualsSection)

-- Settings Section Elements
Window:CreateInput(SettingsSection, {
    Text = "Config Name",
    Placeholder = "Enter config name...",
    Default = "MyConfig",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Config saved as:", text)
        end
    end
})

Window:CreateSearchBox(SettingsSection, {
    Placeholder = "Search players...",
    Items = {"Player1", "Player2", "Player3", "Player4"},
    Callback = function(selected)
        print("Selected player:", selected)
    end
})

Window:CreateKeybind(SettingsSection, {
    Text = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Window:Minimize()
    end
})

Window:CreateButton(SettingsSection, {
    Text = "Change Theme",
    Callback = function()
        local themes = {"Dark", "Light", "Purple", "Ocean"}
        local currentTheme = 1
        for i, theme in pairs(themes) do
            if Window.Theme == Themes[theme] then
                currentTheme = i
                break
            end
        end
        local nextTheme = themes[currentTheme % #themes + 1]
        Window:SetTheme(nextTheme)
        
        Window:Notify({
            Title = "Theme Changed",
            Text = "Changed to " .. nextTheme .. " theme",
            Duration = 2
        })
    end
})

-- Example of programmatic control
wait(2)
autoFarmToggle.Set(true) -- Enable auto farm after 2 seconds

-- Show welcome notification
Window:Notify({
    Title = "Welcome!",
    Text = "Eps1llon Hub loaded successfully",
    Duration = 5
})
```

## 🎨 Available Themes

1. **Dark** - Classic dark theme with blue accents
2. **Light** - Clean light theme for daytime use
3. **Purple** - Elegant purple theme
4. **Ocean** - Cool ocean blue theme (default)

## 📋 API Reference

### Window Creation
```lua
local Window = Library:Create({
    Theme = "Ocean" -- Optional, defaults to "Ocean"
})
```

### Sections
```lua
local section = Window:CreateSection("Section Name")
```

### UI Elements

**Button**
```lua
Window:CreateButton(section, {
    Text = "Button Text",
    Callback = function() end
})
```

**Toggle** (with smooth animations)
```lua
local toggle = Window:CreateToggle(section, {
    Text = "Toggle Text",
    Default = false,
    Callback = function(value) end
})
toggle.Set(true) -- Set programmatically
```

**Slider** (ultra-smooth)
```lua
Window:CreateSlider(section, {
    Text = "Slider Text",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value) end
})
```

**Input**
```lua
Window:CreateInput(section, {
    Text = "Label",
    Placeholder = "Enter text...",
    Default = "",
    Callback = function(text, enterPressed) end
})
```

**Dropdown**
```lua
Window:CreateDropdown(section, {
    Text = "Dropdown Label",
    Options = {"Option 1", "Option 2"},
    Default = "Option 1",
    Callback = function(selected) end
})
```

**Search Box**
```lua
Window:CreateSearchBox(section, {
    Placeholder = "Search...",
    Items = {"Item 1", "Item 2", "Item 3"},
    Callback = function(selected) end
})
```

**Keybind**
```lua
Window:CreateKeybind(section, {
    Text = "Keybind Label",
    Default = Enum.KeyCode.F,
    Callback = function() end
})
```

**Label**
```lua
Window:CreateLabel(section, {
    Text = "Label Text",
    Color = Color3.fromRGB(255, 255, 255)
})
```

**Separator**
```lua
Window:CreateSeparator(section)
```

### Other Functions

**Notification**
```lua
Window:Notify({
    Title = "Title",
    Text = "Message",
    Duration = 3 -- seconds
})
```

**Theme Change**
```lua
Window:SetTheme("Dark") -- "Dark", "Light", "Purple", "Ocean"
```

**Window Control**
```lua
Window:Minimize() -- Minimize to floating icon
Window:Restore() -- Restore from minimized state
Window:Destroy() -- Destroy the UI
```

## 💡 Tips & Tricks

1. **Minimized Window**: Click quickly to restore, drag to move around
2. **Smooth Animations**: All section transitions are synchronized at 0.15s
3. **Toggle Effects**: Toggles have bounce animation and shadow effects
4. **Active Functions**: Toggle and keybind states appear in the floating panel
5. **Resizing**: Drag from bottom-right corner to resize (500x400 to 800x600)

## 🐛 Known Issues & Fixes

- ✅ Fixed: Minimized window dragging vs clicking detection
- ✅ Fixed: Synchronized fade animations for all elements
- ✅ Fixed: Toggle animations with smooth transitions
- ✅ Fixed: Proper transparency handling during section switches

## 📄 License

This UI library is created by the Eps1llon Hub Team. Feel free to use and modify for your projects.

---

Made with ❤️ by Eps1llon Hub Team | Last Updated: 2025-07-27
