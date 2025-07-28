-- Eps1llon Hub Example Script
local Library = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Source.lua'
    )
)()

-- Create main window with custom settings
local Window = Library:Create({
    Theme = 'Ocean',
    Background = 'Blurred Stars',
    ToggleKey = Enum.KeyCode.RightShift,
    ButtonDarkness = 0.5,
    StrokeThickness = 1,
    Font = 'Ubuntu',
    SectionHeaderEnabled = true,
    SectionHeaderConfig = {
        Size = 22,
        Font = Enum.Font.GothamBold,
        Position = 'Center',
        UnderlineEnabled = true,
        UnderlineSize = 0.7,
        UnderlineThickness = 2,
    },
})

-- Main Section
local MainSection = Window:CreateSection('Main Features')

-- Player Section
local PlayerSection = Window:CreateSection(
    'Player',
    Color3.fromRGB(255, 100, 100)
)

-- Visual Section
local VisualSection = Window:CreateSection(
    'Visuals',
    Color3.fromRGB(100, 255, 100)
)

-- Settings Section
local SettingsSection = Window:CreateSection('Settings')

-- Main Features
Window:CreateToggle(MainSection, {
    Text = 'Auto Farm',
    Default = false,
    Callback = function(value)
        _G.AutoFarm = value
        while _G.AutoFarm do
            -- Your auto farm code here
            wait(1)
        end
    end,
})

Window:CreateButton(MainSection, {
    Text = 'Collect All Items',
    Callback = function()
        Window:Notify({
            Title = 'Collection',
            Text = 'Collecting all items...',
            Duration = 2,
        })
        -- Your collection code here
    end,
})

local selectedTarget = nil
Window:CreateSearchBox(MainSection, {
    Placeholder = 'Search players...',
    Items = {}, -- Will be updated dynamically
    OnSelected = function(playerName)
        selectedTarget = playerName
        Window:Notify({
            Title = 'Target Selected',
            Text = 'Selected: ' .. playerName,
            Duration = 2,
        })
    end,
})

-- Update player list
spawn(function()
    while true do
        local players = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(players, player.Name)
        end
        -- Update search box items (assuming you stored the searchBox reference)
        wait(5)
    end
end)

-- Player Settings
Window:CreateSlider(PlayerSection, {
    Text = 'Walk Speed',
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})

Window:CreateSlider(PlayerSection, {
    Text = 'Jump Power',
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end,
})

Window:CreateToggle(PlayerSection, {
    Text = 'Infinite Jump',
    Default = false,
    Callback = function(value)
        _G.InfiniteJump = value
    end,
})

-- Visual Settings with Big Dropdown
Window:CreateBigDropdown(VisualSection, {
    Text = 'ESP Settings',
    CreateElements = function(dropdown)
        dropdown.AddToggle({
            Text = 'Enable ESP',
            Default = false,
            Callback = function(value)
                -- ESP code here
            end,
        })

        dropdown.AddDropdown({
            Text = 'ESP Type',
            Options = { 'Box', 'Name', 'Health', 'Distance', 'All' },
            Default = 'Box',
            Callback = function(selected)
                -- Update ESP type
            end,
        })

        dropdown.AddSlider({
            Text = 'ESP Distance',
            Min = 0,
            Max = 1000,
            Default = 500,
            Callback = function(value)
                -- Update ESP distance
            end,
        })

        dropdown.AddSeparator()

        dropdown.AddLabel({
            Text = 'ESP Colors',
            Color = Color3.fromRGB(255, 255, 0),
        })

        dropdown.AddButton({
            Text = 'Enemy Color',
            Callback = function()
                -- Open color picker
            end,
        })

        dropdown.AddButton({
            Text = 'Team Color',
            Callback = function()
                -- Open color picker
            end,
        })
    end,
})

Window:CreateToggle(VisualSection, {
    Text = 'Show FPS',
    Default = true,
    Callback = function(value)
        -- FPS display code
    end,
})

Window:CreateToggle(VisualSection, {
    Text = 'Show Ping',
    Default = true,
    Callback = function(value)
        -- Ping display code
    end,
})

-- Settings
Window:CreateLabel(SettingsSection, {
    Text = 'Configuration',
    Color = Window.Theme.Accent,
})

Window:CreateInput(SettingsSection, {
    Text = 'Webhook URL',
    Placeholder = 'https://discord.com/api/webhooks/...',
    Callback = function(text)
        _G.WebhookURL = text
    end,
})

Window:CreateKeybind(SettingsSection, {
    Text = 'Toggle UI',
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Window:ToggleUI()
    end,
})

Window:CreateSeparator(SettingsSection)

Window:CreateButton(SettingsSection, {
    Text = 'Save Settings',
    Callback = function()
        -- Save settings code
        Window:Notify({
            Title = 'Settings',
            Text = 'Settings saved successfully!',
            Duration = 3,
        })
    end,
})

Window:CreateButton(SettingsSection, {
    Text = 'Load Settings',
    Callback = function()
        -- Load settings code
        Window:Notify({
            Title = 'Settings',
            Text = 'Settings loaded successfully!',
            Duration = 3,
        })
    end,
})

Window:CreateSeparator(SettingsSection)

Window:CreateButton(SettingsSection, {
    Text = 'Destroy UI',
    Callback = function()
        Window:Destroy()
    end,
})

-- Infinite Jump Implementation
game:GetService('UserInputService').JumpRequest:Connect(function()
    if _G.InfiniteJump then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState('Jumping')
    end
end)

-- Welcome notification
Window:Notify({
    Title = 'Eps1llon Hub',
    Text = 'Successfully loaded! Press '
        .. Window.ToggleKey.Name
        .. ' to toggle.',
    Duration = 5,
})

print('Eps1llon Hub loaded successfully!')
