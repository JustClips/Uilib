-- Eps1llon Hub UI Library - Complete Usage Example
-- This script demonstrates all features of the library

-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/eps1llon-hub/main/library.lua"))()

-- Create the main window with custom configuration
local Window = Library:Create({
    Theme = "Ocean",                      -- Available: Dark, Light, Purple, Ocean
    Background = "Blue Sky",              -- Available: Blue Sky, Mountains, Blurred Stars
    ToggleKey = Enum.KeyCode.RightShift,  -- Key to toggle UI visibility
    Font = "Ubuntu",                      -- Default font
    ButtonDarkness = 0.5,                 -- Button transparency (0-1)
    StrokeThickness = 1,                  -- Border thickness (0-5)
    SectionHeaderEnabled = true,          -- Show section headers
    SectionHeaderWhite = false,           -- Make headers white instead of accent color
    HideUISettings = false,               -- Show UI settings button
    SectionHeaderConfig = {
        Size = 22,                        -- Header text size
        Font = Enum.Font.GothamBold,      -- Header font
        Color = nil,                      -- Custom color (nil = use theme accent)
        Position = "Center",              -- Left, Center, or Right
        UnderlineEnabled = true,          -- Show underline
        UnderlineSize = 0.5,              -- Underline width (0-1)
        UnderlineThickness = 2            -- Underline height in pixels
    }
})

-- Create sections
local MainSection = Window:CreateSection("Main Features")
local PlayerSection = Window:CreateSection("Player", Color3.fromRGB(255, 100, 100)) -- Custom header color
local VisualsSection = Window:CreateSection("Visuals", Color3.fromRGB(100, 255, 100))
local SettingsSection = Window:CreateSection("Settings")
local ExamplesSection = Window:CreateSection("Examples")

-- Main Features Section
Window:CreateButton(MainSection, {
    Text = "Execute Script",
    Callback = function()
        Window:Notify({
            Title = "Success",
            Text = "Script executed successfully!",
            Duration = 3
        })
    end
})

Window:CreateToggle(MainSection, {
    Text = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
        if value then
            Window:Notify({
                Title = "Auto Farm",
                Text = "Auto Farm enabled!",
                Duration = 2
            })
        end
    end
})

