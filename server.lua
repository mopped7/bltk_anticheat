function bltkbanlistregenerator()
	local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	if not o or o == "" then
		SaveResourceFile(GetCurrentResourceName(), "bans.json", "[]", -1)

	else
		local p = json.decode(o)
		if not p then
			SaveResourceFile(GetCurrentResourceName(), "bans.json", "[]", -1)
			p = {}

		end
	end
end;
bltkbanlistregenerator()
function bltkBan(source)
	local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	if o ~= nil then
		local q = json.decode(o)
		if type(q) == "table" then
			table.insert(q, GetPlayerIdentifiers(source))
			local r = json.encode(q)
			SaveResourceFile(GetCurrentResourceName(), "bans.json", r, -1)
		else
			bltkbanlistregenerator()
		end
	else
		bltkbanlistregenerator()
	end
end;

local function V(Q, W, X)
	local Y = GetPlayerIdentifiers(source)
	local v = false;
	local A = tostring(GetPlayerEndpoint(source))
	local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	if o ~= nil then
		local p = json.decode(o)
		if type(p) == "table" then
			for _, a0 in ipairs(GetPlayerIdentifiers(source)) do
				for m, n in ipairs(p) do
					for a5, a6 in ipairs(n) do
						if a6 == a0 or n == a0 then
							v = true;
							break
						end
					end;
					if v then
						break
					end
				end;
				if v then
					break
				end
			end;
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
end;


AddEventHandler("playerConnecting", V)


