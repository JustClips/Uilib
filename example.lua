-- Comprehensive UI Library Example
-- This script demonstrates ALL available UI components in a compact layout

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()

-- Create the main library instance with a compact GUI
local ui = Library:Create({
    Theme = "Dark" -- Options: "Dark", "Light", "Purple", "Ocean"
})

-- Create main section for all components
local mainSection = ui:CreateSection("UI Components Showcase")

-- 1. BUTTONS - Different styles and callbacks
ui:CreateButton(mainSection, {
    Text = "🎯 Primary Action Button",
    Callback = function()
        print("Primary button clicked!")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Button Demo";
            Text = "Primary action executed!";
            Duration = 3;
        })
    end
})

ui:CreateButton(mainSection, {
    Text = "🔄 Reload Interface",
    Callback = function()
        print("Reload button clicked!")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Reload Demo";
            Text = "Interface would reload here!";
            Duration = 3;
        })
    end
})

-- 2. TOGGLES/SWITCHES - Different states and purposes
ui:CreateToggle(mainSection, {
    Text = "🌟 Enable Feature",
    Default = false,
    Callback = function(value)
        print("Feature toggle:", value)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Toggle Demo";
            Text = "Feature " .. (value and "enabled" or "disabled");
            Duration = 2;
        })
    end
})

ui:CreateToggle(mainSection, {
    Text = "🔊 Sound Effects",
    Default = true,
    Callback = function(value)
        print("Sound effects:", value)
    end
})

ui:CreateToggle(mainSection, {
    Text = "🌙 Dark Mode",
    Default = true,
    Callback = function(value)
        print("Dark mode:", value)
        if value then
            ui:SetTheme("Dark")
        else
            ui:SetTheme("Light")
        end
    end
})

-- 3. SLIDERS - Different ranges and purposes
ui:CreateSlider(mainSection, {
    Text = "🎵 Volume",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        print("Volume set to:", value)
    end
})

ui:CreateSlider(mainSection, {
    Text = "⚡ Speed Multiplier",
    Min = 1,
    Max = 10,
    Default = 3,
    Callback = function(value)
        print("Speed multiplier:", value)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Speed Demo";
            Text = "Speed set to " .. value .. "x";
            Duration = 2;
        })
    end
})

ui:CreateSlider(mainSection, {
    Text = "🌈 Transparency",
    Min = 0,
    Max = 100,
    Default = 20,
    Callback = function(value)
        print("Transparency:", value .. "%")
    end
})

-- 4. INPUT BOXES - Text and number inputs
ui:CreateInput(mainSection, {
    Text = "👤 Username",
    Placeholder = "Enter your username...",
    Default = "",
    Callback = function(text, enterPressed)
        print("Username input:", text, "Enter pressed:", enterPressed)
        if enterPressed and text ~= "" then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Input Demo";
                Text = "Welcome, " .. text .. "!";
                Duration = 3;
            })
        end
    end
})

ui:CreateInput(mainSection, {
    Text = "🔑 API Key",
    Placeholder = "Paste your API key here...",
    Default = "",
    Callback = function(text, enterPressed)
        print("API Key entered:", string.len(text) > 0 and string.rep("*", string.len(text)) or "Empty")
    end
})

ui:CreateInput(mainSection, {
    Text = "💬 Custom Message",
    Placeholder = "Type a message...",
    Default = "Hello World!",
    Callback = function(text, enterPressed)
        print("Message:", text)
    end
})

-- 5. DROPDOWNS - Selection menus with multiple options
ui:CreateDropdown(mainSection, {
    Text = "🎨 Theme",
    Options = {"Dark", "Light", "Purple", "Ocean"},
    Default = "Dark",
    Callback = function(option)
        print("Theme selected:", option)
        ui:SetTheme(option)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Theme Demo";
            Text = "Switched to " .. option .. " theme!";
            Duration = 2;
        })
    end
})

ui:CreateDropdown(mainSection, {
    Text = "🎮 Game Mode",
    Options = {"Survival", "Creative", "Adventure", "Spectator", "Hardcore"},
    Default = "Creative",
    Callback = function(option)
        print("Game mode selected:", option)
    end
})

