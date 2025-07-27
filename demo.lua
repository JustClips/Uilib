--[[
    Eps1llon Hub - Visual Feature Demonstration
    
    This script demonstrates the key features of the Eps1llon Hub integration.
    It creates a simple showcase of the UI components and functionality.
]]

-- Load the UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Uilib.lua"))()

-- Create Demo Window
local DemoWindow = Library:Create({
    Theme = "Ocean"
})

-- Feature Categories Demonstration
local function ShowcaseFeatures()
    -- Configuration Demo Section
    local ConfigDemo = DemoWindow:CreateSection("🔧 Configuration Demo")
    
    ConfigDemo:CreateLabel({
        Text = "Character Movement Controls",
        Color = Color3.fromRGB(100, 200, 255)
    })
    
    ConfigDemo:CreateSlider({
        Text = "Demo Walkspeed",
        Min = 1,
        Max = 100,
        Default = 16,
        Callback = function(value)
            DemoWindow:Notify({
                Title = "Walkspeed",
                Text = "Set to " .. value,
                Duration = 1
            })
        end
    })
    
    ConfigDemo:CreateToggle({
        Text = "Demo Feature Toggle",
        Default = false,
        Callback = function(enabled)
            DemoWindow:Notify({
                Title = "Toggle",
                Text = enabled and "Enabled" or "Disabled",
                Duration = 1
            })
        end
    })
    
    -- Combat Demo Section
    local CombatDemo = DemoWindow:CreateSection("⚔️ Combat Demo")
    
    CombatDemo:CreateLabel({
        Text = "Enhanced Combat Features",
        Color = Color3.fromRGB(255, 100, 100)
    })
    
    CombatDemo:CreateSlider({
        Text = "Demo Reach",
        Min = 1,
        Max = 20,
        Default = 3,
        Callback = function(value)
            DemoWindow:Notify({
                Title = "Reach",
                Text = "Extended to " .. value .. " studs",
                Duration = 1
            })
        end
    })
    
    CombatDemo:CreateButton({
        Text = "Test Combat Feature",
        Callback = function()
            DemoWindow:Notify({
                Title = "Combat",
                Text = "Feature demonstration complete!",
                Duration = 2
            })
        end
    })
    
    -- ESP Demo Section
    local ESPDemo = DemoWindow:CreateSection("👁️ ESP Demo")
    
    ESPDemo:CreateLabel({
        Text = "Advanced Visibility Features",
        Color = Color3.fromRGB(100, 255, 100)
    })
    
    ESPDemo:CreateButton({
        Text = "Load ESP Module",
        Callback = function()
            DemoWindow:Notify({
                Title = "ESP",
                Text = "External module loading simulation",
                Duration = 2
            })
        end
    })
    
    -- Inventory Demo Section
    local InventoryDemo = DemoWindow:CreateSection("🎒 Inventory Demo")
    
    InventoryDemo:CreateLabel({
        Text = "Smart Inventory Management",
        Color = Color3.fromRGB(255, 255, 100)
    })
    
    InventoryDemo:CreateSearchBox({
        Text = "Tool Search Demo",
        Items = {"Sword", "Gun", "Hammer", "Pickaxe", "Shovel"},
        Placeholder = "Search tools...",
        Callback = function(item)
            DemoWindow:Notify({
                Title = "Search",
                Text = "Selected: " .. item,
                Duration = 2
            })
        end
    })
    
    -- UI Settings Demo Section
    local SettingsDemo = DemoWindow:CreateSection("🎨 UI Settings Demo")
    
    SettingsDemo:CreateLabel({
        Text = "Theme and Customization",
        Color = Color3.fromRGB(200, 100, 255)
    })
    
    SettingsDemo:CreateDropdown({
        Text = "Demo Theme",
        Options = {"Dark", "Light", "Purple", "Ocean"},
        Default = "Ocean",
        Callback = function(theme)
            DemoWindow:SetTheme(theme)
            DemoWindow:Notify({
                Title = "Theme",
                Text = "Changed to " .. theme,
                Duration = 2
            })
        end
    })
    
    SettingsDemo:CreateInput({
        Text = "Custom Input",
        Placeholder = "Enter text...",
        Callback = function(text)
            if text ~= "" then
                DemoWindow:Notify({
                    Title = "Input",
                    Text = "You entered: " .. text,
                    Duration = 2
                })
            end
        end
    })
    
    SettingsDemo:CreateSeparator()
    
    SettingsDemo:CreateLabel({
        Text = "Eps1llon Hub Integration Demo",
        Color = Color3.fromRGB(100, 200, 255)
    })
    
    SettingsDemo:CreateButton({
        Text = "Load Full Hub",
        Callback = function()
            DemoWindow:Notify({
                Title = "Loading",
                Text = "Loading full Eps1llon Hub...",
                Duration = 3
            })
            
            wait(1)
            
            -- Load the actual hub
            loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/EpsillonHub.lua"))()
            
            -- Close demo window
            wait(2)
            DemoWindow:Destroy()
        end
    })
end

-- Initialize Demonstration
ShowcaseFeatures()

-- Welcome Message
DemoWindow:Notify({
    Title = "Demo Ready",
    Text = "Explore the Eps1llon Hub features!",
    Duration = 5
})

-- Add some helpful information
print("=== Eps1llon Hub Demo ===")
print("This demonstration showcases the UI components and features")
print("of the complete Eps1llon Hub integration.")
print("") 
print("Features demonstrated:")
print("• Modern UI with smooth animations")
print("• Multiple themed interfaces")
print("• Interactive components (sliders, toggles, buttons)")
print("• Search functionality")
print("• Notification system")
print("• Real-time feedback")
print("")
print("Press the 'Load Full Hub' button to access all features!")
print("Use Insert key to toggle UI visibility")

return DemoWindow