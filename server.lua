function bltkbanlistregenerator()
	local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	if not o or o == "" or not json.decode(o) then
		SaveResourceFile(GetCurrentResourceName(), "bans.json", "[]", -1)
	end
end
bltkbanlistregenerator()

function bltkBan(source)
	local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	if o ~= nil then
		local q = json.decode(o)
		if type(q) == "table" then
			table.insert(q, GetPlayerIdentifiers(source))
			local r = json.encode(q, { indent = true })
			SaveResourceFile(GetCurrentResourceName(), "bans.json", r, -1)
		else
			bltkbanlistregenerator()
		end
	else
		bltkbanlistregenerator()
	end
end

local function V(Q, W, X)
	local Y = GetPlayerIdentifiers(source)
	local v = false
	local A = tostring(GetPlayerEndpoint(source))
	local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	if o ~= nil then
		local p = json.decode(o)
		if type(p) == "table" then
			for _, a0 in ipairs(GetPlayerIdentifiers(source)) do
				for m, n in ipairs(p) do
					for a5, a6 in ipairs(n) do
						if a6 == a0 or n == a0 then
							v = true
							break
						end
					end
					if v then
						break
					end
				end
				if v then
					break
				end
			end
			if v then
				--bltkBan(source)
				X.done(ServerConfig.KickMessage)
				return
			end
		else
			bltkbanlistregenerator()
		end
	else
		bltkbanlistregenerator()
	end
end

AddEventHandler("playerConnecting", V)

function sendToDiscord(color, name, message, footer)
	local embed = {
		{
			["color"] = color,
			["title"] = "**" .. name .. "**",
			["description"] = message,
			["footer"] = {
				["text"] = footer,
			},
		},
	}

	PerformHttpRequest(
		webhooks.Log,
		function(err, text, headers) end,
		"POST",
		json.encode({ username = name, embeds = embed }),
		{ ["Content-Type"] = "application/json" }
	)
end
function sendToDiscordSS(sslink, color, name, message, footer)
	local embed = {
		{
			["color"] = color,
			["title"] = "**" .. name .. "**",
			["description"] = message,
			["footer"] = {
				["text"] = footer,
			},
			["image"] = {
				["url"] = sslink,
			},
		},
	}

	PerformHttpRequest(
		webhooks.Log,
		function(err, text, headers) end,
		"POST",
		json.encode({ username = name, embeds = embed }),
		{ ["Content-Type"] = "application/json" }
	)
end
function ExtractIdentifiers(src)
	local identifiers = {
		steam = "Unknown",
		ip = "Unknown",
		discord = "Unknown",
		license = "Unknown",
		xbl = "Unknown",
		live = "Unknown",
	}

	for i = 0, GetNumPlayerIdentifiers(src) - 1 do
		local id = split(GetPlayerIdentifier(src, i), ":")
		identifiers[id[1]] = id[2]
	end

	return identifiers
end

RegisterNetEvent("bltkac_antiloadfromshits", function(res)
	if GetReourceState(res) == "missing" then
		BLTKACDETECT(source, "Entity Spawn Unknown Resource", "Prop spawned with an executor, in an unknown resource (probably eulen). Entity spawner resource: `"..res.."`", ClientConfig.AntiSpawnKick, ClientConfig.AntiSpawnBan)
	end
end)

