Locale = {}

Locale.Languages = {
    { code = "en", name = "English" },
    { code = "ar", name = "العربية" },
    { code = "es", name = "Español" },
    { code = "pt", name = "Português (BR)" },
    { code = "de", name = "Deutsch" },
}
Locale.Strings = {}
Locale.Templates = {}

Locale.FONT_NAME = "A9eelsh"
Locale.FONT_SCALE = 1.0
Locale.FEED_LINE_CHARS = 34

local KVP_KEY = "vmenu_language"
local CACHE_LIMIT = 4000

local language = "en"
local fontId = nil
local caches = { translate = {}, shape = {}, wrap = {} }
local cacheSize = 0
local compiledTemplates = nil

local function IsKnownLanguage(code)
    for _, lang in ipairs(Locale.Languages) do
        if lang.code == code then return true end
    end
    return false
end

local function ClearCaches()
    caches = { translate = {}, shape = {}, wrap = {} }
    cacheSize = 0
    compiledTemplates = nil
end

function Locale.GetLanguage()
    return language
end

function Locale.GetLanguageIndex()
    for i, lang in ipairs(Locale.Languages) do
        if lang.code == language then return i end
    end
    return 1
end

function Locale.Upper(text)
    return (text:gsub("[a-z]", string.upper):gsub("\195([\160-\190])", function(c)
        if c == "\183" then return nil end
        return "\195" .. string.char(c:byte() - 32)
    end))
end

function Locale.GetLanguageNames()
    local names = {}
    for i, lang in ipairs(Locale.Languages) do
        names[i] = lang.name
    end
    return names
end

function Locale.SetLanguage(code)
    if not IsKnownLanguage(code) then return end
    language = code
    SetResourceKvp(KVP_KEY, code)
    ClearCaches()
end

do
    local saved = GetResourceKvpString(KVP_KEY)
    local serverDefault = GetConvar("vmenu_language", "en")
    if IsKnownLanguage(saved) then
        language = saved
    elseif IsKnownLanguage(serverDefault) then
        language = serverDefault
    end
end

function Locale.GetArabicFont()
    if not fontId then
        RegisterFontFile(Locale.FONT_NAME)
        fontId = RegisterFontId(Locale.FONT_NAME)
    end
    return fontId
end

local function Remember(kind, key, value)
    if cacheSize >= CACHE_LIMIT then
        caches = { translate = {}, shape = {}, wrap = {} }
        cacheSize = 0
    end
    caches[kind][key] = value
    cacheSize = cacheSize + 1
end

local function SplitCodes(text)
    local prefix, suffix, s = "", "", text
    while true do
        local code, rest = s:match("^(%s*~[%w_]+~)(.*)$")
        if not code then break end
        prefix, s = prefix .. code, rest
    end
    while true do
        local rest, code = s:match("^(.-)(~[%w_]+~%s*)$")
        if not rest then break end
        s, suffix = rest, code .. suffix
    end
    local lead, core, trail = s:match("^(%s*)(.-)(%s*)$")
    return prefix .. lead, core, trail .. suffix
end

local function EscapePattern(s)
    return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"))
end

