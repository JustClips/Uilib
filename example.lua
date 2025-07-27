--[[
    Eps1llon Hub - Simple Usage Example
    
    This example shows how to load and use the Eps1llon Hub with minimal setup.
    Simply execute this script in your preferred Lua executor.
]]

-- Method 1: Direct load from GitHub (Recommended)
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/EpsillonHub.lua"))()

-- Alternative Method 2: Load with error handling
--[[
local success, hub = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Uilib/refs/heads/main/EpsillonHub.lua"))()
end)

if success then
    print("Eps1llon Hub loaded successfully!")
    -- You can access hub.Window, hub.Config, etc.
else
    warn("Failed to load Eps1llon Hub: " .. tostring(hub))
end
]]

-- Alternative Method 3: Manual installation (if you downloaded the files locally)
--[[
-- Place both Uilib.lua and EpsillonHub.lua in your workspace
-- Then load them:

local Library = loadstring(readfile("Uilib.lua"))()
local Hub = loadstring(readfile("EpsillonHub.lua"))()
]]