function sendToDiscord(color, name, message, footer)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = footer,
              },
          }
      }
  
    PerformHttpRequest(webhooks.Log, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  end
function ExtractIdentifiers(src)
    local identifiers = {
        steam = "Unknown",
        ip = "Unknown",
        discord = "Unknown",
        license = "Unknown",
        xbl = "Unknown",
        live = "Unknown"
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end


-- AntiNuke Var resets
Citizen.CreateThread(function()
    particlesSpawned = 0
    chatBeforeBlock = 0
    veh = {}
    ped = {}
    while true do
        Citizen.Wait(5000)
        particlesSpawned = 0
        chatBeforeBlock = 0
        veh = {}
        ped = {}
    end
end)

-- Args checker
function BLTKACARGCHECK (basevar, maxvalue)
    for n, k in ipairs(basevar) do
        if k > maxvalue then
            return true
        end
    end
    return false
end

RegisterNetEvent("bltkac_detection")
AddEventHandler("bltkac_detection", function(mreason, description, kickstatus, banstatus)
    if ServerConfig.DebugMode then
        local ids = ExtractIdentifiers(source);
        sendToDiscord(7143168, "(DEBUG MODE)User detect - "..mreason, "**ID:** "..source.."\n**Name:** "..GetPlayerName(source).."\n**Steam Hex** "..ids.steam.."\n**Discord ID** "..ids.discord.."\n**Rockstar License** "..ids.license.."\n**Xbox Live** "..ids.live.."\n**Xbox Microsoft** "..ids.xbl.."\n\n**Reason:** "..description, "BLTK AntiCheat")
    else
        if IsPlayerAceAllowed(source, "bltk-ac.bypass") then
        
        else
            local ids = ExtractIdentifiers(source);
            if banstatus then
                bltkBan(source)
            end
            sendToDiscord(7143168, "User detect - "..mreason, "**ID:** "..source.."\n**Name:** "..GetPlayerName(source).."\n**Steam Hex** "..ids.steam.."\n**Discord ID** "..ids.discord.."\n**Rockstar License** "..ids.license.."\n**Xbox Live** "..ids.live.."\n**Xbox Microsoft** "..ids.xbl.."\n\n**Reason:** "..description, "BLTK AntiCheat")
            if kickstatus then
                DropPlayer(source, ServerConfig.KickMessage)
            end
            
        end
    end
end)

function BLTKACDETECT(source, mreason, description, kickstatus, banstatus)
    if ServerConfig.DebugMode then
        local ids = ExtractIdentifiers(source);
        sendToDiscord(7143168, "(DEBUG MODE)User detect - "..mreason, "**ID:** "..source.."\n**Name:** "..GetPlayerName(source).."\n**Steam Hex** "..ids.steam.."\n**Discord ID** "..ids.discord.."\n**Rockstar License** "..ids.license.."\n**Xbox Live** "..ids.live.."\n**Xbox Microsoft** "..ids.xbl.."\n\n**Reason:** "..description, "BLTK AntiCheat")
    else
        if IsPlayerAceAllowed(source, "bltk-ac.bypass") then
        
        else
            local ids = ExtractIdentifiers(source);
            if banstatus then
                bltkBan(source)
            end
            sendToDiscord(7143168, "User detect - "..mreason, "**ID:** "..source.."\n**Name:** "..GetPlayerName(source).."\n**Steam Hex** "..ids.steam.."\n**Discord ID** "..ids.discord.."\n**Rockstar License** "..ids.license.."\n**Xbox Live** "..ids.live.."\n**Xbox Microsoft** "..ids.xbl.."\n\n**Reason:** "..description, "BLTK AntiCheat")
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

if ServerConfig.PCKMenu then
    RegisterCommand('dd', function(source, args)
        BLTKACDETECT(source, "PCKMenu", "This player tried to use a PCK menu", ServerConfig.PCKMenuKick, ServerConfig.PCKMenuBan)
    end)
    
    RegisterCommand('ck', function(source, args)
        BLTKACDETECT(source, "PCKMenu", "This player tried to use a PCK menu", ServerConfig.PCKMenuKick, ServerConfig.PCKMenuBan)
    end)

    RegisterNetEvent('showSprites')
    AddEventHandler('showSprites', function()
        BLTKACDETECT(source, "PCKMenu", "This player tried to use a PCK menu", ServerConfig.PCKMenuKick, ServerConfig.PCKMenuBan)
    end)

    RegisterNetEvent('showBlipz')
    AddEventHandler('showBlipz', function()
        BLTKACDETECT(source, "PCKMenu", "This player tried to use a PCK menu", ServerConfig.PCKMenuKick, ServerConfig.PCKMenuBan)
    end)
end

if ServerConfig.ScramblerScript then
    RegisterServerEvent('613cd851-bb4c-4825-8d4a-423caa7bf2c3')
    AddEventHandler('613cd851-bb4c-4825-8d4a-423caa7bf2c3', function(name)
        BLTKACDETECT(source, "Scrambler Injection", "This player tried to inject a scrambler script", ServerConfig.ScramblerKick, ServerConfig.ScramblerBan)
    end)
end

if ServerConfig.StaminaCheck then
    AddEventHandler("ResetPlayerStamina", function(source)
        BLTKACDETECT(source, "UnlimitedStamina", "Unlimited stamina system blocked.", ServerConfig.StaminaCheckKick, ServerConfig.StaminaCheckBan)
    end)
end

if ServerConfig.WeaponCheckSwitch then
    if ServerConfig.WeaponRemoveCheck then
        AddEventHandler("RemoveWeaponEvent", function(__source, data)
            BLTKACDETECT(__source, "RemoveWeapon Detection", "This player tried to remove a weapon.", ServerConfig.WeaponKick, ServerConfig.WeaponBan)
        end)
        AddEventHandler("RemoveAllWeaponsEvent", function(__source, data)
            BLTKACDETECT(__source, "RemoveWeapon Detection", "This player tried to remove a weapon.", ServerConfig.WeaponKick, ServerConfig.WeaponBan)
        end)
    end
    if ServerConfig.WeaponAddCheck then
        AddEventHandler("GiveAllWeapons", function(__source, data)
            BLTKACDETECT(__source, "GiveWeapon Detection", "This player tried to add a weapon.", ServerConfig.WeaponKick, ServerConfig.WeaponBan)
        end)
    
        AddEventHandler("giveWeaponEvent", function(__source, data)
            if data.GiveAllWeapons == true then
                BLTKACDETECT(__source, "GiveWeapon Detection", "This player tried to add a weapon.", ServerConfig.WeaponKick, ServerConfig.WeaponBan)
            end
        end)
    end
end

if ServerConfig.ParticleFX then
    if ServerConfig.ParticleFXSpamDetecter then
        AddEventHandler('ptFxEvent', function(__source, data)
            particlesSpawned = (particlesSpawned or 0) + 1
            if particlesSpawned > ServerConfig.ParticleFXSpamDetecterMaxFX then
                BLTKACDETECT(__source, "[ANTINUKE] ParticleFX Spam", "ParticleFX Spam detected.", ServerConfig.ParticleFXSpamKick, ServerConfig.ParticleFXSpamBan)
            end
        end)
    end
end

if ServerConfig.ChatController then
    AddEventHandler("chatMessage", function(source, name, message)
        if ServerConfig.ChatAntiSpam then
            chatBeforeBlock = chatBeforeBlock + 1
            if chatBeforeBlock > ServerConfig.MaxMessageSpam then
                BLTKACDETECT(source, "AntiChatSpam", "This player sent more then "..ServerConfig.MaxMessageSpam.." message in 5000ms (5s)", ServerConfig.ChatAntiSpamKick, ServerConfig.ChatAntiSpamBan)
            end
        end
        if ServerConfig.ChatBlacklistedWord then
            for i, v in pairs(ServerConfig.BlacklistedWords) do
                if string.find(message, v) then
                    BLTKACDETECT(source, "Blacklisted word", "This player tried to say a blacklisted word.\n**Word:** `"..v.."`", ServerConfig.ChatBlacklistedWordKick, ServerConfig.ChatBlacklistedWordBan)
                end
            end
        end
    end)
end

if ServerConfig.BlacklistedEventsSystem then
    for k, events in pairs(ServerConfig.BlacklistedEvents) do
    RegisterServerEvent(events)
    AddEventHandler(
    events,
    function()
        BLTKACDETECT(source, "Event Executor", "This player tried to execute a blacklisted event.\n**Executed event:** `"..events.."`", ServerConfig.ChatBlacklistedWordKick, ServerConfig.ChatBlacklistedWordBan)
            end
        )
    end
end

if ServerConfig.AntiExplosionNuke then
    AddEventHandler('explosionEvent', function(source, a8)

            if ServerConfig.ExplosionDetections[a8.explosionType] then
                local a9 = ServerConfig.ExplosionDetections[a8.explosionType]
                if a9.log then
                    BLTKACDETECT(source, "Explosion", "This player tried to use a blocked explosion.", false, false)
                end;
                if a9.kick then
                    BLTKACDETECT(source, "Explosion", "This player tried to use a blocked explosion.", true, false)
                end
                if a9.ban then
                    BLTKACDETECT(source, "Explosion", "This player tried to use a blocked explosion.", true, true)
                end
            end;
            CancelEvent()
    end)
end

if ServerConfig.AntiEntityNuke then
    AddEventHandler("entityCreating",  function(entity,player)
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
        if veh[source] > ServerConfig.MaxVehs then 
            BLTKACDETECT(source, "[ANITNUKE] Vehicle", "This player spawned more than "..ServerConfig.MaxVehs.." entity in 5000 ms", true, true)
        
            CancelEvent()
        end
        end
    end
    end
        if GetEntityType(entity) == 1 then 
        if eType == 6 or eType == 7 or eType == 0 then
            ped[source] = (ped[source] or 0) + 1
            if ped[source] > ServerConfig.MaxPeds then 
            
                BLTKACDETECT(source, "[ANITNUKE] Ped", "This player spawned more than "..ServerConfig.MaxPeds.." entity in 5000 ms", true, true)
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
            BLTKACDETECT(source, "Event executed", "This player executed `"..svevent.."` with a >"..maxvalue.." value `["..args1.."]`", ServerConfig.ParticleFXSpamKick, ServerConfig.ParticleFXSpamBan)
        elseif args2 ~= nil and args2 > maxvalue then
            BLTKACDETECT(source, "Event executed", "This player executed `"..svevent.."` with a >"..maxvalue.." value `["..args1, args2.."]`", ServerConfig.ParticleFXSpamKick, ServerConfig.ParticleFXSpamBan)
        elseif args3 ~= nil and args3 > maxvalue then
            BLTKACDETECT(source, "Event executed", "This player executed `"..svevent.."` with a >"..maxvalue.." value `["..args1, args2, args3.."]`", ServerConfig.ParticleFXSpamKick, ServerConfig.ParticleFXSpamBan)
        elseif args4 ~= nil and args4 > maxvalue then
            BLTKACDETECT(source, "Event executed", "This player executed `"..svevent.."` with a >"..maxvalue.." value `["..args1, args2, args3, args4.."]`", ServerConfig.ParticleFXSpamKick, ServerConfig.ParticleFXSpamBan)
        end
    end)
end