if ServerConfig then
	local surprise = [[
        ____  _   _______ _  __           _   _ _______ _____ _____ _    _ ______       _______ 
        |  _ \| | |__   __| |/ /     /\   | \ | |__   __|_   _/ ____| |  | |  ____|   /\|__   __|
        | |_) | |    | |  | ' /     /  \  |  \| |  | |    | || |    | |__| | |__     /  \  | |   
        |  _ <| |    | |  |  <     / /\ \ | . ` |  | |    | || |    |  __  |  __|   / /\ \ | |   
        | |_) | |____| |  | . \   / ____ \| |\  |  | |   _| || |____| |  | | |____ / ____ \| |   
        |____/|______|_|  |_|\_\ /_/    \_\_| \_|  |_|  |_____\_____|_|  |_|______/_/    \_\_|
    ]]
	print(surprise)
	print("^2BLTK AC Initialized!^0")
end
exp = {}
particlesSpawned = {}
chatBeforeBlock = {}
veh = {}
ped = {}
-- AntiNuke Var resets
CreateThread(function()
	exp = {}
	particlesSpawned = {}
	chatBeforeBlock = {}
	veh = {}
	ped = {}

	while true do
		Wait(5000)
		particlesSpawned = {}
		exp = {}
		chatBeforeBlock = {}
		veh = {}
		ped = {}
	end
end)

RegisterNetEvent("bltkac_detection")
AddEventHandler("bltkac_detection", function(mreason, description, kickstatus, banstatus)
	if ServerConfig.DebugMode then
		local ids = ExtractIdentifiers(source)
		sendToDiscord(
			7143168,
			"(DEBUG MODE)User detect - " .. mreason,
			"**ID:** "
				.. source
				.. "\n**Name:** "
				.. GetPlayerName(source)
				.. "\n**Steam Hex** "
				.. ids.steam
				.. "\n**Discord ID** "
				.. ids.discord
				.. "\n**Rockstar License** "
				.. ids.license
				.. "\n**Xbox Live** "
				.. ids.live
				.. "\n**Xbox Microsoft** "
				.. ids.xbl
				.. "\n\n**Reason:** "
				.. description,
			"BLTK AntiCheat"
		)
	else
		if not IsPlayerAceAllowed(source, "bltk-ac.bypass") then
			local ids = ExtractIdentifiers(source)
			if banstatus then
				bltkBan(source)
			end
			sendToDiscord(
				7143168,
				"User detect - " .. mreason,
				"**ID:** "
					.. source
					.. "\n**Name:** "
					.. GetPlayerName(source)
					.. "\n**Steam Hex** "
					.. ids.steam
					.. "\n**Discord ID** "
					.. ids.discord
					.. "\n**Rockstar License** "
					.. ids.license
					.. "\n**Xbox Live** "
					.. ids.live
					.. "\n**Xbox Microsoft** "
					.. ids.xbl
					.. "\n\n**Reason:** "
					.. description,
				"BLTK AntiCheat"
			)
			if kickstatus then
				DropPlayer(source, ServerConfig.KickMessage)
			end
		end
	end
end)

RegisterNetEvent("bltkac_detection_ai")
AddEventHandler("bltkac_detection_ai", function(ssurl, mreason, description, kickstatus, banstatus)
	print(ssurl)
	if ServerConfig.DebugMode then
		local ids = ExtractIdentifiers(source)
		sendToDiscord(
			7143168,
			"(DEBUG MODE)User detect - " .. mreason,
			"**ID:** "
				.. source
				.. "\n**Name:** "
				.. GetPlayerName(source)
				.. "\n**Steam Hex** "
				.. ids.steam
				.. "\n**Discord ID** "
				.. ids.discord
				.. "\n**Rockstar License** "
				.. ids.license
				.. "\n**Xbox Live** "
				.. ids.live
				.. "\n**Xbox Microsoft** "
				.. ids.xbl
				.. "\n\n**Reason:** "
				.. description,
			"BLTK AntiCheat"
		)
	else
		if not IsPlayerAceAllowed(source, "bltk-ac.bypass") then
			local ids = ExtractIdentifiers(source)
			if banstatus then
				bltkBan(source)
			end
			sendToDiscord(
				7143168,
				"User detect - " .. mreason,
				"**ID:** "
					.. source
					.. "\n**Name:** "
					.. GetPlayerName(source)
					.. "\n**Steam Hex** "
					.. ids.steam
					.. "\n**Discord ID** "
					.. ids.discord
					.. "\n**Rockstar License** "
					.. ids.license
					.. "\n**Xbox Live** "
					.. ids.live
					.. "\n**Xbox Microsoft** "
					.. ids.xbl
					.. "\n\n**Reason:** "
					.. description,
				"BLTK AntiCheat"
			)
			if kickstatus then
				DropPlayer(source, ServerConfig.KickMessage)
			end
		end
	end
end)

function BLTKACDETECT(source, mreason, description, kickstatus, banstatus)
	if ServerConfig.DebugMode then
		local ids = ExtractIdentifiers(source)
		sendToDiscord(
			7143168,
			"(DEBUG MODE)User detect - " .. mreason,
			"**ID:** "
				.. source
				.. "\n**Name:** "
				.. GetPlayerName(source)
				.. "\n**Steam Hex** "
				.. ids.steam
				.. "\n**Discord ID** "
				.. ids.discord
				.. "\n**Rockstar License** "
				.. ids.license
				.. "\n**Xbox Live** "
				.. ids.live
				.. "\n**Xbox Microsoft** "
				.. ids.xbl
				.. "\n\n**Reason:** "
				.. description,
			"BLTK AntiCheat"
		)
	else
		if not IsPlayerAceAllowed(source, "bltk-ac.bypass") then
			local ids = ExtractIdentifiers(source)
			if banstatus then
				bltkBan(source)
			end
			sendToDiscord(
				7143168,
				"User detect - " .. mreason,
				"**ID:** "
					.. source
					.. "\n**Name:** "
					.. GetPlayerName(source)
					.. "\n**Steam Hex** "
					.. ids.steam
					.. "\n**Discord ID** "
					.. ids.discord
					.. "\n**Rockstar License** "
					.. ids.license
					.. "\n**Xbox Live** "
					.. ids.live
					.. "\n**Xbox Microsoft** "
					.. ids.xbl
					.. "\n\n**Reason:** "
					.. description,
				"BLTK AntiCheat"
			)
			if kickstatus then
				DropPlayer(source, ServerConfig.KickMessage)
			end
		end
	end
end

if ServerConfig.UsernameBlacklist then
	AddEventHandler("playerConnecting", function(AWDGAXSUDGYWA5SRD, AHSD, AHSDYASUGD)
		for i, v in pairs(ServerConfig.BlacklistedUsernames) do
			if string.find(AWDGAXSUDGYWA5SRD, v) then
				AHSDYASUGD.done(ServerConfig.UsernameBlacklistKickReason)
			end
		end
	end)
end

if ServerConfig.WeaponCheckSwitch then
	if ServerConfig.WeaponRemoveCheck then
		AddEventHandler("removeAllWeaponsEvent", function(source, data)
			BLTKACDETECT(
				source,
				"Remove all weapons from a player",
				"This player tried to remove all weapons from another player.",
				ServerConfig.WeaponKick,
				ServerConfig.WeaponBan
			)
		end)
		AddEventHandler("removeWeaponEvent", function(source, data)
			BLTKACDETECT(
				source,
				"Remove a weapon from a player",
				"This player tried to remove a weapon from another player.",
				ServerConfig.WeaponKick,
				ServerConfig.WeaponBan
			)
		end)
	end
	if ServerConfig.WeaponAddCheck then
		AddEventHandler("giveWeaponEvent", function(source, data)
			BLTKACDETECT(
				source,
				"Give weapon to a player",
				"This player tried to give a weapon to another player.",
				ServerConfig.WeaponKick,
				ServerConfig.WeaponBan
			)
		end)
	end
end

if ServerConfig.ParticleFX then
	if ServerConfig.ParticleFXSpamDetecter then
		AddEventHandler("ptFxEvent", function(__source, data)
			particlesSpawned[__source] = (particlesSpawned[__source] or 0) + 1
			if particlesSpawned[__source] > ServerConfig.ParticleFXSpamDetecterMaxFX then
				BLTKACDETECT(
					__source,
					"[ANTINUKE] ParticleFX Spam",
					"ParticleFX Spam detected.",
					ServerConfig.ParticleFXSpamKick,
					ServerConfig.ParticleFXSpamBan
				)
			end
		end)
	end
end

if ServerConfig.ChatController then
	AddEventHandler("chatMessage", function(source, name, message)
		if ServerConfig.ChatAntiSpam then
			chatBeforeBlock[source] = (chatBeforeBlock[source] or 0) + 1
			if chatBeforeBlock[source] > ServerConfig.MaxMessageSpam then
				BLTKACDETECT(
					source,
					"AntiChatSpam",
					"This player sent more then " .. ServerConfig.MaxMessageSpam .. " message in 5000ms (5s)",
					ServerConfig.ChatAntiSpamKick,
					ServerConfig.ChatAntiSpamBan
				)
				CancelEvent()
			end
		end
		if ServerConfig.ChatBlacklistedWord then
			for i, v in pairs(ServerConfig.BlacklistedWords) do
				if string.find(message, v) then
					BLTKACDETECT(
						source,
						"Blacklisted word",
						"This player tried to say a blacklisted word.\n**Word:** `" .. v .. "`",
						ServerConfig.ChatBlacklistedWordKick,
						ServerConfig.ChatBlacklistedWordBan
					)
					CancelEvent()
				end
			end
		end
	end)
end

if ServerConfig.BlacklistedEventsSystem then
	for k, events in pairs(ServerConfig.BlacklistedEvents) do
		RegisterServerEvent(events)
		AddEventHandler(events, function()
			BLTKACDETECT(
				source,
				"Event Executor",
				"This player tried to execute a blacklisted event.\n**Executed event:** `" .. events .. "`",
				ServerConfig.ChatBlacklistedWordKick,
				ServerConfig.ChatBlacklistedWordBan
			)
		end)
	end
end

if ServerConfig.AntiExplosionNuke then
	AddEventHandler("explosionEvent", function(source, expdata)
		if ServerConfig.AntiExplosionSpam then
			exp[source] = (exp[source] or 0) + 1
			if exp[source] == ServerConfig.MaxExplosionPerFiveSec then
				BLTKACDETECT(
					source,
					"Explosion Spam",
					"This player tried to spam `" .. ServerConfig.MaxExplosionPerFiveSec .. "` explosions in 5 sec.",
					true,
					true
				)
			end
		end
		if ServerConfig.ExplosionDetections[expdata.explosionType] then
			local expdataargs = ServerConfig.ExplosionDetections[expdata.explosionType]
			if expdataargs.log then
				BLTKACDETECT(
					source,
					"Explosion",
					"This player tried to use a blocked explosion.\n**Explosion:** `"
						.. ServerConfig.ExplosionDetections[expdata.explosionType].name
						.. "`",
					false,
					false
				)
			end
			if expdataargs.kick then
				BLTKACDETECT(
					source,
					"Explosion",
					"This player tried to use a blocked explosion.\n**Explosion:** `"
						.. ServerConfig.ExplosionDetections[expdata.explosionType].name
						.. "`",
					true,
					false
				)
			end
			if expdataargs.ban then
				BLTKACDETECT(
					source,
					"Explosion",
					"This player tried to use a blocked explosion.\n**Explosion:** `"
						.. ServerConfig.ExplosionDetections[expdata.explosionType].name
						.. "`",
					true,
					true
				)
			end
		end
	end)
