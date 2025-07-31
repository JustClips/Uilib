# Eps1llon Hub - Roblox UI Library

![Eps1llon Hub Logo](https://example.com/logo.png) <!-- Replace with actual logo if available, e.g., from rbxassetid in code -->

Eps1llon Hub is a modern, customizable, and mobile-friendly UI library for Roblox scripts. It provides a sleek interface with support for themes (Dark, Light, Purple, Ocean), fonts, backgrounds, and various UI elements like buttons, toggles, sliders, and more. The library includes dragging, resizing (desktop only), keybind toggling, notifications, and a built-in settings panel for runtime customization. It's designed for exploit scripts, with transparency effects, animations, and mobile detection for optimal usability across devices.

Key features:
- **Themes and Customization**: Pre-built themes, adjustable button darkness, stroke thickness, fonts, and backgrounds.
- **Mobile Support**: Touch-enabled dragging, visible scrollbars, and no resizing on mobile.
- **Elements**: Buttons, toggles, sliders, inputs, dropdowns, labels, separators, keybinds, search boxes, and big dropdowns (expandable containers for nested elements).
- **Advanced**: Notifications, section headers, big dropdowns for grouping elements, and a floating settings panel.
- **Compatibility**: Works in CoreGui for broad exploit support (e.g., Synapse, Fluxus, Krnl).

## Installation

To load the library in your Roblox script, use Roblox's `HttpGet` function to fetch the raw source from GitHub:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Source.lua"))()
```

This method is exploit-safe and works in most environments like Synapse, Fluxus, etc. Ensure your exploit allows HTTP requests.

## Initialization

After loading, create a UI instance with `Library:Create(config)`. The `config` table is optional but allows customization.

### Config Parameters for `Library:Create(config)`
- `Theme` (string): Theme name. Options: "Dark", "Light", "Purple", "Ocean". Default: "Ocean".
- `ToggleKey` (Enum.KeyCode): Key to toggle UI visibility. Default: Enum.KeyCode.RightShift (desktop only).
- `Background` (string): Background image name. Options: "Blue Sky", "Mountains", "Blurred Stars". Default: "Blue Sky".
- `Font` (string): Font name. Options: "Ubuntu", "Gotham", "GothamBold", "SourceSans", "SourceSansBold", "Code", "Highway", "SciFi", "Arial", "ArialBold". Default: "Ubuntu".
- `ButtonDarkness` (number): Background transparency for buttons/elements (0-1). Default: 0.5.
- `StrokeThickness` (number): Border stroke width (0-5). Default: 1.
- `SectionHeaderEnabled` (boolean): Show section headers in content area. Default: true.
- `HideUISettings` (boolean): Hide the settings button and panel. Default: false.
- `ElementSizes` (table): Custom heights for elements. Example: `{Button = 35, Toggle = 35, Slider = 55, Input = 35, Dropdown = 35, Label = 25, BigDropdown = 40, Spacing = 8}`. Defaults shown.
- `SectionHeaderConfig` (table): Customize section headers. `{Size = 22, Font = Enum.Font.GothamBold, Color = Color3.fromRGB(255,255,255), Position = "Center"}` (Position: "Center", "Left", "Right").

### Example Initialization
```lua
local ui = Library:Create({
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.F1,
    Background = "Mountains",
    Font = "Gotham",
    ButtonDarkness = 0.3,
    StrokeThickness = 2,
    SectionHeaderEnabled = true,
    HideUISettings = false,
    ElementSizes = {Button = 40, Spacing = 10},
    SectionHeaderConfig = {Size = 24, Position = "Left"}
})
```

This creates a draggable, resizable (desktop) window in CoreGui. Press the toggle key to show/hide it.

## Creating Sections

Sections are tabs in the left sidebar. Use `ui:CreateSection(name, customColor, iconAsset)` to add one.

### Parameters
- `name` (string): Section name (required).
- `customColor` (Color3): Custom color for section header (optional).
- `iconAsset` (string): Roblox asset ID for icon (e.g., "rbxassetid://123456") (optional).

Returns a `section` table for adding elements.

### Example
```lua
local section1 = ui:CreateSection("General", Color3.fromRGB(255, 0, 0), "rbxassetid://86509207249522")
```

Sections auto-highlight on selection. The first section is selected by default.

## UI Components

All elements are added to a section via `ui:CreateElement(section, config)`. Each returns an object for manipulation (e.g., updating values).

### Button: `ui:CreateButton(section, config)`
A clickable button with animation and callback.

#### Config Parameters
- `Text` (string): Button text. Default: "Button".
- `Callback` (function): Called on click.

#### Example
```lua
local button = ui:CreateButton(section1, {
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

### Toggle: `ui:CreateToggle(section, config)`
A switch with on/off state.

#### Config Parameters
- `Text` (string): Label text. Default: "Toggle".
- `Default` (boolean): Initial state. Default: false.
- `Callback` (function(value)): Called with new state (true/false).

#### Methods
- `toggle:Set(value)`: Set state programmatically.

#### Example
```lua
local toggle = ui:CreateToggle(section1, {
    Text = "Enable Feature",
    Default = true,
    Callback = function(enabled)
        print("Toggle:", enabled)
    end
})

toggle:Set(false)  -- Update state
```

### Slider: `ui:CreateSlider(section, config)`
A draggable slider for numeric values.

#### Config Parameters
- `Text` (string): Label text. Default: "Slider".
- `Min` (number): Minimum value. Default: 0.
- `Max` (number): Maximum value. Default: 100.
- `Default` (number): Initial value.
- `Callback` (function(value)): Called on change.

#### Example
```lua
local slider = ui:CreateSlider(section1, {
    Text = "Speed",
    Min = 1,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})
```

### Input: `ui:CreateInput(section, config)`
A text input box.

#### Config Parameters
- `Text` (string): Label text. Default: "Input".
- `Default` (string): Initial text.
- `Placeholder` (string): Placeholder text.
- `Callback` (function(text, enterPressed)): Called on focus lost, with text and if Enter was pressed.

#### Example
```lua
local input = ui:CreateInput(section1, {
    Text = "Username",
    Placeholder = "Enter name...",
    Callback = function(text, enter)
        print("Input:", text, "Enter pressed:", enter)
    end
})
```

### Dropdown: `ui:CreateDropdown(section, config)`
A selectable dropdown list.

#### Config Parameters
- `Text` (string): Label text. Default: "Dropdown".
- `Options` (table): Array of strings.
- `Default` (string): Initial selection.
- `Callback` (function(selected)): Called on selection.

#### Example
```lua
local dropdown = ui:CreateDropdown(section1, {
    Text = "Choose Option",
    Options = {"Option1", "Option2", "Option3"},
    Default = "Option1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

### Label: `ui:CreateLabel(section, config)`
A static text label.

#### Config Parameters
- `Text` (string): Label text. Default: "Label".
- `Color` (Color3): Text color. Default: Theme.Text.

#### Example
```lua
ui:CreateLabel(section1, {
    Text = "Info: This is a label",
    Color = Color3.fromRGB(255, 0, 0)
})
```

### Separator: `ui:CreateSeparator(section)`
A horizontal divider line. No config.

#### Example
```lua
ui:CreateSeparator(section1)
```

### Keybind: `ui:CreateKeybind(section, config)`
A keybind trigger.

#### Config Parameters
- `Text` (string): Label text. Default: "Keybind".
- `Default` (Enum.KeyCode): Initial key. Default: Enum.KeyCode.F.
- `Callback` (function): Called on key press.

#### Example
```lua
ui:CreateKeybind(section1, {
    Text = "Activate",
    Default = Enum.KeyCode.E,
    Callback = function()
        print("Key pressed!")
    end
})
```

### Search Box: `ui:CreateSearchBox(section, config)`
A searchable input with results dropdown.

#### Config Parameters
- `Placeholder` (string): Placeholder text.
- `Items` (table): Array of searchable items.
- `OnSearch` (function(query, items)): Custom filter function (returns filtered table).
- `OnSelected` (function(selected)): Called on selection.

#### Methods
- `search:UpdateItems(newItems)`: Update searchable items.

#### Example
```lua
local search = ui:CreateSearchBox(section1, {
    Placeholder = "Search items...",
    Items = {"Apple", "Banana", "Cherry"},
    OnSelected = function(selected)
        print("Selected:", selected)
    end,
    OnSearch = function(query, items)  -- Optional custom filter
        local filtered = {}
        for _, item in items do
            if item:lower():find(query:lower()) then
                table.insert(filtered, item)
            end
        end
        return filtered
    end
})

search:UpdateItems({"Date", "Elderberry"})  -- Dynamic update
```

### Big Dropdown: `ui:CreateBigDropdown(section, config)`
An expandable container for nested elements (like a collapsible section).

#### Config Parameters
- `Text` (string): Header text. Default: "Dropdown".
- `CreateElements` (function(bigDropdown)): Callback to add nested elements.

#### Methods (for adding nested elements)
- `bigDropdown:AddToggle(config)`
- `bigDropdown:AddSlider(config)`
- `bigDropdown:AddButton(config)`
- `bigDropdown:AddInput(config)`
- `bigDropdown:AddLabel(config)`
- `bigDropdown:AddDropdown(config)`
- `bigDropdown:AddSeparator()`

Configs match their respective elements.

#### Example
```lua
local bigDropdown = ui:CreateBigDropdown(section1, {
    Text = "Advanced Settings",
    CreateElements = function(dd)
        dd:AddToggle({
            Text = "Nested Toggle",
            Callback = function(v) print(v) end
        })
        dd:AddSlider({
            Text = "Nested Slider",
            Min = 0, Max = 10,
            Callback = function(v) print(v) end
        })
        dd:AddSeparator()
        dd:AddButton({
            Text = "Nested Button",
            Callback = function() print("Clicked") end
        })
    end
})
```

## Additional Methods

- `ui:SetTheme(themeName)`: Change theme (e.g., "Dark").
- `ui:SetButtonDarkness(darkness)`: Set element transparency (0-1).
- `ui:SetStrokeThickness(thickness)`: Set border width (0-5).
- `ui:SetFont(fontName)`: Change font.
- `ui:SetToggleKey(keyCode)`: Change toggle key.
- `ui:SetBackground(backgroundName)`: Change background image.
- `ui:Notify(config)`: Show notification. Config: `{Title, Text, Duration}`.
- `ui:Destroy()`: Remove UI.

The settings panel (gear icon) allows runtime changes to these.

## Complete Example Script

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Source.lua"))()

local ui = Library:Create({
    Theme = "Ocean",
    ToggleKey = Enum.KeyCode.RightAlt,
    Background = "Blurred Stars"
})

local section1 = ui:CreateSection("Main", nil, "rbxassetid://86509207249522")
local section2 = ui:CreateSection("Settings")

ui:CreateButton(section1, {
    Text = "Test Button",
    Callback = function()
        ui:Notify({Title = "Success", Text = "Button clicked!", Duration = 5})
    end
})

ui:CreateToggle(section1, {
    Text = "Auto Farm",
    Default = false,
    Callback = function(enabled)
        print("Auto Farm:", enabled)
    end
})

ui:CreateSlider(section1, {
    Text = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

ui:CreateBigDropdown(section2, {
    Text = "Customization",
    CreateElements = function(dd)
        dd:AddDropdown({
            Text = "Theme",
            Options = {"Dark", "Light", "Purple", "Ocean"},
            Callback = function(theme)
                ui:SetTheme(theme)
            end
        })
        dd:AddSeparator()
        dd:AddSlider({
            Text = "Darkness",
            Min = 0,
            Max = 100,
            Callback = function(v)
                ui:SetButtonDarkness(v / 100)
            end
        })
    end
})

ui:CreateSearchBox(section2, {
    Placeholder = "Search Fonts",
    Items = {"Ubuntu", "Gotham", "Arial"},
    OnSelected = function(font)
        ui:SetFont(font)
    end
})
```

This creates a UI with two sections, various elements, and a big dropdown.

## Best Practices and Tips

- **Exploit Compatibility**: Test in your exploit (e.g., Synapse supports CoreGui fully; Fluxus may need HTTP enabled). Avoid installing packages—everything is self-contained.
- **Performance**: Limit elements per section to avoid lag. Use `ui:Destroy()` when done.
- **Mobile Users**: The library auto-detects mobile for touch support. Avoid resize-dependent features.
- **Customization**: Use the settings panel for testing themes/fonts. For production, hardcode configs.
- **Security**: Don't expose callbacks to user input. Use notifications for feedback.
- **Debugging**: If UI doesn't appear, check for errors in `loadstring` or conflicts with other GUIs.
- **Advanced**: For dynamic updates, store element objects (e.g., `toggle:Set(true)`). Big dropdowns are great for organizing complex UIs.

For issues or contributions, visit the [GitHub repo](https://github.com/JustClips/Uilib). Enjoy building! 🚀
