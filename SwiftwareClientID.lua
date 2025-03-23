
local repo = 'https://raw.githubusercontent.com/rayparams/Library/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = false 
Library.NotifySide = "Left" 

local Window = Library:CreateWindow({
	-- Set Center to true if you want the menu to appear in the center
	-- Set AutoShow to true if you want the menu to appear when it is created
	-- Set Resizable to true if you want to have in-game resizable Window
	-- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
	-- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
	-- Position and Size are also valid options here
	-- but you do not need to define them unless you are changing them :)

	
    Title = 'Client ID | v.1.0.2 | Payment',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = false,
	NotifySide = "Right",
	TabPadding = 8,
	MenuFadeTime = 0.2
})


local Tabs = {
	-- Creates a new tab titled Main
	Main = Window:AddTab('Main'),
   -- Ragebot = Window:AddTab('Ragebot'),
    --Farming = Window:AddTab('Farming'),
    --Visuals = Window:AddTab('Visuals'),
    --Teleports = Window:AddTab('Teleports'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local ClientIDGB = Tabs.Main:AddLeftGroupbox('Swiftware')


local GetClientID = ClientIDGB:AddButton({
	Text = 'Copy Client ID To Clipboard',
	Func = function()
		Library:Notify("Copying Client ID, please wait...")
           
local HWID = game:GetService("RbxAnalyticsService"):GetClientId() 

Library:Notify("Copying your Client ID:", HWID) 

setclipboard(HWID) 

Library:Notify("Copied your Client ID to your clipboard. Please send it in the purchase ticket, and save it somewhere, you'll need it to renew your key, or you won't be able to.")

	end,
	DoubleClick = false,

	Tooltip = 'Respawns the character automatically',
	DisabledTooltip = 'Client ID system is down, or has been disabled.', -- Information shown when you hover over the button while it's disabled

	Disabled = false, -- Will disable the button (true / false)
	Visible = true -- Will make the button invisible (true / false)
})












Library:SetWatermarkVisibility(false)

-- Example of dynamically-updating watermark with common traits (fps and ping)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	Library:SetWatermark(('CID Info | %s FPS | %s MS'):format(
		math.floor(FPS),
		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
	));
end);

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Client ID System closed.')
	Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('SWCID')
SaveManager:SetFolder('SWCID/Criminality')
SaveManager:SetSubFolder('Shtuffs') -- if the game has multiple places inside of it (for example: DOORS) 
					   -- you can use this to save configs for those places separately
					   -- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
					   -- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()