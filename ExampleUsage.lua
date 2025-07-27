-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                     EPS1LLON HUB UI LIBRARY DOCUMENTATION                       ║
-- ║                          Complete Usage Guide & Examples                        ║
-- ║                              By: JustClips                                      ║
-- ║                         Date: 2025-07-27 17:41:03 UTC                          ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

--[[
    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
    █                                                                              █
    █                           TABLE OF CONTENTS                                  █
    █                                                                              █
    █  1. GETTING STARTED                                                          █
    █     - Loading the Library                                                    █
    █     - Creating the UI                                                        █
    █     - Configuration Options                                                  █
    █                                                                              █
    █  2. UI ELEMENTS                                                              █
    █     - Button                                                                 █
    █     - Toggle                                                                 █
    █     - Slider                                                                 █
    █     - Input Box                                                              █
    █     - Dropdown                                                               █
    █     - BigDropdown                                                            █
    █     - SearchBox                                                              █
    █     - Keybind                                                                █
    █     - Label                                                                  █
    █     - Separator                                                              █
    █                                                                              █
    █  3. CUSTOMIZATION                                                            █
    █     - Themes                                                                 █
    █     - Fonts                                                                  █
    █     - Backgrounds                                                            █
    █     - UI Settings                                                            █
    █                                                                              █
    █  4. ADVANCED FEATURES                                                        █
    █     - Notifications                                                          █
    █     - Active Functions Display                                               █
    █     - Programmatic Control                                                   █
    █     - Section Management                                                     █
    █                                                                              █
    █  5. COMPLETE EXAMPLES                                                        █
    █                                                                              █
    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
]]

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 1. GETTING STARTED
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Loading the Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Uilib.lua"))()

-- Creating the UI with all available options
local UI = Library:Create({
    -- THEMES (Choose one)
    Theme = "Ocean",              -- Options: "Dark" | "Light" | "Purple" | "Ocean"
    
    -- KEYBIND
    ToggleKey = Enum.KeyCode.RightShift,  -- Key to show/hide UI
    
    -- BACKGROUNDS (Choose one)
    Background = "Blue Sky",      -- Options: "Blue Sky" | "Mountains" | "Blurred Stars"
    
    -- FONTS (Choose one)
    Font = "Ubuntu",              -- Options: "Ubuntu" | "Gotham" | "GothamBold" | "SourceSans" | 
                                 -- "SourceSansBold" | "Code" | "Highway" | "SciFi" | "Arial" | "ArialBold"
    
    -- UI APPEARANCE
    ButtonDarkness = 0.5,         -- 0 = fully transparent, 1 = fully opaque
    StrokeThickness = 1,          -- Border thickness (0-5)
    
    -- SECTION HEADERS
    SectionHeaderEnabled = true,   -- Show headers in content area
    SectionHeaderWhite = false,    -- Make headers white instead of accent color
    
    -- UI SETTINGS SECTION
    HideUISettings = false,        -- Hide the default UI Settings section
    UISettingsAtBottom = true,     -- Keep UI Settings at bottom of sections
    
    -- ADVANCED SECTION HEADER CONFIG
    SectionHeaderConfig = {
        Size = 22,                        -- Font size
        Font = Enum.Font.GothamBold,      -- Font style
        Color = nil,                      -- Custom color (nil = theme accent)
        Position = "Center",              -- "Center" | "Left" | "Right"
        UnderlineEnabled = true,          -- Show underline
        UnderlineSize = 0.5,              -- Width (0-1, fraction of header width)
        UnderlineThickness = 2            -- Thickness in pixels
    }
})

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 2. UI ELEMENTS - Complete Reference
-- ═══════════════════════════════════════════════════════════════════════════════════

-- First, create sections to organize your UI
local Section1 = UI:CreateSection("Main")
local Section2 = UI:CreateSection("Features")
local Section3 = UI:CreateSection("Settings")

-- ───────────────────────────────────────────────────────────────────────────────────
-- BUTTON - Clickable button with hover effects
-- ───────────────────────────────────────────────────────────────────────────────────
local Button = UI:CreateButton(Section1, {
    Text = "Click Me!",                    -- Button text
    Callback = function()                  -- Function to run when clicked
        print("Button was clicked!")
        -- Your code here
    end
})

