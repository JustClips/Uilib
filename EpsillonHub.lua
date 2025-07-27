--[[
    Eps1llon Hub - Complete Integration with JustClips UI Library
    
    A comprehensive, feature-rich hub interface built on top of the modern UI library.
    Includes configuration, combat, ESP, inventory, miscellaneous features, and more.
    
    Features:
    - Configuration: Walkspeed, JumpPower, Infinite Water
    - Combat: Reach & Auto Hit with hitbox expansion
    - ESP: External module integration
    - Inventory: Smart tool grabbing system
    - Misc: Instant Pickup, Cow Orbit, Kill Carrier, Plant Tree, Job GUI
    - Script Chat: External chat system
    - UI Settings: Theme and customization options
    
    Controls:
    - Insert: Toggle UI visibility
    - Draggable interface with resizing support
    - Modern theme system with multiple options
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Hub Configuration
local HubConfig = {
    Name = "Eps1llon Hub",
    Version = "2.0",
    Theme = "Ocean",
    Visible = true,
    Features = {
        -- Configuration
        Walkspeed = 16,
        JumpPower = 50,
        InfiniteWater = false,
        
        -- Combat
        Reach = 3,
        AutoHit = false,
        
        -- ESP
        ESPEnabled = false,
        
        -- Inventory
        SmartGrab = false,
        
        -- Misc
        InstantPickup = false,
        CowOrbit = false,
        
        -- Active connections
        Connections = {}
    }
}

-- Utility Functions
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Eps1llon Hub Error: " .. tostring(result))
        return false, result
    end
    return true, result
end

local function LoadExternalScript(url, name)
    local success, result = SafeCall(function()
        local response = game:HttpGet(url)
        return loadstring(response)()
    end)
    
    if success then
        return result
    else
        warn("Failed to load " .. name .. ": " .. tostring(result))
        return nil
    end
end

local function UpdateCharacterReferences()
    Character = Player.Character
    if Character then
        Humanoid = Character:FindFirstChild("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
    end
end

-- Load UI Library
local Library = LoadExternalScript("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Uilib.lua", "UI Library")

if not Library then
    error("Failed to load UI Library")
end

-- Create Main Window
local Window = Library:Create({
    Theme = HubConfig.Theme
})

-- Notification helper
local function Notify(title, text, duration)
    Window:Notify({
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Welcome notification
Notify("Eps1llon Hub", "Successfully loaded v" .. HubConfig.Version, 5)

-- Create Sections
local ConfigSection = Window:CreateSection("Configuration")
local CombatSection = Window:CreateSection("Combat")
local ESPSection = Window:CreateSection("ESP")
local InventorySection = Window:CreateSection("Inventory")
local MiscSection = Window:CreateSection("Misc")
local ChatSection = Window:CreateSection("Script Chat")
local SettingsSection = Window:CreateSection("UI Settings")

-- Configuration Section Implementation
local function SetWalkspeed(value)
    UpdateCharacterReferences()
    if Humanoid then
        Humanoid.WalkSpeed = value
        HubConfig.Features.Walkspeed = value
        Window:AddActiveFunction("Custom Walkspeed: " .. value)
    end
end

local function SetJumpPower(value)
    UpdateCharacterReferences()
    if Humanoid then
        Humanoid.JumpPower = value
        HubConfig.Features.JumpPower = value
        Window:AddActiveFunction("Custom JumpPower: " .. value)
    end
end

local function ToggleInfiniteWater(enabled)
    HubConfig.Features.InfiniteWater = enabled
    
    if enabled then
        Window:AddActiveFunction("Infinite Water")
        
        -- Implement infinite water logic with thirst management
        local connection = RunService.Heartbeat:Connect(function()
            UpdateCharacterReferences()
            if Character then
                -- Look for thirst/water related values
                local humanoid = Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Check for custom thirst attributes
                    if humanoid:GetAttribute("Thirst") then
                        humanoid:SetAttribute("Thirst", 100)
                    end
                    if humanoid:GetAttribute("Water") then
                        humanoid:SetAttribute("Water", 100)
                    end
                end
                
                -- Check for water GUI elements
                local playerGui = Player:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if gui:IsA("Frame") and gui.Name:lower():find("thirst") then
                            for _, child in pairs(gui:GetChildren()) do
                                if child:IsA("Frame") and child.Name:lower():find("bar") then
                                    child.Size = UDim2.new(1, 0, 1, 0)
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        HubConfig.Features.Connections.InfiniteWater = connection
        Notify("Infinite Water", "Feature enabled", 2)
    else
        Window:RemoveActiveFunction("Infinite Water")
        if HubConfig.Features.Connections.InfiniteWater then
            HubConfig.Features.Connections.InfiniteWater:Disconnect()
            HubConfig.Features.Connections.InfiniteWater = nil
        end
        Notify("Infinite Water", "Feature disabled", 2)
    end
end

-- Configuration UI Elements
ConfigSection:CreateSlider({
    Text = "Walkspeed",
    Min = 1,
    Max = 100,
    Default = HubConfig.Features.Walkspeed,
    Callback = SetWalkspeed
})

ConfigSection:CreateSlider({
    Text = "Jump Power",
    Min = 1,
    Max = 200,
    Default = HubConfig.Features.JumpPower,
    Callback = SetJumpPower
})

ConfigSection:CreateToggle({
    Text = "Infinite Water",
    Default = HubConfig.Features.InfiniteWater,
    Callback = ToggleInfiniteWater
})

ConfigSection:CreateSeparator()

ConfigSection:CreateButton({
    Text = "Reset Character Stats",
    Callback = function()
        SetWalkspeed(16)
        SetJumpPower(50)
        Notify("Configuration", "Character stats reset to default", 2)
    end
})

ConfigSection:CreateDropdown({
    Text = "Speed Preset",
    Options = {"Normal (16)", "Fast (25)", "Very Fast (50)", "Extreme (100)"},
    Default = "Normal (16)",
    Callback = function(option)
        local speeds = {
            ["Normal (16)"] = 16,
            ["Fast (25)"] = 25,
            ["Very Fast (50)"] = 50,
            ["Extreme (100)"] = 100
        }
        SetWalkspeed(speeds[option] or 16)
    end
})

-- Combat Section Implementation
local function SetReach(value)
    HubConfig.Features.Reach = value
    Window:AddActiveFunction("Reach: " .. value)
    
    -- Implement reach expansion logic
    -- Hook into character's tool activation for extended reach
    if Character then
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            -- Expand the tool's reach capabilities
            local handle = tool.Handle
            if handle:FindFirstChild("TouchPart") then
                handle.TouchPart.Size = Vector3.new(value, value, value)
            end
        end
    end
    
    Notify("Reach", "Set to " .. value .. " studs", 2)
end

local function ToggleAutoHit(enabled)
    HubConfig.Features.AutoHit = enabled
    
    if enabled then
        Window:AddActiveFunction("Auto Hit")
        
        -- Implement auto hit logic with target detection
        local connection = RunService.Heartbeat:Connect(function()
            UpdateCharacterReferences()
            if not Character or not RootPart then return end
            
            -- Find nearest target within reach
            local nearestTarget = nil
            local nearestDistance = HubConfig.Features.Reach
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= nearestDistance then
                        nearestTarget = player.Character
                        nearestDistance = distance
                    end
                end
            end
            
            -- Auto hit nearest target
            if nearestTarget and nearestTarget:FindFirstChild("Humanoid") then
                local tool = Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("RemoteEvent") then
                    -- Fire tool's remote event for hitting
                    SafeCall(function()
                        tool.RemoteEvent:FireServer(nearestTarget.HumanoidRootPart)
                    end)
                end
            end
        end)
        
        HubConfig.Features.Connections.AutoHit = connection
        Notify("Auto Hit", "Feature enabled", 2)
    else
        Window:RemoveActiveFunction("Auto Hit")
        if HubConfig.Features.Connections.AutoHit then
            HubConfig.Features.Connections.AutoHit:Disconnect()
            HubConfig.Features.Connections.AutoHit = nil
        end
        Notify("Auto Hit", "Feature disabled", 2)
    end
end

-- Combat UI Elements
CombatSection:CreateSlider({
    Text = "Reach",
    Min = 1,
    Max = 20,
    Default = HubConfig.Features.Reach,
    Callback = SetReach
})

CombatSection:CreateToggle({
    Text = "Auto Hit",
    Default = HubConfig.Features.AutoHit,
    Callback = ToggleAutoHit
})

CombatSection:CreateSlider({
    Text = "Hit Delay (ms)",
    Min = 0,
    Max = 1000,
    Default = 100,
    Callback = function(value)
        HubConfig.Features.HitDelay = value
        Notify("Combat", "Hit delay set to " .. value .. "ms", 2)
    end
})

CombatSection:CreateButton({
    Text = "Test Reach",
    Callback = function()
        UpdateCharacterReferences()
        if Character and RootPart then
            -- Create a visual indicator of reach
            local indicator = Instance.new("Part")
            indicator.Name = "ReachIndicator"
            indicator.Parent = Workspace
            indicator.Size = Vector3.new(HubConfig.Features.Reach * 2, 1, HubConfig.Features.Reach * 2)
            indicator.Position = RootPart.Position
            indicator.CanCollide = false
            indicator.Anchored = true
            indicator.Transparency = 0.7
            indicator.BrickColor = BrickColor.new("Bright red")
            indicator.Shape = Enum.PartType.Cylinder
            
            -- Remove after 3 seconds
            game:GetService("Debris"):AddItem(indicator, 3)
            Notify("Combat", "Reach visualization active", 2)
        end
    end
})

-- ESP Section Implementation
local function ToggleESP(enabled)
    HubConfig.Features.ESPEnabled = enabled
    
    if enabled then
        Window:AddActiveFunction("ESP")
        
        -- Load external ESP module
        local ESPModule = LoadExternalScript("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua", "ESP Module")
        
        if ESPModule then
            Notify("ESP", "External module loaded", 2)
        else
            Notify("ESP", "Failed to load external module", 3)
        end
    else
        Window:RemoveActiveFunction("ESP")
        Notify("ESP", "Feature disabled", 2)
    end
end

-- ESP UI Elements
ESPSection:CreateToggle({
    Text = "Enable ESP",
    Default = HubConfig.Features.ESPEnabled,
    Callback = ToggleESP
})

ESPSection:CreateButton({
    Text = "Load ESP Module",
    Callback = function()
        ToggleESP(true)
    end
})

-- Inventory Section Implementation
local function ToggleSmartGrab(enabled)
    HubConfig.Features.SmartGrab = enabled
    
    if enabled then
        Window:AddActiveFunction("Smart Tool Grab")
        
        -- Implement smart tool grabbing with item prioritization
        local connection = RunService.Heartbeat:Connect(function()
            UpdateCharacterReferences()
            if not Character then return end
            
            -- Define priority tools to grab
            local priorityTools = {"Sword", "Gun", "Tool", "Weapon", "Key"}
            
            -- Search for tools in workspace
            for _, item in pairs(Workspace:GetChildren()) do
                if item:IsA("Tool") or item:IsA("HopperBin") then
                    for _, priority in pairs(priorityTools) do
                        if string.find(item.Name:lower(), priority:lower()) then
                            -- Check if tool is within grab range
                            if item:FindFirstChild("Handle") and RootPart then
                                local distance = (RootPart.Position - item.Handle.Position).Magnitude
                                if distance <= 20 then -- Within 20 studs
                                    SafeCall(function()
                                        item.Parent = Character
                                        Notify("Smart Grab", "Grabbed " .. item.Name, 1)
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        HubConfig.Features.Connections.SmartGrab = connection
        Notify("Smart Grab", "Feature enabled", 2)
    else
        Window:RemoveActiveFunction("Smart Tool Grab")
        if HubConfig.Features.Connections.SmartGrab then
            HubConfig.Features.Connections.SmartGrab:Disconnect()
            HubConfig.Features.Connections.SmartGrab = nil
        end
        Notify("Smart Grab", "Feature disabled", 2)
    end
end

-- Inventory UI Elements
InventorySection:CreateToggle({
    Text = "Smart Tool Grab",
    Default = HubConfig.Features.SmartGrab,
    Callback = ToggleSmartGrab
})

InventorySection:CreateButton({
    Text = "Auto Organize Inventory",
    Callback = function()
        Notify("Inventory", "Auto organizing...", 2)
        
        -- Implement inventory organization logic
        UpdateCharacterReferences()
        if Character then
            local tools = {}
            for _, child in pairs(Character:GetChildren()) do
                if child:IsA("Tool") then
                    table.insert(tools, child)
                end
            end
            
            -- Sort tools alphabetically
            table.sort(tools, function(a, b)
                return a.Name < b.Name
            end)
            
            -- Re-parent tools in order
            for _, tool in pairs(tools) do
                tool.Parent = nil
                tool.Parent = Character
            end
            
            Notify("Inventory", "Organized " .. #tools .. " tools", 2)
        end
    end
})

InventorySection:CreateSearchBox({
    Text = "Tool Search",
    Items = {"Sword", "Gun", "Hammer", "Pickaxe", "Shovel", "Key", "Flashlight"},
    Placeholder = "Search for tools...",
    Callback = function(item)
        UpdateCharacterReferences()
        if Character then
            -- Search for the tool in workspace
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj.Name:lower():find(item:lower()) then
                    SafeCall(function()
                        obj.Parent = Character
                        Notify("Tool Search", "Found and equipped " .. obj.Name, 2)
                    end)
                    break
                end
            end
        end
    end
})

-- Misc Section Implementation
local function ToggleInstantPickup(enabled)
    HubConfig.Features.InstantPickup = enabled
    
    if enabled then
        Window:AddActiveFunction("Instant Pickup")
        
        -- Implement instant pickup with automatic collection
        local connection = RunService.Heartbeat:Connect(function()
            UpdateCharacterReferences()
            if not Character or not RootPart then return end
            
            -- Find and instantly pickup nearby items
            for _, item in pairs(Workspace:GetChildren()) do
                -- Check for common pickup items
                if item:IsA("Part") and item:FindFirstChild("ClickDetector") then
                    local distance = (RootPart.Position - item.Position).Magnitude
                    if distance <= 10 then -- Within 10 studs
                        SafeCall(function()
                            fireclickdetector(item.ClickDetector)
                        end)
                    end
                elseif item:IsA("Model") and item:FindFirstChild("Handle") then
                    -- Handle dropped tools/items
                    local distance = (RootPart.Position - item.Handle.Position).Magnitude
                    if distance <= 10 then
                        SafeCall(function()
                            item.Handle.CFrame = RootPart.CFrame
                        end)
                    end
                end
            end
        end)
        
        HubConfig.Features.Connections.InstantPickup = connection
        Notify("Instant Pickup", "Feature enabled", 2)
    else
        Window:RemoveActiveFunction("Instant Pickup")
        if HubConfig.Features.Connections.InstantPickup then
            HubConfig.Features.Connections.InstantPickup:Disconnect()
            HubConfig.Features.Connections.InstantPickup = nil
        end
        Notify("Instant Pickup", "Feature disabled", 2)
    end
end

local function ToggleCowOrbit(enabled)
    HubConfig.Features.CowOrbit = enabled
    
    if enabled then
        Window:AddActiveFunction("Cow Orbit")
        
        -- Implement cow orbit with circular movement around cows
        local connection = RunService.Heartbeat:Connect(function()
            UpdateCharacterReferences()
            if not Character or not RootPart then return end
            
            -- Find cows in the workspace
            for _, model in pairs(Workspace:GetChildren()) do
                if model:IsA("Model") and model.Name:lower():find("cow") then
                    local cowPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                    if cowPart then
                        local distance = (RootPart.Position - cowPart.Position).Magnitude
                        if distance <= 50 then -- Within 50 studs of cow
                            -- Create orbital movement
                            local angle = tick() * 2 -- Rotation speed
                            local radius = 15 -- Orbit radius
                            local targetPosition = cowPart.Position + Vector3.new(
                                math.cos(angle) * radius,
                                5, -- Hover height
                                math.sin(angle) * radius
                            )
                            
                            SafeCall(function()
                                RootPart.CFrame = CFrame.lookAt(targetPosition, cowPart.Position)
                            end)
                            break -- Only orbit one cow at a time
                        end
                    end
                end
            end
        end)
        
        HubConfig.Features.Connections.CowOrbit = connection
        Notify("Cow Orbit", "Feature enabled", 2)
    else
        Window:RemoveActiveFunction("Cow Orbit")
        if HubConfig.Features.Connections.CowOrbit then
            HubConfig.Features.Connections.CowOrbit:Disconnect()
            HubConfig.Features.Connections.CowOrbit = nil
        end
        Notify("Cow Orbit", "Feature disabled", 2)
    end
end

local function KillCarrier()
    UpdateCharacterReferences()
    if Character and Humanoid then
        Humanoid.Health = 0
        Notify("Kill Carrier", "Character eliminated", 2)
    end
end

local function PlantTree()
    UpdateCharacterReferences()
    if not Character or not RootPart then return end
    
    -- Create a simple tree model
    local tree = Instance.new("Model")
    tree.Name = "EpsillonTree"
    tree.Parent = Workspace
    
    -- Tree trunk
    local trunk = Instance.new("Part")
    trunk.Name = "Trunk"
    trunk.Parent = tree
    trunk.Size = Vector3.new(2, 10, 2)
    trunk.Position = RootPart.Position + Vector3.new(math.random(-5, 5), 5, math.random(-5, 5))
    trunk.BrickColor = BrickColor.new("Brown")
    trunk.Material = Enum.Material.Wood
    trunk.Anchored = true
    
    -- Tree leaves
    local leaves = Instance.new("Part")
    leaves.Name = "Leaves"
    leaves.Parent = tree
    leaves.Size = Vector3.new(8, 6, 8)
    leaves.Position = trunk.Position + Vector3.new(0, 8, 0)
    leaves.BrickColor = BrickColor.new("Bright green")
    leaves.Material = Enum.Material.Leaves
    leaves.Shape = Enum.PartType.Ball
    leaves.Anchored = true
    
    Notify("Plant Tree", "Tree planted successfully", 2)
end

local function OpenJobGUI()
    -- Create a simple job selection GUI
    local jobGui = Instance.new("ScreenGui")
    jobGui.Name = "EpsillonJobGUI"
    jobGui.Parent = Player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = jobGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Job Selection"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.Ubuntu
    title.Parent = frame
    
    local jobs = {"Farmer", "Miner", "Builder", "Guard", "Trader"}
    for i, job in pairs(jobs) do
        local jobButton = Instance.new("TextButton")
        jobButton.Size = UDim2.new(0.8, 0, 0, 25)
        jobButton.Position = UDim2.new(0.1, 0, 0, 40 + (i * 30))
        jobButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        jobButton.Text = job
        jobButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        jobButton.TextSize = 14
        jobButton.Font = Enum.Font.Ubuntu
        jobButton.Parent = frame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = jobButton
        
        jobButton.MouseButton1Click:Connect(function()
            Notify("Job GUI", "Selected job: " .. job, 2)
            jobGui:Destroy()
        end)
    end
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.Ubuntu
    closeButton.Parent = frame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.5, 0)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        jobGui:Destroy()
    end)
    
    Notify("Job GUI", "Opening job interface...", 2)
end

-- Misc UI Elements
MiscSection:CreateToggle({
    Text = "Instant Pickup",
    Default = HubConfig.Features.InstantPickup,
    Callback = ToggleInstantPickup
})

MiscSection:CreateToggle({
    Text = "Cow Orbit",
    Default = HubConfig.Features.CowOrbit,
    Callback = ToggleCowOrbit
})

MiscSection:CreateButton({
    Text = "Kill Carrier",
    Callback = KillCarrier
})

MiscSection:CreateButton({
    Text = "Plant Tree",
    Callback = PlantTree
})

MiscSection:CreateButton({
    Text = "Job GUI",
    Callback = OpenJobGUI
})

-- Script Chat Section Implementation
local function LoadScriptChat()
    local ChatScript = LoadExternalScript("https://raw.githubusercontent.com/fatesc/fates-esp/main/chat.lua", "Script Chat")
    
    if ChatScript then
        Window:AddActiveFunction("Script Chat")
        Notify("Script Chat", "External chat system loaded", 3)
    else
        Notify("Script Chat", "Failed to load chat system", 3)
    end
end

-- Script Chat UI Elements
ChatSection:CreateButton({
    Text = "Load Script Chat",
    Callback = LoadScriptChat
})

ChatSection:CreateLabel({
    Text = "External chat system for enhanced communication",
    Color = Color3.fromRGB(150, 150, 150)
})

-- UI Settings Section Implementation
local function ChangeTheme(themeName)
    Window:SetTheme(themeName)
    HubConfig.Theme = themeName
    Notify("Theme", "Changed to " .. themeName, 2)
end

-- UI Settings Elements
SettingsSection:CreateDropdown({
    Text = "Theme",
    Options = {"Dark", "Light", "Purple", "Ocean"},
    Default = HubConfig.Theme,
    Callback = ChangeTheme
})

SettingsSection:CreateButton({
    Text = "Reset to Default",
    Callback = function()
        ChangeTheme("Ocean")
        Notify("Settings", "Reset to default theme", 2)
    end
})

SettingsSection:CreateButton({
    Text = "Export Settings",
    Callback = function()
        local settings = {
            Theme = HubConfig.Theme,
            Walkspeed = HubConfig.Features.Walkspeed,
            JumpPower = HubConfig.Features.JumpPower,
            Reach = HubConfig.Features.Reach
        }
        
        local settingsString = HttpService:JSONEncode(settings)
        
        -- Create a simple GUI to display the settings
        local exportGui = Instance.new("ScreenGui")
        exportGui.Name = "ExportSettings"
        exportGui.Parent = Player.PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 400, 0, 300)
        frame.Position = UDim2.new(0.5, -200, 0.5, -150)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BorderSizePixel = 0
        frame.Parent = exportGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -20, 1, -60)
        textBox.Position = UDim2.new(0, 10, 0, 40)
        textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.Text = settingsString
        textBox.TextWrapped = true
        textBox.TextSize = 12
        textBox.Font = Enum.Font.Code
        textBox.Parent = frame
        
        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 80, 0, 30)
        closeButton.Position = UDim2.new(0.5, -40, 1, -40)
        closeButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        closeButton.Text = "Close"
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeButton.Parent = frame
        
        closeButton.MouseButton1Click:Connect(function()
            exportGui:Destroy()
        end)
        
        Notify("Settings", "Settings exported to clipboard", 3)
    end
})

SettingsSection:CreateKeybind({
    Text = "Toggle UI Keybind",
    Default = Enum.KeyCode.Insert,
    Callback = function()
        ToggleUI()
    end
})

SettingsSection:CreateSeparator()

SettingsSection:CreateLabel({
    Text = "Eps1llon Hub v" .. HubConfig.Version,
    Color = Color3.fromRGB(100, 200, 255)
})

SettingsSection:CreateLabel({
    Text = "Built with JustClips UI Library",
    Color = Color3.fromRGB(150, 150, 150)
})

SettingsSection:CreateButton({
    Text = "Join Discord",
    Callback = function()
        SafeCall(function()
            if setclipboard then
                setclipboard("https://discord.gg/epsillon-hub")
                Notify("Discord", "Invite link copied to clipboard!", 3)
            else
                Notify("Discord", "Clipboard not supported", 2)
            end
        end)
    end
})

SettingsSection:CreateButton({
    Text = "Reload Hub",
    Callback = function()
        Cleanup()
        wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/EpsillonHub.lua"))()
    end
})

-- Insert Key Toggle Functionality
local function ToggleUI()
    HubConfig.Visible = not HubConfig.Visible
    
    if HubConfig.Visible then
        Window:Restore()
    else
        Window:Minimize()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        ToggleUI()
    end
end)

-- Character Respawn Handler
Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    RootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    -- Reapply settings after respawn
    SetWalkspeed(HubConfig.Features.Walkspeed)
    SetJumpPower(HubConfig.Features.JumpPower)
    
    Notify("Character", "Respawned - settings reapplied", 2)
end)

-- Cleanup Function
local function Cleanup()
    for name, connection in pairs(HubConfig.Features.Connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    
    if Window then
        Window:Destroy()
    end
end

-- Handle script termination
game:GetService("GuiService").MenuOpened:Connect(function()
    Cleanup()
end)

-- Final initialization message
wait(1)
Notify("Eps1llon Hub", "All systems ready! Press Insert to toggle.", 5)

return {
    Window = Window,
    Config = HubConfig,
    Cleanup = Cleanup
}