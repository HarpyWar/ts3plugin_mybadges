--[[
	Copyright (C) 2018 HarpyWar (harpywar@gmail.com)
	
	This file is a part of the plugin https://github.com/HarpyWar/ts3plugin_mybadges
]]--

local MODULE_NAME = "mybadges"
local filename = ts3.getPluginPath() .. "lua_plugin/" .. MODULE_NAME .. "/savedbadges.txt"


local function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)
    if name and depth > 1 then 
    	if not string.match(name, '^[a-zA-z_][a-zA-Z0-9_]*$') then
    		name = string.gsub(name, "'", "\\'")
			-- server identifier must be in quotes, but others are numbers - without quotes
			if depth == 2 then
				name = "[\"".. name .. "\"]"
			else
				name = "[".. name .. "]"
			end
    	end
    	tmp = tmp .. name .. " = "
    end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

local function tableToString(table)
	return "return"..serializeTable(table)
end

local function stringToTable(str)
	local f = loadstring(str)
	return f()
end





local function broadcastBadges(serverConnectionHandlerID)
	local sid = ts3.getServerVariableAsString(serverConnectionHandlerID, ts3defs.VirtualServerProperties.VIRTUALSERVER_UNIQUE_IDENTIFIER)

	
	local displaybadges = table.concat(enabledbadges[sid], ",")
	ts3.requestSendServerTextMsg(serverConnectionHandlerID, "~cmdclientupdate~sclient_badges=overwolf=" .. enableoverwolf[sid] .. ":badges=" .. displaybadges)
end


-- print to user in current tab 
-- "My Badges: 4, 14"
local function printBadgeList(sid)

	local printlist = {}
	local message = "My Badges: "

	-- display in ts3 to user his badges
	local displaybadgenames = {}
	for k = 1, #enabledbadges[sid] do
		for i = 1, #badgelist do
			if enabledbadges[sid][k] == badgelist[i][1] then
				table.insert(printlist, i-mybadges_offset)
			end
		end
	end	
	if (enableoverwolf[sid] == 1) then
		table.insert(printlist, "0")
	end
	
	message = message .. "[" .. table.concat(printlist, ", ") .. "]"
	
	ts3.printMessageToCurrentTab(message)
end



-- save session to file
local function saveBadges()
	local file = io.open(filename, "w")
	file:write( tableToString({enabledbadges, enableoverwolf}) )
	file:close()
end

-- restore session from file
local function loadBadges()
	local file = io.open(filename, "r")
	local data = file:read("*a")
	file:close()

print(data)
	local _table = stringToTable(data) 
	print ("loaded " .. #_table)
	enabledbadges = _table[1]
	enableoverwolf = _table[2]
	

	print ("loaded " .. #enabledbadges .. "/" .. #enableoverwolf)
end


mybadges_helper = {
	show = show,

	saveBadges = saveBadges,
	loadBadges = loadBadges,
	printBadgeList = printBadgeList,
	broadcastBadges = broadcastBadges
}
