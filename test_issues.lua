-- Test script to verify the fixes
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Uilib.lua"))()

-- Test 1: White section headers
print("=== Testing White Section Headers ===")
local UI1 = Library:Create({
    Theme = "Ocean",
    ToggleKey = Enum.KeyCode.F1,
    SectionHeaderEnabled = true,
    SectionHeaderWhite = true  -- Headers should now be white
})

local TestSection1 = UI1:CreateSection("White Header Test")
UI1:CreateLabel(TestSection1, {
    Text = "Check if section header above is white",
    Color = Color3.fromRGB(255, 255, 255)
})

-- Test 2: Empty dropdown should not show visible container
print("=== Testing Empty Dropdown Fix ===")
local TestSection2 = UI1:CreateSection("Dropdown Tests")

local EmptyDropdown = UI1:CreateDropdown(TestSection2, {
    Text = "Empty Dropdown",
    Options = {}, -- Empty - should not show container when clicked
    Default = "None",
    Callback = function(selected)
        print("Selected from empty:", selected)
    end
})

local NormalDropdown = UI1:CreateDropdown(TestSection2, {
    Text = "Normal Dropdown", 
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected from normal:", selected)
    end
})

UI1:CreateLabel(TestSection2, {
    Text = "Empty dropdown should not expand when clicked",
    Color = Color3.fromRGB(255, 255, 0)
})

print("✅ Test UI created!")
print("🔍 Check:")
print("1. 'White Header Test' and 'Dropdown Tests' headers should be WHITE")
print("2. 'Empty Dropdown' should not expand/show container when clicked")
print("3. 'Normal Dropdown' should work normally")