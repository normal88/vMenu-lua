VehicleColors = {}

VehicleColors.ClassicColors = {
    { id = 0,   label = "BLACK",           name = "Black" },
    { id = 1,   label = "GRAPHITE",        name = "Graphite" },
    { id = 2,   label = "BLACK_STEEL",     name = "Black Steel" },
    { id = 3,   label = "DARK_SILVER",     name = "Dark Silver" },
    { id = 4,   label = "SILVER",          name = "Silver" },
    { id = 5,   label = "BLUE_SILVER",     name = "Blue Silver" },
    { id = 6,   label = "ROLLED_STEEL",    name = "Rolled Steel" },
    { id = 7,   label = "SHADOW_SILVER",   name = "Shadow Silver" },
    { id = 8,   label = "STONE_SILVER",    name = "Stone Silver" },
    { id = 9,   label = "MIDNIGHT_SILVER", name = "Midnight Silver" },
    { id = 10,  label = "CAST_IRON_SIL",   name = "Cast Iron Silver" },
    { id = 11,  label = "ANTHR_BLACK",     name = "Anthracite Black" },

    { id = 27,  label = "RED",             name = "Red" },
    { id = 28,  label = "TORINO_RED",      name = "Torino Red" },
    { id = 29,  label = "FORMULA_RED",     name = "Formula Red" },
    { id = 30,  label = "BLAZE_RED",       name = "Blaze Red" },
    { id = 31,  label = "GRACE_RED",       name = "Grace Red" },
    { id = 32,  label = "GARNET_RED",      name = "Garnet Red" },
    { id = 33,  label = "SUNSET_RED",      name = "Sunset Red" },
    { id = 34,  label = "CABERNET_RED",    name = "Cabernet Red" },
    { id = 35,  label = "CANDY_RED",       name = "Candy Red" },
    { id = 36,  label = "SUNRISE_ORANGE",  name = "Sunrise Orange" },
    { id = 37,  label = "GOLD",            name = "Gold" },
    { id = 38,  label = "ORANGE",          name = "Orange" },

    { id = 49,  label = "DARK_GREEN",      name = "Dark Green" },
    { id = 50,  label = "RACING_GREEN",    name = "Racing Green" },
    { id = 51,  label = "SEA_GREEN",       name = "Sea Green" },
    { id = 52,  label = "OLIVE_GREEN",     name = "Olive Green" },
    { id = 53,  label = "BRIGHT_GREEN",    name = "Bright Green" },
    { id = 54,  label = "PETROL_GREEN",    name = "Petrol Green" },

    { id = 61,  label = "GALAXY_BLUE",     name = "Galaxy Blue" },
    { id = 62,  label = "DARK_BLUE",       name = "Dark Blue" },
    { id = 63,  label = "SAXON_BLUE",      name = "Saxon Blue" },
    { id = 64,  label = "BLUE",            name = "Blue" },
    { id = 65,  label = "MARINER_BLUE",    name = "Mariner Blue" },
    { id = 66,  label = "HARBOR_BLUE",     name = "Harbor Blue" },
    { id = 67,  label = "DIAMOND_BLUE",    name = "Diamond Blue" },
    { id = 68,  label = "SURF_BLUE",       name = "Surf Blue" },
    { id = 69,  label = "NAUTICAL_BLUE",   name = "Nautical Blue" },
    { id = 70,  label = "ULTRA_BLUE",      name = "Ultra Blue" },
    { id = 71,  label = "PURPLE",          name = "Purple" },
    { id = 72,  label = "SPIN_PURPLE",     name = "Spin Purple" },
    { id = 73,  label = "RACING_BLUE",     name = "Racing Blue" },
    { id = 74,  label = "LIGHT_BLUE",      name = "Light Blue" },

    { id = 88,  label = "YELLOW",          name = "Yellow" },
    { id = 89,  label = "RACE_YELLOW",     name = "Race Yellow" },
    { id = 90,  label = "BRONZE",          name = "Bronze" },
    { id = 91,  label = "FLUR_YELLOW",     name = "Fluorescent Yellow" },
    { id = 92,  label = "LIME_GREEN",      name = "Lime Green" },

    { id = 94,  label = "UMBER_BROWN",     name = "Umber Brown" },
    { id = 95,  label = "CREEK_BROWN",     name = "Creek Brown" },
    { id = 96,  label = "CHOCOLATE_BROWN", name = "Chocolate Brown" },
    { id = 97,  label = "MAPLE_BROWN",     name = "Maple Brown" },
    { id = 98,  label = "SADDLE_BROWN",    name = "Saddle Brown" },
    { id = 99,  label = "STRAW_BROWN",     name = "Straw Brown" },
    { id = 100, label = "MOSS_BROWN",      name = "Moss Brown" },
    { id = 101, label = "BISON_BROWN",     name = "Bison Brown" },
    { id = 102, label = "WOODBEECH_BROWN", name = "Woodbeech Brown" },
    { id = 103, label = "BEECHWOOD_BROWN", name = "Beechwood Brown" },
    { id = 104, label = "SIENNA_BROWN",    name = "Sienna Brown" },
    { id = 105, label = "SANDY_BROWN",     name = "Sandy Brown" },
    { id = 106, label = "BLEECHED_BROWN",  name = "Bleached Brown" },
    { id = 107, label = "CREAM",           name = "Cream" },

    { id = 111, label = "WHITE",           name = "White" },
    { id = 112, label = "FROST_WHITE",     name = "Frost White" },

    { id = 135, label = "HOT PINK",        name = "Hot Pink" },
    { id = 136, label = "SALMON_PINK",     name = "Salmon Pink" },
    { id = 137, label = "PINK",            name = "Pink" },
    { id = 138, label = "BRIGHT_ORANGE",   name = "Bright Orange" },

    { id = 141, label = "MIDNIGHT_BLUE",   name = "Midnight Blue" },
    { id = 142, label = "MIGHT_PURPLE",    name = "Might Purple" },
    { id = 143, label = "WINE_RED",        name = "Wine Red" },

    { id = 145, label = "BRIGHT_PURPLE",   name = "Bright Purple" },
    { id = 146, label = "VERY_DARK_BLUE",  name = "Very Dark Blue" },
    { id = 147, label = "BLACK_GRAPHITE",  name = "Black Graphite" },

    { id = 150, label = "LAVA_RED",        name = "Lava Red" },
}