local function GetTemplates()
    if compiledTemplates then return compiledTemplates end
    compiledTemplates = {}
    for english, translated in pairs(Locale.Templates[language] or {}) do
        local prefix, core, suffix = SplitCodes(english)
        if prefix ~= "" and translated:sub(1, #prefix) == prefix then
            translated = translated:sub(#prefix + 1)
        end
        if suffix ~= "" and translated:sub(-#suffix) == suffix then
            translated = translated:sub(1, -#suffix - 1)
        end
        english = core

        local parts, literalLength = {}, 0
        for literal in (english .. "%s"):gmatch("(.-)%%s") do
            parts[#parts + 1] = EscapePattern(literal)
            literalLength = literalLength + #literal
        end
        compiledTemplates[#compiledTemplates + 1] = {
            pattern = "^" .. table.concat(parts, "(.-)") .. "$",
            replacement = translated,
            weight = literalLength,
        }
    end
    table.sort(compiledTemplates, function(a, b) return a.weight > b.weight end)
    return compiledTemplates
end

local function FillTemplate(replacement, captures)
    local index = 0
    local out = replacement:gsub("%%(%d)", function(n)
        return Locale.Translate(captures[tonumber(n)] or "")
    end)
    out = out:gsub("%%s", function()
        index = index + 1
        return Locale.Translate(captures[index] or "")
    end)
    return out
end

function Locale.Translate(text)
    if language == "en" or type(text) ~= "string" or text == "" then
        return text
    end
    local cached = caches.translate[text]
    if cached then return cached end

    local result = text
    local prefix, core, suffix = SplitCodes(text)
    local strings = Locale.Strings[language]
    local exact = strings and strings[core]
    if not exact and strings and core:find("^%l") then
        exact = strings[(core:gsub("(%a)([%w']*)", function(first, rest) return first:upper() .. rest end))]
    end
    if exact then
        result = prefix .. exact .. suffix
    elseif core ~= "" then
        for _, template in ipairs(GetTemplates()) do
            local captures = { core:match(template.pattern) }
            if captures[1] ~= nil then
                result = prefix .. FillTemplate(template.replacement, captures) .. suffix
                break
            end
        end
    end

    Remember("translate", text, result)
    return result
end

local FORMS = {}
for _, entry in ipairs({
    { 0x0621, 0xFE80, 1 }, { 0x0622, 0xFE81, 2 }, { 0x0623, 0xFE83, 2 }, { 0x0624, 0xFE85, 2 },
    { 0x0625, 0xFE87, 2 }, { 0x0626, 0xFE89, 4 }, { 0x0627, 0xFE8D, 2 }, { 0x0628, 0xFE8F, 4 },
    { 0x0629, 0xFE93, 2 }, { 0x062A, 0xFE95, 4 }, { 0x062B, 0xFE99, 4 }, { 0x062C, 0xFE9D, 4 },
    { 0x062D, 0xFEA1, 4 }, { 0x062E, 0xFEA5, 4 }, { 0x062F, 0xFEA9, 2 }, { 0x0630, 0xFEAB, 2 },
    { 0x0631, 0xFEAD, 2 }, { 0x0632, 0xFEAF, 2 }, { 0x0633, 0xFEB1, 4 }, { 0x0634, 0xFEB5, 4 },
    { 0x0635, 0xFEB9, 4 }, { 0x0636, 0xFEBD, 4 }, { 0x0637, 0xFEC1, 4 }, { 0x0638, 0xFEC5, 4 },
    { 0x0639, 0xFEC9, 4 }, { 0x063A, 0xFECD, 4 }, { 0x0641, 0xFED1, 4 }, { 0x0642, 0xFED5, 4 },
    { 0x0643, 0xFED9, 4 }, { 0x0644, 0xFEDD, 4 }, { 0x0645, 0xFEE1, 4 }, { 0x0646, 0xFEE5, 4 },
    { 0x0647, 0xFEE9, 4 }, { 0x0648, 0xFEED, 2 }, { 0x0649, 0xFEEF, 2 }, { 0x064A, 0xFEF1, 4 },
}) do
    local letter, base, count = entry[1], entry[2], entry[3]
    local forms = { base }
    for i = 1, count - 1 do forms[i + 1] = base + i end
    FORMS[letter] = forms
end
FORMS[0x0640] = { 0x0640, 0x0640, 0x0640, 0x0640 }

local LAM_ALEF = { [0x0622] = 0xFEF5, [0x0623] = 0xFEF7, [0x0625] = 0xFEF9, [0x0627] = 0xFEFB }

local MIRROR = {
    [0x28] = 0x29, [0x29] = 0x28, [0x5B] = 0x5D, [0x5D] = 0x5B, [0x7B] = 0x7D, [0x7D] = 0x7B,
    [0x3C] = 0x3E, [0x3E] = 0x3C, [0xAB] = 0xBB, [0xBB] = 0xAB,
    [0x2190] = 0x2192, [0x2192] = 0x2190,
}

local function IsDiacritic(cp)
    return (cp >= 0x064B and cp <= 0x065F) or cp == 0x0670
end

local function JoinsForward(cp)
    local forms = FORMS[cp]
    return forms ~= nil and #forms == 4
end

local function GetClass(glyph)
    if glyph.atom then return "L" end
    local cp = glyph.cp
    if (cp >= 0x30 and cp <= 0x39) or (cp >= 0x0660 and cp <= 0x0669) or (cp >= 0x06F0 and cp <= 0x06F9) then
        return "L"
    end
    if (cp >= 0x41 and cp <= 0x5A) or (cp >= 0x61 and cp <= 0x7A) or (cp >= 0xC0 and cp < 0x0590 and cp ~= 0xD7 and cp ~= 0xF7) then
        return "L"
    end
    if (cp >= 0x0590 and cp <= 0x08FF) or (cp >= 0xFB1D and cp <= 0xFDFF) or (cp >= 0xFE70 and cp <= 0xFEFF) then
        return "R"
    end
    return "N"
end

local function ParseLine(line)
    local glyphs = {}
    local color, bold = nil, false
    local pos, len = 1, #line
    while pos <= len do
        local code = line:match("^~[%w_]+~", pos)
        if code then
            local name = code:sub(2, -2)
            if name == "h" then
                bold = not bold
            elseif #name == 1 and name:match("%a") then
                color = (name ~= "s") and name or nil
            else
                glyphs[#glyphs + 1] = { atom = code, color = color, bold = bold }
            end
            pos = pos + #code
        else
            local cp = utf8.codepoint(line, pos)
            if not IsDiacritic(cp) then
                glyphs[#glyphs + 1] = { cp = cp, color = color, bold = bold }
            end
            pos = utf8.offset(line, 2, pos)
        end
    end
    return glyphs
end

local function ApplyJoining(glyphs)
    local base = {}
    for i, glyph in ipairs(glyphs) do
        base[i] = glyph.cp or false
    end

    local out = {}
    local i, n = 1, #glyphs
    while i <= n do
        local glyph = glyphs[i]
        local forms = base[i] and FORMS[base[i]]
        if not forms then
            out[#out + 1] = glyph
            i = i + 1
        else
            local prevJoins = base[i - 1] and JoinsForward(base[i - 1]) or false
            local nextCp = base[i + 1]
            local ligature = base[i] == 0x0644 and nextCp and LAM_ALEF[nextCp]
            if ligature then
                glyph.cp = ligature + (prevJoins and 1 or 0)
                out[#out + 1] = glyph
                i = i + 2
            else
                local nextJoins = #forms == 4 and nextCp and FORMS[nextCp] ~= nil or false
                local form
                if prevJoins and nextJoins then
                    form = forms[4]
                elseif prevJoins then
                    form = forms[2]
                elseif nextJoins then
                    form = forms[3]
                end
                glyph.cp = form or forms[1]
                out[#out + 1] = glyph
                i = i + 1
            end
        end
    end
    return out
end

local function Reorder(glyphs)
    local n = #glyphs
    local visual = {}
    for i = 1, n do
        visual[i] = glyphs[n - i + 1]
        visual[i].class = GetClass(visual[i])
    end

    local k = 1
    while k <= n do
        if visual[k].class == "L" then
            local first, last, m = k, k, k + 1
            while m <= n and visual[m].class ~= "R" do
                if visual[m].class == "L" then last = m end
                m = m + 1
            end
            for a = first, last do visual[a].ltr = true end
            local a, b = first, last
            while a < b do
                visual[a], visual[b] = visual[b], visual[a]
                a, b = a + 1, b - 1
            end
            k = last + 1
        else
            local glyph = visual[k]
            if glyph.class == "N" and glyph.cp and MIRROR[glyph.cp] then
                glyph.cp = MIRROR[glyph.cp]
            end
            k = k + 1
        end
    end
    return visual
end

local function Emit(visual)
    local buffer = {}
    local color, bold = nil, false
    for _, glyph in ipairs(visual) do
        if glyph.color ~= color then
            buffer[#buffer + 1] = "~" .. (glyph.color or "s") .. "~"
            color = glyph.color
        end
        if glyph.bold ~= bold then
            buffer[#buffer + 1] = "~h~"
            bold = glyph.bold
        end
        buffer[#buffer + 1] = glyph.atom or utf8.char(glyph.cp)
    end
    return table.concat(buffer)
end

local function ShapeLine(line)
    return Emit(Reorder(ApplyJoining(ParseLine(line))))
end

function Locale.HasArabic(text)
    return text:find("[\216-\219][\128-\191]") ~= nil or text:find("\239[\173-\187][\128-\191]") ~= nil
end

local function NeedsShaping(text)
    return text:find("\216[\161-\191]") ~= nil or text:find("\217[\128-\138]") ~= nil
end

function Locale.Shape(text)
    if type(text) ~= "string" or not NeedsShaping(text) then
        return text
    end
    local cached = caches.shape[text]
    if cached then return cached end

    local ok, result = pcall(function()
        local lines = {}
        for line in (text .. "~n~"):gmatch("(.-)~n~") do
            lines[#lines + 1] = ShapeLine(line)
        end
        return table.concat(lines, "~n~")
    end)
    if not ok then result = text end

    Remember("shape", text, result)
    return result
end

function Locale.Display(text, defaultFont)
    if type(text) ~= "string" or text == "" then
        return text, defaultFont, 1.0, false
    end
    text = Locale.Translate(text)
    if not Locale.HasArabic(text) then
        return text, defaultFont, 1.0, false
    end
    text = Locale.Shape(text):gsub("←", "<"):gsub("→", ">")
    return text, Locale.GetArabicFont(), Locale.FONT_SCALE, true
end

local function MeasureWidth(text, font, scale)
    BeginTextCommandGetWidth("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetTextFont(font)
    SetTextScale(scale, scale)
    return EndTextCommandGetWidth(true)
end

function Locale.WrapShaped(text, font, scale, maxWidth)
    local key = text .. "\0" .. scale .. "\0" .. maxWidth
    local cached = caches.wrap[key]
    if cached then return cached end

    local lines = {}
    for paragraph in (text .. "~n~"):gmatch("(.-)~n~") do
        local current = nil
        for word in paragraph:gmatch("%S+") do
            local candidate = current and (current .. " " .. word) or word
            if current and MeasureWidth(Locale.Shape(candidate), font, scale) > maxWidth then
                lines[#lines + 1] = Locale.Shape(current)
                current = word
            else
                current = candidate
            end
        end
        lines[#lines + 1] = Locale.Shape(current or "")
    end

    local result = table.concat(lines, "~n~"):gsub("←", "<"):gsub("→", ">")
    Remember("wrap", key, result)
    return result
end

function Locale.ForScaleform(text)
    if type(text) ~= "string" or text == "" then return text end
    text = Locale.Translate(text)
    if not NeedsShaping(text) then return text end

    local lines = {}
    for paragraph in (text .. "~n~"):gmatch("(.-)~n~") do
        local current, length = nil, 0
        for word in paragraph:gmatch("%S+") do
            local wordLength = utf8.len((word:gsub("~[%w_]+~", ""))) or #word
            if current and length + 1 + wordLength > Locale.FEED_LINE_CHARS then
                lines[#lines + 1] = Locale.Shape(current)
                current, length = word, wordLength
            else
                current = current and (current .. " " .. word) or word
                length = length + (length > 0 and 1 or 0) + wordLength
            end
        end
        lines[#lines + 1] = Locale.Shape(current or "")
    end

    Locale.GetArabicFont()
    return "<FONT FACE='" .. Locale.FONT_NAME .. "'>" .. table.concat(lines, "~n~") .. "</FONT>"
end

return Locale
