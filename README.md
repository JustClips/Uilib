# UILib - Modern UI Library for Roblox Executors

A sleek and customizable UI library designed for Roblox script executors, featuring a modern design with smooth animations and comprehensive UI elements.

## Features

- 🎨 Modern, clean interface with customizable themes
- 🔄 Smooth animations and transitions
- 📱 Draggable windows
- 🎯 Multiple UI elements (buttons, toggles, sliders, dropdowns, etc.)
- 💾 Settings persistence
- 🎨 Color picker support
- 📝 Text input fields
- 🔔 Notification system

## Installation

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/UILib/main/Source.lua"))()
```

## Quick Start

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/UILib/main/Source.lua"))()

local Window = UILib:CreateWindow({
    Title = "My Script Hub",
    SubTitle = "v1.0.0",
    SaveFolder = "MyScriptConfig"
})

local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://123456789"
})

Tab:AddButton({
    Title = "Click Me!",
    Description = "This is a button",
    Callback = function()
        print("Button clicked!")
    end
})
```

## API Documentation

### Creating a Window

```lua
local Window = UILib:CreateWindow({
    Title = "Window Title",           -- Main title of the window
    SubTitle = "v1.0.0",             -- Subtitle (optional)
    SaveFolder = "ConfigFolder",      -- Folder name for saving settings
    IntroEnabled = true,              -- Enable intro animation (default: true)
    IntroText = "Welcome",            -- Intro text (optional)
    IntroIcon = "rbxassetid://...",  -- Intro icon (optional)
    Icon = "rbxassetid://...",        -- Window icon (optional)
    DisableUIToggle = false,          -- Disable UI toggle (default: false)
    Size = UDim2.new(0, 580, 0, 460), -- Window size (optional)
    Position = UDim2.new(...),        -- Window position (optional)
})
```

### Creating Tabs

```lua
local Tab = Window:CreateTab({
    Name = "Tab Name",
    Icon = "rbxassetid://123456789" -- Optional icon
})
```

### UI Elements

#### Button
```lua
Tab:AddButton({
    Title = "Button",
    Description = "Button description",
    Callback = function()
        print("Clicked!")
    end
})
```

#### Toggle
```lua
Tab:AddToggle({
    Title = "Toggle",
    Description = "Toggle description",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```

#### Slider
```lua
Tab:AddSlider({
    Title = "Slider",
    Description = "Adjust value",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 1,
    Callback = function(value)
        print("Slider:", value)
    end
})
```

#### Dropdown
```lua
Tab:AddDropdown({
    Title = "Dropdown",
    Description = "Select an option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = 1,
    Callback = function(value)
        print("Selected:", value)
    end
})
```

#### Color Picker
```lua
Tab:AddColorPicker({
    Title = "Color Picker",
    Description = "Choose a color",
    Default = Color3.new(1, 1, 1),
    Callback = function(color)
        print("Color:", color)
    end
})
```

#### Textbox
```lua
Tab:AddTextbox({
    Title = "Textbox",
    Description = "Enter text",
    Default = "Default text",
    PlaceholderText = "Type here...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

#### Bind
```lua
Tab:AddBind({
    Title = "Keybind",
    Description = "Set a keybind",
    Default = Enum.KeyCode.F,
    Hold = false,
    Callback = function()
        print("Key pressed!")
    end,
    UpdateBind = function(key)
        print("New bind:", key)
    end
})
```

#### Label
```lua
Tab:AddLabel({
    Title = "Label",
    Content = "This is a label"
})
```

#### Paragraph
```lua
Tab:AddParagraph({
    Title = "Paragraph Title",
    Content = "This is a longer text that can span multiple lines."
})
```

#### Section
```lua
local Section = Tab:AddSection({
    Title = "Section Title"
})

-- Add elements to section
Section:AddButton({...})
Section:AddToggle({...})
```

### Updating Elements

Most elements return an object that can be used to update their properties:

```lua
local Toggle = Tab:AddToggle({...})
Toggle:UpdateToggle(true) -- Update toggle state

local Slider = Tab:AddSlider({...})
Slider:UpdateSlider(75) -- Update slider value

local Dropdown = Tab:AddDropdown({...})
Dropdown:UpdateDropdown("Option 2") -- Update selected option
```

### Notifications

```lua
UILib:Notify({
    Title = "Notification",
    Content = "This is a notification!",
    Duration = 5
})
```

### Settings

The library automatically saves and loads settings based on the `SaveFolder` parameter. Settings are stored in the executor's workspace folder.

## Themes

The UI uses a dark theme by default with customizable accent colors. The color scheme includes:
- Background: Dark grays (#1C1C1C, #161616)
- Accent: Blue (#3B82F6)
- Text: White/Gray shades
- Success: Green
- Error: Red

## Tips

1. **Performance**: The library is optimized for performance with debounced callbacks and efficient rendering
2. **Mobile Support**: While primarily designed for PC, basic mobile support is included
3. **Customization**: Most visual properties can be customized through the element options
4. **Auto-save**: Toggle states, slider values, and other settings are automatically saved

## Credits

Created by JustClips for the Roblox scripting community.

## License

This project is open source and available for anyone to use and modify.
