PlayerOptionsMenu = {}

local menu = nil

PlayerOptionsMenu.PlayerGodMode = false
PlayerOptionsMenu.PlayerInvisible = false
PlayerOptionsMenu.PlayerStamina = false
PlayerOptionsMenu.PlayerFastRun = false
PlayerOptionsMenu.PlayerFastSwim = false
PlayerOptionsMenu.PlayerSuperJump = false
PlayerOptionsMenu.PlayerNoRagdoll = false
PlayerOptionsMenu.PlayerNeverWanted = false
PlayerOptionsMenu.PlayerIsIgnored = false
PlayerOptionsMenu.PlayerStayInVehicle = false
PlayerOptionsMenu.PlayerFrozen = false
PlayerOptionsMenu.SuperJumpLevel = 1

local SUPER_JUMP_LEVELS = { 1.0, 1.25, 1.5, 1.75, 2.0 }
local SUPER_JUMP_BOOST_FRAMES = 3

function PlayerOptionsMenu.CreateMenu()
    menu = Menu:New("Player Options", "Player Related Options")
    MenuController:AddMenu(menu)

    local playerGodModeCheckbox = MenuCheckboxItem:New("God Mode", "Makes you invincible.",
        PlayerOptionsMenu.PlayerGodMode)
    local invisibleCheckbox = MenuCheckboxItem:New("Invisible", "Makes you invisible to yourself and others.",
        PlayerOptionsMenu.PlayerInvisible)
    local unlimitedStaminaCheckbox = MenuCheckboxItem:New("Unlimited Stamina",
        "Allows you to run forever without slowing down.", PlayerOptionsMenu.PlayerStamina)
    local fastRunCheckbox = MenuCheckboxItem:New("Fast Run", "Get ~g~Snail~s~ powers and run very fast!",
        PlayerOptionsMenu.PlayerFastRun)
    local fastSwimCheckbox = MenuCheckboxItem:New("Fast Swim", "Get ~g~Snail 2.0~s~ powers and swim super fast!",
        PlayerOptionsMenu.PlayerFastSwim)
    local superJumpOptions = { "Off" }
    for level = 1, #SUPER_JUMP_LEVELS do
        superJumpOptions[#superJumpOptions + 1] = "Level " .. level
    end
    local superJumpList = MenuListItem:New("Super Jump", superJumpOptions,
        PlayerOptionsMenu.PlayerSuperJump and (PlayerOptionsMenu.SuperJumpLevel + 1) or 1,
        "Get ~g~Snail 3.0~s~ powers and jump like a champ! Level 1 is the normal super jump, higher levels jump higher.")
    local noRagdollCheckbox = MenuCheckboxItem:New("No Ragdoll",
        "Disables player ragdoll, makes you not fall off your bike anymore.", PlayerOptionsMenu.PlayerNoRagdoll)
    local neverWantedCheckbox = MenuCheckboxItem:New("Never Wanted", "Disables all wanted levels.",
        PlayerOptionsMenu.PlayerNeverWanted)
    local everyoneIgnoresPlayerCheckbox = MenuCheckboxItem:New("Everyone Ignore Player", "Everyone will leave you alone.",
        PlayerOptionsMenu.PlayerIsIgnored)
    local playerStayInVehicleCheckbox = MenuCheckboxItem:New("Stay In Vehicle",
        "NPCs will not be able to drag you out of your vehicle.", PlayerOptionsMenu.PlayerStayInVehicle)
    local playerFrozenCheckbox = MenuCheckboxItem:New("Freeze Player", "Freezes your current location.",
        PlayerOptionsMenu.PlayerFrozen)

    local wantedLevelList = { "No Wanted Level", "1", "2", "3", "4", "5" }
    local setWantedLevel = MenuListItem:New("Set Wanted Level", wantedLevelList, 1,
        "Set your wanted level by selecting a value.")

    local setArmorItem = MenuListItem:New("Set Armor Type", {
        "No Armor",
        GetLabelText("WT_BA_0"),
        GetLabelText("WT_BA_1"),
        GetLabelText("WT_BA_2"),
        GetLabelText("WT_BA_3"),
        GetLabelText("WT_BA_4")
    }, 1, "Set the armor level/type for your player.")

    local healPlayerBtn = MenuItem:New("Heal Player", "Give the player max health.")
    local clearBloodBtn = MenuItem:New("Clear Blood", "Clear the blood off your player.")
    local cleanPlayerBtn = MenuItem:New("Clean Player Clothes", "Clean your player clothes.")
    local dryPlayerBtn = MenuItem:New("Dry Player Clothes", "Make your player clothes dry.")
    local wetPlayerBtn = MenuItem:New("Wet Player Clothes", "Make your player clothes wet.")
    local suicidePlayerBtn = MenuItem:New("~r~Commit Suicide", "Kill yourself by taking the pill.")

    local playerScenariosList = MenuListItem:New("Player Scenarios", PedScenarios.Scenarios, 1,
        "Select a scenario and hit enter to start it. Selecting another scenario will override the current scenario. If you're already playing the selected scenario, selecting it again will stop the scenario.")
    local stopScenarioBtn = MenuItem:New("Force Stop Scenario",
        "This will force a playing scenario to stop immediately, without waiting for it to finish its 'stopping' animation.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POGod) then
        menu:AddMenuItem(playerGodModeCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POInvisible) then
        menu:AddMenuItem(invisibleCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POUnlimitedStamina) then
        menu:AddMenuItem(unlimitedStaminaCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POFastRun) then
        menu:AddMenuItem(fastRunCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POFastSwim) then
        menu:AddMenuItem(fastSwimCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POSuperjump) then
        menu:AddMenuItem(superJumpList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PONoRagdoll) then
        menu:AddMenuItem(noRagdollCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PONeverWanted) then
        menu:AddMenuItem(neverWantedCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POSetWanted) then
        menu:AddMenuItem(setWantedLevel)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POIgnored) then
        menu:AddMenuItem(everyoneIgnoresPlayerCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POStayInVehicle) then
        menu:AddMenuItem(playerStayInVehicleCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POFreeze) then
        menu:AddMenuItem(playerFrozenCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POMaxHealth) then
        menu:AddMenuItem(healPlayerBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POMaxArmor) then
        menu:AddMenuItem(setArmorItem)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POClearBlood) then
        menu:AddMenuItem(clearBloodBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POCleanPlayer) then
        menu:AddMenuItem(cleanPlayerBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PODryPlayer) then
        menu:AddMenuItem(dryPlayerBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POWetPlayer) then
        menu:AddMenuItem(wetPlayerBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POScenarios) then
        menu:AddMenuItem(playerScenariosList)
        menu:AddMenuItem(stopScenarioBtn)
    end

    menu:AddMenuItem(suicidePlayerBtn)

    menu.OnCheckboxChange = function(sender, item, index, checked)
        local ped = PlayerPedId()
        local playerId = PlayerId()

        if item == playerGodModeCheckbox then
            PlayerOptionsMenu.PlayerGodMode = checked
            SetEntityInvincible(ped, checked)
            Notify.Success("God Mode " .. (checked and "~g~enabled" or "~r~disabled") .. ".")
            TriggerServerEvent("vMenu:LogPlayerOption", "God Mode", checked)

        elseif item == invisibleCheckbox then
            PlayerOptionsMenu.PlayerInvisible = checked
            SetEntityVisible(ped, not checked, false)
            Notify.Success("Invisibility " .. (checked and "~g~enabled" or "~r~disabled") .. ".")
            TriggerServerEvent("vMenu:LogPlayerOption", "Invisibility", checked)

        elseif item == unlimitedStaminaCheckbox then
            PlayerOptionsMenu.PlayerStamina = checked
            StatSetInt(GetHashKey("MP0_STAMINA"), checked and 100 or 0, true)
            Notify.Success("Unlimited Stamina " .. (checked and "~g~enabled" or "~r~disabled") .. ".")

        elseif item == fastRunCheckbox then
            PlayerOptionsMenu.PlayerFastRun = checked
            SetRunSprintMultiplierForPlayer(playerId, checked and 1.49 or 1.0)
            Notify.Success("Fast Run " .. (checked and "~g~enabled" or "~r~disabled") .. ".")

        elseif item == fastSwimCheckbox then
            PlayerOptionsMenu.PlayerFastSwim = checked
            SetSwimMultiplierForPlayer(playerId, checked and 1.49 or 1.0)
            Notify.Success("Fast Swim " .. (checked and "~g~enabled" or "~r~disabled") .. ".")

        elseif item == noRagdollCheckbox then
            PlayerOptionsMenu.PlayerNoRagdoll = checked
            SetPedCanRagdoll(ped, not checked)
            Notify.Success("No Ragdoll " .. (checked and "~g~enabled" or "~r~disabled") .. ".")

        elseif item == neverWantedCheckbox then
            PlayerOptionsMenu.PlayerNeverWanted = checked
            if checked then
                SetMaxWantedLevel(0)
                ClearPlayerWantedLevel(playerId)
            else
                SetMaxWantedLevel(5)
            end
            Notify.Success("Never Wanted " .. (checked and "~g~enabled" or "~r~disabled") .. ".")
            TriggerServerEvent("vMenu:LogPlayerOption", "Never Wanted", checked)

        elseif item == everyoneIgnoresPlayerCheckbox then
            PlayerOptionsMenu.PlayerIsIgnored = checked
            SetEveryoneIgnorePlayer(playerId, checked)
            SetPoliceIgnorePlayer(playerId, checked)
            SetPlayerCanBeHassledByGangs(playerId, not checked)
            Notify.Success("Everyone Ignore Player " .. (checked and "~g~enabled" or "~r~disabled") .. ".")

        elseif item == playerStayInVehicleCheckbox then
            PlayerOptionsMenu.PlayerStayInVehicle = checked
            Notify.Success("Stay In Vehicle " .. (checked and "~g~enabled" or "~r~disabled") .. ".")

        elseif item == playerFrozenCheckbox then
            PlayerOptionsMenu.PlayerFrozen = checked
            FreezeEntityPosition(ped, checked)
            Notify.Success("Freeze Player " .. (checked and "~g~enabled" or "~r~disabled") .. ".")
        end

        PlayerOptionsMenu.SaveSettings()
    end

    menu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == superJumpList then
            local enabled = newIndex > 1
            PlayerOptionsMenu.PlayerSuperJump = enabled
            if enabled then
                PlayerOptionsMenu.SuperJumpLevel = newIndex - 1
                Notify.Success("Super Jump set to ~g~Level " .. PlayerOptionsMenu.SuperJumpLevel .. "~s~.")
            else
                Notify.Success("Super Jump ~r~disabled~s~.")
            end
            TriggerServerEvent("vMenu:LogPlayerOption",
                enabled and ("Super Jump (Level " .. PlayerOptionsMenu.SuperJumpLevel .. ")") or "Super Jump", enabled)
            PlayerOptionsMenu.SaveSettings()
        end
    end

    menu.OnListItemSelect = function(sender, item, selectedIndex, itemIndex)
        local ped = PlayerPedId()
        local playerId = PlayerId()

        if item == setWantedLevel then
            local wantedLevel = selectedIndex - 1
            SetPlayerWantedLevel(playerId, wantedLevel, false)
            SetPlayerWantedLevelNow(playerId, false)
            Notify.Success("Wanted level set to ~o~" .. wantedLevel .. "~s~.")

        elseif item == setArmorItem then
            local armorValue = (selectedIndex - 1) * 20
            SetPedArmour(ped, armorValue)
            Notify.Success("Armor set to ~o~" .. armorValue .. "~s~.")

        elseif item == playerScenariosList then
            local scenarioName = PedScenarios.Scenarios[selectedIndex]
            if scenarioName then
                PedScenarios.PlayScenario(scenarioName)
            end
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        local ped = PlayerPedId()

        if item == healPlayerBtn then
            SetEntityHealth(ped, GetEntityMaxHealth(ped))
            Notify.Success("Player healed.")

        elseif item == clearBloodBtn then
            ClearPedBloodDamage(ped)
            ResetPedVisibleDamage(ped)
            ClearPedDamageDecalByZone(ped, 0, "ALL")
            ClearPedDamageDecalByZone(ped, 1, "ALL")
            ClearPedDamageDecalByZone(ped, 2, "ALL")
            ClearPedDamageDecalByZone(ped, 3, "ALL")
            ClearPedDamageDecalByZone(ped, 4, "ALL")
            ClearPedDamageDecalByZone(ped, 5, "ALL")
            Notify.Success("Blood cleared.")

        elseif item == cleanPlayerBtn then
            ClearPedBloodDamage(ped)
            Notify.Success("Player clothes have been cleaned.")

        elseif item == dryPlayerBtn then
            SetPedWetnessHeight(ped, 0.0)
            Notify.Success("Player is now dry.")

        elseif item == wetPlayerBtn then
            SetPedWetnessHeight(ped, 2.0)
            Notify.Success("Player is now wet.")

        elseif item == stopScenarioBtn then
            PedScenarios.ForceStopScenario()

        elseif item == suicidePlayerBtn then
            PlayerOptionsMenu.CommitSuicide()
        end
    end

    return menu
