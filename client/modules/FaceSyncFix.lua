FaceSyncFix = {}

local snapshot        = nil
local pulseUntil      = 0
local fixInProgress   = false

local MALE_MODEL      = `mp_m_freemode_01`
local FEMALE_MODEL    = `mp_f_freemode_01`

local FINALIZE_BLEND  = 0x4668D80430D6C299

local OVERLAYS = {
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
    { index = 11, style = "bodyBlemishesStyle", opacity = "bodyBlemishesOpacity" },
}

local function IsMPPed(ped)
    local model = GetEntityModel(ped)
    return model == MALE_MODEL or model == FEMALE_MODEL
end

local function RandomDifferentValue(original, min, max)
    local v = math.random(min, max)
    if v == original then
        v = (v < max) and (v + 1) or min
    end
    return v
end

local function CaptureSnapshot(character)
    if not character then return nil end
    local blend = character.PedHeadBlendData or {}
    local app = character.PedAppearance or {}
    local snap = {
        blend = {
            FirstFaceShape         = blend.FirstFaceShape         or 0,
            SecondFaceShape        = blend.SecondFaceShape        or 0,
            ThirdFaceShape         = blend.ThirdFaceShape         or 0,
            FirstSkinTone          = blend.FirstSkinTone          or 0,
            SecondSkinTone         = blend.SecondSkinTone         or 0,
            ThirdSkinTone          = blend.ThirdSkinTone          or 0,
            ParentFaceShapePercent = blend.ParentFaceShapePercent or 0.5,
            ParentSkinTonePercent  = blend.ParentSkinTonePercent  or 0.5,
        },
        appearance = {},
        features = {},
        eyeColor = app.eyeColor or 0,
        hairStyle = app.hairStyle or 0,
        hairColor = app.hairColor or 0,
        hairHighlight = app.hairHighlightColor or 0,
    }
    for k, v in pairs(app) do snap.appearance[k] = v end
    for i = 0, 19 do
        snap.features[i] = (character.FaceShapeFeatures and character.FaceShapeFeatures[i]) or 0.0
    end
    return snap
end

local function ApplyBlend(ped, b)
    SetPedHeadBlendData(ped,
        (b.FirstFaceShape or 0) + 0,
        (b.SecondFaceShape or 0) + 0,
        (b.ThirdFaceShape or 0) + 0,
        (b.FirstSkinTone or 0) + 0,
        (b.SecondSkinTone or 0) + 0,
        (b.ThirdSkinTone or 0) + 0,
        (b.ParentFaceShapePercent or 0.5) + 0.0,
        (b.ParentSkinTonePercent or 0.5) + 0.0,
        0.0 + 0.0,
        false
    )
    Citizen.InvokeNative(FINALIZE_BLEND, ped)
end

local function ReapplySnapshot(ped, snap)
    if not snap then return end
    ApplyBlend(ped, snap.blend)

    for i = 0, 19 do
        SetPedFaceFeature(ped, i, (snap.features[i] or 0.0) + 0.0)
    end

    SetPedEyeColor(ped, snap.eyeColor or 0)

    SetPedHairColor(ped, snap.hairColor or 0, snap.hairHighlight or 0)

    local app = snap.appearance
    for _, ov in ipairs(OVERLAYS) do
        local style = app[ov.style]
        local opacity = app[ov.opacity] or 1.0
        if style and style ~= 255 then
            SetPedHeadOverlay(ped, ov.index, style, opacity + 0.0)
            if ov.color then
                local c = app[ov.color] or 0
                SetPedHeadOverlayColor(ped, ov.index, ov.colorType, c, c)
            end
        else
            SetPedHeadOverlay(ped, ov.index, 255, 0.0)
        end
    end

    Citizen.InvokeNative(FINALIZE_BLEND, ped)
end

function FaceSyncFix.Store(blend)
    if not blend then return end
    if not snapshot then snapshot = { blend = {}, appearance = {}, features = {} } end
    snapshot.blend = {
        FirstFaceShape         = blend.FirstFaceShape         or 0,
        SecondFaceShape        = blend.SecondFaceShape        or 0,
        ThirdFaceShape         = blend.ThirdFaceShape         or 0,
        FirstSkinTone          = blend.FirstSkinTone          or 0,
        SecondSkinTone         = blend.SecondSkinTone         or 0,
        ThirdSkinTone          = blend.ThirdSkinTone          or 0,
        ParentFaceShapePercent = blend.ParentFaceShapePercent or 0.5,
        ParentSkinTonePercent  = blend.ParentSkinTonePercent  or 0.5,
    }
end

function FaceSyncFix.StoreFull(character)
    local snap = CaptureSnapshot(character)
    if not snap then return end
    snapshot = snap
    pulseUntil = GetGameTimer() + 60000
end

Citizen.CreateThread(function()
    while true do
        if snapshot and GetGameTimer() < pulseUntil then
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and IsMPPed(ped) then
                ReapplySnapshot(ped, snapshot)
            end
            Wait(4000)
        else
            Wait(1000)
        end
    end
end)

AddEventHandler("playerSpawned", function()
    if fixInProgress then return end
    if not snapshot then return end

    fixInProgress = true
    SetTimeout(12000, function() fixInProgress = false end)

    Citizen.CreateThread(function()
        Wait(5000)

        local ped = PlayerPedId()
        if not DoesEntityExist(ped) or not IsMPPed(ped) then
            fixInProgress = false
            return
        end

        local b = snapshot.blend
        local rDad = RandomDifferentValue(b.FirstFaceShape, 0, 45)
        local rMom = RandomDifferentValue(b.SecondFaceShape, 0, 45)
        SetPedHeadBlendData(ped,
            rDad, rMom, 0,
            rDad, rMom, 0,
            0.5, 0.5, 0.0, false
        )
        Citizen.InvokeNative(FINALIZE_BLEND, ped)

        Wait(200)

        if PlayerPedId() ~= ped or not DoesEntityExist(ped) or not IsMPPed(ped) then
            fixInProgress = false
            return
        end

        ReapplySnapshot(ped, snapshot)

        pulseUntil = GetGameTimer() + 60000

        fixInProgress = false
    end)
end)

_G.FaceSyncFix = FaceSyncFix
