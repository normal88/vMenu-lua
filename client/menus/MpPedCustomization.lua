MpPedCustomizationMenu = {}

local menu = nil
local createCharacterMenu = nil
local inheritanceMenu = nil
local appearanceMenu = nil
local faceShapeMenu = nil
local tattooMenu = nil
local clothingMenu = nil
local propsMenu = nil
local savedCharactersMenu = nil

local isInCharacterCreation = false
local isNavigatingToSubmenu = false

local isEditingCharacter = false
local editingKvpKey = nil
local editingDisplayName = nil

local savedCharsDirty = true

local KVP_PREFIX = "mp_ped_"
local MALE_MODEL = `mp_m_freemode_01`
local FEMALE_MODEL = `mp_f_freemode_01`

local currentCharacter = {
    Version = 1,
    SaveName = "",
    IsMale = true,
    ModelHash = MALE_MODEL,
    FacialExpression = "mood_Normal_1",
    Category = "Uncategorized",

    PedHeadBlendData = {
        FirstFaceShape = 0,
        SecondFaceShape = 0,
        ThirdFaceShape = 0,
        FirstSkinTone = 0,
        SecondSkinTone = 0,
        ThirdSkinTone = 0,
        ParentFaceShapePercent = 0.5,
        ParentSkinTonePercent = 0.5,
        IsParentInheritance = false
    },

    PedAppearance = {
        hairStyle = 0,
        hairColor = 0,
        hairHighlightColor = 0,
        HairOverlay = nil,

        blemishesStyle = 255,
        blemishesOpacity = 1.0,

        beardStyle = 255,
        beardColor = 0,
        beardOpacity = 1.0,

        eyebrowsStyle = 255,
        eyebrowsColor = 0,
        eyebrowsOpacity = 1.0,

        ageingStyle = 255,
        ageingOpacity = 1.0,

        makeupStyle = 255,
        makeupColor = 0,
        makeupOpacity = 1.0,

        blushStyle = 255,
        blushColor = 0,
        blushOpacity = 1.0,

        complexionStyle = 255,
        complexionOpacity = 1.0,

        sunDamageStyle = 255,
        sunDamageOpacity = 1.0,

        lipstickStyle = 255,
        lipstickColor = 0,
        lipstickOpacity = 1.0,

        molesFrecklesStyle = 255,
        molesFrecklesOpacity = 1.0,

        chestHairStyle = 255,
        chestHairColor = 0,
        chestHairOpacity = 1.0,

        bodyBlemishesStyle = 255,
        bodyBlemishesOpacity = 1.0,

        eyeColor = 0
    },

    FaceShapeFeatures = {},

    DrawableVariations = {},

    PropVariations = {},

    PedTattoos = {
        HeadTattoos = {},
        TorsoTattoos = {},
        LeftArmTattoos = {},
        RightArmTattoos = {},
        LeftLegTattoos = {},
        RightLegTattoos = {},
        BadgeTattoos = {}
    }
}

for i = 0, 19 do
    currentCharacter.FaceShapeFeatures[i] = 0.0
end

for _, componentId in ipairs({ 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 }) do
    currentCharacter.DrawableVariations[componentId] = { drawable = 0, texture = 0 }
end

for _, propId in ipairs({ 0, 1, 2, 6, 7 }) do
    currentCharacter.PropVariations[propId] = { drawable = -1, texture = 0 }
end

local hairColorNames = {
    [0] = "Black", [1] = "Dark Gray", [2] = "Medium Gray", [3] = "Darkest Brown",
    [4] = "Dark Brown", [5] = "Brown", [6] = "Light Brown", [7] = "Lighter Brown",
    [8] = "Lightest Brown", [9] = "Faded Brown", [10] = "Faded Blonde", [11] = "Lightest Blonde",
    [12] = "Lighter Blonde", [13] = "Light Blonde", [14] = "White Blonde", [15] = "Grayish Brown",
    [16] = "Reddish Brown", [17] = "Red Brown", [18] = "Dark Red", [19] = "Red",
    [20] = "Very Red", [21] = "Vibrant Red", [22] = "Orangish Red", [23] = "Faded Red",
    [24] = "Faded Orange", [25] = "Gray", [26] = "Light Gray", [27] = "Lighter Gray",
    [28] = "Lightest Gray", [29] = "Dark Purple", [30] = "Purple", [31] = "Light Purple",
    [32] = "Violet", [33] = "Vibrant Violet", [34] = "Candy Pink", [35] = "Light Pink",
    [36] = "Cyan", [37] = "Blue", [38] = "Dark Blue", [39] = "Green",
    [40] = "Emerald", [41] = "Oil Slick", [42] = "Shiny Green", [43] = "Vibrant Green",
    [44] = "Green", [45] = "Bleach Blonde", [46] = "Golden Blonde", [47] = "Orange Blonde",
    [48] = "Orange", [49] = "Vibrant Orange", [50] = "Shiny Orange", [51] = "Dark Orange",
    [52] = "Red", [53] = "Dark Red", [54] = "Very Dark Red", [55] = "Black",
    [56] = "Black", [57] = "Black", [58] = "Black", [59] = "Black",
    [60] = "Black", [61] = "Black", [62] = "Gray", [63] = "Brown"
}

local eyeColorNames = {
    [0] = "Green", [1] = "Emerald", [2] = "Light Blue", [3] = "Light Brown",
    [4] = "Blue", [5] = "Dark Blue", [6] = "Brown", [7] = "Dark Brown",
    [8] = "Hazel", [9] = "Gray", [10] = "Light Green", [11] = "Light Brown",
    [12] = "Blue Green", [13] = "Brown", [14] = "Dark Brown", [15] = "Amber",
    [16] = "Light Hazel", [17] = "Yellow", [18] = "Light Blue", [19] = "Pink",
    [20] = "Red", [21] = "Light Gray", [22] = "Gold", [23] = "Olive",
    [24] = "Dark Emerald", [25] = "Pale Green", [26] = "Orange", [27] = "Steel Blue",
    [28] = "Violet", [29] = "Honey", [30] = "Black", [31] = "Dark Gray"
}

local function GetHairColorName(index)
    return hairColorNames[index] or ("Color " .. index)
end

local function GetEyeColorName(index)
    return eyeColorNames[index] or ("Color " .. index)
end

local facialExpressions = {
    "mood_Normal_1",
    "mood_Happy_1",
    "mood_Angry_1",
    "mood_Aiming_1",
    "mood_Injured_1",
    "mood_stressed_1",
    "mood_smug_1",
    "mood_sulk_1"
}

local faceFeatureNames = {
    "Nose Width",
    "Noes Peak Height",
    "Nose Peak Length",
    "Nose Bone Height",
    "Nose Peak Lowering",
    "Nose Bone Twist",
    "Eyebrows Height",
    "Eyebrows Depth",
    "Cheekbones Height",
    "Cheekbones Width",
    "Cheeks Width",
    "Eyes Opening",
    "Lips Thickness",
    "Jaw Bone Width",
    "Jaw Bone Depth/Length",
    "Chin Height",
    "Chin Depth/Length",
    "Chin Width",
    "Chin Hole Size",
    "Neck Thickness"
}

local hairOverlays = {
    [0] = { collection = "multiplayer_overlays", name = "FM_M_Hair_001_a" },
    [1] = { collection = "multiplayer_overlays", name = "FM_M_Hair_001_z" },
    [2] = { collection = "multiplayer_overlays", name = "FM_M_Hair_001_z" },
    [3] = { collection = "multiplayer_overlays", name = "FM_M_Hair_001_z" },
    [4] = { collection = "multiplayer_overlays", name = "FM_M_Hair_001_a" },
}

local OVERLAY_MAP = {
    { index = 0,  style = "blemishesStyle",     opacity = "blemishesOpacity" },
    { index = 1,  style = "beardStyle",         opacity = "beardOpacity",        color = "beardColor",     colorType = 1 },
    { index = 2,  style = "eyebrowsStyle",      opacity = "eyebrowsOpacity",     color = "eyebrowsColor",  colorType = 1 },
    { index = 3,  style = "ageingStyle",        opacity = "ageingOpacity" },
    { index = 4,  style = "makeupStyle",        opacity = "makeupOpacity",       color = "makeupColor",    colorType = 2 },
    { index = 5,  style = "blushStyle",         opacity = "blushOpacity",        color = "blushColor",     colorType = 2 },
    { index = 6,  style = "complexionStyle",    opacity = "complexionOpacity" },
    { index = 7,  style = "sunDamageStyle",     opacity = "sunDamageOpacity" },
    { index = 8,  style = "lipstickStyle",      opacity = "lipstickOpacity",     color = "lipstickColor",  colorType = 2 },
    { index = 9,  style = "molesFrecklesStyle", opacity = "molesFrecklesOpacity" },
    { index = 10, style = "chestHairStyle",     opacity = "chestHairOpacity",    color = "chestHairColor", colorType = 1 },
    { index = 11, style = "bodyBlemishesStyle", opacity = "bodyBlemishesOpacity" }
}

function MpPedCustomizationMenu.CreateMenu()
    menu = Menu:New("MP Ped Customization", "Multiplayer character creator")
    MenuController:AddMenu(menu)

    local createMaleBtn = MenuItem:New("Create Male Character", "Create a new male multiplayer character.")
    local createFemaleBtn = MenuItem:New("Create Female Character", "Create a new female multiplayer character.")
    local savedCharactersBtn = MenuItem:New("Saved Characters", "Manage your saved characters.")
    savedCharactersBtn.Label = "→→→"

    menu:AddMenuItem(createMaleBtn)
    menu:AddMenuItem(createFemaleBtn)
    menu:AddMenuItem(savedCharactersBtn)

    MpPedCustomizationMenu.CreateCharacterCreationMenu()
    MpPedCustomizationMenu.CreateSavedCharactersMenu()

    MenuController:BindMenuItem(menu, savedCharactersMenu, savedCharactersBtn)

    menu.OnItemSelect = function(sender, item, index)
        if item == createMaleBtn then
            menu:CloseMenu()
            MpPedCustomizationMenu.StartCharacterCreation(true)
        elseif item == createFemaleBtn then
            menu:CloseMenu()
            MpPedCustomizationMenu.StartCharacterCreation(false)
        elseif item == savedCharactersBtn then
            if savedCharsDirty then
                MpPedCustomizationMenu.RefreshSavedCharactersMenu()
                savedCharsDirty = false
            end
        end
    end

    return menu
end

