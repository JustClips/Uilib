# Eps1llon Hub Premium UI Library

A modern, feature-rich UI library for Roblox with smooth animations, customizable themes, and a sleek design inspired by popular UI frameworks.

![Version](https://img.shields.io/badge/version-2.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Roblox-red.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

- 🎨 **Multiple Themes** - Dark, Light, Purple, and Ocean themes
- 🖼️ **Background Images** - Built-in backgrounds with easy customization
- 🎯 **Smooth Animations** - Fluid transitions and hover effects
- 📱 **Resizable Interface** - Drag to resize with min/max limits
- 🔧 **Customizable Elements** - Adjust button darkness, stroke thickness, fonts
- 📊 **Active Functions Display** - Track enabled features in real-time
- ⚙️ **UI Settings Panel** - Built-in settings for live customization
- 🎭 **Section Headers** - Customizable headers with underlines
- 🔍 **Search Box** - Dynamic search with filtering
- 📦 **Big Dropdowns** - Rayfield-style expandable containers

## Installation

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/Eps1llonHub/main/Library.lua"))()


-- Create the main window
local Window = Library:Create({
    Theme = "Ocean",              -- Dark, Light, Purple, Ocean
    Background = "Blue Sky",      -- Blue Sky, Mountains, Blurred Stars
    ToggleKey = Enum.KeyCode.RightShift,
    ButtonDarkness = 0.5,         -- 0-1 (0 = transparent, 1 = opaque)
    StrokeThickness = 1,          -- 0-5
    Font = "Ubuntu",              -- Ubuntu, Gotham, Arial, etc.
    SectionHeaderEnabled = true,
    SectionHeaderWhite = false,
    HideUISettings = false
})

-- Create a section
local MainSection = Window:CreateSection("Main Features")

-- Add elements
Window:CreateButton(MainSection, {
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})


Window:CreateButton(section, {
    Text = "Button Name",
    Callback = function()
        -- Your code here
    end
})


local toggle = Window:CreateToggle(section, {
    Text = "Toggle Name",
    Default = false,
    Callback = function(value)
        print("Toggle is now:", value)
    end
})

-- Set toggle programmatically
toggle.Set(true)


Window:CreateSlider(section, {
    Text = "Slider Name",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})


Window:CreateInput(section, {
    Text = "Input Name",
    Default = "Default Text",
    Placeholder = "Enter text...",
    Callback = function(text, enterPressed)
        print("Input:", text, "Enter pressed:", enterPressed)
    end
})


Window:CreateDropdown(section, {
    Text = "Dropdown Name",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})


local searchBox = Window:CreateSearchBox(section, {
    Placeholder = "Search players...",
    Items = {"Player1", "Player2", "Player3"},
    OnSelected = function(selected)
        print("Selected:", selected)
    end,
    OnSearch = function(searchText, items)
        -- Custom search logic (optional)
        local filtered = {}
        for _, item in pairs(items) do
            if item:lower():find(searchText) then
                table.insert(filtered, item)
            end
        end
        return filtered
    end
})

-- Update items dynamically
searchBox.UpdateItems({"NewPlayer1", "NewPlayer2"})


Window:CreateBigDropdown(section, {
    Text = "Advanced Settings",
    CreateElements = function(dropdown)
        dropdown.AddToggle({
            Text = "Enable Feature",
            Default = true,
            Callback = function(value)
                print("Feature enabled:", value)
            end
        })
        
        dropdown.AddSlider({
            Text = "Power Level",
            Min = 0,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("Power:", value)
            end
        })
        
        dropdown.AddButton({
            Text = "Apply Settings",
            Callback = function()
                print("Settings applied!")
            end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddInput({
            Text = "Custom Name",
            Placeholder = "Enter name...",
            Callback = function(text)
                print("Name set to:", text)
            end
        })
    end
})



Window:CreateLabel(section, {
    Text = "This is a label",
    Color = Color3.fromRGB(255, 255, 0)  -- Optional custom color
})


Window:CreateSeparator(section)


Window:CreateKeybind(section, {
    Text = "Toggle UI",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Keybind pressed!")
    end
})


Window:SetTheme("Dark")  -- Dark, Light, Purple, Ocean


Window:SetBackground("Mountains")  -- Blue Sky, Mountains, Blurred Stars


Window:SetButtonDarkness(0.7)    -- 0-1
Window:SetStrokeThickness(2)     -- 0-5
Window:SetFont("Gotham")         -- Font name
Window:SetToggleKey(Enum.KeyCode.Tab)  -- Change toggle key



-- Create section with custom header color
local section = Window:CreateSection("VIP Section", Color3.fromRGB(255, 215, 0))

-- Configure section headers globally
Window.SectionHeaderConfig = {
    Size = 24,
    Font = Enum.Font.GothamBold,
    Position = "Center",  -- Center, Left, Right
    UnderlineEnabled = true,
    UnderlineSize = 0.5,  -- 0-1 (percentage of width)
    UnderlineThickness = 2
}



Window:Notify({
    Title = "Success",
    Text = "Operation completed successfully!",
    Duration = 3  -- Seconds
})


|
Window:Minimize() - Minimize the UI
Window:Restore() - Restore from minimized state
Window:ToggleUI() - Toggle UI visibility
Window:Destroy() - Completely remove the UI
