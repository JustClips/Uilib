# Uilib Examples Usage Guide

## 🚀 Quick Start

### Option 1: Comprehensive Demo (Recommended)
Shows ALL components with detailed examples and documentation:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/UilibExample.lua"))()
```

### Option 2: Compact Demo  
Smaller interface perfect for tight spaces:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/CompactExample.lua"))()
```

## 📋 What Each Example Shows

### UilibExample.lua (Comprehensive)
- **5 Sections** with organized components
- **18 Interactive elements** with working callbacks
- **All 8 component types** demonstrated
- **Theme switching** with 4 themes
- **Advanced features** like notifications
- **Complete documentation** in comments
- **Real-world examples** you can copy

**Components Demonstrated:**
- ✅ Buttons (Standard, Action, Multi-action)
- ✅ Toggles (Basic, Feature, Advanced mode)
- ✅ Sliders (Speed, Volume, Precision)
- ✅ Inputs (Username, Player ID, Config)
- ✅ Dropdowns (Game mode, Difficulty, Themes)
- ✅ Search boxes (Players, Items)
- ✅ Labels (Status, Section headers, Color variants)
- ✅ Separators (Section dividers)

### CompactExample.lua (Compact)
- **4 Sections** with essential components  
- **8 Interactive elements** with callbacks
- **Smaller GUI** (480x360) for space efficiency
- **Quick demo** of all component types
- **Perfect for integration** into existing scripts

## 🎮 Interactive Features

Both examples include:

### Working Callbacks
Every component has functional callbacks that demonstrate:
- Button click handling
- Toggle state changes  
- Slider value updates
- Input text processing
- Dropdown selections
- Search functionality

### Live Notifications
- Welcome messages
- Action confirmations
- Status updates
- Progress indicators

### Theme Switching
Switch between 4 themes in real-time:
- **Dark** - Modern dark with blue accents
- **Light** - Clean light theme
- **Purple** - Dark with purple highlights  
- **Ocean** - Blue-tinted ocean theme

### Window Management
- Drag to move
- Resize with handles
- Minimize/restore
- Responsive layout

## 💡 Usage Tips

### For Learning
1. Start with `UilibExample.lua` to see all features
2. Examine the code structure and comments
3. Copy component examples for your own projects
4. Experiment with different themes

### For Development
1. Use `CompactExample.lua` as a template
2. Replace demo callbacks with your actual logic
3. Customize the GUI size as needed
4. Add/remove sections based on your needs

### Common Patterns

#### Basic Script Structure
```lua
local Library = loadstring(game:HttpGet("..."))()
local GUI = Library:Create({Theme = "Dark"})

local Section = GUI:CreateSection("My Section")

-- Add your components
GUI:CreateButton(Section, {
    Text = "My Button",
    Callback = function()
        -- Your code here
    end
})
```

#### Notification Pattern
```lua
local function notify(title, message)
    spawn(function()
        GUI:Notify({
            Title = title,
            Text = message,
            Duration = 3
        })
    end)
end
```

#### Input Validation Pattern
```lua
GUI:CreateInput(section, {
    Text = "Number Input",
    Callback = function(text, enterPressed)
        if enterPressed then
            local num = tonumber(text)
            if num then
                -- Valid number
                notify("Success", "Number: " .. num)
            else
                -- Invalid input
                notify("Error", "Please enter a valid number")
            end
        end
    end
})
```

## 🔧 Customization

### GUI Size
```lua
-- After creating the GUI
GUI.MainFrame.Size = UDim2.new(0, width, 0, height)
GUI.MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
```

### Themes
```lua
-- Change theme anytime
GUI:SetTheme("Purple")
```

### Component Organization
- Use sections to group related components
- Add separators between different types
- Use labels as headers for clarity

## 📚 More Examples

Check the README.md for additional templates and patterns for common use cases like game hacks, utility scripts, and more.

## 🐛 Troubleshooting

### Common Issues
1. **Library won't load**: Check internet connection and URL
2. **Components not showing**: Ensure section is created first
3. **Callbacks not working**: Check function syntax
4. **GUI too big/small**: Adjust MainFrame.Size

### Getting Help
- Read the component documentation in README.md
- Study the example code comments
- Test with the validation script