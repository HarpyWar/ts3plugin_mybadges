--[[
	Copyright (C) 2018 HarpyWar (harpywar@gmail.com)
	
	This file is a part of the plugin https://github.com/HarpyWar/ts3plugin_mybadges
]]--

--
-- Callback functions
--

-- Will store factor to add to menuID to calculate the real menuID used in the TeamSpeak client (to support menus from multiple Lua modules)
-- Add this value to above menuID when passing the ID to setPluginMenuEnabled. See demo.lua for an example.
local moduleMenuItemID = 0




local function onConnectStatusChangeEvent(sid, status, errorNumber)

	print("TestModule: onConnectStatusChangeEvent: " .. sid .. " " .. status .. " " .. errorNumber)

	if (status == 4) then
		-- set badges on connect from the file and print
		mybadges_helper.loadBadges()
		mybadges_helper.broadcastBadges(sid)
		-- print to user
		mybadges_helper.printBadgeList(sid)
	end
end


--
-- Called when a plugin menu item (see ts3plugin_initMenus) is triggered. Optional function, when not using plugin menus, do not implement this.
--
-- Parameters:
--  serverConnectionHandlerID: ID of the current server tab
--  type: Type of the menu (ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CHANNEL, ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CLIENT or ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL)
--  menuItemID: Id used when creating the menu item
--  selectedItemID: Channel or Client ID in the case of PLUGIN_MENU_TYPE_CHANNEL and PLUGIN_MENU_TYPE_CLIENT. 0 for PLUGIN_MENU_TYPE_GLOBAL.
--
local function onMenuItemEvent(sid, menuType, menuItemID, selectedItemID)
	local guid = badgelist[menuItemID][1];

	if enabledbadges[sid] == nil then
		enabledbadges[sid] = {}
		enableoverwolf[sid] = 0
	end
	
	-- clear
	if (guid == "clear") then
		enabledbadges[sid] = {}
		enableoverwolf[sid] = 0
	-- do nothing
	elseif (guid == "show") then
		
	-- overwolf
	elseif (guid == "overwolf") then
		if enableoverwolf[sid] == 0 then
			enableoverwolf[sid] = 1
		else
			enableoverwolf[sid] = 0
		end
	else
	-- badges
		local found = false
		-- find selected badge in enabled
		for i = 1, #enabledbadges[sid] do
			if enabledbadges[sid][i] == guid then
				found = true
				print ("FOUND AND DELETED")
				table.remove(enabledbadges[sid], i)
				break
			end
		end
		
		-- if new badge then insert it
		if not found then
			-- max 3 badges
			if #enabledbadges[sid] < 3 then
				table.insert(enabledbadges[sid], guid)
			else
				enabledbadges[sid][3] = enabledbadges[sid][2]
				enabledbadges[sid][2] = enabledbadges[sid][1]
				enabledbadges[sid][1] = guid
			end
		end
	end

	mybadges_helper.broadcastBadges(sid)
	-- print to user
	mybadges_helper.printBadgeList(sid)
	mybadges_helper.saveBadges()
end


mybadges_events = {
	moduleMenuItemID = moduleMenuItemID,
	onConnectStatusChangeEvent = onConnectStatusChangeEvent,
	onMenuItemEvent = onMenuItemEvent
}