end

function PlayerOptionsMenu.GetMenu()
    if menu == nil then
        PlayerOptionsMenu.CreateMenu()
    end
    return menu
end

function PlayerOptionsMenu.CommitSuicide()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, true) then
        Notify.Error("You can't commit suicide while in a vehicle, get out first.")
        return
    end

    if IsEntityDead(ped) then
        Notify.Error("You are already dead.")
        return
    end

    local currentMenu = MenuController:GetCurrentMenu()
    if currentMenu then
        currentMenu:CloseMenu()
    end

    Citizen.CreateThread((function()
        local animDict = "mp_suicide"
        local animName = "pill"

        RequestAnimDict(animDict)
        local timeout = GetGameTimer() + 5000
        while not HasAnimDictLoaded(animDict) do
            if GetGameTimer() > timeout then
                Notify.Error("Failed to load animation.")
                SetEntityHealth(ped, 0)
                return
            end
            Citizen.Wait(0)
        end

        ped = PlayerPedId()

        ClearPedTasks(ped)

        TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

        Citizen.Wait(5000)

        ped = PlayerPedId()
        SetEntityHealth(ped, 0)

        RemoveAnimDict(animDict)

        Notify.Alert("You committed suicide.")
    end))
end

function PlayerOptionsMenu.SaveSettings()
    local settings = {
        PlayerGodMode       = PlayerOptionsMenu.PlayerGodMode,
        PlayerInvisible     = PlayerOptionsMenu.PlayerInvisible,
        PlayerStamina       = PlayerOptionsMenu.PlayerStamina,
        PlayerFastRun       = PlayerOptionsMenu.PlayerFastRun,
        PlayerFastSwim      = PlayerOptionsMenu.PlayerFastSwim,
        PlayerSuperJump     = PlayerOptionsMenu.PlayerSuperJump,
        SuperJumpLevel      = PlayerOptionsMenu.SuperJumpLevel,
        PlayerNoRagdoll     = PlayerOptionsMenu.PlayerNoRagdoll,
        PlayerNeverWanted   = PlayerOptionsMenu.PlayerNeverWanted,
        PlayerIsIgnored     = PlayerOptionsMenu.PlayerIsIgnored,
        PlayerStayInVehicle = PlayerOptionsMenu.PlayerStayInVehicle,
        PlayerFrozen        = PlayerOptionsMenu.PlayerFrozen,
    }
    SetResourceKvp("vmenu_player_options", json.encode(settings))
