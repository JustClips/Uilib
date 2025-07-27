-- Visual test for Roblox Studio to demonstrate the fixes
-- Run this in Roblox Studio Command Bar or as a LocalScript

-- Load the UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()

print("🎨 Creating visual test UI to demonstrate fixes...")

-- Create UI with white headers to test fix #1
local UI = Library:Create({
    Theme = "Ocean",
    ToggleKey = Enum.KeyCode.RightShift,
    SectionHeaderEnabled = true,
    SectionHeaderWhite = true,  -- FIX #1: Headers should now be WHITE
    Background = "Blue Sky"
})

-- Section 1: Header Color Test
local HeaderTestSection = UI:CreateSection("Header Color Test")

UI:CreateLabel(HeaderTestSection, {
    Text = "✅ This section header above should be WHITE",
    Color = Color3.fromRGB(0, 255, 0)
})

UI:CreateLabel(HeaderTestSection, {
    Text = "Before fix: Headers were colorful/accent colored",
    Color = Color3.fromRGB(255, 200, 100)
})

UI:CreateLabel(HeaderTestSection, {
    Text = "After fix: Headers respect SectionHeaderWhite setting",
    Color = Color3.fromRGB(100, 255, 100)
})

-- Section 2: Dropdown Test
local DropdownTestSection = UI:CreateSection("Dropdown Fix Test")

UI:CreateLabel(DropdownTestSection, {
    Text = "📋 Test the dropdowns below:",
    Color = Color3.fromRGB(255, 255, 255)
})

-- FIX #2: Empty dropdown should not show container when clicked
local EmptyDropdown = UI:CreateDropdown(DropdownTestSection, {
    Text = "Empty Dropdown",
    Options = {},  -- Empty options array
    Default = "None",
    Callback = function(selected)
        print("Empty dropdown selected:", selected)
    end
})

UI:CreateLabel(DropdownTestSection, {
    Text = "☝️ Empty dropdown above should NOT expand when clicked",
    Color = Color3.fromRGB(255, 255, 0)
})

-- Normal dropdown for comparison
local NormalDropdown = UI:CreateDropdown(DropdownTestSection, {
    Text = "Normal Dropdown",
    Options = {"Apple", "Banana", "Cherry", "Date"},
    Default = "Apple",
    Callback = function(selected)
        print("Normal dropdown selected:", selected)
        UI:Notify({
            Title = "Dropdown Test",
            Text = "Selected: " .. selected,
            Duration = 2
        })
    end
})

UI:CreateLabel(DropdownTestSection, {
    Text = "☝️ Normal dropdown above should work perfectly",
    Color = Color3.fromRGB(100, 255, 100)
})

-- Section 3: Other Elements (Regression Test)
local RegressionSection = UI:CreateSection("Regression Tests")

UI:CreateLabel(RegressionSection, {
    Text = "🔧 These elements should still work normally:",
    Color = Color3.fromRGB(255, 255, 255)
})

UI:CreateToggle(RegressionSection, {
    Text = "Test Toggle",
    Default = false,
    Callback = function(enabled)
        print("Toggle:", enabled)
        UI:Notify({
            Title = "Toggle Test",
            Text = enabled and "Enabled!" or "Disabled!",
            Duration = 1
        })
    end
})

UI:CreateSlider(RegressionSection, {
    Text = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider:", value)
    end
})

UI:CreateButton(RegressionSection, {
    Text = "Test Button",
    Callback = function()
        print("Button clicked!")
        UI:Notify({
            Title = "Button Test", 
            Text = "Button works perfectly!",
            Duration = 2
        })
    end
})

-- Test theme switching to verify header updates
UI:CreateButton(RegressionSection, {
    Text = "Switch to Purple Theme",
    Callback = function()
        UI:SetTheme("Purple")
        UI:Notify({
            Title = "Theme Changed",
            Text = "Headers should still be white!",
            Duration = 3
        })
    end
})

UI:CreateButton(RegressionSection, {
    Text = "Switch to Dark Theme", 
    Callback = function()
        UI:SetTheme("Dark")
        UI:Notify({
            Title = "Theme Changed",
            Text = "Headers should still be white!",
            Duration = 3
        })
    end
})

-- Welcome notification
UI:Notify({
    Title = "🎉 Visual Test Ready!",
    Text = "Check: 1) White headers, 2) Empty dropdown behavior",
    Duration = 5
})

print("✨ Visual test UI created!")
print("🔍 Look for:")
print("1. All section headers should be WHITE")
print("2. 'Empty Dropdown' should not expand when clicked")
print("3. 'Normal Dropdown' should work perfectly")
print("4. All other elements should work normally")
print("5. Theme changes should keep headers white")

return UI  -- Return UI object for further testing if needed