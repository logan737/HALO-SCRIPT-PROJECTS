--[[
--=====================================================================================================--
Script Name: Map Vote System (beta v1.0), for SAPP (PC & CE)
Description: N/A

IMPORTANT: SAPP's builtin map voting system must be disabled before using this script.
           In the init.txt file, set "mapvote" to false.

[!] Ready for Beta Testing...

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local mapvote = { }

-- ======================= MAPVOTE CONFIGURATION STARTS ======================= --
-- Players needed to vote:
mapvote.players_needed = 1

-- Map Cycle timeout (In Seconds):
mapvote.timeout = 15 -- Do not set to 0!

-- Voting Options screen alignment:
mapvote.alignment = "l"  -- Left = l, Right = r, Center = c, Tab: t

-- Number of Map Vote entries to display per page:
mapvote.maxresults = 5

-- If enabled, players will who are level 'mapvote.extrapower' (or greater) 
-- will have extra power over their vote and will add 'mapvote.extra' votes to their selection.
mapvote.extra_vote = false
mapvote.extrapower = 4
mapvote.extra = 2

-- During Voting, Chat Messages will fade after this many seconds:
mapvote.message_fade = 7

-- Total number of chat messages allowed on screen at once.
mapvote.max_chat_messages = 5

-- If players execute a command, all fedback timers will be paused for this many seconds,
-- while an error message is being displayed:
mapvote.pause_time = 1.5

-- To navigate between pages, type 'mapvote.next_page' or 'mapvote.previous_page'.
mapvote.next_page = "n"
mapvote.previous_page = "p"
--

-- If enabled, vote options will always be shuffled
mapvote.shuffle_votes = false

-- Global Server Prefix:
-- Several functions temporarily removes the ** SERVER ** prefix when it announces messges.
-- The prefix will be restored to 'mapvote.serverprefix' when the relay has finished.
mapvote.serverprefix = "** SERVER ** " -- Leave a space after the last asterisk.
--

mapvote.messages = {
    on_vote = "%name% voted for [ %mapname% ]  -  [ %gametype% ]  -  Votes: %votes%",
    on_win_vote = "%mapname% [ %gametype% ] won with %votes% vote%plural% !!",
    already_voted = "You have already voted!",

    page_navigation = "[Page %current_page%/%total_pages%] Type '%next_cmd%' -> Next Page  |  Type '%prev_cmd%' -> Previous Page",

    vote_time_remaining_1 = "Vote Time Remaining: %seconds% second%plural%",
    vote_time_remaining_2 = "[YOU HAVE VOTED] - MapCycle Time Out Remaining: %seconds% second%plural%",

    -- Random Selection Messges:
    no_one_voted = "No votes were processed! Chosing random map in (%seconds%) seconds",
    on_random_selection = "%mapname% [ %gametype% ] has been randomly selected",
}

-- This is the primary map vote configuration table.
-- Each entry must contain a valid map name and gametype - make sure you spell these correctly.

mapvote.maps = {

    -- [MAP NAME] - {AVAILABLE GAMETYPES}
    -- You can specify on a per-map basis what gametypes are available:

    ["sidewinder"] = { "ctf", "slayer", "oddball" },
    ["ratrace"] = { "ctf", "slayer" },
    ["bloodgulch"] = { "ctf", "slayer", "oddball" },
    ["beavercreek"] = { "ctf", "slayer", "oddball" },
    ["boardingaction"] = { "ctf", "slayer" },
    ["carousel"] = { "ctf", "slayer" },
    ["dangercanyon"] = { "ctf", "slayer" },
    ["deathisland"] = { "ctf", "slayer" },
    ["gephyrophobia"] = { "ctf", "slayer" },
    ["icefields"] = { "ctf", "slayer", "oddball" },
    ["infinity"] = { "ctf", "slayer" },
    ["timberland"] = { "ctf", "slayer" },
    ["hangemhigh"] = { "ctf", "slayer", "oddball" },
    ["damnation"] = { "ctf", "slayer" },
    ["putput"] = { "ctf", "slayer" },
    ["prisoner"] = { "ctf", "slayer" },
    ["wizard"] = { "ctf", "slayer" },
    ["longest"] = { "ctf", "slayer", "oddball" },

    -- Repeat the structure to add your own maps and gametypes.
}

-- ======================= MAPVOTE CONFIGURATION ENDS ======================= --

local results, cur_page, votes = { }, { }, { }
local start_page, map_count, total_pages = 1, 0, 0
local vote_options, has_voted = { }, { }
local paused = { }

local sub, gsub = string.sub, string.gsub
local gmatch = string.gmatch
local floor = math.floor
local concat = table.concat

local global_message

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
end

function OnScriptUnload()
    --
end

function setup_params()
    execute_command("sv_mapcycle_timeout " .. mapvote.timeout)

    results, votes, map_count = { }, { }, 0
    vote_options = { }

    if (end_message ~= nil) then
        end_message = nil
    end

    mapvote.timer, mapvote.start = { }, { }

    for k, _ in pairs(mapvote.maps) do
        results[#results + 1] = k
        map_count = map_count + 1
    end

    -- Shuffle Vote Options:
    if (mapvote.shuffle_votes and #results > 0) then
        local function shuffleResults(input)
            math.randomseed(os.time())
            local output = {}
            for i = #input, 1, -1 do
                local j = math.random(i)
                input[i], input[j] = input[j], input[i]
                table.insert(output, input[i])
            end
            return output
        end
        shuffleResults(results)
    end

    -- Create the primary vote table:
    for i = 1, #results do
        if (results[i]) then

            local mapname = results[i]
            local gametype = mapvote.maps[mapname]

            for j = 1, #gametype do
                if (gametype[j] ~= nil) then
                    votes[#votes + 1] = {
                        [mapname] = {
                            [gametype[j]] = { votes = 0 }
                        }
                    }
                end
            end
        end
    end
end

local Say = function(p, message)
    if (p) and (message) then
        if (type(message) == "table") then
            for i = 1, #message do
                if (message[i] ~= nil) then
                    rprint(p, "|" .. mapvote.alignment .. " " .. message[i])
                end
            end
        else
            rprint(p, "|" .. mapvote.alignment .. " " .. message)
        end
    end
end

-- Returns the current vote page:
local getPage = function(page)
    local current_page = tonumber(page) or nil

    if (current_page == nil) then
        current_page = 1
    end

    local max_results = mapvote.maxresults
    local start = (max_results) * current_page
    local startpage = (start - max_results + 1)
    local endpage = start

    return startpage, endpage
end

-- Returns the total number of pages:
local getPageCount = function(total, max_results)
    local pages = total / (max_results)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

-- A neat function to handle spacing in a string.
local function spacing(n, sep)
    sep = sep or ""
    local String = ""
    for i = 1, n do
        if i == floor(n / 2) then
            String = String .. ""
        end
        String = String .. " "
    end
    return sep .. String
end

-- Receives number - determines whether to pluralize.
-- Returns string 's' if the input is greater than 1.
local function getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

local function hasExtraVotePower(p)
    local level = tonumber(get_var(p, "$lvl"))
    if (level >= mapvote.extrapower) then
        return true
    end
end

function OnGameStart()
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_CHAT'])
    unregister_callback(cb['EVENT_COMMAND'])
end

-- This function iterates over the map table and selects a random map & gametype:
local getRandomMap = function()
    local map_table = mapvote.maps

    math.randomseed(os.time())
    local x = math.random(1, map_count)
    for mapname, _ in pairs(map_table) do
        local gametype_table = votes[x][mapname]
        if (gametype_table ~= nil) then
            for gametype, _ in pairs(gametype_table) do
                return mapname, gametype
            end
        end
    end
end

-- This function returns the total number of players currently online.
local player_count = function()
    return tonumber(get_var(0, "$pn"))
end

function mapvote:calculate_votes()
    cls(0, 25, true, "chat")

    local final_results = { }
    end_message = end_message or { }
    end_message.timer, end_message.msg = 0, ""

    local map_table = mapvote.maps
    for mapname, _ in pairs(map_table) do
        -- mapname = mapname string
        for index, _ in pairs(votes) do
            local gametype_table = votes[index][mapname]
            if (gametype_table ~= nil) then
                for gametype, _ in pairs(gametype_table) do
                    -- gametype = gametype string
                    local FinalVotes = gametype_table[gametype].votes
                    if (FinalVotes ~= nil) and (FinalVotes > 0) then
                        local map = (FinalVotes .. "|" .. mapname .. "|" .. gametype)
                        final_results[#final_results + 1] = map
                    end
                end
            end
        end
    end

    local messages = mapvote.messages
    if (#final_results > 0) then
        table.sort(final_results)
        local result = {}
        result[#result + 1] = final_results[#final_results]
        if (#result > 0) then
            for _, v in pairs(result) do
                local data = stringSplit(v, "|")
                if (data) then
                    local fResult, i = { }, 1
                    for j = 1, 3 do
                        if (data[j] ~= nil) then
                            fResult[i] = data[j]
                            i = i + 1
                        end
                    end
                    if (fResult ~= nil) then

                        local final_votes, mapname, gametype = fResult[1], fResult[2], fResult[3]
                        local char = getChar(final_votes)
                        execute_command("map " .. mapname .. " " .. gametype)
                        local msg = gsub(gsub(gsub(gsub(messages.on_win_vote, "%%mapname%%", mapname), "%%gametype%%", gametype), "%%votes%%", final_votes), "%%plural%%", char)
                        end_message.msg = msg
                        cprint(msg, 2 + 8)
                        break
                    end
                end
            end
        end
    else
        -- RANDOM MAP SELECTION ...

        local delay = 3
        function delay_map_selection()
            local map, gametype = select(1, getRandomMap()), select(2, getRandomMap())
            execute_command("map " .. map .. " " .. gametype)
            local msg = gsub(gsub(messages.on_random_selection, "%%mapname%%", map), "%%gametype%%", gametype)
            end_message.msg = msg
            cprint(msg, 2 + 8)
        end
        timer(1000 * delay, "delay_map_selection")

        local msg = gsub(messages.no_one_voted, "%%seconds%%", delay)
        end_message.msg = msg
        cprint(msg, 2 + 8)
    end
end

function OnGameEnd()
    setup_params()
    if (tonumber(get_var(0, "$pn")) >= mapvote.players_needed) then
        total_pages = getPageCount(map_count, mapvote.maxresults)

        global_message = { }
        global_message.timer = { }
        global_message.timer[0] = 0

        function delay_clear_chat()
            cls(0, 25, true, "chat")
        end
        timer(50, "delay_clear_chat")

        -- Begin voting process.
        mapvote:begin()

        -- Register a hook into SAPP's tick event.
        register_callback(cb['EVENT_TICK'], "OnTick")
        -- Register a hook into SAPP's chat event.
        register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
        register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    end
end

function mapvote:begin()

    for i = 1, 16 do
        if player_present(i) then
            cur_page[i], has_voted[i] = start_page, false
            vote_options[i], mapvote.start[i] = { }, true
            paused[i] = { }
            paused[i].start, paused[i].timer = false, 0
        end
    end

    -- Init map cycle timer:
    mapvote.timer[0], mapvote.start[0] = 0, true
    cprint("MAP VOTING HAS BEGUN", 2 + 8)
end

-- This function handles chat messages and vote feedback:
local function RelayMessages(p)
    if (global_message ~= nil) then
        for j = 1, #global_message do
            if (global_message[j] ~= nil) then
                if (global_message.timer[0] ~= nil) then
                    global_message.timer[0] = global_message.timer[0] + 0.030
                    if (global_message.timer[0] >= mapvote.message_fade) or (#global_message >= mapvote.max_chat_messages) then
                        global_message.timer[0] = 0
                        -- Remove the first message from the array:
                        table.remove(global_message, 1)
                    else
                        -- Relay message to player
                        rprint(p, global_message[j])
                    end
                end
            end
        end
    end
end

function OnTick()
    if (mapvote.start ~= nil and mapvote.start[0] == true) then
        mapvote.timer[0] = mapvote.timer[0] + 0.030
        if (mapvote.timer[0] >= mapvote.timeout) then
            mapvote.start = nil
            mapvote:calculate_votes()
        else
            for i = 1, 16 do
                if player_present(i) then

                    if not (paused[i].start) then

                        -- Clear Console
                        cls(i, 25)

                        -- Show Vote Options:
                        local m = mapvote.messages
                        if (mapvote.start[i] ~= nil) then
                            mapvote:showMapVoteOptions(i)
                            rprint(i, ' ')
                            local msg = gsub(gsub(gsub(gsub(m.page_navigation,
                                    "%%current_page%%", cur_page[i]),
                                    "%%total_pages%%", total_pages),
                                    "%%next_cmd%%", mapvote.next_page),
                                    "%%prev_cmd%%", mapvote.previous_page)
                            rprint(i, msg)
                        end
                        --

                        -- Show chat messages and vote feedback:
                        RelayMessages(i)

                        local seconds = secondsToTime(mapvote.timer[0])
                        local char = getChar(mapvote.timeout - floor(seconds))

                        if not (has_voted[i]) then
                            local msg = gsub(gsub(m.vote_time_remaining_1, "%%seconds%%", mapvote.timeout - floor(seconds)), "%%plural%%", char)
                            rprint(i, msg)
                        else
                            local msg = gsub(gsub(m.vote_time_remaining_2, "%%seconds%%", mapvote.timeout - floor(seconds)), "%%plural%%", char)
                            rprint(i, msg)
                        end
                    elseif (paused[i].timer >= mapvote.pause_time) then
                        paused[i].start, paused[i].timer = false, 0
                    else
                        paused[i].timer = paused[i].timer + 0.030
                    end
                    --
                end
            end
        end
    elseif (end_message.timer ~= nil) then
        end_message.timer = end_message.timer + 0.030
        if (end_message.timer >= 5) then
            end_message.timer, global_message = nil, nil
        else
            for i = 1, 16 do
                if player_present(i) then
                    if not (paused[i].start) then
                        local _spacing = 5

                        -- Clear Console:
                        cls(i, 25)

                        -- Print vote feedback:
                        rprint(i, "|c" .. end_message.msg)
                        rprint(i, "|c__________________________________________________________________")
                        for _ = 1, (_spacing - player_count()) do
                            rprint(i, " ")
                        end

                        -- Show chat messages and vote feedback:
                        RelayMessages(i)
                        --
                    elseif (paused[i].timer >= mapvote.pause_time) then
                        paused[i].start, paused[i].timer = false, 0
                    else
                        paused[i].timer = paused[i].timer + 0.030
                    end
                end
            end
        end
    end
end

function mapvote:showMapVoteOptions(p)

    if (vote_options[p][1] == nil) then
        vote_options[p] = { }
        local startpage, endpage = select(1, getPage(cur_page[p])), select(2, getPage(cur_page[p]))
        for i = startpage, endpage do
            if (results[i]) then

                local mapname, m = results[i], { }
                local gametypes = mapvote.maps[mapname]

                local part_one, part_two = i .. spacing(2) .. mapname .. ":" .. spacing(1) .. ""

                for j = 1, #gametypes do
                    if (gametypes[j] ~= nil) then
                        m[#m + 1] = "[" .. j .. spacing(2) .. gametypes[j] .. "]"
                        part_two = concat(m, ", ")
                    end
                end

                vote_options[p][#vote_options[p] + 1] = part_one .. spacing(1) .. part_two
            end
        end
    end

    if (vote_options[p] ~= nil) and (vote_options[p][1] ~= nil) then
        Say(p, vote_options[p])
    end
end

local function add_message(msg, name)
    if (global_message ~= nil) then
        if (name) then
            name = name .. ": "
        else
            name = ""
        end
        local chat_format = name .. msg
        global_message[#global_message + 1] = chat_format
        if (global_message.timer[0] ~= nil) then
            global_message.timer[0] = 0
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local p = tonumber(PlayerIndex)
    local name = get_var(p, "$name")

    local msg = stringSplit(Message)
    if (#msg == 0) then
        return false
    elseif (sub(msg[1], 1, 1) == "/" or sub(msg[1], 1, 1) == "\\") then
        if (paused[p].start ~= true) then
            paused[p].start = true
            cls(p, 25)
            rprint(p, "Commands Disabled. Please wait until the next game begins.")
        end
        return false
    elseif (mapvote.start ~= nil and mapvote.start[p] ~= nil) then
        if (msg[1] == mapvote.next_page) or (msg[1] == mapvote.previous_page) then

            if (msg[1] == mapvote.next_page) then
                cur_page[p] = cur_page[p] + 1
            elseif (msg[1] == mapvote.previous_page) then
                cur_page[p] = cur_page[p] - 1
            end

            if (cur_page[p] < start_page) then
                cur_page[p] = total_pages
            elseif (cur_page[p] > total_pages) then
                cur_page[p] = start_page
            end

            if (vote_options[p][1] ~= nil) then
                vote_options[p][1] = nil
            end
            -- VOTE SELECTION ...
        elseif (msg[1] ~= nil and msg[2] ~= nil) and msg[1]:match("%d+") and msg[2]:match("%d+") then
            local messages = mapvote.messages
            local name = get_var(p, "$name")

            local map_selection_id = tonumber(msg[1]:match("%d+")) or nil
            local gamemode_selection_id = tonumber(msg[2]:match("%d+")) or nil

            -- Check if the player has already voted
            if not (has_voted[p]) then

                local current_start, current_end = select(1, getPage(cur_page[p])), select(2, getPage(cur_page[p]))

                for index = current_start, current_end do
                    if (results[index]) then

                        local mapname, gametype
                        local m = results[index]
                        local gt = mapvote.maps[m]

                        if (map_selection_id == index) then
                            mapname = m
                            for i = 1, #gt do
                                if (gt[i] ~= nil) then
                                    if (gamemode_selection_id == i) then
                                        gametype = gt[i]
                                        break
                                    end
                                end
                            end
                        end

                        if (mapname ~= nil) and (gametype ~= nil) then
                            for _, v in pairs(votes) do
                                local map_table = v[mapname]
                                if (map_table ~= nil) then
                                    local value = v[mapname][gametype]
                                    if (value ~= nil) then
                                        local cur_votes = value.votes

                                        if (mapvote.extra_vote) then
                                            if hasExtraVotePower(p) then
                                                value.votes = cur_votes + mapvote.extra
                                            end
                                        else
                                            value.votes = cur_votes + 1
                                        end

                                        local msg = gsub(gsub(gsub(gsub(messages.on_vote,
                                                "%%name%%", name),
                                                "%%mapname%%", mapname),
                                                "%%gametype%%", gametype),
                                                "%%votes%%", value.votes)
                                        has_voted[p], mapvote.start[p] = true, nil
                                        cls(p, 25)
                                        add_message(msg)
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            else
                local msg = gsub(messages.already_voted, "%%name%%", name)
                rprint(p, msg)
            end
        elseif (global_message ~= nil) then
            add_message(Message, name)
        end
    elseif (global_message ~= nil) and (mapvote.start ~= nil or mapvote.start == nil or mapvote.start[p] ~= nil) then
        add_message(Message, name)
    else
        cls(p, 25)
        rprint(p, "Chat Muted. Please wait until the next game begins!")
    end
    return false
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local msg = stringSplit(Command)
    local p = tonumber(PlayerIndex)

    if (#msg == 0) then
        return false
    elseif (paused[p].start ~= true) then
        paused[p].start = true

        cls(p, 25)

        rprint(p, "Commands Disabled. Please wait until the next game begins.")
        return false
    end
end

function cls(PlayerIndex, count, clear_chat, type)
    count = count or 25
    if (PlayerIndex) and not (clear_chat) then
        for _ = 1, count do
            rprint(PlayerIndex, " ")
        end
    elseif (clear_chat) then
        for i = 1, 16 do
            if player_present(i) then
                for _ = 1, count do
                    if (type == "chat") then
                        execute_command("msg_prefix \"\"")
                        say(i, " ")
                        execute_command("msg_prefix \" " .. mapvote.serverprefix .. "\"")
                    else
                        rprint(i, " ")
                    end
                end
            end
        end
    end
end

function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end