end
RegisterNetEvent("bltk:read:screenshotstorage", function()
	TriggerClientEvent("bltk:screenshotstorage", source, webhooks.ScreenShotStorage)
end)
if ServerConfig.AntiEntityNuke then
	AddEventHandler("entityCreating", function(entity, player)
		local entity = entity
		local model = GetEntityModel(entity)
		local eType = GetEntityPopulationType(entity)

		if DoesEntityExist(entity) then
			local source = NetworkGetEntityOwner(entity)
			local entID = NetworkGetNetworkIdFromEntity(entity)
			if GetEntityType(entity) == 2 then
				if eType == 6 or eType == 7 then
					if model ~= 0 then
						veh[source] = (veh[source] or 0) + 1
						if veh[source] > 3 then
							TriggerClientEvent("bltkac:antinuke:clearvehicles", -1, source)
						end
						if veh[source] > ServerConfig.MaxVehs then
							TriggerClientEvent("bltkac:antinuke:clearvehicles", -1, source)
							BLTKACDETECT(
								source,
								"[ANITNUKE] Vehicle",
								"This player spawned more than " .. ServerConfig.MaxVehs .. " entity in 5000 ms",
								true,
								true
							)

							CancelEvent()
						end
					end
				end
			end
			if GetEntityType(entity) == 1 then
				if eType == 6 or eType == 7 or eType == 0 then
					ped[source] = (ped[source] or 0) + 1
					if ped[source] > ServerConfig.MaxPeds then
						BLTKACDETECT(
							source,
							"[ANITNUKE] Ped",
							"This player spawned more than " .. ServerConfig.MaxPeds .. " entity in 5000 ms",
							true,
							true
						)
						CancelEvent()
					end
				end
			end
		end
	end)