end

function PlayerOptionsMenu.LoadSettings()
    local data = GetResourceKvpString("vmenu_player_options")
    if not data or data == "" then return end

    local settings = json.decode(data)
    if not settings then return end

    local ped      = PlayerPedId()
    local playerId = PlayerId()
    local P        = PermissionsManager.Permission

    if settings.PlayerGodMode and PermissionsManager.IsAllowed(P.POGod) then
        PlayerOptionsMenu.PlayerGodMode = true
    end

    if settings.PlayerInvisible and PermissionsManager.IsAllowed(P.POInvisible) then
        PlayerOptionsMenu.PlayerInvisible = true
    end

    if settings.PlayerStamina and PermissionsManager.IsAllowed(P.POUnlimitedStamina) then
        PlayerOptionsMenu.PlayerStamina = true
        StatSetInt(GetHashKey("MP0_STAMINA"), 100, true)
    end

    if settings.PlayerFastRun and PermissionsManager.IsAllowed(P.POFastRun) then
        PlayerOptionsMenu.PlayerFastRun = true
        SetRunSprintMultiplierForPlayer(playerId, 1.49)
    end

    if settings.PlayerFastSwim and PermissionsManager.IsAllowed(P.POFastSwim) then
        PlayerOptionsMenu.PlayerFastSwim = true
        SetSwimMultiplierForPlayer(playerId, 1.49)
    end

    local level = tonumber(settings.SuperJumpLevel)
    if level and SUPER_JUMP_LEVELS[level] then
        PlayerOptionsMenu.SuperJumpLevel = level
    end
    if settings.PlayerSuperJump and PermissionsManager.IsAllowed(P.POSuperjump) then
        PlayerOptionsMenu.PlayerSuperJump = true
    end

    if settings.PlayerNoRagdoll and PermissionsManager.IsAllowed(P.PONoRagdoll) then
        PlayerOptionsMenu.PlayerNoRagdoll = true
        SetPedCanRagdoll(ped, false)
    end

    if settings.PlayerNeverWanted and PermissionsManager.IsAllowed(P.PONeverWanted) then
        PlayerOptionsMenu.PlayerNeverWanted = true
    end

    if settings.PlayerIsIgnored and PermissionsManager.IsAllowed(P.POIgnored) then
        PlayerOptionsMenu.PlayerIsIgnored = true
        SetEveryoneIgnorePlayer(playerId, true)
        SetPoliceIgnorePlayer(playerId, true)
        SetPlayerCanBeHassledByGangs(playerId, false)
    end

    if settings.PlayerStayInVehicle and PermissionsManager.IsAllowed(P.POStayInVehicle) then
        PlayerOptionsMenu.PlayerStayInVehicle = true
        SetPlayerCanBeDraggedOutOfVehicle(playerId, false)
    end

    if settings.PlayerFrozen and PermissionsManager.IsAllowed(P.POFreeze) then
        PlayerOptionsMenu.PlayerFrozen = true
        FreezeEntityPosition(ped, true)
    end
