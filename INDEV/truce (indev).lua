--[[
--=====================================================================================================--
Script Name: Truce, for SAPP (PC & CE)
Description: N/A

Command Syntax: 
    * /truce [player id]
    * /accept [player id]
    * /deny [player id]
    * /untruce [player id]
    * /trucelist

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"
-- configuration [starts] -->

-- Minimum privilege level required to execute /truce command. Set to -1 (negative one) for all players
local privilege_level = -1

local base_command = "truce"
local accept_command = "accept"

-- # Message Configuration:
local on_request = {
    -- Messages transmitted to the target player
    msgToTarget = {
        "%executor_name% is requesting a truce with you.",
        "To accept, type /accept %executor_id%",
        "To deny this request, type /deny %executor_id%"
    },

    -- Message transmitted to the executor
    msgToExecutor = {"Request sent to %target_name%"}
}

local on_accept = {
    -- Messages transmitted to the target player
    msgToTarget = {"You are now in a truce with %executor_name%"},
    -- Message transmitted to the executor
    msgToExecutor = {"[request accepted] You are now in a truce with %target_name%"}
}

local on_deny = {
    -- Messages transmitted to the target player
    msgToTarget = {"You denied %target_name%'s truce request"},
    -- Message transmitted to the executor
    msgToExecutor = {"%executor_name% denied your truce request"}
}


-- configuration [ends] <--

local truce = { }
local requests = { }
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
end

function OnScriptUnload()

end

function OnPlayerConnect(PlayerIndex)
    requests[PlayerIndex] = { }
    requests[PlayerIndex].active = 0
end

local function checkAccess(PlayerIndex)
    if (tonumber(get_var(PlayerIndex, "$lvl"))) >= privilege_level then
        return true
    else
        rprint(PlayerIndex, "Command failed. Insufficient Permission.")
        return false
    end
end

local function isOnline(TargetID, executor)
    if player_present(TargetID) then
        return true
    else
        rprint(executor, "Command failed. Player not online.")
        return false
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    
	local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local TargetID = tonumber(args[1])
    
	if (command == string.lower(base_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            if isOnline(TargetID, executor) then
                if (TargetID ~= executor) then
                    local players = {}
                    players.en = get_var(executor, "$name")
                    players.eid = tonumber(get_var(executor, "$n"))
                    players.tn = get_var(TargetID, "$name")
                    players.tid = tonumber(get_var(TargetID, "$n"))
                    truce:sendrequest(players)
                else
                    rprint(executor, "Command failed. You cannot initiate a truce with yourself.")
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /truce [player id]")
        end
        return false
    elseif (command == string.lower(accept_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            if isOnline(TargetID, executor) then
                -- accept logic
            end
        else
            rprint(executor, "Invalid syntax. Usage: /accept [player id]")
        end
        return false
	end
    
end

function truce:sendrequest(params)
    local params = params or {}
    
    local executor_name = params.en or nil
    local executor_id = params.eid or nil
    
    local target_name = params.tn or nil
    local target_id = params.tid or nil
    
    local msgToExecutor, msgToTarget = on_request.msgToExecutor, on_request.msgToTarget
    for k, _ in pairs(msgToExecutor) do
        local StringFormat = gsub(msgToExecutor[k], "%%target_name%%", target_name)
        rprint(executor_id, StringFormat)
    end
    for k, _ in pairs(msgToTarget) do
        local StringFormat = (gsub(gsub(msgToTarget[k], "%%executor_name%%", executor_name), "%%executor_id%%", executor_id))
        rprint(target_id, StringFormat)
    end
    
    requests[target_id].active = requests[target_id].active + 1
end

function truce:enable(params)
    local params = params or {}
end

function truce:disable(params)
    local params = params or {}
end

function truce:list(params)
    local params = params or {}
end

function cmdsplit(str)
	local subs = {}
	local sub = ""
	local ignore_quote, inquote, endquote
	for i = 1,string.len(str) do
		local bool
		local char = string.sub(str, i, i)
		if char == " " then
			if (inquote and endquote) or (not inquote and not endquote) then
				bool = true
			end
		elseif char == "\\" then
			ignore_quote = true
		elseif char == "\"" then
			if not ignore_quote then
				if not inquote then
					inquote = true
				else
					endquote = true
				end
			end
		end
		
		if char ~= "\\" then
			ignore_quote = false
		end
		
		if bool then
			if inquote and endquote then
				sub = string.sub(sub, 2, string.len(sub) - 1)
			end
			
			if sub ~= "" then
				table.insert(subs, sub)
			end
			sub = ""
			inquote = false
			endquote = false
		else
			sub = sub .. char
		end
		
		if i == string.len(str) then
			if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
				sub = string.sub(sub, 2, string.len(sub) - 1)
			end
			table.insert(subs, sub)
		end
	end
	
	local cmd = subs[1]
	local args = subs
	table.remove(args, 1)
	
	return cmd, args
end