function MpPedCustomizationMenu.CreateCharacterCreationMenu()
    createCharacterMenu = Menu:New("Create Character", "Customize your character")
    MenuController:AddMenu(createCharacterMenu)

    inheritanceMenu = Menu:New("Character Inheritance", "Parents and genetics")
    appearanceMenu = Menu:New("Character Appearance", "Hair, overlays, and features")
    faceShapeMenu = Menu:New("Face Shape Features", "Facial feature adjustments")
    tattooMenu = Menu:New("Character Tattoo Options", "Manage tattoos")
    clothingMenu = Menu:New("Character Clothes", "Customize clothing")
    propsMenu = Menu:New("Character Props", "Hats, glasses, and accessories")

    MenuController:AddMenu(inheritanceMenu)
    MenuController:AddMenu(appearanceMenu)
    MenuController:AddMenu(faceShapeMenu)
    MenuController:AddMenu(tattooMenu)
    MenuController:AddMenu(clothingMenu)
    MenuController:AddMenu(propsMenu)

    MpPedCustomizationMenu.SetupTattooMenu()

    MpPedCustomizationMenu.SetupInheritanceMenuHandlers()
    MpPedCustomizationMenu.SetupFaceShapeMenuHandlers()
    MpPedCustomizationMenu.SetupAppearanceMenuHandlers()
    MpPedCustomizationMenu.SetupClothingMenuHandlers()
    MpPedCustomizationMenu.SetupPropsMenuHandlers()

    MpPedCustomizationMenu.RefreshInheritanceMenuItems()
    MpPedCustomizationMenu.RefreshFaceShapeMenuItems()
    MpPedCustomizationMenu.RefreshAppearanceMenuItems()
    MpPedCustomizationMenu.RefreshClothingMenuItems()
    MpPedCustomizationMenu.RefreshPropsMenuItems()

    local inheritanceBtn = MenuItem:New("Character Inheritance", "Parents and genetics.")
    inheritanceBtn.Label = "→→→"

    local appearanceBtn = MenuItem:New("Character Appearance", "Hair, makeup, and overlays.")
    appearanceBtn.Label = "→→→"

    local faceShapeBtn = MenuItem:New("Character Face Shape Options", "Adjust facial features.")
    faceShapeBtn.Label = "→→→"

    local tattooBtn = MenuItem:New("Character Tattoo Options", "Manage tattoos and badges.")
    tattooBtn.Label = "→→→"

    local clothingBtn = MenuItem:New("Character Clothes", "Customize clothing.")
    clothingBtn.Label = "→→→"

    local propsBtn = MenuItem:New("Character Props", "Hats, glasses, and accessories.")
    propsBtn.Label = "→→→"

    local facialExpressionList = MenuListItem:New("Facial Expression", facialExpressions, 0, "Select facial expression.")

    local categoryList = MenuListItem:New("Character Category", { "Uncategorized" }, 0, "Organize your saved characters.")

    local saveBtn = MenuItem:New("Save Character", "Save your character.")
    local exitBtn = MenuItem:New("Exit Without Saving", "Are you sure? All unsaved work will be lost.")

    createCharacterMenu:AddMenuItem(inheritanceBtn)
    createCharacterMenu:AddMenuItem(appearanceBtn)
    createCharacterMenu:AddMenuItem(faceShapeBtn)
    createCharacterMenu:AddMenuItem(tattooBtn)
    createCharacterMenu:AddMenuItem(clothingBtn)
    createCharacterMenu:AddMenuItem(propsBtn)
    createCharacterMenu:AddMenuItem(facialExpressionList)
    createCharacterMenu:AddMenuItem(categoryList)
    createCharacterMenu:AddMenuItem(saveBtn)
    createCharacterMenu:AddMenuItem(exitBtn)

    MenuController:BindMenuItem(createCharacterMenu, inheritanceMenu, inheritanceBtn)
    MenuController:BindMenuItem(createCharacterMenu, appearanceMenu, appearanceBtn)
    MenuController:BindMenuItem(createCharacterMenu, faceShapeMenu, faceShapeBtn)
    MenuController:BindMenuItem(createCharacterMenu, tattooMenu, tattooBtn)
    MenuController:BindMenuItem(createCharacterMenu, clothingMenu, clothingBtn)
    MenuController:BindMenuItem(createCharacterMenu, propsMenu, propsBtn)

    createCharacterMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == facialExpressionList then
            currentCharacter.FacialExpression = facialExpressions[newIndex]
            MpPedCustomizationMenu.ApplyFacialExpression()
        elseif item == categoryList then
            currentCharacter.Category = item.ListItems[newIndex]
        end
    end

    createCharacterMenu.OnItemSelect = function(sender, item, index)
        if item == saveBtn then
            Citizen.CreateThread(function()
                MpPedCustomizationMenu.SaveCharacter()
            end)
        elseif item == exitBtn then
            if exitBtn.Label == "~r~Confirm" then
                exitBtn.Label = ""
                isInCharacterCreation = false
                createCharacterMenu:CloseMenu()
                MpPedCustomizationMenu.RestorePlayerModel()
                MpPedCustomizationMenu.GetMenu():OpenMenu()
            else
                exitBtn.Label = "~r~Confirm"
                Notify.Alert("Press again to confirm exit. All unsaved work will be lost.")
            end
        end
    end

    createCharacterMenu.OnIndexChange = function(sender, oldItem, newItem, oldIndex, newIndex)
        if oldItem == exitBtn then
            exitBtn.Label = ""
        end
    end

    MpPedCustomizationMenu.SetupMenuCloseHandlers()
end

