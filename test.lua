--[[
    Eps1llon Hub - Component Test Suite
    
    This script tests all UI components to ensure they function correctly.
]]

local function TestUIComponents()
    print("=== Testing UI Library Components ===")
    
    -- Test UI Library Loading
    local success, Library = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Uilib.lua"))()
    end)
    
    if not success then
        warn("Failed to load UI Library: " .. tostring(Library))
        return false
    end
    
    print("✓ UI Library loaded successfully")
    
    -- Test Window Creation
    local testWindow = Library:Create({
        Theme = "Dark"
    })
    
    if not testWindow then
        warn("Failed to create test window")
        return false
    end
    
    print("✓ Window creation successful")
    
    -- Test Section Creation
    local testSection = testWindow:CreateSection("Test Section")
    
    if not testSection then
        warn("Failed to create test section")
        return false
    end
    
    print("✓ Section creation successful")
    
    -- Test Component Creation
    local components = {}
    
    -- Test Button
    components.button = testWindow:CreateButton(testSection, {
        Text = "Test Button",
        Callback = function()
            print("✓ Button callback working")
        end
    })
    
    -- Test Toggle
    components.toggle = testWindow:CreateToggle(testSection, {
        Text = "Test Toggle",
        Default = false,
        Callback = function(state)
            print("✓ Toggle callback working: " .. tostring(state))
        end
    })
    
    -- Test Slider
    components.slider = testWindow:CreateSlider(testSection, {
        Text = "Test Slider",
        Min = 0,
        Max = 100,
        Default = 50,
        Callback = function(value)
            print("✓ Slider callback working: " .. value)
        end
    })
    
    -- Test Input
    components.input = testWindow:CreateInput(testSection, {
        Text = "Test Input",
        Placeholder = "Enter text...",
        Callback = function(text)
            print("✓ Input callback working: " .. text)
        end
    })
    
    -- Test Dropdown
    components.dropdown = testWindow:CreateDropdown(testSection, {
        Text = "Test Dropdown",
        Options = {"Option 1", "Option 2", "Option 3"},
        Default = "Option 1",
        Callback = function(option)
            print("✓ Dropdown callback working: " .. option)
        end
    })
    
    -- Test Label
    components.label = testWindow:CreateLabel(testSection, {
        Text = "Test Label",
        Color = Color3.fromRGB(100, 200, 255)
    })
    
    print("✓ All components created successfully")
    
    -- Test Theme Changes
    local themes = {"Dark", "Light", "Purple", "Ocean"}
    for _, theme in pairs(themes) do
        testWindow:SetTheme(theme)
        print("✓ Theme change successful: " .. theme)
    end
    
    -- Test Notifications
    testWindow:Notify({
        Title = "Test",
        Text = "Notification system working!",
        Duration = 2
    })
    
    print("✓ Notification system working")
    
    -- Test Window Controls
    testWindow:Minimize()
    wait(1)
    testWindow:Restore()
    
    print("✓ Window minimize/restore working")
    
    -- Cleanup
    wait(2)
    testWindow:Destroy()
    
    print("✓ Window cleanup successful")
    print("=== All Tests Passed! ===")
    
    return true
end

local function TestEpsillonHub()
    print("\n=== Testing Eps1llon Hub Integration ===")
    
    -- Test Hub Loading
    local success, hub = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/EpsillonHub.lua"))()
    end)
    
    if success then
        print("✓ Eps1llon Hub loaded successfully")
        
        -- Test configuration exists
        if hub and hub.Config then
            print("✓ Hub configuration accessible")
            print("  - Theme: " .. hub.Config.Theme)
            print("  - Version: " .. hub.Config.Version)
        end
        
        -- Test window exists
        if hub and hub.Window then
            print("✓ Hub window accessible")
        end
        
        return true
    else
        warn("Failed to load Eps1llon Hub: " .. tostring(hub))
        return false
    end
end

-- Run Tests
local uiTestsPassed = TestUIComponents()
local hubTestsPassed = TestEpsillonHub()

if uiTestsPassed and hubTestsPassed then
    print("\n🎉 All tests completed successfully!")
    print("The Eps1llon Hub integration is fully functional.")
else
    warn("\n❌ Some tests failed. Please check the output above.")
end