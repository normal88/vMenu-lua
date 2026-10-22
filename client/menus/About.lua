AboutMenu = {}

local menu = nil

local vMenuVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0) or "unknown"

local function IsNewer(latest, current)
    local function parse(version)
        local parts = {}
        for number in tostring(version or ""):gsub("^[vV]", ""):gmatch("%d+") do
            parts[#parts + 1] = tonumber(number)
        end
        return parts
    end
    local a, b = parse(latest), parse(current)
    for i = 1, math.max(#a, #b) do
        local x, y = a[i] or 0, b[i] or 0
        if x ~= y then
            return x > y
        end
    end
    return false
end

function AboutMenu.CreateMenu()
    menu = Menu:New("vMenu", "About vMenu")
    MenuController:AddMenu(menu)

    local versionItem = MenuItem:New("vMenu Version", "This server is using vMenu ~b~~h~" .. vMenuVersion .. "~h~~s~.")
    versionItem.Label = "~h~" .. vMenuVersion .. "~h~"
    versionItem.Enabled = false

    local latestVersion = GlobalState.vMenuLatestVersion
    if latestVersion and IsNewer(latestVersion, vMenuVersion) then
        versionItem.Description = "A newer vMenu version is available: ~g~" .. latestVersion .. "~s~."
        versionItem.Label = "~y~" .. vMenuVersion .. "~s~"
    end

    local creditsItem = MenuItem:New("About vMenu / Credits", "vMenu is made by ~b~Vespura~s~. For more info, checkout ~b~www.vespura.com/vmenu~s~. Thank you to: Deltanic, Brigliar, IllusiveTea, Shayan Doust, zr0iq and Golden (among others) for the contributions made to this menu. This Lua version is a community conversion of the original C# vMenu.")
    creditsItem.Enabled = false

    menu:AddMenuItem(versionItem)
    menu:AddMenuItem(creditsItem)

    local serverInfoMessage = ConfigManager.GetSettingsString(ConfigManager.Setting.vmenu_server_info_message, "")
    if serverInfoMessage and serverInfoMessage ~= "" then
        local serverInfoItem = MenuItem:New("Developed By", "VSX-Team")

        local serverWebsite = ConfigManager.GetSettingsString(ConfigManager.Setting.vmenu_server_info_website_url, "")
        if serverWebsite and serverWebsite ~= "" then
            serverInfoItem.Label = "VSX-Team"
        end

        serverInfoItem.Enabled = false
        menu:AddMenuItem(serverInfoItem)
    end

    local discordItem = MenuItem:New("Discord", "https://discord.gg/VSX")
    discordItem.Label = "discord.gg/VSX"
    discordItem.Enabled = false
    menu:AddMenuItem(discordItem)

    return menu
end

function AboutMenu.GetMenu()
    if menu == nil then
        AboutMenu.CreateMenu()
    end
    return menu
end

return AboutMenu
