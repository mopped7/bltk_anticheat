ServerConfig = {} -- [[Version: V1]]
-- [[READ THIS!]]
-- [[Always configure your anticheat properly, a bad configuration can cause false positives, and ban innocent players. Turn off what you don't need, turn on what you need, and fill the tables properly.]]

-- BYPASS ACE: bltk-ac.bypass

ServerConfig.DebugMode = true -- Debug Mode, prevent players from getting banned and kicked, only use it for troubleshooting and other testing stuff. This function will also disable bypass, to let admins to troubleshoot the Anticheat.
ServerConfig.KickMessage = "Default config" -- Change this

ServerConfig.UsernameBlacklist = true
    ServerConfig.UsernameBlacklistKickReason = "Your name is blacklisted on this server"
        ServerConfig.BlacklistedUsernames = {"administrator", "admin", "adm1n", "adm!n", "admln", "moderator", "owner", "nigger", "n1gger", "moderator", "eulencheats", "lynxmenu", "atgmenu", "hacker", "bastard", "hamhaxia", "333gang", "ukrp", "eguk", "n1gger", "n1ga", "nigga", "n1gga", "nigg3r",
        "nig3r", "shagged", "4dm1n", "<", ">", "~", "4dmin", "m0d3r4t0r", "n199er", "n1993r", "rustchance.com", "rustchance", "hellcase.com", "hellcase", "youtube.com", "youtu.be", "youtube", "twitch.tv", "twitch", "anticheat.gg", "anticheat", "fucking",
        "chocohax", "civilgamers.com", "civilgamers", "csgoempire.com", "csgoempire", "g4skins.com", "g4skins", "gameodds.gg", "duckfuck.com", "crysishosting.com", "crysishosting", "skinhub.com", "skinhub",
        "casedrop.eu", "casedrop", "cs.money", "rustypot.com","rampage.lt", "?", "xcasecsgo.com", "xcasecsgo", "csgocases.com",
        "csgocases", "K9GrillzUK.co.uk", "moat.gg", "princevidz.com", "princevidz", "pvpro.com", "Pvpro", "ez.krimes.ro", "loot.farm", "arma3fisherslife.net", "arma3fisherslife", "egamers.io", "ifn.gg", "sups.gg", "tradeit.gg",
        "§", "csgotraders.net", "csgotraders", "hurtfun.com", "hurtfun", "gamekit.com", "t.tv", "yandex.ru", "yandex", "csgofly.com", "csgofly", "pornhub.com", "pornhub","cs.deals","twat", "STRESS.PW"}

ServerConfig.PCKMenu = true -- PCK Menu Detect
    ServerConfig.PCKMenuKick = true 
    ServerConfig.PCKMenuBan = true

ServerConfig.ScramblerScript = true -- Anti ScramblerScript detect. It may not work correctly on some servers.
    ServerConfig.ScramblerKick = true 
    ServerConfig.ScramblerBan = true

ServerConfig.StaminaCheck = true -- This can detect unlimited stamina scripts. If you have a stamina modifier script, disable this function.
    ServerConfig.StaminaCheckKick = true 
    ServerConfig.StaminaCheckBan = true

ServerConfig.WeaponCheckSwitch = true -- Masterswitch of the weapon check system.
    ServerConfig.WeaponKick = true -- Kick players, if the weapon protection system catch cheaters.
    ServerConfig.WeaponBan = true -- Ban players, if the weapon protection system catch cheaters.
        ServerConfig.WeaponRemoveCheck = true -- This function can be useful, but it will not work correctly on a few servers.
        ServerConfig.WeaponAddCheck = true -- This function can be useful, but it will not work correctly on a few servers.

ServerConfig.AntiEntityNuke = true
    ServerConfig.MaxPeds = 6 -- Max ped spawn/5 sec
    ServerConfig.MaxVehs = 6 -- Max vehicle spawn/5 sec
        ServerConfig.AntiEntityNukeKick = true
        ServerConfig.AntiEntityNukeBan = true

ServerConfig.ParticleFX = true -- A really useful particleFX detector system.
    ServerConfig.ParticleFXSpamDetecter = true -- Anti ParticleFX Spammer system.
    ServerConfig.ParticleFXSpamDetecterMaxFX = 7 -- Particle FX limit / 5 sec. A good starting point is 7
        ServerConfig.ParticleFXSpamKick = true
        ServerConfig.ParticleFXSpamBan = true

ServerConfig.AntiExplosionNuke = true -- Anti explosion nuke system, this will detect a lot of cheats, if you configure it properly.
    ServerConfig.ExplosionDetections = {
        [0] = { name = "Grenade", log = false, kick = false, ban = false },
        [1] = { name = "GrenadeLauncher", log = false, kick = false, ban = false },
        [3] = { name = "Molotov", log = false, kick = false, ban = false },
        [4] = { name = "Rocket", log = false, kick = false, ban = false },
        [5] = { name = "TankShell", log = false, kick = false, ban = false},
        [6] = { name = "Hi_Octane", log = false, kick = false, ban = false },
        [7] = { name = "Car", log = false, kick = false, ban = false },
        [8] = { name = "Plance", log = false, kick = false, ban = false },
        [9] = { name = "PetrolPump", log = false, kick = false, ban = false },
        [10] = { name = "Bike", log = false, kick = false, ban = false },
        [11] = { name = "Dir_Steam", log = false, kick = false, ban = false },
        [12] = { name = "Dir_Flame", log = false, kick = false, ban = false },
        [13] = { name = "Dir_Water_Hydrant", log = false, kick = false, ban = false },
        [14] = { name = "Dir_Gas_Canister", log = false, kick = false, ban = false },
        [15] = { name = "Boat", log = false, kick = false, ban = false },
        [16] = { name = "Ship_Destroy", log = false, kick = false, ban = false },
        [17] = { name = "Truck", log = false, kick = false, ban = false },
        [18] = { name = "Bullet", log = false, kick = false, ban = false },
        [19] = { name = "SmokeGrenadeLauncher", log = false, kick = false, ban = false },
        [20] = { name = "SmokeGrenade", log = false, kick = false, ban = false },
        [21] = { name = "BZGAS", log = false, kick = false, ban = false },
        [22] = { name = "Flare", log = false, kick = false, ban = false },
        [23] = { name = "Gas_Canister", log = false, kick = false, ban = false },
        [24] = { name = "Extinguisher", log = false, kick = false, ban = false },
        [25] = { name = "Programmablear", log = false, kick = false, ban = false },
        [26] = { name = "Train", log = true, log = false, kick = false, ban = false },
        [27] = { name = "Barrel", log = false, kick = false, ban = false },
        [28] = { name = "PROPANE", log = false, kick = false, ban = false },
        [29] = { name = "Blimp", log = false, kick = false, ban = false },
        [30] = { name = "Dir_Flame_Explode", log = false, kick = false, ban = false },
        [31] = { name = "Tanker", log = false, kick = false, ban = false },
        [32] = { name = "PlaneRocket", log = false, kick = false, ban = false },
        [33] = { name = "VehicleBullet", log = false, kick = false, ban = false },
        [34] = { name = "Gas_Tank", log = false, kick = false, ban = false },
        [35] = { name = "FireWork", log = false, kick = false, ban = false },
        [36] = { name = "SnowBall", log = false, kick = false, ban = false },
        [37] = { name = "ProxMine", log = false, kick = false, ban = false },
        [38] = { name = "Valkyrie_Cannon", log = false, kick = false, ban = false }
    }

ServerConfig.ChatController = true -- Chat control system
    ServerConfig.ChatAntiSpam = true -- Anti chat spam
        ServerConfig.MaxMessageSpam = 5 -- Max messages / 5 sec
        ServerConfig.ChatAntiSpamKick = true
        ServerConfig.ChatAntiSpamBan = true
    ServerConfig.ChatBlacklistedWord = true -- Word blacklist system, this can be useful.
        ServerConfig.BlacklistedWords = {
            "Desudo",
            "Brutan",
            "EulenCheats",
            "Lynx 8",
            "www.lynxmenu.com",
            "HamHaxia",
            "Ham Mafia",
            "www.renalua.com",
            "Fallen#0811",
            "HamHaxia", 
            "Ham Mafia", 
            "Xanax#0134", 
            ">:D Player Crash",  
            "34ByTe Community", 
            "lynxmenu.com", 
            "Anti-Lynx",
            "Baran#8992",
            "iLostName#7138",
            "Melon#1379",
            "hammafia.com",
            "AlphaV ~ 5391",
            "vjuton.pl",
            "Soviet Bear",
            "MARVIN menu",
            "Alpha Menu",
            "Tiafall",
            "KoGuSzEk#3251",
        }
        ServerConfig.ChatBlacklistedWordKick = true
        ServerConfig.ChatBlacklistedWordBan = true

ServerConfig.BlacklistedEventsSystem = true -- This is a really good tool against newbie cheaters. If you configure this function properly, you can find a lot of cheaters.
    ServerConfig.BlacklistedEventKick = true
    ServerConfig.BlacklistedEventBan = true
    ServerConfig.BlacklistedEvents = {
        "redst0nia:checking",
        "hentailover:xdlol",
        "antilynx8:anticheat",
        "antilynxr6:detection",
        "antilynx8r4a:anticheat",
        "antilynxr4:detect",
        "ynx8:anticheat",
        "lynx8:anticheat",
        "adminmenu:allowall",
        "h:xd",
        "HCheat:TempDisableDetection",
        "FAC:EzExec",
    }

