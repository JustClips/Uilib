-- Compact Uilib Demo - Loadstring Ready
-- Shows all components in a smaller, organized interface

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/main/Uilib.lua"))()
local GUI = Library:Create({Theme = "Dark"})

-- Compact size
GUI.MainFrame.Size = UDim2.new(0, 480, 0, 360)
GUI.MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
GUI.Title.Text = "Uilib Demo"

local function notify(msg) spawn(function() GUI:Notify({Title="Demo", Text=msg, Duration=2}) end) end

-- Section 1: Basic Controls
local basic = GUI:CreateSection("Basic")
GUI:CreateLabel(basic, {Text = "🎮 Controls", Color = Color3.fromRGB(100,200,255)})
GUI:CreateButton(basic, {Text = "Button", Callback = function() notify("Button pressed!") end})
GUI:CreateToggle(basic, {Text = "Toggle", Default = false, Callback = function(v) notify("Toggle: "..tostring(v)) end})
GUI:CreateSeparator(basic)

-- Section 2: Input
local input = GUI:CreateSection("Input")
GUI:CreateLabel(input, {Text = "📝 Inputs", Color = Color3.fromRGB(255,200,100)})
GUI:CreateSlider(input, {Text = "Speed", Min = 1, Max = 100, Default = 50, Callback = function(v) notify("Speed: "..v) end})
GUI:CreateInput(input, {Text = "Name", Placeholder = "Enter name...", Callback = function(t,e) if e then notify("Name: "..t) end end})

-- Section 3: Selection  
local select = GUI:CreateSection("Select")
GUI:CreateLabel(select, {Text = "📋 Selection", Color = Color3.fromRGB(200,100,255)})
GUI:CreateDropdown(select, {Text = "Mode", Options = {"Easy","Normal","Hard"}, Default = "Normal", Callback = function(v) notify("Mode: "..v) end})
GUI:CreateSearchBox(select, {Placeholder = "Search...", Items = {"Apple","Banana","Cherry","Date"}, Callback = function(v) notify("Found: "..v) end})

-- Section 4: Themes
local theme = GUI:CreateSection("Themes")
GUI:CreateLabel(theme, {Text = "🎨 Themes", Color = Color3.fromRGB(255,100,200)})
GUI:CreateDropdown(theme, {Text = "Theme", Options = {"Dark","Light","Purple","Ocean"}, Default = "Dark", Callback = function(t) GUI:SetTheme(t) notify("Theme: "..t) end})
GUI:CreateButton(theme, {Text = "Notify Test", Callback = function() notify("Test notification!") end})

spawn(function() wait(1) notify("Welcome! Try all components") end)
return GUI