-- ───────────────────────────────────────────────────────────────────────────────────
-- TOGGLE - On/Off switch with animation
-- ───────────────────────────────────────────────────────────────────────────────────
local Toggle = UI:CreateToggle(Section1, {
    Text = "Enable Feature",               -- Toggle label
    Default = false,                       -- Starting state (true/false)
    Callback = function(enabled)           -- Function called when toggled
        print("Toggle is now:", enabled)
        if enabled then
            -- Code when enabled
        else
            -- Code when disabled
        end
    end
})

-- You can also set toggle state programmatically:
-- Toggle.Set(true)  -- Enable
-- Toggle.Set(false) -- Disable

-- ───────────────────────────────────────────────────────────────────────────────────
-- SLIDER - Value slider with live updates
-- ───────────────────────────────────────────────────────────────────────────────────
local Slider = UI:CreateSlider(Section1, {
    Text = "Speed",                        -- Slider label
    Min = 0,                               -- Minimum value
    Max = 100,                             -- Maximum value
    Default = 50,                          -- Starting value
    Callback = function(value)             -- Called when value changes
        print("Slider value:", value)
        -- Your code here
    end
})

-- Access current value: Slider.Value

-- ───────────────────────────────────────────────────────────────────────────────────
-- INPUT BOX - Text input field
-- ───────────────────────────────────────────────────────────────────────────────────
local Input = UI:CreateInput(Section1, {
    Text = "Username",                     -- Label
    Default = "Player",                    -- Default text
    Placeholder = "Enter username...",     -- Placeholder when empty
    Callback = function(text, enterPressed) -- Called when focus lost or enter pressed
        print("Input text:", text)
        print("Enter pressed:", enterPressed)
        -- Your code here
    end
})

-- ───────────────────────────────────────────────────────────────────────────────────
-- DROPDOWN - Selection menu
-- ───────────────────────────────────────────────────────────────────────────────────
local Dropdown = UI:CreateDropdown(Section1, {
    Text = "Select Option",                -- Label
    Options = {"Option 1", "Option 2", "Option 3"}, -- Available options
    Default = "Option 1",                  -- Default selection
    Callback = function(selected)          -- Called when option selected
        print("Selected:", selected)
        -- Your code here
    end
})

-- ───────────────────────────────────────────────────────────────────────────────────
-- BIGDROPDOWN - Expandable container for multiple elements
-- ───────────────────────────────────────────────────────────────────────────────────
local BigDropdown = UI:CreateBigDropdown(Section2, {
    Text = "⚙️ Advanced Settings",         -- Dropdown title
    CreateElements = function(dropdown)     -- Function to add elements
        -- Add any UI element inside the dropdown
        
        dropdown.AddToggle({
            Text = "Sub Feature 1",
            Default = false,
            Callback = function(enabled)
                print("Sub feature 1:", enabled)
            end
        })
        
        dropdown.AddSlider({
            Text = "Sub Slider",
            Min = 0,
            Max = 10,
            Default = 5,
            Callback = function(value)
                print("Sub slider:", value)
            end
        })
        
        dropdown.AddButton({
            Text = "Sub Button",
            Callback = function()
                print("Sub button clicked")
            end
        })
        
        dropdown.AddInput({
            Text = "Sub Input",
            Placeholder = "Type here...",
            Callback = function(text)
                print("Sub input:", text)
            end
        })
        
        dropdown.AddSeparator() -- Visual divider
        
        dropdown.AddLabel({
            Text = "Information Label",
            Color = UI.Theme.Accent  -- Optional custom color
        })
    end
})

-- ───────────────────────────────────────────────────────────────────────────────────
-- SEARCHBOX - Dynamic search with filtering
-- ───────────────────────────────────────────────────────────────────────────────────
local SearchBox = UI:CreateSearchBox(Section2, {
    Placeholder = "Search items...",       -- Search placeholder
    Items = {"Apple", "Banana", "Orange", "Grape"}, -- Items to search
    OnSelected = function(item)            -- Called when item selected
        print("Selected item:", item)
        -- Your code here
    end,
    OnSearch = function(searchText, items) -- Custom search logic (optional)
        -- Return filtered items based on searchText
        local results = {}
        for _, item in pairs(items) do
            if item:lower():find(searchText:lower()) then
                table.insert(results, item)
            end
        end
        return results
    end
})

-- Update search items dynamically:
-- SearchBox.UpdateItems({"New", "Items", "Here"})

