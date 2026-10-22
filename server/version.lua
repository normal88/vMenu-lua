VersionCheck = {}

local RESOURCE = GetCurrentResourceName()
local CHECK_INTERVAL = 6 * 60 * 60 * 1000

VersionCheck.Current = GetResourceMetadata(RESOURCE, "version", 0) or "0.0.0"
VersionCheck.Latest = nil
VersionCheck.Url = nil

local function GetRepository()
    local repository = GetResourceMetadata(RESOURCE, "repository", 0) or ""
    repository = repository:gsub("^%s+", ""):gsub("%s+$", "")
    repository = repository:gsub("^https?://github%.com/", ""):gsub("/+$", ""):gsub("%.git$", "")
    if repository:match("^[%w%-%._]+/[%w%-%._]+$") then
        return repository
    end
    return nil
end

local function ParseVersion(version)
    local parts = {}
    for number in tostring(version or ""):gsub("^[vV]", ""):gmatch("%d+") do
        parts[#parts + 1] = tonumber(number)
    end
    return parts
end

function VersionCheck.Compare(a, b)
    local left, right = ParseVersion(a), ParseVersion(b)
    for i = 1, math.max(#left, #right) do
        local x, y = left[i] or 0, right[i] or 0
        if x ~= y then
            return x > y and 1 or -1
        end
    end
    return 0
end

local function Request(url)
    local p = promise.new()
    PerformHttpRequest(url, function(status, body)
        p:resolve({ status = status, body = body })
    end, "GET", "", {
        ["User-Agent"] = "vMenu-version-check",
        ["Accept"] = "application/vnd.github+json",
    })
    return Citizen.Await(p)
end

local function FetchLatest(repository)
    local release = Request(("https://api.github.com/repos/%s/releases/latest"):format(repository))
    if release.status == 200 and release.body then
        local ok, data = pcall(json.decode, release.body)
        if ok and type(data) == "table" and data.tag_name then
            return tostring(data.tag_name):gsub("^[vV]", ""), data.html_url
        end
    end

    local manifest = Request(("https://raw.githubusercontent.com/%s/HEAD/fxmanifest.lua"):format(repository))
    if manifest.status == 200 and manifest.body then
        local version = manifest.body:match("\nversion%s+['\"]([^'\"]+)['\"]") or manifest.body:match("^version%s+['\"]([^'\"]+)['\"]")
        if version then
            return version, ("https://github.com/%s"):format(repository)
        end
    end
    return nil, nil
end

function VersionCheck.Run()
    local repository = GetRepository()
    if not repository then return end

    local latest, url = FetchLatest(repository)
    if not latest then return end

    VersionCheck.Latest = latest
    VersionCheck.Url = url
    GlobalState.vMenuLatestVersion = latest

    if VersionCheck.Compare(latest, VersionCheck.Current) > 0 then
        print(("^3[vMenu]^7 Update available: ^1%s^7 -> ^2%s^7  %s"):format(VersionCheck.Current, latest, url or ""))
    end
end

CreateThread(function()
    Wait(10000)
    while true do
        VersionCheck.Run()
        Wait(CHECK_INTERVAL)
    end
end)