function MpPedCustomizationMenu.StartCharacterCreation(isMale, isEditing)

    if not isEditing then
        isEditingCharacter = false
        editingKvpKey = nil
        editingDisplayName = nil
        MpPedCustomizationMenu.ResetCharacterToDefaults(isMale)
    else
        currentCharacter.IsMale = isMale
        currentCharacter.ModelHash = isMale and MALE_MODEL or FEMALE_MODEL
    end

    RequestModel(currentCharacter.ModelHash)
    while not HasModelLoaded(currentCharacter.ModelHash) do
        Wait(0)
    end

    local coords = GetEntityCoords(PlayerPedId())

    local _savedWeapons1 = {}
    local _currentWeapon1 = GetCurrentPedWeapon(PlayerPedId(), true)
    for _, w in ipairs(ValidWeapon.WeaponList) do
        local hash = GetHashKey(w.Name)
        if HasPedGotWeapon(PlayerPedId(), hash, false) then
            _savedWeapons1[#_savedWeapons1 + 1] = { hash = hash, ammo = GetAmmoInPedWeapon(PlayerPedId(), hash), tint = GetPedWeaponTintIndex(PlayerPedId(), hash), current = (hash == _currentWeapon1) }
        end
    end

    SetPlayerModel(PlayerId(), currentCharacter.ModelHash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(currentCharacter.ModelHash)

    for _, w in ipairs(_savedWeapons1) do
        GiveWeaponToPed(PlayerPedId(), w.hash, w.ammo, false, false)
        SetPedWeaponTintIndex(PlayerPedId(), w.hash, w.tint)
    end
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

    local ped = PlayerPedId()
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    FreezeEntityPosition(ped, true)

    ClearPedDecorations(ped)
    ClearPedFacialDecorations(ped)
    ClearAllPedProps(ped)

    if not isEditing then
        MpPedCustomizationMenu.SetPlayerDefaultClothing(isMale)
    end

    MpPedCustomizationMenu.ApplyCharacterData()

    MpPedCustomizationMenu.RefreshInheritanceMenuItems()
    MpPedCustomizationMenu.RefreshFaceShapeMenuItems()
    MpPedCustomizationMenu.RefreshAppearanceMenuItems()
    MpPedCustomizationMenu.RefreshClothingMenuItems()
    MpPedCustomizationMenu.RefreshPropsMenuItems()
    MpPedCustomizationMenu.RefreshTattooMenuItems()

    CameraManager.ActivateCamera()

    isInCharacterCreation = true
    createCharacterMenu:OpenMenu()
end

function MpPedCustomizationMenu.SetupMenuCloseHandlers()
    createCharacterMenu.OnMenuClose = function(sender)
        if isInCharacterCreation and not isNavigatingToSubmenu then
            Citizen.CreateThread(function()
                Wait(100)
                if isInCharacterCreation and not MenuController:IsAnyMenuOpen() then
                    createCharacterMenu:OpenMenu()
                end
            end)
        end
        isNavigatingToSubmenu = false
    end

    local function setupChildMenuClose(childMenu)
        childMenu.OnMenuClose = function(sender)
        end
    end

    setupChildMenuClose(inheritanceMenu)
    setupChildMenuClose(appearanceMenu)
    setupChildMenuClose(faceShapeMenu)
    setupChildMenuClose(tattooMenu)
    setupChildMenuClose(clothingMenu)
    setupChildMenuClose(propsMenu)
end

function MpPedCustomizationMenu.ResetCharacterToDefaults(isMale)
    currentCharacter = {
        Version = 1,
        SaveName = "",
        IsMale = isMale,
        ModelHash = isMale and MALE_MODEL or FEMALE_MODEL,
        FacialExpression = "mood_Normal_1",
        Category = "Uncategorized",
        PedHeadBlendData = {
            FirstFaceShape = 0,
            SecondFaceShape = 0,
            ThirdFaceShape = 0,
            FirstSkinTone = 0,
            SecondSkinTone = 0,
            ThirdSkinTone = 0,
            ParentFaceShapePercent = 0.5,
            ParentSkinTonePercent = 0.5,
            IsParentInheritance = false
        },
        PedAppearance = {
            hairStyle = 0,
            hairColor = 0,
            hairHighlightColor = 0,
            HairOverlay = nil,
            blemishesStyle = 255,
            blemishesOpacity = 1.0,
            beardStyle = 255,
            beardColor = 0,
            beardOpacity = 1.0,
            eyebrowsStyle = 255,
            eyebrowsColor = 0,
            eyebrowsOpacity = 1.0,
            ageingStyle = 255,
            ageingOpacity = 1.0,
            makeupStyle = 255,
            makeupColor = 0,
            makeupOpacity = 1.0,
            blushStyle = 255,
            blushColor = 0,
            blushOpacity = 1.0,
            complexionStyle = 255,
            complexionOpacity = 1.0,
            sunDamageStyle = 255,
            sunDamageOpacity = 1.0,
            lipstickStyle = 255,
            lipstickColor = 0,
            lipstickOpacity = 1.0,
            molesFrecklesStyle = 255,
            molesFrecklesOpacity = 1.0,
            chestHairStyle = 255,
            chestHairColor = 0,
            chestHairOpacity = 1.0,
            bodyBlemishesStyle = 255,
            bodyBlemishesOpacity = 1.0,
            eyeColor = 0
        },
        FaceShapeFeatures = {},
        DrawableVariations = {},
        PropVariations = {},
        PedTattoos = {
            HeadTattoos = {},
            TorsoTattoos = {},
            LeftArmTattoos = {},
            RightArmTattoos = {},
            LeftLegTattoos = {},
            RightLegTattoos = {},
            BadgeTattoos = {}
        }
    }

    for i = 0, 19 do
        currentCharacter.FaceShapeFeatures[i] = 0.0
    end

    for _, componentId in ipairs({ 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 }) do
        currentCharacter.DrawableVariations[componentId] = { drawable = 0, texture = 0 }
    end

    for _, propId in ipairs({ 0, 1, 2, 6, 7 }) do
        currentCharacter.PropVariations[propId] = { drawable = -1, texture = 0 }
    end
end

function MpPedCustomizationMenu.SetPlayerDefaultClothing(isMale)
    local ped = PlayerPedId()

    SetPedDefaultComponentVariation(ped)

end

function MpPedCustomizationMenu.SetupInheritanceMenuHandlers()
    inheritanceMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        local parentIndex = newIndex - 1
        if item.Text == "Father" then
            currentCharacter.PedHeadBlendData.FirstFaceShape = parentIndex
            currentCharacter.PedHeadBlendData.FirstSkinTone = parentIndex
            item.Description = "Father: ~y~" .. parentIndex .. "~s~ / 45"
            MpPedCustomizationMenu.ApplyHeadBlend()
        elseif item.Text == "Mother" then
            currentCharacter.PedHeadBlendData.SecondFaceShape = parentIndex
            currentCharacter.PedHeadBlendData.SecondSkinTone = parentIndex
            item.Description = "Mother: ~y~" .. parentIndex .. "~s~ / 45"
            MpPedCustomizationMenu.ApplyHeadBlend()
        end
    end

    inheritanceMenu.OnSliderPositionChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item.Text == "Head Shape Mix" then
            currentCharacter.PedHeadBlendData.ParentFaceShapePercent = newIndex / 10.0
            MpPedCustomizationMenu.ApplyHeadBlend()
        elseif item.Text == "Body Skin Mix" then
            currentCharacter.PedHeadBlendData.ParentSkinTonePercent = newIndex / 10.0
            MpPedCustomizationMenu.ApplyHeadBlend()
        end
    end
end

function MpPedCustomizationMenu.RefreshInheritanceMenuItems()
    inheritanceMenu:ClearMenuItems()

    local blend = currentCharacter.PedHeadBlendData

    local fathers = {}
    for i = 0, 45 do
        table.insert(fathers, "Father " .. i)
    end
    local fatherList = MenuListItem:New("Father", fathers, blend.FirstFaceShape + 1,
        "Father: ~y~" .. blend.FirstFaceShape .. "~s~ / 45")

    local mothers = {}
    for i = 0, 45 do
        table.insert(mothers, "Mother " .. i)
    end
    local motherList = MenuListItem:New("Mother", mothers, blend.SecondFaceShape + 1,
        "Mother: ~y~" .. blend.SecondFaceShape .. "~s~ / 45")

    local shapeMixPos = math.floor(blend.ParentFaceShapePercent * 10 + 0.5)
    local shapeSlider = MenuSliderItem:New("Head Shape Mix", "Left = Father, Right = Mother", 0, 10, shapeMixPos, false)

    local skinMixPos = math.floor(blend.ParentSkinTonePercent * 10 + 0.5)
    local skinSlider = MenuSliderItem:New("Body Skin Mix", "Left = Father, Right = Mother", 0, 10, skinMixPos, false)

    inheritanceMenu:AddMenuItem(fatherList)
    inheritanceMenu:AddMenuItem(motherList)
    inheritanceMenu:AddMenuItem(shapeSlider)
    inheritanceMenu:AddMenuItem(skinSlider)
end

function MpPedCustomizationMenu.SetupAppearanceMenuHandlers()
    appearanceMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        local idx = newIndex - 1
        local ped = PlayerPedId()
        local itemText = item.Text

        if itemText == "Hair Style" then
            local maxHair = GetNumberOfPedDrawableVariations(ped, 2)
            currentCharacter.PedAppearance.hairStyle = idx
            SetPedComponentVariation(ped, 2, idx, 0, 0)
            MpPedCustomizationMenu.ApplyHairOverlay()
            item.Description = "Style: ~y~" .. (idx + 1) .. "~s~ / " .. maxHair
        elseif itemText == "Hair Color" then
            currentCharacter.PedAppearance.hairColor = idx
            SetPedHairColor(ped, idx, currentCharacter.PedAppearance.hairHighlightColor)
            item.Description = "Color: ~y~" .. GetHairColorName(idx) .. "~s~ (" .. idx .. " / " .. (GetNumHairColors() - 1) .. ")"
        elseif itemText == "Hair Highlight Color" then
            currentCharacter.PedAppearance.hairHighlightColor = idx
            SetPedHairColor(ped, currentCharacter.PedAppearance.hairColor, idx)
            item.Description = "Highlight: ~y~" .. GetHairColorName(idx) .. "~s~ (" .. idx .. " / " .. (GetNumHairColors() - 1) .. ")"

        elseif itemText == "Eye Colors" then
            currentCharacter.PedAppearance.eyeColor = idx
            SetPedEyeColor(ped, idx)
            item.Description = "Eye Color: ~y~" .. GetEyeColorName(idx) .. "~s~ (" .. idx .. " / 31)"

        else
            MpPedCustomizationMenu.HandleOverlayListChange(itemText, idx, item)
        end
    end
end

function MpPedCustomizationMenu.RefreshAppearanceMenuItems()
    appearanceMenu:ClearMenuItems()

    local ped = PlayerPedId()

    local hairStyles = {}
    local maxHair = GetNumberOfPedDrawableVariations(ped, 2)
    for i = 0, maxHair - 1 do
        table.insert(hairStyles, "Style " .. i)
    end
    local curHairStyle = currentCharacter.PedAppearance.hairStyle
    local hairStyleList = MenuListItem:New("Hair Style", hairStyles, curHairStyle + 1,
        "Style: ~y~" .. (curHairStyle + 1) .. "~s~ / " .. maxHair)
    hairStyleList.ShowColorPanel = false

    local numHairColors = GetNumHairColors() - 1
    local hairColors = {}
    for i = 0, numHairColors do
        table.insert(hairColors, "Color #" .. (i + 1))
    end
    local curHairColor = currentCharacter.PedAppearance.hairColor
    local hairColorList = MenuListItem:New("Hair Color", hairColors, curHairColor + 1,
        "Color: ~y~" .. GetHairColorName(curHairColor) .. "~s~ (" .. curHairColor .. " / " .. numHairColors .. ")")
    hairColorList.ShowColorPanel = true
    hairColorList.ColorPanelColorType = MenuListItem.ColorPanelType.Hair

    local curHighlight = currentCharacter.PedAppearance.hairHighlightColor
    local hairHighlightList = MenuListItem:New("Hair Highlight Color", hairColors,
        curHighlight + 1, "Highlight: ~y~" .. GetHairColorName(curHighlight) .. "~s~ (" .. curHighlight .. " / " .. numHairColors .. ")")
    hairHighlightList.ShowColorPanel = true
    hairHighlightList.ColorPanelColorType = MenuListItem.ColorPanelType.Hair

    appearanceMenu:AddMenuItem(hairStyleList)
    appearanceMenu:AddMenuItem(hairColorList)
    appearanceMenu:AddMenuItem(hairHighlightList)

    local isMale = currentCharacter.IsMale
    local app = currentCharacter.PedAppearance

    MpPedCustomizationMenu.AddOverlayItems("Blemishes", 0, GetNumHeadOverlayValues(0), false, nil, app.blemishesStyle, app.blemishesOpacity)

    MpPedCustomizationMenu.AddOverlayItems("Beard", 1, GetNumHeadOverlayValues(1), true, MenuListItem.ColorPanelType.Hair,
        app.beardStyle, app.beardOpacity, app.beardColor, not isMale)

    MpPedCustomizationMenu.AddOverlayItems("Eyebrows", 2, GetNumHeadOverlayValues(2), true, MenuListItem.ColorPanelType.Hair,
        app.eyebrowsStyle, app.eyebrowsOpacity, app.eyebrowsColor)

    MpPedCustomizationMenu.AddOverlayItems("Ageing", 3, GetNumHeadOverlayValues(3), false, nil, app.ageingStyle, app.ageingOpacity)

    MpPedCustomizationMenu.AddOverlayItems("Makeup", 4, GetNumHeadOverlayValues(4), true, MenuListItem.ColorPanelType.Makeup,
        app.makeupStyle, app.makeupOpacity, app.makeupColor)

    MpPedCustomizationMenu.AddOverlayItems("Blush", 5, GetNumHeadOverlayValues(5), true, MenuListItem.ColorPanelType.Makeup,
        app.blushStyle, app.blushOpacity, app.blushColor)

    MpPedCustomizationMenu.AddOverlayItems("Complexion", 6, GetNumHeadOverlayValues(6), false, nil, app.complexionStyle, app.complexionOpacity)

    MpPedCustomizationMenu.AddOverlayItems("Sun Damage", 7, GetNumHeadOverlayValues(7), false, nil, app.sunDamageStyle, app.sunDamageOpacity)

    MpPedCustomizationMenu.AddOverlayItems("Lipstick", 8, GetNumHeadOverlayValues(8), true, MenuListItem.ColorPanelType.Makeup,
        app.lipstickStyle, app.lipstickOpacity, app.lipstickColor)

    MpPedCustomizationMenu.AddOverlayItems("Moles and Freckles", 9, GetNumHeadOverlayValues(9), false, nil,
        app.molesFrecklesStyle, app.molesFrecklesOpacity)

    MpPedCustomizationMenu.AddOverlayItems("Chest Hair", 10, GetNumHeadOverlayValues(10), true, MenuListItem.ColorPanelType.Hair,
        app.chestHairStyle, app.chestHairOpacity, app.chestHairColor, not isMale)

    MpPedCustomizationMenu.AddOverlayItems("Body Blemishes", 11, GetNumHeadOverlayValues(11), false, nil,
        app.bodyBlemishesStyle, app.bodyBlemishesOpacity)

    local eyeColors = {}
    for i = 0, 31 do
        table.insert(eyeColors, "Eye Color " .. i)
    end
    local curEyeColor = currentCharacter.PedAppearance.eyeColor
    local eyeColorList = MenuListItem:New("Eye Colors", eyeColors, curEyeColor + 1,
        "Eye Color: ~y~" .. GetEyeColorName(curEyeColor) .. "~s~ (" .. curEyeColor .. " / 31)")
    appearanceMenu:AddMenuItem(eyeColorList)
end

function MpPedCustomizationMenu.AddOverlayItems(name, overlayIndex, maxStyles, hasColor, colorType, currentStyle,
                                                currentOpacity, currentColor, locked)
    local overlayKey = name:lower():gsub("[%s/]", "")

    local styles = {}
    for i = 0, maxStyles - 1 do
        table.insert(styles, "Style " .. i)
    end
    local styleDesc
    if currentStyle == 255 or currentStyle == 0 then
        styleDesc = name .. ": ~c~None~s~"
    else
        styleDesc = name .. " Style: ~y~" .. (currentStyle + 1) .. "~s~ / " .. maxStyles
    end
    local styleList = MenuListItem:New(name .. " Style", styles, (currentStyle == 255 and 0 or currentStyle) + 1, styleDesc)
    if locked then styleList.Enabled = false end
    appearanceMenu:AddMenuItem(styleList)

    local opacities = {}
    for i = 0, 10 do
        table.insert(opacities, (i * 10) .. "%")
    end
    local opacityIndex = math.floor((currentOpacity + 0.05) * 10) + 1
    local opacityDesc = name .. " Opacity: ~y~" .. math.floor(currentOpacity * 100 + 0.5) .. "%~s~"
    local opacityList = MenuListItem:New(name .. " Opacity", opacities, opacityIndex, opacityDesc)
    if locked then opacityList.Enabled = false end
    appearanceMenu:AddMenuItem(opacityList)

    if hasColor then
        local numColors = GetNumHairColors() - 1
        local colors = {}
        for i = 0, numColors do
            table.insert(colors, "Color #" .. (i + 1))
        end
        local colorIdx = currentColor or 0
        local colorName = GetHairColorName(colorIdx)
        local colorDesc = name .. " Color: ~y~" .. colorName .. "~s~ (" .. colorIdx .. " / " .. numColors .. ")"
        local colorList = MenuListItem:New(name .. " Color", colors, colorIdx + 1, colorDesc)
        colorList.ShowColorPanel = true
        colorList.ColorPanelColorType = colorType
        if locked then colorList.Enabled = false end
        appearanceMenu:AddMenuItem(colorList)
    end
end

function MpPedCustomizationMenu.HandleOverlayListChange(itemText, newIndex, item)
    local ped = PlayerPedId()

    local overlays = {
        { name = "Blemishes",          key = "blemishes",     index = 0,  hasColor = false },
        { name = "Beard",              key = "beard",         index = 1,  hasColor = true, colorKey = "beardColor",     colorType = 1 },
        { name = "Eyebrows",           key = "eyebrows",      index = 2,  hasColor = true, colorKey = "eyebrowsColor",  colorType = 1 },
        { name = "Ageing",             key = "ageing",        index = 3,  hasColor = false },
        { name = "Makeup",             key = "makeup",        index = 4,  hasColor = true, colorKey = "makeupColor",    colorType = 2 },
        { name = "Blush",              key = "blush",         index = 5,  hasColor = true, colorKey = "blushColor",     colorType = 2 },
        { name = "Complexion",         key = "complexion",    index = 6,  hasColor = false },
        { name = "Sun Damage",         key = "sunDamage",     index = 7,  hasColor = false },
        { name = "Lipstick",           key = "lipstick",      index = 8,  hasColor = true, colorKey = "lipstickColor",  colorType = 2 },
        { name = "Moles and Freckles", key = "molesFreckles", index = 9,  hasColor = false },
        { name = "Chest Hair",         key = "chestHair",     index = 10, hasColor = true, colorKey = "chestHairColor", colorType = 1 },
        { name = "Body Blemishes",     key = "bodyBlemishes", index = 11, hasColor = false }
    }

    for _, overlay in ipairs(overlays) do
        if itemText == overlay.name .. " Style" then
            local styleValue = newIndex == 0 and 255 or (newIndex - 1)
            currentCharacter.PedAppearance[overlay.key .. "Style"] = styleValue

            local opacity = currentCharacter.PedAppearance[overlay.key .. "Opacity"]
            SetPedHeadOverlay(ped, overlay.index, styleValue == 255 and 255 or styleValue, opacity)

            if overlay.hasColor and styleValue ~= 255 then
                local color = currentCharacter.PedAppearance[overlay.colorKey]
                SetPedHeadOverlayColor(ped, overlay.index, overlay.colorType, color, color)
            end

            if item then
                if styleValue == 255 then
                    item.Description = overlay.name .. ": ~c~None~s~"
                else
                    item.Description = overlay.name .. " Style: ~y~" .. (styleValue + 1) .. "~s~ / " .. item:ItemsCount()
                end
            end
            break
        elseif itemText == overlay.name .. " Opacity" then
            local opacity = math.max(0.0, math.min(1.0, newIndex / 10.0))
            currentCharacter.PedAppearance[overlay.key .. "Opacity"] = opacity

            local style = currentCharacter.PedAppearance[overlay.key .. "Style"]
            if style ~= 255 then
                SetPedHeadOverlay(ped, overlay.index, style, opacity)
            end

            if item then
                item.Description = overlay.name .. " Opacity: ~y~" .. math.floor(opacity * 100 + 0.5) .. "%~s~"
            end
            break
        elseif overlay.hasColor and itemText == overlay.name .. " Color" then
            local color = newIndex
            currentCharacter.PedAppearance[overlay.colorKey] = color

            local style = currentCharacter.PedAppearance[overlay.key .. "Style"]
            if style ~= 255 then
                SetPedHeadOverlayColor(ped, overlay.index, overlay.colorType, color, color)
            end

            if item then
                local colorName = GetHairColorName(color)
                item.Description = overlay.name .. " Color: ~y~" .. colorName .. "~s~ (" .. color .. " / " .. (GetNumHairColors() - 1) .. ")"
            end
            break
        end
    end
end

function MpPedCustomizationMenu.SetupFaceShapeMenuHandlers()
    faceShapeMenu.OnSliderPositionChange = function(sender, item, oldIndex, newIndex, itemIndex)
        local value = (newIndex - 10) / 10.0

        local featureIndex = itemIndex - 1
        currentCharacter.FaceShapeFeatures[featureIndex] = value
        SetPedFaceFeature(PlayerPedId(), featureIndex, value)
    end
end

function MpPedCustomizationMenu.RefreshFaceShapeMenuItems()
    faceShapeMenu:ClearMenuItems()

    for i = 0, 19 do
        local featureValue = currentCharacter.FaceShapeFeatures[i] or 0.0
        local sliderPos = math.floor(featureValue * 10 + 10 + 0.5)
        sliderPos = math.max(0, math.min(20, sliderPos))

        local slider = MenuSliderItem:New(faceFeatureNames[i + 1], "Adjust " .. faceFeatureNames[i + 1]:lower() .. ".", 0,
            20, sliderPos, false)
        faceShapeMenu:AddMenuItem(slider)
    end
end

function MpPedCustomizationMenu.SetupTattooMenu()
    local function ApplySavedTattoos()
        ClearPedDecorations(PlayerPedId())

        for _, tattoo in ipairs(currentCharacter.PedTattoos.HeadTattoos) do
            SetPedDecoration(PlayerPedId(), GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
        for _, tattoo in ipairs(currentCharacter.PedTattoos.TorsoTattoos) do
            SetPedDecoration(PlayerPedId(), GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
        for _, tattoo in ipairs(currentCharacter.PedTattoos.LeftArmTattoos) do
            SetPedDecoration(PlayerPedId(), GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
        for _, tattoo in ipairs(currentCharacter.PedTattoos.RightArmTattoos) do
            SetPedDecoration(PlayerPedId(), GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
        for _, tattoo in ipairs(currentCharacter.PedTattoos.LeftLegTattoos) do
            SetPedDecoration(PlayerPedId(), GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
        for _, tattoo in ipairs(currentCharacter.PedTattoos.RightLegTattoos) do
            SetPedDecoration(PlayerPedId(), GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
        for _, tattoo in ipairs(currentCharacter.PedTattoos.BadgeTattoos) do
            SetPedDecoration(PlayerPedId(), GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end

        if currentCharacter.PedAppearance.HairOverlay and
            currentCharacter.PedAppearance.HairOverlay.collection and
            currentCharacter.PedAppearance.HairOverlay.name then
            SetPedDecoration(PlayerPedId(),
                GetHashKey(currentCharacter.PedAppearance.HairOverlay.collection),
                GetHashKey(currentCharacter.PedAppearance.HairOverlay.name))
        end
    end

    local function IsTattooApplied(tattooList, collection, name)
        for _, tat in ipairs(tattooList) do
            if tat.collection == collection and tat.name == name then
                return true
            end
        end
        return false
    end

    local function RemoveTattoo(tattooList, collection, name)
        for i, tat in ipairs(tattooList) do
            if tat.collection == collection and tat.name == name then
                table.remove(tattooList, i)
                return
            end
        end
    end

    local isMale = currentCharacter.IsMale
    local headTattoos = TattoosData.GetTattoosByZone(isMale, "HEAD")
    local torsoTattoos = TattoosData.GetTattoosByZone(isMale, "TORSO")
    local leftArmTattoos = TattoosData.GetTattoosByZone(isMale, "LEFT_ARM")
    local rightArmTattoos = TattoosData.GetTattoosByZone(isMale, "RIGHT_ARM")
    local leftLegTattoos = TattoosData.GetTattoosByZone(isMale, "LEFT_LEG")
    local rightLegTattoos = TattoosData.GetTattoosByZone(isMale, "RIGHT_LEG")
    local badgeTattoos = TattoosData.GetTattoosByZone(isMale, "BADGES")

    local headNames = TattoosData.GetTattooNamesByZone(isMale, "HEAD")
    local torsoNames = TattoosData.GetTattooNamesByZone(isMale, "TORSO")
    local leftArmNames = TattoosData.GetTattooNamesByZone(isMale, "LEFT_ARM")
    local rightArmNames = TattoosData.GetTattooNamesByZone(isMale, "RIGHT_ARM")
    local leftLegNames = TattoosData.GetTattooNamesByZone(isMale, "LEFT_LEG")
    local rightLegNames = TattoosData.GetTattooNamesByZone(isMale, "RIGHT_LEG")
    local badgeNames = TattoosData.GetTattooNamesByZone(isMale, "BADGES")

    local headList = MenuListItem:New("Head", headNames, 0,
        "Select a head tattoo and press ~o~enter~s~ to add/remove it.")
    headList.ItemData = { zone = "HEAD", tattoos = headTattoos, savedList = currentCharacter.PedTattoos.HeadTattoos }

    local torsoList = MenuListItem:New("Torso", torsoNames, 0,
        "Select a torso tattoo and press ~o~enter~s~ to add/remove it.")
    torsoList.ItemData = { zone = "TORSO", tattoos = torsoTattoos, savedList = currentCharacter.PedTattoos.TorsoTattoos }

    local leftArmList = MenuListItem:New("Left Arm", leftArmNames, 0,
        "Select a left arm tattoo and press ~o~enter~s~ to add/remove it.")
    leftArmList.ItemData = {
        zone = "LEFT_ARM",
        tattoos = leftArmTattoos,
        savedList = currentCharacter.PedTattoos
            .LeftArmTattoos
    }

    local rightArmList = MenuListItem:New("Right Arm", rightArmNames, 0,
        "Select a right arm tattoo and press ~o~enter~s~ to add/remove it.")
    rightArmList.ItemData = {
        zone = "RIGHT_ARM",
        tattoos = rightArmTattoos,
        savedList = currentCharacter.PedTattoos
            .RightArmTattoos
    }

    local leftLegList = MenuListItem:New("Left Leg", leftLegNames, 0,
        "Select a left leg tattoo and press ~o~enter~s~ to add/remove it.")
    leftLegList.ItemData = {
        zone = "LEFT_LEG",
        tattoos = leftLegTattoos,
        savedList = currentCharacter.PedTattoos
            .LeftLegTattoos
    }

    local rightLegList = MenuListItem:New("Right Leg", rightLegNames, 0,
        "Select a right leg tattoo and press ~o~enter~s~ to add/remove it.")
    rightLegList.ItemData = {
        zone = "RIGHT_LEG",
        tattoos = rightLegTattoos,
        savedList = currentCharacter.PedTattoos
            .RightLegTattoos
    }

    local badgeList = MenuListItem:New("Badges", badgeNames, 0,
        "Select a badge overlay and press ~o~enter~s~ to add/remove it.")
    badgeList.ItemData = { zone = "BADGES", tattoos = badgeTattoos, savedList = currentCharacter.PedTattoos.BadgeTattoos }

    local removeAllBtn = MenuItem:New("Remove All Tattoos", "Clear all tattoos and badges from your character.")

    tattooMenu:AddMenuItem(headList)
    tattooMenu:AddMenuItem(torsoList)
    tattooMenu:AddMenuItem(leftArmList)
    tattooMenu:AddMenuItem(rightArmList)
    tattooMenu:AddMenuItem(leftLegList)
    tattooMenu:AddMenuItem(rightLegList)
    tattooMenu:AddMenuItem(badgeList)
    tattooMenu:AddMenuItem(removeAllBtn)

    tattooMenu.OnIndexChange = function(sender, oldItem, newItem, oldIndex, newIndex)
        ApplySavedTattoos()
    end

    tattooMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        ApplySavedTattoos()

        if item.ItemData and item.ItemData.tattoos then
            local tattooData = item.ItemData.tattoos[newIndex]
            if tattooData then
                local collection = tattooData.collectionName
                local name = tattooData.name

                if not IsTattooApplied(item.ItemData.savedList, collection, name) then
                    SetPedDecoration(PlayerPedId(), GetHashKey(collection), GetHashKey(name))
                end
            end
        end
    end

    tattooMenu.OnListItemSelect = function(sender, item, listIndex, itemIndex)
        if item.ItemData and item.ItemData.tattoos then
            local tattooData = item.ItemData.tattoos[listIndex]
            if tattooData then
                local collection = tattooData.collectionName
                local name = tattooData.name
                local savedList = item.ItemData.savedList

                if IsTattooApplied(savedList, collection, name) then
                    RemoveTattoo(savedList, collection, name)
                    Notify.Success("Tattoo #" .. listIndex .. " has been ~r~removed~s~.")
                else
                    table.insert(savedList, { collection = collection, name = name })
                    Notify.Success("Tattoo #" .. listIndex .. " has been ~g~added~s~.")
                end

                ApplySavedTattoos()
            end
        end
    end

    tattooMenu.OnItemSelect = function(sender, item, index)
        if item.Text == "Remove All Tattoos" then
            ClearPedDecorations(PlayerPedId())
            currentCharacter.PedTattoos.HeadTattoos = {}
            currentCharacter.PedTattoos.TorsoTattoos = {}
            currentCharacter.PedTattoos.LeftArmTattoos = {}
            currentCharacter.PedTattoos.RightArmTattoos = {}
            currentCharacter.PedTattoos.LeftLegTattoos = {}
            currentCharacter.PedTattoos.RightLegTattoos = {}
            currentCharacter.PedTattoos.BadgeTattoos = {}
            Notify.Success("All tattoos have been removed.")

            if currentCharacter.PedAppearance.HairOverlay and
                currentCharacter.PedAppearance.HairOverlay.collection and
                currentCharacter.PedAppearance.HairOverlay.name then
                SetPedDecoration(PlayerPedId(),
                    GetHashKey(currentCharacter.PedAppearance.HairOverlay.collection),
                    GetHashKey(currentCharacter.PedAppearance.HairOverlay.name))
            end
        end
    end
end

function MpPedCustomizationMenu.RefreshTattooMenuItems()

    tattooMenu:ClearMenuItems()

    local isMale = currentCharacter.IsMale
    local headTattoos = TattoosData.GetTattoosByZone(isMale, "HEAD")
    local torsoTattoos = TattoosData.GetTattoosByZone(isMale, "TORSO")
    local leftArmTattoos = TattoosData.GetTattoosByZone(isMale, "LEFT_ARM")
    local rightArmTattoos = TattoosData.GetTattoosByZone(isMale, "RIGHT_ARM")
    local leftLegTattoos = TattoosData.GetTattoosByZone(isMale, "LEFT_LEG")
    local rightLegTattoos = TattoosData.GetTattoosByZone(isMale, "RIGHT_LEG")
    local badgeTattoos = TattoosData.GetTattoosByZone(isMale, "BADGES")

    local function CreateTattooNames(tattoos, prefix)
        local names = {}
        local count = #tattoos
        for i = 1, count do
            table.insert(names, prefix .. " #" .. i .. " (of " .. count .. ")")
        end
        return names
    end

    local headNames = CreateTattooNames(headTattoos, "Tattoo")
    local torsoNames = CreateTattooNames(torsoTattoos, "Tattoo")
    local leftArmNames = CreateTattooNames(leftArmTattoos, "Tattoo")
    local rightArmNames = CreateTattooNames(rightArmTattoos, "Tattoo")
    local leftLegNames = CreateTattooNames(leftLegTattoos, "Tattoo")
    local rightLegNames = CreateTattooNames(rightLegTattoos, "Tattoo")
    local badgeNames = CreateTattooNames(badgeTattoos, "Badge")

    local tatDesc =
    "Cycle through the list to preview tattoos. If you like one, press enter to select it, selecting it will add the tattoo if you don't already have it. If you already have that tattoo then the tattoo will be removed."

    local headList = MenuListItem:New("Head Tattoos", headNames, 0, tatDesc)
    headList.ItemData = { zone = "HEAD", tattoos = headTattoos, savedList = currentCharacter.PedTattoos.HeadTattoos }

    local torsoList = MenuListItem:New("Torso Tattoos", torsoNames, 0, tatDesc)
    torsoList.ItemData = { zone = "TORSO", tattoos = torsoTattoos, savedList = currentCharacter.PedTattoos.TorsoTattoos }

    local leftArmList = MenuListItem:New("Left Arm Tattoos", leftArmNames, 0, tatDesc)
    leftArmList.ItemData = {
        zone = "LEFT_ARM",
        tattoos = leftArmTattoos,
        savedList = currentCharacter.PedTattoos
            .LeftArmTattoos
    }

    local rightArmList = MenuListItem:New("Right Arm Tattoos", rightArmNames, 0, tatDesc)
    rightArmList.ItemData = {
        zone = "RIGHT_ARM",
        tattoos = rightArmTattoos,
        savedList = currentCharacter.PedTattoos
            .RightArmTattoos
    }

    local leftLegList = MenuListItem:New("Left Leg Tattoos", leftLegNames, 0, tatDesc)
    leftLegList.ItemData = {
        zone = "LEFT_LEG",
        tattoos = leftLegTattoos,
        savedList = currentCharacter.PedTattoos
            .LeftLegTattoos
    }

    local rightLegList = MenuListItem:New("Right Leg Tattoos", rightLegNames, 0, tatDesc)
    rightLegList.ItemData = {
        zone = "RIGHT_LEG",
        tattoos = rightLegTattoos,
        savedList = currentCharacter.PedTattoos
            .RightLegTattoos
    }

    local badgeList = MenuListItem:New("Badge Overlays", badgeNames, 0, tatDesc)
    badgeList.ItemData = { zone = "BADGES", tattoos = badgeTattoos, savedList = currentCharacter.PedTattoos.BadgeTattoos }

    local removeAllBtn = MenuItem:New("Remove All Tattoos",
        "Click this if you want to remove all tattoos and start over.")

    tattooMenu:AddMenuItem(headList)
    tattooMenu:AddMenuItem(torsoList)
    tattooMenu:AddMenuItem(leftArmList)
    tattooMenu:AddMenuItem(rightArmList)
    tattooMenu:AddMenuItem(leftLegList)
    tattooMenu:AddMenuItem(rightLegList)
    tattooMenu:AddMenuItem(badgeList)
    tattooMenu:AddMenuItem(removeAllBtn)

end

function MpPedCustomizationMenu.SetupClothingMenuHandlers()

    local componentNames = {
        [1] = "Masks",
        [3] = "Upper Body",
        [4] = "Lower Body",
        [5] = "Bags & Parachutes",
        [6] = "Shoes",
        [7] = "Scarfs & Chains",
        [8] = "Shirt & Accessory",
        [9] = "Body Armor & Accessory 2",
        [10] = "Badges & Logos",
        [11] = "Shirt Overlay & Jackets"
    }

    clothingMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item.ItemData then
            local ped = PlayerPedId()
            local componentId = item.ItemData.componentId
            local baseName = componentNames[componentId] or "Item"
            local maxDrawables = GetNumberOfPedDrawableVariations(ped, componentId)

            if newIndex == 1 then
                currentCharacter.DrawableVariations[componentId].drawable = 0
                currentCharacter.DrawableVariations[componentId].texture = 0
                SetPedComponentVariation(ped, componentId, 0, 0, 0)
                local maxTex = GetNumberOfPedTextureVariations(ped, componentId, 0)
                item.Text = baseName
                item.Description = "Default / Remove.\nDrawable: ~c~0~s~ / " .. maxDrawables .. "\nTexture: ~y~1~s~ / " .. maxTex
            else
                local drawable = newIndex - 2
                local texture = currentCharacter.DrawableVariations[componentId].texture

                currentCharacter.DrawableVariations[componentId].drawable = drawable
                SetPedComponentVariation(ped, componentId, drawable, texture, 0)

                local maxTextures = GetNumberOfPedTextureVariations(ped, componentId, drawable)
                if texture >= maxTextures then
                    texture = 0
                    currentCharacter.DrawableVariations[componentId].texture = texture
                    SetPedComponentVariation(ped, componentId, drawable, texture, 0)
                end

                item.Text = baseName
                item.Description = "Press ~r~ENTER~s~ to cycle textures.\nDrawable: ~y~" .. (drawable + 1) .. "~s~ / " .. maxDrawables .. "\nTexture: ~y~" .. (texture + 1) .. "~s~ / " .. maxTextures
            end
        end
    end

    clothingMenu.OnListItemSelect = function(sender, item, listIndex, itemIndex)
        if item.ItemData then
            local ped = PlayerPedId()
            local componentId = item.ItemData.componentId

            if listIndex > 1 then
                local drawable = currentCharacter.DrawableVariations[componentId].drawable
                local texture = currentCharacter.DrawableVariations[componentId].texture
                local maxDrawables = GetNumberOfPedDrawableVariations(ped, componentId)
                local maxTextures = GetNumberOfPedTextureVariations(ped, componentId, drawable)

                if maxTextures > 1 then
                    texture = (texture + 1) % maxTextures
                elseif maxTextures == 1 then
                    texture = 0
                end

                currentCharacter.DrawableVariations[componentId].texture = texture
                SetPedComponentVariation(ped, componentId, drawable, texture, 0)

                local baseName = componentNames[componentId] or "Item"
                item.Text = baseName
                item.Description = "Press ~r~ENTER~s~ to cycle textures.\nDrawable: ~y~" .. (drawable + 1) .. "~s~ / " .. maxDrawables .. "\nTexture: ~y~" .. (texture + 1) .. "~s~ / " .. maxTextures
            end
        end
    end
end

function MpPedCustomizationMenu.RefreshClothingMenuItems()
    clothingMenu:ClearMenuItems()

    local ped = PlayerPedId()

    local componentIndices = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
    local componentNames = {
        [1] = "Masks",
        [3] = "Upper Body",
        [4] = "Lower Body",
        [5] = "Bags & Parachutes",
        [6] = "Shoes",
        [7] = "Scarfs & Chains",
        [8] = "Shirt & Accessory",
        [9] = "Body Armor & Accessory 2",
        [10] = "Badges & Logos",
        [11] = "Shirt Overlay & Jackets"
    }

    for _, componentId in ipairs(componentIndices) do
        local maxDrawables = GetNumberOfPedDrawableVariations(ped, componentId)
        local currentDrawable = GetPedDrawableVariation(ped, componentId)
        local currentTexture = GetPedTextureVariation(ped, componentId)

        currentCharacter.DrawableVariations[componentId].drawable = currentDrawable
        currentCharacter.DrawableVariations[componentId].texture = currentTexture

        local items = { "0/" .. maxDrawables }
        local maxTextures = GetNumberOfPedTextureVariations(ped, componentId, currentDrawable)
        for i = 0, maxDrawables - 1 do
            table.insert(items, "" .. (i + 1) .. "/" .. maxDrawables)
        end

        local description
        if currentDrawable == 0 then
            local maxTex = GetNumberOfPedTextureVariations(ped, componentId, 0)
            description = "Default / Remove.\nDrawable: ~c~0~s~ / " .. maxDrawables .. "\nTexture: ~y~1~s~ / " .. maxTex
        else
            description = "Press ~r~ENTER~s~ to cycle textures.\nDrawable: ~y~" .. (currentDrawable + 1) .. "~s~ / " .. maxDrawables .. "\nTexture: ~y~" .. (currentTexture + 1) .. "~s~ / " .. maxTextures
        end

        local itemName
        if currentDrawable == 0 then
            itemName = componentNames[componentId]
        else
            itemName = componentNames[componentId]
        end

        local listItem = MenuListItem:New(itemName, items, currentDrawable + 2, description)
        listItem.ItemData = { componentId = componentId }
        clothingMenu:AddMenuItem(listItem)
    end
end

function MpPedCustomizationMenu.SetupPropsMenuHandlers()

    local propNames = {
        [0] = "Hats & Helmets",
        [1] = "Glasses",
        [2] = "Misc Props",
        [6] = "Watches",
        [7] = "Bracelets"
    }

    propsMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item.ItemData then
            local ped = PlayerPedId()
            local propId = item.ItemData.propId
            local propIndex = newIndex == 1 and -1 or (newIndex - 2)
            local maxProps = GetNumberOfPedPropDrawableVariations(ped, propId)

            if propIndex == -1 then
                SetPedPropIndex(ped, propId, -1, -1, false)
                ClearPedProp(ped, propId)
                currentCharacter.PropVariations[propId].drawable = -1
                currentCharacter.PropVariations[propId].texture = -1
                item.Description = "No prop selected.\nDrawable: ~c~none~s~ / " .. maxProps .. "\nTexture: ~c~none~s~"
            else
                local textureIndex = 0
                local maxTextures = GetNumberOfPedPropTextureVariations(ped, propId, propIndex)
                SetPedPropIndex(ped, propId, propIndex, textureIndex, true)
                currentCharacter.PropVariations[propId].drawable = propIndex
                currentCharacter.PropVariations[propId].texture = textureIndex
                item.Description = "Press ~r~ENTER~s~ to cycle textures.\nDrawable: ~y~" .. (propIndex + 1) .. "~s~ / " .. maxProps .. "\nTexture: ~y~" .. (textureIndex + 1) .. "~s~ / " .. maxTextures
            end

            local baseName = propNames[propId] or "Prop"
            if propIndex == -1 then
                item.Text = baseName .. " ~r~(None)~s~"
            else
                item.Text = baseName
            end
        end
    end

    propsMenu.OnListItemSelect = function(sender, item, listIndex, itemIndex)
        if item.ItemData then
            local ped = PlayerPedId()
            local propId = item.ItemData.propId
            local propIndex = currentCharacter.PropVariations[propId].drawable

            if propIndex == -1 then
                SetPedPropIndex(ped, propId, -1, -1, false)
                ClearPedProp(ped, propId)
            else
                local currentTexture = GetPedPropTextureIndex(ped, propId)
                local maxTextures = GetNumberOfPedPropTextureVariations(ped, propId, propIndex)
                local maxProps = GetNumberOfPedPropDrawableVariations(ped, propId)
                local newTexture = (currentTexture + 1 >= maxTextures) and 0 or (currentTexture + 1)

                SetPedPropIndex(ped, propId, propIndex, newTexture, true)
                currentCharacter.PropVariations[propId].texture = newTexture

                local baseName = propNames[propId] or "Prop"
                item.Text = baseName
                item.Description = "Press ~r~ENTER~s~ to cycle textures.\nDrawable: ~y~" .. (propIndex + 1) .. "~s~ / " .. maxProps .. "\nTexture: ~y~" .. (newTexture + 1) .. "~s~ / " .. maxTextures
            end
        end
    end
end

function MpPedCustomizationMenu.RefreshPropsMenuItems()
    propsMenu:ClearMenuItems()

    local ped = PlayerPedId()

    local propIndices = { 0, 1, 2, 6, 7 }
    local propNames = {
        [0] = "Hats & Helmets",
        [1] = "Glasses",
        [2] = "Misc Props",
        [6] = "Watches",
        [7] = "Bracelets"
    }

    for _, propId in ipairs(propIndices) do
        local maxProps = GetNumberOfPedPropDrawableVariations(ped, propId)
        local currentProp = currentCharacter.PropVariations[propId].drawable
        local currentTexture = currentCharacter.PropVariations[propId].texture

        local items = { "No Prop" }
        for i = 0, maxProps - 1 do
            table.insert(items, "Prop " .. i)
        end

        local selectedIndex = currentProp == -1 and 1 or (currentProp + 2)
        local maxTextures = currentProp == -1 and 0 or GetNumberOfPedPropTextureVariations(ped, propId, currentProp)

        local description
        if currentProp == -1 then
            description = "No prop selected.\nDrawable: ~c~none~s~ / " .. maxProps .. "\nTexture: ~c~none~s~"
        else
            description = "Press ~r~ENTER~s~ to cycle textures.\nDrawable: ~y~" .. (currentProp + 1) .. "~s~ / " .. maxProps .. "\nTexture: ~y~" .. (currentTexture + 1) .. "~s~ / " .. maxTextures
        end

        local itemName
        if currentProp == -1 then
            itemName = propNames[propId] .. " ~r~(None)~s~"
        else
            itemName = propNames[propId]
        end

        local listItem = MenuListItem:New(itemName, items, selectedIndex, description)
        listItem.ItemData = { propId = propId }
        propsMenu:AddMenuItem(listItem)
    end
end

function MpPedCustomizationMenu.CreateSavedCharactersMenu()
    savedCharactersMenu = Menu:New("Saved Characters", "Your saved characters")
    MenuController:AddMenu(savedCharactersMenu)

    PedPreview.Register(savedCharactersMenu, function(sender)
        local item = sender:GetMenuItems()[sender.CurrentIndex]
        return MpPedCustomizationMenu.GetPreview(item and item.ItemData)
    end)

    MpPedCustomizationMenu.RefreshSavedCharactersMenu()
end

function MpPedCustomizationMenu.RefreshSavedCharactersMenu()
    savedCharsDirty = false
    savedCharactersMenu:ClearMenuItems()

    local savedCharacters = {}
    local processedKeys = {}

    local function ProcessKey(key)
        if not key or type(key) ~= "string" or key == "" then
            return
        end

        if processedKeys[key] then
            return
        end
        processedKeys[key] = true

        if key:match("^vmenu_") or key:match("^settings_") or key:match("^config_") then
            return
        end

        local success, data = pcall(function()
            return GetResourceKvpString(key)
        end)

        if not success or not data or type(data) ~= "string" or data == "" then
            return
        end

        local decodeSuccess, charData = pcall(function()
            return json.decode(data)
        end)

        if not decodeSuccess or type(charData) ~= "table" then
            return
        end

        local isValidChar = (charData.IsMale ~= nil) and
            (charData.PedHeadBlendData ~= nil or charData.ModelHash ~= nil or charData.PedAppearance ~= nil)

        if isValidChar then
            charData.kvpKey = key
            if not charData.SaveName or charData.SaveName == "" then
                charData.SaveName = key:gsub("^mp_ped_", ""):gsub("^mp_char_", ""):gsub("^char_", "")
            else
                local displayName = charData.SaveName:gsub("^mp_ped_", ""):gsub("^mp_char_", ""):gsub("^char_", "")
                charData.DisplayName = displayName
            end

            table.insert(savedCharacters, charData)
        end
    end

    local searchPrefixes = { "mp_ped_", "mp_char_", "char_" }

    for _, prefix in ipairs(searchPrefixes) do
        local success, findHandle = pcall(StartFindKvp, prefix)

        if success and findHandle then
            while true do
                local key = FindKvp(findHandle)
                if not key then
                    break
                end
                ProcessKey(key)
            end
            pcall(EndFindKvp, findHandle)
        end
    end

    table.sort(savedCharacters, function(a, b)
        return (a.SaveName or ""):lower() < (b.SaveName or ""):lower()
    end)

    if #savedCharacters == 0 then
        local noCharsBtn = MenuItem:New("No saved characters", "Create a character to see it here.")
        noCharsBtn.Enabled = false
        savedCharactersMenu:AddMenuItem(noCharsBtn)
    else
        for _, charData in ipairs(savedCharacters) do
            local displayName = charData.DisplayName or charData.SaveName
            local btn = MenuItem:New(displayName, "Click to manage this character.")
            btn.Label = "→→→"
            btn.ItemData = charData

            local actionsMenu = MpPedCustomizationMenu.CreateCharacterActionsMenu(charData)

            savedCharactersMenu:AddMenuItem(btn)

            MenuController:BindMenuItem(savedCharactersMenu, actionsMenu, btn)
        end
    end
end

function MpPedCustomizationMenu.CreateCharacterActionsMenu(charData)
    local displayName = charData.DisplayName or charData.SaveName:gsub("^mp_ped_", "")
    local actionsMenu = Menu:New("Manage Character", displayName)
    MenuController:AddMenu(actionsMenu)
    PedPreview.Register(actionsMenu, function()
        return MpPedCustomizationMenu.GetPreview(charData)
    end)

    local spawnBtn = MenuItem:New("Spawn Saved Character", "Become this character.")
    local editBtn = MenuItem:New("Edit Saved Character", "Load this character in the customization menu to edit it.")
    local cloneBtn = MenuItem:New("Clone Saved Character", "Clone this saved character into a new separate character.")
    local setAsDefaultBtn = MenuItem:New("Set As Default Character",
        "If this is set to the default character, then you will spawn as this character every time you join the server.")
    local renameBtn = MenuItem:New("Rename Saved Character", "Rename this saved character.")
    local deleteBtn = MenuItem:New("~r~Delete Saved Character", "Delete this saved character. This can NOT be undone!")
    deleteBtn.RightIcon = Icon.WARNING

    actionsMenu:AddMenuItem(spawnBtn)
    actionsMenu:AddMenuItem(editBtn)
    actionsMenu:AddMenuItem(cloneBtn)
    actionsMenu:AddMenuItem(setAsDefaultBtn)
    actionsMenu:AddMenuItem(renameBtn)
    actionsMenu:AddMenuItem(deleteBtn)

    actionsMenu.OnItemSelect = function(sender, item, index)
        if item == spawnBtn then
            MpPedCustomizationMenu.LoadCharacter(charData)
        elseif item == editBtn then
            actionsMenu:CloseMenu()
            savedCharactersMenu:CloseMenu()
            MpPedCustomizationMenu.LoadCharacterForEditing(charData)
        elseif item == cloneBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "Clone of " .. displayName, "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end

            if GetOnscreenKeyboardResult() then
                local newName = GetOnscreenKeyboardResult()
                if newName and newName ~= "" then
                    local newKey = KVP_PREFIX .. newName
                    local existingData = GetResourceKvpString(newKey)

                    if existingData and existingData ~= "" then
                        Notify.Error("A character with that name already exists.")
                    else
                        local clonedData = {}
                        for k, v in pairs(charData) do
                            clonedData[k] = v
                        end
                        clonedData.SaveName = KVP_PREFIX .. newName
                        clonedData.kvpKey = nil
                        clonedData.DisplayName = nil

                        local jsonData = json.encode(clonedData)
                        SetResourceKvp(newKey, jsonData)
                        Notify.Success("Character cloned as: ~g~" .. newName)
                        MpPedCustomizationMenu.RefreshSavedCharactersMenu()
                    end
                else
                    Notify.Error("Invalid name.")
                end
            end
        elseif item == setAsDefaultBtn then
            SetResourceKvp("vmenu_default_character", charData.kvpKey)
            Notify.Success("~g~" .. displayName .. "~s~ is now your default character.")
        elseif item == renameBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", displayName, "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end

            if GetOnscreenKeyboardResult() then
                local newName = GetOnscreenKeyboardResult()
                if newName and newName ~= "" then
                    local newKey = KVP_PREFIX .. newName
                    local existingData = GetResourceKvpString(newKey)

                    if newKey == charData.kvpKey then
                        Notify.Error("That's already the current name.")
                    elseif existingData and existingData ~= "" then
                        Notify.Error("A character with that name already exists.")
                    else
                        local oldData = GetResourceKvpString(charData.kvpKey)
                        if oldData then
                            local parsedData = json.decode(oldData)
                            if parsedData then
                                parsedData.SaveName = KVP_PREFIX .. newName
                                local newJsonData = json.encode(parsedData)
                                SetResourceKvp(newKey, newJsonData)
                                DeleteResourceKvp(charData.kvpKey)
                                Notify.Success("Character renamed to: ~g~" .. newName)
                                actionsMenu:CloseMenu()
                                MpPedCustomizationMenu.RefreshSavedCharactersMenu()
                            end
                        end
                    end
                else
                    Notify.Error("Invalid name.")
                end
            end
        elseif item == deleteBtn then
            if item.Label == "Are you sure?" then
                DeleteResourceKvp(charData.kvpKey)
                Notify.Success("Character deleted: ~r~" .. displayName)
                actionsMenu:CloseMenu()
                MpPedCustomizationMenu.RefreshSavedCharactersMenu()
                item.Label = ""
            else
                item.Label = "Are you sure?"
            end
        end
    end

    actionsMenu.OnMenuClose = function(sender)
        deleteBtn.Label = ""
    end

    return actionsMenu
end

function MpPedCustomizationMenu.LoadCharacterForEditing(charData)
    isEditingCharacter = true
    editingKvpKey = charData.kvpKey
    editingDisplayName = charData.DisplayName or charData.SaveName:gsub("^mp_ped_", "")

    MpPedCustomizationMenu.LoadCharacterData(charData)

    MpPedCustomizationMenu.StartCharacterCreation(currentCharacter.IsMale, true)

    Notify.Info("Editing character: ~y~" .. editingDisplayName)
end

function MpPedCustomizationMenu.LoadCharacterData(charData)
    currentCharacter.SaveName = charData.SaveName or ""
    currentCharacter.IsMale = charData.IsMale
    currentCharacter.ModelHash = charData.ModelHash or (charData.IsMale and MALE_MODEL or FEMALE_MODEL)
    currentCharacter.Version = charData.Version or 1
    currentCharacter.Category = charData.Category or "Uncategorized"
    currentCharacter.FacialExpression = charData.FacialExpression or "mood_Normal_1"

    if charData.PedHeadBlendData then
        currentCharacter.PedHeadBlendData.FirstFaceShape = charData.PedHeadBlendData.FirstFaceShape or 0
        currentCharacter.PedHeadBlendData.SecondFaceShape = charData.PedHeadBlendData.SecondFaceShape or 0
        currentCharacter.PedHeadBlendData.ThirdFaceShape = charData.PedHeadBlendData.ThirdFaceShape or 0
        currentCharacter.PedHeadBlendData.FirstSkinTone = charData.PedHeadBlendData.FirstSkinTone or 0
        currentCharacter.PedHeadBlendData.SecondSkinTone = charData.PedHeadBlendData.SecondSkinTone or 0
        currentCharacter.PedHeadBlendData.ThirdSkinTone = charData.PedHeadBlendData.ThirdSkinTone or 0
        currentCharacter.PedHeadBlendData.ParentFaceShapePercent = charData.PedHeadBlendData.ParentFaceShapePercent or
            0.5
        currentCharacter.PedHeadBlendData.ParentSkinTonePercent = charData.PedHeadBlendData.ParentSkinTonePercent or 0.5
        currentCharacter.PedHeadBlendData.IsParentInheritance = charData.PedHeadBlendData.IsParentInheritance == true
    end

    if charData.PedAppearance then
        for key, value in pairs(charData.PedAppearance) do
            if currentCharacter.PedAppearance[key] ~= nil then
                currentCharacter.PedAppearance[key] = value
            end
        end
    end

    if charData.FaceShapeFeatures then
        if charData.FaceShapeFeatures.features then
            for i = 0, 19 do
                local strId = tostring(i)
                currentCharacter.FaceShapeFeatures[i] = charData.FaceShapeFeatures.features[strId] or
                    charData.FaceShapeFeatures.features[i] or 0.0
            end
        else
            for i = 0, 19 do
                local strId = tostring(i)
                currentCharacter.FaceShapeFeatures[i] = charData.FaceShapeFeatures[strId] or
                    charData.FaceShapeFeatures[i] or 0.0
            end
        end
    end

    if charData.DrawableVariations and charData.DrawableVariations.clothes then
        local clothes = charData.DrawableVariations.clothes
        for componentId = 0, 11 do
            local strId = tostring(componentId)
            local clothingData = clothes[strId] or clothes[componentId]
            if clothingData then
                local drawable = clothingData.Key or clothingData.drawable or 0
                local texture = clothingData.Value or clothingData.texture or 0
                currentCharacter.DrawableVariations[componentId] = { drawable = drawable, texture = texture }
            end
        end
    elseif charData.DrawableVariations then
        for componentId, data in pairs(charData.DrawableVariations) do
            local numId = tonumber(componentId)
            if numId and type(data) == "table" then
                local drawable = data.drawable or data.Key or 0
                local texture = data.texture or data.Value or 0
                currentCharacter.DrawableVariations[numId] = { drawable = drawable, texture = texture }
            end
        end
    end

    if charData.PropVariations and charData.PropVariations.props then
        local props = charData.PropVariations.props
        for _, propId in ipairs({ 0, 1, 2, 6, 7 }) do
            local strId = tostring(propId)
            local propData = props[strId] or props[propId]
            if propData then
                local drawable = propData.Key or propData.drawable or -1
                local texture = propData.Value or propData.texture or 0
                currentCharacter.PropVariations[propId] = { drawable = drawable, texture = texture }
            end
        end
    elseif charData.PropVariations then
        for propId, data in pairs(charData.PropVariations) do
            local numId = tonumber(propId)
            if numId and type(data) == "table" then
                currentCharacter.PropVariations[numId] = {
                    drawable = data.drawable or data.Key or -1,
                    texture = data.texture or data.Value or 0
                }
            end
        end
    end

    local tattoos = charData.PedTattoos or charData.PedTatttoos
    if tattoos then
        local function convertTattooList(list)
            if not list then return {} end
            local result = {}
            for _, tattoo in ipairs(list) do
                if tattoo.Key and tattoo.Value then
                    table.insert(result, { collection = tattoo.Key, name = tattoo.Value })
                elseif tattoo.collection and tattoo.name then
                    table.insert(result, tattoo)
                end
            end
            return result
        end

        currentCharacter.PedTattoos.HeadTattoos = convertTattooList(tattoos.HeadTattoos)
        currentCharacter.PedTattoos.TorsoTattoos = convertTattooList(tattoos.TorsoTattoos)
        currentCharacter.PedTattoos.LeftArmTattoos = convertTattooList(tattoos.LeftArmTattoos)
        currentCharacter.PedTattoos.RightArmTattoos = convertTattooList(tattoos.RightArmTattoos)
        currentCharacter.PedTattoos.LeftLegTattoos = convertTattooList(tattoos.LeftLegTattoos)
        currentCharacter.PedTattoos.RightLegTattoos = convertTattooList(tattoos.RightLegTattoos)
        currentCharacter.PedTattoos.BadgeTattoos = convertTattooList(tattoos.BadgeTattoos)
    end
end

function MpPedCustomizationMenu.RandomizeCharacter()
    currentCharacter.PedHeadBlendData.FirstFaceShape = math.random(0, 45)
    currentCharacter.PedHeadBlendData.SecondFaceShape = math.random(0, 45)
    currentCharacter.PedHeadBlendData.FirstSkinTone = currentCharacter.PedHeadBlendData.FirstFaceShape
    currentCharacter.PedHeadBlendData.SecondSkinTone = currentCharacter.PedHeadBlendData.SecondFaceShape

    currentCharacter.PedHeadBlendData.ParentFaceShapePercent = math.random() * 0.6 + 0.2
    currentCharacter.PedHeadBlendData.ParentSkinTonePercent = math.random() * 0.6 + 0.2

    for i = 0, 19 do
        currentCharacter.FaceShapeFeatures[i] = (math.random(5, 15) - 10) / 10.0
    end

    local ped = PlayerPedId()
    local maxHair = GetNumberOfPedDrawableVariations(ped, 2)
    currentCharacter.PedAppearance.hairStyle = math.random(0, maxHair - 1)
    currentCharacter.PedAppearance.hairColor = math.random(0, 31)
    currentCharacter.PedAppearance.hairHighlightColor = math.random(0, 31)

    currentCharacter.PedAppearance.eyeColor = math.random(0, 31)

    currentCharacter.PedAppearance.blemishesStyle = math.random(0, 23)
    currentCharacter.PedAppearance.blemishesOpacity = math.random(3, 7) / 10.0

    currentCharacter.PedAppearance.ageingStyle = math.random(0, 14)
    currentCharacter.PedAppearance.ageingOpacity = math.random(3, 7) / 10.0

    currentCharacter.PedAppearance.complexionStyle = math.random(0, 11)
    currentCharacter.PedAppearance.complexionOpacity = math.random(3, 7) / 10.0

    if currentCharacter.IsMale then
        currentCharacter.PedAppearance.beardStyle = math.random(0, 28)
        currentCharacter.PedAppearance.beardOpacity = math.random(8, 10) / 10.0
        currentCharacter.PedAppearance.beardColor = math.random(0, 31)
    end

    currentCharacter.PedAppearance.eyebrowsStyle = math.random(0, 33)
    currentCharacter.PedAppearance.eyebrowsOpacity = 1.0
    currentCharacter.PedAppearance.eyebrowsColor = math.random(0, 31)

    MpPedCustomizationMenu.ApplyCharacterData()
    Notify.Success("Character randomized!")
end

function MpPedCustomizationMenu.ApplyHeadBlend()
    local ped = PlayerPedId()
    local blend = currentCharacter.PedHeadBlendData

    SetPedHeadBlendData(ped,
        (blend.FirstFaceShape or 0) + 0,
        (blend.SecondFaceShape or 0) + 0,
        (blend.ThirdFaceShape or 0) + 0,
        (blend.FirstSkinTone or 0) + 0,
        (blend.SecondSkinTone or 0) + 0,
        (blend.ThirdSkinTone or 0) + 0,
        (blend.ParentFaceShapePercent or 0.5) + 0.0,
        (blend.ParentSkinTonePercent or 0.5) + 0.0,
        0.0 + 0.0,
        false
    )

    Citizen.InvokeNative(0x4668D80430D6C299, ped)

    if FaceSyncFix then FaceSyncFix.Store(blend) end
end

function MpPedCustomizationMenu.ApplyHairOverlay()
    local hairStyle = currentCharacter.PedAppearance.hairStyle
    if hairOverlays[hairStyle] then
        local overlay = hairOverlays[hairStyle]
        ClearPedFacialDecorations(PlayerPedId())
        SetPedDecoration(PlayerPedId(), GetHashKey(overlay.collection), GetHashKey(overlay.name))
        currentCharacter.PedAppearance.HairOverlay = overlay
    end
end

function MpPedCustomizationMenu.ApplyFacialExpression()
    local ped = PlayerPedId()
    SetFacialIdleAnimOverride(ped, currentCharacter.FacialExpression, "")
end

function MpPedCustomizationMenu.ApplyCharacterData()
    local ped = PlayerPedId()

    MpPedCustomizationMenu.ApplyHeadBlend()

    SetPedComponentVariation(ped, 2, currentCharacter.PedAppearance.hairStyle, 0, 0)
    SetPedHairColor(ped, currentCharacter.PedAppearance.hairColor, currentCharacter.PedAppearance.hairHighlightColor)
    MpPedCustomizationMenu.ApplyHairOverlay()

    SetPedEyeColor(ped, currentCharacter.PedAppearance.eyeColor)

    for _, overlay in ipairs(OVERLAY_MAP) do
        local style = currentCharacter.PedAppearance[overlay.style]
        local opacity = currentCharacter.PedAppearance[overlay.opacity]

        if style ~= 255 then
            SetPedHeadOverlay(ped, overlay.index, style, opacity)
            if overlay.color then
                local color = currentCharacter.PedAppearance[overlay.color]
                SetPedHeadOverlayColor(ped, overlay.index, overlay.colorType, color, color)
            end
        else
            SetPedHeadOverlay(ped, overlay.index, 255, 0.0)
        end
    end

    for i = 0, 19 do
        SetPedFaceFeature(ped, i, currentCharacter.FaceShapeFeatures[i])
    end

    local clothingCount = 0
    for componentId, clothing in pairs(currentCharacter.DrawableVariations) do
        SetPedComponentVariation(ped, componentId, clothing.drawable, clothing.texture, 0)
        clothingCount = clothingCount + 1
    end

    for propId, prop in pairs(currentCharacter.PropVariations) do
        if prop.drawable == -1 then
            SetPedPropIndex(ped, propId, -1, -1, false)
            ClearPedProp(ped, propId)
        else
            SetPedPropIndex(ped, propId, prop.drawable, prop.texture, true)
        end
    end

    ClearPedDecorations(ped)
    for _, tattoo in ipairs(currentCharacter.PedTattoos.HeadTattoos or {}) do
        SetPedDecoration(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
    end
    for _, tattoo in ipairs(currentCharacter.PedTattoos.TorsoTattoos or {}) do
        SetPedDecoration(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
    end
    for _, tattoo in ipairs(currentCharacter.PedTattoos.LeftArmTattoos or {}) do
        SetPedDecoration(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
    end
    for _, tattoo in ipairs(currentCharacter.PedTattoos.RightArmTattoos or {}) do
        SetPedDecoration(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
    end
    for _, tattoo in ipairs(currentCharacter.PedTattoos.LeftLegTattoos or {}) do
        SetPedDecoration(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
    end
    for _, tattoo in ipairs(currentCharacter.PedTattoos.RightLegTattoos or {}) do
        SetPedDecoration(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
    end
    for _, tattoo in ipairs(currentCharacter.PedTattoos.BadgeTattoos or {}) do
        SetPedDecoration(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
    end

    MpPedCustomizationMenu.ApplyFacialExpression()

    Citizen.InvokeNative(0x4668D80430D6C299, ped)

    if FaceSyncFix and FaceSyncFix.StoreFull then
        FaceSyncFix.StoreFull(currentCharacter)
    end
end

local function ReadVariation(entry, defaultDrawable)
    if type(entry) == "table" then
        return entry.Key or entry.drawable or defaultDrawable, entry.Value or entry.texture or 0
    elseif type(entry) == "number" then
        return entry, 0
    end
    return nil, nil
end

function MpPedCustomizationMenu.ApplyCharacterToPed(ped, charData)
    local blend = charData.PedHeadBlendData or {}
    SetPedHeadBlendData(ped,
        (blend.FirstFaceShape or 0) + 0,
        (blend.SecondFaceShape or 0) + 0,
        (blend.ThirdFaceShape or 0) + 0,
        (blend.FirstSkinTone or 0) + 0,
        (blend.SecondSkinTone or 0) + 0,
        (blend.ThirdSkinTone or 0) + 0,
        (blend.ParentFaceShapePercent or 0.5) + 0.0,
        (blend.ParentSkinTonePercent or 0.5) + 0.0,
        0.0,
        false
    )
    local timeout = GetGameTimer() + 2000
    while not HasPedHeadBlendFinished(ped) and GetGameTimer() < timeout do
        Wait(0)
    end
    if not DoesEntityExist(ped) then return end

    local app = charData.PedAppearance or {}
    SetPedComponentVariation(ped, 2, app.hairStyle or 0, 0, 0)
    SetPedHairColor(ped, app.hairColor or 0, app.hairHighlightColor or 0)
    SetPedEyeColor(ped, app.eyeColor or 0)

    for _, overlay in ipairs(OVERLAY_MAP) do
        local style = app[overlay.style] or 255
        if style ~= 255 then
            SetPedHeadOverlay(ped, overlay.index, style, (app[overlay.opacity] or 1.0) + 0.0)
            if overlay.color then
                local color = app[overlay.color] or 0
                SetPedHeadOverlayColor(ped, overlay.index, overlay.colorType, color, color)
            end
        else
            SetPedHeadOverlay(ped, overlay.index, 255, 0.0)
        end
    end

    local features = charData.FaceShapeFeatures or {}
    features = features.features or features
    for i = 0, 19 do
        SetPedFaceFeature(ped, i, (features[tostring(i)] or features[i] or 0.0) + 0.0)
    end

    local clothes = charData.DrawableVariations or {}
    clothes = clothes.clothes or clothes
    for componentId = 0, 11 do
        local drawable, texture = ReadVariation(clothes[tostring(componentId)] or clothes[componentId], 0)
        if drawable then
            SetPedComponentVariation(ped, componentId, drawable, texture, 0)
        end
    end

    local props = charData.PropVariations or {}
    props = props.props or props
    for _, propId in ipairs({ 0, 1, 2, 6, 7 }) do
        local drawable, texture = ReadVariation(props[tostring(propId)] or props[propId], -1)
        if drawable and drawable ~= -1 then
            SetPedPropIndex(ped, propId, drawable, texture, true)
        else
            ClearPedProp(ped, propId)
        end
    end

    ClearPedDecorations(ped)
    local tattoos = charData.PedTattoos or charData.PedTatttoos
    if type(tattoos) == "table" then
        for _, list in pairs(tattoos) do
            if type(list) == "table" then
                for _, tattoo in ipairs(list) do
                    local collection = tattoo.collection or tattoo.Key
                    local name = tattoo.name or tattoo.Value
                    if collection and name then
                        SetPedDecoration(ped, GetHashKey(collection), GetHashKey(name))
                    end
                end
            end
        end
    end

    SetFacialIdleAnimOverride(ped, charData.FacialExpression or "mood_Normal_1", "")
end

function MpPedCustomizationMenu.GetPreview(charData)
    if type(charData) ~= "table" then return nil end
    local model = charData.ModelHash or (charData.IsMale and MALE_MODEL or FEMALE_MODEL)
    return charData, model, MpPedCustomizationMenu.ApplyCharacterToPed
end

local function BuildSaveData(saveName)
    local pedAppearanceCopy = {}
    for k, v in pairs(currentCharacter.PedAppearance) do
        if type(v) == "table" then
            pedAppearanceCopy[k] = {}
            for k2, v2 in pairs(v) do
                pedAppearanceCopy[k][k2] = v2
            end
        else
            pedAppearanceCopy[k] = v
        end
    end

    local pedTattoosCopy = {}
    for zone, tattooList in pairs(currentCharacter.PedTattoos) do
        pedTattoosCopy[zone] = {}
        for _, tattoo in ipairs(tattooList) do
            table.insert(pedTattoosCopy[zone], { collection = tattoo.collection, name = tattoo.name })
        end
    end

    local saveData = {
        SaveName = KVP_PREFIX .. saveName,
        DisplayName = saveName,
        IsMale = currentCharacter.IsMale,
        ModelHash = currentCharacter.ModelHash,
        Version = currentCharacter.Version or 1,
        Category = currentCharacter.Category or "Uncategorized",
        FacialExpression = currentCharacter.FacialExpression,

        PedHeadBlendData = {
            FirstFaceShape = currentCharacter.PedHeadBlendData.FirstFaceShape,
            SecondFaceShape = currentCharacter.PedHeadBlendData.SecondFaceShape,
            ThirdFaceShape = currentCharacter.PedHeadBlendData.ThirdFaceShape,
            FirstSkinTone = currentCharacter.PedHeadBlendData.FirstSkinTone,
            SecondSkinTone = currentCharacter.PedHeadBlendData.SecondSkinTone,
            ThirdSkinTone = currentCharacter.PedHeadBlendData.ThirdSkinTone,
            ParentFaceShapePercent = currentCharacter.PedHeadBlendData.ParentFaceShapePercent,
            ParentSkinTonePercent = currentCharacter.PedHeadBlendData.ParentSkinTonePercent,
            ParentThirdUnkPercent = 0.0,
            IsParentInheritance = currentCharacter.PedHeadBlendData.IsParentInheritance
        },

        PedAppearance = pedAppearanceCopy,

        FaceShapeFeatures = {
            features = {}
        },

        DrawableVariations = {
            clothes = {}
        },

        PropVariations = {
            props = {}
        },

        PedTatttoos = pedTattoosCopy,

        PedFacePaints = {}
    }

    for i = 0, 19 do
        if currentCharacter.FaceShapeFeatures[i] then
            saveData.FaceShapeFeatures.features[tostring(i)] = currentCharacter.FaceShapeFeatures[i]
        end
    end

    for componentId, data in pairs(currentCharacter.DrawableVariations) do
        if type(data) == "table" then
            saveData.DrawableVariations.clothes[tostring(componentId)] = {
                Key = data.drawable or 0,
                Value = data.texture or 0
            }
        end
    end

    for propId, data in pairs(currentCharacter.PropVariations) do
        if type(data) == "table" then
            saveData.PropVariations.props[tostring(propId)] = {
                Key = data.drawable or -1,
                Value = data.texture or 0
            }
        end
    end

    return saveData
end

function MpPedCustomizationMenu.SaveCharacter()
    if isEditingCharacter and editingKvpKey then
        local displayName = editingDisplayName or editingKvpKey:gsub("^mp_ped_", "")
        local saveName = editingKvpKey:gsub("^mp_ped_", "")
        local saveData = BuildSaveData(saveName)
        local jsonData = json.encode(saveData)
        SetResourceKvp(editingKvpKey, jsonData)
        savedCharsDirty = true
        Notify.Success("Character updated: ~g~" .. displayName)

        isEditingCharacter = false
        editingKvpKey = nil
        editingDisplayName = nil

        isInCharacterCreation = false
        createCharacterMenu:CloseMenu()
        MpPedCustomizationMenu.RestorePlayerModel()
        MpPedCustomizationMenu.GetMenu():OpenMenu()
        return
    end

    isInCharacterCreation = false
    createCharacterMenu:CloseMenu()

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local saveName = GetOnscreenKeyboardResult()
        if saveName and saveName ~= "" then
            local key = KVP_PREFIX .. saveName
            local existingData = GetResourceKvpString(key)

            if existingData and existingData ~= "" then
                Notify.Error("A character with that name already exists.")
                isInCharacterCreation = true
                createCharacterMenu:OpenMenu()
            else
                local saveData = BuildSaveData(saveName)
                local jsonData = json.encode(saveData)
                SetResourceKvp(key, jsonData)
                savedCharsDirty = true
                Notify.Success("Character saved as: ~g~" .. saveName)

                MpPedCustomizationMenu.RestorePlayerModel()
                MpPedCustomizationMenu.GetMenu():OpenMenu()
            end
        else
            Notify.Error("Invalid save name.")
            isInCharacterCreation = true
            createCharacterMenu:OpenMenu()
        end
    else
        isInCharacterCreation = true
        createCharacterMenu:OpenMenu()
    end
end

function MpPedCustomizationMenu.LoadCharacter(charData)

    currentCharacter.SaveName = charData.SaveName or ""
    currentCharacter.IsMale = charData.IsMale
    currentCharacter.ModelHash = charData.ModelHash or (charData.IsMale and MALE_MODEL or FEMALE_MODEL)
    currentCharacter.Version = charData.Version or 1
    currentCharacter.Category = charData.Category or "Uncategorized"
    currentCharacter.FacialExpression = charData.FacialExpression or "mood_Normal_1"

    if charData.PedHeadBlendData then
        currentCharacter.PedHeadBlendData.FirstFaceShape = charData.PedHeadBlendData.FirstFaceShape or 0
        currentCharacter.PedHeadBlendData.SecondFaceShape = charData.PedHeadBlendData.SecondFaceShape or 0
        currentCharacter.PedHeadBlendData.ThirdFaceShape = charData.PedHeadBlendData.ThirdFaceShape or 0
        currentCharacter.PedHeadBlendData.FirstSkinTone = charData.PedHeadBlendData.FirstSkinTone or 0
        currentCharacter.PedHeadBlendData.SecondSkinTone = charData.PedHeadBlendData.SecondSkinTone or 0
        currentCharacter.PedHeadBlendData.ThirdSkinTone = charData.PedHeadBlendData.ThirdSkinTone or 0
        currentCharacter.PedHeadBlendData.ParentFaceShapePercent = charData.PedHeadBlendData.ParentFaceShapePercent or
            0.5
        currentCharacter.PedHeadBlendData.ParentSkinTonePercent = charData.PedHeadBlendData.ParentSkinTonePercent or 0.5
        currentCharacter.PedHeadBlendData.IsParentInheritance = charData.PedHeadBlendData.IsParentInheritance == true
    end

    if charData.PedAppearance then
        local app = charData.PedAppearance
        currentCharacter.PedAppearance.hairStyle = app.hairStyle or 0
        currentCharacter.PedAppearance.hairColor = app.hairColor or 0
        currentCharacter.PedAppearance.hairHighlightColor = app.hairHighlightColor or 0
        currentCharacter.PedAppearance.HairOverlay = app.HairOverlay
        currentCharacter.PedAppearance.eyeColor = app.eyeColor or 0

        currentCharacter.PedAppearance.blemishesStyle = app.blemishesStyle or 255
        currentCharacter.PedAppearance.blemishesOpacity = app.blemishesOpacity or 1.0
        currentCharacter.PedAppearance.beardStyle = app.beardStyle or 255
        currentCharacter.PedAppearance.beardColor = app.beardColor or 0
        currentCharacter.PedAppearance.beardOpacity = app.beardOpacity or 1.0
        currentCharacter.PedAppearance.eyebrowsStyle = app.eyebrowsStyle or 255
        currentCharacter.PedAppearance.eyebrowsColor = app.eyebrowsColor or 0
        currentCharacter.PedAppearance.eyebrowsOpacity = app.eyebrowsOpacity or 1.0
        currentCharacter.PedAppearance.ageingStyle = app.ageingStyle or 255
        currentCharacter.PedAppearance.ageingOpacity = app.ageingOpacity or 1.0
        currentCharacter.PedAppearance.makeupStyle = app.makeupStyle or 255
        currentCharacter.PedAppearance.makeupColor = app.makeupColor or 0
        currentCharacter.PedAppearance.makeupOpacity = app.makeupOpacity or 1.0
        currentCharacter.PedAppearance.blushStyle = app.blushStyle or 255
        currentCharacter.PedAppearance.blushColor = app.blushColor or 0
        currentCharacter.PedAppearance.blushOpacity = app.blushOpacity or 1.0
        currentCharacter.PedAppearance.complexionStyle = app.complexionStyle or 255
        currentCharacter.PedAppearance.complexionOpacity = app.complexionOpacity or 1.0
        currentCharacter.PedAppearance.sunDamageStyle = app.sunDamageStyle or 255
        currentCharacter.PedAppearance.sunDamageOpacity = app.sunDamageOpacity or 1.0
        currentCharacter.PedAppearance.lipstickStyle = app.lipstickStyle or 255
        currentCharacter.PedAppearance.lipstickColor = app.lipstickColor or 0
        currentCharacter.PedAppearance.lipstickOpacity = app.lipstickOpacity or 1.0
        currentCharacter.PedAppearance.molesFrecklesStyle = app.molesFrecklesStyle or 255
        currentCharacter.PedAppearance.molesFrecklesOpacity = app.molesFrecklesOpacity or 1.0
        currentCharacter.PedAppearance.chestHairStyle = app.chestHairStyle or 255
        currentCharacter.PedAppearance.chestHairColor = app.chestHairColor or 0
        currentCharacter.PedAppearance.chestHairOpacity = app.chestHairOpacity or 1.0
        currentCharacter.PedAppearance.bodyBlemishesStyle = app.bodyBlemishesStyle or 255
        currentCharacter.PedAppearance.bodyBlemishesOpacity = app.bodyBlemishesOpacity or 1.0
    end

    if charData.FaceShapeFeatures and charData.FaceShapeFeatures.features then
        for i = 0, 19 do
            local strIndex = tostring(i)
            currentCharacter.FaceShapeFeatures[i] = charData.FaceShapeFeatures.features[strIndex] or
                charData.FaceShapeFeatures.features[i] or 0.0
        end
    elseif charData.FaceShapeFeatures and type(charData.FaceShapeFeatures) == "table" then
        for i = 0, 19 do
            currentCharacter.FaceShapeFeatures[i] = charData.FaceShapeFeatures[i] or
                charData.FaceShapeFeatures[tostring(i)] or 0.0
        end
    end

    if charData.DrawableVariations and charData.DrawableVariations.clothes then
        local clothes = charData.DrawableVariations.clothes
        for componentId = 0, 11 do
            local strId = tostring(componentId)
            local clothingData = clothes[strId] or clothes[componentId]
            if clothingData then
                local drawable = clothingData.Key or clothingData.drawable or 0
                local texture = clothingData.Value or clothingData.texture or 0
                currentCharacter.DrawableVariations[componentId] = { drawable = drawable, texture = texture }
            end
        end
    elseif charData.DrawableVariations then
        for componentId, data in pairs(charData.DrawableVariations) do
            local numId = tonumber(componentId)
            if numId and data then
                local drawable, texture
                if type(data) == "table" then
                    drawable = data.drawable or data.Key or 0
                    texture = data.texture or data.Value or 0
                else
                    drawable = data
                    texture = 0
                end
                currentCharacter.DrawableVariations[numId] = {
                    drawable = drawable,
                    texture = texture
                }
            end
        end
    end

    if charData.PropVariations and charData.PropVariations.props then
        local props = charData.PropVariations.props
        for _, propId in ipairs({ 0, 1, 2, 6, 7 }) do
            local strId = tostring(propId)
            local propData = props[strId] or props[propId]
            if propData then
                local drawable = propData.Key or propData.drawable or -1
                local texture = propData.Value or propData.texture or 0
                currentCharacter.PropVariations[propId] = { drawable = drawable, texture = texture }
            end
        end
    elseif charData.PropVariations then
        for propId, data in pairs(charData.PropVariations) do
            local numId = tonumber(propId)
            if numId and data then
                local drawable, texture
                if type(data) == "table" then
                    drawable = data.drawable or data.Key or -1
                    texture = data.texture or data.Value or 0
                else
                    drawable = data
                    texture = 0
                end
                currentCharacter.PropVariations[numId] = {
                    drawable = drawable,
                    texture = texture
                }
            end
        end
    end

    local tattoos = charData.PedTattoos or charData.PedTatttoos
    if tattoos then
        local function convertTattooList(list)
            if not list then return {} end
            local result = {}
            for _, tattoo in ipairs(list) do
                if tattoo.Key and tattoo.Value then
                    table.insert(result, { collection = tattoo.Key, name = tattoo.Value })
                elseif tattoo.collection and tattoo.name then
                    table.insert(result, tattoo)
                end
            end
            return result
        end

        currentCharacter.PedTattoos.HeadTattoos = convertTattooList(tattoos.HeadTattoos)
        currentCharacter.PedTattoos.TorsoTattoos = convertTattooList(tattoos.TorsoTattoos)
        currentCharacter.PedTattoos.LeftArmTattoos = convertTattooList(tattoos.LeftArmTattoos)
        currentCharacter.PedTattoos.RightArmTattoos = convertTattooList(tattoos.RightArmTattoos)
        currentCharacter.PedTattoos.LeftLegTattoos = convertTattooList(tattoos.LeftLegTattoos)
        currentCharacter.PedTattoos.RightLegTattoos = convertTattooList(tattoos.RightLegTattoos)
        currentCharacter.PedTattoos.BadgeTattoos = convertTattooList(tattoos.BadgeTattoos)
    end

    local modelHash = currentCharacter.ModelHash

    RequestModel(modelHash)
    local loadStart = GetGameTimer()
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() - loadStart > 5000 then
            Notify.Error("Failed to load character model.")
            return
        end
        Wait(0)
    end

    local coords = GetEntityCoords(PlayerPedId())

    local _savedWeapons2 = {}
    local _currentWeapon2 = GetCurrentPedWeapon(PlayerPedId(), true)
    for _, w in ipairs(ValidWeapon.WeaponList) do
        local hash = GetHashKey(w.Name)
        if HasPedGotWeapon(PlayerPedId(), hash, false) then
            _savedWeapons2[#_savedWeapons2 + 1] = { hash = hash, ammo = GetAmmoInPedWeapon(PlayerPedId(), hash), tint = GetPedWeaponTintIndex(PlayerPedId(), hash), current = (hash == _currentWeapon2) }
        end
    end

    SetPlayerModel(PlayerId(), modelHash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(modelHash)

    for _, w in ipairs(_savedWeapons2) do
        GiveWeaponToPed(PlayerPedId(), w.hash, w.ammo, false, false)
        SetPedWeaponTintIndex(PlayerPedId(), w.hash, w.tint)
    end
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

    local ped = PlayerPedId()
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    FreezeEntityPosition(ped, true)

    MpPedCustomizationMenu.ApplyCharacterData()

    CameraManager.DeactivateCamera()
    local ped = PlayerPedId()
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)

    Notify.Success("Loaded character: ~y~" .. currentCharacter.SaveName)
end

function MpPedCustomizationMenu.RestorePlayerModel()
    isEditingCharacter = false
    editingKvpKey = nil
    editingDisplayName = nil

    CameraManager.DeactivateCamera()

    local ped = PlayerPedId()
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)

    Notify.Info("Exited character creator.")
end

function MpPedCustomizationMenu.GetMenu()
    if menu == nil then
        MpPedCustomizationMenu.CreateMenu()
    end
    return menu
end

return MpPedCustomizationMenu
