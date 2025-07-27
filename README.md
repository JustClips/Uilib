# Eps1llon Hub Premium UI Library

A modern, sleek Roblox UI library with smooth animations, resizable interface, and comprehensive features. Features a floating active functions display, multiple themes, and intuitive drag-and-drop functionality.

## ✨ Features

- **Modern Design**: Clean, professional interface with smooth animations
- **Multiple Themes**: Dark, Light, Purple, and Ocean themes
- **Resizable Interface**: Drag corners to resize the main window
- **Draggable Windows**: Move windows by dragging the title bar
- **Active Functions Display**: Floating sidebar showing currently active toggles/keybinds
- **Click Indicators**: Visual indicators on clickable buttons (👆)
- **Minimizable**: Minimize to a compact floating window
- **Notification System**: Built-in notifications with auto-dismiss
- **Comprehensive Elements**: Buttons, toggles, sliders, inputs, dropdowns, search boxes, and more

## 🚀 Installation

1. Copy the library code to a ModuleScript
2. Place the ModuleScript in ReplicatedStorage or ServerStorage
3. Require the module in your script

```lua
local Library = require(game.ReplicatedStorage.Eps1llonHubLibrary)
```

## 📖 Basic Usage

### Creating a Main Window

```lua
-- Load the library
local Library = require(game.ReplicatedStorage.Eps1llonHubLibrary)

-- Create the main window with configuration
local Window = Library:Create({
    Theme = "Ocean" -- Available: "Dark", "Light", "Purple", "Ocean"
})
```

### Creating Sections

Sections are categories that organize your UI elements:

```lua
-- Create sections for organizing elements
local MainSection = Window:CreateSection("Main")
local SettingsSection = Window:CreateSection("Settings")
local UtilsSection = Window:CreateSection("Utils")
```

## 🎮 UI Elements

### Buttons

Clickable buttons with visual feedback and click indicators (👆):

```lua
MainSection:CreateButton({
    Text = "Click Me!",
    Callback = function()
        print("Button was clicked!")
        Window:Notify({
            Title = "Success",
            Text = "Button activated!",
            Duration = 2
        })
    end
})
```

### Toggles

On/off switches that maintain state:

```lua
local espEnabled = false

SettingsSection:CreateToggle({
    Text = "ESP",
    Default = false,
    Callback = function(value)
        espEnabled = value
        print("ESP is now:", value and "enabled" or "disabled")
    end
})
```

### Sliders

Numeric value selectors with visual feedback:

```lua
local walkSpeed = 16

MainSection:CreateSlider({
    Text = "Walk Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Callback = function(value)
        walkSpeed = value
        -- Apply walk speed to character
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})
```

### Input Boxes

Text input fields for user data:

```lua
UtilsSection:CreateInput({
    Text = "Player Name",
    Placeholder = "Enter username...",
    Default = "",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Searching for player:", text)
            -- Add your player search logic here
        end
    end
})
```

### Dropdowns

Selection menus with multiple options:

```lua
local selectedWeapon = "None"

MainSection:CreateDropdown({
    Text = "Weapon",
    Options = {"None", "Sword", "Bow", "Staff", "Dagger"},
    Default = "None",
    Callback = function(option)
        selectedWeapon = option
        print("Selected weapon:", option)
        -- Add weapon switching logic here
    end
})
```

### Search Boxes

Interactive search with live filtering:

```lua
local playerNames = {"Player1", "Player2", "Player3", "TestUser", "GameMaster"}

UtilsSection:CreateSearchBox({
    Placeholder = "Search players...",
    Items = playerNames,
    Callback = function(selectedPlayer)
        print("Selected player:", selectedPlayer)
        -- Add player selection logic here
    end
})
```

### Labels

Display-only text elements:

```lua
SettingsSection:CreateLabel({
    Text = "Version: 1.0.0",
    Color = Color3.fromRGB(100, 200, 255) -- Optional custom color
})
```

### Separators

Visual dividers between elements:

```lua
SettingsSection:CreateSeparator()
```

### Keybinds

Key-activated functions:

```lua
MainSection:CreateKeybind({
    Text = "Toggle GUI",
    Default = Enum.KeyCode.F,
    Callback = function()
        -- Toggle GUI visibility
        Window.MainFrame.Visible = not Window.MainFrame.Visible
    end
})
```

## 🎨 Theme System

Change themes dynamically:

```lua
-- Available themes: "Dark", "Light", "Purple", "Ocean"
Window:SetTheme("Purple")
```

