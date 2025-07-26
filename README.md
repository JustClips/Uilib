# Uilib - Modern Roblox UI Library

A modern, sleek UI library for Roblox with smooth animations, multiple themes, and comprehensive component support.

## Features

- **Modern Design**: Clean, professional interface with smooth animations
- **Multiple Themes**: Dark, Light, Purple, and Ocean themes
- **Resizable & Draggable**: Fully interactive window management
- **Comprehensive Components**: All essential UI elements included
- **Easy to Use**: Simple API for quick integration

## Quick Start

### Loading the Library

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()
```

### Basic Usage

```lua
-- Create window
local Window = Library:Create({
    Theme = "Dark" -- "Dark", "Light", "Purple", "Ocean"
})

-- Create section
local Section = Window:CreateSection("My Section")

-- Add components
Window:CreateButton(Section, {
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## Complete Example

Load the comprehensive example that demonstrates ALL components:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/UilibExample.lua"))()
```

## Available Components

### Button
```lua
Window:CreateButton(section, {
    Text = "Button Text",
    Callback = function()
        -- Button click logic
    end
})
```

### Toggle/Switch
```lua
Window:CreateToggle(section, {
    Text = "Toggle Text",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```

### Slider
```lua
Window:CreateSlider(section, {
    Text = "Slider Text",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider:", value)
    end
})
```

### Text Input
```lua
Window:CreateInput(section, {
    Text = "Input Label",
    Placeholder = "Enter text...",
    Default = "",
    Callback = function(text, enterPressed)
        print("Input:", text)
    end
})
```

### Dropdown
```lua
Window:CreateDropdown(section, {
    Text = "Dropdown Label",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

### Search Box
```lua
Window:CreateSearchBox(section, {
    Placeholder = "Search...",
    Items = {"Item 1", "Item 2", "Item 3"},
    Callback = function(selected)
        print("Found:", selected)
    end
})
```

### Label
```lua
Window:CreateLabel(section, {
    Text = "Label Text",
    Color = Color3.fromRGB(255, 255, 255) -- Optional
})
```

### Separator
```lua
Window:CreateSeparator(section)
```

## Window Management

### Themes
```lua
Window:SetTheme("Dark")   -- Dark theme
Window:SetTheme("Light")  -- Light theme  
Window:SetTheme("Purple") -- Purple theme
Window:SetTheme("Ocean")  -- Ocean theme
```

### Notifications
```lua
Window:Notify({
    Title = "Notification Title",
    Text = "Notification message",
    Duration = 3 -- seconds
})
```

### Window Controls
```lua
Window:Minimize() -- Minimize window
Window:Restore()  -- Restore window
Window:Destroy()  -- Close/destroy window
```

## Example Projects

### Simple Script Template
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()
local Window = Library:Create({Theme = "Dark"})

local MainSection = Window:CreateSection("Main")

-- Your components here
Window:CreateButton(MainSection, {
    Text = "Execute",
    Callback = function()
        -- Your code here
    end
})
```

### Game Hack Template
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()
local Window = Library:Create({Theme = "Ocean"})

-- Player section
local PlayerSection = Window:CreateSection("Player")

Window:CreateSlider(PlayerSection, {
    Text = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

Window:CreateToggle(PlayerSection, {
    Text = "No Clip",
    Default = false,
    Callback = function(enabled)
        -- No clip logic
    end
})

-- Visual section
local VisualSection = Window:CreateSection("Visual")

Window:CreateButton(VisualSection, {
    Text = "Full Bright",
    Callback = function()
        -- Full bright logic
    end
})
```

## Customization

### Window Size
```lua
local Window = Library:Create()
Window.MainFrame.Size = UDim2.new(0, 600, 0, 400) -- Custom size
Window.MinSize = Vector2.new(400, 300) -- Minimum size
Window.MaxSize = Vector2.new(800, 600) -- Maximum size
```

### Component Styling
Components automatically adapt to the selected theme. Use `Window:SetTheme()` to change themes dynamically.

## Browser Compatibility

This library is designed for Roblox and requires:
- Roblox Studio or Roblox Player
- Script execution environment (client-side)

## License

This project is open source and available under the MIT License.