-- ───────────────────────────────────────────────────────────────────────────────────
-- KEYBIND - Key binding functionality
-- ───────────────────────────────────────────────────────────────────────────────────
local Keybind = UI:CreateKeybind(Section2, {
    Text = "Hotkey",                       -- Label
    Default = Enum.KeyCode.F,              -- Default key
    Callback = function()                  -- Called when key pressed
        print("Keybind pressed!")
        -- Your code here
    end
})

-- ───────────────────────────────────────────────────────────────────────────────────
-- LABEL - Text display
-- ───────────────────────────────────────────────────────────────────────────────────
local Label = UI:CreateLabel(Section2, {
    Text = "Information Text",             -- Label text
    Color = Color3.fromRGB(255, 255, 0)   -- Optional text color
})

-- ───────────────────────────────────────────────────────────────────────────────────
-- SEPARATOR - Visual divider line
-- ───────────────────────────────────────────────────────────────────────────────────
UI:CreateSeparator(Section2)  -- No configuration needed

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 3. CUSTOMIZATION - Runtime Changes
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Change theme at runtime
UI:SetTheme("Purple")  -- "Dark" | "Light" | "Purple" | "Ocean"

-- Change font at runtime
UI:SetFont("GothamBold")  -- Any available font

-- Change background at runtime
UI:SetBackground("Mountains")  -- "Blue Sky" | "Mountains" | "Blurred Stars"

-- Adjust UI appearance
UI:SetButtonDarkness(0.7)   -- 0-1
UI:SetStrokeThickness(2)    -- 0-5

-- Change toggle key
UI:SetToggleKey(Enum.KeyCode.Insert)

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 4. ADVANCED FEATURES
-- ═══════════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────────
-- NOTIFICATIONS - Show temporary messages
-- ───────────────────────────────────────────────────────────────────────────────────
UI:Notify({
    Title = "Success!",                    -- Notification title
    Text = "Operation completed",          -- Notification text
    Duration = 3                           -- Duration in seconds
})

-- ───────────────────────────────────────────────────────────────────────────────────
-- ACTIVE FUNCTIONS DISPLAY
-- ───────────────────────────────────────────────────────────────────────────────────
-- The UI automatically shows active toggles and features in a floating window
-- This happens automatically when toggles are enabled

-- ───────────────────────────────────────────────────────────────────────────────────
-- CUSTOM UI SETTINGS PLACEMENT
-- ───────────────────────────────────────────────────────────────────────────────────
-- If you hide default UI Settings, you can add them to any section:
if UI.HideUISettings then
    UI:AddUISettingsToSection(Section3)
end

-- ───────────────────────────────────────────────────────────────────────────────────
-- SECTION MANAGEMENT
-- ───────────────────────────────────────────────────────────────────────────────────
-- Sections are automatically managed, but you can control their order:
local FirstSection = UI:CreateSection("First")   -- Will appear first
local LastSection = UI:CreateSection("Last")     -- Will appear after First
-- UI Settings will always be at bottom if UISettingsAtBottom = true

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 5. COMPLETE WORKING EXAMPLE
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Clean example showing all features
local ExampleUI = Library:Create({
    Theme = "Ocean",
    ToggleKey = Enum.KeyCode.RightShift,
    Background = "Blue Sky"
})

-- Create sections
local MainSection = ExampleUI:CreateSection("Main")
local PlayerSection = ExampleUI:CreateSection("Player")
local VisualsSection = ExampleUI:CreateSection("Visuals")

-- Main Features
ExampleUI:CreateLabel(MainSection, {
    Text = "Game Enhancements",
    Color = ExampleUI.Theme.Accent
})

ExampleUI:CreateToggle(MainSection, {
    Text = "God Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
        else
            game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
        end
    end
})

