Theme = {}

Theme.Themes = {
    {
        code = "default",
        name = "Default",
        colors = {
            itemsBackground = { 0, 0, 0, 180 },
            subtitleBar = { 0, 0, 0, 255 },
            description = { 0, 0, 0, 200 },
            selectedRow = { 255, 255, 255, 225 },
            accent = nil,
            text = 255,
            disabledText = 109,
            selectedText = 0,
            selectedDisabledText = 50,
            lightHighlight = true,
        },
    },
    {
        code = "dark",
        name = "Dark",
        colors = {
            itemsBackground = { 10, 10, 12, 225 },
            subtitleBar = { 16, 16, 20, 255 },
            description = { 10, 10, 12, 230 },
            selectedRow = { 44, 44, 50, 245 },
            accent = { 66, 135, 245, 255 },
            text = 200,
            disabledText = 100,
            selectedText = 255,
            selectedDisabledText = 130,
            lightHighlight = false,
        },
    },
}

local KVP_KEY = "vmenu_theme"
local current = Theme.Themes[1]

local function FindTheme(code)
    for _, theme in ipairs(Theme.Themes) do
        if theme.code == code then return theme end
    end
    return nil
end

function Theme.Colors()
    return current.colors
end

function Theme.GetIndex()
    for i, theme in ipairs(Theme.Themes) do
        if theme == current then return i end
    end
    return 1
end

function Theme.GetNames()
    local names = {}
    for i, theme in ipairs(Theme.Themes) do
        names[i] = theme.name
    end
    return names
end

function Theme.Set(code)
    local theme = FindTheme(code)
    if not theme then return end
    current = theme
    SetResourceKvp(KVP_KEY, code)
end

current = FindTheme(GetResourceKvpString(KVP_KEY)) or FindTheme(GetConvar("vmenu_theme", "default")) or current

return Theme