end

function PlayerOptionsMenu.EnforcePermissions()
    local ped      = PlayerPedId()
    local playerId = PlayerId()
    local P        = PermissionsManager.Permission
    local dirty    = false

    local function revoke(flag, perm, onRevoke)
        if PlayerOptionsMenu[flag] and not PermissionsManager.IsAllowed(perm) then
            PlayerOptionsMenu[flag] = false
            if onRevoke then onRevoke() end
            dirty = true
        end
    end

    revoke("PlayerGodMode", P.POGod, function()
        SetEntityInvincible(ped, false)
    end)

    revoke("PlayerInvisible", P.POInvisible, function()
        SetEntityVisible(ped, true, false)
    end)

    revoke("PlayerStamina", P.POUnlimitedStamina, function()
        StatSetInt(GetHashKey("MP0_STAMINA"), 0, true)
    end)

    revoke("PlayerFastRun", P.POFastRun, function()
        SetRunSprintMultiplierForPlayer(playerId, 1.0)
    end)

    revoke("PlayerFastSwim", P.POFastSwim, function()
        SetSwimMultiplierForPlayer(playerId, 1.0)
    end)

    revoke("PlayerSuperJump", P.POSuperjump, nil)

    revoke("PlayerNoRagdoll", P.PONoRagdoll, function()
        SetPedCanRagdoll(ped, true)
    end)

    revoke("PlayerNeverWanted", P.PONeverWanted, function()
        SetMaxWantedLevel(5)
    end)

    revoke("PlayerIsIgnored", P.POIgnored, function()
        SetEveryoneIgnorePlayer(playerId, false)
        SetPoliceIgnorePlayer(playerId, false)
        SetPlayerCanBeHassledByGangs(playerId, true)
    end)

    revoke("PlayerStayInVehicle", P.POStayInVehicle, function()
        SetPlayerCanBeDraggedOutOfVehicle(playerId, true)
    end)

    revoke("PlayerFrozen", P.POFreeze, function()
        FreezeEntityPosition(ped, false)
    end)

    if dirty then
        PlayerOptionsMenu.SaveSettings()
    end
