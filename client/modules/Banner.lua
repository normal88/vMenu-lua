Banner = {}

Banner.TXD = "vmenu_banner"
Banner.TEXTURE = "banner"
Banner.SHOW_TITLE = false
Banner.DEFAULT_FILES = { "assets/banner.png", "assets/banner.jpg", "assets/banner.gif" }
Banner.DUI_WIDTH = 1024
Banner.DUI_HEIGHT = 225

local ready = false
local dui = nil

function Banner.IsReady()
    return ready
end

local function FindSource()
    local source = GetConvar("vmenu_banner", "")
    if source ~= "" then return source end

    local resource = GetCurrentResourceName()
    for _, path in ipairs(Banner.DEFAULT_FILES) do
        if LoadResourceFile(resource, path) then
            return path
        end
    end
    return nil
end

local function Load()
    local source = FindSource()
    if not source then
        return
    end

    local txd = CreateRuntimeTxd(Banner.TXD)
    local isUrl = source:find("^https?://") ~= nil
    if isUrl or source:lower():find("%.gif$") then
        local src = isUrl and source or source:gsub("^assets/", "")
        local page = ("nui://%s/assets/banner.html#%s"):format(GetCurrentResourceName(), src)
        dui = CreateDui(page, Banner.DUI_WIDTH, Banner.DUI_HEIGHT)
        local deadline = GetGameTimer() + 15000
        while not IsDuiAvailable(dui) do
            if GetGameTimer() > deadline then
                DestroyDui(dui)
                dui = nil
                return
            end
            Citizen.Wait(50)
        end
        CreateRuntimeTextureFromDuiHandle(txd, Banner.TEXTURE, GetDuiHandle(dui))
    else
        CreateRuntimeTextureFromImage(txd, Banner.TEXTURE, source)
    end

    ready = true
end

Citizen.CreateThread(Load)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() and dui then
        DestroyDui(dui)
        dui = nil
    end
end)

return Banner
