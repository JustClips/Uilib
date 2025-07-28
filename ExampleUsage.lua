-- Example usage script for Eps1llon Hub UI Library
-- Assume the library code is loaded from the provided URL or pasted.

local Library = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/Source.lua'
    )
)()

-- Create the UI with custom configuration
local UI = Library:Create({
    Theme = 'Ocean', -- Choose from Dark, Light, Purple, Ocean
    ToggleKey = Enum.KeyCode.RightShift,
    Background = 'Blue Sky', -- Choose from available backgrounds
    Font = 'Gotham', -- Choose from available fonts
    ButtonDarkness = 0.3, -- 0 to 1
    StrokeThickness = 1,
    SectionHeaderEnabled = true,
    SectionHeaderWhite = false,
    HideUISettings = false, -- Set to true to hide UI settings button
    ElementSizes = {
        Button = 40,
        Toggle = 40,
        Slider = 60,
        Input = 40,
        Dropdown = 40,
        Label = 30,
        BigDropdown = 45,
        Spacing = 10,
    },
    SectionHeaderConfig = {
        Size = 24,
        Font = Enum.Font.GothamBold,
        Position = 'Center', -- Center, Left, Right
        UnderlineEnabled = true,
        UnderlineSize = 0.6, -- 0 to 1
        UnderlineThickness = 3,
    },
})

-- Create a section
local MainSection = UI:CreateSection('Main Section')

-- Add a button
UI:CreateButton(MainSection, {
    Text = 'Click Me',
    Callback = function()
        print('Button clicked!')
        UI:Notify({
            Title = 'Success',
            Text = 'Button was clicked successfully!',
            Duration = 3,
        })
    end,
})

-- Add a toggle
local toggle = UI:CreateToggle(MainSection, {
    Text = 'Enable Feature',
    Default = false,
    Callback = function(value)
        print('Toggle state:', value)
    end,
})

-- Add a slider
UI:CreateSlider(MainSection, {
    Text = 'Speed',
    Min = 1,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print('Slider value:', value)
    end,
})

-- Add an input
UI:CreateInput(MainSection, {
    Text = 'Enter Name',
    Placeholder = 'Your name...',
    Default = '',
    Callback = function(text, enterPressed)
        print('Input:', text, 'Enter pressed:', enterPressed)
    end,
})

-- Add a dropdown
UI:CreateDropdown(MainSection, {
    Text = 'Choose Option',
    Options = { 'Option 1', 'Option 2', 'Option 3' },
    Default = 'Option 1',
    Callback = function(selected)
        print('Selected:', selected)
    end,
})

-- Add a label
UI:CreateLabel(MainSection, {
    Text = 'This is a label',
    Color = Color3.fromRGB(255, 100, 100),
})

-- Add a separator
UI:CreateSeparator(MainSection)

-- Add a keybind
UI:CreateKeybind(MainSection, {
    Text = 'Quick Action',
    Default = Enum.KeyCode.Q,
    Callback = function()
        print('Keybind pressed!')
    end,
})

-- Add a search box
UI:CreateSearchBox(MainSection, {
    Placeholder = 'Search items...',
    Items = { 'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry' },
    OnSearch = function(searchText, items) -- Custom search function (optional)
        local filtered = {}
        for _, item in pairs(items) do
            if item:lower():find(searchText) then
                table.insert(filtered, item)
            end
        end
        return filtered
    end,
    OnSelected = function(selected)
        print('Selected item:', selected)
    end,
})

-- Create another section with custom color
local AdvancedSection = UI:CreateSection('Advanced', Color3.fromRGB(255, 0, 0))

-- Add a BigDropdown (Rayfield-style)
local bigDropdown = UI:CreateBigDropdown(AdvancedSection, {
    Text = 'Advanced Options',
    CreateElements = function(dropdown)
        -- Add elements inside the BigDropdown
        dropdown.AddToggle({
            Text = 'Sub Toggle',
            Default = true,
            Callback = function(value)
                print('Sub Toggle:', value)
            end,
        })

        dropdown.AddSlider({
            Text = 'Sub Slider',
            Min = 0,
            Max = 10,
            Default = 5,
            Callback = function(value)
                print('Sub Slider:', value)
            end,
        })

        dropdown.AddButton({
            Text = 'Sub Button',
            Callback = function()
                print('Sub Button clicked!')
            end,
        })

        dropdown.AddInput({
            Text = 'Sub Input',
            Placeholder = 'Enter...',
            Callback = function(text)
                print('Sub Input:', text)
            end,
        })

        dropdown.AddDropdown({
            Text = 'Sub Dropdown',
            Options = { 'A', 'B', 'C' },
            Default = 'A',
            Callback = function(selected)
                print('Sub Selected:', selected)
            end,
        })

        dropdown.AddLabel({
            Text = 'Sub Label',
            Color = Color3.fromRGB(0, 255, 0),
        })
    end,
})

-- Example of updating theme dynamically
wait(5)
UI:SetTheme('Dark')

-- Example of setting font
UI:SetFont('ArialBold')

-- Example of notifying
UI:Notify({
    Title = 'Welcome',
    Text = 'UI Loaded Successfully!',
    Duration = 5,
})

-- To destroy the UI
-- UI:Destroy()