end

local inJump = false
local jumpBoostFrames = 0
local jumpTargetSpeed = 0.0
local jumpProtected = false
local jumpLandedAt = nil

local function EndJumpProtection(ped)
    if not jumpProtected then return end
    jumpProtected = false
    jumpLandedAt = nil
    SetEntityInvincible(ped, PlayerOptionsMenu.PlayerGodMode == true)
    SetPedCanRagdoll(ped, PlayerOptionsMenu.PlayerNoRagdoll ~= true)
end

local function UpdateSuperJump(ped, playerId, enabled)
    if enabled then
        SetSuperJumpThisFrame(playerId)
    end

    local airborne = IsEntityInAir(ped)
    local jumping = IsPedJumping(ped)
    local multiplier = SUPER_JUMP_LEVELS[PlayerOptionsMenu.SuperJumpLevel] or 1.0

    if not jumping and not airborne then
        inJump = false
    elseif enabled and jumping and airborne and not inJump then
        inJump = true
        local speed = GetEntityVelocity(ped).z
        if multiplier > 1.0 and speed > 0.0 then
            jumpTargetSpeed = speed * multiplier
            jumpBoostFrames = SUPER_JUMP_BOOST_FRAMES
            jumpProtected = true
            SetEntityInvincible(ped, true)
            SetPedCanRagdoll(ped, false)
        end
    end

    if jumpBoostFrames > 0 then
        local velocity = GetEntityVelocity(ped)
        if velocity.z < jumpTargetSpeed then
            SetEntityVelocity(ped, velocity.x, velocity.y, jumpTargetSpeed)
        end
        jumpBoostFrames = jumpBoostFrames - 1
    end

    if jumpProtected then
        if airborne or jumping then
            jumpLandedAt = nil
        elseif not jumpLandedAt then
            jumpLandedAt = GetGameTimer()
        elseif GetGameTimer() - jumpLandedAt > 500 then
            EndJumpProtection(ped)
        end
    end