VehicleColors.MatteColors = {
    { id = 12,  label = "BLACK",         name = "Matte Black" },
    { id = 13,  label = "GREY",          name = "Matte Grey" },
    { id = 14,  label = "LIGHT_GREY",    name = "Matte Light Grey" },

    { id = 39,  label = "RED",           name = "Matte Red" },
    { id = 40,  label = "DARK_RED",      name = "Matte Dark Red" },
    { id = 41,  label = "ORANGE",        name = "Matte Orange" },
    { id = 42,  label = "YELLOW",        name = "Matte Yellow" },

    { id = 55,  label = "LIME_GREEN",    name = "Matte Lime Green" },

    { id = 82,  label = "DARK_BLUE",     name = "Matte Dark Blue" },
    { id = 83,  label = "BLUE",          name = "Matte Blue" },
    { id = 84,  label = "MIDNIGHT_BLUE", name = "Matte Midnight Blue" },

    { id = 128, label = "GREEN",         name = "Matte Green" },

    { id = 148, label = "Purple",        name = "Matte Purple" },
    { id = 149, label = "MIGHT_PURPLE",  name = "Matte Might Purple" },

    { id = 151, label = "MATTE_FOR",     name = "Matte Forest Green" },
    { id = 152, label = "MATTE_OD",      name = "Matte Olive Drab" },
    { id = 153, label = "MATTE_DIRT",    name = "Matte Desert Brown" },
    { id = 154, label = "MATTE_DESERT",  name = "Matte Desert Tan" },
    { id = 155, label = "MATTE_FOIL",    name = "Matte Foilage Green" },
}

