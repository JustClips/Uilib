# Eps1llon Hub UI Library - Compact Edition

A modern, compact UI library for Roblox with comprehensive component showcase and significantly reduced GUI size.

## 🎯 New Features

### ✨ Compact Design
- **Reduced GUI size**: From 650x450 to 380x320 pixels (42% smaller!)
- **Optimized components**: All elements redesigned for compact layout
- **Better space utilization**: More components fit in smaller space
- **Maintained usability**: All functionality preserved in smaller form factor

### 🧩 Complete Component Showcase
This library now includes comprehensive examples demonstrating **ALL 8 UI components**:

1. **🔘 Buttons** - Interactive action triggers with hover effects
2. **🔄 Toggles** - On/off switches with smooth animations  
3. **📊 Sliders** - Value selection with custom ranges (0-100, 1-10, etc.)
4. **📝 Input Boxes** - Text fields with placeholders and validation
5. **📋 Dropdowns** - Selection menus with expandable options
6. **🔍 Search Boxes** - Filterable lists with real-time search
7. **📄 Labels** - Information display with custom styling and colors
8. **➖ Separators** - Visual dividers for content organization

## 📚 Usage Examples

### Quick Start (Compact Demo)
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/compact_demo.lua"))()
```

### Full Component Showcase
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/example.lua"))()
```

### Basic Implementation
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()

-- Create compact UI
local ui = Library:Create({Theme = "Dark"})
local section = ui:CreateSection("My Controls")

-- Add components
ui:CreateButton(section, {
    Text = "🚀 Action Button",
    Callback = function() print("Button clicked!") end
})

ui:CreateSlider(section, {
    Text = "📊 Value Slider",
    Min = 0, Max = 100, Default = 50,
    Callback = function(value) print("Value:", value) end
})

ui:CreateToggle(section, {
    Text = "🔧 Enable Feature",
    Default = false,
    Callback = function(enabled) print("Feature:", enabled) end
})
```

## 🎨 Available Themes
- **Dark** (default) - Modern dark theme
- **Light** - Clean light theme  
- **Purple** - Elegant purple theme
- **Ocean** - Cool ocean blue theme

Switch themes dynamically:
```lua
ui:SetTheme("Purple")
```

## 📐 Size Specifications

### New Compact Dimensions
- **Main GUI**: 380×320 pixels (was 650×450)
- **Component Heights**: 
  - Buttons: 28px (was 35px)
  - Toggles: 28px (was 35px) 
  - Inputs: 28px (was 35px)
  - Dropdowns: 28px (was 35px)
  - Search boxes: 28px (was 35px)
  - Sliders: 45px (was 55px)
  - Labels: 20px (was 25px)
  - Separators: 1px (unchanged)

### Size Limits
- **Minimum**: 350×300 pixels
- **Maximum**: 450×400 pixels
- **Default**: 380×320 pixels

## 🔧 Component Details

### Buttons
```lua
ui:CreateButton(section, {
    Text = "Button Text",
    Callback = function() 
        -- Your code here
    end
})
```

### Toggles/Switches
```lua
ui:CreateToggle(section, {
    Text = "Toggle Name",
    Default = false,
    Callback = function(value)
        print("Toggle state:", value)
    end
})
```

### Sliders
```lua
ui:CreateSlider(section, {
    Text = "Slider Name", 
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})
```

### Input Boxes
```lua
ui:CreateInput(section, {
    Text = "Input Label",
    Placeholder = "Enter text...",
    Default = "",
    Callback = function(text, enterPressed)
        print("Input:", text)
    end
})
```

### Dropdowns
```lua
ui:CreateDropdown(section, {
    Text = "Dropdown Label",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

### Search Boxes
```lua
ui:CreateSearchBox(section, {
    Placeholder = "Search items...",
    Items = {"Item 1", "Item 2", "Item 3"},
    Callback = function(selected)
        print("Found:", selected)
    end
})
```

### Labels
```lua
ui:CreateLabel(section, {
    Text = "Label Text",
    Color = Color3.fromRGB(255, 255, 255) -- Optional custom color
})
```

### Separators
```lua
ui:CreateSeparator(section)
```

## 🚀 Performance Improvements
- **Smaller memory footprint** due to compact size
- **Faster rendering** with optimized component dimensions
- **Better mobile compatibility** with reduced screen real estate usage
- **Improved user experience** with all components visible at once

## 📁 Example Files
- `example.lua` - Comprehensive showcase of all components
- `compact_demo.lua` - Minimal example showing essential components
- `Uilib.lua` - Main library file with compact optimizations

## 🔄 Migration from Previous Version
If you're upgrading from the larger GUI version:
1. The API remains exactly the same
2. All components work identically 
3. Only the visual size has been reduced
4. No code changes required for existing implementations

---

**Total Components**: 8 types
**GUI Size Reduction**: 42% smaller
**Component Coverage**: 100% showcased
**Backward Compatibility**: Full