end

Citizen.CreateThread((function()
    while true do
        local sleep = 1000

        local godMode = PlayerOptionsMenu.PlayerGodMode
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.POGod)

        local superJump = PlayerOptionsMenu.PlayerSuperJump
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.POSuperjump)

        local neverWanted = PlayerOptionsMenu.PlayerNeverWanted
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.PONeverWanted)

        local invisible = PlayerOptionsMenu.PlayerInvisible
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.POInvisible)
            and ConfigManager.GetSettingsBool(ConfigManager.Setting.vmenu_handle_invisibility)

        local frozen = PlayerOptionsMenu.PlayerFrozen
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.POFreeze)

        if superJump or jumpProtected then
            sleep = 0
        elseif godMode or neverWanted or invisible or frozen then
            sleep = 250
        end

        local ped, playerId
        if godMode or superJump or jumpProtected or neverWanted or invisible or frozen then
            ped = PlayerPedId()
            playerId = PlayerId()
        end

        if godMode and ped then
            SetEntityInvincible(ped, true)
        end

        if (superJump or jumpProtected) and ped then
            UpdateSuperJump(ped, playerId, superJump)
        end

        if neverWanted and playerId then
            if GetPlayerWantedLevel(playerId) > 0 then
                ClearPlayerWantedLevel(playerId)
            end
            if GetMaxWantedLevel() > 0 then
                SetMaxWantedLevel(0)
            end
        end

        if invisible and ped then
            SetEntityVisible(ped, false, false)
        end

        if frozen and ped then
            FreezeEntityPosition(ped, true)
        end

        Citizen.Wait(sleep)
    end
end))

return PlayerOptionsMenu