end

for i, v in pairs(ServerConfig.MaxValuedEvents) do
	local svevent = i
	local maxvalue = ServerConfig.MaxValuedEvents[i].maxvalue
	RegisterServerEvent(svevent)
	AddEventHandler(svevent, function(args1, args2, args3, args4)
		if args1 ~= nil and args1 > maxvalue then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. svevent .. "` with a >" .. maxvalue .. " value `[" .. args1 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		elseif args2 ~= nil and args2 > maxvalue then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. svevent .. "` with a >" .. maxvalue .. " value `[" .. args1,
				args2 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		elseif args3 ~= nil and args3 > maxvalue then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. svevent .. "` with a >" .. maxvalue .. " value `[" .. args1,
				args2,
				args3 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		elseif args4 ~= nil and args4 > maxvalue then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. svevent .. "` with a >" .. maxvalue .. " value `[" .. args1,
				args2,
				args3,
				args4 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
	end)
end
RegisterNetEvent("bltk:clienttoserver:72813618768432576", function()
	if IsPlayerUsingSuperJump(source) then
		BLTKACDETECT(
			source,
			"MenuCheck Superjump",
			"This player tried to use superjump",
			ClientConfig.MenuCheckKick,
			ClientConfig.MenuCheckBan
		)
	end
end)
RegisterNetEvent("bltkac_12837612873843658347658376", function(resyyy)
	if GetResourceState(resyyy) == "stopped" then
	else
		BLTKACDETECT(
			source,
			"Resource stop",
			"This player tried to stop a resource: `" .. resyyy .. "`",
			ClientConfig.InjectKick,
			ClientConfig.InjectBan
		)
	end
end)
for _, c in pairs(ServerConfig.NegativeVauleEvents) do
	RegisterNetEvent(c)
	AddEventHandler(c, function(args1, args2, args3, args4)
		if args1 ~= nil and args1 == -1 then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. c .. "` with a -1 value `[" .. args1 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
		if args2 ~= nil and args2 == -1 then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. c .. "` with a -1 value `[" .. args2 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
		if args3 ~= nil and args3 == -1 then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. c .. "` with a -1 value `[" .. args3 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
		if args4 ~= nil and args4 == -1 then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. c .. "` with a -1 value `[" .. args4 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
		if args5 ~= nil and args5 == -1 then
			BLTKACDETECT(
				source,
				"Event executed",
				"This player executed `" .. c .. "` with a -1 value `[" .. args5 .. "]`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
	end)
end
if ServerConfig.AntiFakeMessage then
	AddEventHandler("chatMessage", function(source, name, message)
		if not GetPlayerName(source) == name then
			BLTKACDETECT(
				source,
				"Fake Chat Message",
				"This player tried to send a message as `"..name.."`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
	end)
end
function installresources(an, manifest, rname, ao)
	local ap = io.open(an .. "/" .. manifest .. ".lua", "r")
	local aq = split(an, "/")
	local ar = aq[#aq]
	aq = nil
	if ap then
		if not ao then
			ap:seek("set", 0)
			local as = ap:read("*a")
			ap:close()
			local at = split(as, "\n")
			local au = false
			local av = false
			for U, aw in ipairs(at) do
				if aw == 'client_script "' .. rname .. '.lua"' then
					au = true
				end
				if not av then
					local ax = string.find(aw, "client_script") or -1
					local ay = string.find(aw, "#") or -1
					if ax ~= -1 and (ay == -1 or ax < ay) then
						av = true
					end
				end
			end
			if av then
				as = as .. '\nclient_script "' .. rname .. '.lua"'
				if not au then
					os.remove(an .. "/" .. manifest .. ".lua")
					ap = io.open(an .. "/" .. manifest .. ".lua", "w")
					if ap then
						ap:seek("set", 0)
						ap:write(as)
						ap:close()
					end
				end
				local az = [[
                    CreateThread(function()
                        Wait(500)
                        while true do
                            Wait(3000)
                            if InSec ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a SkidMenu into "..GetCurrentResourceName()..", true, true) 
                            end
                            if e ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a LynxMenu into "..GetCurrentResourceName()..".", true, true) 
                            end
                            if WarMenu ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a LynxMenu into "..GetCurrentResourceName()..", true, true) 
                            end
                            if menuName ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a Tiago into "..GetCurrentResourceName()..", true, true) 
                            end
                            if BrutanPremium ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a BrutanPremiumMenu into "..GetCurrentResourceName()..", true, true) 
                            end
                            if obl2 ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a Oblivious into "..GetCurrentResourceName()..", true, true) 
                            end
                            if Proxy ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a Dopamine into "..GetCurrentResourceName()..", true, true) 
                            end
                            if LynxEvo ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a LynxMenu into "..GetCurrentResourceName()..", true, true) 
                            end
                            if Absolute ~= nil then
                                TriggerServerEvent("bltkac_detection", "EMD Injection", "This player tried to inject a AbsoluteMenu into "..GetCurrentResourceName()..", true, true) 
                            end
                        end
                    end)
                ]]
				ap = io.open(an .. "/" .. rname .. ".lua", "w")
				if ap then
					ap:seek("set", 0)
					ap:write(az)
					ap:close()
					af[1] = af[1] + 1
					print("^2BLTK AC^0: ^2Installation successfully completed.^0")
				else
					print("^2BLTK AC^0: ^2Installation failed.^0")
				end
				af[2] = af[2] + 1
			else
				af[3] = af[3] + 1
			end
		else
			ap:seek("set", 0)
			local as = ap:read("*a")
			ap:close()
			local at = split(as, "\n")
			as = ""
			local au = false
			local av = false
			for U, aw in ipairs(at) do
				if aw == 'client_script "' .. rname .. '.lua"' then
					au = true
				else
					as = as .. aw .. "\n"
				end
			end
			if os.rename(an .. "/" .. rname .. ".lua", an .. "/" .. rname .. ".lua") then
				av = true
				os.remove(an .. "/" .. rname .. ".lua")
			end
			if not au and not av then
				af[3] = af[3] + 1
			end
			if au then
				af[2] = af[2] + 1
				os.remove(an .. "/" .. manifest .. ".lua")
				ap = io.open(an .. "/" .. manifest .. ".lua", "w")
				if ap then
					ap:seek("set", 0)
					ap:write(as)
					ap:close()
				else
					print("^2BLTK AC^0: ^2Installation failed.^0")
					au, av = false, false
				end
			end
			if au or av then
				print("^2BLTK AC^0: ^2Successfully uninstalled.^0")
				af[1] = af[1] + 1
			end
		end
	else
		af[3] = af[3] + 1
	end
