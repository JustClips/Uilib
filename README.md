# Eps1llon Hub Premium UI Library

A modern, feature-rich UI library for Roblox with smooth animations, customizable themes, and a sleek design inspired by popular UI frameworks.

![Version](https://img.shields.io/badge/version-2.0-blue)
![Roblox](https://img.shields.io/badge/platform-Roblox-red)
![License](https://img.shields.io/badge/license-MIT-green)

## 🌟 Features

- **Modern Design**: Clean, minimalist interface with smooth animations
- **Fully Customizable**: Themes, fonts, colors, and more
- **Rayfield-style BigDropdowns**: Collapsible sections with preview functionality
- **Resizable & Draggable**: Windows can be resized and moved freely
- **Active Functions Display**: Track enabled features in real-time
- **Floating UI Settings**: Gear icon opens customizable settings panel
- **Multiple Themes**: Dark, Light, Purple, and Ocean themes included
- **Background Images**: Built-in scenic backgrounds
- **Responsive Elements**: All UI elements respond to hover and click
- **Section Headers**: Customizable headers with optional underlines
- **Minimize to Icon**: Minimize UI to a small draggable widget

## 📦 Installation

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Source.lua"))()
```

## 🚀 Quick Start

```lua
-- Create Window
local Window = Library:Create({
    Theme = "Ocean",           -- Dark, Light, Purple, Ocean
    Background = "Blue Sky",   -- Blue Sky, Mountains, Blurred Stars
    ToggleKey = Enum.KeyCode.RightShift,
    Font = "Ubuntu"           -- See font list below
})

-- Create Section
local MainSection = Window:CreateSection("Main")

-- Add Elements
Window:CreateButton(MainSection, {
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## 📖 Documentation

### Window Creation

```lua
local Window = Library:Create({
    Theme = "Ocean",                    -- Theme name (string)
    Background = "Blue Sky",            -- Background name (string)
    ToggleKey = Enum.KeyCode.RightShift, -- Toggle UI visibility key
    Font = "Ubuntu",                    -- Font name (string)
    ButtonDarkness = 0.5,              -- Button transparency (0-1)
    StrokeThickness = 1,               -- Border thickness (0-5)
    SectionHeaderEnabled = true,        -- Show section headers
    SectionHeaderWhite = false,        -- Make headers white
    HideUISettings = false,            -- Hide UI settings button
    SectionHeaderConfig = {
        Size = 22,                     -- Header text size
        Font = Enum.Font.GothamBold,   -- Header font
        Color = nil,                   -- Custom header color (optional)
        Position = "Center",           -- Left, Center, Right
        UnderlineEnabled = true,       -- Show underline
        UnderlineSize = 0.5,          -- Underline width (0-1)
        UnderlineThickness = 2         -- Underline height
    }
})
```

### Creating Sections

```lua
-- Basic section
local Section = Window:CreateSection("Section Name")

-- Section with custom header color
local ColoredSection = Window:CreateSection("Colored Section", Color3.fromRGB(255, 100, 100))
```

### UI Elements

#### Button
```lua
Window:CreateButton(Section, {
    Text = "Button Text",
    Callback = function()
        print("Clicked!")
    end
})
```

#### Toggle
```lua
Window:CreateToggle(Section, {
    Text = "Toggle Name",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```

#### Slider
```lua
Window:CreateSlider(Section, {
    Text = "Slider Name",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Value:", value)
    end
})
```

#### Input Box
```lua
Window:CreateInput(Section, {
    Text = "Input Name",
    Default = "Default Text",
    Placeholder = "Enter text...",
    Callback = function(text, enterPressed)
        print("Input:", text)
    end
})
```

#### Dropdown
```lua
Window:CreateDropdown(Section, {
    Text = "Dropdown Name",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

#### BigDropdown (Rayfield-style)
```lua
Window:CreateBigDropdown(Section, {
    Text = "Settings",
    CreateElements = function(dropdown)
        dropdown.AddToggle({
            Text = "Enable Feature",
            Default = true,
            Callback = function(value)
                print("Feature:", value)
            end
        })
        
        dropdown.AddSlider({
            Text = "Power",
            Min = 0,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("Power:", value)
            end
        })
        
        dropdown.AddButton({
            Text = "Reset",
            Callback = function()
                print("Reset!")
            end
        })
        
        dropdown.AddInput({
            Text = "Name",
            Default = "Player",
            Callback = function(text)
                print("Name:", text)
            end
        })
        
        dropdown.AddDropdown({
            Text = "Mode",
            Options = {"Easy", "Normal", "Hard"},
            Default = "Normal",
            Callback = function(mode)
                print("Mode:", mode)
            end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddLabel({
            Text = "Additional Options",
            Color = Color3.fromRGB(255, 255, 0)
        })
    end
})
```

#### Search Box
```lua
Window:CreateSearchBox(Section, {
    Placeholder = "Search players...",
    Items = {"Player1", "Player2", "Player3"},
    OnSelected = function(selected)
        print("Selected:", selected)
    end,
    OnSearch = function(query, items)
        -- Custom search logic (optional)
        local filtered = {}
        for _, item in pairs(items) do
            if item:lower():find(query) then
                table.insert(filtered, item)
            end
        end
        return filtered
    end
})
```

#### Keybind
```lua
Window:CreateKeybind(Section, {
    Text = "Keybind Name",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Key pressed!")
    end
})
```

#### Label
```lua
Window:CreateLabel(Section, {
    Text = "This is a label",
    Color = Color3.fromRGB(255, 255, 0)  -- Optional
})
```

#### Separator
```lua
Window:CreateSeparator(Section)
```

### Notifications

```lua
Window:Notify({
    Title = "Success",
    Text = "Operation completed successfully!",
    Duration = 3  -- Seconds (optional, default: 3)
})
```

### Available Themes
- `Dark` - Classic dark theme
- `Light` - Clean light theme  
- `Purple` - Purple accent theme
- `Ocean` - Blue ocean theme (default)

### Available Fonts
- `Ubuntu` (default)
- `Gotham`
- `GothamBold`
- `SourceSans`
- `SourceSansBold`
- `Code`
- `Highway`
- `SciFi`
- `Arial`
- `ArialBold`

### Available Backgrounds
- `Blue Sky` (default)
- `Mountains`
- `Blurred Stars`

### Methods

#### Change Theme
```lua
Window:SetTheme("Dark")
```

#### Change Background
```lua
Window:SetBackground("Mountains")
```

#### Change Font
```lua
Window:SetFont("GothamBold")
```

#### Change Toggle Key
```lua
Window:SetToggleKey(Enum.KeyCode.LeftAlt)
```

#### Add UI Settings to Any Section
```lua
Window:AddUISettingsToSection(Section)
```

#### Destroy UI
```lua
Window:Destroy()
```

## 🎨 Customization

### Button Darkness
Controls the transparency of buttons (0 = transparent, 1 = opaque)
```lua
Window:SetButtonDarkness(0.7)
```

### Stroke Thickness
Controls the border thickness of UI elements (0-5)
```lua
Window:SetStrokeThickness(2)
```

### Custom Section Headers
You can customize section headers globally during window creation or individually per section:
```lua
-- Global configuration
local Window = Library:Create({
    SectionHeaderConfig = {
        Size = 24,
        Font = Enum.Font.GothamBold,
        Color = Color3.fromRGB(255, 100, 100),
        Position = "Left",
        UnderlineEnabled = true,
        UnderlineSize = 0.8,
        UnderlineThickness = 3
    }
})

-- Per-section color
local Section = Window:CreateSection("Custom Section", Color3.fromRGB(100, 255, 100))
```

## 🔥 Advanced Features

### Active Functions Display
The library automatically tracks active toggles and keybinds in a floating panel that appears when features are enabled.

### UI Settings Panel
Click the gear icon in the title bar to open a floating settings panel where you can customize:
- Button darkness
- Stroke thickness
- Font
- Theme
- Background
- Section header settings

### Minimize Functionality
- Click the minimize button (-) to shrink the UI to a small draggable widget
- Click the minimized widget to restore the UI
- The UI remembers its size when restored

### Dynamic BigDropdown Updates
BigDropdowns show a preview of their first element's state:
- Toggles show "Enabled/Disabled"
- Sliders show their current value
- Inputs show their text content
- Dropdowns show the selected option

## 📝 Example Script

See `example.lua` for a complete implementation example.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License.

## 👤 Credits

Created by Eps1llon
- Inspired by popular UI libraries like Rayfield, Orion, and others
- Built with performance and user experience in mind

---

**Note**: This library is for educational purposes. Always respect game rules and terms of service when using UI libraries.
