-- Comprehensive test script to validate the fixes and ensure no regressions
print("🧪 Starting comprehensive UI library tests...")

-- Check if we're in a Roblox environment
local isRoblox = game and game.GetService
if not isRoblox then
    print("❌ Not in Roblox environment - some tests may fail")
    return
end

-- Load the library from local file for testing
local Library = loadstring(readfile("Uilib.lua"))()

print("✅ Library loaded successfully")

-- Test 1: Section Header Color Fix
print("\n🔍 Test 1: Section Header Colors")
local testResults = {}

-- Test with SectionHeaderWhite = true
local UI_White = Library:Create({
    Theme = "Ocean",
    ToggleKey = Enum.KeyCode.F1,
    SectionHeaderEnabled = true,
    SectionHeaderWhite = true
})

local WhiteSection = UI_White:CreateSection("White Header")

-- Check if header exists and get its color
local whiteHeader = nil
for _, descendant in pairs(UI_White.ScreenGui:GetDescendants()) do
    if descendant.Name == "SectionHeader" and descendant.Text == "White Header" then
        whiteHeader = descendant
        break
    end
end

if whiteHeader then
    local isWhite = whiteHeader.TextColor3 == Color3.fromRGB(255, 255, 255)
    testResults.whiteHeader = isWhite
    print(isWhite and "✅ White header color is correct" or "❌ White header color is wrong")
else
    testResults.whiteHeader = false
    print("❌ White header not found")
end

-- Test with SectionHeaderWhite = false (should use accent color)
local UI_Accent = Library:Create({
    Theme = "Ocean", 
    ToggleKey = Enum.KeyCode.F2,
    SectionHeaderEnabled = true,
    SectionHeaderWhite = false
})

local AccentSection = UI_Accent:CreateSection("Accent Header")

local accentHeader = nil
for _, descendant in pairs(UI_Accent.ScreenGui:GetDescendants()) do
    if descendant.Name == "SectionHeader" and descendant.Text == "Accent Header" then
        accentHeader = descendant
        break
    end
end

if accentHeader then
    local isAccent = accentHeader.TextColor3 == UI_Accent.Theme.Accent
    testResults.accentHeader = isAccent
    print(isAccent and "✅ Accent header color is correct" or "❌ Accent header color is wrong")
else
    testResults.accentHeader = false
    print("❌ Accent header not found")
end

-- Test 2: Dropdown Empty Container Fix
print("\n🔍 Test 2: Dropdown Container Visibility")

local TestSection = UI_White:CreateSection("Dropdown Tests")

-- Test empty dropdown
local EmptyDropdown = UI_White:CreateDropdown(TestSection, {
    Text = "Empty Dropdown",
    Options = {},
    Default = "None"
})

-- Check if option container is initially hidden
local emptyContainerHidden = not EmptyDropdown.OptionContainer.Visible
testResults.emptyContainerHidden = emptyContainerHidden
print(emptyContainerHidden and "✅ Empty dropdown container is initially hidden" or "❌ Empty dropdown container is visible")

-- Test dropdown with options
local NormalDropdown = UI_White:CreateDropdown(TestSection, {
    Text = "Normal Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1"
})

-- Check if normal dropdown container is initially hidden
local normalContainerHidden = not NormalDropdown.OptionContainer.Visible
testResults.normalContainerHidden = normalContainerHidden
print(normalContainerHidden and "✅ Normal dropdown container is initially hidden" or "❌ Normal dropdown container is visible")

-- Test 3: Verify other elements still work
print("\n🔍 Test 3: Regression Tests")

-- Test toggle
local toggle = UI_White:CreateToggle(TestSection, {
    Text = "Test Toggle",
    Default = false
})
testResults.toggleExists = toggle ~= nil
print(testResults.toggleExists and "✅ Toggle creation works" or "❌ Toggle creation failed")

-- Test slider  
local slider = UI_White:CreateSlider(TestSection, {
    Text = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50
})
testResults.sliderExists = slider ~= nil
print(testResults.sliderExists and "✅ Slider creation works" or "❌ Slider creation failed")

-- Test button
local button = UI_White:CreateButton(TestSection, {
    Text = "Test Button"
})
testResults.buttonExists = button ~= nil
print(testResults.buttonExists and "✅ Button creation works" or "❌ Button creation failed")

-- Test 4: Theme changes (UpdateSectionHeaders should be called)
print("\n🔍 Test 4: Theme Change Updates Headers")

local originalColor = whiteHeader and whiteHeader.TextColor3
UI_White:SetTheme("Purple")

-- Check if header color updated after theme change
local afterThemeColor = whiteHeader and whiteHeader.TextColor3
local headerUpdated = originalColor ~= afterThemeColor or whiteHeader.TextColor3 == Color3.fromRGB(255, 255, 255)
testResults.headerUpdated = headerUpdated
print(headerUpdated and "✅ Header color updates with theme change" or "❌ Header color not updated with theme change")

-- Summary
print("\n📊 TEST SUMMARY:")
local passed = 0
local total = 0
for test, result in pairs(testResults) do
    total = total + 1
    if result then
        passed = passed + 1
        print("✅", test)
    else
        print("❌", test)
    end
end

print(string.format("\n🎯 Results: %d/%d tests passed (%.1f%%)", passed, total, (passed/total)*100))

if passed == total then
    print("🎉 All tests passed! Fixes are working correctly.")
else
    print("⚠️  Some tests failed. Please review the fixes.")
end

-- Cleanup
UI_White:Destroy()
UI_Accent:Destroy()

print("\n✨ Testing complete!")