Window:CreateSlider(MainSection, {
    Text = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

Window:CreateKeybind(MainSection, {
    Text = "Toggle Fly",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Fly key pressed!")
    end
})

-- Player Section with BigDropdown
Window:CreateBigDropdown(PlayerSection, {
    Text = "Character Settings",
    CreateElements = function(dropdown)
        dropdown.AddToggle({
            Text = "God Mode",
            Default = false,
            Callback = function(value)
                print("God Mode:", value)
            end
        })
        
        dropdown.AddToggle({
            Text = "Infinite Jump",
            Default = false,
            Callback = function(value)
                print("Infinite Jump:", value)
            end
        })
        
        dropdown.AddSlider({
            Text = "Jump Power",
            Min = 50,
            Max = 300,
            Default = 50,
            Callback = function(value)
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            end
        })
        
        dropdown.AddSlider({
            Text = "Gravity",
            Min = 0,
            Max = 196.2,
            Default = 196.2,
            Callback = function(value)
                workspace.Gravity = value
            end
        })
        
        dropdown.AddButton({
            Text = "Reset Character",
            Callback = function()
                game.Players.LocalPlayer.Character:BreakJoints()
            end
        })
    end
})

Window:CreateBigDropdown(PlayerSection, {
    Text = "Teleportation",
    CreateElements = function(dropdown)
        dropdown.AddInput({
            Text = "Player Name",
            Placeholder = "Enter player name...",
            Callback = function(text)
                print("Target player:", text)
            end
        })
        
        dropdown.AddButton({
            Text = "Teleport to Player",
            Callback = function()
                print("Teleporting...")
            end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddLabel({
            Text = "Quick Teleports",
            Color = Color3.fromRGB(255, 255, 0)
        })
        
        dropdown.AddButton({
            Text = "Spawn",
            Callback = function()
                -- Teleport to spawn logic
            end
        })
        
        dropdown.AddButton({
            Text = "Previous Position",
            Callback = function()
                -- Teleport to previous position
            end
        })
    end
})

-- Visuals Section
Window:CreateToggle(VisualsSection, {
    Text = "ESP Enabled",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

Window:CreateDropdown(VisualsSection, {
    Text = "ESP Type",
    Options = {"Box", "Name", "Health", "Distance", "All"},
    Default = "Box",
    Callback = function(selected)
        print("ESP Type:", selected)
    end
})

Window:CreateSlider(VisualsSection, {
    Text = "ESP Distance",
    Min = 100,
    Max = 10000,
    Default = 1000,
    Callback = function(value)
        print("ESP Distance:", value)
    end
})

Window:CreateSeparator(VisualsSection)

Window:CreateLabel(VisualsSection, {
    Text = "Chams Settings",
    Color = Color3.fromRGB(255, 200, 0)
})

Window:CreateToggle(VisualsSection, {
    Text = "Chams Enabled",
    Default = false,
    Callback = function(value)
        print("Chams:", value)
    end
})

-- Settings Section
Window:CreateInput(SettingsSection, {
    Text = "Config Name",
    Default = "default",
    Placeholder = "Enter config name...",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Saving config:", text)
        end
    end
})

Window:CreateButton(SettingsSection, {
    Text = "Save Config",
    Callback = function()
        Window:Notify({
            Title = "Config",
            Text = "Configuration saved!",
            Duration = 2
        })
    end
})

Window:CreateButton(SettingsSection, {
    Text = "Load Config",
    Callback = function()
        Window:Notify({
            Title = "Config",
            Text = "Configuration loaded!",
            Duration = 2
        })
    end
})

Window:CreateSeparator(SettingsSection)

-- Search Box Example
local players = {}
for _, player in pairs(game.Players:GetPlayers()) do
    table.insert(players, player.Name)
end

Window:CreateSearchBox(SettingsSection, {
    Placeholder = "Search players...",
    Items = players,
    OnSelected = function(selected)
        print("Selected player:", selected)
        Window:Notify({
            Title = "Player Selected",
            Text = "You selected: " .. selected,
            Duration = 2
        })
    end
})

-- Examples Section
Window:CreateLabel(ExamplesSection, {
    Text = "UI Customization Examples",
    Color = Color3.fromRGB(100, 200, 255)
})

-- Theme Changer
Window:CreateDropdown(ExamplesSection, {
    Text = "Change Theme",
    Options = {"Dark", "Light", "Purple", "Ocean"},
    Default = "Ocean",
    Callback = function(theme)
        Window:SetTheme(theme)
        Window:Notify({
            Title = "Theme Changed",
            Text = "Theme set to: " .. theme,
            Duration = 2
        })
    end
})

-- Background Changer
Window:CreateDropdown(ExamplesSection, {
    Text = "Change Background",
    Options = {"Blue Sky", "Mountains", "Blurred Stars"},
    Default = "Blue Sky",
    Callback = function(bg)
        Window:SetBackground(bg)
    end
})

-- Font Changer
Window:CreateDropdown(ExamplesSection, {
    Text = "Change Font",
    Options = {"Ubuntu", "Gotham", "GothamBold", "SourceSans", "Code", "SciFi"},
    Default = "Ubuntu",
    Callback = function(font)
        Window:SetFont(font)
    end
})

Window:CreateSeparator(ExamplesSection)

-- Dynamic Examples
Window:CreateButton(ExamplesSection, {
    Text = "Show Multiple Notifications",
    Callback = function()
        for i = 1, 3 do
            task.wait(0.5)
            Window:Notify({
                Title = "Notification " .. i,
                Text = "This is notification number " .. i,
                Duration = 2
            })
        end
    end
})

-- BigDropdown with mixed elements
Window:CreateBigDropdown(ExamplesSection, {
    Text = "Advanced Example",
    CreateElements = function(dropdown)
        dropdown.AddLabel({
            Text = "Mixed Elements Example",
            Color = Color3.fromRGB(255, 100, 255)
        })
        
        dropdown.AddToggle({
            Text = "Enable All",
            Default = false,
            Callback = function(value)
                print("Enable All:", value)
            end
        })
        
        dropdown.AddSlider({
            Text = "Quality",
            Min = 1,
            Max = 10,
            Default = 5,
            Callback = function(value)
                print("Quality:", value)
            end
        })
        
        dropdown.AddDropdown({
            Text = "Mode",
            Options = {"Performance", "Balanced", "Quality"},
            Default = "Balanced",
            Callback = function(mode)
                print("Mode:", mode)
            end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddInput({
            Text = "Custom Value",
            Default = "100",
            Placeholder = "Enter value...",
            Callback = function(text)
                print("Custom Value:", text)
            end
        })
        
        dropdown.AddButton({
            Text = "Apply Settings",
            Callback = function()
                Window:Notify({
                    Title = "Settings",
                    Text = "All settings applied!",
                    Duration = 2
                })
            end
        })
    end
})

-- Add UI Settings to the bottom of Examples section
Window:AddUISettingsToSection(ExamplesSection)

-- Initial notification
Window:Notify({
    Title = "Welcome!",
    Text = "Eps1llon Hub loaded successfully!",
    Duration = 5
})

-- Tips
print([[
=== Eps1llon Hub Tips ===
- Press RightShift to toggle UI visibility
- Click the gear icon for UI settings
- Drag windows by the title bar
- Resize by dragging the bottom-right corner
- Click minimize (-) to shrink to icon
- All your active features appear in the floating panel
========================
]])
