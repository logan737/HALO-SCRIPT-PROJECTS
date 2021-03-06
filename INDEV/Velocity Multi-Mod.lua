--[[
--=====================================================================================================--
Script Name: Velocity Multi-Mod (v 1.68), for SAPP (PC & CE)
Description: Velocity is an all-in-one package that combines a multitude of my scripts.
             ALL combined scripts have been heavily refactored, refined and improved for Velocity,
             with the addition of many new features not found in the standalone versions,
             as well as a ton of "special" features unique to Velocity that do not come in standalone scripts.

Combined Scripts:
    - Admin Chat                Admin Join Messages         Alias System         Anti Impersonator         Auto Message
    - Block Object Pickups
    - Chat Censor               Chat IDs                    Chat Logging         Color Changer             Color Reservation
    - Command Spy               Console Logo                Custom Weapons       Cute
    - Enter Vehicle
    - Garbage Collection        Get Coords                  Give
    - Infinity Ammo             Item Spawner
    - Lurker
    - Welcome Messages          Mute System
    - Player List               Portal Gun                  Private Messaging System
    - Respawn On Demand         Respawn Time
    - Suggestions Box
    - Teleport Manager

    ## Special Commands:
    `/plugins [page id]`
    `/enable [id]` & `/disable [id]`
    > /plugins [page id] will display a list of all individual features indicating which ones are enabled or disabled.
    > You can enable or disable any feature at any time with /enable [id], /disable [id].
    
    `/velocity`
    > If update checking is disabled this command will only display the current script version.
    > If update checking is enabled this command will send an http query to the Velocity GitHub page and return the latest version if an update is available.
   
    > To enable update checking, this script requires that the following plugin is installed:
    https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
    Credits to Kavawuvi (002) for HTTP client functionality.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"
local settings = { }
-- Configuration [STARTS] ---------------------------------------
local function GameSettings()
    settings = {

        --[[
            1). enabled: Enabled = true, Disabled = false
            2). permission_level: Minimum level required to execute a command.
            3). execute_on_others: Minimum level required to execute a command on others.
        
        ]]

        mod = {
            ["Admin Chat"] = { -- Chat privately with other admins.
                enabled = true,
                base_command = "achat", -- /base_command [me | id | */all] [on|off|0|1|true|false)
                permission_level = 1,
                execute_on_others = 4,
                prefix = "[ADMIN CHAT]",
                restore = true,
                environment = "rcon", -- Valid environments: "rcon", "chat".
                message_format = {
                    "%prefix% %sender_name% [%index%]:",
                    "%message%",
                }

            },
            ["Admin Join Messages"] = { -- Custom join messages for staff on a per-level basis.
                enabled = true,
                messages = {
                    -- [prefix] [message] (note: the joining player's name is automatically inserted between [prefix] and [message])
                    [1] = { "[TRIAL-MOD] ", " joined the server. Everybody hide!" },
                    [2] = { "[MODERATOR] ", " just showed up. Hold my beer!" },
                    [3] = { "[ADMIN] ", " just joined. Hide your bananas!" },
                    [4] = { "[SENIOR-ADMIN] ", " joined the server." },
                }
            },
            ["Alias System"] = { -- Query a player's hash to check what aliases have been used with it.
                enabled = true,
                base_command = "alias", -- /base_command [id | me ] [page id]
                dir = "sapp\\alias.lua",
                permission_level = 1,
                max_results_per_page = 50,
                use_timer = true,
                duration = 5, -- How long should the alias results be displayed for? (in seconds)
                alignment = "|l", -- Left = l, Right = r, Center = c, Tab: t
            },
            ["Anti Impersonator"] = { -- Prevent other players from impersonating your clan/community members.
                enabled = true,
                action = "kick", -- Valid actions, "kick", "ban"
                reason = "impersonating",
                bantime = 10, -- (In Minutes) -- Set to zero to ban permanently
                users = {
                    { ["Chalwk"] = { "127.0.0.1", "6c8f0bc306e0108b4904812110185edd", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },
                    { ["Ro@dhog"] = { "0ca756f62f9ecb677dc94238dcbc6c75", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },

                    -- If someone joins with the name 'example_name' and their ip address (or hash) 
                    -- does not match any of the ip address (or hashes) for that name entry, action will be taken.
                    { ["example_name"] = { "127.0.0.1", "128.0.0.2", "129.0.0.3", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },

                    -- repeat the structure to add more entries...
                    { ["name_here"] = { "ip 1", "ip 2", "hash1", "hash2", "hash3", "etc..." } },
                    -- You do not need both ip and hash but it adds a bit more security.
                },
            },
            ["Auto Message"] = {
                -- This feature will automatically broadcast messages every 'time_between_messages' seconds.
                -- You can manually broadcast a message on demand with /base_command [message id].
                -- To get the message id, type "/base_command list".
                enabled = false,
                permission_level = 1,
                base_command = "broadcast",
                time_between_messages = 300, -- 300 = 5 minutes
                announcements = {
                    { -- Message #1:
                        "Like us on Facebook | facebook.com/page_id",
                        "Get updates on special events and other shenanigans.",
                    },
                    { -- Message #2:
                        "Follow us on Twitter | twitter.com/twitter_id",
                        "Share your favourite game screen shots with us!",
                    },
                    { -- Message #3:
                        "Interested in becoming an official member of our community?",
                        "We are recruiting! Sign up on our website | website url",
                    },
                    -- Repeat the structure to add more entries.
                },
            },
            ["Block Object Pickups"] = {
                -- Prevent players from picking up objects (weapons & powerups etc)
                enabled = true,
                permission_level = 1,
                execute_on_others = 4,
                block_command = "block", -- /block_command [me | id | */all]
                unblock_command = "unblock", -- /unblock_command [me | id | */all]
                enable_on_disconnect = false, -- Reenable pickups for player if they quit (means it will be reenabled if they rejoin)
            },
            -- # Chat Censor.
            ["Chat Censor"] = {
                enabled = true,
                censor = "*",
                words = {
                    [1] = { "arsehole", "asshole", "a$$", "a$$hole", "a_s_s", "a55", "a55hole", "ahole" },
                    [2] = { "bitch", "b[%p]tch", "b17ch", "b1tch" },
                    [3] = { "boner" },
                    [4] = { "^bs$", "bullshit", "bullsh[%p]t" },
                    [5] = { "clit", "cl[%p]t" },
                    [6] = { "^cum$" },
                    [7] = { "cunt" },
                    [8] = { "cock", "c0ck", "cOck", "cocksucker"},
                    [9] = { "dick", "dickhead", "d[%p]ckhead"},
                    [10] = { "^fag$", "faggot", "^fagg$" },
                    [11] = { "fatass" },
                    [12] = { "fuck", "fcuk", "fucker", "fucck", "fucccckkk", "fcucking", "fuccckcckkk"},
                    [13] = { "nigga", "nigger", "n[%p]gga", "n[%p]gger" },
                    [14] = { "prick" },
                    [15] = { "pussy", "p[%s]ussy"},
                    [16] = { "slut" },
                    [17] = { "sh[%p]t", "shit", "sh[%p]+", "sh1t", "5h1t", "5hit" },
                    [18] = { "bitch", "bitches", "b[%p]tch", "b[%p]tches" },
                    [19] = { "wank", "wanker" },
                    [20] = { "whore", "wh0re", "wh0reface" },
                    [21] = { ":v", ">:v", ":'v", ">:'v", ": v", ":  v", ":    v" },
                }
            },
            ["Chat IDs"] = {
                --[[
                    This feature modifies player chat messages.
                    --> Adds a Player Index ID in front of their name in square [] brackets.
                
                    Example: 
                    Team output: [Chalwk] [1]: This is a test message
                    Global output: Chalwk [1]: This is a test message
                --]]
                enabled = true,
                global_format = { "%sender_name% [%index%]: %message%" },
                team_format = { "[%sender_name%] [%index%]: %message%" },
                use_admin_prefixes = false, -- Set to TRUE to enable the below bonus feature.
                -- Ability to have separate chat formats on a per-admin-level basis...
                trial_moderator = {
                    lvl = 1,
                    "[T-MOD] %sender_name% [%index%]: %message%", -- global
                    "[T-MOD] [%sender_name%] [%index%]: %message%" -- team
                },
                moderator = {
                    lvl = 2,
                    "[MOD] %sender_name% [%index%]: %message%", -- global
                    "[MOD] [%sender_name%] [%index%]: %message%" -- team
                },
                admin = {
                    lvl = 3,
                    "[ADMIN] %sender_name% [%index%]: %message%", -- global
                    "[ADMIN] [%sender_name%] [%index%]: %message%" -- team
                },
                senior_admin = {
                    lvl = 4,
                    "[S-ADMIN] %sender_name% [%index%]: %message%", -- global
                    "[S-ADMIN] [%sender_name%] [%index%]: %message%" -- team
                },
                ignore_list = {
                    "skip",
                }
            },
            -- # Logs chat, commands and quit-join events.
            ["Chat Logging"] = {
                enabled = true,
                dir = "sapp\\Server Chat.txt"
            },
            ["Color Changer"] = { -- # Change any player's armour color on demand.
                enabled = true,
                permission_level = 1,
                execute_on_others = 4,
                base_command = "setcolor",
            },
            ["Color Reservation"] = {
                enabled = false, -- Enabled = true, Disabled = false
                color_table = {
                    [1] = { "6c8f0bc306e0108b4904812110185edd" }, -- white (Chalwk)
                    [2] = { "available" }, -- black
                    [3] = { "available" }, -- red
                    [4] = { "available" }, -- blue
                    [5] = { "available" }, -- gray
                    [6] = { "available" }, -- yellow
                    [7] = { "available" }, -- green
                    [8] = { "available" }, -- pink
                    [9] = { "available" }, -- purple
                    [10] = { "available" }, -- cyan
                    [11] = { "available" }, -- cobalt
                    [12] = { "available" }, -- orange
                    [13] = { "abd5c96cd22517b4e2f358598147c606" }, -- teal (Shoo)
                    [14] = { "0ca756f62f9ecb677dc94238dcbc6c75" }, -- sage (Ro@dhod)
                    [15] = { "available" }, -- brown
                    [16] = { "available" }, -- tan
                    [17] = { "available" }, -- maroon
                    [18] = { "available" } -- salmon
                }
            },
            -- Admins get notified when a player executes a command
            ["Command Spy"] = {
                enabled = true,
                permission_level = 1,
                prefix = "[SPY]",
                hide_commands = true,
                commands_to_hide = {
                    "/accept",
                    "/deny",
                    -- "/afk",
                    -- "/lead",
                    -- "/stfu",
                    -- "/unstfu",
                    -- "/skip",
                    -- repeat the structure to add more entries
                }
            },
            ["Console Logo"] = { -- A nifty console logo (ascii: 'kban')
                enabled = true,
                logo = {
                    -- MESSAGE | COLOR
                    { "================================================================================", 2 + 8 },
                    { "%date_and_time%", 6 },
                    { "" },
                    { "     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 4 + 8 },
                    { "      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 4 + 8 },
                    { "      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 4 + 8 },
                    { "      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 4 + 8 },
                    { "     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 4 + 8 },
                    { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
                    { "                               %server_name%", 7 + 8 },
                    { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
                    { "" },
                    { "================================================================================", 2 + 8 },
                }
            },
            ["Custom Weapons"] = {
                enabled = false, -- Enabled = true, Disabled = false
                assign_weapons = false,
                assign_custom_frags = false,
                assign_custom_plasmas = false,
                weapons = {

                    -- [!] WARNING: 4th weapon slot is usually reserved for the objective (flag/oddball).
                    -- If this slot is occupied, you cannot pick up the objective.

                    -- [slot1,slot2,slot3,slot4] [frags,plasmas] [map enabled/disabled (true or false)]

                    -- If you don't want to utilize custom grenade assignments for a given map, 
                    -- and would prefer to use the game-type settings for grenade assignments instead, set the respective grenade type count to "00" (double zero).

                    -- If you want to utilize a given map for grenade assignment but not weapon assignments, set all 4 weapon slots to 'nil'.
                    -- You will spawn with default weapons set in the game-type settings.

                    -- If you want to utilize weapon assignments but don't want to spawn with grenades (at all) on a given map, 
                    -- set the respective grenade type count to '0' (single 0).

                    -- To completely disable custom weapon and grenade assignment for a given map, set the last value to 'false'

                    ["beavercreek"] = { pistol, sniper, nil, nil, 00, 00, false },
                    ["bloodgulch"] = { sniper, pistol, needler, nil, 2, 2, false },
                    ["boardingaction"] = { shotgun, pistol, nil, nil, 1, 3, false },
                    ["carousel"] = { sniper, pistol, shotgun, nil, 2, 2, false },
                    ["dangercanyon"] = { pistol, rocket_launcher, assault_rifle, nil, 00, 00, false },
                    ["deathisland"] = { sniper, pistol, assault_rifle, nil, 1, 1, false },
                    ["gephyrophobia"] = { sniper, pistol, rocket_launcher, nil, 3, 3, false },
                    ["icefields"] = { pistol, assault_rifle, nil, nil, 2, 3, false },
                    ["infinity"] = { pistol, sniper, rocket_launcher, nil, 4, 4, false },
                    ["sidewinder"] = { pistol, rocket_launcher, plasma_cannon, nil, 3, 2, false },
                    ["timberland"] = { pistol, assault_rifle, needler, nil, 3, 3, true },
                    ["hangemhigh"] = { pistol, shotgun, nil, nil, 2, 2, false },
                    ["ratrace"] = { assault_rifle, pistol, nil, nil, 0, 0, false },
                    ["damnation"] = { assault_rifle, pistol, nil, nil, 1, 3, false },
                    ["putput"] = { plasma_pistol, plasma_rifle, nil, nil, 1, 1, false },
                    ["prisoner"] = { pistol, rocket_launcher, nil, nil, 1, 1, false },
                    ["wizard"] = { pistol, sniper, nil, nil, 0, 0, true },
                    -- [ custom maps ]...
                    -- place custom weapon tag IDs in the loadWeaponTags() function and assign a variable name to them.
                    -- Repeat the structure to add more maps.
                    ["room_final"] = { rocket_launcher, nil, nil, nil, 00, 00, true },
                    ["dead_end"] = { pistol, assault_rifle, nil, nil, 00, 00, true },
                    ["gruntground"] = { needler, nil, nil, nil, 1, 1, true },
                    ["feelgoodinc"] = { rocket_launcher, nil, nil, nil, 00, 00, true },
                    ["lolcano"] = { rocket_launcher, nil, nil, nil, 00, 00, true },
                    ["camden_place"] = { pistol, nil, nil, nil, 00, 00, true },
                    ["alice_gulch"] = { pistol, nil, nil, nil, 00, 00, true },
                    ["church"] = { pistol, assault_rifle, nil, nil, 00, 00, true },
                    ["dummy"] = { rocket, nil, nil, nil, 00, 00, true },
                    ["snowdrop"] = { battle_rifle, pistol, nil, nil, 00, 00, true },
                    ["dangerouscanyon"] = { rocket_launcher, sniper, nil, nil, 00, 00, true },
                    ["shotguncreek"] = { shotgun, nil, nil, nil, 00, 00, true },
                },
            },
            ["Cute"] = {
                -- # What cute things did you do today? (requested by Shoo)
                enabled = true,
                base_command = "cute", -- /base_command [me | id | */all]

                -- Use %executors_name% (optional) variable to output the executor's name.
                -- Use %target_name% (optional) variable to output the target's name.

                messages = {
                    -- Target sees this message
                    "%target_name%, what cute things did you do today?",
                    -- Command response (to executor)
                    "[you] -> %target_name%, what cute things did you do today?",
                },
                permission_level = -1,
                environment = "chat" -- Valid environments: "rcon", "chat".
            },
            ["Enter Vehicle"] = {
                enabled = true,
                base_command = "enter", -- /base_command <item> [me | id | */all] (opt height/distance)
                permission_level = 1,
                execute_on_others = 4,
                multi_control = true,
                -- Destroy objects spawned:
                garbage_collection = {
                    on_death = true,
                    on_disconnect = true,
                },
            },
            -- Used for Item Spawner and Enter Vehicle
            ["Garbage Collection"] = {
                enabled = true,
                base_command = "clean", -- /base_command <item> [me | id | */all]
                permission_level = 1,
                execute_on_others = 4,
            },
            ["Get Coords"] = {
                enabled = true,
                base_command = "gc", -- /base_command
                permission_level = 1,
                execute_on_others = 4,
            },
            ["Give"] = {
                enabled = true,
                base_command = "give", -- /base_command <item> [me | id | */all]
                permission_level = 1,
                execute_on_others = 4,
            },
            ["Infinity Ammo"] = {
                enabled = true,
                server_override = false, -- If this is enabled, all players will have Infinity (perma-ammo) by default (the /infammo command cannot be used)
                base_command = "infammo",
                announcer = false, -- If this is enabled then all players will be alerted when someone goes into Infinity Ammo mode.
                permission_level = 1,
                multiplier_min = 0.001, -- minimum damage multiplier
                multiplier_max = 10, -- maximum damage multiplier
            },
            ["Item Spawner"] = {
                enabled = true,
                base_command = "spawn", -- /base_command <item> [me | id | */all] [amount]
                permission_level = 1,
                execute_on_others = 4,
                -- Destroy objects spawned:
                garbage_collection = {
                    on_death = true,
                    on_disconnect = true,
                },
                list = "itemlist",
                max_results_per_page = 20,
                distance_from_playerX = 2.5,
                distance_from_playerY = 2.5,
                objects = {
                    -- "Item Name", "tag type", "tag name"
                    [1] = { "cyborg", "bipd", "characters\\cyborg_mp\\cyborg_mp" },

                    -- Equipment
                    [2] = { "camo", "eqip", "powerups\\active camouflage" },
                    [3] = { "health", "eqip", "powerups\\health pack" },
                    [4] = { "overshield", "eqip", "powerups\\over shield" },
                    [5] = { "frag", "eqip", "weapons\\frag grenade\\frag grenade" },
                    [6] = { "plasma", "eqip", "weapons\\plasma grenade\\plasma grenade" },

                    -- Vehicles
                    [7] = { "banshee", "vehi", "vehicles\\banshee\\banshee_mp" },
                    [8] = { "turret", "vehi", "vehicles\\c gun turret\\c gun turret_mp" },
                    [9] = { "ghost", "vehi", "vehicles\\ghost\\ghost_mp" },
                    [10] = { "tank", "vehi", "vehicles\\scorpion\\scorpion_mp" },
                    [11] = { "rhog", "vehi", "vehicles\\rwarthog\\rwarthog" },
                    [12] = { "hog", "vehi", "vehicles\\warthog\\mp_warthog" },

                    -- Weapons
                    [13] = { "rifle", "weap", "weapons\\assault rifle\\assault rifle" },
                    [14] = { "ball", "weap", "weapons\\ball\\ball" },
                    [15] = { "flag", "weap", "weapons\\flag\\flag" },
                    [16] = { "flamethrower", "weap", "weapons\\flamethrower\\flamethrower" },
                    [17] = { "needler", "weap", "weapons\\needler\\mp_needler" },
                    [18] = { "pistol", "weap", "weapons\\pistol\\pistol" },
                    [19] = { "ppistol", "weap", "weapons\\plasma pistol\\plasma pistol" },
                    [20] = { "prifle", "weap", "weapons\\plasma rifle\\plasma rifle" },
                    [21] = { "frg", "weap", "weapons\\plasma_cannon\\plasma_cannon" },
                    [22] = { "rocket", "weap", "weapons\\rocket launcher\\rocket launcher" },
                    [23] = { "shotgun", "weap", "weapons\\shotgun\\shotgun" },
                    [24] = { "sniper", "weap", "weapons\\sniper rifle\\sniper rifle" },

                    -- Projectiles
                    [25] = { "sheebolt", "proj", "vehicles\\banshee\\banshee bolt" },
                    [26] = { "sheerod", "proj", "vehicles\\banshee\\mp_banshee fuel rod" },
                    [27] = { "turretbolt", "proj", "vehicles\\c gun turret\\mp gun turret" },
                    [28] = { "ghostbolt", "proj", "vehicles\\ghost\\ghost bolt" },
                    [29] = { "tankbullet", "proj", "vehicles\\scorpion\\bullet" },
                    [30] = { "tankshell", "proj", "vehicles\\scorpion\\tank shell" },
                    [31] = { "hogbullet", "proj", "vehicles\\warthog\\bullet" },
                    [32] = { "riflebullet", "proj", "weapons\\assault rifle\\bullet" },
                    [33] = { "flame", "proj", "weapons\\flamethrower\\flame" },
                    [34] = { "needle", "proj", "weapons\\needler\\mp_needle" },
                    [35] = { "pistolbullet", "proj", "weapons\\pistol\\bullet" },
                    [36] = { "ppistolbolt", "proj", "weapons\\plasma pistol\\bolt" },
                    [37] = { "priflebolt", "proj", "weapons\\plasma rifle\\bolt" },
                    [38] = { "priflecbolt", "proj", "weapons\\plasma rifle\\charged bolt" },
                    [39] = { "rocketproj", "proj", "weapons\\rocket launcher\\rocket" },
                    [40] = { "shottyshot", "proj", "weapons\\shotgun\\pellet" },
                    [41] = { "snipershot", "proj", "weapons\\sniper rifle\\sniper bullet" },
                    [42] = { "fuelrodshot", "proj", "weapons\\plasma_cannon\\plasma_cannon" },

                    -- Custom Vehicles [ Bitch Slap ]
                    [43] = { "slap1", "vehi", "deathstar\\1\\vehicle\\tag_2830" }, -- Chain Gun Hog
                    [44] = { "slap2", "vehi", "deathstar\\1\\vehicle\\tag_3215" }, -- Quad Bike
                    [45] = { "wraith", "vehi", "vehicles\\wraith\\wraith" },
                    [46] = { "pelican", "vehi", "vehicles\\pelican\\pelican" },

                    -- Custom Weapons ...
                    [47] = { "bomb1", "weap", "weapons\\bomb\\bomb" }, -- camden_place
                }
            },
            -- # This is a spectator-like feature.
            ["Lurker"] = {
                enabled = true,
                dir = 'sapp\\lurker.tmp',
                base_command = "lurker", -- /command on|off [me | id | */all] <cmd_flag>
                cmd_flags = {"-c", "-h", "-ch"}, -- Command flag parameters.
                -- If '-c' (short for camouflage) command parameter is specified, you will only have camo!
                -- If '-h' (short for hidden) command parameter is specified, you will only be hidden!
                -- If '-ch' (short for camouflage + hidden) command parameter is specified, you will be both hidden and camouflaged!
                -- If neither are specified, the script will revert to default settings, i.e, 'hide', 'camouflage'
                -- If Player ID parameter ([me | id | */all]) is not specified, Lurker will default to the executor.                
                permission_level = -1,
                execute_on_others = 4,
                -- If this is true, the player will have invincibility (god mode):
                invincibility = true,
                -- If this is true, you will be hidden from all players.
                hide = true,
                -- If this is true, you will be camouflaged:
                camouflage = true,
                -- If this is true, Lurker will be auto-disabled (for all players) when the game ends, thus, players will not be in Lurker when the next game begins.
                -- They will have to turn it back on:
                auto_off = false,
                -- If this is enabled then Lurker will tell you if someone is in Lurker mode if you aim at them.
                screen_notifications = true,
                -- If this is true, your vehicle will disappear too!
                hide_vehicles = true,
                -- If this is true, you will be hidden from radar.
                hide_from_radar = true,
                -- If this is true, players in Lurker will not be able to inflict (or receive) damage.
                block_damage = true,
                -- If this is true, the player wlll have a speed boost:
                speed_boost = true,
                -- If this is true, you will have permanent shield:
                apply_shield = true,
                -- Shield amount applied:
                shield_amount = 100,
                -- Speed boost applied (default running speed is 1):
                running_speed = 2,
                -- Speed the player returns to when they exit out of Lurker Mode:
                default_running_speed = 1,
                -- Time (in seconds) until the player is killed after picking up the objective (flag or oddball)
                time_until_death = 9,

                -- You lose one warning point every time you pick up the objective (flag or oddball).
                -- If you have no warnings left, your Lurker privileges will be revoked (until the server is restarted)
                warnings = 4,

                -- =============== ENABLE | DISABLE Messages =============== --
                -- Let players know when someone goes into (or out of) Lurker mode:
                announce = true,
                -- (optional) -> Use "%name%" variable to output the joining players name.
                onEnableMsg = "%name% is now in Lurker Mode (Spectator) | STATE: [%mode%]",
                onDisabeMsg = "%name% is no longer in Lurker Mode (Spectator)",
                --==================================================================================================--

                -- =============== JOIN/QUIT SETTINGS =============== --
                -- Keep Lurker on quit? (When the player returns, they will still be in Lurker).
                keep = true,

                -- Remind the newly joined player that they are in Lurker? (requires 'keep' to be enabled) 
                join_tell = true,
                -- (optional) -> Use "%name%" variable to output the joining players name.
                join_msg = "%name%, You have joined in Lurker Mode (Spectator)",

                -- If this is true, the player will be informed of how many warnings remain.
                announce_warnings = true,
                join_warnings_left_msg = "Lurker Warnings left: %warnings%",

                -- Tell other players that PlayerX joined in Lurker? (requires 'keep' to be enabled) 
                join_tell_others = true,
                join_others_msg = "%name% joined in Lurker Mode (Spectator) | STATE: [%mode%]",

            },
            ["Welcome Messages"] = { -- Messages shown to the player on join.
                enabled = false,
                duration = 5, -- How long should the message(s) be displayed on screen for? (in seconds)
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                -- Use %server_name% variable to output the server name.
                -- Use %player_name% variable to output the joining player's name.
                messages = {
                    "Welcome to %server_name%",
                    -- repeat the structure to add more entries
                }
            },
            ["Mute System"] = {
                enabled = false,
                dir = "sapp\\mutes.txt",
                permission_level = 1,
                can_mute_admins = true,
                mute_command = "mute",
                unmute_command = "unmute",
                mutelist_command = "mutelist",
                default_mute_time = 525600,
            },
            -- # An alternative player list mod. Overrides SAPP's built in /pl command.
            ["Player List"] = {
                enabled = true,
                permission_level = 1,
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                command_aliases = {
                    "pl",
                    "players",
                    "playerlist",
                    "playerslist"
                }
            },
            ["Portal Gun"] = {
                enabled = true,
                base_command = "portalgun", -- /base_command [me | id | */all] [on|off|0|1|true|false)
                announcer = true, -- If this is enabled then all players will be alerted when someone goes into Portal Gun mode.
                permission_level = 1,
                execute_on_others = 4,
            },
            -- # Private Messaging System
            -- Send private messages to players both online and offline
            ["Private Messaging System"] = {
                enabled = true,
                dir = "sapp\\private_messages.txt",
                permission_level = -1,
                max_results_per_page = 5, -- max emails per page
                send_command = "pm", -- /send_command [recipient id (index or ip)] {message}
                read_command = "readmail", -- /read_command [page num]
                new_mail = "You have (%count%) private messages",
                delete_command = "delpm", -- /delete_command [message id | */all]
                send_response = "Message Sent",
                read_format = {
                    "%index%",
                    "Sender: %sender_name%",
                    "Date & Time: %time_stamp%",
                    "%msg%",
                },
                -- do not touch these unless you know what you're doing
                max_characters = 78, -- maximum characters in message
                seperator = "|",
            },
            -- Respawn yourself or others on demand (no death penalty incurred)
            ["Respawn On Demand"] = {
                enabled = true,
                permission_level = -1,
                execute_on_others = 4,
                base_command = "respawn",
            },
            ["Respawn Time"] = {
                enabled = false,
                permission_level = 1,
                execute_on_others = 4,
                base_command = "setrespawn",
                -- [ This enables you to set the default re-spawn time for all maps and game types. 
                -- When enabled, the custom respawn settings in the 'maps' table have no effect.
                global_respawn_time = {
                    enabled = true,
                    time = 3
                },
                -- ]
                maps = {
                    -- CTF, SLAYER, TEAM-S, KOTH, TEAM-KOTH, ODDBALL, TEAM-ODDBALL, RACE, TEAM-RACE
                    ["beavercreek"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bloodgulch"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["boardingaction"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["carousel"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["dangercanyon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["deathisland"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["gephyrophobia"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["icefields"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["infinity"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sidewinder"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["timberland"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["hangemhigh"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ratrace"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["damnation"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["putput"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["prisoner"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["wizard"] = { 0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["tactics"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["gruntground"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["lolcano"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["homestead"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["camden_place"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["olympus_mons"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["chaosgulchv2"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["enigma"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["extinction"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["coldsnap"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["mario64"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["dead-end"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["destinycanyon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["immure"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sneak"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["windfall_island"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["feelgoodinc"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["battlegulch_v2_chaos"] = { 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ragnarok"] = { 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["celebration_island"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["doom_wa_view"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["garden_ce"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sciophobiav2"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["portent"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["pitfall"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["quagmire"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["baz_canyon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bigass"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["pardis_perdu"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["insomnia_map"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["zanzibar_intense"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["deltaruined_intense"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["knot"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 0.5, 0.5 },
                    ["juggernaught"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["room_final"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["yoyorast island v2"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h3 foundry"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["cliffhanger"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["snowtorn_cove"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["remnants"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["temprate"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["pueblo_fantasma_beta"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["combat_arena"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h2_new_mombasa"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h2_zanzibar"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["lavaflows"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["runway-mod"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["medical block"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["[hsp]the-pit"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["abandonment"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ambush"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["armageddon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["augury"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bitch_slap"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["crimson_woods"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["fission_point"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h2 coagulation"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ministunt"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["no_remorse"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sledding02"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["train.station"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["destiny"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 }
                }
            },
            ["Suggestions Box"] = {
                -- Players can suggest features or maps using /suggest {message}. Suggestions are saved to suggestions.txt
                enabled = false,
                base_command = "suggestion", -- /base_command {message}
                permission_level = -1, -- Minimum privilege level required to execute /suggestion (-1 for all players, 1-4 for admins)
                dir = "sapp\\suggestions.txt", -- file directory
                msg_format = "[%time_stamp%] %player_name%: %message%", -- Message format saved to suggestions.txt
                response = "Thank you for your suggestion, %player_name%" -- Message sent to the player when they execute /suggestion
            },
            ["Teleport Manager"] = {
                enabled = true,
                dir = "sapp\\teleports.txt",
                execute_on_others = 4,
                permission_level = {
                    setwarp = 1,
                    warp = -1,
                    back = -1,
                    warplist = -1,
                    warplistall = -1,
                    delwarp = 1
                },
                commands = {
                    "setwarp", -- set command
                    "warp", -- go to command
                    "back", -- go back command
                    "warplist", --list command
                    "warplistall", -- list all command
                    "delwarp" -- delete command
                }
            },
        },
        global = {
            script_version = 1.68, -- << --- do not touch
            beepOnLoad = false,
            beepOnJoin = true,
            check_for_updates = false,
            server_prefix = "**SERVER** ",
            max_results_per_page = 10,
            special_commands = {
                velocity = { "velocity", -1 }, -- /velocity
                enable = { "enable", 1 }, -- /enable [id]
                disable = { "disable", 1 }, -- /disable [id]
                list = { "plugins", 1 }, -- /pluigns

                -- Clears the chat (useful if someone says something negative or derogatory).
                clearchat = { "clear", 1 }, -- /clear

                -- CUSTOM INFO COMMAND: /cmd [page id].
                -- Example: /lore 1, will show the server rules.
                information = {
                    cmd = "lore", -- /cmd [page id]
                    permission_level = -1,
                    data = {
                        [1] = { -- page 1
                            "[ SERVER RULES ]",
                            "1). No negative or derogatory behavior towards other players.",
                            "2). Swearing and vulgar remarks in excess will not be tolerated",
                            "and will result in a temporary or permanent ban (server ban or chat ban).",
                            "3). No cheating, hacking, glitching, etc.",
                            "4). No team stacking.",
                            "Server or admin balance/auto-balance will be done if necessary.",
                            "5). Any form of intentional team killing or disruptive play will not be allowed.",
                        },
                        [2] = { -- page 2
                            "[ SERVER INFORMATION ]",
                            "nothing to show",
                        },
                        [3] = { -- page 3
                            "[ STAFF ]",
                            "nothing to show",
                        },
                        [4] = { -- page 4 (repeat the structure to add more pages)
                            "[ MISC ]",
                            "nothing to show",
                        },
                    },
                },
            },
            -- [!] Do not Touch unless you know what you are doing!
            player_data = {
                "Player: %name%",
                "CD Hash: %hash%",
                "IP Address: %ip_address%",
                "Index ID: %index_id%",
                "Privilege Level: %level%",
                -- [!] - [!] - [!] - [!] - [!] - [!] - [!] - [!] --
            },
        }
    }
end
-- Configuration [ENDS] -----------------------------------------

-- Tables/variables used Globally
local velocity, player_info = { }, { }
local players
local server_ip = "000.000.000.000"
local globals = nil
local red_flag, blue_flag
local entervehicle = { }

local function InitPlayers()
    players = {
        ["Alias System"] = { },
        ["Welcome Messages"] = { },
        ["Admin Chat"] = { },
    }
end
-- String Library, Math Library, Table Library
local sub, gsub, find, upper, lower, format, match, gmatch = string.sub, string.gsub, string.find, string.upper, string.lower, string.format, string.match, string.gmatch
local floor = math.floor
local concat = table.concat

local function getip(p, bool)
    if (bool) then
        return get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+)")
    else
        return get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+:%d+)")
    end
end

-- Receives a string and executes SAPP function 'say_all' without the **SERVER** prefix.
-- Restores the prefix when relay is done.
local SayAll = function(Message)
    if (Message) then
        execute_command("msg_prefix \"\"")
        say_all(Message) -- Sends a global message.
        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
    end
end

-- Receives a string and Player ID (number) - executes SAPP function 'say' without the **SERVER** prefix.
-- Restores the prefix when done.
local Say = function(Player, Message)
    if (Player) and (Message) then
        execute_command("msg_prefix \"\"")
        say(Player, Message) -- Sends a private message to the target player.
        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
    end
end

local mapname = ""
local ce
local console_address_patch = nil
local game_over
local Lurker = { }

-- #Color Reservation
local colorres_bool = { }
local can_use_colorres

-- #Color Changer
local colorspawn = { }

-- #Auto Message
local autoMessage = { }
local auto_msg_startindex = 1
local auto_msg_init_timer
local auto_msg_countdown = 0

-- #Item Spawner
local temp_objects_table = { }

-- #Enter Vehicle
local ev = { }
local ev_Status = { }
local ev_NewVehicle, ev_OldVehicle = { }, { }

-- drones
local EV_drone_table, IS_drone_table, item_objects = { }, { }, { }

-- Mute Handler
local mute_table = { }

-- #Custom Weapons
local weapon = {}

-- #Infinity Ammo
local infammo = {}
local frag_check = {}
local modify_damage, damage_multiplier = { }, { }

-- #Portal Gun
local weapon_status, portalgun_mode = { }, { }

-- #Respawn Time
local respawn_cmd_override, respawn_time = { }, { }

-- #Teleport Manager
local canset = { }
local wait_for_response, previous_location = { }, { }
for i = 1, 16 do
    previous_location[i] = {}
end

-- #Private Messaging System
local privateMessage, unread_mail = { }, { }

-- #Give
local check_available_slots, give_weapon, delete_weapon = { }, { }, { }

-- #Block Object Pickups
local block_table = { }

-- This function returns the name of the server.
local function getServerName()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local sv_name = read_widestring(network_struct + 0x8, 0x42)
    return sv_name
end

-- Receives a number (PlayerIndex).
-- Executes SAPP commands: 'ammo', 'mag' and 'battery' for the target player.
local function adjust_ammo(p)
    for w = 1, 4 do
        -- Weapon slots 1 thru 4
        execute_command("ammo " .. tonumber(p) .. " 999 " .. w)
        execute_command("mag " .. tonumber(p) .. " 100 " .. w)
        execute_command("battery " .. tonumber(p) .. " 100 " .. w)
    end
end

-- This function returns the total number of players currently online.
local player_count = function()
    return tonumber(get_var(0, "$pn"))
end

-- Detremines what element indexes should be returned.
local getPage = function(params)
    local params = params or {}
    local table = params.table or nil
    local page = tonumber(params.page) or nil

    if (page == nil) then
        page = 1
    end

    local max_results = table.max_results_per_page
    local start = (max_results) * page
    local startpage = (start - max_results + 1)
    local endpage = start

    return startpage, endpage
end

-- Returns the total #pages.
local getPageCount = function(total, max_results)
    local pages = total / (max_results)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

-- Receives number (PlayerIndex) - disables infinity ammo for the Target Player.
local function DisableInfAmmo(TargetID)
    infammo[TargetID] = false
    frag_check[TargetID] = false
    modify_damage[TargetID] = false
    damage_multiplier[TargetID] = 0
end

-- Receives number (PlayerIndex) - Determines if the player is level 1 (at minimimum), or greater.
local function isAdmin(p)
    if (tonumber(get_var(p, "$lvl")) >= 1) then
        return true
    end
end

-- Checks if the command was executed by a player or console - Retuns true if the latter.
local function isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

-- Checks if the MOD being called is enabled in settings.
local function modEnabled(script, e)
    if (settings.mod[script].enabled) then
        return true
    elseif (e) then
        respond(e, "Command Failed. (Feature: '" .. script .. "' is disabled).", "rcon", 4 + 8)
    end
end

-- Returns the required permission level of the respective mod.
local function getPermLevel(script, bool, p)
    local p = p or nil
    if not (bool) and (p == nil) then
        return tonumber(settings.mod[script].permission_level)
    elseif (bool) and (p == nil) then
        return tonumber(settings.mod[script].execute_on_others)
    elseif not (bool) and (p ~= nil) then
        return tonumber(settings.mod[script].permission_level[p.cmd])
    end
end

-- Checks if the player can execute this command on others
local execute_on_others_error = { }
local function executeOnOthers(e, self, is_console, level, script)
    if not (self) and not (is_console) then
        local req_lvl = getPermLevel(script, true)
        if tonumber(level) >= req_lvl then
            return true
        elseif (execute_on_others_error[e]) then
            execute_on_others_error[e] = false
            respond(e, "You are not allowed to executed this command on other players.", "rcon", 4 + 8)
            respond(e, "You need to be level (" .. req_lvl .. ") at minimum. You are level (" .. level .. ")", "rcon", 4 + 8)
            return false
        end
    else
        -- Server should always be allowed to execute on others.
        return true
    end
end

-- Stores player information
local function populateInfoTable(p)
    player_info[p] = { }
    if (halo_type == "PC") then
        ce = 0x0
    else
        ce = 0x40
    end
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(p) * 0x20
    local name, hash = read_widestring(cns, 12), get_var(p, "$hash")
    local ip, id, level = get_var(p, "$ip"), get_var(p, "$n"), tonumber(get_var(p, "$lvl"))
    local a, b, c, d, e
    local tab = settings.global.player_data
    for i = 1, #tab do
        if tab[i]:match("%%name%%") then
            a = gsub(tab[i], "%%name%%", name)
        elseif tab[i]:match("%%hash%%") then
            b = gsub(tab[i], "%%hash%%", hash)
        elseif tab[i]:match("%%ip_address%%") then
            c = gsub(tab[i], "%%ip_address%%", ip)
        elseif tab[i]:match("%%index_id%%") then
            d = gsub(tab[i], "%%index_id%%", id)
        elseif tab[i]:match("%%level%%") then
            e = gsub(tab[i], "%%level%%", level)
        end
    end
    table.insert(player_info[p], { ["name"] = a, ["hash"] = b, ["ip"] = c, ["id"] = d, ["level"] = e })
end

local function getPlayerInfo(Player, ID)
    if player_present(Player) then
        if player_info[Player] ~= nil or player_info[Player] ~= {} then
            for key, _ in ipairs(player_info[Player]) do
                return player_info[Player][key][ID]
            end
        else
            return error('getPlayerInfo() -> Unable to get ' .. ID)
        end
    end
end

-- Receives two parameters: Number (PlayerIndex) & String (Message).
-- Loops through all players (i) and sends them a message (excludes PlayerIndex).
local function announceExclude(PlayerIndex, message)
    for i = 1, 16 do
        if (player_present(i) and i ~= PlayerIndex) then
            Say(i, message) -- SAPP function 'say'
        end
    end
end

-- Returns the desired spacing.
local function spacing(n, sep)
    sep = sep or ""
    local String, Seperator = "", ","
    for i = 1, n do
        if i == floor(n / 2) then
            String = String .. sep
        end
        String = String .. " "
    end
    return Seperator .. String
end

local function FormatTable(table, rowlen, space, delimiter)
    local longest = 0
    for _, v in ipairs(table) do
        local len = string.len(v)
        if (len > longest) then
            longest = len
        end
    end
    local rows = {}
    local row = 1
    local count = 1
    for k, v in ipairs(table) do
        if (count % rowlen == 0) or (k == #table) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - string.len(v) + space, delimiter)
        end
        if (count % rowlen == 0) then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

-- #Alias System ---------------------------------------------
local max_columns, max_results = 5, 100
local startIndex, endIndex = 1, max_columns
local spaces = 2
local alias, alias_results = { }, { }
local initialStartIndex, known_pirated_hashes
local function PreLoad()
    initialStartIndex = tonumber(startIndex)
    known_pirated_hashes = { }
    known_pirated_hashes = {
        "388e89e69b4cc08b3441f25959f74103",
        "81f9c914b3402c2702a12dc1405247ee",
        "c939c09426f69c4843ff75ae704bf426",
        "13dbf72b3c21c5235c47e405dd6e092d",
        "29a29f3659a221351ed3d6f8355b2200",
        "d72b3f33bfb7266a8d0f13b37c62fddb",
        "76b9b8db9ae6b6cacdd59770a18fc1d5",
        "55d368354b5021e7dd5d3d1525a4ab82",
        "d41d8cd98f00b204e9800998ecf8427e",
        "c702226e783ea7e091c0bb44c2d0ec64",
        "f443106bd82fd6f3c22ba2df7c5e4094",
        "10440b462f6cbc3160c6280c2734f184",
        "3d5cd27b3fa487b040043273fa00f51b",
        "b661a51d4ccf44f5da2869b0055563cb",
        "740da6bafb23c2fbdc5140b5d320edb1",
        "7503dad2a08026fc4b6cfb32a940cfe0",
        "4486253cba68da6786359e7ff2c7b467",
        "f1d7c0018e1648d7d48f257dc35e9660",
        "40da66d41e9c79172a84eef745739521",
        "2863ab7e0e7371f9a6b3f0440c06c560",
        "34146dc35d583f2b34693a83469fac2a",
        "b315d022891afedf2e6bc7e5aaf2d357",
        "63bf3d5a51b292cd0702135f6f566bd1",
        "6891d0a75336a75f9d03bb5e51a53095",
        "325a53c37324e4adb484d7a9c6741314",
        "0e3c41078d06f7f502e4bb5bd886772a",
        "fc65cda372eeb75fc1a2e7d19e91a86f",
        "f35309a653ae6243dab90c203fa50000",
        "50bbef5ebf4e0393016d129a545bd09d",
        "a77ee0be91bd38a0635b65991bc4b686",
        "3126fab3615a94119d5fe9eead1e88c1",
        "2f02b641060da979e2b89abcfa1af3d6", -- new (needs verifying)
    }
end
-- #Alias System
function alias:reset(ip)
    alias_results[ip] = { }
    players["Alias System"][ip] = {
        eid = 0,
        timer = 0,
        current_page = 0,
        total_pages = 0,
        total_aliases = 0,
        current_count = 0,
        total_count = 0,
        bool = false,
        trigger = false,
        shared = false,
    }
end

--------------------------------------------------------------
-- #Welcome Messages
local welcomeMessages = { }
local welcome_board = { }
local function set(Player, ip)
    welcome_board[ip] = { }
    local tab = settings.mod["Welcome Messages"].messages
    for i = 1, #tab do
        if (tab[i]) then
            table.insert(welcome_board[ip], tab[i])
        end
    end
    for j = 1, #welcome_board[ip] do
        welcome_board[ip][j] = gsub(gsub(welcome_board[ip][j], "%%server_name%%", getServerName()), "%%player_name%%", get_var(Player, "$name"))
    end
end

-- Trigger function for Welcome Messages feature.
function welcomeMessages:show(Player, ip)
    set(Player, ip)
    players["Welcome Messages"][ip] = {
        timer = 0,
        show = true,
    }
end

function welcomeMessages:hide(PlayerIndex, ip)
    players["Welcome Messages"][ip] = nil
    welcome_board[ip] = nil
    cls(PlayerIndex, 25)
end
--------------------------------------------------------------
-- #Admin Chat
local adminchat, achat_status = {}, { }
local achat_data = {}
function adminchat:set(ip)
    players["Admin Chat"][ip] = {
        adminchat = false,
        boolean = false,
    }
end
--------------------------------------------------------------
-- #Lurker
-- Return the number of warnings this player has remaining.
function getLurkerWarnings(ip)
    local mod = settings.mod["Lurker"]
    return ((Lurker[ip].warnings) or mod.warnings)
end

function reset()
    for i = 1, 16 do
        if player_present(i) then
            local ip = getip(i, true)
            local is_in_lurker = isInLurker(ip)
            local mod = settings.mod["Lurker"]            
            if ((Lurker[ip] ~= nil) or is_in_lurker) then
                Lurker[ip] = nil
                if (mod.speed_boost) then
                    execute_command("s " .. tonumber(i) .. " " .. tonumber(mod.default_running_speed))
                end
                if not (game_over) then
                    rprint(i, "SAPP Reloaded.")
                    rprint(i, "Your Lurker Mode has been deactivated.")
                end
                remove_data_log(i)
            end
        end
    end
end
--------------------------------------------------------------

function velocity:ShowCurrentVersion()
    if (settings.global.check_for_updates) then
        getCurrentVersion(true)
    else
        local script_version = format("%0.2f", settings.global.script_version)
        cprint("[VELOCITY] Current Version: " .. script_version, 2 + 8)
    end
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

function OnScriptLoad()
    InitPlayers() -- Creates an array of arrays (table wherein each element is another table)
    loadWeaponTags() -- preload weapon tag variables
    GameSettings()
    printEnabled() -- Loops through settings.mod -> prints mod name & status message (enabled or disabled)
    velocity:ShowCurrentVersion()
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")

    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")

    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")

    register_callback(cb['EVENT_DIE'], "OnPlayerKill")

    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")

    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")

    if (settings.global.beepOnLoad) then
        execute_command_sequence("beep 1200 200; beep 1200 200; beep 1200 200")
    end

    -- #Alias System
    if modEnabled("Alias System") then
        checkFile(settings.mod["Alias System"].dir)
        resetAliasParams()
        PreLoad()
    end

    -- #Private Messaging System
    if modEnabled("Private Messaging System") then
        checkFile(settings.mod["Private Messaging System"].dir)
    end

    -- Teleport Manager
    if modEnabled("Teleport Manager") then
        checkFile(settings.mod["Teleport Manager"].dir)
    end

    -- #Mute System
    if modEnabled("Mute System") then
        checkFile(settings.mod["Mute System"].dir)
    end

    -- #Suggestions Box
    if modEnabled("Suggestions Box") then
        checkFile(settings.mod["Suggestions Box"].dir)
    end

    -- #Chat Logging
    if modEnabled("Chat Logging") then
        checkFile(settings.mod["Chat Logging"].dir)
    end

    -- #Custom Weapons
    if modEnabled("Custom Weapons") then
        if not (game_over) then
            if get_var(0, "$gt") ~= "n/a" then
                mapname = get_var(0, "$map")
            end
        end
    end

    -- #Lurker
    if modEnabled("Lurker") then 
        checkFile(settings.mod["Lurker"].dir)
        if (tonumber(get_var(0, "$pn")) > 0) then
            reset()
        end
    end

    for i = 1, 16 do
        if player_present(i) then
            populateInfoTable(i)
            local ip = getip(i, true) -- returns ip (without port)
            local level = tonumber(get_var(i, "$lvl"))

            -- #Give
            if modEnabled("Give") then
                check_available_slots[i] = false
                give_weapon[i] = false
                delete_weapon[i] = false
            end

            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat", false) then
                    adminchat:set(ip)
                end
            end

            -- #Portal Gun
            if modEnabled("Portal Gun") then
                if portalgun_mode[ip] then
                    portalgun_mode[ip] = false
                    weapon_status[ip] = nil
                end
            end

            -- #Mute System
            if modEnabled("Mute System") then
                local p = { }
                p.tip = ip
                local muted = velocity:loadMute(p)
                if (muted ~= nil) and (p.tip == muted[1]) then
                    p.tn, p.time, p.tid = name, muted[3], tonumber(i)
                    velocity:saveMute(p, true, true)
                end
            end

            -- #Welcome Messages
            if modEnabled("Welcome Messages") then
                if (players["Welcome Messages"][ip] ~= nil) then
                    welcomeMessages:hide(i, ip)
                end
            end
        end
    end

    -- #Console Logo
    if modEnabled("Console Logo") then
        function consoleLogo()
            local tab = settings.mod["Console Logo"].logo
            if (#tab > 0) then
                local servername, date = getServerName(), os.date("%A, %d %B %Y - %X")
                for i = 1, #tab do
                    local str = tab[i][1] or ""
                    local color = tab[i][2] or 0
                    str = (gsub(gsub(str, "%%date_and_time%%", date), "%%server_name%%", servername))
                    cprint(str, color)
                end
            end
        end
        timer(50, "consoleLogo")
    end

    local rcon = sig_scan("B8????????E8??000000A1????????55")
    if (rcon ~= 0) then
        console_address_patch = read_dword(rcon + 1)
        safe_write(true)
        write_byte(console_address_patch, 0)
        safe_write(false)
    end

    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (gp == 3) then
        return
    end
    globals = read_dword(gp)

    -- Register Server Console to Table
    alias:reset(server_ip)

    if checkFile("sapp\\changelog.txt") then
        RecordChanges()
    end
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then
            local ip = getip(i, true)
            local level = tonumber(get_var(i, "$lvl"))
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat", false) then
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
                end
            end
            -- #Mute System
            if modEnabled("Mute System") then
                local name = get_var(i, "$name")
                if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                    local p = { }
                    p.tip, p.tn, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(i)
                    velocity:saveMute(p, false, true)
                end
            end
            -- #Give
            if modEnabled("Give") then
                check_available_slots[i] = false
                give_weapon[i] = false
                delete_weapon[i] = false
            end
        end
    end
    if console_address_patch ~= nil then
        safe_write(true)
        write_byte(console_address_patch, 0x72)
        safe_write(false)
    end
end

function OnGameStart()
    -- Used Globally
    game_over = false
    mapname = get_var(0, "$map")
    PreLoad()
    resetAliasParams()
    red_flag, blue_flag = read_dword(globals + 0x8), read_dword(globals + 0xC)
    for i = 1, 16 do
        if player_present(i) then
            local ip = getip(i, true)
            local level = tonumber(get_var(i, "$lvl"))

            -- #Welcome Messages
            if modEnabled("Welcome Messages") then
                if (players["Welcome Messages"][ip] ~= nil) then
                    welcomeMessages:hide(i, ip)
                end
            end

            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat", false) then
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
                end
            end
        end
    end

    -- #Chat Logging
    if modEnabled("Chat Logging") then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local map = get_var(0, "$map")
            local gt = get_var(0, "$mode")
            local n1 = "\n"
            local t1 = os.date("[%A %d %B %Y] - %X - A new game has started on " .. tostring(map) .. ", Mode: " .. tostring(gt))
            local n2 = "\n---------------------------------------------------------------------------------------------\n"
            file:write(n1, t1, n2)
            file:close()
        end
    end

    -- #Color Reservation
    if modEnabled("Color Reservation") then
        if (getTeamPlay()) then
            can_use_colorres = false
        else
            can_use_colorres = true
        end
    end

    -- #Auto Message
    if modEnabled("Auto Message") then
        auto_msg_startindex = 1
        auto_msg_init_timer = true
    end

    -- #Item Spawner
    if modEnabled("Item Spawner") then
        local objects_table = settings.mod["Item Spawner"].objects
        for i = 1, #objects_table do
            temp_objects_table[#temp_objects_table + 1] = objects_table[i][1]
        end
    end
end

function OnGameEnd()
    -- Prevents displaying chat ids when the game is over.
    -- Otherwise map voting breaks.
    game_over = true
    resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            local ip = getip(i, true)
            local level = tonumber(get_var(i, "$lvl"))

            -- #Custom Weapons
            if modEnabled("Custom Weapons") and (settings.mod["Custom Weapons"].assign_weapons) then
                weapon[i] = false
            end

            -- #Give
            if modEnabled("Give") then
                check_available_slots[i] = false
                give_weapon[i] = false
                delete_weapon[i] = false
            end

            -- #Mute System
            if modEnabled("Mute System") then
                local name = get_var(i, "$name")
                if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                    local p = { }
                    p.tip, p.tn, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(i)
                    velocity:saveMute(p, false, false)
                end
            end

            -- #Portal Gun
            if modEnabled("Portal Gun") then
                if portalgun_mode[ip] then
                    portalgun_mode[ip] = false
                    weapon_status[ip] = nil
                end
            end

            -- #Welcome Messages
            if modEnabled("Welcome Messages") then
                if (players["Welcome Messages"][ip] ~= nil) then
                    welcomeMessages:hide(i, ip)
                end
            end

            -- #Respawn Time
            if modEnabled("Respawn Time") then
                respawn_cmd_override[ip] = false
                respawn_time[ip] = 0
            end

            -- #Admin Chat
            if modEnabled("Admin Chat") then
                local mod = players["Admin Chat"][ip]
                if (mod ~= nil) then
                    local restore = settings.mod["Admin Chat"].restore
                    if (level) >= getPermLevel("Admin Chat", false) then
                        if (restore) then
                            local bool
                            if (mod.adminchat) then
                                bool = "true"
                            else
                                bool = "false"
                            end
                            achat_status[ip] = bool
                            achat_data[achat_status] = achat_data[achat_status] or {}
                            table.insert(achat_data[achat_status], tostring(achat_status[ip]))
                        else
                            mod.adminchat = false
                            mod.boolean = false
                        end
                    end
                end
            end

            -- #Lurker
            if modEnabled("Lurker") then 
                local mod = settings.mod["Lurker"]
                if (mod.auto_off) and (tonumber(get_var(0, "$pn")) > 0)then
                    reset()
                end
            end
        end
    end

    -- #Chat Logging
    if modEnabled("Chat Logging") then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local data = os.date("[%A %d %B %Y] - %X - The game is ending - ")
            file:write(data)
            file:close()
        end
    end

    -- #Auto Message
    if modEnabled("Auto Message") then
        auto_msg_init_timer = false
        auto_msg_countdown = 0
    end
    cprint("The Game Has Ended | Showing: POST GAME CARNAGE REPORT.", 4 + 8)
end

-- #Lurker:
local function hide_player(p, coords)
    local xOff, yOff, zOff = 1000, 1000, 1000
    write_float(get_player(p) + 0x100, coords.z - zOff)
    local mod = settings.mod["Lurker"]
    if (mod.hide_from_radar) then
        write_float(get_player(p) + 0xF8, coords.x - xOff)
        write_float(get_player(p) + 0xFC, coords.y - yOff)
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local ip = getip(i, true)
            local player = get_dynamic_player(i)
            local name = get_var(i, "$name")

            -- #Custom Weapons
            local wTab = settings.mod["Custom Weapons"]
            if modEnabled("Custom Weapons") and (wTab.assign_weapons) then
                if wTab.weapons[mapname] ~= nil then
                    if (player_alive(i)) then
                        if (weapon[i] == true) then
                            if (player ~= 0) then
                                local x, y, z = read_vector3d(player + 0x5C)
                                local primary, secondary, tertiary, quaternary, Slot = select(1, determineWeapon())

                                if (primary) or (secondary) or (tertiary) or (quaternary) then
                                    execute_command("wdel " .. i)
                                end

                                if (secondary) then
                                    assign_weapon(spawn_object("weap", secondary, x, y, z), i)
                                end

                                if (primary) then
                                    assign_weapon(spawn_object("weap", primary, x, y, z), i)
                                end

                                if (Slot == 3 or Slot == 4) then
                                    timer(100, "delayAssignMore", i, x, y, z)
                                end

                                function delayAssignMore(i, x, y, z)
                                    if (tertiary) then
                                        assign_weapon(spawn_object("weap", tertiary, x, y, z), i)
                                    end

                                    if (quaternary) then
                                        assign_weapon(spawn_object("weap", quaternary, x, y, z), i)
                                    end
                                end
                            end
                        end
                        weapon[i] = false
                    end
                end
            end

            -- #Give
            if modEnabled("Give") then
                if (check_available_slots[i]) then
                    check_available_slots[i] = false
                    if (player ~= 0) then
                        local weapon
                        for j = 0, 3 do
                            weapon = get_object_memory(read_dword(player + 0x2F8 + j * 4))
                            if (weapon ~= 0) then
                                if (j < 2) then
                                    give_weapon[i] = true
                                else
                                    delete_weapon[i] = true
                                    give_weapon[i] = true
                                end
                            end
                        end
                    end
                end
            end

            local vTab = entervehicle[i]
            if (player_alive(i) and vTab ~= nil and vTab.enter) then
                local vehicle, seat = vTab.vehicle, vTab.seat
                enter_vehicle(vehicle, i, seat)
                entervehicle[i] = nil
            end

            -- #Color Changer
            if modEnabled("Color Changer") then
                if (player ~= 0) and (colorspawn[ip] ~= nil) and (vTab ~= nil) and not (vTab.enter) then
                    write_vector3d(player + 0x5C, colorspawn[ip][1], colorspawn[ip][2], colorspawn[ip][3])
                    colorspawn[ip] = nil
                end
            end

            -- #Infinity Ammo
            if modEnabled("Infinity Ammo") and infammo[i] then
                if (frag_check[i] == true) and getFrags(i) == true then
                    execute_command("nades " .. tonumber(i) .. " 7")
                end
            end

            -- #Lurker
            if modEnabled("Lurker") then
                local mod = settings.mod["Lurker"]
                
                local status = Lurker[ip]
                if (status ~= nil) and (status.enabled) then

                    if (mod.screen_notifications) then
                    
                        local proceed
                        if (status.mode == "default" and not mod.hide) or (status.mode == "camouflaged") then
                            proceed = true
                        end
                    
                        if (proceed) then
                            for j = 1, 16 do
                                if (i ~= j) then
                                    if (player_alive(i)) and (player_alive(j)) then
                                        local P1Object, P2Object = get_dynamic_player(i), get_dynamic_player(j)
                                        if (P1Object ~= 0) and (P2Object ~= 0) then
                                            local camX, camY, camZ = read_float(P1Object + 0x230), read_float(P1Object + 0x234), read_float(P1Object + 0x238)
                                            local couching = read_float(P1Object + 0x50C)
                                            local px, py, pz = read_vector3d(P1Object + 0x5c)
                                            if (couching == 0) then
                                                pz = pz + 0.65
                                            else
                                                pz = pz + (0.35 * couching)
                                            end
                                            local player_1 = read_dword(get_player(i) + 0x34)
                                            local success, _, _, _, Object = intersect(px, py, pz, camX * 1000, camY * 1000, camZ * 1000, player_1)
                                            local player_2 = Object and read_dword(get_player(j) + 0x34)
                                            if (success == true and Object ~= nil) then
                                                local lurker_p2 = Lurker[getip(j, true)]
                                                if (Object == player_2 and lurker_p2 ~= nil and lurker_p2.enabled) then
                                                    cls(i, 25)
                                                    respond(i, "|c" .. get_var(j, "$name") .. " is in Lurker Mode (Spectator)", "rcon")
                                                    for _ = 1, 5 do
                                                        rprint(i, " ")
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end


                    -- HIDE PLAYER
                    if (mod.hide) and (status.mode == "hidden" or status.mode == "camouflaged_and_hidden" or status.mode == "default") then
                        local coords = getXYZ(0, i)
                        if (coords) then
                            if ((coords.invehicle and mod.hide_vehicles) or not coords.invehicle) then
                                hide_player(i, coords)
                            end
                        end
                    end

                    -- APPLY CAMO
                    if (mod.camouflage) and (status.mode == "camouflaged" or status.mode == "camouflaged_and_hidden" or status.mode == "default") then
                        execute_command("camo " .. i .. " 1")
                    end
                    
                    -- APPLY OVERSHIELD
                    if (mod.apply_shield) then
                        execute_command("sh " .. tonumber(i) .. " " .. tonumber(mod.shield_amount))
                    end

                    -- APPLY SPEED
                    if not (status.warn) and (mod.speed_boost) then
                        execute_command("s " .. tonumber(i) .. " " .. tonumber(mod.running_speed))
                    
                    -- WARN PLAYER
                    elseif (status.warn) then
                        status.timer = status.timer + 0.030
                        cls(i, 25)
                        local days, hours, minutes, seconds = secondsToTime(status.timer, 4)
                        rprint(i, "|cWarning! Drop the " .. status.objective)
                        local char = getChar(mod.time_until_death - floor(seconds))
                        rprint(i, "|cYou will be killed in " .. mod.time_until_death - floor(seconds) .. " second" .. char)
                        rprint(i, "|c[ warnings left ] ")
                        rprint(i, "|c" .. status.warnings)
                        rprint(i, "|c ")
                        rprint(i, "|c ")
                        rprint(i, "|c ")

                        -- Check player warnings
                        if (getLurkerWarnings(ip) <= 0) then
                            status.warn, status.enabled = false, false
                            execute_command("s " .. tonumber(i) .. " " .. tonumber(mod.default_running_speed ))
                            killSilently(i) -- KILL PLAYER
                            rprint(i, "Your Lurker mode was auto-revoked! [no warnings left]")
                            if (mod.announce) then
                                announceExclude(i, get_var(i, "$name") .. "'s Lurker (spectator) privileges have been auto-revoked.")
                            end
                        end

                        if (status.timer >= mod.time_until_death) then
                            status.warn, status.teleport, status.timer = false, false, 0
                            killSilently(i)
                            cls(i, 25)
                            rprint(i, "|c=========================================================")
                            rprint(i, "|cYou were killed!")
                            rprint(i, "|c=========================================================")
                            rprint(i, "|c ")
                            rprint(i, "|c ")
                            rprint(i, "|c ")
                            rprint(i, "|c ")
                            status.object = "" -- just in case
                        end
                    end
                    
                    local score = tonumber(get_var(i, "$score"))
                    if (score < 0) then
                        execute_command("score " .. tonumber(i) .. " " .. status.score)
                    end
                end
            end


            -- #Portal Gun
            if modEnabled("Portal Gun") then
                if player_alive(i) and (portalgun_mode[ip] == true) then
                    if (player ~= 0) then
                        local shot_fired, is_crouching
                        local couching = read_float(player + 0x50C)
                        if (couching == 0) then
                            is_crouching = false
                        else
                            is_crouching = true
                        end
                        shot_fired = read_float(player + 0x490)
                        if (shot_fired ~= weapon_status[ip] and shot_fired == 1 and is_crouching) then
                            execute_command("boost " .. i)
                        end
                        weapon_status[ip] = shot_fired
                    end
                end
            end

            -- #Alias System
            if modEnabled("Alias System") then
                if (players["Alias System"][ip] and players["Alias System"][ip].trigger) then
                    players["Alias System"][ip].timer = players["Alias System"][ip].timer + 0.030
                    alias:show(players["Alias System"][ip])
                    if players["Alias System"][ip].timer >= floor(settings.mod["Alias System"].duration) then
                        alias:reset(ip)
                    end
                end
            end

            -- #Welcome Messages
            if modEnabled("Welcome Messages") then
                if players["Welcome Messages"][ip] and (players["Welcome Messages"][ip].show) then
                    players["Welcome Messages"][ip].timer = players["Welcome Messages"][ip].timer + 0.030
                    cls(i, 25)
                    for j = 1, #welcome_board[ip] do
                        respond(i, "|" .. settings.mod["Welcome Messages"].alignment .. " " .. welcome_board[ip][j], "rcon")
                    end
                    if players["Welcome Messages"][ip].timer >= math.floor(settings.mod["Welcome Messages"].duration) then
                        welcomeMessages:hide(i, ip)
                    end
                end
            end

            -- #Enter Vehicle
            if modEnabled("Enter Vehicle") and (ev_Status[i]) then
                if not PlayerInVehicle(i) then
                    enter_vehicle(ev_NewVehicle[i], i, 0)
                    local old_vehicle = get_object_memory(ev_OldVehicle[i])
                    write_vector3d(old_vehicle + 0x5C, 0, 0, 0)
                    timer(500, "DestroyObject", ev_OldVehicle[i])
                    ev_Status[i] = false
                end
            end

            -- #Mute System
            if modEnabled("Mute System") then
                if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                    mute_table[ip].timer = mute_table[ip].timer + 0.030
                    local days, hours, minutes, seconds = secondsToTime(mute_table[ip].timer, 4)
                    local duration = tonumber(mute_table[ip].duration)
                    mute_table[ip].remaining = (duration) - floor(minutes)
                    if (mute_table[ip].remaining <= 0) then
                        local p = { }
                        p.tip, p.tn, p.tid = ip, name, tonumber(i)
                        velocity:unmute(p)
                    end
                end
            end
        end
    end
    -- Auto Message
    if modEnabled("Auto Message") and (auto_msg_init_timer) then
        timeUntilNext()
    end
end

-- Auto Message
function timeUntilNext()
    local tab = settings.mod["Auto Message"]
    auto_msg_countdown = auto_msg_countdown + 0.030
    if (auto_msg_countdown >= (tab.time_between_messages)) then
        auto_msg_countdown = 0
        autoMessage:broadcast()
    end
end

-- Auto Message
function autoMessage:broadcast()
    local announcements = settings.mod["Auto Message"].announcements

    if (auto_msg_startindex == #announcements + 1) then
        auto_msg_startindex = 1
    end

    for i = 1, #announcements[auto_msg_startindex] do
        if (announcements[auto_msg_startindex][i] ~= nil) then
            local msg = announcements[auto_msg_startindex][i]
            SayAll(msg)
            cprint(msg)
        end
    end

    auto_msg_startindex = auto_msg_startindex + 1
end

function determineWeapon()
    local primary, secondary, tertiary, quaternary, Slot
    local tab = settings.mod["Custom Weapons"]
    for i = 1, 4 do
        local weapon = tab.weapons[mapname][i]
        if (weapon ~= nil) then
            if (i == 1 and tab.weapons[mapname][i] ~= nil) then
                primary = tab.weapons[mapname][i]
                Slot = i
            end
            if (i == 2 and tab.weapons[mapname][i] ~= nil) then
                secondary = tab.weapons[mapname][i]
                Slot = i
            end
            if (i == 3 and tab.weapons[mapname][i] ~= nil) then
                tertiary = tab.weapons[mapname][i]
                Slot = i
            end
            if (i == 4 and tab.weapons[mapname][i] ~= nil) then
                quaternary = tab.weapons[mapname][i]
                Slot = i
            end
        end
    end
    return primary, secondary, tertiary, quaternary, Slot
end

-- #Anti Impersonator
local function takeAction(tab, id, name)
    local action, reason, bantime = tab.action, tab.reason, tab.bantime
    if (action == "kick") then
        execute_command("k" .. " " .. id .. " \"" .. reason .. "\"")
        cprint(name .. " was kicked for " .. reason, 4 + 8)
    elseif (action == "ban") then
        execute_command("b" .. " " .. id .. " " .. bantime .. " \"" .. reason .. "\"")
        cprint(name .. " was banned for " .. bantime .. " minutes for " .. reason, 4 + 8)
    else
        error("Action not properly defined. Valid Actions: 'kick' or 'ban'")
    end
end

function OnPlayerPrejoin(PlayerIndex)
    cprint("________________________________________________________________________________", 2 + 8)
    cprint("Player attempting to connect to the server...", 5 + 8)
    populateInfoTable(PlayerIndex)
    cprint(getPlayerInfo(PlayerIndex, "name"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "hash"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "ip"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "id"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "level"), 2 + 8)
    if (settings.global.beepOnJoin == true) then
        os.execute("echo \7")
    end
end

function OnPlayerConnect(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = tonumber(get_var(PlayerIndex, "$n"))
    local ip = getip(PlayerIndex, true)
    local level = getPlayerInfo(PlayerIndex, "level"):match("%d+")

    -- Forces me (Chalwk) to welcome the new player (because reasons).
    -- Disabled because reasons also.

    --[[
    for i = 1,16 do
        if player_present(i) then 
            local o_name = get_var(i, "$name") 
            if (name ~= "Chalwk") and (o_name == "Chalwk") then
                local o_index = tonumber(i)
                local chatFormat = settings.mod["Chat IDs"].global_format[1]
                local welcome_msg = "Welcome back, " .. name
                local formattedString = (gsub(gsub(gsub(chatFormat, "%%sender_name%%", "Chalwk"), "%%index%%", o_index), "%%message%%", welcome_msg))
                SayAll(formattedString)
            end
        end
    end
    ]]

    -- #CONSOLE OUTPUT
    if (player_info[id] ~= nil or player_info[id] ~= {}) then
        cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 2 + 8)
        cprint("Status: " .. name .. " connected successfully.", 5 + 8)
        cprint("________________________________________________________________________________", 2 + 8)
    end

    -- #Mute System
    if modEnabled("Mute System") then
        local p = { }
        p.tip = ip
        local muted = velocity:loadMute(p)
        if (muted ~= nil) and (ip == muted[1]) then
            p.tn, p.time, p.tid = name, muted[3], id
            velocity:saveMute(p, true, true)
        end
    end

    -- #Give
    if modEnabled("Give") then
        check_available_slots[id] = false
        give_weapon[id] = false
        delete_weapon[id] = false
    end

    -- #Block Object Pickups
    if modEnabled("Block Object Pickups") then
        if (block_table[ip]) then
            execute_command("block_all_objects " .. PlayerIndex .. " 1")
        end
    end

    -- #Private Messaging System
    if modEnabled("Private Messaging System") then
        local count = 0
        unread_mail[ip] = { }
        local tab = settings.mod["Private Messaging System"]
        local lines = lines_from(tab.dir)
        for _, v in pairs(lines) do
            if (v:match(ip)) then
                unread_mail[ip][#unread_mail[ip] + 1] = v:match(":(.+)")
                count = count + 1
            end
        end

        if (count > 0) then
            local str = gsub(tab.new_mail, "%%count%%", count)
            respond(id, str, "rcon", 2 + 8)
        end
    end

    -- #Respawn Time
    if modEnabled("Respawn Time") then
        respawn_cmd_override[ip] = false
        respawn_time[ip] = 0
    end

    -- #Lurker
    if modEnabled("Lurker") then
        if (tonumber(level) >= getPermLevel("Lurker", false)) then
            Lurker[ip] = Lurker[ip] or nil
            local status = Lurker[ip]
            local score = get_var(id, "$score")
            local mod = settings.mod["Lurker"]
            
            local function tell(id, bool)
                if (bool) then
                    Lurker[ip] = { } -- Initialize an array for this player.
                    status = Lurker[ip]
                    
                    -- ENABLE LURKER
                    status.enabled = true
                    status.warnings = status.warnings or mod.warnings
                end
                
                -- JOIN MESSAGES:
                if (mod.join_tell) then
                    local join_message_1 = gsub(mod.join_msg, "%%name%%", name)
                    respond(id, join_message_1, "rcon", 2 + 8)
                    if (mod.announce_warnings) then
                        local join_message_2 = gsub(mod.join_warnings_left_msg, "%%warnings%%", status.warnings)
                        respond(id, join_message_2, "rcon", 2+8)
                    end
                end

                if (mod.join_tell_others) then
                    local mode = "UNKNOWN"
                    if (mod.hide and mod.camouflage) then
                        mode = "C/H"
                    elseif (mod.hide and not mod.camouflage) then
                        mode = "H"
                    elseif (mod.camouflage and not mod.hide) then
                        mode = "C"
                    end
                    local msg = gsub(gsub(mod.join_others_msg, "%%name%%", name), "%%mode%%", mode)
                    announceExclude(id, msg, "rcon", 2 + 8)
                end
            end
            
            local is_in_lurker = isInLurker(ip)
            if (status ~= nil and status.enabled) then -- no need to declare `Lurker[ip].enable`
                tell(id)
            elseif (status == nil) and (is_in_lurker) then -- must declare `Lurker[ip] = {}` and `Lurker[ip].enable`
                tell(id, true)
            elseif (status == nil) and not (is_in_lurker) then
                Lurker[ip] = { } -- Initialize an array for this player.
                status = Lurker[ip]
            end
            
            status.teleport, status.warn, status.timer, status.score, status.warnings, status.mode = false, false, 0, score, getLurkerWarnings(ip), "default"
        end
    end

    -- #Infinity Ammo
    if modEnabled("Infinity Ammo") then
        damage_multiplier[id] = 0
        if not (settings.mod["Infinity Ammo"].server_override) then
            infammo[id] = false
            modify_damage[id] = false
            damage_multiplier[id] = 0
        else
            infammo[id] = true
        end
    end

    -- #Alias System
    if modEnabled("Alias System") then
        alias:add(name, hash)
        if (tonumber(level) >= getPermLevel("Alias System", false)) then
            alias:reset(ip)
        end
        --[[
        
        -- Remove from comment block if you want to use this.
        
        if (known_pirated_hashes ~= nil) then
            for i = 1, #known_pirated_hashes do
                if (hash == known_pirated_hashes[i]) then
                    -- No need to create a new loop for players because the #known_pirated_hashes is greater than 16 anyway.
                    if player_present(i) and isAdmin(i) then
                        say(i, name .. " is using a pirated copy of Halo.")
                    end
                end
            end
        end
        ]]
    end

    -- #Welcome Messages
    if modEnabled("Welcome Messages") then
        welcomeMessages:show(id, ip)
    end

    -- #Admin Chat
    if modEnabled("Admin Chat") then
        local restore = settings.mod["Admin Chat"].restore
        if (tonumber(level) >= getPermLevel("Admin Chat", false)) then
            adminchat:set(ip)
            local mod = players["Admin Chat"][ip]
            if (mod ~= nil) then
                if (restore) then
                    local args = stringSplit(tostring(achat_status[ip]), "|")
                    if (args[2] ~= nil) then
                        if (args[2] == "true") then
                            respond(id, "[reminder] Your admin chat is on!", "rcon")
                            mod.adminchat = true
                            mod.boolean = true
                        else
                            mod.adminchat = false
                            mod.boolean = false
                        end
                    end
                else
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
                end
            end
        end
    end

    -- #Chat Logging
    if modEnabled("Chat Logging") then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local ip = getip(id, false) -- include port
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [JOIN]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Admin Join Messages
    if modEnabled("Admin Join Messages") then
        local level = tonumber(get_var(id, "$lvl"))
        if (level >= 1) then
            local tab, join_message = settings.mod["Admin Join Messages"].messages
            join_message = tab[level][1] .. name .. tab[level][2]
            local function announceJoin(join_message)
                for i = 1, 16 do
                    if player_present(i) then
                        rprint(i, join_message)
                    end
                end
            end
            announceJoin(join_message)
        end
    end

    -- #Anti Impersonator
    if modEnabled("Anti Impersonator") then
        local tab = settings.mod["Anti Impersonator"]
        local found
        for key, _ in ipairs(tab.users) do
            local userdata = tab.users[key][name]
            if (userdata ~= nil) then
                for i = 1, #userdata do
                    if (userdata[i] == hash) or (userdata[i] == ip) then
                        found = true
                        break
                    end
                end
                if not (found) then
                    takeAction(tab, id, name)
                    break
                end
            end
        end
    end

    -- #Item Spawner
    if modEnabled("Item Spawner") then
        IS_drone_table[id] = nil
    end

    -- #Enter Vehicle
    if modEnabled("Enter Vehicle") then
        ev[id] = false
        ev_Status[id] = false
        EV_drone_table[id] = nil
    end

    -- #Color Reservation
    if modEnabled("Color Reservation") then
        if (can_use_colorres == true) then
            local ColorTable = settings.mod["Color Reservation"].color_table
            local player = getPlayer(id)
            local found
            for k, _ in ipairs(ColorTable) do
                for i = 1, #ColorTable do
                    local val = ColorTable[k][i]
                    if (val) then
                        if find(val, hash) then
                            k = k - 1
                            write_byte(player + 0x60, tonumber(k))
                            colorres_bool[id] = true
                            found = true
                            break
                        end
                        if not (found) then
                            if (val ~= "available") then
                                if (read_byte(getPlayer(id) + 0x60) == k - 1) then
                                    local function selectRandomColor(exclude)
                                        local num = rand(1, 18)
                                        if (num == exclude) then
                                            selectRandomColor(tonumber(k))
                                        else
                                            return num
                                        end
                                    end
                                    local colorID = selectRandomColor(tonumber(k))
                                    if colorID then
                                        write_byte(player + 0x60, colorID)
                                        colorres_bool[id] = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerDisconnect(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = tonumber(get_var(PlayerIndex, "$n"))
    local level = getPlayerInfo(PlayerIndex, "level"):match("%d+")

    local function GetIP(id)
        local ip_address
        if (halo_type == "PC") then
            ip_address = getPlayerInfo(id, "ip"):match("(%d+.%d+.%d+.%d+)")
        else
            ip_address = getip(id, true)
        end
        return ip_address
    end

    local ip = GetIP(id)

    -- #CONSOLE OUTPUT
    cprint("________________________________________________________________________________", 4 + 8)
    if (player_info[id] ~= nil or player_info[id] ~= {}) then
        cprint(getPlayerInfo(id, "name"), 4 + 8)
        cprint(getPlayerInfo(id, "hash"), 4 + 8)
        cprint(getPlayerInfo(id, "ip"), 4 + 8)
        cprint(getPlayerInfo(id, "id"), 4 + 8)
        cprint(getPlayerInfo(id, "level"), 4 + 8)
    end
    cprint("________________________________________________________________________________", 4 + 8)

    -- #Mute System
    if modEnabled("Mute System") then
        if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
            local p = { }
            p.tip, p.tn, p.time, p.tid = ip, name, mute_table[ip].remaining, id
            velocity:saveMute(p, true, true)
        end
    end

    -- #Give
    if modEnabled("Give") then
        check_available_slots[id] = false
        give_weapon[id] = false
        delete_weapon[id] = false
    end

    -- #Block Object Pickups
    if modEnabled("Block Object Pickups") then
        local mod = settings.mod["Block Object Pickups"]
        if (block_table[ip]) and (mod.enable_on_disconnect) then
            block_table[ip] = false
            execute_command("block_all_objects " .. id .. " 0")
        end
    end

    -- #Portal Gun
    if modEnabled("Portal Gun") then
        if (portalgun_mode[ip] == true) then
            portalgun_mode[ip] = false
            weapon_status[ip] = nil
        end
    end

    -- #Respawn Time
    if (respawn_time[ip] ~= nil) then
        respawn_time[ip] = nil
    end

    -- #Alias System
    if modEnabled("Alias System") then
        if (tonumber(level) >= getPermLevel("Alias System", false)) then
            if (players["Alias System"][ip] ~= nil) then
                alias:reset(ip)
            end
        end
    end

    -- #Welcome Messages
    if modEnabled("Welcome Messages") then
        welcomeMessages:hide(id, ip)
    end

    -- #Teleport Manager
    if modEnabled("Teleport Manager") then
        wait_for_response[id] = false
        for i = 1, 3 do
            previous_location[id][i] = nil
        end
    end

    -- #Admin Chat
    if modEnabled("Admin Chat") then
        local restore = settings.mod["Admin Chat"].restore
        local mod = players["Admin Chat"][ip]
        if (mod ~= nil) then
            if tonumber(level) >= getPermLevel("Admin Chat", false) then
                if (restore) and (mod ~= nil) then
                    local bool
                    if (mod.adminchat) then
                        bool = "true"
                    else
                        bool = "false"
                    end
                    achat_status[ip] = bool
                    achat_data[achat_status] = achat_data[achat_status] or {}
                    table.insert(achat_data[achat_status], tostring(achat_status[ip]))
                else
                    mod.adminchat = false -- attempt to index local 'mod' (a nil value) - when script is reloaded
                    mod.boolean = false
                end
            end
        end
    end

    -- #Lurker
    if modEnabled("Lurker") then
        local mod = settings.mod["Lurker"]
        local status = Lurker[ip]
        if (status ~= nil) then
            if not (status.enabled) or not (mod.keep) then
                remove_data_log(id)
            end
        end
    end
    
    -- #Infinity Ammo
    if (modEnabled("Lurker") and infammo[id]) then
        DisableInfAmmo(id)
    end

    -- #Chat Logging
    if modEnabled("Admin Chat") then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [QUIT]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Enter Vehicle & Item Spawner
    if modEnabled("Enter Vehicle") or modEnabled("Item Spawner") then
        local tab = settings.mod["Enter Vehicle"]
        if (tab.garbage_collection.on_disconnect) then
            if ev_NewVehicle[id] ~= nil then
                ev[id] = false
                ev_Status[id] = false
            end
            CleanUpDrones(id, 1)
        end
        local tab = settings.mod["Item Spawner"]
        if (tab.garbage_collection.on_disconnect) then
            CleanUpDrones(id, 2)
        end
    end
    -- Clean up player_info table for id:
    player_info[id] = nil
end

local function Teleport(TargetID, x, y, z, height)
    local player_object = get_dynamic_player(TargetID)
    if (player_object ~= 0) then
        write_vector3d(player_object + 0x5C, x, y, z + height)
    end
end

function OnPlayerPrespawn(PlayerIndex)
    -- #Lurker
    -- if modEnabled("Lurker") then
        -- local ip = getip(PlayerIndex, true)
        -- local status = Lurker[ip]
        -- if (status ~= nil) and (status.teleport ~= nil) and (status.teleport) then
            -- status.teleport = false
            -- local XYZ = status.spawn_coords
            -- local x, y, z, height = XYZ[1], XYZ[2], XYZ[3], XYZ[4]
            -- Teleport(PlayerIndex, x, y, z, height)
        -- end
    -- end
end

function OnPlayerSpawn(PlayerIndex)
    -- #Custom Weapons
    local ip = getip(PlayerIndex, true)
    if modEnabled("Custom Weapons") then
        local Wtab = settings.mod["Custom Weapons"]
        if player_alive(PlayerIndex) then
            if (Wtab.weapons[mapname] ~= nil) then
                if (Wtab.weapons[mapname][7]) then
                    weapon[PlayerIndex] = true
                    local player_object = get_dynamic_player(PlayerIndex)
                    if (player_object ~= 0) then
                        if (Wtab.assign_custom_frags == true) then
                            local frags = Wtab.weapons[mapname][5]
                            if (frags ~= 00) then
                                write_word(player_object + 0x31E, tonumber(frags))
                            end
                        end
                        if (Wtab.assign_custom_plasmas == true) then
                            local plasmas = Wtab.weapons[mapname][6]
                            if (plasmas ~= 00) then
                                write_word(player_object + 0x31F, tonumber(plasmas))
                            end
                        end
                    end
                end
            end
        end
    end
    -- #Color Reservation
    if modEnabled("Color Reservation") then
        if (can_use_colorres == true) then
            if (colorres_bool[PlayerIndex]) then
                colorres_bool[PlayerIndex] = false
                local player_object = read_dword(get_player(PlayerIndex) + 0x34)
                DestroyObject(player_object)
            end
        end
    end
    -- #Portal Gun
    if modEnabled("Portal Gun") then
        weapon_status[ip] = 0
    end

    -- #Infinity Ammo
    if (modEnabled("Infinity Ammo") and infammo[PlayerIndex]) then
        frag_check[PlayerIndex] = true
        adjust_ammo(PlayerIndex)
    end
    
    -- #Lurker
    if modEnabled("Lurker") then
        local mod = settings.mod["Lurker"]
        local status = Lurker[ip]
        if (status ~= nil) and (status.enabled) and (mod.invincibility) then
            execute_command("god " .. PlayerIndex)
        end
    end
end

function OnPlayerKill(PlayerIndex)
    local ip = getip(PlayerIndex, true)
    local level = tonumber(get_var(PlayerIndex, "$lvl"))

    -- #Respawn Time
    if modEnabled("Respawn Time") then
        local player = get_player(PlayerIndex)
        if not (respawn_cmd_override[ip]) then
            local mod = settings.mod["Respawn Time"]
            local function getSpawnTime()
                local spawntime
                if (get_var(1, "$gt") == "ctf") then
                    spawntime = mod.maps[mapname][1]
                elseif (get_var(1, "$gt") == "slayer") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][2]
                    else
                        spawntime = mod.maps[mapname][3]
                    end
                elseif (get_var(1, "$gt") == "koth") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][4]
                    else
                        spawntime = mod.maps[mapname][5]
                    end
                elseif (get_var(1, "$gt") == "oddball") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][6]
                    else
                        spawntime = mod.maps[mapname][7]
                    end
                elseif (get_var(1, "$gt") == "race") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][8]
                    else
                        spawntime = mod.maps[mapname][9]
                    end
                end
                return spawntime
            end
            if not mod.global_respawn_time.enabled then
                if (mod.maps[mapname] ~= nil) then
                    write_dword(player + 0x2C, tonumber(getSpawnTime()) * 33)
                end
            else
                local time = mod.global_respawn_time.time
                write_dword(player + 0x2C, time * 33)
            end
        else
            write_dword(player + 0x2C, respawn_time[ip] * 33)
        end
    end
    
    -- #Lurker
    if modEnabled("Lurker") then
        local status = Lurker[ip]
        if (status ~= nil) and (status.enabled) then
            status.scores, status.timer, status.warn, status.has_objective = 0,0, false, false
        end
    end

    -- #Enter Vehicle & Item Spawner
    if modEnabled("Enter Vehicle") or modEnabled("Item Spawner") then
        if (settings.mod["Enter Vehicle"].garbage_collection.on_death) then
            CleanUpDrones(PlayerIndex, 1)
        end
        if (settings.mod["Item Spawner"].garbage_collection.on_death) then
            CleanUpDrones(PlayerIndex, 2)
        end
    end

    -- #Infinity Ammo
    if (modEnabled("Infinity Ammo") and infammo[PlayerIndex]) then
        frag_check[PlayerIndex] = false
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local id = tonumber(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local ip = getip(PlayerIndex, true)
    local response

    local level = function(p)
        return tonumber(get_var(p, "$lvl"))
    end

    -- #Mute System
    if modEnabled("Mute System") then
        if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
            cprint('[MUTED] ' .. name .. ": " .. Message)
            if (mute_table[ip].duration == default_mute_time) then
                rprint(PlayerIndex, "[muted] You are muted permanently.")
            else
                local char = getChar(mute_table[ip].duration)
                rprint(PlayerIndex, "[muted] Time remaining: " .. mute_table[ip].duration .. " minute" .. char)
            end
            return false
        end
    end

    -- Used throughout OnPlayerChat()
    local message = stringSplit(Message)
    if (#message == 0) then
        return false
    end
    
    -- #Chat Censor
    if modEnabled("Chat Censor") then
        local tab = settings.mod["Chat Censor"]
        local table = tab.words
        local function checkForChar(word)
            local chars = { -- wip
                "^",
                "$",
            }
            for i = 1, #chars do
                if find(word, chars[i]) then
                    word = gsub(word, "%" .. chars[i], "")
                end
            end
            return word
        end
        local start, content = 1, ""
        for i = 0, #message do
            if (message[i]) then 
                for j = 1, #table do
                    for k = 1, #table[j] do
                        local swear_word = table[j][k]
                        if find(message[i]:lower(), swear_word) then
                        
                            swear_word = checkForChar(swear_word)
                            local len = string.len(swear_word)
                            local replaced_word = sub(swear_word, 1, 1)
                            for w = 1, len - 1 do
                                replaced_word = replaced_word .. tab.censor
                            end
                            
                            local start, text, len = 1, "", string.len(message[i])
                            
                            for w = 1, len - 1 do
                                start = start + 1
                                text = sub(message[i], 1, start)
                                if (lower(text) == swear_word) then
                                    break
                                end
                            end
                            
                            local first_letter = sub(text, 1, 1)
                            if (first_letter == upper(first_letter)) then
                                replaced_word = gsub(replaced_word, sub(replaced_word, 1, 1), upper(first_letter))
                            end 
                            
                            -- Message = gsub(Message, swear_word, replaced_word)
                            if (text ~= nil) then
                                Message = gsub(Message, text, replaced_word)
                            end
                            break
                        end
                    end
                end
            end
        end
    end

    -- #Chat IDs & Admin Chat
    local keyword
    if modEnabled("Chat IDs") or modEnabled("Admin Chat") then
        local ignore = settings.mod["Chat IDs"].ignore_list
        local word = lower(message[1]) or upper(message[1])
        if (table.match(ignore, word)) then
            keyword = true
        else
            keyword = false
        end
    end

    -- #Command Spy & Chat Logging
    local command
    local iscommand
    local cmd_prefix
    if modEnabled("Command Spy") or modEnabled("Chat Logging") then
        local cSpy = settings.mod["Command Spy"]
        if sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\" then
            command = message[1]:gsub("\\", "/")
            iscommand = true
            cmd_prefix = "[COMMAND] "
        else
            iscommand = false
        end

        if (tonumber(get_var(PlayerIndex, "$lvl")) == -1) and (iscommand) then
            local hidden_messages, hidden = cSpy.commands_to_hide
            for _, v in pairs(hidden_messages) do
                if (command == v) then
                    hidden = true
                end
            end
            local hide_commands = cSpy.hide_commands
            if (hide_commands and hidden) then
                response = false
            elseif (hide_commands and not hidden) or (hide_commands == false) then
                velocity:CommandSpy(cSpy.prefix .. " " .. name .. ":    \"" .. Message .. "\"")
                response = true
            end
        end
        
        local chat_type
        if type == 0 then
            chat_type = "[GLOBAL]  "
        elseif type == 1 then
            chat_type = "[TEAM]    "
        elseif type == 2 then
            chat_type = "[VEHICLE] "
        else
            chat_type = "[UNKNOWN CHAT TYPE]"
        end
        
        if modEnabled("Admin Chat") then
            local achat = players["Admin Chat"][ip]
            if (achat ~= nil and achat.adminchat) then
                chat_type = "[ADMIN CHAT]"
            end
        end     
        
        local dir = settings.mod["Chat Logging"].dir
        local function LogChat(dir, msg)
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            local file = io.open(dir, "a+")
            if file ~= nil then
                local str = format("%s\t%s\n", timestamp, tostring(msg))
                file:write(str)
                file:close()
            end
        end
        if iscommand then
            LogChat(dir, "   " .. cmd_prefix .. "     " .. name .. " [" .. id .. "]: " .. Message)
            cprint(cmd_prefix .. " " .. name .. " [" .. id .. "]: " .. Message, 3 + 8)
        else
            LogChat(dir, "   " .. chat_type .. "     " .. name .. " [" .. id .. "]: " .. Message)
            cprint(chat_type .. " " .. name .. " [" .. id .. "]: " .. Message, 3 + 8)
        end
    end

    -- #Admin Chat
    if modEnabled("Admin Chat") then
        local mod = players["Admin Chat"][ip]
        if (mod ~= nil) then
            local environment = settings.mod["Admin Chat"].environment
            local function AdminChat(table)
                for i = 1, 16 do
                    if player_present(i) then
                        if (level(i) >= getPermLevel("Admin Chat", false)) then
                            if (environment == "rcon") then
                                for j = 1, #table do
                                    respond(i, "|l" .. table[j], "rcon")
                                end
                            elseif (environment == "chat") then
                                for j = 1, #table do
                                    respond(i, table[j], "chat")
                                end
                            end
                            response = false
                        end
                    end
                end
            end
            if (mod.adminchat) then
                -- attempt to index local 'mod' (a nil value) - when script is reloaded
                if (level(id) >= getPermLevel("Admin Chat", false)) then
                    for c = 0, #message do
                        if message[c] then
                            if not (keyword) or (keyword == nil) then
                                if sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\" then
                                    response = true
                                else
                                    local tab = settings.mod["Admin Chat"]
                                    local strFormat = tab.message_format
                                    local prefix = tab.prefix
                                    local temp = { }
                                    for i = 1, #strFormat do
                                        if (strFormat[i]) then
                                            temp[#temp + 1] = strFormat[i]
                                        end
                                    end
                                    for j = 1, #temp do
                                        temp[j] = gsub(gsub(gsub(gsub(temp[j], "%%prefix%%", prefix), "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message)
                                    end
                                    AdminChat(temp)
                                    response = false
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
    -- #Chat IDs
    if modEnabled("Chat IDs") then
        if not (game_over) then
            local c_tab = settings.mod["Chat IDs"]

            -- GLOBAL FORMAT
            local GlobalDefault = c_tab.global_format[1]
            local Global_TModFormat = c_tab.trial_moderator[1]
            local Global_ModFormat = c_tab.moderator[1]
            local Global_AdminFormat = c_tab.admin[1]
            local Global_SAdminFormat = c_tab.senior_admin[1]

            --TEAM FORMAT
            local TeamDefault = c_tab.team_format[1]
            local Team_TModFormat = c_tab.trial_moderator[2]
            local Team_ModFormat = c_tab.moderator[2]
            local Team_AdminFormat = c_tab.admin[2]
            local Team_SAdminFormat = c_tab.senior_admin[2]

            -- Permission Levels
            local tmod_perm = c_tab.trial_moderator.lvl
            local mod_perm = c_tab.moderator.lvl
            local admin_perm = c_tab.admin.lvl
            local sadmin_perm = c_tab.senior_admin.lvl

            if not (keyword) or (keyword == nil) then
                local function ChatHandler(PlayerIndex, Message)
                    local function SendToTeam(Message, PlayerIndex, Global, Tmod, Mod, Admin, sAdmin)
                        for i = 1, 16 do
                            if player_present(i) and (get_var(i, "$team") == get_var(PlayerIndex, "$team")) then
                                local formattedString = ""
                                if (Global == true) then
                                    formattedString = (gsub(gsub(gsub(TeamDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Tmod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Mod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Admin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (sAdmin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                end
                                Say(i, formattedString)
                                response = false
                            end
                        end
                    end

                    local function SendToAll(Message, Global, Tmod, Mod, Admin, sAdmin)
                        local formattedString = ""
                        if (Global == true) then
                            formattedString = (gsub(gsub(gsub(GlobalDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Tmod == true) then
                            formattedString = (gsub(gsub(gsub(Global_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Mod == true) then
                            formattedString = (gsub(gsub(gsub(Global_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Admin == true) then
                            formattedString = (gsub(gsub(gsub(Global_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (sAdmin == true) then
                            formattedString = (gsub(gsub(gsub(Global_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        end
                        SayAll(formattedString)
                        response = false
                    end

                    for b = 0, #message do
                        if message[b] then
                            if not (sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\") then
                                if (getTeamPlay()) then
                                    if (type == 0 or type == 2) then
                                        if (c_tab.use_admin_prefixes == true) then
                                            if (level(id) == tmod_perm) then
                                                SendToAll(Message, nil, true, nil, nil, nil)
                                            elseif (level(id) == mod_perm) then
                                                SendToAll(Message, nil, nil, true, nil, nil)
                                            elseif (level(id) == admin_perm) then
                                                SendToAll(Message, nil, nil, nil, true, nil)
                                            elseif (level(id) == sadmin_perm) then
                                                SendToAll(Message, nil, nil, nil, nil, true)
                                            else
                                                SendToAll(Message, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    elseif (type == 1) then
                                        if (c_tab.use_admin_prefixes == true) then
                                            if (level(id) == tmod_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, true, nil, nil, nil)
                                            elseif (level(id) == mod_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, true, nil, nil)
                                            elseif (level(id) == admin_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, true, nil)
                                            elseif (level(id) == sadmin_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, nil, true)
                                            else
                                                SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                        end
                                    end
                                elseif (c_tab.use_admin_prefixes) then
                                    if (level(id) == tmod_perm) then
                                        SendToAll(Message, nil, true, nil, nil, nil)
                                    elseif (level(id) == mod_perm) then
                                        SendToAll(Message, nil, nil, true, nil, nil)
                                    elseif (level(id) == admin_perm) then
                                        SendToAll(Message, nil, nil, nil, true, nil)
                                    elseif (level(id) == sadmin_perm) then
                                        SendToAll(Message, nil, nil, nil, nil, true)
                                    else
                                        SendToAll(Message, true, nil, nil, nil, nil)
                                    end
                                else
                                    SendToAll(Message, true, nil, nil, nil, nil)
                                end
                            else
                                response = true
                            end
                            break
                        end
                    end
                end
                if modEnabled("Admin Chat") then
                    local achat = players["Admin Chat"][ip]
                    if (achat ~= nil) and (achat.adminchat ~= true) then
                        ChatHandler(PlayerIndex, Message)
                    end
                else
                    ChatHandler(PlayerIndex, Message)
                end
            end
        end
    end
    -- #Teleport Manager
    if modEnabled("Teleport Manager") then
        if wait_for_response[PlayerIndex] then
            if Message == ("yes") then
                local dir = settings.mod["Teleport Manager"].dir
                local warp_num = tonumber(getWarp())
                delete_from_file(dir, warp_num, 1)
                rprint(PlayerIndex, "Successfully deleted teleport id #" .. warp_num)
                wait_for_response[PlayerIndex] = false
            elseif Message == ("no") then
                rprint(PlayerIndex, "Process Cancelled")
                wait_for_response[PlayerIndex] = false
            end
            if Message ~= "yes" or Message ~= "no" then
                rprint(PlayerIndex, "That is not a valid response, please try again. Type yes|no")
            end
            response = false
        end
    end
    return response
end

local function checkAccess(e, console_allowed, script, others, alt, params)
    local access
    if (e ~= -1 and e >= 1 and e < 16) then
        if not (alt) then
            if (tonumber(get_var(e, "$lvl")) >= getPermLevel(script, others)) then
                access = true
            else
                rprint(e, "Command failed. Insufficient Permission.")
                access = false
            end
        else
            if (tonumber(get_var(e, "$lvl")) >= getPermLevel(script, others, params)) then
                access = true
            else
                rprint(e, "Command failed. Insufficient Permission.")
                access = false
            end
        end
    elseif (console_allowed) and (e < 1) then
        access = true
    elseif not (console_allowed) and (e < 1) then
        access = false
        respond(e, "Command Failed. Unable to execute from console.", "rcon", 4 + 8)
    end
    return access
end

local gameover = function(e)
    if (game_over) then
        rprint(e, "Command Failed -> Game has Ended.")
        rprint(e, "Please wait until the next game has started.")
        return true
    end
end

local function cmdself(t, e)
    if (t) and (tonumber(t) == tonumber(e)) then
        rprint(e, "You cannot execute this command on yourself.")
        return true
    end
end

local function isOnline(t, e)
    if (t) then
        if (t > 0 and t < 17) then
            if player_present(t) then
                return true
            else
                respond(e, "Command failed. Player not online.", "rcon", 4 + 8)
                return false
            end
        else
            respond(e, "Invalid player id. Please enter a number between 1-16", "rcon", 4 + 8)
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    
    if (command == nil) then
        return
    end
    command = lower(command) or upper(command) or ""

    local executor = tonumber(PlayerIndex)
    local level = tonumber(get_var(executor, "$lvl"))
    
    local ip = getip(PlayerIndex, true)
    if (ip == nil) then
        ip = server_ip
    end
    
    local TargetID, target_all_players, is_error
    local name, hash = get_var(executor, "$name"), get_var(executor, "$hash")

    local pCMD = settings.global.special_commands
    local lore_cmd = pCMD.information

    local function hasAccess(e, lvl_req)
        if isConsole(e) then
            return true
        elseif (level >= lvl_req) then
            return true
        else
            respond(e, "Insufficient Permission", "rcon", 5 + 8)
            return false
        end
    end

    -- #Command Spy
    if modEnabled("Command Spy") then
        if (Environment == 1 and level == -1) then
            local cSpy = settings.mod["Command Spy"]
            velocity:CommandSpy("[RCON] " .. cSpy.prefix .. " " .. name .. ":    \"" .. Command .. "\"")
        end
    end

    local params = { }
    local function validate_params(parameter, pos)
        local function getplayers(arg, executor)
            local players = { }
            if (arg == nil) or (arg == "me") then
                TargetID = executor
                table.insert(players, executor)
            elseif (arg:match("%d+")) then
                TargetID = tonumber(arg)
                table.insert(players, arg)
            elseif (arg == "*" or arg == "all") then
                for i = 1, 16 do
                    if player_present(i) then
                        target_all_players = true
                        table.insert(players, i)
                    end
                end
            else
                respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", "rcon", 4 + 8)
                is_error = true
                return false
            end

            for i = 1, #players do
                if (executor ~= tonumber(players[i])) then
                    execute_on_others_error[executor] = { }
                    execute_on_others_error[executor] = true
                end
            end

            if (players[1]) then
                return players
            end
            players = nil
            return false
        end
        local pl = getplayers(args[tonumber(pos)], executor)
        if pl then
            for i = 1, #pl do
                if (pl[i] == nil) then
                    break
                end

                params.eid = executor
                params.eip = ip
                params.en, params.eh = name, hash

                params.tid = tonumber(pl[i])
                params.tip = getip(pl[i], true)
                params.tn, params.th = get_var(pl[i], "$name"), get_var(pl[i], "$hash")

                if (params.eip == nil) then
                    params.eip = server_ip
                end

                -- #Admin Chat
                if (parameter == "achat") then
                    if (args[1] ~= nil) then
                        params.option = args[1] -- on|off
                    end
                    if (target_all_players) then
                        velocity:determineAchat(params)
                    end
                    -- #Alias System
                elseif (parameter == "alias") then
                    local bool
                    if isConsole(executor) then
                        bool = false
                    else
                        bool = settings.mod["Alias System"].use_timer
                    end
                    if (args[2] ~= nil) then
                        params.page = args[2] -- page id
                    end
                    params.timer = bool
                    alias:reset(params.eip)
                    -- #Block Object Pickups
                elseif (parameter == "blockpickup") then
                    if (target_all_players) then
                        velocity:blockpickup(params)
                    end
                elseif (parameter == "unblock") then
                    if (target_all_players) then
                        velocity:unblockpickups(params)
                    end
                    -- #Color Changer
                elseif (parameter == "colorchanger") then
                    if (args[1] ~= nil) then
                        params.color = args[1] -- color id
                    end
                    if (target_all_players) then
                        velocity:setcolor(params)
                    end
                    -- #Cute
                elseif (parameter == "cute") then
                    if (target_all_players) then
                        if not cmdself(params.tid, executor) then
                            velocity:cute(params)
                        end
                    end
                    -- #Enter Vehicle
                elseif (parameter == "entervehicle") then
                    if (args[1] ~= nil) then
                        params.item = args[1] -- item
                    end
                    if (args[3] ~= nil) then
                        params.height = args[3] -- height
                    end
                    if (args[4] ~= nil) then
                        params.distance = args[4] -- distance
                    end
                    if (target_all_players) then
                        velocity:enterVehicle(params)
                    end
                    -- #Garbage Collection
                elseif (parameter == "garbagecollection") then
                    if (args[1] ~= nil) then
                        params.table = args[2] -- table id
                    end
                    if (target_all_players) then
                        velocity:clean(params)
                    end
                    -- #Get Coords
                elseif (parameter == "getcoords") then
                    if (target_all_players) then
                        velocity:getcoords(params)
                    end
                    -- #Give
                elseif (parameter == "give") then
                    if (args[1] ~= nil) then
                        params.object = args[1]
                    end
                    if (target_all_players) then
                        velocity:give(params)
                    end
                    -- #Infinity Ammo
                elseif (parameter == "infinityammo") then
                    if (args[2] ~= nil) then
                        params.multiplier = args[2] -- multipler
                    end
                    if (target_all_players) then
                        velocity:infinityAmmo(params)
                    end
                    -- #Item Spawner
                elseif (parameter == "itemspawner") then
                    if (args[1] ~= nil) then
                        params.item = args[1] -- object
                    end
                    if (args[3] ~= nil) then
                        params.amount = args[3] -- amount
                    end
                    if (target_all_players) then
                        velocity:spawnItem(params)
                    end
                    -- #Lurker
                elseif (parameter == "lurker") then
                    if (args[1] ~= nil) then
                        params.option = args[1]
                    end
                    
                    if (args[3] ~= nil) then
                        params.flag = args[3]
                    end

                    if (target_all_players) then
                        Lurker:set(params)
                    end
                    -- #Mute System
                elseif (parameter == "mute") then
                    if (args[2] ~= nil) then
                        params.time = args[2] -- time diff
                    end
                    if (target_all_players) then
                        if not cmdself(params.tid, executor) then
                            velocity:saveMute(params, true, true)
                        end
                    end
                elseif (parameter == "unmute") then
                    if (target_all_players) then
                        if not cmdself(params.tid, executor) then
                            velocity:unmute(params)
                        end
                    end
                    -- #Portal Gun
                elseif (parameter == "portalgun") then
                    if (args[1] ~= nil) then
                        params.option = args[1]
                    end
                    if (target_all_players) then
                        velocity:portalgun(params)
                    end
                    -- #Respawn Time
                elseif (parameter == "setrespawn") then
                    if (args[2] ~= nil) then
                        params.time = args[2]
                    end
                    if (target_all_players) then
                        velocity:setRespawnTime(params)
                    end
                    -- #Respawn On Demand
                elseif (parameter == "respawn") then
                    if (target_all_players) then
                        velocity:respawn(params)
                    end
                    -- #Teleport Manager | warp
                elseif (parameter == "warp") then
                    if (args[1] ~= nil) then
                        params.warpname = args[1]
                    end
                    if (target_all_players) then
                        velocity:warp(params)
                    end
                    -- #Teleport Manager | back
                elseif (parameter == "warpback") then
                    if (target_all_players) then
                        velocity:warpback(params)
                    end
                end
            end
        end
    end

    if modEnabled("Alias System") or modEnabled("Welcome Messages") then
        if (players["Alias System"][ip] ~= nil and players["Alias System"][ip].trigger) then
            alias:reset(ip)
            cls(executor, 25)
        end

        if (players["Welcome Messages"][ip] ~= nil and players["Welcome Messages"][ip].show) then
            welcomeMessages:hide(executor, ip)
            cls(executor, 25)
        end
    end

    -- #Player List
    local cmd_list = settings.mod["Player List"].command_aliases
    for i = 1, #cmd_list do
        if (command == cmd_list[i]) then
            if modEnabled("Player List", executor) then
                if (checkAccess(executor, true, "Player List")) then
                    if (args[1] == nil) then
                        velocity:listplayers(executor)
                    else
                        respond(executor, "Invalid Syntax. Usage: /" .. command, "rcon", 4 + 8)
                    end
                end
            end
            return false
        end
    end

    -- #Admin Chat
    if (command == settings.mod["Admin Chat"].base_command) then
        if not gameover(executor) then
            if modEnabled("Admin Chat", executor) then
                if (checkAccess(executor, true, "Admin Chat")) then
                    local tab = settings.mod["Admin Chat"]
                    if (args[1] ~= nil) then
                        validate_params("achat", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:determineAchat(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " on/off [me | id | */all]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Alias System
    elseif (command == settings.mod["Alias System"].base_command) then
        if modEnabled("Alias System", executor) then
            if (checkAccess(executor, true, "Alias System")) then
                local tab = settings.mod["Alias System"]
                if (args[1] ~= nil) then
                    validate_params("alias", 1) --/base_command [id] <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            velocity:cmdRoutine(params)
                        end
                    else
                        respond(executor, "Unable to check aliases from all players.", "rcon", 4 + 8)
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. tab.base_command .. " [id | me ] [page id]", "rcon", 4 + 8)
                end
            end
        end
        return false
        -- #Auto Message
    elseif (command == settings.mod["Auto Message"].base_command) then
        if not gameover(executor) then
            if modEnabled("Auto Message", executor) then
                if (checkAccess(executor, true, "Auto Message")) then
                    local tab = settings.mod["Auto Message"]
                    if (args[1] ~= nil) and (args[2] == nil) then
                        local p = { }
                        p.eid, p.args, p.tab = executor, args[1], tab
                        autoMessage:broadcastManually(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [broadcast id]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Block Object Pickups [block]
    elseif (command == settings.mod["Block Object Pickups"].block_command) then
        if not gameover(executor) then
            if modEnabled("Block Object Pickups", executor) then
                if (checkAccess(executor, true, "Block Object Pickups")) then
                    local tab = settings.mod["Block Object Pickups"]
                    if (args[1] ~= nil) and (args[2] == nil) then
                        validate_params("blockpickup", 1) --/block_command [me | id | */all]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:blockpickup(params)
                            end
                        end

                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.block_command .. " [me | id | */all]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Block Object Pickups [unblock]
    elseif (command == settings.mod["Block Object Pickups"].unblock_command) then
        if not gameover(executor) then
            if modEnabled("Block Object Pickups", executor) then
                if (checkAccess(executor, true, "Block Object Pickups")) then
                    local tab = settings.mod["Block Object Pickups"]
                    if (args[1] ~= nil) and (args[2] == nil) then
                        validate_params("blockpickup", 1) --/unblock_command [me | id | */all]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:unblockpickups(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.unblock_command .. " [me | id | */all]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Color Changer
    elseif (command == settings.mod["Color Changer"].base_command) then
        if not getTeamPlay() then
            if not gameover(executor) then
                if modEnabled("Color Changer", executor) then
                    if (checkAccess(executor, true, "Color Changer")) then
                        local tab = settings.mod["Color Changer"]
                        if (args[1] ~= nil) then
                            validate_params("colorchanger", 2) --/base_command <args> [me | id | */all]
                            if not (target_all_players) then
                                if not (is_error) and isOnline(TargetID, executor) then
                                    velocity:setcolor(params)
                                end
                            end
                        else
                            respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [color id] [me | id | */all]", "rcon", 4 + 8)
                        end
                    end
                end
            end
        else
            respond(executor, "This command doesn't work on Team-Based games.", "rcon", 4 + 8)
        end
        return false
        -- #Cute
    elseif (command == settings.mod["Cute"].base_command) then
        if modEnabled("Cute", executor) then
            if (checkAccess(executor, true, "Cute")) then
                local tab = settings.mod["Cute"]
                if (args[1] ~= nil) then
                    validate_params("cute", 1) --/base_command [id]
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            velocity:cute(params)
                        end
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. tab.base_command .. " [me | id | */all]", "rcon", 4 + 8)
                end
            end
        end
        return false
        -- #Enter Vehicle
    elseif (command == settings.mod["Enter Vehicle"].base_command) then
        if not gameover(executor) then
            if modEnabled("Enter Vehicle", executor) then
                if modEnabled("Item Spawner", executor) then
                    if (checkAccess(executor, true, "Enter Vehicle")) then
                        local tab = settings.mod["Enter Vehicle"]
                        if (args[1] ~= nil) then
                            validate_params("entervehicle", 2) --/base_command <args> [id]
                            if not (target_all_players) then
                                if not (is_error) and isOnline(TargetID, executor) then
                                    velocity:enterVehicle(params)
                                end
                            end
                        else
                            respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " <vehicle name> [me | id | */all] (opt height/distance)", "rcon", 4 + 8)
                            return false
                        end
                    end
                else
                    rprint(executor, "Error. Plugin: 'Item Spawner' needs to be enabled for this to work.")
                end
            end
        end
        return false
        -- #Garbage Collection
    elseif (command == settings.mod["Garbage Collection"].base_command) then
        if not gameover(executor) then
            if modEnabled("Garbage Collection", executor) or modEnabled("Garbage Collection", executor) then
                if (checkAccess(executor, true, "Garbage Collection")) then
                    local tab = settings.mod["Garbage Collection"]
                    if (args[1] ~= nil) and (args[2] ~= nil) then
                        validate_params("garbagecollection", 1) --/base_command [id] <args>
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:clean(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [me | id | */all] [type]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Get Coords
    elseif (command == settings.mod["Get Coords"].base_command) then
        if not gameover(executor) then
            if modEnabled("Get Coords", executor) then
                if (checkAccess(executor, true, "Get Coords")) then
                    local tab = settings.mod["Get Coords"]
                    if (args[1] ~= nil) and (args[2] == nil) then
                        validate_params("getcoords", 1) --/base_command [me | id | */all]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:getcoords(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [me | id | */all]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Give
    elseif (command == settings.mod["Give"].base_command) then
        if not gameover(executor) then
            if modEnabled("Give", executor) then
                if (checkAccess(executor, true, "Give")) then
                    local tab = settings.mod["Give"]
                    if (args[1] ~= nil) then
                        validate_params("give", 2) --/base_command <item> [me | id | */all]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:give(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " <item> [me | id | */all]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Infinity Ammo
    elseif (command == settings.mod["Infinity Ammo"].base_command) then
        if not gameover(executor) then
            if modEnabled("Infinity Ammo", executor) then
                if (checkAccess(executor, true, "Infinity Ammo")) then
                    local tab = settings.mod["Infinity Ammo"]
                    if (args[1] ~= nil) then
                        validate_params("infinityammo", 1) --/base_command [id] <args>
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:infinityAmmo(params)
                            end
                        end
                    else
                        respond(executor, "Invalid syntax. Usage: /" .. tab.base_command .. " [me | id | */all] [multiplier]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Item Spawner
    elseif (command == settings.mod["Item Spawner"].base_command) then
        if not gameover(executor) then
            if modEnabled("Item Spawner", executor) then
                if (checkAccess(executor, true, "Item Spawner")) then
                    local tab = settings.mod["Item Spawner"]
                    if (args[1] ~= nil) then
                        validate_params("itemspawner", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:spawnItem(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " <item name> [me | id | */all] [opt: amount]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Item Spawner
    elseif (command == settings.mod["Item Spawner"].list) then
        if not gameover(executor) then
            if modEnabled("Item Spawner", executor) then
                if (checkAccess(executor, true, "Item Spawner")) then
                    local tab = settings.mod["Item Spawner"]
                    if (args[1] == nil) then
                        local p = { }
                        p.eid, p.table = executor, tab
                        velocity:itemSpawnerList(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.list .. " [page id]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Lurker
    elseif (command == settings.mod["Lurker"].base_command) then
        if not gameover(executor) then
            if modEnabled("Lurker", executor) then
                if (checkAccess(executor, true, "Lurker")) then
                    local tab = settings.mod["Lurker"]
                    if (args[1] ~= nil) then
                        validate_params("lurker", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                Lurker:set(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " on|off [me | id | */all] <flag>", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Mute System
    elseif (command == settings.mod["Mute System"].mute_command) then
        if modEnabled("Mute System", executor) then
            if (checkAccess(executor, true, "Mute System")) then
                local tab = settings.mod["Mute System"]
                if (args[1] ~= nil) and (args[2] ~= nil) then
                    validate_params("mute", 1) --/mute_command [id] <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            if not cmdself(params.tid, executor) then
                                velocity:saveMute(params, true, true)
                            end
                        end
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. tab.mute_command .. " [me | id | */all] <time diff>", "rcon", 2 + 8)
                end
            end
        end
        return false
        -- #Mute System
    elseif (command == settings.mod["Mute System"].unmute_command) then
        if modEnabled("Mute System", executor) then
            if (checkAccess(executor, true, "Mute System")) then
                local tab = settings.mod["Mute System"]
                if (args[1] ~= nil) then
                    validate_params("unmute", 1) --/unmute_command [id] <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            if not cmdself(params.tid, executor) then
                                velocity:unmute(params)
                            end
                        end
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. tab.unmute_command .. " [me | id | */all]", "rcon", 2 + 8)
                end
            end
        end
        return false
        -- #Mute System
    elseif (command == settings.mod["Mute System"].mutelist_command) then
        if modEnabled("Mute System", executor) then
            if (checkAccess(executor, true, "Mute System")) then
                local p = { }
                p.eid = executor
                p.flag = args[1]
                velocity:mutelist(p)
            end
        end
        return false
        -- #Portal Gun
    elseif (command == settings.mod["Portal Gun"].base_command) then
        if not gameover(executor) then
            if modEnabled("Portal Gun", executor) then
                if (checkAccess(executor, true, "Portal Gun")) then
                    local tab = settings.mod["Portal Gun"]
                    if (args[1] ~= nil) then
                        validate_params("portalgun", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:portalgun(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " on|off [me | id | */all] ", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Private Messaging System
    elseif (command == settings.mod["Private Messaging System"].send_command) then
        if not gameover(executor) then
            if modEnabled("Private Messaging System", executor) then
                if (checkAccess(executor, true, "Private Messaging System")) then
                    local tab = settings.mod["Private Messaging System"]
                    if (args[1] ~= nil) and (args[2] ~= nil) then
                        local p = { }
                        local content = Command:match(args[1] .. "(.+)")
                        if Command:find(tab.seperator) then
                            content = gsub(content, tab.seperator, "")
                        end
                        p.eid, p.en, p.eip, p.message, p.recipient_id = executor, name, ip, content, args[1]
                        p.dir = tab.dir
                        privateMessage:send(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.send_command .. " [user id] {message}", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Private Messaging System
    elseif (command == settings.mod["Private Messaging System"].read_command) then
        if not gameover(executor) then
            if modEnabled("Private Messaging System", executor) then
                if (checkAccess(executor, false, "Private Messaging System")) then
                    local tab = settings.mod["Private Messaging System"]
                    if (args[1] ~= nil) then
                        local p = { }
                        p.eid, p.eip, p.page = executor, ip, args[1]
                        p.mail = privateMessage:load(p)
                        privateMessage:read(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.read_command .. " [page num]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Private Messaging System
    elseif (command == settings.mod["Private Messaging System"].delete_command) then
        if not gameover(executor) then
            if modEnabled("Private Messaging System", executor) then
                if (checkAccess(executor, false, "Private Messaging System")) then
                    local tab = settings.mod["Private Messaging System"]
                    if (args[1] ~= nil) then
                        local p = { }
                        p.eid, p.eip, p.mail_id = executor, ip, args[1]
                        p.mail = privateMessage:load(p)
                        privateMessage:delete(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.delete_command .. " [message id | */all]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Respawn Time
    elseif (command == settings.mod["Respawn Time"].base_command) then
        if not gameover(executor) then
            if modEnabled("Respawn Time", executor) then
                if (checkAccess(executor, true, "Respawn Time")) then
                    local tab = settings.mod["Respawn Time"]
                    if (args[1] ~= nil) then
                        validate_params("setrespawn", 1) --/base_command [id] <args>
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:setRespawnTime(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [me | id | */all] <time diff>", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Respawn On Demand
    elseif (command == settings.mod["Respawn On Demand"].base_command) then
        if not gameover(executor) then
            if modEnabled("Respawn On Demand", executor) then
                if (checkAccess(executor, true, "Respawn On Demand")) then
                    local tab = settings.mod["Respawn On Demand"]
                    if (args[1] ~= nil) and (args[2] == nil) then
                        validate_params("respawn", 1) --/base_command [me | id | */all]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:respawn(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [me | id | */all]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Suggestions Box
    elseif (command == settings.mod["Suggestions Box"].base_command) then
        if not gameover(executor) then
            if modEnabled("Suggestions Box", executor) then
                if (checkAccess(executor, true, "Suggestions Box")) then
                    local tab = settings.mod["Suggestions Box"]
                    if (args[1] ~= nil) then
                        local p = { }
                        local content = gsub(Command, tab.base_command, "")
                        p.eid, p.en, p.message = executor, name, content
                        p.format, p.dir = tab.msg_format, tab.dir
                        velocity:suggestion(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " {message}", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | SET WARP
    elseif (command == settings.mod["Teleport Manager"].commands[1]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                local p = { }
                p.eid, p.level, p.cmd = executor, level, "setwarp"
                if (checkAccess(executor, false, "Teleport Manager", false, true, p)) then
                    if (args[1] ~= nil) then
                        p.warpname = args[1]
                        velocity:setwarp(p)
                    else
                        local tab = settings.mod["Teleport Manager"]
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[1] .. " <warp name>", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | WARP
    elseif (command == settings.mod["Teleport Manager"].commands[2]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                if (checkAccess(executor, true, "Teleport Manager", true, false, p)) then
                    local tab = settings.mod["Teleport Manager"]
                    if (args[1] ~= nil) then
                        validate_params("warp", 2) --/commands[2] <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:warp(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[2] .. " [warp name] [me | id | */all] ", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | BACK
    elseif (command == settings.mod["Teleport Manager"].commands[3]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                if (checkAccess(executor, true, "Teleport Manager", true, false, p)) then
                    local tab = settings.mod["Teleport Manager"]
                    if (args[1] ~= nil and args[2] == nil) then
                        validate_params("warpback", 1) --/commands[3] <args>
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:warpback(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[3] .. " [me | id | */all] ", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | WARP LIST
    elseif (command == settings.mod["Teleport Manager"].commands[4]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                if (checkAccess(executor, true, "Teleport Manager", true, false, p)) then
                    local tab = settings.mod["Teleport Manager"]
                    if (args[1] == nil) then
                        local p = {}
                        p.eid = executor
                        velocity:warplist(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[4] .. " or /" .. tab.commands[5], "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | WARP LIST ALL
    elseif (command == settings.mod["Teleport Manager"].commands[5]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                if (checkAccess(executor, true, "Teleport Manager", true, false, p)) then
                    local tab = settings.mod["Teleport Manager"]
                    if (args[1] == nil) then
                        local p = {}
                        p.eid = executor
                        velocity:warplistall(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[5] .. " or /" .. tab.commands[4], "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | BACK
    elseif (command == settings.mod["Teleport Manager"].commands[6]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                if (checkAccess(executor, true, "Teleport Manager", true, false, p)) then
                    local tab = settings.mod["Teleport Manager"]
                    if (args[1] ~= nil) then
                        local p = { }
                        p.warpid = args[1]
                        p.eid = executor
                        velocity:delwarp(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[6] .. " [warp id]", "rcon", 4 + 8)
                    end
                end
            end
        end
        return false
        -- S P E C I A L   C O M M A N D S ============================================================================================
        -- #Velocity Version command
    elseif (command == pCMD.velocity[1]) then
        if hasAccess(executor, pCMD.velocity[2]) then
            local script_version = format("%0.2f", settings.global.script_version)
            if (settings.global.check_for_updates) then
                if (getCurrentVersion(false) ~= script_version) then
                    respond(executor, "============================================================================", "rcon", 7 + 8)
                    respond(executor, "[VELOCITY] Version " .. getCurrentVersion(false) .. " is available for download.", "rcon", 5 + 8)
                    respond(executor, "Current version: v" .. script_version, "rcon", 5 + 8)
                    respond(executor, "============================================================================", "rcon", 7 + 8)
                else
                    respond(executor, "Velocity Version " .. script_version, "rcon", 5 + 8)
                end
            else
                respond(executor, "Update Checking disabled. Current version: " .. script_version, "rcon", 5 + 8)
            end
        end
        return false
        -- #Clear Chat Command
    elseif (command == pCMD.clearchat[1]) then
        if hasAccess(executor, pCMD.clearchat[2]) then
            for i = 1, 20 do
                SayAll(" ")
                if player_present(i) and (tonumber(get_var(i, "$lvl")) >= 1) then
                    respond(i, "Chat was cleared by " .. name, "rcon", 5 + 8)
                end
            end
        end
        return false
        -- #Rules and Information
    elseif (command == lore_cmd.cmd) then
        if not gameover(executor) then
            if hasAccess(executor, lore_cmd.permission_level) then
                if (args[1] ~= nil) and args[1]:match("%d+") and not args[1]:match("[A-Za-z]") then
                    local page = tonumber(args[1])
                    local table = lore_cmd.data[page]
                    if (table) then
                        for i = 1, #table do
                            local content = table[i]
                            if (content) then
                                respond(executor, content, "rcon", 2 + 8)
                            end
                        end
                        respond(executor, "Viewing Page (" .. page .. "/" .. #lore_cmd.data .. ")", "rcon", 4 + 8)
                    else
                        respond(executor, "[SERVER] -> you: Invalid Page Number", "rcon", 4 + 8)
                    end
                else
                    respond(executor, "Invalid Syntax. Usage: /" .. lore_cmd.cmd .. " [page num]", "rcon", 4 + 8)
                end
            end
        end
        return false
        -- #Plugin List
    elseif (command == pCMD.list[1]) then
        if not gameover(executor) then
            if hasAccess(executor, pCMD.list[2]) then
                local page, len = args[1], string.len
                if (page == nil) then
                    page = 1
                end
                if (page ~= nil) and (len(page) > 0) and (args[2] == nil) then
                    local tab = settings
                    local p, table = { }, { }
                    p.table, p.page = tab.global, page

                    local count = 0
                    local startpage, endpage = select(1, getPage(p)), select(2, getPage(p))

                    local t = {}
                    for k, _ in pairs(tab.mod) do
                        t[#t + 1] = k
                        count = count + 1
                    end

                    local status = ""
                    for page_num = startpage, endpage do
                        if (t[page_num]) then
                            for k, v in pairs(t) do
                                if (k == page_num) then
                                    if (tab.mod[v].enabled) then
                                        status = "[enabled]"
                                    else
                                        status = "[disabled]"
                                    end
                                    table[#table + 1] = (t[page_num] .. "|" .. k .. "|" .. status)
                                end
                            end
                        end
                    end

                    if (#table > 0) then
                        for _, v in pairs(table) do
                            local data = stringSplit(v, "|")
                            if (data) then
                                local result, i = { }, 1
                                for j = 1, 3 do
                                    if (data[j] ~= nil) then
                                        result[i] = data[j]
                                        i = i + 1
                                    end
                                end
                                if (result ~= nil) then
                                    local plugin_name = result[1]
                                    local index = result[2]
                                    local status = result[3]
                                    local seperator = "|c"
                                    if (status == "[enabled]") then
                                        color = 2 + 8
                                    else
                                        color = 4 + 8
                                    end
                                    respond(executor, "[#" .. index .. "] " .. plugin_name .. " " .. status, "rcon", color)
                                end
                            end
                        end
                        local maxpages = getPageCount(count, 10) -- 10 pages hardcoded
                        respond(executor, "Viewing Page (" .. page .. "/" .. maxpages .. "). Total Plugins: " .. count, "rcon", 5 + 8)
                    else
                        respond(executor, "Nothing to show", "rcon", 5 + 8)
                    end
                else
                    respond(executor, "Invalid Syntax. Usage: /" .. pCMD.list[1] .. " [page num]", "rcon", 4 + 8)
                end
            end
        end
        return false
        -- #Enable Plugin
    elseif (command == pCMD.enable[1]) then
        if not gameover(executor) then
            if (args[1] ~= nil and args[1]:match("%d+")) then
                if hasAccess(executor, pCMD.enable[2]) then
                    local id = args[1]
                    local t = {}
                    for k, _ in pairs(settings.mod) do
                        t[#t + 1] = k
                    end
                    for k, v in pairs(t) do
                        if v then
                            if (tonumber(id) == tonumber(k)) then
                                if not (settings.mod[v].enabled) then
                                    settings.mod[v].enabled = true
                                    respond(executor, "[" .. k .. "] " .. v .. " is enabled", "rcon", 2 + 8)
                                else
                                    respond(executor, v .. " is already enabled!", "rcon", 3 + 8)
                                end
                            end
                        end
                    end
                    for _ in pairs(t) do
                        t[_] = nil
                    end
                end
            else
                respond(executor, "Invalid Syntax. Usage: /" .. pCMD.enable[1], "rcon", 4 + 8)
            end
        end
        return false
        -- #Disable Plugin
    elseif (command == pCMD.disable[1]) then
        if not gameover(executor) then
            if (args[1] ~= nil and args[1]:match("%d+")) then
                if hasAccess(executor, pCMD.disable[2]) then
                    local id = args[1]
                    local t = {}
                    for k, _ in pairs(settings.mod) do
                        t[#t + 1] = k
                    end
                    for k, v in pairs(t) do
                        if v then
                            if (tonumber(id) == tonumber(k)) then
                                if (settings.mod[v].enabled) then
                                    settings.mod[v].enabled = false
                                    respond(executor, "[" .. k .. "] " .. v .. " is disabled", "rcon", 4 + 8)
                                else
                                    respond(executor, v .. " is already enabled!", "rcon", 3 + 8)
                                end
                            end
                        end
                    end
                    for _ in pairs(t) do
                        t[_] = nil
                    end
                end
            else
                respond(executor, "Invalid Syntax. Usage: /" .. pCMD.disable[1], "rcon", 4 + 8)
            end
        end
        return false
    end
end

-- #Portal Gun
function velocity:portalgun(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local option = params.option or nil
    local proceed

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local function Enable(tip)
        portalgun_mode[tip] = true
        announceExclude(tid, tn .. " is now in Portal Gun mode!")
    end

    local function Disable(tip)
        portalgun_mode[tip] = false
        announceExclude(tid, tn .. " is no longer in Portal Gun mode!")
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Portal Gun")) then
        local base_command = settings.mod["Portal Gun"].base_command
        local status, already_set, is_error
        if (option == "on") or (option == "1") or (option == "true") then
            if (portalgun_mode[tip] ~= true) then
                Enable(tip)
                status, already_set, is_error = "Enabled", false, false
            else
                status, already_set, is_error = "Enabled", true, false
            end
        elseif (option == "off") or (option == "0") or (option == "false") then
            if (portalgun_mode[tip] ~= false) then
                Disable(tip)
                status, already_set, is_error = "Disabled", false, false
            else
                status, already_set, is_error = "Disabled", true, false
            end
        else
            is_error = true
            respond(eid, "Invalid Syntax: Type /" .. base_command .. " on|off [id]", "rcon", 4 + 8)
        end
        if not (is_error) and not (already_set) then
            if not (is_self) then
                respond(eid, "Portal Gun " .. status .. " for " .. tn, "rcon", 2 + 8)
                respond(tid, "Your Portal Gun was " .. status .. " by " .. en, "rcon")
            else
                respond(eid, "Portal Gun " .. status, "rcon")
            end
        elseif (already_set) then
            respond(eid, "[SERVER] -> " .. tn .. ", Portal Gun is already " .. status, "rcon")
        end
    end
    return false
end

-- #Auto Message
function autoMessage:broadcastManually(params)
    local params = params or {}
    local eid = params.eid or nil
    local args = params.args
    local tab = params.tab
    if (args == "list") then
        respond(eid, "-------- MESSAGES --------", "rcon", 2 + 8)
        for i = 1, #tab.announcements do
            respond(eid, "[" .. i .. "] " .. tab.announcements[i], "rcon", 2 + 8)
        end
    elseif args:match("^%d+$") then
        if (tab.announcements[tonumber(args)] ~= nil) then
            SayAll(tab.announcements[tonumber(args)])
        else
            respond(eid, "Invalid Broacast ID", "rcon", 2 + 8)
        end
    else
        respond(eid, "Invalid Syntax: Usage: /" .. tab.base_command .. " [broadcast id]", "rcon", 4 + 8)
    end
    return false
end

-- #Block Object Pickups [block]
function velocity:blockpickup(params)
    local params = params or {}
    local eid = params.eid or nil
    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Block Object Pickups")) then
        if (block_table[tip] ~= true) then
            block_table[tip] = true
            execute_command("block_all_objects " .. tid .. " 1")
            if not (is_self) then
                respond(eid, "Blocking object pickups for " .. tn, "rcon", 2 + 8)
            else
                respond(eid, "[SERVER] -> you: Blocking object pickups", "rcon", 2 + 8)
            end
        else
            respond(eid, "Objects already blocked for " .. tn, "rcon", 2 + 8)
        end
    end
    return false
end

-- #Block Object Pickups [unblock]
function velocity:unblockpickups(params)
    local params = params or {}
    local eid = params.eid or nil
    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Block Object Pickups")) then
        if (block_table[tip] ~= false) then
            block_table[tip] = false
            execute_command("block_all_objects " .. tid .. " 0")
            if not (is_self) then
                respond(eid, "Unblocking object pickups for " .. tn, "rcon", 2 + 8)
            else
                respond(eid, "[SERVER] -> you: Unblocking object pickups", "rcon", 2 + 8)
            end
        else
            respond(eid, "Objects already unblocked for " .. tn, "rcon", 2 + 8)
        end
    end
    return false
end


-- #Color Changer
function velocity:setcolor(params)
    local params = params or {}
    local eid = params.eid or nil
    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil
    local en = params.en or nil

    local target_name = params.tn or nil
    local color = params.color or nil

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Block Object Pickups")) then
        if player_alive(tid) then
            local player_object = get_dynamic_player(tid)
            if (player_object ~= 0) then
                local player, color_name, _error_= getPlayer(tid)
                if (color == "white" or color == "0") then
                    color, color_name = 0, "white"
                elseif (color == "black" or color == "1") then
                    color, color_name = 1, "black"
                elseif (color == "red" or color == "2") then
                    color, color_name = 2, "red"
                elseif (color == "blue" or color == "3") then
                    color, color_name = 3, "blue"
                elseif (color == "gray" or color == "4") then
                    color, color_name = 4, "gray"
                elseif (color == "yellow" or color == "5") then
                    color, color_name = 5, "yellow"
                elseif (color == "green" or color == "6") then
                    color, color_name = 6, "green"
                elseif (color == "pink" or color == "7") then
                    color, color_name = 7, "pink"
                elseif (color == "purple" or color == "8") then
                    color, color_name = 8, "purple"
                elseif (color == "cyan" or color == "9") then
                    color, color_name = 9, "cyan"
                elseif (color == "cobalt" or color == "10") then
                    color, color_name = 10, "cobalt"
                elseif (color == "orange" or color == "11") then
                    color, color_name = 11, "orange"
                elseif (color == "teal" or color == "12") then
                    color, color_name = 12, "teal"
                elseif (color == "sage" or color == "13") then
                    color, color_name = 13, "sage"
                elseif (color == "brown" or color == "14") then
                    color, color_name = 14, "brown"
                elseif (color == "tan" or color == "15") then
                    color, color_name = 15, "tan"
                elseif (color == "maroon" or color == "16") then
                    color, color_name = 16, "maroon"
                elseif (color == "salmon" or color == "17") then
                    color, color_name = 17, "salmon"
                else
                    respond(eid, "Invalid Color", "rcon", 4 + 8)
                    _error_ = true
                end
                if not (_error_) then
                    color = color or 0 -- just in case
                    write_byte(player + 0x60, color)
                    colorspawn[tip] = { }
                    local coords = getXYZ(eid, tid)
                    if (coords) then
                        local x, y, z = coords.x, coords.y, coords.z
                        colorspawn[tip][1], colorspawn[tip][2], colorspawn[tip][3] = x, y, z
                        killSilently(tid)

                        if (coords.invehicle) then
                            entervehicle[tid].enter = true
                        end

                        if not (is_self) then
                            respond(eid, tn .. "'s color was changed to " .. color_name, "rcon", 2 + 8)
                            respond(tid, en .. " set your color to " .. color_name, "rcon", 2 + 8)
                        else
                            respond(eid, "Color changed to " .. color_name, "rcon", 4 + 8)
                        end
                    end
                end
            end
        else
            respond(eid, get_var(tid, "$name") .. " is dead! Please wait until they respawn.", "rcon", 4 + 8)
        end
    end
    return false
end

-- #Respawn
function velocity:respawn(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Respawn On Demand")) then
        killSilently(tid)
        if not (is_self) then
            respond(eid, "Respawning " .. tn, "rcon", 2 + 8)
            respond(tid, "You were respawned by " .. en, "rcon", 2 + 8)
        else
            respond(eid, "Respawning...", "rcon", 2 + 8)
        end
    end
    return false
end

-- #Give
function velocity:give(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil

    local item = params.object or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Respawn On Demand")) then
        local tab = settings["Give"]
        function delay_add()
            if (give_weapon[tid]) then
                give_weapon[tid] = false
                if player_alive(tid) then
                    if not PlayerInVehicle(tid) then
                        local table = settings.mod["Item Spawner"].objects
                        local valid, err
                        for i = 1, #table do
                            if (item == table[i][1]) then
                                local tag_type = table[i][2]
                                if (tag_type == "weap" or tag_type == "eqip") then
                                    if (delete_weapon[tid]) and (tag_type == "weap") then
                                        execute_command('wdel ' .. tid .. ' 0')
                                    end
                                    local tag_name = table[i][3]
                                    if TagInfo(tag_type, tag_name) then
                                        local function giveObject(tid, tag_type, tag_name)
                                            local player_object = get_dynamic_player(tid)
                                            if (player_object ~= 0) then
                                                local x, y, z = read_vector3d(player_object + 0x5C)
                                                assign_weapon(spawn_object(tag_type, tag_name, x, y, z), tid)
                                                if not (is_self) then
                                                    respond(eid, "Giving " .. tn .. " " .. table[i][1], "rcon", 2 + 8)
                                                    respond(tid, en .. " gave you " .. table[i][1], "rcon", 2 + 8)
                                                else
                                                    respond(eid, "Received " .. table[i][1], "rcon", 2 + 8)
                                                end
                                                valid = true
                                            end
                                        end
                                        giveObject(tid, tag_type, tag_name)
                                    else
                                        respond(eid, "Error: Missing tag id for '" .. item .. "' in 'objects' table", "rcon", 4 + 8)
                                    end
                                else
                                    respond(eid, "Unable to give that object!", "rcon", 4 + 8)
                                    err = true
                                end
                                break
                            end
                        end
                        if not (valid) and not (err) then
                            respond(tid, "'" .. item .. "' is not a valid object or it is missing in the 'objects' table", "rcon", 4 + 8)
                        end
                    elseif not (is_self) then
                        respond(eid, "Command Failed. " .. tn .. " must not be in a vehicle!", "rcon", 4 + 8)
                    else
                        respond(eid, "Command Failed. You must not be in a vehicle!", "rcon", 4 + 8)
                    end
                else
                    if not (is_self) then
                        respond(eid, "Command Failed. " .. tn .. " is dead!", "rcon", 4 + 8)
                    else
                        respond(eid, "Command failed. You are dead. [wait until you respawn]", "rcon", 4 + 8)
                    end
                end
            end
        end
        check_available_slots[tid] = true
        timer(100, "delay_add")
    end
end

-- Get Coords
function velocity:getcoords(params)
    local params = params or {}
    local eid = params.eid or nil

    local tid = params.tid or nil
    local tn = params.tn or nil

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Get Coords")) then
        local coords = getXYZ(eid, tid)
        if (coords) then
            local x, y, z, invehicle = coords.x, coords.y, coords.z, coords.invehicle
            respond(eid, tn .. "'s Coords: x: " .. x .. ", y: " .. y .. ", z: " .. z, "rcon", 2 + 8)
            if (eid > 0) then 
                cprint(x .. ", " .. y .. ", " .. z)
            end
            if (coords.invehicle) then
                respond(eid, tn .. " is in a vehicle.", "rcon", 2 + 8)
            else
                respond(eid, tn .. " is not in a vehicle.", "rcon", 2 + 8)
            end
        end
    end
end

function velocity:listplayers(e)
    local header, cheader, ffa
    local player_count = 0
    local bool = true
    local alignment = settings.mod["Player List"].alignment
    if (getTeamPlay()) then
        header = "|" .. alignment .. " [ ID.    -    Name.    -    Team.    -    IP.    -    Mode ]"
        cheader = "ID.        Name.        Team.        IP."
    else
        ffa = true
        header = "|" .. alignment .. " [ ID.    -    Name.    -    IP.    -    Mode ]"
        cheader = "ID.        Name.        IP"
    end
    for i = 1, 16 do
        if player_present(i) then
            if (bool) then
                bool = false
                if not (isConsole(e)) then
                    rprint(e, header)
                else
                    cprint(cheader, 7 + 8)
                end
            end
            player_count = player_count + 1
            local id, name, team, ip = get_var(i, "$n"), get_var(i, "$name"), get_var(i, "$team"), getip(i, true)

            local in_lurker = Lurker[ip]
            if (in_lurker ~= nil) then
                in_lurker = in_lurker.enabled
            else
                in_lurker = false
            end
            
            local in_portalgun = portalgun_mode[ip]
            local prefix
            if (in_lurker) and not (in_portalgun) then
                prefix = "|r[LURKER]"
            elseif (in_portalgun) and not (in_lurker) then
                prefix = "|r[PGUN]"
            elseif (in_portalgun) and (in_lurker) then
                prefix = "|r[PGUN] [LURKER]"
            else
                prefix = ""
            end

            local sep, seperator = ".         ", " | "
            if isConsole(e) then
                prefix = gsub(prefix, "|r", "   ")
            end

            local str = ""

            if not (ffa) then
                str = "    " .. id .. sep .. name .. seperator .. team .. seperator .. ip .. prefix
            else
                str = "    " .. id .. sep .. name .. seperator .. ip .. prefix
            end
            if not (isConsole(e)) then
                rprint(e, "|" .. alignment .. " " .. str)
            else
                cprint(str, 5 + 8)
            end
        end
    end
    if (player_count == 0) and (isConsole(e)) then
        cprint("------------------------------------", 5 + 8)
        cprint("There are no players online", 4 + 8)
        cprint("------------------------------------", 5 + 8)
    end
end

function velocity:determineAchat(params)

    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local option = params.option or nil
    local mod = players["Admin Chat"][tip]
    local proceed

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (option == "-s") or (option == "status") then
        if (tLvl >= 1) then
            if (mod.adminchat == true) then
                status = "enabled"
            else
                status = "disabled"
            end
            if (is_self) then
                respond(eid, "[status] - > " .. status, "rcon", 4 + 8)
            else
                respond(eid, tn .. "'s admin chat is " .. status, "rcon", 4 + 8)
            end
        else
            respond(eid, tn .. " is not an admin! [Admin Chat Off]", "rcon", 4 + 8)
        end
    else
        proceed = true
    end

    if (proceed) then
        local base_command = settings.mod["Admin Chat"].base_command
        if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Admin Chat")) then
            if (tLvl >= 1) then
                -- Check if the target is an admin (only admins can use this command)
                local status, already_set, is_error
                if (option == "on") or (option == "1") or (option == "true") then
                    if (mod.boolean ~= true) then
                        status, already_set, is_error = "Enabled", false, false
                        mod.adminchat = true
                        mod.boolean = true
                    else
                        status, already_set, is_error = "Enabled", true, false
                    end
                elseif (option == "off") or (option == "0") or (option == "false") then
                    if (mod.boolean ~= false) then
                        status, already_set, is_error = "Disabled", false, false
                        mod.adminchat = false
                        mod.boolean = false
                    else
                        status, already_set, is_error = "Disabled", true, false
                    end
                else
                    is_error = true
                    respond(eid, "Invalid Syntax: Type /" .. base_command .. " [id] on|off.", "rcon", 4 + 8)
                end
                if not (is_error) and not (already_set) then
                    if not (is_self) then
                        respond(eid, "Admin Chat " .. status .. " for " .. tn, "rcon", 2 + 8)
                        respond(tid, "Your Admin Chat was " .. status .. " by " .. en, "rcon")
                    else
                        respond(eid, "Admin Chat " .. status, "rcon")
                    end
                elseif (already_set) then
                    respond(eid, "[SERVER] -> " .. tn .. ", Admin Chat is already " .. status, "rcon")
                end
            else
                respond(eid, "Failed to set " .. tn .. "'s admin chat to (" .. option .. ") [player not admin]", "rcon", 4 + 8)
            end
        end
    end
    return false
end

function velocity:setRespawnTime(params)
    local params = params or { }
    local eid = params.eid or nil
    local en = params.en or nil
    local eip = params.eip or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local tip = params.tip or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    local function getRSTime(p)
        if (get_player(p)) then
            return read_dword(get_player(p) + 0x2C)
        end
    end

    local proceed
    local time = params.time or nil
    if (time == nil) then
        if (respawn_cmd_override[tip] == true) then
            status = getRSTime(tid)
        else
            status = getRSTime(tid)
        end
        if (is_self) then
            respond(eid, "Your respawn time: " .. status .. " seconds", "rcon", 4 + 8)
        else
            respond(eid, tn .. "'s respawn time: " .. status .. " seconds", "rcon", 4 + 8)
        end
    else
        proceed = true
    end

    if (proceed) then
        if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Respawn Time")) then
            if not (is_error) then
                if not (is_self) then
                    if (respawn_time[tip] == nil) then
                        respawn_time[tip] = getRSTime(tid)
                    else
                        respawn_time[tip] = time
                    end
                    respond(eid, tn .. "'s respawn time was set to " .. respawn_time[tip] .. " seconds", "rcon", 4 + 8)
                    respond(tid, "Your respawn time was set to " .. respawn_time[tip] .. " seconds by " .. en, "rcon", 4 + 8)
                    respawn_cmd_override[tip] = true
                else
                    if (respawn_time[eip] == nil) then
                        respawn_time[eip] = getRSTime(eid)
                    else
                        respawn_time[eip] = time
                    end
                    respawn_cmd_override[eip] = true
                    respond(eid, "Your respawn time was set to " .. respawn_time[eip] .. " seconds", "rcon", 4 + 8)
                end
            end
        end
    end
    return false
end

function velocity:enterVehicle(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil

    local height = params.height or nil
    local distance = params.distance or nil
    local item = params.item or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Enter Vehicle")) then
        if (tLvl >= 1) then
            -- Check if the target is an admin (only admins can use this command)
            if not (is_error) then

                if (distance) then
                    if distance:match("%d+") then
                        distance = tonumber(distance)
                    else
                        respond(eid, "Command failed. Invalid distance parameter")
                    end
                else
                    distance = 2
                end

                if (height) then
                    if height:match("%d+") then
                        height = tonumber(height)
                    else
                        respond(eid, "Command failed. Invalid height parameter")
                    end
                else
                    height = 0.3
                end

                if player_alive(tid) then
                    local x, y, z, is_valid, err, no_match
                    local objects_table = settings.mod["Item Spawner"].objects
                    local player_object = get_dynamic_player(tid)
                    for i = 1, #objects_table do
                        if (item == objects_table[i][1]) and (objects_table[i][2] == "vehi") then
                            if TagInfo(objects_table[i][2], objects_table[i][3]) then
                                if PlayerInVehicle(tid) then
                                    local VehicleID = read_dword(player_object + 0x11C)
                                    if (VehicleID == 0xFFFFFFFF) then
                                        return false
                                    end
                                    local vehicle = get_object_memory(VehicleID)
                                    x, y, z = read_vector3d(vehicle + 0x5c)
                                    ev_OldVehicle[tid] = VehicleID
                                else
                                    x, y, z = read_vector3d(player_object + 0x5c)
                                end

                                local camera_x = read_float(player_object + 0x230)
                                local camera_y = read_float(player_object + 0x234)
                                x = x + camera_x * distance
                                y = y + camera_y * distance
                                z = z + height

                                ev_NewVehicle[tid] = spawn_object("vehi", objects_table[i][3], x, y, z)

                                local multi_control = settings.mod["Enter Vehicle"].multi_control

                                local function Enter(player, vehicle)
                                    enter_vehicle(vehicle, player, 0)
                                    ev[player] = true
                                end

                                -- Multi Control - NOT in vehicle
                                if multi_control and not PlayerInVehicle(tid) then
                                    Enter(tid, ev_NewVehicle[tid])

                                    -- Multi Control - IN vehicle
                                elseif multi_control and PlayerInVehicle(tid) then
                                    Enter(tid, ev_NewVehicle[tid])

                                    -- NO Multi Control - NOT in vehicle
                                elseif not multi_control and not PlayerInVehicle(tid) then
                                    Enter(tid, ev_NewVehicle[tid])

                                    -- NO Multi Control - IN vehicle
                                elseif not multi_control and PlayerInVehicle(tid) then
                                    exit_vehicle(tid)
                                    ev_Status[tid] = true
                                end

                                if ev_NewVehicle[tid] ~= nil then
                                    EV_drone_table[tid] = EV_drone_table[tid] or {}
                                    table.insert(EV_drone_table[tid], ev_NewVehicle[tid])
                                end

                                ev[tid] = true
                                is_valid = true
                            else
                                err = true
                            end
                        else
                            no_match = true
                        end
                    end

                    if (is_valid) then
                        if not (is_self) then
                            respond(tid, "Entering " .. item, "rcon", 4 + 8)
                            respond(eid, "Entering " .. tn .. " into " .. item, "rcon", 4 + 8)
                        else
                            respond(tid, "Entering " .. item, "rcon", 4 + 8)
                        end
                    end
                    if not (is_valid) and (no_match) and not (err) then
                        respond(eid, "Failed to spawn object. [unknown object name]", "rcon", 4 + 8)
                    elseif (is_valid == nil or is_valid == false) and (err) and (no_match) then
                        respond(eid, "Failed to spawn object. [missing tag id]", "rcon", 4 + 8)
                    end
                else
                    if not (is_self) then
                        respond(eid, "Command Failed. " .. tn .. " is dead!", "rcon", 4 + 8)
                    else
                        respond(eid, "Command failed. You are dead. [wait until you respawn]", "rcon", 4 + 8)
                    end
                end
            end
        else
            respond(eid, "Failed to spawn item for " .. tn .. " - [player not admin]", "rcon", 4 + 8)
        end
    end
    return false
end

function velocity:spawnItem(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local item = params.item or nil
    local amount = params.amount or nil

    local tab = settings.mod["Item Spawner"]

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (amount ~= nil) then
        if (amount:match("%d+") and not amount:match("[A-Za-z]")) then
            amount = tonumber(amount)
        else
            respond(eid, "Invalid Command Parameter. [numbers only]", "rcon", 4 + 8)
        end
    else
        amount = 1
    end

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Item Spawner")) then
        if player_alive(tid) then
            local objects_table = tab.objects
            local valid, err
            local sin = math.sin
            for i = 1, #objects_table do
                if (item == objects_table[i][1]) then
                    --if (item:match(objects_table[i][1])) then
                    local tag_type = objects_table[i][2]
                    local tag_name = objects_table[i][3]
                    if TagInfo(tag_type, tag_name) then
                        local function SpawnObject(tid, tag_type, tag_name)
                            local player_object = get_dynamic_player(tid)
                            if player_object ~= 0 then
                                local x_aim = read_float(player_object + 0x230)
                                local y_aim = read_float(player_object + 0x234)
                                local z_aim = read_float(player_object + 0x238)
                                local x = read_float(player_object + 0x5C)
                                local y = read_float(player_object + 0x60)
                                local z = read_float(player_object + 0x64)
                                local obj_x = x + tab.distance_from_playerX * sin(x_aim)
                                local obj_y = y + tab.distance_from_playerY * sin(y_aim)
                                local obj_z = z + 0.3 * sin(z_aim) + 0.5
                                item_objects[tid] = spawn_object(tag_type, tag_name, obj_x, obj_y, obj_z)
                                valid = true
                                if (item_objects[tid]) ~= nil then
                                    IS_drone_table[tid] = IS_drone_table[tid] or {}
                                    table.insert(IS_drone_table[tid], item_objects[tid])
                                end
                            end
                        end
                        for i = 1, amount do
                            SpawnObject(tid, tag_type, tag_name)
                        end
                        if (valid) then
                            local char = getChar(amount)
                            if not (is_self) then
                                respond(eid, "Spawning (" .. amount .. ") " .. objects_table[i][1] .. char .. " for " .. tn, "rcon", 4 + 8)
                                respond(tid, en .. " spawned (" .. amount .. ") " .. objects_table[i][1] .. char .. " for you", "rcon", 4 + 8)
                            else
                                respond(eid, "Spawning (" .. amount .. ") " .. objects_table[i][1] .. char, "rcon", 4 + 8)
                            end
                        end
                    else
                        err = true
                        respond(eid, "Error: Missing tag id for '" .. item .. "' in 'objects' table", "rcon", 4 + 8)
                    end
                    break
                end
            end
            if not (valid) and not (err) then
                respond(tid, "'" .. item .. "' is not a valid object or it is missing in the 'objects' table", "rcon", 4 + 8)
            end
        else
            if not (is_self) then
                respond(eid, "Command Failed. " .. tn .. " is dead!", "rcon", 4 + 8)
            else
                respond(eid, "Command failed. You are dead. [wait until you respawn]", "rcon", 4 + 8)
            end
        end
    end
    return false
end

function velocity:itemSpawnerList(params)
    local params = params or {}
    local eid = params.eid or nil

    local tab = params.table
    local item_list = tab.objects

    local max_columns, max_results = 5, 100
    local startIndex, endIndex = 1, max_columns
    local spaces = 2

    local t, count, total_count = { }, 0, 0
    for k, v in pairs(item_list) do
        local command = item_list[k][1]
        local tag_type = item_list[k][2]
        local tag_name = item_list[k][3]
        if TagInfo(tag_type, tag_name) then
            t[#t + 1] = command
            count = count + 1
        end
        total_count = total_count + 1
    end

    local function formatResults()
        local placeholder, row = { }

        for i = tonumber(startIndex), tonumber(endIndex) do
            if (t) then
                placeholder[#placeholder + 1] = t[i]
                row = FormatTable(placeholder, max_columns, spaces)
            end
        end

        if (row == "") or (row == " ") then
            row = nil -- just in case
        end

        if (row ~= nil) then
            respond(eid, row, "rcon", 2 + 8)
        end

        for a in pairs(placeholder) do
            placeholder[a] = nil
        end

        startIndex = (endIndex + 1)
        endIndex = (endIndex + (max_columns))
    end

    if (#t > 0) then
        while (endIndex < count + max_columns) do
            formatResults()
        end
    end

    if (startIndex >= count) then
        startIndex = 1
        endIndex = max_columns
        respond(eid, "Objects available: (" .. count .. "/" .. total_count .. ")", "rcon", 2 + 8)
    end
end

function velocity:clean(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local identifier = params.table or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Garbage Collection")) then
        local object, proceed
        if identifier:match("%d+") then
            identifier = tonumber(identifier)
            if (identifier > 0) and (identifier < 3) then
                if (identifier == 1) then
                    object = "Enter Vehicle"
                else
                    object = "Item Spawner"
                end
            end
        elseif (identifier == "*" or identifier == "all") then
            identifier = tostring(identifier)
            object = "Enter Vehicle & Item Spawner"
        else
            respond(eid, "Invalid Table ID!", "rcon", 4 + 8)
        end

        if (ev_NewVehicle[tid] ~= nil) or (item_objects[tid] ~= nil) then
            proceed = true
        else
            respond(tid, tn .. " has nothing to clean up", "rcon", 4 + 8)
        end

        if (proceed) then
            CleanUpDrones(tid, identifier)
            if (is_self) then
                respond(eid, "Cleaning up " .. object .. " objects", "rcon", 4 + 8)
            else
                respond(eid, "Cleaning up " .. tn .. "'s " .. object .. " objects", "rcon", 4 + 8)
            end
        end
    end
    return false
end

function velocity:infinityAmmo(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local multiplier = params.multiplier or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Infinity Ammo")) then
        local tab = settings.mod["Infinity Ammo"]
        local function EnableInfAmmo(TargetID, specified, multiplier)
            infammo[TargetID] = true
            frag_check[TargetID] = true
            adjust_ammo(TargetID)
            if specified then
                --if not (lurker[TargetID]) then
                    local mult = tonumber(multiplier)
                    modify_damage[TargetID] = true
                    damage_multiplier[TargetID] = mult
                    respond(TargetID, "[cheat] Infinity Ammo enabled", "rcon", 4 + 8)
                    respond(TargetID, damage_multiplier[TargetID] .. "% damage multiplier applied", "rcon", 4 + 8)
                --else
                    --respond(eid, "Unable to set damage multipliers while in Lurker Mode", "rcon", 4 + 8)
                --end
            else
                respond(TargetID, "[cheat] Infinity Ammo enabled", "rcon", 4 + 8)
                if (tab.announcer) then
                    announceExclude(TargetID, get_var(TargetID, "$name") .. " is now in Infinity Ammo mode.")
                end
            end
        end

        local _min = tab.multiplier_min
        local _max = tab.multiplier_max

        local function validate_multiplier(T3)
            if tonumber(T3) >= tonumber(_min) and tonumber(T3) < tonumber(_max) + 1 then
                return true
            else
                respond(eid, "Invalid multiplier. Choose a number between 0.001-10", "rcon", 4 + 8)
            end
            return false
        end

        if (is_self) then
            if (multiplier == nil) then
                EnableInfAmmo(eid, false, 0)
            elseif multiplier:match("%d+") then
                if validate_multiplier(multiplier) then
                    EnableInfAmmo(eid, true, multiplier)
                end
            elseif (multiplier == "off" or multiplier == "false") then
                DisableInfAmmo(eid)
                respond(eid, "Infinity Ammo disabled.", "rcon", 2 + 8)
                if (tab.announcer) then
                    announceExclude(eid, en .. " is no longer in Infinity Ammo Mode")
                end
            end
        elseif not (is_self) then
            if (multiplier == nil) then
                if player_present(tid) then
                    EnableInfAmmo(tid, false, 0)
                    respond(eid, "[cheat] Infinity Ammo enabled for " .. tn, "rcon", 4 + 8)
                else
                    respond(eid, "Player not present", "rcon", 4 + 8)
                end
            elseif multiplier:match("%d+") then
                if player_present(tid) then
                    if validate_multiplier(multiplier) then
                        EnableInfAmmo(tid, true, multiplier)
                        respond(eid, "[cheat] Infinity Ammo enabled for " .. tn, "rcon", 4 + 8)
                    end
                else
                    respond(eid, "Command failed. Player not online", "rcon", 4 + 8)
                end
            elseif (multiplier == "off") then
                DisableInfAmmo(tid)
                respond(eid, "[cheat] Infinity Ammo disabled for " .. tn, "rcon", 4 + 8)
                if (tab .. announcer) then
                    announceExclude(tid, tn .. " is no longer in Infinity Ammo Mode")
                end
            end
        end
    end
    return false
end

function velocity:cute(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local tab = settings.mod["Cute"]
    local tFormat, eFormat = tab.messages[1], tab.messages[2]

    local tStr = (gsub(gsub(tFormat, "%%executors_name%%", en), "%%target_name%%", tn))

    if (tab.environment == "chat") then
        respond(tid, tStr, "chat", 2 + 8)
    else
        respond(tid, tStr, "rcon", 2 + 8)
    end

    local eStr = (gsub(gsub(eFormat, "%%executors_name%%", en), "%%target_name%%", tn))
    respond(eid, eStr, "rcon", 2 + 8)
    return false
end

function velocity:setwarp(params)
    local params = params or { }
    local eid = params.eid or nil
    local warpname = params.warpname or nil
    local dir = settings.mod["Teleport Manager"].dir

    if not isFileEmpty(dir) then
        local lines = lines_from(dir)
        for _, v in pairs(lines) do
            if (warpname == v:match("[%a%d+_]*")) then
                respond(eid, "That portal name already exists!", "rcon")
                canset[eid] = false
                break
            else
                canset[eid] = true
            end
        end
    else
        canset[eid] = true
    end

    if warpname:match(mapname) then
        respond(eid, "Teleport name cannot be the same as the current map name!", "rcon")
        canset[eid] = false
    end
    if (canset[eid] == true) then
        local x, y, z
        if PlayerInVehicle(eid) then
            x, y, z = read_vector3d(get_object_memory(read_dword(get_dynamic_player(eid) + 0x11C)) + 0x5c)
        else
            x, y, z = read_vector3d(get_dynamic_player(eid) + 0x5C)
        end
        
        x,y,z = format("%0.3f", x), format("%0.3f", y), format("%0.3f", z)

        local file = io.open(dir, "a+")
        local str = warpname .. " [Map: " .. mapname .. "] X " .. x .. ", Y " .. y .. ", Z " .. z
        file:write(str, "\n")
        file:close()
        respond(eid, "Teleport location set to: " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon")
    end
end

function velocity:warp(params)
    local params = params or { }
    local eid = params.eid or nil
    local tid = params.tid or nil
    local en = params.en or nil
    local tn = params.tn or nil
    local warpname = params.warpname or nil
    local dir = settings.mod["Teleport Manager"].dir

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Teleport Manager")) then
        if not isFileEmpty(dir) then
            local found
            local valid
            local lines = lines_from(dir)
            for _, v in pairs(lines) do
                if (warpname == v:match("[%a%d+_]*")) then
                    if (player_alive(tid)) then
                        if find(v, mapname) then
                            found = true
                            -- numbers without decimal points -----------------------------------------------------------------------------
                            local x, y, z
                            if match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                valid = true -- 0
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                valid = true -- *
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                valid = true -- 1
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                valid = true -- 2
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                valid = true -- 3
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                valid = true -- 1 & 2
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                valid = true -- 1 & 3
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                            elseif match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                valid = true -- 2 & 3
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                                -- numbers with decimal points -----------------------------------------------------------------------------
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 0
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- *
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 1
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 2
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 3
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 1 & 2
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 1 & 3
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 2 & 3
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            else
                                respond(eid, "Script Error! Coordinates for that teleport do not match the regex expression", "rcon", 4 + 8)
                                cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4 + 8)
                            end
                            if (v ~= nil and valid) then
                                if not PlayerInVehicle(tid) then
                                    local prevX, prevY, prevZ = read_vector3d(get_dynamic_player(tid) + 0x5C)
                                    previous_location[tid][1] = prevX
                                    previous_location[tid][2] = prevY
                                    previous_location[tid][3] = prevZ
                                    write_vector3d(get_dynamic_player(tid) + 0x5C, tonumber(x), tonumber(y), tonumber(z))
                                    valid = false
                                else
                                    TeleportPlayer(read_dword(get_dynamic_player(tid) + 0x11C), tonumber(x), tonumber(y), tonumber(z) + 0.5)
                                    valid = false
                                end
                                if (is_self) then
                                    respond(eid, "Teleporting to [" .. warpname .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon", 4 + 8)
                                else
                                    respond(eid, "Teleporting " .. tn .. " to [" .. warpname .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon", 4 + 8)
                                    respond(tid, en .. " teleport you to [" .. warpname .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon", 4 + 8)
                                end
                            end
                        else
                            found = true
                            respond(eid, "That warp is not linked to this map", "rcon", 4 + 8)
                        end
                    else
                        found = true
                        respond(eid, "You cannot teleport when dead", "rcon", 4 + 8)
                    end
                end
            end
            if not (found) then
                respond(eid, "That teleport name is not valid", "rcon", 4 + 8)
            end
        else
            respond(eid, "The teleport list is empty!", "rcon", 4 + 8)
        end
    end
    return false
end

function velocity:warpback(params)
    local params = params or { }
    local eid = params.eid or nil
    local tid = params.tid or nil
    local en = params.en or nil
    local tn = params.tn or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Teleport Manager")) then
        if not PlayerInVehicle(tid) then
            if previous_location[tid][1] ~= nil then
                write_vector3d(get_dynamic_player(tid) + 0x5C, previous_location[tid][1], previous_location[tid][2], previous_location[tid][3])
                if (is_self) then
                    respond(eid, "Returning to previous location", "rcon", 4 + 8)
                else
                    respond(eid, "Returning " .. tn .. " to previous location", "rcon", 4 + 8)
                    respond(tid, en " sent you back to your previous location", "rcon", 4 + 8)
                end
                for i = 1, 3 do
                    previous_location[tid][i] = nil
                end
            else
                if (is_self) then
                    respond(eid, "Unable to teleport back! You haven't been anywhere!")
                else
                    respond(eid, "Unable to teleport " .. tn .. " back! They haven't been anywhere!")
                end
            end
        end
    end
end

function velocity:warplist(params)
    local params = params or { }
    local eid = params.eid or nil
    local dir = settings.mod["Teleport Manager"].dir
    if not isFileEmpty(dir) then
        local lines = lines_from(dir)
        for k, v in pairs(lines) do
            if find(v, mapname) then
                found = true
                respond(eid, "[" .. k .. "] " .. v, "rcon", 4 + 8)
            end
        end
        if not (found) then
            respond(eid, "There are no warps for the current map.", "rcon", 4 + 8)
        end
    else
        respond(eid, "The teleport list is empty!", "rcon", 4 + 8)
    end
end

function velocity:warplistall(params)
    local params = params or { }
    local eid = params.eid or nil
    local dir = settings.mod["Teleport Manager"].dir
    if not isFileEmpty(dir) then
        local lines = lines_from(dir)
        for k, v in pairs(lines) do
            respond(eid, "[" .. k .. "] " .. v, "rcon", 2 + 8)
        end
    else
        respond(eid, "The teleport list is empty!", "rcon", 4 + 8)
    end
end

function velocity:delwarp(params)
    local params = params or { }
    local eid = params.eid or nil
    local warpid = params.warpid or nil
    local dir = settings.mod["Teleport Manager"].dir
    if not isFileEmpty(dir) then
        local lines = lines_from(dir)
        local found
        for k, v in pairs(lines) do
            if (k ~= nil) then
                if (warpid == v:match(k)) then
                    found = true
                    if find(v, mapname) then
                        delete_from_file(dir, k, 1)
                        respond(eid, "Successfully deleted teleport id #" .. k, "rcon", 2 + 8)
                    else
                        wait_for_response[eid] = true
                        respond(eid, "Warning: That teleport is not linked to this map.", "rcon", 2 + 8)
                        respond(eid, "Type 'YES' to delete, type 'NO' to cancel.", "rcon", 2 + 8)
                        function getWarp()
                            return tonumber(k)
                        end
                    end
                end
            end
        end
        if not (found) then
            respond(eid, "Teleport Index ID does not exist", "rcon", 2 + 8)
        end
    else
        respond(eid, "The teleport list is empty", "rcon", 2 + 8)
    end
end

function remove_data_log(p)
    local params = { }
    local ip = getip(p, true)
    params.ip, params.save = ip, nil
    Lurker:savetofile(params)
end

function Lurker:set(params)
    local params = params or { }

    local en = params.en or nil
    local eid = params.eid or nil
    if (eid == nil) then
        eid = 0
    end

    local tn = params.tn or nil
    local tip = params.tip or nil

    local tid = params.tid or nil
    if (tid == nil and eid ~= nil) then
        tid = eid
    end

    local option = params.option or nil
    local flag = params.flag or nil
    local mod = settings.mod["Lurker"]
    local is_self
    if (eid == tid) then
        is_self = true
    end

    if isConsole(eid) then
        en = "SERVER"
    end

    Lurker[tip] = Lurker[tip] or { }
    local status = Lurker[tip]
    status.warnings = (status.warnings) or getLurkerWarnings(tip)
    local warnings = status.warnings
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))
    
    local function Enable()
        status.enabled, status.teleport, status.warn = true, false, false
        status.score, status.timer = get_var(tid, "$score"), 0
        
        local p = { }
        p.ip, p.save = tip, true
        Lurker:savetofile(p)
        
        if (mod.invincibility) then
            execute_command("god " .. tid)
        end
        
        if (mod.announce) then
            local mode = "UNKNOWN"
            if (status.mode == "default") then
                if (mod.hide and mod.camouflage) then
                    mode = "C/H"
                elseif (mod.hide and not mod.camouflage) then
                    mode = "H"
                elseif (mod.camouflage and not mod.hide) then
                    mode = "C"
                end
            elseif (status.mode == "hidden") then
                mode = "H"
            elseif (status.mode == "camouflaged") then
                mode = "C"
            end
            local enable_msg = gsub(gsub(mod.onEnableMsg, "%%name%%", tn), "%%mode%%", mode)
            announceExclude(tid, enable_msg)
        end
    end

    local function Disable(tid)
        status.enabled = false
        if (mod.invincibility) then
            execute_command("ungod " .. tid)
        end
        if (mod.announce) then
            announceExclude(tid, gsub(mod.onDisabeMsg, "%%name%%", tn))
        end
        if (mod.speed_boost) then
            execute_command("s " .. tonumber(tid) .. " " .. tonumber(mod.default_running_speed))
        end
        remove_data_log(tid)
        
        if (tLvl >= 1) then -- Only admins can TP back to where they were (exploit prevention)
            --local coords = getXYZ(eid, tid)
            -- if (coords) then
                -- local x, y, z = coords.x, coords.y, coords.z
                -- killSilently(tid)
                -- if not (coords.invehicle) then
                    -- status.spawn_coords = { }
                    -- status.spawn_coords[1], status.spawn_coords[2], status.spawn_coords[3], status.spawn_coords[4] = x, y, z, 0.5
                    -- status.teleport = true
                -- elseif (coords.invehicle) then
                    -- entervehicle[tid].enter = true
                -- end
            -- else
                -- killSilently(tid)
            -- end
        else
            killSilently(tid)            
        end
    end
    
    local cmd_flags, is_error, on_off = mod.cmd_flags
    local function flag_check()    
        local disabled_error, _error_
        if (flag ~= nil) then
            if (flag == cmd_flags[1]) then -- camo only
                if (mod.camouflage) then
                    status.mode = "camouflaged"
                    on_off = "Enabled (with Camouflage)"
                else
                    disabled_error, _error_ = true, "Lurker.camouflage is disabled internally"
                end
            elseif (flag == cmd_flags[2]) then -- hidden only
                if (mod.hide) then
                    status.mode = "hidden"
                    on_off = "Enabled (hidden only)"
                else
                    disabled_error, _error_ = true, "Lurker.hide is disabled internally"
                end
            elseif (flag == cmd_flags[3]) then -- camouflage + hidden
                if (mod.camouflage) and (mod.hide) then
                    status.mode = "camouflaged_and_hidden"
                    on_off = "Enabled (Hidden with Camouflage)"
                else
                    disabled_error, _error_ = true, "Lurker.camouflage & Lurker.hide are disabled internally"
                end
            else
                is_error, disabled_error = true, true
                respond(eid, "Invalid Syntax: Usage: /" .. mod.base_command .. " on|off [me | id | */all] <flag>", "rcon", 4 + 8)
            end
            if not (disabled_error) then
                return true
            elseif not (is_error) then
                is_error = true
                respond(eid, "Command failed! (" .. _error_ .. ")", "rcon", 4+8)
                return false
            end
        else
            status.mode = "default"
            on_off = "Enabled"
            return true
        end
    end
    
    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Lurker")) then
        if (tonumber(warnings) > 0) then
            local already_set
            if (option == "on") or (option == "1") or (option == "true") then     
                if (status.enabled ~= true) then
                    if flag_check() then
                        already_set, is_error = false, false
                        Enable(tid, tn)
                    end
                else
                    on_off, already_set, is_error = "Enabled", true, false
                end
            elseif (option == "off") or (option == "0") or (option == "false") then
                if (status.enabled ~= false and status.enabled ~= nil) then
                    on_off, already_set, is_error = "Disabled", false, false
                    Disable(tid, tn)
                else
                    on_off, already_set, is_error = "Disabled", true, false
                end
            else
                is_error = true
                respond(eid, "Invalid Syntax: Usage: /" .. mod.base_command .. " on|off [me | id | */all] <flag>", "rcon", 4 + 8)
            end
            if not (is_error) and not (already_set) then
                if not (is_self) then
                    respond(eid, "Lurker " .. on_off .. " for " .. tn, "rcon", 2 + 8)
                    respond(tid, "Lurker Mode was " .. on_off .. " by " .. en, "rcon")
                else
                    respond(eid, "Lurker Mode " .. on_off, "rcon", 2 + 8)
                end
            elseif (already_set) then
                respond(eid, "[SERVER] -> " .. tn .. ", Lurker already " .. on_off, "rcon", 4 + 8)
            end
        else
            if not (is_self) then
                respond(eid, tn .. "'s Lurker has been revoked! [no warnings left]", "rcon", 2 + 8)
            else
                respond(tid, "Your Lurker Mode was auto-revoked! [no warnings left]", "rcon", 2 + 8)
            end
        end
    end
    return false
end

-- #Suggestions Box
function velocity:suggestion(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil
    local content = params.message or nil
    local msg_format = params.format or nil
    local dir = params.dir or nil
    if isConsole(eid) then
        en = "SERVER"
    end
    local t, text = {}
    t[#t + 1] = content
    if (t) then
        local file = io.open(dir, "a+")
        if (file) then
            for _, v in pairs(t) do
                text = v
            end
            local timestamp = os.date("%d/%m/%Y - %H:%M:%S")
            local str = gsub(gsub(gsub(msg_format, "%%time_stamp%%", timestamp), "%%player_name%%", en), "%%message%%", text .. "\n")
            file:write(str)
            file:close()
            local tab = settings.mod["Suggestions Box"]
            respond(eid, gsub(tab.response, "%%player_name%%", en), "rcon", 7 + 8)
            respond(eid, "------------ [ MESSAGE ] ------------------------------------------------", "rcon", 7 + 8)
            respond(eid, tostring(text), "rcon", 7 + 8)
            respond(eid, "-------------------------------------------------------------------------------------------------------------", "rcon", 7 + 8)
        end
    end
    for _ in pairs(t) do
        _ = nil
    end
end

-- #Private Messaging System
function privateMessage:send(params)
    local params = params or {}

    local eid = params.eid or nil
    local eip = params.eip or nil

    local en = params.en or nil
    if isConsole(eid) then
        en = "SERVER"
    end

    local recipient_id = params.recipient_id or nil

    local function isSelf()
        if (tonumber(eid) == tonumber(recipient_id)) or (tostring(eip) == tostring(recipient_id)) then
            respond(eid, "You cannot send yourself private messages!", "rcon", 4 + 8)
            return true
        end
    end

    local ip_match = recipient_id:match("(%d+.%d+.%d+.%d+)")
    local player_id = tonumber(recipient_id:match("%d+"))
    local exclude = recipient_id:match('[A-Za-z]')

    local valid_recipient
    if (recipient_id) then
        if (ip_match) and not (exclude) then
            if not isSelf() then
                valid_recipient = true
            end
        elseif (player_id) and not (exclude) then
            if (player_id > 0 and player_id < 17) then
                if not isSelf() then
                    if player_present(player_id) then
                        valid_recipient = true
                    else
                        respond(eid, "Player (#" .. player_id .. ") not online!", "rcon", 4 + 8)
                        respond(eid, "To message OFFLINE players please enter their IP Address instead.", "rcon", 4 + 8)
                    end
                end
            end
        else
            respond(eid, "----- [ Invalid User ID ] -----", "rcon", 4 + 8)
            respond(eid, "To message ONLINE players please enter their Index ID", "rcon", 4 + 8)
            respond(eid, "To message OFFLINE players please enter their IP Address", "rcon", 4 + 8)
        end
    end

    local tab = settings.mod["Private Messaging System"]

    local proceed
    local function msgCheck()
        local t, len = {}
        local message = params.message or nil
        local max_char = tab.max_characters
        t[#t + 1] = message
        for _, v in pairs(t) do
            if (t) then
                len = string.len(v)
                if (len < max_char) then
                    t[1] = v
                    proceed = true
                    return t[1]
                else
                    local char = getChar(max_char)
                    respond(eid, "Your message is too long! (max " .. max_char .. " character" .. char .. ")", "rcon", 7 + 8)
                    break
                end
            end
        end
        for _ in pairs(t) do
            _ = nil
        end
    end

    if (valid_recipient) then
        local text = msgCheck()
        local t = { }
        t[#t + 1] = text
        if (t) and (proceed) then

            local time_stamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            local message = tostring(t[1])
            local str = recipient_id .. tab.seperator .. " " .. time_stamp .. tab.seperator .. " " .. en .. tab.seperator .. message

            local function tellAdmins()
                for i = 0, 16 do
                    if player_present(i) and isAdmin(i) then
                        if (i ~= eid) and (i ~= player_id) then
                            rprint(i, "[PM SPY] " .. en .. " ->" .. recipient_id)
                            rprint(i, message)
                        end
                    end
                end
            end

            if (ip_match) then
                local dir = params.dir or nil
                local file = io.open(dir, "a+")
                if (file) then
                    file:write(str .. "\n")
                    file:close()
                    respond(eid, tab.send_response, "rcon", 7 + 8)
                    respond(eid, "------------ [ MESSAGE ] ------------------------------------------------", "rcon", 7 + 8)
                    respond(eid, "[you] -> " .. recipient_id, "rcon", 7 + 8)
                    respond(eid, message, "rcon", 7 + 8)
                    respond(eid, "-------------------------------------------------------------------------------------------------------------", "rcon", 7 + 8)
                end
            elseif (player_id) then
                respond(player_id, "New Private Message from: " .. en, "rcon", 7 + 8)
                respond(player_id, message, "rcon", 7 + 8)

                respond(eid, "Message Sent to " .. get_var(player_id, "$name"), "rcon", 7 + 8)
                respond(eid, message, "rcon", 7 + 8)
            end
            tellAdmins()
        end
    end
end

-- #Private Messaging System
function privateMessage:load(params)
    local params = params or {}
    local ip = params.eip or nil
    local tab = settings.mod["Private Messaging System"]
    local lines = lines_from(tab.dir)

    unread_mail[ip] = { }
    for _, v in pairs(lines) do
        if (v:match(ip)) then
            unread_mail[ip][#unread_mail[ip] + 1] = v
        end
    end
    return unread_mail[ip]
end

-- #Private Messaging System
function privateMessage:getMailList()
    local tab = settings.mod["Private Messaging System"]
    local lines = lines_from(tab.dir)
    local t = { }
    for _, v in pairs(lines) do
        t[#t + 1] = v
    end
    return t
end

-- #Private Messaging System
function privateMessage:read(params)
    local params = params or {}
    local eid = params.eid or nil
    local eip = params.eip or nil
    local mail = params.mail or nil
    local tab = settings.mod["Private Messaging System"]
    local page = params.page

    local proceed
    if (page:match("%d+")) and not page:match('[A-Za-z]') then
        proceed = true
    end

    if (proceed) then
        local has_mail
        local function hasMail(has_mail)
            local count = #unread_mail[eip]
            if (has_mail) and (count > 0) then
                local maxpages = getPageCount(count, tab.max_results_per_page)
                respond(eid, "Viewing Page (" .. page .. "/" .. maxpages .. "). Total Messages: " .. count, "rcon", 2 + 8)
            end
        end

        if (#mail > 0) then

            local table = { }
            local list = privateMessage:getMailList()
            local p = { }
            p.table, p.page = tab, page
            local startpage, endpage = select(1, getPage(p)), select(2, getPage(p))

            for page_num = startpage, endpage do
                if (list[page_num]) then
                    for k, v in pairs(list) do
                        if (k == page_num) and (v:match(eip)) then
                            table[#table + 1] = (list[page_num] .. tab.seperator .. k)
                        end
                    end
                end
            end

            if (#table > 0) then
                for _, v in pairs(table) do
                    local data = stringSplit(v, tab.seperator)
                    if (data) then
                        local result, i = { }, 1
                        for j = 1, 5 do
                            if (data[j] ~= nil) then
                                result[i] = data[j]
                                i = i + 1
                            end
                        end
                        if (result ~= nil) then
                            has_mail = true
                            local tab = tab.read_format
                            local a, b, c
                            for k = 1, #tab do
                                if tab[k]:match("%%index%%") then
                                    a = gsub(tab[k], "%%index%%", result[5])
                                elseif tab[k]:match("%%sender_name%%") then
                                    b = gsub(tab[k], "%%sender_name%%", result[3])
                                elseif tab[k]:match("%%time_stamp%%") then
                                    c = gsub(tab[k], "%%time_stamp%%", result[2])
                                elseif tab[k]:match("%%msg%%") then
                                    d = gsub(tab[k], "%%msg%%", result[4])
                                end
                            end
                            local temp = {}
                            temp[#temp + 1] = { ["index"] = a, ["name"] = b, ["time_stamp"] = c, ["msg"] = d }

                            local function get(ID)
                                for key, _ in ipairs(temp) do
                                    return temp[key][ID]
                                end
                            end

                            local sender_name = get("name")
                            local time_stamp = get("time_stamp")
                            local msg = get("msg")
                            local index = get("index")

                            local seperator = "|c"
                            respond(eid, "[#" .. index .. "] " .. sender_name .. seperator .. time_stamp, "rcon", 2 + 8)
                            respond(eid, msg, "rcon", 2 + 8)
                            respond(eid, " ", "rcon", 2 + 8)
                        end
                    end
                end
            else
                respond(eid, "Nothing to show", "rcon", 2 + 8)
            end
        else
            respond(eid, "You have no mail", "rcon", 2 + 8)
        end
        hasMail(has_mail)
    else
        respond(eid, "Invalid Page Number", "rcon", 2 + 8)
    end
end

-- #Private Messaging System
function privateMessage:delete(params)
    local params = params or {}
    local mail = params.mail or nil
    if (#mail > 0) then
        local eid = params.eid or nil
        local eip = params.eip or nil

        local mail_id = params.mail_id or nil
        local delete_all

        if (mail_id == "*" or mail_id == "all") then
            delete_all = true
        else
            mail_id = tonumber(mail_id)
        end

        local tab = settings.mod["Private Messaging System"]
        local dir = tab.dir

        local found, _error_
        if not (delete_all) then
            for k, v in pairs(lines_from(dir)) do
                if (k ~= nil) then
                    if (mail_id == k) and (v:match(eip)) then
                        respond(eid, "Message [#" .. k .. "] deleted", "rcon", 2 + 8)
                        delete_from_file(dir, k, 1)
                        found, _error_ = true, false
                        break
                    end
                end
            end
        elseif (#unread_mail[eip] > 0) then
            local function delete()
                for k, v in pairs(lines_from(dir)) do
                    if (k ~= nil) and (v:match(eip)) then
                        delete_from_file(dir, k, 1)
                        found, _error_ = true, false
                        break
                    end
                end
            end
            for i = 1, #unread_mail[eip] do
                delete()
            end
            respond(eid, "Deleted (" .. #unread_mail[eip] .. ") messages", "rcon", 2 + 8)
            unread_mail[eip] = nil
        else
            respond(eid, "Nothing to Delete!", "rcon", 2 + 8)
        end

        if not (found) and not (_error_) then
            respond(eid, "Invalid #Mail ID", "rcon", 2 + 8)
        end
    end
end

-- #Alias System
function velocity:cmdRoutine(params)
    local params = params or {}
    local eid = params.eid or nil
    local eip = params.eip or nil
    local use_timer = params.timer or nil
    local current_page = params.page or nil

    if (current_page == nil) then
        current_page = 1
    end

    local tab = players["Alias System"][eip]
    local settings = settings.mod["Alias System"]
    local max_results = settings.max_results_per_page

    tab.target_hash = params.th
    tab.target_name = params.tn
    tab.eid = eid

    local aliases, content
    local directory = settings.dir
    local lines = lines_from(directory)
    for _, v in pairs(lines) do
        if (v:match(tab.target_hash)) then
            content = stringSplit(v:match(":(.+)"), ",")
            alias_results[eip][#alias_results[eip] + 1] = content
        end
    end

    for i = 1, #known_pirated_hashes do
        if (tab.target_hash == known_pirated_hashes[i]) then
            tab.shared = true
        end
    end

    for i = 1, #alias_results[eip][1] do
        if (alias_results[eip][1][i]) then
            tab.total_count = tab.total_count + 1
        end
    end

    local p, table = { }, { }
    p.table, p.page = settings, current_page
    local startpage, endpage = select(1, getPage(p)), select(2, getPage(p))
    for page_num = startpage, endpage do
        if (alias_results[eip][1][page_num]) then
            table[#table + 1] = alias_results[eip][1][page_num]
        end
    end

    local pages = getPageCount(tab.total_count, max_results)

    if (#table > 0) then
        alias_results[eip][1] = { }

        for k, v in pairs(table) do
            alias_results[eip][1][k] = v
        end

        for i = 1, max_results do
            if (alias_results[eip][1][i]) then
                tab.current_count = tab.current_count + 1
            end
        end

        tab.current_page = current_page
        tab.total_pages = pages
        tab.results = alias_results[eip][1]
        tab.max_results = max_results

        if (use_timer) then
            tab.trigger = true
            tab.bool = true
        else
            alias:show(tab)
        end
    else
        respond(eid, "Invalid Page ID. Valid pages: 1 to " .. pages, "rcon", 2 + 8)
    end
end

-- #Alias System
function alias:show(tab)
    alias:align(tab)
end

-- #Alias System
function alias:align(tab)
    local tab = tab or { }
    if (tab) then

        local executor = tab.eid

        local current_page = tab.current_page
        local total_pages = tab.total_pages
        local total_aliases = tab.total_aliases

        local current_count = tab.current_count
        local total_count = tab.total_count

        local target_hash = tab.target_hash
        local target_name = tab.target_name
        local pirated = tab.shared
        local results = tab.results
        local max_results = tab.max_results

        local alignment = settings.mod["Alias System"].alignment

        if not isConsole(executor) then
            cls(executor, 25)
        else
            alignment = ""
        end

        local function formatResults()
            local placeholder, row = { }

            for i = tonumber(startIndex), tonumber(endIndex) do
                if (results) then
                    placeholder[#placeholder + 1] = results[i]
                    row = FormatTable(placeholder, max_columns, spaces)
                end
            end

            if (row == "") or (row == " ") then
                row = nil -- just in case
            end

            if (row ~= nil) then
                respond(executor, alignment .. " " .. row, "rcon")
            end

            for a in pairs(placeholder) do
                placeholder[a] = nil
            end

            startIndex = (endIndex + 1)
            endIndex = (endIndex + (max_columns))
        end

        while (endIndex < total_count + max_columns) do
            formatResults()
        end

        if (startIndex >= total_count) then
            startIndex = initialStartIndex
            endIndex = max_columns
        end

        respond(executor, " ", "rcon", 2 + 8)
        --[Page X/X] Showing (X/X) aliases for xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 
        respond(executor, alignment .. " " .. '[Page ' .. current_page .. '/' .. total_pages .. '] Showing (' .. current_count .. '/' .. total_count .. ') aliases for: "' .. target_hash .. '"', "rcon", 2 + 8)
        if (pirated) then
            respond(executor, alignment .. " " .. target_name .. ' is using a pirated copy of Halo.', "rcon", 2 + 8)
        end
    end
end

-- #Alias System
function resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            if (tonumber(get_var(i, "$lvl")) >= settings.mod["Alias System"].permission_level) then
                local ip = getip(i, true)
                alias:reset(ip)
            end
        end
    end
end

-- #Alias System
function alias:add(name, hash)
    local dir = settings.mod["Alias System"].dir
    local lines = lines_from(dir)
    local data, alias, name_found, index
    for k, v in pairs(lines) do
        if (v:match(hash)) then
            data = stringSplit(gsub(v, hash .. ":", ""), ",")
            alias = v .. "," .. name
            index, value = k, v
        end
    end

    if (data) then
        local result, i = { }, 1
        for j = 1, #data do
            if (data[j] ~= nil) then
                result[i] = data[j]
                i = i + 1
            end
        end
        if (result ~= nil) then

            for i = 1, #result do
                if (name == result[i]) then
                    -- Name entry already exists for this hash: (do nothing).
                    name_found = true
                    break
                end
            end

            if not (name_found) then
                -- Name entry does not eist for this hash: (create new name entry).
                delete_from_file(dir, index, 1)
                local file = assert(io.open(dir, "a+"))
                file:write(alias .. "\n")
                file:close()
            end
        end
    else
        -- Hash entry does not exist in the database: (create entry).
        local file = assert(io.open(dir, "a+"))
        file:write(hash .. ":" .. name .. "\n")
        file:close()
    end
end

function velocity:CommandSpy(Message)
    for i = 1, 16 do
        local level = get_var(i, "$lvl")
        if tonumber(level) >= getPermLevel("Command Spy", false) then
            respond(i, Message, "rcon", 2 + 8)
        end
    end
end

-- #Mute System
function velocity:saveMute(params, bool, showMessage)
    local params = params or { }

    local ip = params.tip or nil
    local name = params.tn or nil
    local eid = params.eid or nil
    local en = params.en or nil
    local tid = params.tid or nil
    local time = params.time or nil

    local proceed
    if not (settings.mod["Mute System"].can_mute_admins) then
        if tonumber(get_var(tid, "$lvl")) >= 1 then
            proceed = false
        else
            proceed = true
        end
    else
        proceed = true
    end

    if (proceed) then
        mute_table[ip] = mute_table[ip] or { }
        mute_table[ip].muted = true
        mute_table[ip].timer = 0
        mute_table[ip].remaining = time
        mute_table[ip].duration = time

        local dir = settings.mod["Mute System"].dir

        local lines, found = lines_from(dir)
        for _, v in pairs(lines) do
            if (v:match(ip)) then
                found = true
                local fRead = io.open(dir, "r")
                local content = fRead:read("*all")
                fRead:close()
                content = gsub(content, v, ip .. ", " .. name .. ", " .. time)
                local fWrite = io.open(dir, "w")
                fWrite:write(content)
                fWrite:close()
            end
        end
        if not (found) then
            local file = assert(io.open(dir, "a+"))
            file:write(ip .. ", " .. name .. ", " .. time .. "\n")
            file:close()
        end
        if (bool) and (showMessage) then
            if (mute_table[ip].duration == default_mute_time) then
                respond(tid, "You are muted permanently", "rcon", 2 + 8)
                if (eid ~= nil) then
                    respond(eid, name .. " was muted permanently", "rcon", 2 + 8)
                    for i = 1, 16 do
                        if tonumber(get_var(i, "$lvl")) >= 1 and (i ~= eid) then
                            respond(i, name .. " was muted permanently by " .. en, "rcon", 2 + 8)
                        end
                    end
                end
            else
                local char = getChar(mute_table[ip].duration)
                respond(tid, "You were muted! Time remaining: " .. mute_table[ip].duration .. " minute" .. char, "rcon", 2 + 8)
                if (eid ~= nil) then
                    respond(eid, name .. " was muted for " .. mute_table[ip].duration .. " minute" .. char, "rcon", 2 + 8)
                    for i = 1, 16 do
                        if tonumber(get_var(i, "$lvl")) >= 1 and (i ~= eid) then
                            respond(i, name .. " was muted for " .. mute_table[ip].duration .. " minute" .. char .. " by " .. en, "rcon", 2 + 8)
                        end
                    end
                end
            end
        end
    else
        respond(eid, "Unable to mute " .. name .. ". [can_mute_admins is disabled]", "rcon", 4 + 8)
    end
end

-- #Mute System
function velocity:unmute(params)
    local params = params or { }

    local ip = params.tip or nil
    local name = params.tn or nil
    local eid = params.eid or nil
    local tid = params.tid or nil
    local en = params.en or nil

    local proceed
    if not (settings.mod["Mute System"].can_mute_admins) then
        if tonumber(get_var(tid, "$lvl")) >= 1 then
            proceed = false
        else
            proceed = true
        end
    else
        proceed = true
    end

    if (proceed) then
        local dir = settings.mod["Mute System"].dir
        local lines = lines_from(dir)
        for _, v in pairs(lines) do
            if (v:match(ip)) then
                local fRead = io.open(dir, "r")
                local content = fRead:read("*all")
                fRead:close()
                local file = io.open(dir, "w")
                content = gsub(content, v, "")
                file:write(content)
                file:close()
                mute_table[ip] = { }
            end
        end

        if (eid ~= nil and eid == 0) or (eid == nil) then
            en = 'SERVER'
            id = 0
        elseif (eid ~= nil and eid > 0) then
            en = en
            id = eid
        end
        respond(tid, "You were unmuted by " .. en, "rcon", 2 + 8)
        respond(id, name .. " was unmuted by " .. en, "rcon", 2 + 8)
    else
        respond(eid, "Unable to unmute " .. name .. ". [can_mute_admins is disabled]", "rcon", 4 + 8)
    end
end

-- #Mute System
function velocity:loadMute(params)
    local params = params or { }
    local ip = params.tip or nil
    local dir = settings.mod["Mute System"].dir
    local content, data

    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if (v:match(ip)) then
            data = stringSplit(v, ",")
        end
    end

    if (data) then
        local result, i = { }, 1
        for j = 1, 3 do
            if (data[j] ~= nil) then
                result[i] = data[j]
                i = i + 1
            end
        end
        if (result ~= nil) then
            return result
        end
    end
end

-- #Mute System
function velocity:mutelist(params)
    local params = params or { }
    local eid = params.eid or nil
    local flag = params.flag or nil
    local dir = settings.mod["Mute System"].dir

    respond(eid, "----------- IP - NAME - TIME REMAINING (in minutes) ----------- ", "rcon", 7 + 8)

    local lines = lines_from(dir)
    for k, v in pairs(lines) do
        if (k ~= nil) then
            if (flag == nil) then
                respond(eid, v, "rcon", 2 + 8)
            elseif (flag == "-o") then
                local count = 0
                for i = 1, 16 do
                    if player_present(i) then
                        count = count + 1
                        local p = { }
                        p.tip = getip(i, true)
                        local muted = velocity:loadMute(p)
                        if (p.tip == muted[1]) then
                            local char = getChar(muted[3])
                            respond(eid, get_var(i, "$name") .. " [" .. tonumber(i) .. "]: " .. muted[3] .. " minute" .. char .. " left", "rcon", 7 + 8)
                        end
                    end
                end
                if (count == 0) then
                    respond(eid, "Nobody online is currently muted.", "rcon", 4 + 8)
                    break
                end
            else
                respond(eid, "Invalid syntax. Usage: /" .. mutelist_command .. " <flag>", "rcon", 2 + 8)
                break
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- #Lurker
    if modEnabled("Lurker") then
        local mod = settings.mod["Lurker"]
        if (mod.block_damage) then
            if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
                local vip, kip = getip(PlayerIndex, true), getip(CauserIndex, true)
                local v, k = Lurker[vip], Lurker[kip]
                if (v ~= nil or k ~= nil) and (v.enabled or k.enabled) then
                    return false
                end
            end
        end
    end
    -- #Infinity Ammo
    if modEnabled("Infinity Ammo") then
        if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
            if (modify_damage[CauserIndex] == true) then
                return true, Damage * tonumber(damage_multiplier[CauserIndex])
            end
        end
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    if modEnabled("Lurker") then
        local ip = getip(PlayerIndex, true)
        local status = Lurker[ip]

        if (status ~= nil and status.enabled) then
            if (tonumber(Type) == 1) then
                if hasObjective(PlayerIndex, WeaponIndex) then
                
                    -- Every time you pick up the flag, you will lose one warning point.
                    status.warnings = (status.warnings - 1)
                    status.warn = true
                    execute_command("s " .. tonumber(PlayerIndex) .. " 0")

                    if (status.warnings <= 0) then
                        status.warnings = 0
                    end
                end
            end
        end
    end
    -- #Infinity Ammo
    if (modEnabled("Infinity Ammo", PlayerIndex) and infammo[PlayerIndex]) then
        adjust_ammo(PlayerIndex)
    end
end

function OnWeaponDrop(PlayerIndex)
    if modEnabled("Lurker") then
    
        local ip = getip(PlayerIndex, true)
        local status = Lurker[ip]
        
        if (status ~= nil and status.enabled) and (status.warn) then
            local mod = settings.mod["Lurker"]
            status.warn, status.timer = false, 0
            -- APPLY SPEED - player was frozen when `OnWeaponPickup()` was called.
            execute_command("s " .. tonumber(PlayerIndex) .. " " .. tonumber(mod.running_speed))
        end
    end
end

function TeleportPlayer(ObjectID, x, y, z)
    if (get_object_memory(ObjectID) ~= 0) then
        local veh_obj = get_object_memory(read_dword(get_object_memory(ObjectID) + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or get_object_memory(ObjectID)) + 0x5C, x, y, z)
    end
end

function hasObjective(PlayerIndex, WeaponIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    local weaponId = read_dword(player_object + 0x118)
    if (weaponId ~= 0) then
        local ip = getip(PlayerIndex, true)
        local status = Lurker[ip]
        
        local weapon_object = get_object_memory(read_dword(player_object + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4))
        local tag_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
        
        for j = 0, 3 do    
            local weapon = read_dword(player_object + 0x2F8 + 4 * j)
            if (weapon == red_flag) or (weapon == blue_flag) then
                status.objective = "flag"
                return true
            elseif (tag_name ~= nil and tag_name == "weapons\\ball\\ball") then
                status.objective = "oddball"
                return true
            end
        end
    end
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if (PlayerIndex) then
        -- #Infinity Ammo
        if (modEnabled("Infinity Ammo") and infammo[PlayerIndex]) then
            adjust_ammo(PlayerIndex)
        end
    end
end

-- #Infinity Ammo
function getFrags(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) and player_present(PlayerIndex) then
        safe_read(true)
        local frags = read_byte(player_object + 0x31E)
        local plasmas = read_byte(player_object + 0x31F)
        safe_read(false)
        if tonumber(frags) <= 0 or tonumber(plasmas) <= 0 then
            return true
        end
    end
    return false
end

function killSilently(PlayerIndex)
    if DeleteWeapons(PlayerIndex) then
        local kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
        local original = read_dword(kill_message_addresss)
        safe_write(true)
        write_dword(kill_message_addresss, 0x03EB01B1)
        safe_write(false)
        execute_command("kill " .. tonumber(PlayerIndex))
        safe_write(true)
        write_dword(kill_message_addresss, original)
        safe_write(false)
        write_dword(get_player(PlayerIndex) + 0x2C, 0 * 33)
        -- Deduct one death
        local deaths = tonumber(get_var(PlayerIndex, "$deaths"))
        execute_command("deaths " .. tonumber(PlayerIndex) .. " " .. deaths - 1)
    end
end

function CleanUpDrones(TargetID, TableID)
    -- Enter Vehicle
    local function CleanVehicles(TargetID)
        if EV_drone_table[TargetID] ~= nil then
            for k, v in pairs(EV_drone_table[TargetID]) do
                if EV_drone_table[TargetID][k] > 0 then
                    if v then
                        DestroyObject(v)
                        EV_drone_table[TargetID][k] = nil
                    end
                end
            end
            EV_drone_table[TargetID] = nil
            ev_NewVehicle[TargetID] = nil
        end
    end

    -- Item Spawner
    local function CleanItems(TargetID)
        if IS_drone_table[TargetID] ~= nil then
            for k, v in pairs(IS_drone_table[TargetID]) do
                if IS_drone_table[TargetID][k] > 0 then
                    if v then
                        DestroyObject(v)
                        IS_drone_table[TargetID][k] = nil
                    end
                end
            end
            IS_drone_table[TargetID] = nil
            item_objects[TargetID] = nil
        end
    end

    if (TableID == 1) then
        CleanVehicles(TargetID)
    elseif (TableID == 2) then
        CleanItems(TargetID)
    elseif (TableID == "all" or TableID == "*") then
        CleanVehicles(TargetID)
        CleanItems(TargetID)
    end
end

-----------------------------------------------------------------------------------------------
-- FUNCTIONS USED THROUGHOUT

function PlayerInVehicle(PlayerIndex)
    if (get_dynamic_player(PlayerIndex) ~= 0) then
        local VehicleID = read_dword(get_dynamic_player(PlayerIndex) + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function checkFile(directory)
    local file = io.open(directory, "rb")
    if file then
        file:close()
        return true
    else
        local file = io.open(directory, "a+")
        if file then
            file:close()
            return true
        end
    end
end

-- #Lurker
function isInLurker(ip)
    local dir = settings.mod["Lurker"].dir
    local lines = lines_from(dir)
    local p = { }
    for k, v in pairs(lines) do
        if (v:match(ip)) then
            p.k, p.v = k, v
            return p
        end
    end
end

-- #Lurker
function Lurker:savetofile(params)
    local params = params or { }
    local ip = params.ip or nil
    local save = params.save
    local dir = settings.mod["Lurker"].dir
    
    local p = isInLurker(ip)
    
    if (p) then
        if not (save) then
            delete_from_file(dir, p.k, 1)
        else
            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()
            content = gsub(content, p.v, ip)
            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    elseif (save) then
        local file = assert(io.open(dir, "a+"))
        file:write(ip .. "\n")
        file:close()
    end
end

function cls(PlayerIndex, count)
    if (PlayerIndex) then
        for _ = 1, count do
            respond(PlayerIndex, " ", "rcon")
        end
    end
end

function getTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
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

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function respond(executor, message, environment, color)
    if (executor) then
        color = color or 4 + 8
        if not (isConsole(executor)) then
            if (environment == "chat") then
                Say(executor, message)
            elseif (environment == "rcon") then
                rprint(executor, message)
            end
        else
            cprint(message, color)
        end
    end
end

-- #Custom Weapons
function loadWeaponTags()

    -- [ stock weapons ]
    pistol = "weapons\\pistol\\pistol"
    sniper = "weapons\\sniper rifle\\sniper rifle"
    plasma_cannon = "weapons\\plasma_cannon\\plasma_cannon"
    rocket_launcher = "weapons\\rocket launcher\\rocket launcher"
    plasma_pistol = "weapons\\plasma pistol\\plasma pistol"
    plasma_rifle = "weapons\\plasma rifle\\plasma rifle"
    assault_rifle = "weapons\\assault rifle\\assault rifle"
    flamethrower = "weapons\\flamethrower\\flamethrower"
    needler = "weapons\\needler\\mp_needler"
    shotgun = "weapons\\shotgun\\shotgun"

    -- [ custom weapons ]
    -- snowdrop
    battle_rifle = "halo3\\weapons\\battle rifle\\tactical battle rifle"
end

function getXYZ(e, t)
    local x, y, z
    local player_object = get_dynamic_player(t)
    if (player_object ~= 0) then
        if player_alive(t) then
            local coords = { }
            if PlayerInVehicle(t) then
                coords.invehicle = true
                local VehicleID = read_dword(player_object + 0x11C)
                local vehicle = get_object_memory(VehicleID)
                x, y, z = read_vector3d(vehicle + 0x5c)
                local seat = read_word(player_object + 0x2F0)
                entervehicle[t] = { }
                entervehicle[t].vehicle = VehicleID
                entervehicle[t].seat = seat
            else
                coords.invehicle = false
                x, y, z = read_vector3d(player_object + 0x5c)
            end
            x, y, z = format("%0.3f", x), format("%0.3f", y), format("%0.3f", z)
            coords.x, coords.y, coords.z = x, y, z
            return coords
        elseif (e) then
            respond(e, get_var(t, "$name") .. " is dead! Please wait until they respawn.", "rcon", 4 + 8)
        end
    end
end

function cmdsplit(str)
    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1, string.len(str) do
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

function DestroyObject(object)
    if (object) then
        destroy_object(object)
    end
end

function DeleteWeapons(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        write_word(player_object + 0x31E, 0)
        write_word(player_object + 0x31F, 0)
        local weaponId = read_dword(player_object + 0x118)
        if (weaponId ~= 0) then
            for j = 0, 3 do
                local weapon = read_dword(player_object + 0x2F8 + 4 * j)
                if (weapon ~= red_flag) and (weapon ~= blue_flag) then
                    DestroyObject(weapon)
                end
            end
        end
        return true
    end
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return concat(byte_table)
end

function getPlayer(PlayerIndex)
    if tonumber(PlayerIndex) then
        if tonumber(PlayerIndex) ~= 0 then
            local player = get_player(PlayerIndex)
            if (player ~= 0) then
                return player
            end
        end
    end
    return nil
end

function secondsToTime(seconds, places)

    local years = floor(seconds / (60 * 60 * 24 * 365))
    seconds = seconds % (60 * 60 * 24 * 365)
    local weeks = floor(seconds / (60 * 60 * 24 * 7))
    seconds = seconds % (60 * 60 * 24 * 7)
    local days = floor(seconds / (60 * 60 * 24))
    seconds = seconds % (60 * 60 * 24)
    local hours = floor(seconds / (60 * 60))
    seconds = seconds % (60 * 60)
    local minutes = floor(seconds / 60)
    seconds = seconds % 60

    if (places == 6) then
        return format("%02d:%02d:%02d:%02d:%02d:%02d", years, weeks, days, hours, minutes, seconds)
    elseif (places == 5) then
        return format("%02d:%02d:%02d:%02d:%02d", weeks, days, hours, minutes, seconds)
    elseif not (places) or (places == 4) then
        return days, hours, minutes, seconds
    elseif (places == 3) then
        return format("%02d:%02d:%02d", hours, minutes, seconds)
    elseif (places == 2) then
        return format("%02d:%02d", minutes, seconds)
    elseif (places == 1) then
        return format("%02", seconds)
    end
end

function delete_from_file(dir, start_index, end_index)
    local fp = io.open(dir, "r")
    local t = {}
    i = 1;
    for line in fp:lines() do
        if i < start_index or i >= start_index + end_index then
            t[#t + 1] = line
        end
        i = i + 1
    end
    if i > start_index and i < start_index + end_index then
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open(dir, "w+")
    for i = 1, #t do
        fp:write(format("%s\n", t[i]))
    end
    fp:close()
end

function isFileEmpty(dir)
    local file = io.open(dir, "r")
    local line = file:read()
    file:close()
    if (line == nil) then
        return true
    else
        return false
    end
end

function getCurrentVersion(bool)
    local http_client
    local ffi = require("ffi")
    ffi.cdef [[
        typedef void http_response;
        http_response *http_get(const char *url, bool async);
        void http_destroy_response(http_response *);
        void http_wait_async(const http_response *);
        bool http_response_is_null(const http_response *);
        bool http_response_received(const http_response *);
        const char *http_read_response(const http_response *);
        uint32_t http_response_length(const http_response *);
    ]]
    http_client = ffi.load("lua_http_client")

    local function httpRequest(URL)
        local response = http_client.http_get(URL, false)
        local returning = nil
        if http_client.http_response_is_null(response) ~= true then
            local response_text_ptr = http_client.http_read_response(response)
            returning = ffi.string(response_text_ptr)
        end
        http_client.http_destroy_response(response)
        return returning
    end

    local url = 'https://raw.githubusercontent.com/Chalwk77/HALO-SCRIPT-PROJECTS/master/INDEV/Velocity%20Multi-Mod.lua'
    local version = httpRequest(url):match("script_version = (%d+.%d+)")
    local script_version = format("%0.2f", settings.global.script_version)
    if (bool == true) then
        if (tonumber(version) ~= script_version) then
            cprint("============================================================================", 5 + 8)
            cprint("[VELOCITY] Version " .. tostring(version) .. " is available for download.")
            cprint("Current version: v" .. script_version, 5 + 8)
            cprint("============================================================================", 5 + 8)
        else
            cprint("[VELOCITY] Version " .. script_version, 2 + 8)
        end
    end
    return tonumber(version)
end

-- Prints enabled scripts | Called by OnScriptLoad()
function printEnabled()
    cprint("\n----- [ VELOCITY ] -----", 3 + 5)
    for k, _ in pairs(settings.mod) do
        if (settings.mod[k].enabled) then
            cprint(k .. " is enabled", 2 + 8)
        else
            cprint(k .. " is disabled", 4 + 8)
        end
    end
    cprint("----------------------------------\n", 3 + 5)
end

-- In the event of an error, the script will trigger these two functions: OnError(), report()
function report()
    local script_version = format("%0.2f", settings.global.script_version)
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

-- This function will return a string with a traceback of the stack call...
-- ...and call function 'report' after 50 milliseconds.
function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end

function RecordChanges()
    local file = io.open("sapp\\changelog.txt", "w")
    local cl = {}

    local mod = settings.mod
    local global_cmd = settings.global.special_commands
    --
    local spawn_cmd = mod["Item Spawner"].base_command
    local itemlist_cmd = mod["Item Spawner"].list
    local block_cmd = mod["Block Object Pickups"].block_command
    local unblock_cmd = mod["Block Object Pickups"].unblock_command
    local alias_cmd = mod["Alias System"].base_command
    local lurker_cmd = mod["Lurker"].base_command
    local coords_cmd = mod["Get Coords"].base_command
    local delpm_cmd = mod["Private Messaging System"].delete_command
    local pmread_cmd = mod["Private Messaging System"].read_command
    local clean_cmd = mod["Garbage Collection"].base_command
    local give_cmd = mod["Give"].base_command
    local enter_cmd = mod["Enter Vehicle"].base_command
    local respawn_cmd = mod["Respawn On Demand"].base_command
    local broadcast_cmd = mod["Auto Message"].base_command
    local colorchanger_cmd = mod["Color Changer"].base_command
    --
    local plugins_cmd = global_cmd.list[1]
    local version_cmd = global_cmd.velocity[1]
    local lore_cmd = global_cmd.information.cmd

    cl[#cl + 1] = "[2/22/19]"
    cl[#cl + 1] = "1). Began Development of BGS (now known as Velocity)."
    cl[#cl + 1] = "Velocity is an all-in-one package that combines a multitude of my scripts."
    cl[#cl + 1] = "ALL combined scripts have been heavily refactored, refined and improved for Velocity,"
    cl[#cl + 1] = "with the addition of many new features not found in the standalone versions,"
    cl[#cl + 1] = "as well as a ton of 'special' features unique to Velocity that do not come in standalone scripts."
    cl[#cl + 1] = ""
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/23/19]"
    cl[#cl + 1] = "1). Core functionality complete"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/24/19]"
    cl[#cl + 1] = "1). First semi-stable Release (github: master -> INDEV)"
    cl[#cl + 1] = "Script Released: v1.0"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/25/19]"
    cl[#cl + 1] = "1). I have made some heavy tweaks to the /" .. clean_cmd .. " command (which was previously exclusive to the 'Enter Vehicle' mod)"
    cl[#cl + 1] = "in order to accommodate a new system that tracks objects spawned with both Enter vehicle and Item Spawner."
    cl[#cl + 1] = ""
    cl[#cl + 1] = "The base command is the same. However, the command arguments have changed:"
    cl[#cl + 1] = ""
    cl[#cl + 1] = "Valid [id] inputs: [number range 1-16, me or *]"
    cl[#cl + 1] = "/" .. clean_cmd .. " [id] 1 (cleans up 'Enter Vehicle' objects)"
    cl[#cl + 1] = "/" .. clean_cmd .. " [id] 2 (cleans up 'Item Spawner' objects)"
    cl[#cl + 1] = "/" .. clean_cmd .. " [id] * (cleans up 'everything')"
    cl[#cl + 1] = ""
    cl[#cl + 1] = "Also, to clear up any confusion should there be any, /" .. clean_cmd .. " * * is valid - This will clean everything for everybody."
    cl[#cl + 1] = "Additionally, you can toggle on|off garbage collection (on death, on disconnect) in the config sections of the respective mods."
    cl[#cl + 1] = "Script Updated to v1.1"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/26/19]"
    cl[#cl + 1] = "1). A few tweaks to Alias System."
    cl[#cl + 1] = "Script Updated to v1.2"
    cl[#cl + 1] = "2). You can now use Lurker mode while Infinity Ammo is enabled, but you cannot manipulate damage multipliers."
    cl[#cl + 1] = "Script Updated to v1.3"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/27/19]"
    cl[#cl + 1] = "1). Fixed a map check error relating to Respawn Time."
    cl[#cl + 1] = "Script Updated to v1.4"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/28/19]"
    cl[#cl + 1] = "1). Fixed a bug relating to Anti Impersonator."
    cl[#cl + 1] = "The user table in the Anti Impersonator configuration table now supports multiple hashes per user."
    cl[#cl + 1] = "Script Updated to v1.5"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/1/19]"
    cl[#cl + 1] = "1). Refactored Color Reservation"
    cl[#cl + 1] = "2). OnServerCommand() | Infinity Ammo (2[t]) was not targeting the correct player. This has been fixed."
    cl[#cl + 1] = "3). Bug fix for Alias System and other minor bug fixes."
    cl[#cl + 1] = "Script Updated to v1.6"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/2/19]"
    cl[#cl + 1] = "1). Completely Rewrote BGS and released under a new name: (Velocity - Multi Mod)."
    cl[#cl + 1] = "Script Updated to v1.7"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/22/19]"
    cl[#cl + 1] = "1). Updated Anti-Impersonator with optional IP Address scans"
    cl[#cl + 1] = "If someone joins with a name found in the users table and their ip address (or hash)"
    cl[#cl + 1] = "does not match any of the ip address (or hashes) for that name entry, action will be taken."
    cl[#cl + 1] = "Script Updated to v1.8"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/25/19]"
    cl[#cl + 1] = "1). Fixed a bug relating to Alias System and a couple of documentation edits"
    cl[#cl + 1] = "Script Updated to v1.9"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/27/19]"
    cl[#cl + 1] = "1). Bug Fix relating to function 'OnPlayerDisconnect()'"
    cl[#cl + 1] = "2). Bug Fix relating to function 'velocity:loadMute()'"
    cl[#cl + 1] = "3). Bug Fix for Suggestion Box"
    cl[#cl + 1] = "4). Other Minor Bug Fixes"
    cl[#cl + 1] = "5). Began writing Private Messaging System."
    cl[#cl + 1] = "Script Updated to v1.10"
    cl[#cl + 1] = "6). Continued development on Private Messaging System"
    cl[#cl + 1] = "Script Updated to v1.11"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/28/19]"
    cl[#cl + 1] = "1). Added page browser to Private Messaging System (read command /" .. pmread_cmd .. " [page num])'."
    cl[#cl + 1] = "2). [Private Messaging System] Continued Developed."
    cl[#cl + 1] = "Script Updated to v1.12"
    cl[#cl + 1] = "3). Bug Fix relating to function 'velocity:setLurker()'."
    cl[#cl + 1] = "Script Updated to v1.13"
    cl[#cl + 1] = "4). [Private Messaging System] Continued Developed."
    cl[#cl + 1] = "5). [new] Added a new feature (Respawn On Demand)."
    cl[#cl + 1] = "Respawn yourself or others on demand with /" .. respawn_cmd .. " [id] (no death penalty incurred)."
    cl[#cl + 1] = "6). Bug Fix for Portalgun Gun."
    cl[#cl + 1] = "Script Updated to v1.14"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/29/19]"
    cl[#cl + 1] = "1). Bug Fix for Alias System"
    cl[#cl + 1] = "Script Updated to v1.15"
    cl[#cl + 1] = "2). [new] Added GIVE feature. Command Syntax: /" .. give_cmd .. " <item> [me | id | */all]"
    cl[#cl + 1] = "3). More Bug Fixes"
    cl[#cl + 1] = "Script Updated to v1.16"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[4/30/19]"
    cl[#cl + 1] = "1). Updated Documentation and Bug Fixes."
    cl[#cl + 1] = "Script Updated to v1.17"
    cl[#cl + 1] = "2). [new] Added Chat Censor feature."
    cl[#cl + 1] = "3). Small tweak to Mute System in function: OnPlayerChat()."
    cl[#cl + 1] = "4). Bug Fix for Alias System."
    cl[#cl + 1] = "Script Updated to v1.18"
    cl[#cl + 1] = "5). Small tweak to Player List."
    cl[#cl + 1] = "Script Updated to v1.19"
    cl[#cl + 1] = "6). [new] Added Block-Object-Pickup feature. Command Syntax: /" .. block_cmd .. " [me | id | */all], /" .. unblock_cmd .. " [me | id | */all]"
    cl[#cl + 1] = "Script Updated to v1.20"
    cl[#cl + 1] = "7). Tweaked Plugin List feature"
    cl[#cl + 1] = "You can now view plugins by page: /" .. plugins_cmd .. " [page id] (max 10 results per page)"
    cl[#cl + 1] = "You can change the max results in 'settings -> global -> max_results_per_page'"
    cl[#cl + 1] = "Script Updated to v1.21"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/1/19]"
    cl[#cl + 1] = "1). Added 'bomb' from camden_place to Item Spawner objects table."
    cl[#cl + 1] = "Item Keyword is 'bomb1'. (/" .. spawn_cmd .. " bomb1 me)"
    cl[#cl + 1] = "2). New item spawner command parameter: [amount]."
    cl[#cl + 1] = "You can now specify the amount of the <item> to spawn."
    cl[#cl + 1] = "For example, '/" .. spawn_cmd .. " hog me 5' will spawn 5 chain gun hogs."
    cl[#cl + 1] = "Script Updated to v1.22"
    cl[#cl + 1] = "3). Small tweak to function 'OnPlayerChat()."
    cl[#cl + 1] = "Chat Command 'SKIP' typed in capitals will now trigger Map Skipping properly."
    cl[#cl + 1] = "Previously only 'skip' in lowercase would trigger this."
    cl[#cl + 1] = "4). Small tweak to 'Give' feature command output"
    cl[#cl + 1] = "Script Updated to v1.23"
    cl[#cl + 1] = "5). Small tweak to /" .. block_cmd .. ", /" .. unblock_cmd .. " feature"
    cl[#cl + 1] = "6). Added missing /" .. itemlist_cmd .. " command logic for Item Spawner."
    cl[#cl + 1] = "This command shows you a list of all available objects that you can /" .. spawn_cmd .. ", /" .. enter_cmd .. " or /" .. give_cmd .. " for the current map."
    cl[#cl + 1] = "Script Updated to v1.24"
    cl[#cl + 1] = "7). Tweaked Chat Censor feature + 1 documentation edit."
    cl[#cl + 1] = "Script Updated to v1.25"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/2/19]"
    cl[#cl + 1] = "1). [new] Command: /" .. lore_cmd .. " [page id]."
    cl[#cl + 1] = "This command displays a custom list of information (by page)."
    cl[#cl + 1] = "You can change the messages in 'settings -> global -> information'"
    cl[#cl + 1] = "Script Updated to v1.26"
    cl[#cl + 1] = "2). Small tweak to Chat Censor."
    cl[#cl + 1] = "Script Updated to v1.27"
    cl[#cl + 1] = "3). Another tweak to Chat Censor."
    cl[#cl + 1] = "Script Updated to v1.28"
    cl[#cl + 1] = "4). More tweaks to Chat Censor and a couple of documentation edits."
    cl[#cl + 1] = "Script Updated to v1.29"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/3/19]"
    cl[#cl + 1] = "1). Bug fix for List Players feature."
    cl[#cl + 1] = "2). Other minor tweaks and a few documentation edits."
    cl[#cl + 1] = "3). Tiny tweak in function 'velocity:setLurker()'"
    cl[#cl + 1] = "Script Updated to v1.30"
    cl[#cl + 1] = "4). Bug fix in function 'OnPlayerChat()' - Empty messages will now return false."
    cl[#cl + 1] = "5). Bug fix for command: /" .. plugins_cmd .. " [page id]"
    cl[#cl + 1] = "The command feedback now correctly displays the status of each individual plugin."
    cl[#cl + 1] = "6). Bug fix for Admin Chat feature - script will no longer throw an error if arg[2] (command parameter) is nil."
    cl[#cl + 1] = "7). Bug fix for Item Spawner, Enter Vehicle and Give."
    cl[#cl + 1] = "Script Updated to v1.31"
    cl[#cl + 1] = "8). For performance reasons, I had to refactor a large amount of the Alias System."
    cl[#cl + 1] = "The command syntax has changed from '/" .. alias_cmd .. " [id]' to '/" .. alias_cmd .. " [id] [page id]'."
    cl[#cl + 1] = ""
    cl[#cl + 1] = "There were two reasons for this change."
    cl[#cl + 1] = ""
    cl[#cl + 1] = "Reason #1:"
    cl[#cl + 1] = "Most people have pirated copies of Halo nowadays."
    cl[#cl + 1] = "Eventually, the number of aliases registered to a pirated key will result in the names being cut off the screen as you view them."
    cl[#cl + 1] = "Halo's rcon environment can only display so many lines before they disappear beyond the viewable buffer."
    cl[#cl + 1] = "A way around this was to split the names into pages - wherein by, a certain number of lines (rows & columns) will be shown per page."
    cl[#cl + 1] = "This consequently, albeit positive, means the Alias System is not as taxing on server performance as you view the aliases."
    cl[#cl + 1] = ""
    cl[#cl + 1] = "Reason #2:"
    cl[#cl + 1] = "With so many names registered to a pirated key, it is difficult (without comparing IP address to names) to determine"
    cl[#cl + 1] = "what names the target player has actually used. For this reason, I plan on implementing an '/ipalias [ip]' command feature at a later date."
    cl[#cl + 1] = "In the meantime, the system is perfect for viewing names used with (legit) copies of Halo."
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/4/19]"
    cl[#cl + 1] = "1). Couple of minor tweaks."
    cl[#cl + 1] = "Script Updated to v1.32"
    cl[#cl + 1] = "2). Tweaked Console Logo."
    cl[#cl + 1] = "Script Updated to v1.33"
    cl[#cl + 1] = "3). Bug fix for Alias System - checks against pirated copies of Halo."
    cl[#cl + 1] = "4). Bug fix for Admin Chat - Fixed a problem with permission check."
    cl[#cl + 1] = "Script Updated to v1.34"
    cl[#cl + 1] = "5). Small tweak to Admin Chat (again)"
    cl[#cl + 1] = "Script Updated to v1.35"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/5/19]"
    cl[#cl + 1] = "1). Small tweak to Chat Censor."
    cl[#cl + 1] = "Script Updated to v1.36"
    cl[#cl + 1] = "2). Bug fix for Alias System - page browser."
    cl[#cl + 1] = "3). Bug fix for Lurker - Command: '/" .. lurker_cmd .. " on me' no longer throws an error if executed from console."
    cl[#cl + 1] = "Script Updated to v1.37"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/6/19]"
    cl[#cl + 1] = "1). Removed duplicated perm-check in function 'velocity:portalgun()'."
    cl[#cl + 1] = "Script Updated to v1.38"
    cl[#cl + 1] = "2). Fixed a small problem with command per-check errors spamming the executor."
    cl[#cl + 1] = "Script Updated to v1.39"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/7/19]"
    cl[#cl + 1] = "1). Lurker will now tell you if someone is in Lurker Mode by aiming at them."
    cl[#cl + 1] = "2). Small tweak to Portalun Mode."
    cl[#cl + 1] = "3). All Velocity Commands are now case-insensitive."
    cl[#cl + 1] = "4). A few more minor tweaks here and there."
    cl[#cl + 1] = "Script Updated to v1.40"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/8/19]"
    cl[#cl + 1] = "1). Fixed a major problem with Alias System."
    cl[#cl + 1] = "2). [new] Added new 'Get Coords' feature. Command syntax: /" .. coords_cmd .. " [me | id | */all]."
    cl[#cl + 1] = "Use this command to retrieve the current x,y,z coordinates of the target player."
    cl[#cl + 1] = "3). Tidied up some code."
    cl[#cl + 1] = "4). Bug fix for command /" .. version_cmd .. ":"
    cl[#cl + 1] = "Output will now correctly display the version string with two decimal places."
    cl[#cl + 1] = "Script Updated to v1.41"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/12/19]"
    cl[#cl + 1] = "1). Fixed a bug with Alias System (requires regenerating alias.txt)."
    cl[#cl + 1] = "2). A few tweaks to Private Messaging System + New Command: /" .. delpm_cmd .. " [message id | */all]"
    cl[#cl + 1] = "With this command, you can delete emails individually or all at once."
    cl[#cl + 1] = "Script Updated to v1.42"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/13/19]"
    cl[#cl + 1] = "1). [new] Added 'Auto Message' feature:"
    cl[#cl + 1] = "This mod will automatically broadcast messages every x seconds."
    cl[#cl + 1] = "You can manually broadcast a message on demand with /" .. broadcast_cmd .. " [id]."
    cl[#cl + 1] = "To get the broadcast Message ID, type /" .. broadcast_cmd .. " list."
    cl[#cl + 1] = "Script Updated to v1.43"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/14/19]"
    cl[#cl + 1] = "1). Various minor bug fixes."
    cl[#cl + 1] = "2). There has been a small but significant change to the (now optional) 'Target ID' command parameter for:"
    cl[#cl + 1] = "portalgun, admin chat, lurker, give, item spawner, enter vehicle and other similar features."
    cl[#cl + 1] = "This change means that if the Target ID parameter is not specified, the executor will become the default target."
    cl[#cl + 1] = "For instance, '/lurker on' will trigger Lurker for the executor."
    cl[#cl + 1] = "Script Updated to v1.44"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/15/19]"
    cl[#cl + 1] = "1). Bug fix for nil-check error in function 'OnServerCommand()'."
    cl[#cl + 1] = "Script Updated to v1.45"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/16/19]"
    cl[#cl + 1] = "1). Fixed a couple of potential crashes."
    cl[#cl + 1] = "Script Updated to v1.46"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/18/19]"
    cl[#cl + 1] = "1). [new] Color Changer feature: (Change any player's armor color on demand)."
    cl[#cl + 1] = "Command Syntax: /" .. colorchanger_cmd .. " [color id] [me | id | */all]"
    cl[#cl + 1] = "2). Bug fix for Private Messaging System (pm spy was visible to the recipient)."
    cl[#cl + 1] = "3). Other minor bug fixes, tweaks and code clean ups."
    cl[#cl + 1] = "4). Bug fix for Infinity Ammo."
    cl[#cl + 1] = "Script Updated to v1.47"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/19/19]"
    cl[#cl + 1] = "1). Bug fix in function 'OnServerCommand()'."
    cl[#cl + 1] = "Script Updated to v1.48"
    cl[#cl + 1] = "2). Small fix for command /" .. plugins_cmd .. ". If the page ID is not specified, it will now default to page 1."
    cl[#cl + 1] = "3). Tweaked Lurker a little bit: When disabling Lurker, you will now teleport to your previous location."
    cl[#cl + 1] = "Script Updated to v1.49"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/20/19]"
    cl[#cl + 1] = "1). Another tweak for Lurker:"
    cl[#cl + 1] = "If you were in a vehicle when disabling Lurker, you will now be automatically re-entered into that exact same vehicle (in the same seat)."
    cl[#cl + 1] = "Script Updated to v1.50"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/22/19]"
    cl[#cl + 1] = "1). Tweak to Lurker: You will now freeze on the spot if you pick up the flag/oddball while in Lurker Mode and unfreeze when you drop it."
    cl[#cl + 1] = "The reason for this change is because people were exploiting the speed-boost that Lurker gives you."
    cl[#cl + 1] = "On Small maps, you could pickup the opposing teams flag and score with it before the drop-flag-warning timer runs out."
    cl[#cl + 1] = "Script Updated to v1.51"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/23/19]"
    cl[#cl + 1] = "1). Minor bug fixes."
    cl[#cl + 1] = "Script Updated to v1.52"
    cl[#cl + 1] = "2). Major bug fix for Lurker:"
    cl[#cl + 1] = "The flag will no longer be permanently deleted when disabling Lurker (or from auto-kill)."
    cl[#cl + 1] = "Script Updated to v1.53"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/24/19]"
    cl[#cl + 1] = "1). Bug fix (and one tweak) for Color Changer:"
    cl[#cl + 1] = "A: Made a correction to gametype-check-logic."
    cl[#cl + 1] = "B: If you were in a vehicle when you set your color, you will now re enter into that exact same vehicle (in the same seat), just like Lurker."
    cl[#cl + 1] = "2). The Objective-Check routines for Lurker will now work on protected maps."
    cl[#cl + 1] = "This means, for example, if you pickup the flag or oddball on a protected map,"
    cl[#cl + 1] = "lurker will recognize that you have picked up the objective, even if the tag id for that object is obfuscated and/or protected internally."
    cl[#cl + 1] = "Script Updated to v1.54"
    cl[#cl + 1] = "3). New setting ('hide') for LURKER:"
    cl[#cl + 1] = "Toggle 'hide' on or off to completely hide the player from others."
    cl[#cl + 1] = "Script Updated to v1.55"
    cl[#cl + 1] = "4). A couple of minor tweaks."
    cl[#cl + 1] = "Script Updated to v1.56"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/26/19]"
    cl[#cl + 1] = "1). Small tweak to Lurker."
    cl[#cl + 1] = "If 'hide' is enabled, players in Lurker Mode will now be hidden from the radar."
    cl[#cl + 1] = "Script Updated to v1.57"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/28/19]"
    cl[#cl + 1] = "1). New option added to lurker: 'hide_from_radar'."
    cl[#cl + 1] = "Previously, if 'hide' was enabled, you would be hidden from radar regardless."
    cl[#cl + 1] = "You can now toggle this on or off with the new setting."
    cl[#cl + 1] = "Script Updated to v1.58"
    cl[#cl + 1] = "2). Bug fix for Color Changer. "
    cl[#cl + 1] = "3). Removed mod: 'Spawn From Sky'."
    cl[#cl + 1] = "Script Updated to v1.59"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/29/19]"
    cl[#cl + 1] = "1). Completely rewrote Lurker. (See Lurker's config section for details)"
    cl[#cl + 1] = "2). Bug fix for Chat Censor."
    cl[#cl + 1] = "3). Other minor bug fixes."
    cl[#cl + 1] = "Script Updated to v1.60"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/30/19]"
    cl[#cl + 1] = "1). Bug Fixes from the aftermath of rewriting Lurker."
    cl[#cl + 1] = "Script Updated to v1.61"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[5/31/19]"
    cl[#cl + 1] = "1). Bug fixes for Chat Censor and Color Changer."
    cl[#cl + 1] = "Script Updated to v1.62"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[6/1/19]"
    cl[#cl + 1] = "1). Bug fix for Lurker - Players were joining in Lurker Mode when they shouldn't have been."
    cl[#cl + 1] = "Script Updated to v1.63"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[6/5/19]"
    cl[#cl + 1] = "1). Minor tweak for Admin Chat:"
    cl[#cl + 1] = "Admin Chat now has a chat-type prefix."
    cl[#cl + 1] = "Script Updated to v1.64"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[6/10/19]"
    cl[#cl + 1] = "1). Updated the 'Known Pirated Hashes' list."
    cl[#cl + 1] = "Script Updated to v1.65"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[7/8/19]"
    cl[#cl + 1] = "1). Bug fix for mute system."
    cl[#cl + 1] = "Script Updated to v1.66"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[7/29/19]"
    cl[#cl + 1] = "1). Bug fix in function OnServerChat()."
    cl[#cl + 1] = "Script Updated to v1.67"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[9/22/19]"
    cl[#cl + 1] = "1). Bug fixes. Nothing major"
    cl[#cl + 1] = "Script Updated to v1.68"
    file:write(concat(cl, "\n"))
    file:close()
    cprint("[VELOCITY] Writing Change Log...", 2 + 8)
    for _ in pairs(cl) do
        cl[_] = nil
    end
end