end
function searchall(an, ao)
	local ap = io.popen('dir "' .. an .. '" /b /ad')
	ap:seek("set", 0)
	local aA = ap:read("*a")
	ap:close()
	local at = split(aA, "\n")
	for U, aw in ipairs(at) do
		if string.len(aw) > 0 then
			setall(an .. "/" .. aw, ao)
			searchall(an .. "/" .. aw, ao)
		end
	end
end
function split(aB, aC)
	local splitted = {}
	for str in string.gmatch(aB, "([^" .. aC .. "]+)") do
		table.insert(splitted, str)
	end

	return splitted
end
if ServerConfig.AntiESX then
	RegisterNetEvent("esx:getSharedObject", function()
		BLTKACDETECT(
			source,
			"ESX Injection (ANTIESX)",
			"This player tried to trigger `esx:getSharedObject`",
			ServerConfig.AntiESXKick,
			ServerConfig.AntiESXBan
		)
	end)
end

if ServerConfig.AntiNuke then
	AddEventHandler("entityCreated", function(entity)
		local entpop = GetEntityPopulationType(entity)
		source = NetworkGetEntityOwner(entity)
		if entpop == 6 or entpop == 7 then
			if ServerConfig.BlacklistedVehicles then
				if GetEntityType(entity) == 2 then
					for i, v in pairs(ServerConfig.BlacklistedVehicleList) do
						local listedentity = i
						local logname = ServerConfig.BlacklistedVehicleList[i].logname
						if GetEntityModel(entity) == listedentity then
							DeleteEntity(entity)
							BLTKACDETECT(
								source,
								"AntiNuke Vehicle Blacklist",
								"This player tried to spawn a blacklisted vehicle `" .. logname .. "`",
								ServerConfig.BlacklistedEntitiesKick,
								ServerConfig.BlacklistedEntitiesBan
							)
						end
					end
				end
			end
		end
		if entpop == 6 or entpop == 7 or entpop == 0 then
			if ServerConfig.BlacklistedPeds then
				if GetEntityType(entity) == 1 then
					for i, v in pairs(ServerConfig.BlacklistedPedList) do
						local listedentity = i
						local logname = ServerConfig.BlacklistedPedList[i].logname
						if GetEntityModel(entity) == listedentity then
							DeleteEntity(entity)
							BLTKACDETECT(
								source,
								"AntiNuke Ped Blacklist",
								"This player tried to spawn a blacklisted ped `" .. logname .. "`",
								ServerConfig.BlacklistedEntitiesKick,
								ServerConfig.BlacklistedEntitiesBan
							)
						end
					end
				end
			end
		end
		if ServerConfig.BlacklistedObjects then
			if GetEntityType(entity) == 3 then
				for i, v in pairs(ServerConfig.BlacklistedObjectList) do
					local listedentity = i
					local logname = ServerConfig.BlacklistedObjectList[i].logname
					if GetEntityModel(entity) == listedentity then
						DeleteEntity(entity)
						BLTKACDETECT(
							source,
							"AntiNuke Object Blacklist",
							"This player tried to spawn a blacklisted object `" .. logname .. "`",
							ServerConfig.BlacklistedEntitiesKick,
							ServerConfig.BlacklistedEntitiesBan
						)
					end
				end
			end
		end
	end)
