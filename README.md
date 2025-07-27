-- Load the UI Library
local Library = loadstring(game:HttpGet("YOUR_UI_LIBRARY_URL_HERE"))()

-- Create the main UI window with custom configuration
local Window = Library:Create({
    Theme = "Ocean",                    -- Available: Dark, Light, Purple, Ocean
    ToggleKey = Enum.KeyCode.RightShift, -- Key to show/hide UI
    ButtonDarkness = 0.3,               -- 0 = transparent, 1 = opaque
    StrokeThickness = 1.5,              -- Border thickness
    Font = "Ubuntu",                    -- Default font
    Background = "Blue Sky",            -- Default background
    SectionHeaderEnabled = true,        -- Show section headers
    SectionHeaderWhite = false,         -- Use theme color for headers
    DropdownSections = false,           -- Normal sections (not dropdown)
    SectionHeaderConfig = {
        Size = 24,
        Font = Enum.Font.GothamBold,
        Color = nil,                    -- nil = use theme color
        Position = "Center",            -- Center, Left, Right
        UnderlineEnabled = true,
        UnderlineSize = 0.6,           -- 60% of header width
        UnderlineThickness = 2
    }
})

-- Create sections
local MainSection = Window:CreateSection("Main")
local CombatSection = Window:CreateSection("Combat")
local VisualsSection = Window:CreateSection("Visuals")
local MiscSection = Window:CreateSection("Misc")
local SettingsSection = Window:CreateSection("Settings")

-- Main Section Elements
Window:CreateLabel(MainSection, {
    Text = "Welcome to Eps1llon Hub!",
    Color = Color3.fromRGB(100, 200, 255)
})

Window:CreateSeparator(MainSection)

-- Button Example
local SpeedButton = Window:CreateButton(MainSection, {
    Text = "Speed Boost",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
        Window:Notify({
            Title = "Speed Boost",
            Text = "Your speed has been increased!",
            Duration = 3
        })
    end
})

-- Toggle Example
local GodModeToggle = Window:CreateToggle(MainSection, {
    Text = "God Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            -- Enable god mode logic
            print("God Mode Enabled")
        else
            -- Disable god mode logic
            print("God Mode Disabled")
        end
    end
})

