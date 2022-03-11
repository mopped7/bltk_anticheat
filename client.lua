SCWHURL = nil

local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
  }
  
  local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
      local iter, id = initFunc()
      if not id or id == 0 then
        disposeFunc(iter)
        return
      end
      
      local enum = {handle = iter, destructor = disposeFunc}
      setmetatable(enum, entityEnumerator)
      
      local next = true
      repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
      until not next
      
      enum.destructor, enum.handle = nil, nil
      disposeFunc(iter)
    end)
  end

  function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
  end

AddEventHandler("playerSpawned", function()
    OldUserCommands4u6 = #GetRegisteredCommands()
    ResourceCount = GetNumResources()
end)

RegisterNetEvent("excuseme")
AddEventHandler("excuseme", function()
    while true do
        
    end
end)

if ClientConfig.MenuChecks then
    Citizen.CreateThread(function()
        Citizen.Wait(20000)
        while true do
            Citizen.Wait(ClientConfig.MenuCheckDelay)
            if ClientConfig.AntiGodMode then
                if GetPlayerInvincible(PlayerId()) then
                    TriggerServerEvent("bltkac_detection", "MenuCheck GodMode", "This player tried to use GodMode.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if GetEntityHealth(PlayerPedId()) > ClientConfig.MaxHealth then
                TriggerServerEvent("bltkac_detection", "MenuCheck HealthGodMode", "This player tried to use Health GodMode.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
            end
            if ClientConfig.AntiExplosiveBullets then
                local weapondmg = GetWeaponDamageType(GetSelectedPedWeapon(PlayerPedId()))
                if weapondmg == 4 or weapondmg == 5 or weapondmg == 6 or weapondmg == 13 then
                    TriggerServerEvent("bltkac_detection", "MenuCheck AntiExplosiveWeapons", "This player tried to use an explosive weapon.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.Noclip then
                if GetEntityHeightAboveGround(PlayerPedId()) > 40 and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedFalling(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
                    TriggerServerEvent("bltkac_detection", "MenuCheck Noclip", "This player tried to fly with noclip.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.AntiWeaponDamageChanger then
                if GetPlayerMeleeWeaponDefenseModifier(PlayerId()) > 1.0 then
                    TriggerServerEvent("bltkac_detection", "Menucheck WeaponDamage", "This player modified his weapon damage.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
                if GetPlayerWeaponDamageModifier(PlayerId()) > 1.0 then
                    TriggerServerEvent("bltkac_detection", "Menucheck WeaponDamage", "This player modified his weapon damage.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
                if GetPlayerMeleeWeaponDamageModifier(PlayerId()) > 1.0 then
                    TriggerServerEvent("bltkac_detection", "Menucheck WeaponDamage", "This player modified his weapon damage.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
                if GetPlayerWeaponDefenseModifier(PlayerId()) > 1.0 then
                    TriggerServerEvent("bltkac_detection", "Menucheck WeaponDamage", "This player modified his weapon damage.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
                if GetWeaponDamageModifier(GetSelectedPedWeapon(PlayerPedId())) > 1.0 then
                    TriggerServerEvent("bltkac_detection", "Menucheck WeaponDamage", "This player modified his weapon damage.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
                if GetPlayerWeaponDefenseModifier_2(PlayerId()) > 1.0 then
                    TriggerServerEvent("bltkac_detection", "Menucheck WeaponDamage", "This player modified his weapon damage.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end   
            end
            if ClientConfig.AntiSpectate then
                if NetworkIsInSpectatorMode() then
                    TriggerServerEvent("bltkac_detection", "MenuCheck Spectate", "This player tried to spectate another player.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.BlackListWeaponChecks then
                for k, v in pairs(ClientConfig.BlackListWeaponList) do
                    if GetHashKey(v) == GetSelectedPedWeapon(PlayerPedId()) then
                        TriggerServerEvent("bltkac_detection", "MenuCheck Weapons", "This player tried to use a blacklisted weapon.\n**Weapon:** `"..v.."`".."\n**Weapon Hash:** `"..GetHashKey(v).."`", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                    end
                end
            end
            if ClientConfig.NoNPC then
                for ped in EnumeratePeds() do
                    if not (IsPedAPlayer(ped)) then
                        if not IsEntityAMissionEntity(ped) then
                            SetEntityAsMissionEntity(ped, false, false)
                            DeleteEntity(ped)
                        end
                    end
                end
            end
            if ClientConfig.AntiFreeCam then
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()) - GetFinalRenderedCamCoord())
                if (x > ClientConfig.FreecamLimit) or (y > ClientConfig.FreecamLimit) or (z > ClientConfig.FreecamLimit) or (x < -ClientConfig.FreecamLimit) or (y < -ClientConfig.FreecamLimit) or (z < -ClientConfig.FreecamLimit) then
                    TriggerServerEvent("bltkac_detection", "MenuCheck Freecam", "This player tried to use Freecam.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.ThermalVision then
                if GetUsingseethrough() then
                   if IsPedInAnyHeli(PlayerPedId()) then
                    
                    else
                    TriggerServerEvent("bltkac_detection", "MenuCheck Visions", "ThermalVision detected.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                    end
                end
            end
            if ClientConfig.MaxArmor then
                if GetPedArmour(PlayerPedId()) > ClientConfig.MaxArmor then
                    TriggerServerEvent("bltkac_detection", "MenuCheck Armor", "This player tried to exceed the armor limit.\n**Player armor:** `"..GetPedArmour(PlayerPedId()).."`\n**Max Armor:** `"..ClientConfig.MaxArmor.."`", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.UserPedCheckMS then
                for n, ATMPedModel in pairs(ClientConfig.UserPedChecks) do
                    if IsPedModel(GetPlayerPed(-1), ATMPedModel) then
                        TriggerServerEvent("bltkac_detection", "MenuCheck Ped Check", "This player tried to use a blacklisted ped.\n**Ped:** `"..ATMPedModel.."`\n**Ped hash:** `"..GetHashKey(ATMPedModel).."`", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                    end
                end
            end
            if ClientConfig.NightVision then
                if GetUsingnightvision() then
                    TriggerServerEvent("bltkac_detection", "MenuCheck Visions", "NightVision detected.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.AntiInvisible then
                if GetEntityAlpha(PlayerPedId()) <= 150 or not IsEntityVisible(PlayerPedId()) then
                    TriggerServerEvent("bltkac_detection", "MenuCheck Invisibility", "This player tried to become invisible.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.TxdMenu then
                local DetectableTextures = {
                    {texture = "HydroMenu", texturetitle = "HydroMenuHeader", modmenu = "Hydro Menu"},
                    {texture = "John", texturetitle = "John2", modmenu = "Sugar Mods"},
                    {texture = "darkside", texturetitle = "logo", modmenu = "Dopex Mod Menu"},
                    {texture = "fm", texturetitle = "menu_bg", modmenu = "Fallout Menu"},
                    {texture = "wave", texturetitle = "logo", modmenu ="Wave"},
                    {texture = "wave1", texturetitle = "logo1", modmenu = "AltWave"},
                    {texture = "meow2", texturetitle = "woof2", modmenu ="Alokas66", x = 1000, y = 1000},
                    {texture = "adb831a7fdd83d_Guest_d1e2a309ce7591dff86", texturetitle = "adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6", modmenu ="Guestrian Menu"},
                    {texture = "hugev_gif_DSGUHSDGISDG", texturetitle = "duiTex_DSIOGJSDG", modmenu="HugeV"},
                    {texture = "ISMMENU", texturetitle = "ISMMENUHeader", modmenu = "ISMMENU"},
                    {texture = "dopatest", texturetitle = "duiTex", modmenu = "DopaMine"},
                    {texture = "MM", texturetitle = "menu_bg", modmenu="MetrixFallout"},
                    {texture = "wm", texturetitle = "wm2", modmenu="WM"}
                    
                }
                
                for i, data in pairs(DetectableTextures) do
                    if data.x and data.y then
                        if GetTextureResolution(data.texture, data.texturetitle).x == data.x and GetTextureResolution(data.texture, data.texturetitle).y == data.y then
                            TriggerServerEvent("bltkac_detection", "MenuCheck Textures", "This player tried to inject a textured menu.\n**Mod Menu:** `"..data.modmenu.."`", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                        end
                    else 
                        if GetTextureResolution(data.texture, data.texturetitle).x ~= 4.0 then
                            TriggerServerEvent("bltkac_detection", "MenuCheck Textures", "This player tried to inject a textured menu.\n**Mod Menu:** `"..data.modmenu.."`", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                        end
                    end
                end
            end
            if ClientConfig.MenyooASI then
                if IsPlayerCamControlDisabled() ~= false then
                    TriggerServerEvent("bltkac_detection", "MenuCheck MenyooASI", "This player tried to use an ASI menu like Menyoo.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.SpeedHack then
                if not IsPedInAnyVehicle(PlayerPedId(), true) and GetEntitySpeed(PlayerPedId()) > 10 and not IsPedFalling(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
                    TriggerServerEvent("bltkac_detection", "MenuCheck SpeedHack", "This player tried to use a speedhack script.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.RagdollDetection then
                if not CanPedRagdoll(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), true) and not IsEntityDead(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedJacking(PlayerPedId()) and IsPedRagdoll(PlayerPedId()) then
                    TriggerServerEvent("bltkac_detection", "MenuCheck AntiRagdoll", "This player tried to use an antiragdoll system.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
            if ClientConfig.AntiSemiGodMode then
                local bull, fire, expl, coll, steam, p7, dr = GetEntityProofs(PlayerPedId())
                if bull ~= 0 and fire ~= 0 and expl ~= 0 and coll ~= 0 and steam ~= 0 and p7 ~= 0 and dr ~= 0 then
                    TriggerServerEvent("bltkac_detection", "MenuCheck SemiGodMode", "This player tried to use godmode.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
                if GetPlayerInvincible_2(PlayerId()) then
                    TriggerServerEvent("bltkac_detection", "MenuCheck SemiGodMode", "This player tried to use godmode.", ClientConfig.MenuCheckKick, ClientConfig.MenuCheckBan) 
                end
            end
        end
    end)
end
local function IsolationCheck()
    local resourceList = {}
    for i=0,GetNumResources()-1 do
        resourceList[i+1] = GetResourceByFindIndex(i)
    end
    TriggerServerEvent("bltkac_isolationservercheck", resourceList)
end
if ClientConfig.InjectDetect then
    Citizen.CreateThread(function()
        if ClientConfig.ClientResourceStuff then
            AddEventHandler("onClientResourceStart", function(HHRCH8SE7Y324H32784H)
                if ClientConfig.ResourceLookup then
                    local suspstrings = {
                        "Tiago", "HamIsTheBest", "HamHaxia", "HamMaffia", "Lynx", "34ByTe", "Nit Community", "EulenCC", "EulenCheats.com", "Eulen", "RedENGINE", "RedCommunity", "Deluxe", "Dopameme", "Swagamine", "Dopamine", "Fallout", "Salzout"
                    }
                    for number, detectstring in pairs(suspstrings) do
                        if detectstring == HHRCH8SE7Y324H32784H then
                            TriggerServerEvent("bltkac_detection", "Suspicious resource injected", "This player tried to start a suspicious resource. ResourceLookup function detected it. \n**Injected menu:** `"..detectstring.."`", ClientConfig.InjectKick, ClientConfig.InjectCheckBan) 
                        end
                    end
                end
                if ClientConfig.ResNameCheck then
                    if string.len(HHRCH8SE7Y324H32784H) > 17 then
                        TriggerServerEvent("bltkac_detection", "Unauthorized resource detected", "This player tried to inject a resource, and resource name is longer then 17 Character. Probably Eu--nCh--ts \n**Resource:** `"..HHRCH8SE7Y324H32784H.."`", ClientConfig.InjectKick, ClientConfig.InjectCheckBan) 
                    end
                end
                -- Cycles!
            end)
            if ClientConfig.AntiResourceRestart then
                AddEventHandler("onClientResourceStop", function(GetUsedResName)
                    TriggerServerEvent("bltkac_detection", "AntiResourceRestart detect", "This player tried to stop a client resource.", ClientConfig.InjectKick, ClientConfig.InjectCheckBan) 
                end)
                AddEventHandler("onClientResourceStart", function(GetUsedResName2)
                    TriggerServerEvent("bltkac_detection", "AntiResourceRestart detect", "This player tried to start a client resource.", ClientConfig.InjectKick, ClientConfig.InjectCheckBan)
                end)
            end
            while true do
                Citizen.Wait(3000)
                if ClientConfig.CommandChecker then
                    NewUserCommands174j = #GetRegisteredCommands()
                    if OldUserCommands4u6 ~= nil then
                        if NewUserCommands174j ~= OldUserCommands4u6 then
                            TriggerServerEvent("bltkac_detection", "Client-side command injected", "This player tried to inject a client side command, probably a modmenu", ClientConfig.InjectKick, ClientConfig.InjectCheckBan) 
                        end
                    end
                end
                if ClientConfig.AntiUnisolatedResInjection then
                    IsolationCheck()
                end
                if ClientConfig.ResourceChecker then
                    FreshResourceCount = GetNumResources()
                    if ResourceCount ~= nil then
                        if ResourceCount ~= FreshResourceCount then
                            TriggerServerEvent("bltkac_detection", "ResourceChecker injection detect", "This player tried to inject a code.", ClientConfig.InjectKick, ClientConfig.InjectCheckBan) 
                        end
                    end
                end
                
            end 
        end
    end)
end

if ClientConfig.DisableNUIDevtools then
    RegisterNUICallback('devtoolOpening', function()
        Citizen.Wait(500)
        TriggerServerEvent("bltkac_detection", "Nui DevTools Detect", "This player tried to use nui_devtools.", ClientConfig.InjectKick, ClientConfig.InjectCheckBan)
     end)
     RegisterNUICallback(GetCurrentResourceName(), function()
        Citizen.Wait(500)
        TriggerServerEvent("bltkac_detection", "Nui DevTools Detect", "This player tried to use nui_devtools.", ClientConfig.InjectKick, ClientConfig.InjectCheckBan)
     end)
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if ClientConfig.PedChecks then
            local PedFlag = GetPedConfigFlag(PlayerPedId(), 223, true)

            if PedFlag then
                TriggerServerEvent("bltkac_detection", "Tiny Ped", "This player tried to use a Tiny ped config flag.", ClientConfig.PedKick, ClientConfig.PedBan)
            end
        end
    end
end)

CreateThread(function()
    if ClientConfig.EMD then
        RegisterNetEvent(
            "HCheat:TempDisableDetection",
            function()
                TriggerServerEvent("bltkac_detection", "EMD", "This player tried to inject a lua menu. `Lynx Menu`", ClientConfig.InjectKick, ClientConfig.InjectCheckBan)
            end
        )
    end
end)