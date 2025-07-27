--[[
    Eps1llon Hub Premium UI Library - Full Example Usage
    Author: JustClips
    Date: 2025-01-27 15:31:04 UTC
    Version: 2.0
    
    This example demonstrates every feature of the UI library
]]

-- Load the UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/eps1llon-hub/main/UILibrary.lua"))()

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- ========================================
-- WINDOW CREATION WITH ALL OPTIONS
-- ========================================

local Window = Library:Create({
    -- Theme Options: "Dark", "Light", "Purple", "Ocean"
    Theme = "Ocean",
    
    -- Toggle key to show/hide UI
    ToggleKey = Enum.KeyCode.RightShift,
    
    -- Button transparency (0 = fully transparent, 1 = fully opaque)
    ButtonDarkness = 0.3,
    
    -- Border thickness (0-5)
    StrokeThickness = 1.5,
    
    -- Font Options: "Ubuntu", "Gotham", "GothamBold", "SourceSans", etc.
    Font = "Ubuntu",
    
    -- Background Options: "Blue Sky", "Mountains", "Blurred Stars"
    Background = "Blue Sky",
    
    -- Section header settings
    SectionHeaderEnabled = true,
    SectionHeaderWhite = false,
    DropdownSections = false,
    
    -- Advanced header configuration
    SectionHeaderConfig = {
        Size = 24,
        Font = Enum.Font.GothamBold,
        Color = nil, -- nil uses theme color
        Position = "Center", -- "Center", "Left", "Right"
        UnderlineEnabled = true,
        UnderlineSize = 0.6,
        UnderlineThickness = 2
    }
})

-- ========================================
-- CREATE SECTIONS
-- ========================================

local HomeSection = Window:CreateSection("Home")
local PlayerSection = Window:CreateSection("Player")
local CombatSection = Window:CreateSection("Combat")
local VisualsSection = Window:CreateSection("Visuals")
local TeleportSection = Window:CreateSection("Teleport")
local MiscSection = Window:CreateSection("Misc")
local ConfigSection = Window:CreateSection("Config")

-- ========================================
-- HOME SECTION
-- ========================================

-- Welcome Label
Window:CreateLabel(HomeSection, {
    Text = "Welcome to Eps1llon Hub Premium!",
    Color = Color3.fromRGB(100, 200, 255)
})

Window:CreateSeparator(HomeSection)

-- Status Label
local StatusLabel = Window:CreateLabel(HomeSection, {
    Text = "Status: Connected",
    Color = Color3.fromRGB(100, 255, 100)
})

-- Info Button
Window:CreateButton(HomeSection, {
    Text = "Show Info",
    Callback = function()
        Window:Notify({
            Title = "Information",
            Text = "Eps1llon Hub v2.0 - Created by JustClips",
            Duration = 4
        })
    end
})

-- Discord Button
Window:CreateButton(HomeSection, {
    Text = "Copy Discord",
    Callback = function()
        setclipboard("discord.gg/eps1llon")
        Window:Notify({
            Title = "Discord",
            Text = "Discord link copied to clipboard!",
            Duration = 2
        })
    end
})