VehicleColors.MetalColors = {
    { id = 117, label = "BR_STEEL",       name = "Brushed Steel" },
    { id = 118, label = "BR BLACK_STEEL", name = "Brushed Black Steel" },
    { id = 119, label = "BR_ALUMINIUM",   name = "Brushed Aluminium" },

    { id = 158, label = "GOLD_P",         name = "Pure Gold" },
    { id = 159, label = "GOLD_S",         name = "Brushed Gold" },
}

VehicleColors.UtilColors = {
    { id = 15,  label = "BLACK",         name = "Util Black" },
    { id = 16,  label = "FMMC_COL1_1",   name = "Util Black Poly" },
    { id = 17,  label = "DARK_SILVER",   name = "Util Dark Silver" },
    { id = 18,  label = "SILVER",        name = "Util Silver" },
    { id = 19,  label = "BLACK_STEEL",   name = "Util Gun Metal" },
    { id = 20,  label = "SHADOW_SILVER", name = "Util Shadow Silver" },

    { id = 43,  label = "DARK_RED",      name = "Util Dark Red" },
    { id = 44,  label = "RED",           name = "Util Red" },
    { id = 45,  label = "GARNET_RED",    name = "Util Garnet Red" },

    { id = 56,  label = "DARK_GREEN",    name = "Util Dark Green" },
    { id = 57,  label = "GREEN",         name = "Util Green" },

    { id = 75,  label = "DARK_BLUE",     name = "Util Dark Blue" },
    { id = 76,  label = "MIDNIGHT_BLUE", name = "Util Midnight Blue" },
    { id = 77,  label = "SAXON_BLUE",    name = "Util Saxon Blue" },
    { id = 78,  label = "NAUTICAL_BLUE", name = "Util Nautical Blue" },
    { id = 79,  label = "BLUE",          name = "Util Blue" },
    { id = 80,  label = "FMMC_COL1_13",  name = "Util Lightning Blue" },
    { id = 81,  label = "BRIGHT_PURPLE", name = "Util Maui Blue Poly" },

    { id = 93,  label = "STRAW_BROWN",   name = "Util Straw Brown" },

    { id = 108, label = "UMBER_BROWN",   name = "Util Umber Brown" },
    { id = 109, label = "MOSS_BROWN",    name = "Util Moss Brown" },
    { id = 110, label = "SANDY_BROWN",   name = "Util Sandy Brown" },

    { id = 122, label = "OFF_WHITE",     name = "Util Off White" },

    { id = 125, label = "BRIGHT_GREEN",  name = "Util Bright Green" },

    { id = 127, label = "HARBOR_BLUE",   name = "Util Medium Blue" },

    { id = 134, label = "FROST_WHITE",   name = "Util Frost White" },

    { id = 139, label = "LIME_GREEN",    name = "Util Lime Green" },
    { id = 140, label = "ULTRA_BLUE",    name = "Util Ultra Blue" },

    { id = 144, label = "GREY",          name = "Util Grey" },

    { id = 157, label = "LIGHT_BLUE",    name = "Util Light Blue" },

    { id = 160, label = "YELLOW",        name = "Util Yellow" },
}

