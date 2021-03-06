--[[
------------------------------------
Description: HPC ladrangvalley (Spiker Weapon), Phasor V2+
Copyright (c) 2016-2018
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]--

function GetRequiredVersion()
    return 200
end
function OnScriptLoad(processid, game, persistent)
end
function OnScriptUnload()
end
Ball = { }
math.inf = 1 / 0

Ball[1] = { "weapons\\covenant\\spiker", 95.455, -152.498, 0.162 } -- Red base (The four Cabinet Portals)
function OnNewGame(map)
    gamemap = map
    spiker_mapId = gettagid("weap", "weapons\\covenant\\spiker")

    if gamemap == "ladrangvalley" then
        for k, v in pairs(Ball) do
            local tag_id = gettagid("weap", v[1])
            v[1] = tag_id
            v[5] = createobject(tag_id, 0, math.inf, false, v[2], v[3], v[4])
            if getobject(v[5]) == nil then
                hprintf("E R R O R! Object Creation failed. Number: " .. k)
            end
        end
    end
end

function OnScriptLoad(process, game, persistent)
    if game == true or game == "PC" then
        GAME = "PC"
        gametype_base = 0x671340
        map_name = readstring(0x698F21)
        gametype = readbyte(gametype_base + 0x30)
    end
end

function OnObjectInteraction(player, objId, mapId)
    local Pass = nil
    local name, type = gettaginfo(mapId)
    if type == "weap" then
        if gametype == 1 or gametype == 3 then
            if name == "weapons\\covenant\\spiker" then
                Pass = false
            end
        end
        return Pass
    end
end