-- Big Dropdown Example - Quick Actions
local QuickActions = Window:CreateBigDropdown(HomeSection, {
    Text = "Quick Actions",
    CreateElements = function(dropdown)
        dropdown.AddLabel({
            Text = "Common Actions",
            Color = Color3.fromRGB(255, 200, 100)
        })
        
        dropdown.AddButton({
            Text = "Respawn",
            Callback = function()
                LocalPlayer.Character:BreakJoints()
            end
        })
        
        dropdown.AddButton({
            Text = "Reset Camera",
            Callback = function()
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddToggle({
            Text = "Hide Username",
            Default = false,
            Callback = function(enabled)
                LocalPlayer.Character.Humanoid.DisplayDistanceType = enabled and 
                    Enum.HumanoidDisplayDistanceType.None or 
                    Enum.HumanoidDisplayDistanceType.Viewer
            end
        })
    end
})

-- ========================================
-- PLAYER SECTION
-- ========================================

-- Walk Speed Slider
local WalkSpeedSlider = Window:CreateSlider(PlayerSection, {
    Text = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(value)
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Jump Power Slider
local JumpPowerSlider = Window:CreateSlider(PlayerSection, {
    Text = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(value)
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Gravity Slider
local GravitySlider = Window:CreateSlider(PlayerSection, {
    Text = "Gravity",
    Min = 0,
    Max = 196.2,
    Default = 196.2,
    Callback = function(value)
        workspace.Gravity = value
    end
})

Window:CreateSeparator(PlayerSection)

-- God Mode Toggle
local GodModeToggle = Window:CreateToggle(PlayerSection, {
    Text = "God Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            LocalPlayer.Character.Humanoid.Health = math.huge
        else
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
        end
    end
})

-- Infinite Jump Toggle
local InfJumpConnection
local InfJumpToggle = Window:CreateToggle(PlayerSection, {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(enabled)
        if enabled then
            InfJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end)
        else
            if InfJumpConnection then
                InfJumpConnection:Disconnect()
            end
        end
    end
})

-- Noclip Toggle
local NoclipToggle = Window:CreateToggle(PlayerSection, {
    Text = "Noclip",
    Default = false,
    Callback = function(enabled)
        -- Noclip implementation
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end
})

-- ========================================
-- COMBAT SECTION
-- ========================================

-- Aimbot Keybind
local AimbotKeybind = Window:CreateKeybind(CombatSection, {
    Text = "Aimbot",
    Default = Enum.KeyCode.E,
    Callback = function()
        Window:Notify({
            Title = "Aimbot",
            Text = "Aimbot activated!",
            Duration = 1
        })
    end
})

-- ESP Toggle
local ESPToggle = Window:CreateToggle(CombatSection, {
    Text = "Enable ESP",
    Default = false,
    Callback = function(enabled)
        -- ESP implementation would go here
        print("ESP:", enabled)
    end
})

-- FOV Circle Toggle
local FOVToggle = Window:CreateToggle(CombatSection, {
    Text = "Show FOV Circle",
    Default = false,
    Callback = function(enabled)
        -- FOV circle implementation
    end
})

-- FOV Size Slider
local FOVSlider = Window:CreateSlider(CombatSection, {
    Text = "FOV Size",
    Min = 10,
    Max = 500,
    Default = 90,
    Callback = function(value)
        -- Update FOV size
    end
})

Window:CreateSeparator(CombatSection)

-- Target Priority Dropdown
local TargetPriority = Window:CreateDropdown(CombatSection, {
    Text = "Target Priority",
    Options = {"Closest", "Lowest Health", "Highest Health", "Random"},
    Default = "Closest",
    Callback = function(selected)
        print("Target Priority:", selected)
    end
})

-- Hit Part Dropdown
local HitPart = Window:CreateDropdown(CombatSection, {
    Text = "Hit Part",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(selected)
        print("Hit Part:", selected)
    end
})

-- ========================================
-- VISUALS SECTION
-- ========================================

-- Environment Settings
local EnvironmentSettings = Window:CreateBigDropdown(VisualsSection, {
    Text = "Environment Settings",
    CreateElements = function(dropdown)
        dropdown.AddLabel({
            Text = "Lighting",
            Color = Color3.fromRGB(255, 255, 100)
        })
        
        dropdown.AddSlider({
            Text = "Time of Day",
            Min = 0,
            Max = 24,
            Default = 14,
            Callback = function(value)
                game.Lighting.ClockTime = value
            end
        })
        
        dropdown.AddSlider({
            Text = "Brightness",
            Min = 0,
            Max = 10,
            Default = 1,
            Callback = function(value)
                game.Lighting.Brightness = value
            end
        })
        
        dropdown.AddSeparator()
        
        dropdown.AddToggle({
            Text = "Always Day",
            Default = false,
            Callback = function(enabled)
                -- Always day implementation
            end
        })
        
        dropdown.AddToggle({
            Text = "No Fog",
            Default = false,
            Callback = function(enabled)
                if enabled then
                    game.Lighting.FogEnd = 100000
                else
                    game.Lighting.FogEnd = 1000
                end
            end
        })
    end
})

-- Crosshair Settings
Window:CreateToggle(VisualsSection, {
    Text = "Custom Crosshair",
    Default = false,
    Callback = function(enabled)
        -- Crosshair implementation
    end
})

Window:CreateDropdown(VisualsSection, {
    Text = "Crosshair Style",
    Options = {"Cross", "Circle", "Dot", "Square"},
    Default = "Cross",
    Callback = function(selected)
        -- Update crosshair style
    end
})

Window:CreateSlider(VisualsSection, {
    Text = "Crosshair Size",
    Min = 1,
    Max = 50,
    Default = 10,
    Callback = function(value)
        -- Update crosshair size
    end
})

-- ========================================
-- TELEPORT SECTION
-- ========================================

-- Player Search Box
local PlayerSearch = Window:CreateSearchBox(TeleportSection, {
    Placeholder = "Search players...",
    Items = {},
    OnSelected = function(playerName)
        local targetPlayer = Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = 
                targetPlayer.Character.HumanoidRootPart.CFrame
            
            Window:Notify({
                Title = "Teleport",
                Text = "Teleported to " .. playerName,
                Duration = 2
            })
        end
    end,
    OnSearch = function(searchText, items)
        local filtered = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(searchText:lower()) then
                table.insert(filtered, player.Name)
            end
        end
        return filtered
    end
})

-- Update player list
spawn(function()
    while wait(1) do
        local playerNames = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        PlayerSearch.UpdateItems(playerNames)
    end
end)

-- Location Teleports
Window:CreateLabel(TeleportSection, {
    Text = "Quick Teleports",
    Color = Color3.fromRGB(255, 200, 100)
})

Window:CreateButton(TeleportSection, {
    Text = "Teleport to Spawn",
    Callback = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
})

-- Custom Position Input
local CustomTPInput = Window:CreateInput(TeleportSection, {
    Text = "Custom Position",
    Placeholder = "X, Y, Z",
    Callback = function(text, enterPressed)
        if enterPressed then
            local coords = text:split(",")
            if #coords == 3 then
                local x = tonumber(coords[1])
                local y = tonumber(coords[2])
                local z = tonumber(coords[3])
                
                if x and y and z then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
                    Window:Notify({
                        Title = "Teleport",
                        Text = "Teleported to custom position",
                        Duration = 2
                    })
                end
            end
        end
    end
})

-- ========================================
-- MISC SECTION
-- ========================================

-- Anti-AFK Toggle
local AntiAFKToggle = Window:CreateToggle(MiscSection, {
    Text = "Anti-AFK",
    Default = true,
    Callback = function(enabled)
        -- Anti-AFK implementation
        local VirtualUser = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            if enabled then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
})

-- Auto Rejoin Toggle
local AutoRejoinToggle = Window:CreateToggle(MiscSection, {
    Text = "Auto Rejoin on Kick",
    Default = false,
    Callback = function(enabled)
        -- Auto rejoin implementation
    end
})

Window:CreateSeparator(MiscSection)

-- Server Actions
Window:CreateButton(MiscSection, {
    Text = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

Window:CreateButton(MiscSection, {
    Text = "Server Hop",
    Callback = function()
        -- Server hop implementation
        Window:Notify({
            Title = "Server Hop",
            Text = "Finding new server...",
            Duration = 2
        })
    end
})

-- Chat Spam
local ChatSpamInput = Window:CreateInput(MiscSection, {
    Text = "Chat Message",
    Placeholder = "Message to spam...",
    Callback = function(text, enterPressed)
        if enterPressed and text ~= "" then
            -- Chat spam implementation
            print("Chat spam:", text)
        end
    end
})

-- FPS Display Toggle
local FPSToggle = Window:CreateToggle(MiscSection, {
    Text = "Show FPS",
    Default = false,
    Callback = function(enabled)
        -- FPS counter implementation
    end
})

-- ========================================
-- CONFIG SECTION
-- ========================================

Window:CreateLabel(ConfigSection, {
    Text = "Configuration",
    Color = Color3.fromRGB(255, 200, 100)
})

-- Config Name Input
local ConfigNameInput = Window:CreateInput(ConfigSection, {
    Text = "Config Name",
    Placeholder = "Enter config name...",
    Default = "config1"
})

-- Save Config Button
Window:CreateButton(ConfigSection, {
    Text = "Save Config",
    Callback = function()
        Window:Notify({
            Title = "Config",
            Text = "Configuration saved!",
            Duration = 2
        })
    end
})

-- Load Config Button
Window:CreateButton(ConfigSection, {
    Text = "Load Config",
    Callback = function()
        Window:Notify({
            Title = "Config",
            Text = "Configuration loaded!",
            Duration = 2
        })
    end
})

Window:CreateSeparator(ConfigSection)

-- Export/Import
Window:CreateButton(ConfigSection, {
    Text = "Export to Clipboard",
    Callback = function()
        -- Export config to clipboard
        setclipboard("CONFIG_DATA_HERE")
        Window:Notify({
            Title = "Export",
            Text = "Config exported to clipboard!",
            Duration = 2
        })
    end
})

Window:CreateButton(ConfigSection, {
    Text = "Import from Clipboard",
    Callback = function()
        -- Import config from clipboard
        local clipboardData = getclipboard()
        Window:Notify({
            Title = "Import",
            Text = "Config imported from clipboard!",
            Duration = 2
        })
    end
})

-- ========================================
-- RUNTIME CUSTOMIZATION EXAMPLES
-- ========================================

-- Example: Change theme after 5 seconds
spawn(function()
    wait(5)
    Window:SetTheme("Purple")
    Window:Notify({
        Title = "Theme Changed",
        Text = "Theme changed to Purple!",
        Duration = 2
    })
end)

-- Example: Programmatic toggle control
spawn(function()
    wait(10)
    GodModeToggle.Set(true)
    Window:Notify({
        Title = "God Mode",
        Text = "God Mode enabled automatically!",
        Duration = 2
    })
end)

-- ========================================
-- FINAL SETUP
-- ========================================

-- Show welcome notification
Window:Notify({
    Title = "Eps1llon Hub",
    Text = "Successfully loaded! Press " .. Window.ToggleKey.Name .. " to toggle",
    Duration = 5
})

-- Print instructions
print("========================================")
print("Eps1llon Hub Premium UI Library v2.0")
print("Created by: JustClips")
print("Toggle Key:", Window.ToggleKey.Name)
print("========================================")
print("Features:")
print("- 4 Themes")
print("- 3 Backgrounds")
print("- Resizable Windows")
print("- Active Functions Display")
print("- Big Dropdowns")
print("- And much more!")
print("========================================")

-- Auto-save config on close (example)
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    -- Save configuration before teleporting
    print("Saving configuration...")
end)
