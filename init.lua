--[[
	Copyright (C) 2018 HarpyWar (harpywar@gmail.com)
	
	This file is a part of the plugin https://github.com/HarpyWar/ts3plugin_mybadges
]]--


--
-- Testmodule initialisation, this script is called via autoload mechanism when the
-- TeamSpeak 3 client starts.
--

local MODULE_NAME = "mybadges"

require("ts3init")            -- Required for ts3RegisterModule
require(MODULE_NAME .. "/helper") 
require(MODULE_NAME .. "/events")  -- Forwarded TeamSpeak 3 callbacks
require(MODULE_NAME .. "/badgelist") 
require(MODULE_NAME .. "/command")    -- Some functions callable from TS3 client chat input


-- Initialize menus. Optional function, if not using menus do not implement this.
-- This function is called automatically by the TeamSpeak client.
--
local function createMenus(moduleMenuItemID)
	-- Store value added to menuIDs to be able to calculate menuIDs for this module again for setPluginMenuEnabled (see demo.lua)
	mybadges_events.moduleMenuItemID = moduleMenuItemID

	local menus ={}
    for i = 1, #badgelist do
		print(badgelist[i][1])
		
		-- numbers in menu for badges (0. Overwolf, 1. ..)
		local idx = i-mybadges_offset
		if idx < 0 then 
			idx = ""
		else
			idx = idx .. ". "
		end
        table.insert(menus, {ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL, i,  idx .. badgelist[i][2], MODULE_NAME .. "/icons/" .. badgelist[i][3]} )
    end
	return menus
end

-- Define which callbacks you want to receive in your module. Callbacks not mentioned
-- here will not be called. To avoid function name collisions, your callbacks should
-- be put into an own package.
local registeredEvents = {
	createMenus = createMenus,
	onConnectStatusChangeEvent = mybadges_events.onConnectStatusChangeEvent,
	onMenuItemEvent = mybadges_events.onMenuItemEvent
}

-- Register your callback functions with a unique module name.
ts3RegisterModule(MODULE_NAME, registeredEvents)