ui:CreateDropdown(mainSection, {
    Text = "🌍 Server Region",
    Options = {"US East", "US West", "Europe", "Asia", "Australia", "South America"},
    Default = "US East",
    Callback = function(option)
        print("Server region:", option)
    end
})

-- 6. SEARCH BOXES - Searchable lists
ui:CreateSearchBox(mainSection, {
    Placeholder = "🔍 Search players...",
    Items = {"Player1", "Player2", "Player3", "AdminUser", "TestAccount", "GuestUser", "ProGamer", "NewPlayer"},
    Callback = function(item)
        print("Player selected:", item)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Search Demo";
            Text = "Selected player: " .. item;
            Duration = 2;
        })
    end
})

ui:CreateSearchBox(mainSection, {
    Placeholder = "🎵 Search songs...",
    Items = {"Sunset Dreams", "Ocean Waves", "Mountain Echo", "City Lights", "Forest Whispers", "Desert Wind", "River Flow", "Thunder Storm"},
    Callback = function(item)
        print("Song selected:", item)
    end
})

-- 7. LABELS - Information display with different styles
ui:CreateLabel(mainSection, {
    Text = "📊 Status: All systems operational",
    Color = Color3.fromRGB(100, 255, 100) -- Green
})

ui:CreateLabel(mainSection, {
    Text = "⚠️ Warning: High resource usage detected",
    Color = Color3.fromRGB(255, 200, 100) -- Orange
})

ui:CreateLabel(mainSection, {
    Text = "💡 Tip: Use shortcuts for faster navigation",
    Color = Color3.fromRGB(100, 200, 255) -- Blue
})

ui:CreateLabel(mainSection, {
    Text = "🔧 Version: 2.1.0 | Updated: Today",
    Color = Color3.fromRGB(200, 200, 200) -- Gray
})

-- 8. SEPARATORS - Visual organization
ui:CreateSeparator(mainSection)

-- Additional section to show organization
local advancedSection = ui:CreateSection("Advanced Controls")

-- More complex examples
ui:CreateSlider(advancedSection, {
    Text = "🎯 Precision Value",
    Min = 0,
    Max = 1000,
    Default = 250,
    Callback = function(value)
        print("Precision value:", value)
    end
})

ui:CreateToggle(advancedSection, {
    Text = "🚀 Turbo Mode",
    Default = false,
    Callback = function(value)
        print("Turbo mode:", value)
        if value then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Turbo Mode";
                Text = "⚡ TURBO ACTIVATED! ⚡";
                Duration = 3;
            })
        end
    end
})

ui:CreateButton(advancedSection, {
    Text = "💾 Save Configuration",
    Callback = function()
        print("Configuration saved!")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Save Demo";
            Text = "Configuration saved successfully!";
            Duration = 2;
        })
    end
})

ui:CreateSeparator(advancedSection)

ui:CreateLabel(advancedSection, {
    Text = "🎉 All components loaded successfully!",
    Color = Color3.fromRGB(100, 255, 100)
})

-- Print completion message
print("🚀 UI Library Example loaded! All components are now visible in the compact interface.")
print("📝 Components included: Buttons, Toggles, Sliders, Inputs, Dropdowns, Search boxes, Labels, and Separators")
print("🎨 Try switching themes using the dropdown to see different visual styles!")

--[[
COMPONENT SUMMARY:
✅ Buttons - Interactive action triggers with hover effects
✅ Toggles - On/off switches with smooth animations  
✅ Sliders - Value selection with custom ranges
✅ Input Boxes - Text fields with placeholders and validation
✅ Dropdowns - Selection menus with expandable options
✅ Search Boxes - Filterable lists with real-time search
✅ Labels - Information display with custom styling
✅ Separators - Visual dividers for content organization

FEATURES DEMONSTRATED:
- Compact layout optimized for smaller GUI size
- All component types with various configurations
- Callback functions showing interactivity
- Theme switching capabilities
- Notification system integration
- Console logging for debugging
- Responsive design elements
- Professional styling with icons and colors
--]]