end

AddEventHandler("ptFxEvent", function(source, data)
	for k, n in pairs(ServerConfig.BlacklistedParticles) do
		if k == data.effectHash then
			BLTKACDETECT(
				source,
				"Blacklisted Particle",
				"This player spawned a blacklisted particle\n**Particle:** `"
					.. ServerConfig.BlacklistedParticles[k].name
					.. "`",
				true,
				true
			)
		end
	end
end)

local validResourceList
local function collectValidResourceList()
	validResourceList = {}
	for i = 0, GetNumResources() - 1 do
		validResourceList[GetResourceByFindIndex(i)] = true
	end
end
collectValidResourceList()
AddEventHandler("onResourceListRefresh", collectValidResourceList)
RegisterNetEvent("bltkac_isolationservercheck")
AddEventHandler("bltkac_isolationservercheck", function(givenList)
	for _, resource in ipairs(givenList) do
		if not validResourceList[resource] then
			BLTKACDETECT(
				source,
				"Unisolated Execution",
				"Unauthorized resource detected.\n**Resource:** `" .. resource .. "`",
				ClientConfig.InjectKick,
				ClientConfig.InjectBan
			)
			break
		end
	end
end)

if ServerConfig.ClearPedTasksImmediately then
	AddEventHandler("clearPedTasksEvent", function(source, data)
		if data.immediately then
			BLTKACDETECT(
				source,
				"Clear Ped Tasks",
				"This player tried to clear ped tasks on another player. Probably kicking players out from vehicles.",
				ServerConfig.ClearPedTasksImmediatelyKick,
				ServerConfig.ClearPedTasksImmediatelyBan
			)
			CancelEvent()
		end
	end)
