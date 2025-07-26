-- Compact UI Demo - Essential Components Only
-- Minimal example showing all UI components in the smallest possible space

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()

-- Create compact UI instance
local ui = Library:Create({
    Theme = "Dark"
})

-- Single section with all essential components
local demo = ui:CreateSection("Compact Demo")

-- Essential components showcase
ui:CreateButton(demo, {
    Text = "🚀 Action",
    Callback = function() print("Button clicked!") end
})

ui:CreateToggle(demo, {
    Text = "🔧 Enable",
    Default = false,
    Callback = function(v) print("Toggle:", v) end
})

ui:CreateSlider(demo, {
    Text = "📊 Value",
    Min = 0, Max = 100, Default = 50,
    Callback = function(v) print("Slider:", v) end
})

ui:CreateInput(demo, {
    Text = "📝 Input",
    Placeholder = "Type here...",
    Callback = function(text) print("Input:", text) end
})

ui:CreateDropdown(demo, {
    Text = "📋 Select",
    Options = {"Option A", "Option B", "Option C"},
    Default = "Option A",
    Callback = function(opt) print("Selected:", opt) end
})

ui:CreateSearchBox(demo, {
    Placeholder = "🔍 Search...",
    Items = {"Item 1", "Item 2", "Item 3", "Item 4"},
    Callback = function(item) print("Found:", item) end
})

ui:CreateLabel(demo, {
    Text = "ℹ️ Status: Ready",
    Color = Color3.fromRGB(100, 255, 100)
})

ui:CreateSeparator(demo)

ui:CreateLabel(demo, {
    Text = "✅ All components loaded",
    Color = Color3.fromRGB(200, 200, 200)
})

print("🎯 Compact UI Demo loaded - All 8 component types displayed!")