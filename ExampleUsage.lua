-- UILib Example Usage
-- This script demonstrates all features of the UILib library

-- Load the library
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/UILib/main/Source.lua"))()

-- Create main window
local Window = UILib:CreateWindow({
    Title = "UILib Example Hub",
    SubTitle = "v1.0.0 - Full Demo",
    SaveFolder = "UILibExample", -- Settings will be saved here
    IntroEnabled = true,
    IntroText = "UILib Example",
    IntroIcon = "rbxassetid://7733964370",
    Icon = "rbxassetid://7733964370",
    DisableUIToggle = false
})

-- ========================================
-- Tab 1: Basic Elements
-- ========================================
local BasicTab = Window:CreateTab({
    Name = "Basic Elements",
    Icon = "rbxassetid://7733960981"
})

-- Button Example
BasicTab:AddButton({
    Title = "Print Message",
    Description = "Click to print a message to console",
    Callback = function()
        print("Hello from UILib!")
        UILib:Notify({
            Title = "Button Clicked",
            Content = "Check your console for the message!",
            Duration = 3
        })
    end
})

-- Toggle Example
local GodmodeToggle = BasicTab:AddToggle({
    Title = "Godmode",
    Description = "Enable godmode (example)",
    Default = false,
    Callback = function(value)
        if value then
            print("Godmode enabled!")
            -- Your godmode code here
        else
            print("Godmode disabled!")
            -- Disable godmode code here
        end
    end
})

-- Slider Example
local WalkspeedSlider = BasicTab:AddSlider({
    Title = "Walkspeed",
    Description = "Adjust your walkspeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 0,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Dropdown Example
local TeamDropdown = BasicTab:AddDropdown({
    Title = "Select Team",
    Description = "Choose a team to join",
    Options = {"Red Team", "Blue Team", "Green Team", "Yellow Team"},
    Default = 1,
    Callback = function(selected)
        print("Selected team:", selected)
        UILib:Notify({
            Title = "Team Selected",
            Content = "You selected: " .. selected,
            Duration = 2
        })
    end
})

-- ========================================
-- Tab 2: Advanced Elements
-- ========================================
local AdvancedTab = Window:CreateTab({
    Name = "Advanced",
    Icon = "rbxassetid://7733956134"
})

-- Color Picker Example
local ColorPicker = AdvancedTab:AddColorPicker({
    Title = "UI Color",
    Description = "Change UI accent color",
    Default = Color3.fromRGB(59, 130, 246),
    Callback = function(color)
        print("Color changed to:", color)
        -- You could update UI elements with this color
    end
})

-- Textbox Example
local UsernameBox = AdvancedTab:AddTextbox({
    Title = "Target Player",
    Description = "Enter a player's username",
    Default = "",
    PlaceholderText = "Enter username...",
    Callback = function(text)
        print("Target player set to:", text)
        -- Your targeting code here
    end
})

-- Keybind Example
local FlyBind = AdvancedTab:AddBind({
    Title = "Fly Keybind",
    Description = "Press this key to toggle fly",
    Default = Enum.KeyCode.F,
    Hold = false,
    Callback = function()
        print("Fly key pressed!")
        -- Your fly toggle code here
    end,
    UpdateBind = function(key)
        print("Fly keybind changed to:", tostring(key))
    end
})

-- Section Example
local CombatSection = AdvancedTab:AddSection({
    Title = "Combat Settings"
})

CombatSection:AddToggle({
    Title = "Aimbot",
    Description = "Enable aimbot",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value and "Enabled" or "Disabled")
    end
})

CombatSection:AddSlider({
    Title = "FOV Size",
    Description = "Aimbot field of view",
    Min = 10,
    Max = 500,
    Default = 100,
    Rounding = 0,
    Callback = function(value)
        print("FOV Size:", value)
    end
})

-- ========================================
-- Tab 3: Information
-- ========================================
local InfoTab = Window:CreateTab({
    Name = "Information",
    Icon = "rbxassetid://7733964719"
})

-- Label Example
InfoTab:AddLabel({
    Title = "Script Info",
    Content = "UILib Example v1.0.0"
})

-- Paragraph Example
InfoTab:AddParagraph({
    Title = "About This Script",
    Content = "This is a demonstration of all UILib features. Each element showcases different functionality that you can use in your own scripts. Feel free to modify and experiment!"
})

InfoTab:AddParagraph({
    Title = "Features",
    Content = "• Modern UI Design\n• Smooth Animations\n• Auto-Save Settings\n• Customizable Elements\n• Easy to Use API"
})

-- Add some spacing
InfoTab:AddLabel({
    Title = "",
    Content = ""
})

-- Credits section
local CreditsSection = InfoTab:AddSection({
    Title = "Credits"
})

CreditsSection:AddParagraph({
    Title = "Developer",
    Content = "UILib created by JustClips"
})

CreditsSection:AddButton({
    Title = "GitHub Repository",
    Description = "Open the GitHub page",
    Callback = function()
        setclipboard("https://github.com/JustClips/UILib")
        UILib:Notify({
            Title = "Copied!",
            Content = "GitHub link copied to clipboard",
            Duration = 2
        })
    end
})

-- ========================================
-- Tab 4: Settings & Examples
-- ========================================
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://7733956134"
})

-- UI Settings Section
local UISection = SettingsTab:AddSection({
    Title = "UI Settings"
})

UISection:AddButton({
    Title = "Destroy UI",
    Description = "Remove the UI completely",
    Callback = function()
        Window:Destroy()
    end
})

UISection:AddToggle({
    Title = "Rainbow UI",
    Description = "Enable rainbow effect (example)",
    Default = false,
    Callback = function(value)
        if value then
            print("Rainbow mode enabled!")
            -- Add rainbow effect code here
        else
            print("Rainbow mode disabled!")
        end
    end
})

-- Notification Examples Section
local NotifSection = SettingsTab:AddSection({
    Title = "Notification Examples"
})

NotifSection:AddButton({
    Title = "Success Notification",
    Description = "Show a success message",
    Callback = function()
        UILib:Notify({
            Title = "Success!",
            Content = "Operation completed successfully!",
            Duration = 3
        })
    end
})

NotifSection:AddButton({
    Title = "Error Notification",
    Description = "Show an error message",
    Callback = function()
        UILib:Notify({
            Title = "Error!",
            Content = "Something went wrong!",
            Duration = 3
        })
    end
})

NotifSection:AddButton({
    Title = "Long Notification",
    Description = "Show a longer notification",
    Callback = function()
        UILib:Notify({
            Title = "Information",
            Content = "This is a longer notification that demonstrates how the notification system handles longer text content.",
            Duration = 5
        })
    end
})

-- ========================================
-- Dynamic Updates Example
-- ========================================

-- Example of updating elements after creation
task.wait(2)
GodmodeToggle:UpdateToggle(true) -- Enable godmode toggle after 2 seconds

-- Example of updating dropdown options
task.wait(5)
TeamDropdown:UpdateDropdown("Blue Team") -- Change selected team after 5 seconds

-- Show welcome notification
UILib:Notify({
    Title = "Welcome!",
    Content = "UILib loaded successfully. Explore all the features!",
    Duration = 5
})

print("UILib Example loaded! Press RightShift to toggle UI visibility.")