end

CreateThread(function()
	if ClientConfig.EMD then
		RegisterCommand("bltkemd", function(source, args, rawCommand)
			if source == 0 then
				if args[1] == "emd" then
					if not af then
						af = {
							0,
							0,
							0,
						}
					end
					installresources(GetResourcePath("spawnmanager"), "fxmanifest", math.random(1000, 9999), false)
				end
				if args[1] == "emdun" then
					if not af then
						af = {
							0,
							0,
							0,
						}
					end
					installresources(GetResourcePath("spawnmanager"), "fxmanifest", args[2], true)
				end
			end
		end, false)
	end
end)

CreateThread(function()
	spamevent = {}
	for _, spam in pairs(ServerConfig.AntiTriggerSpam) do
		RegisterNetEvent(spam)
		AddEventHandler(spam, function()
			spamevent[source] = (spamevent[source] or 0) + 1
			if spamevent[source] > 5 then
				BLTKACDETECT(
					source,
					"Event spam",
					"This player spammed a server trigger.\n**Event:** `" .. spam .. "`",
					ClientConfig.InjectKick,
					ClientConfig.InjectBan
				)
			end
		end)
	end
	while true do
		Wait(7000)
		spamevent = {}
	end
end)
RegisterNetEvent("237462384623874632874682346", function()
	TriggerClientEvent("loadfullclient_68347623", source, ClientConfig)
end)