-- Player Controls
local PlayerControls = ExampleUI:CreateBigDropdown(PlayerSection, {
    Text = "🏃 Movement Settings",
    CreateElements = function(dropdown)
        dropdown.AddSlider({
            Text = "Walk Speed",
            Min = 16,
            Max = 200,
            Default = 16,
            Callback = function(value)
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
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
        
        dropdown.AddToggle({
            Text = "Infinite Jump",
            Default = false,
            Callback = function(enabled)
                -- Infinite jump implementation
                local InfiniteJump = enabled
                game:GetService("UserInputService").JumpRequest:Connect(function()
                    if InfiniteJump then
                        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                    end
                end)
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

-- Visual Settings
ExampleUI:CreateSearchBox(VisualsSection, {
    Placeholder = "Search players to highlight...",
    Items = {},
    OnSelected = function(playerName)
        local player = game.Players:FindFirstChild(playerName)
        if player and player.Character then
            -- Highlight player logic
            ExampleUI:Notify({
                Title = "Player Selected",
                Text = "Now tracking: " .. playerName,
                Duration = 3
            })
        end
    end
})

-- Update player list
local function UpdatePlayerList()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        table.insert(players, player.Name)
    end
    -- Update search box items (assuming you stored the searchbox)
end

game.Players.PlayerAdded:Connect(UpdatePlayerList)
UpdatePlayerList()

-- Show welcome notification
ExampleUI:Notify({
    Title = "Welcome!",
    Text = "Press " .. ExampleUI.ToggleKey.Name .. " to toggle UI",
    Duration = 5
})

-- ═══════════════════════════════════════════════════════════════════════════════════
-- ADDITIONAL TIPS & TRICKS
-- ═══════════════════════════════════════════════════════════════════════════════════

--[[
    💡 TIPS:
    
    1. UI ORGANIZATION
       - Use sections to group related features
       - Use BigDropdowns to create collapsible feature groups
       - Use separators and labels to visually organize elements
    
    2. PERFORMANCE
       - The UI automatically handles cleanup when destroyed
       - Animations are optimized for smooth performance
       - Active functions display updates automatically
    
    3. USER EXPERIENCE
       - All interactive elements show visual feedback
       - Hover effects indicate clickable areas
       - Smooth animations make the UI feel professional
    
    4. BEST PRACTICES
       - Always provide clear labels for features
       - Use appropriate input types (toggle for on/off, slider for ranges)
       - Group related settings in BigDropdowns
       - Show notifications for important actions
    
    5. KEYBOARD SHORTCUTS
       - Default toggle: RightShift (customizable)
       - UI is draggable by the title bar
       - UI is resizable by dragging the bottom-right corner
       - Minimize button creates a floating icon
    
    6. DESTROY UI
       - When done, clean up with: UI:Destroy()
]]

-- ═══════════════════════════════════════════════════════════════════════════════════
-- ERROR HANDLING EXAMPLE
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Safe UI creation with error handling
local success, UI = pcall(function()
    return Library:Create({Theme = "Ocean"})
end)

if success then
    print("UI created successfully!")
else
    warn("Failed to create UI:", UI)
end

-- ═══════════════════════════════════════════════════════════════════════════════════
-- QUICK REFERENCE CARD
-- ═══════════════════════════════════════════════════════════════════════════════════

--[[
╔════════════════════════════════════════════════════════════════════════════════╗
║                              QUICK REFERENCE                                    ║
╠════════════════════════════════════════════════════════════════════════════════╣
║ ELEMENT          │ RETURNS          │ KEY METHODS/PROPERTIES                   ║
╠══════════════════╪══════════════════╪══════════════════════════════════════════╣
║ CreateButton     │ button object    │ .Frame, .Button                          ║
║ CreateToggle     │ toggle object    │ .Set(bool), .Enabled                     ║
║ CreateSlider     │ slider object    │ .Value                                   ║
║ CreateInput      │ input object     │ .TextBox                                 ║
║ CreateDropdown   │ dropdown object  │ .Selected, .Options                      ║
║ CreateBigDropdown│ bigdropdown obj  │ .AddToggle(), .AddSlider(), etc.         ║
║ CreateSearchBox  │ searchbox object │ .UpdateItems(table)                      ║
║ CreateKeybind    │ keybind object   │ .Key                                     ║
║ CreateLabel      │ label object     │ .Label                                   ║
║ CreateSeparator  │ separator object │ (none)                                   ║
╠══════════════════╪══════════════════╪══════════════════════════════════════════╣
║ LIBRARY METHODS  │                  │                                          ║
╠══════════════════╪══════════════════╪══════════════════════════════════════════╣
║ :Create()        │ UI object        │ Creates main UI                          ║
║ :CreateSection() │ section object   │ Creates a new section                    ║
║ :SetTheme()      │ void             │ Changes theme                            ║
║ :SetFont()       │ void             │ Changes font                             ║
║ :SetBackground() │ void             │ Changes background                       ║
║ :Notify()        │ void             │ Shows notification                       ║
║ :Destroy()       │ void             │Destroys UI                             ║
╚════════════════════════════════════════════════════════════════════════════════╝
]]

print("Eps1llon Hub UI Library loaded successfully!")
print("Documentation by: JustClips")
print("GitHub: https://github.com/JustClips/Uilib")
