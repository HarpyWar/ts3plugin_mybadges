--[[
	Copyright (C) 2018 HarpyWar (harpywar@gmail.com)
	
	This file is a part of the plugin https://github.com/HarpyWar/ts3plugin_mybadges
]]--


local function set_badge(sid, badge_id, idx)
	if badge_id < 0 or badge_id > #badgelist then
		ts3.printMessageToCurrentTab("Invalid badge ID: " .. badge_id)
		do return end
	end

	if (badge_id == 0) then
		enableoverwolf[sid] = 1
	else
		ts3.printMessageToCurrentTab(#enabledbadges[sid])
		if (#enabledbadges[sid] < 3) then
			table.insert(enabledbadges[sid], badgelist[badge_id + mybadges_offset][1])
		end
	end
	
end


-- Run with "/lua run mybadges.set 1 1 16 0"
local function set(sid, badge1, badge2, badge3, badge4)
	-- clear
	enabledbadges[sid] = {}
	enableoverwolf[sid] = 0
	
	-- add 
	if (badge1 ~= nil) then
		set_badge(sid, badge1, 1)
	end
	if (badge2 ~= nil) then
		set_badge(sid, badge2, 2)
	end
	if (badge3 ~= nil) then
		set_badge(sid, badge3, 3)
	end
	if (badge4 ~= nil) then
		set_badge(sid, badge4, 4)
	end
	
	show(sid)
end

-- Run with "/lua run mybadges.clear"
local function clear(sid)
	mybadges_events.onMenuItemEvent(sid, nil, 2, nil)
end

-- Run with "/lua run mybadges.show"
local function show(sid)
	mybadges_events.onMenuItemEvent(sid, nil, 1, nil)
end


mybadges = {
	show = show,
	clear = clear,
	set = set
}