-- Slider Example
local JumpPowerSlider = Window:CreateSlider(MainSection, {
    Text = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Input Box Example
local TeleportInput = Window:CreateInput(MainSection, {
    Text = "Player Name",
    Placeholder = "Enter player name...",
    Callback = function(text, enterPressed)
        if enterPressed then
            -- Teleport to player logic
            print("Teleporting to:", text)
        end
    end
})

-- Dropdown Example
local WeaponDropdown = Window:CreateDropdown(MainSection, {
    Text = "Select Weapon",
    Options = {"Sword", "Gun", "Bow", "Staff", "Dagger"},
    Default = "Sword",
    Callback = function(selected)
        print("Selected weapon:", selected)
    end
})

-- Big Dropdown Example (New Feature)
local AdvancedSettings = Window:CreateBigDropdown(MainSection, {
    Text = "Advanced Options",
    CreateElements = function(dropdown)
        dropdown.AddLabel({Text = "Movement Settings", Color = Color3.fromRGB(255, 200, 100)})
        
        dropdown.AddToggle({
            Text = "Auto Sprint",
            Default = false,
            Callback = function(v) print("Auto Sprint:", v) end
        })
        
        dropdown.AddSlider({
            Text = "Sprint Speed",
            Min = 16,
            Max = 100,
            Default = 30,
            Callback = function(v) print("Sprint Speed:", v) end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddLabel({Text = "Jump Settings"})
        
        dropdown.AddToggle({
            Text = "Infinite Jump",
            Callback = function(v) print("Infinite Jump:", v) end
        })
        
        dropdown.AddInput({
            Text = "Jump Height",
            Placeholder = "50-500",
            Callback = function(text) print("Jump Height:", text) end
        })
        
        dropdown.AddButton({
            Text = "Reset to Defaults",
            Callback = function()
                print("Settings reset!")
            end
        })
    end
})

-- Combat Section Elements
Window:CreateKeybind(CombatSection, {
    Text = "Aimbot",
    Default = Enum.KeyCode.E,
    Callback = function()
        print("Aimbot activated!")
    end
})

local ESPToggle = Window:CreateToggle(CombatSection, {
    Text = "Enable ESP",
    Default = false,
    Callback = function(enabled)
        -- ESP logic here
        print("ESP:", enabled)
    end
})

local FOVSlider = Window:CreateSlider(CombatSection, {
    Text = "Aimbot FOV",
    Min = 10,
    Max = 360,
    Default = 90,
    Callback = function(value)
        print("FOV set to:", value)
    end
})

-- Search Box Example
local PlayerSearch = Window:CreateSearchBox(CombatSection, {
    Placeholder = "Search players...",
    Items = {}, -- Will be populated dynamically
    OnSelected = function(player)
        print("Selected player:", player)
    end,
    OnSearch = function(searchText, items)
        -- Custom search logic
        local filtered = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Name:lower():find(searchText) then
                table.insert(filtered, player.Name)
            end
        end
        return filtered
    end
})

-- Update search items dynamically
spawn(function()
    while wait(1) do
        local players = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(players, player.Name)
        end
        PlayerSearch.UpdateItems(players)
    end
end)

-- Visuals Section
local ColorPicker = Window:CreateButton(VisualsSection, {
    Text = "UI Color (Coming Soon)",
    Callback = function()
        Window:Notify({
            Title = "Coming Soon",
            Text = "Color picker will be added in next update!",
            Duration = 2
        })
    end
})

local CrosshairToggle = Window:CreateToggle(VisualsSection, {
    Text = "Custom Crosshair",
    Default = false,
    Callback = function(enabled)
        -- Crosshair logic
    end
})

local CrosshairSize = Window:CreateSlider(VisualsSection, {
    Text = "Crosshair Size",
    Min = 1,
    Max = 50,
    Default = 10,
    Callback = function(value)
        -- Update crosshair size
    end
})

-- Big Dropdown for Visual Settings
local VisualPresets = Window:CreateBigDropdown(VisualsSection, {
    Text = "Visual Presets",
    CreateElements = function(dropdown)
        dropdown.AddLabel({Text = "Quick Presets"})
        
        dropdown.AddButton({
            Text = "Competitive",
            Callback = function()
                -- Apply competitive visual settings
                print("Applied Competitive preset")
            end
        })
        
        dropdown.AddButton({
            Text = "Cinematic",
            Callback = function()
                -- Apply cinematic visual settings
                print("Applied Cinematic preset")
            end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddToggle({
            Text = "Motion Blur",
            Callback = function(v) print("Motion Blur:", v) end
        })
        
        dropdown.AddToggle({
            Text = "Bloom Effects",
            Callback = function(v) print("Bloom:", v) end
        })
        
        dropdown.AddSlider({
            Text = "Render Distance",
            Min = 100,
            Max = 1000,
            Default = 500,
            Callback = function(v) print("Render Distance:", v) end
        })
    end
})

-- Misc Section
Window:CreateButton(MiscSection, {
    Text = "Server Hop",
    Callback = function()
        -- Server hop logic
        print("Hopping servers...")
    end
})

Window:CreateButton(MiscSection, {
    Text = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

Window:CreateToggle(MiscSection, {
    Text = "Anti-AFK",
    Default = true,
    Callback = function(enabled)
        -- Anti-AFK logic
        print("Anti-AFK:", enabled)
    end
})

Window:CreateInput(MiscSection, {
    Text = "Chat Spam",
    Placeholder = "Message to spam...",
    Callback = function(text, enterPressed)
        if enterPressed and text ~= "" then
            -- Chat spam logic
            print("Spamming:", text)
        end
    end
})

-- Settings Section (Additional to built-in UI Settings)
Window:CreateLabel(SettingsSection, {
    Text = "Game Settings",
    Color = Color3.fromRGB(255, 255, 100)
})

Window:CreateSeparator(SettingsSection)

local FPSCapDropdown = Window:CreateDropdown(SettingsSection, {
    Text = "FPS Cap",
    Options = {"30", "60", "120", "144", "240", "Unlimited"},
    Default = "60",
    Callback = function(selected)
        if selected == "Unlimited" then
            setfpscap(999)
        else
            setfpscap(tonumber(selected))
        end
    end
})

Window:CreateToggle(SettingsSection, {
    Text = "Show FPS",
    Default = false,
    Callback = function(enabled)
        -- FPS counter logic
        print("Show FPS:", enabled)
    end
})

Window:CreateButton(SettingsSection, {
    Text = "Export Settings",
    Callback = function()
        -- Export settings to clipboard
        Window:Notify({
            Title = "Settings",
            Text = "Settings copied to clipboard!",
            Duration = 2
        })
    end
})

Window:CreateButton(SettingsSection, {
    Text = "Load Config",
    Callback = function()
        -- Load config logic
        print("Loading config...")
    end
})

-- Example of programmatically changing settings
wait(2)

-- Change theme
Window:SetTheme("Purple")

-- Change font
Window:SetFont("GothamBold")

-- Change button darkness
Window:SetButtonDarkness(0.5)

-- Change stroke thickness
Window:SetStrokeThickness(2)

-- Change background
Window:SetBackground("Mountains")

-- Update section headers
Window.SectionHeaderConfig.Size = 26
Window.SectionHeaderConfig.Position = "Left"
Window:UpdateSectionHeaders()

-- Send notification
Window:Notify({
    Title = "UI Loaded",
    Text = "All features have been loaded successfully!",
    Duration = 5
})

-- Example of using toggle methods
wait(3)
GodModeToggle.Set(true) -- Enable god mode programmatically

-- Example of dropdown sections (uncomment to test)
--[[
local Window2 = Library:Create({
    Theme = "Dark",
    DropdownSections = true, -- This makes sections collapsible
})

local Section1 = Window2:CreateSection("Dropdown Section 1")
Window2:CreateButton(Section1, {Text = "Button 1"})
Window2:CreateToggle(Section1, {Text = "Toggle 1"})

local Section2 = Window2:CreateSection("Dropdown Section 2")
Window2:CreateSlider(Section2, {Text = "Slider 1"})
--]]

print("UI Library loaded successfully!")
print("Press", Window.ToggleKey.Name, "to toggle UI visibility")
