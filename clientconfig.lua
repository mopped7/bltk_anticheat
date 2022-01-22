ClientConfig = {} -- [[Version: V1]]
-- [[READ THIS!]]
-- [[Always configure your anticheat properly, a bad configuration can cause false positives, and ban innocent players.]]

ClientConfig.MenuChecks = true -- Menucheck system
    ClientConfig.MenuCheckDelay = 1000 -- Menucheck repeat delay in ms, lower numbers are more efficient, but they are causing more lag.
        ClientConfig.MenuCheckKick = true -- Kick players, if menucheck catch cheaters.
        ClientConfig.MenuCheckBan = true -- Ban players, if menucheck catch cheaters.
            ClientConfig.AntiGodMode = true -- This can cause problems on a few frameworks. Usually works fine with ESX.
            ClientConfig.MaxHealth = 200 -- Max player health, usually 200.
            ClientConfig.AntiSemiGodMode = true -- That's a better option for detecting godmode, more reliable etc...
            ClientConfig.AntiSpectate = true -- This will detect spectating players.
            ClientConfig.BlackListWeaponChecks = true -- Weapon blacklist system
                ClientConfig.BlackListWeaponList = { -- Blacklisted Weapons
                    "WEAPON_RPG",
                    "WEAPON_FIREWORK",
                    "WEAPON_APPISTOL"    
                }
            ClientConfig.NoNPC = true -- Turn this on, if you have a NoNPC server. This function will delete ALL peds.
            ClientConfig.TxdMenu = false -- This will detect some textured mod menu.
            ClientConfig.ThermalVision = true -- This will detect thermal vision if the player is not in any helicopter.
            ClientConfig.NightVision = true -- This will detect night vision.
            ClientConfig.RagdollDetection = true -- Detecting Anti-Ragdoll systems.
            ClientConfig.MenyooASI = false -- It can detect some ASI menu like Menyoo, be careful with this function, this function can cause false positives on some servers.

ClientConfig.InjectDetect = true -- Client-side anti injector system
    ClientConfig.ClientResourceStuff = true -- If you enabled one of these functions under the ClientResourceStuff section, then don't restart, stop, or start client sided scripts.
        ClientConfig.InjectKick = true -- Kick players, if injection system catch cheaters.
        ClientConfig.InjectCheckBan = true -- Ban players, if injection system catch cheaters.
            ClientConfig.ResourceLookup = true -- This will lookup client resources, and can detect some light and free crap executors. 
            ClientConfig.CommandChecker = true -- This will catch new client sided commands, that can be really useful, if someone wants to inject a menu with commands.
            ClientConfig.ResourceChecker = false -- This will check the number of resources. (it can be useful but really heavy with loaded servers, not use if you have more than 50 players)
            ClientConfig.AntiResourceRestart = true -- (Really useful) Can detect some executors. DON'T STOP RESTART OR START SCRIPTS IF YOU ENABLED THIS.
            ClientConfig.NUICheck = true -- Effective detection
            ClientConfig.DisableNUIDevtools = true -- This function will disable nui_devtools.