VehicleColors.WornColors = {
    { id = 21,  label = "BLACK",          name = "Worn Black" },
    { id = 22,  label = "GRAPHITE",       name = "Worn Graphite" },
    { id = 23,  label = "LIGHT_GREY",     name = "Worn Silver Grey" },
    { id = 24,  label = "SILVER",         name = "Worn Silver" },
    { id = 25,  label = "BLUE_SILVER",    name = "Worn Blue Silver" },
    { id = 26,  label = "SHADOW_SILVER",  name = "Worn Shadow Silver" },

    { id = 46,  label = "RED",            name = "Worn Red" },
    { id = 47,  label = "SALMON_PINK",    name = "Worn Golden Red" },
    { id = 48,  label = "DARK_RED",       name = "Worn Dark Red" },

    { id = 58,  label = "DARK_GREEN",     name = "Worn Dark Green" },
    { id = 59,  label = "GREEN",          name = "Worn Green" },
    { id = 60,  label = "SEA_GREEN",      name = "Worn Sea Wash" },

    { id = 85,  label = "DARK_BLUE",      name = "Worn Dark Blue" },
    { id = 86,  label = "BLUE",           name = "Worn Blue" },
    { id = 87,  label = "LIGHT_BLUE",     name = "Worn Light Blue" },

    { id = 113, label = "SANDY_BROWN",    name = "Worn Honey Beige" },
    { id = 114, label = "BISON_BROWN",    name = "Worn Brown" },
    { id = 115, label = "CREEK_BROWN",    name = "Worn Dark Brown" },
    { id = 116, label = "BLEECHED_BROWN", name = "Worn Straw Beige" },

    { id = 121, label = "OFF_WHITE",      name = "Worn Off White" },

    { id = 123, label = "ORANGE",         name = "Worn Orange" },
    { id = 124, label = "SUNRISE_ORANGE", name = "Worn Light Orange" },

    { id = 126, label = "TAXI_YELLOW",    name = "Worn Taxi Yellow" },

    { id = 129, label = "RACING_GREEN",   name = "Worn Sea Green" },
    { id = 130, label = "ORANGE",         name = "Worn Orange" },
    { id = 131, label = "WHITE",          name = "Worn White" },
    { id = 132, label = "FROST_WHITE",    name = "Worn Olive Army Green" },
    { id = 133, label = "OLIVE_GREEN",    name = "Worn Olive Green" },
}

VehicleColors.ChameleonColors = {
    { id = 223, label = "G9_PAINT01", name = "Monochrome" },
    { id = 224, label = "G9_PAINT02", name = "Night & Day" },
    { id = 225, label = "G9_PAINT03", name = "The Verlierer" },
    { id = 226, label = "G9_PAINT04", name = "Sprunk Extreme" },
    { id = 227, label = "G9_PAINT05", name = "Vice City" },
    { id = 228, label = "G9_PAINT06", name = "Synthwave Nights" },
    { id = 229, label = "G9_PAINT07", name = "Four Seasons" },
    { id = 230, label = "G9_PAINT08", name = "Maisonette 9 Throwback" },
    { id = 231, label = "G9_PAINT09", name = "Bubblegum" },
    { id = 232, label = "G9_PAINT10", name = "Full Rainbow" },
    { id = 233, label = "G9_PAINT11", name = "Sunset" },
    { id = 234, label = "G9_PAINT12", name = "The Seven" },
    { id = 235, label = "G9_PAINT13", name = "Kamen Rider" },
    { id = 236, label = "G9_PAINT14", name = "Chromatic Aberration" },
    { id = 237, label = "G9_PAINT15", name = "It's Christmas!" },
    { id = 238, label = "G9_PAINT16", name = "Temperature" },
}

VehicleColors.ChromeColorId = 120

function VehicleColors.GetColorListWithCount(colorList)
    local result = {}
    local count = #colorList
    for i, color in ipairs(colorList) do
        table.insert(result, color.name .. " (" .. i .. "/" .. count .. ")")
    end
    return result
end

function VehicleColors.GetWheelColorsList()
    local result = { "Default Alloy" }
    local classicNames = VehicleColors.GetColorListWithCount(VehicleColors.ClassicColors)
    for _, name in ipairs(classicNames) do
        table.insert(result, name)
    end
    return result
end

function VehicleColors.GetIndexById(colorList, id)
    for i, color in ipairs(colorList) do
        if color.id == id then
            return i
        end
    end
    return 1
end

return VehicleColors
