Control = {
    FrontendAccept = 201,
    FrontendCancel = 202,
    FrontendPause = 199,
    FrontendPauseAlternate = 200,

    FrontendUp = 188,
    FrontendDown = 187,
    FrontendLeft = 189,
    FrontendRight = 190,

    PhoneCancel = 177,
    PhoneScrollBackward = 241,
    PhoneScrollForward = 242,

    InteractionMenu = 244,

    SelectWeapon = 37,
    SelectNextWeapon = 14,
    SelectPrevWeapon = 15,

    Attack = 24,
    Attack2 = 25,
    VehicleMouseControlOverride = 348,

    MultiplayerInfo = 20,

    LookLeftRight = 1,
    LookUpDown = 2,
    LookBehind = 26,

    MoveUpDown = 31,
    MoveLeftRight = 30,

    Phone = 27,
    PhoneDown = 173,
    PhoneLeft = 174,
    PhoneRight = 175,

    MeleeAttack1 = 140,
    MeleeAttack2 = 141,
    MeleeAttackAlternate = 263,
    MeleeAttackHeavy = 264,
    MeleeAttackLight = 140,
    Aim = 25,
    VehicleAttack = 69,
    VehicleAttack2 = 68,
    VehicleAim = 68,
    VehicleFlyAttack = 114,
    VehiclePassengerAttack = 142,

    VehicleSelectNextWeapon = 99,
    VehicleSelectPrevWeapon = 100,
    VehicleCinCam = 80,
    VehicleHeadlight = 74,
    VehicleDuck = 73,
    VehicleFlyTransform = 135,
    VehicleNextRadio = 81,
    VehiclePrevRadio = 82,
    VehicleRadioWheel = 85,

    RadioWheelLeftRight = 243,
    RadioWheelUpDown = 244,
}

function Control.IsJustPressed(control)
    return IsControlJustPressed(0, control) or IsDisabledControlJustPressed(0, control)
end

function Control.IsJustReleased(control)
    return IsControlJustReleased(0, control) or IsDisabledControlJustReleased(0, control)
end

function Control.IsPressed(control)
    return IsControlPressed(0, control) or IsDisabledControlPressed(0, control)
end

function Control.DisableThisFrame(control)
    DisableControlAction(0, control, true)
end

function Control.DisableAllThisFrame()
    DisableAllControlActions(0)
end

return Control