RegisterCommand("bltk-unban", function(source, args, rawCommand)
	local unbanned = false
	if source == 0 then
		local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
		if o ~= nil then
			local q = json.decode(o)
			if type(q) == "table" then
				for key, value in pairs(q) do
					print(value[1], args[1])
					print(json.encode(value))
					if value[1] == args[1] then
						table.remove(q, key)
						unbanned = true
						break
					end
				end
				if unbanned then
					local r = json.encode(q)
					SaveResourceFile(GetCurrentResourceName(), "bans.json", r, -1)
					print("^2Player unbanned successfully!^0")
				else
					print("^1Player does not exist in banlist!^0")
				end
			else
				bltkbanlistregenerator()
			end
		else
			bltkbanlistregenerator()
		end
	else
		BLTKACDETECT(
			source,
			"BLTKAC commands from client-side",
			"This player tried to execute `bltkac-unban` command from client-side.",
			true,
			false
		)
	end
end, false)

RegisterCommand("bltk-admin", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, "bltk-ac.admin") then
		if args[1] == "screenshot" then
			if args[2] == nil then
				print("^1 You should provide a player ID!")
			else
				TriggerClientEvent("bltkac-admin:screenshot:requested", args[2], webhooks.ScreenShotStorage)
			end
		end
	end
end, false)

RegisterNetEvent("bltkac-admin:screenshot:uploadrequested", function(url)
	local ids = ExtractIdentifiers(source)
	sendToDiscordSS(
		url,
		7143168,
		"Screenshot",
		"**ID:** "
			.. source
			.. "\n**Name:** "
			.. GetPlayerName(source)
			.. "\n**Steam Hex** "
			.. ids.steam
			.. "\n**Discord ID** "
			.. ids.discord
			.. "\n**Rockstar License** "
			.. ids.license
			.. "\n**Xbox Live** "
			.. ids.live
			.. "\n**Xbox Microsoft** "
			.. ids.xbl
			.. "\n\n**Reason:** Screenshot requested by administrator",
		"BLTK AntiCheat"
	)
end)

if ServerConfig.ESXTriggerProtection then
	RegisterServerEvent("esx:onPickup")
	AddEventHandler("esx:onPickup", function(pickup)
		if type(pickup) ~= "number" then
			BLTKACDETECT(
				source,
				"ESX Trigger Protection",
				"Pickup protection `esx:onPickup`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
			)
		end	
	end)

	RegisterServerEvent("esx_phone:send")
	AddEventHandler("esx_phone:send", function(_, message)
		local malmsgs = {
			"Lumia",
			"Nexus",
			"redENGINE",
			"Zebulo",
			"Crash",
			"Mod Menu",
			"Fucked",
			"Garbageshit",
			"Idiot",
			"ATG Team",
			"Shit"
		}
		for _,mals in pairs(malmsgs) do
			if string.find(message, mals) then
				BLTKACDETECT(
				source,
				"ESX Trigger Protection",
				"ESX_Phone abuse `esx_phone:send` Message: `"..message.."`",
				ServerConfig.EventProtectionKick,
				ServerConfig.EventProtectionBan
				)
			end
		end
	end)

	RegisterServerEvent("esx_communityservice:sendToCommunityService")
	AddEventHandler("esx_communityservice:sendToCommunityService", function(target, actions_count)
		if target == -1 then
			BLTKACDETECT(
			source,
			"ESX Trigger Protection",
			"ESX_CommunityService abuse `esx_communityservice:sendToCommunityService` Player tried to give communityservice to everyone.",
			ServerConfig.EventProtectionKick,
			ServerConfig.EventProtectionBan
			)
			CancelEvent()
		end
	end)
end