### Theme Colors

Each theme includes:
- **Background**: Main window background
- **Secondary**: Element backgrounds
- **Tertiary**: Input field backgrounds
- **Accent**: Highlight and active colors
- **Text**: Primary text color
- **TextDark**: Secondary text color
- **Border**: Border and divider colors

## 📢 Notifications

Display temporary messages to users:

```lua
Window:Notify({
    Title = "Information",
    Text = "This is a notification message!",
    Duration = 3 -- seconds (optional, default is 3)
})
```

## 🎯 Advanced Features

### Active Functions Display

The library automatically tracks active toggles and keybinds in a floating sidebar. This shows users what features are currently enabled.

### Window Controls

- **Minimize**: Click the "—" button to minimize to a floating icon
- **Close**: Click the "×" button to destroy the GUI
- **Resize**: Drag the bottom-right corner to resize the window
- **Move**: Drag the title bar to move the window

### Programmatic Control

```lua
-- Minimize the window
Window:Minimize()

-- Restore from minimized state
Window:Restore()

-- Destroy the GUI completely
Window:Destroy()

-- Add/remove active functions manually
Window:AddActiveFunction("Custom Feature")
Window:RemoveActiveFunction("Custom Feature")
```

## 📝 Complete Example

Here's a full example script showing all features:

```lua
-- Load the library
local Library = require(game.ReplicatedStorage.Eps1llonHubLibrary)

-- Create main window
local Window = Library:Create({
    Theme = "Ocean"
})

-- Create sections
local MainSection = Window:CreateSection("Main")
local CombatSection = Window:CreateSection("Combat")
local SettingsSection = Window:CreateSection("Settings")

-- Main section elements
MainSection:CreateButton({
    Text = "Teleport to Spawn",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            Window:Notify({
                Title = "Teleported",
                Text = "Moved to spawn location!"
            })
        end
    end
})

MainSection:CreateSlider({
    Text = "Walk Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

MainSection:CreateToggle({
    Text = "Infinite Jump",
    Default = false,
    Callback = function(enabled)
        -- Add infinite jump logic here
        print("Infinite Jump:", enabled)
    end
})

-- Combat section
CombatSection:CreateDropdown({
    Text = "Target Player",
    Options = {"None", "Player1", "Player2", "Player3"},
    Default = "None",
    Callback = function(target)
        print("Target set to:", target)
    end
})

CombatSection:CreateKeybind({
    Text = "Auto Attack",
    Default = Enum.KeyCode.X,
    Callback = function()
        print("Auto attack activated!")
    end
})

-- Settings section
SettingsSection:CreateLabel({
    Text = "GUI Settings",
    Color = Color3.fromRGB(100, 200, 255)
})

SettingsSection:CreateSeparator()

SettingsSection:CreateDropdown({
    Text = "Theme",
    Options = {"Dark", "Light", "Purple", "Ocean"},
    Default = "Ocean",
    Callback = function(theme)
        Window:SetTheme(theme)
        Window:Notify({
            Title = "Theme Changed",
            Text = "Switched to " .. theme .. " theme!"
        })
    end
})

SettingsSection:CreateInput({
    Text = "Custom Title",
    Placeholder = "Enter new title...",
    Callback = function(text, enterPressed)
        if enterPressed and text ~= "" then
            Window.Title.Text = text
        end
    end
})

-- Search box example
local searchItems = {"Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig"}
SettingsSection:CreateSearchBox({
    Placeholder = "Search fruits...",
    Items = searchItems,
    Callback = function(fruit)
        Window:Notify({
            Title = "Selected",
            Text = "You chose: " .. fruit
        })
    end
})

print("Eps1llon Hub loaded successfully!")
```

## 🔧 Customization Tips

1. **Organize Logically**: Group related functions into sections
2. **Use Descriptive Names**: Make button and toggle names clear
3. **Provide Feedback**: Use notifications to confirm actions
4. **Set Reasonable Defaults**: Choose sensible default values for sliders and toggles
5. **Handle Errors**: Add error checking in your callbacks

## 🐛 Troubleshooting

**GUI not appearing?**
- Check that the library is properly required
- Ensure you're calling `Library:Create()`

**Elements not working?**
- Verify callback functions are properly defined
- Check for syntax errors in your callbacks

**Performance issues?**
- Avoid complex operations in slider callbacks
- Use debouncing for frequently-called functions

## 📄 License

This library is free to use and modify for your Roblox projects.

---

**Created by Eps1llon Hub Development Team**
