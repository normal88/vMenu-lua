(function()

MenuItem = {}
MenuItem.__index = MenuItem

MenuItem.ITEM_TEXT_X_OFFSET = 0.0
MenuItem.LABEL_X_OFFSET = 0.0

MenuItem.RIGHT_ITEM_TEXT_X_OFFSET = -12.0
MenuItem.RIGHT_LABEL_X_OFFSET = 17.0

MenuItem.WIDTH = 500.0
MenuItem.ROW_HEIGHT = 38.0

function MenuItem:New(text, description)
    local self = setmetatable({}, MenuItem)

    self.Text = text or "N/A"
    self.Label = nil
    self.Description = description
    self.LeftIcon = Icon.NONE
    self.RightIcon = Icon.NONE
    self.Enabled = true
    self.ItemData = nil
    self.ParentMenu = nil
    self.PositionOnScreen = 0

    return self
end

function MenuItem:GetIndex()
    if self.ParentMenu then
        for i, item in ipairs(self.ParentMenu:GetMenuItems()) do
            if item == self then
                return i
            end
        end
    end
    return -1
end

function MenuItem:IsSelected()
    if self.ParentMenu then
        return self.ParentMenu.CurrentIndex == self:GetIndex()
    end
    return false
end

function MenuItem:UsesDarkGlyphs()
    return self:IsSelected() and Theme.Colors().lightHighlight
end

function MenuItem:GetSafeZoneSize()
    local safeZone = GetSafeZoneSize()
    local aspectRatio = GetAspectRatio(false)
    local resolution = 1080.0 * aspectRatio
    return 1.0 / resolution / safeZone
end

function MenuItem:GetSpriteX(icon, leftAligned, leftSide)
    if icon == Icon.NONE then
        return 0.0
    end

    local screenWidth = MenuController.ScreenWidth

    if leftSide then
        if leftAligned then
            return 20.0 / screenWidth
        else
            return (MenuItem.WIDTH - 20.0) / screenWidth
        end
    else
        if leftAligned then
            return (MenuItem.WIDTH - 20.0) / screenWidth
        else
            return 20.0 / screenWidth
        end
    end
end

function MenuItem:DrawBackground(indexOffset, yOffset)
    local x = (self.ParentMenu.Position.x + (MenuItem.WIDTH / 2.0)) / MenuController.ScreenWidth
    local y = (self.ParentMenu.Position.y + ((self:GetIndex() - indexOffset - 1) * MenuItem.ROW_HEIGHT) + (MenuItem.ROW_HEIGHT / 2.0) + yOffset) /
        MenuController.ScreenHeight

    if self:IsSelected() then
        local width = MenuItem.WIDTH / MenuController.ScreenWidth
        local height = MenuItem.ROW_HEIGHT / MenuController.ScreenHeight

        local colors = Theme.Colors()
        local row = colors.selectedRow
        SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
        SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)
        DrawRect(x, y, width, height, row[1], row[2], row[3], row[4])
        if colors.accent then
            local accent = colors.accent
            local lineHeight = 2.0 / MenuController.ScreenHeight
            DrawRect(x, y + (height / 2.0) - (lineHeight / 2.0), width, lineHeight,
                accent[1], accent[2], accent[3], accent[4])
        end
        ResetScriptGfxAlign()
    end

    return x, y
end

function MenuItem:DrawLeftIcon(textXOffset, y)
    if self.LeftIcon == Icon.NONE then
        return textXOffset
    end

    textXOffset = 25.0

    SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
    SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

    local spriteName = Icon.GetSpriteName(self.LeftIcon, self:UsesDarkGlyphs())
    local spriteDict = Icon.GetDictionary(self.LeftIcon)
    local spriteX = self:GetSpriteX(self.LeftIcon, self.ParentMenu.LeftAligned, true)
    local spriteY = y
    local spriteSize = Icon.GetSize(self.LeftIcon, MenuController.ScreenWidth, MenuController.ScreenHeight)
    local spriteWidth = spriteSize[1]
    local spriteHeight = spriteSize[2]
    local spriteColor = Icon.GetColor(self.LeftIcon, self:UsesDarkGlyphs(), self.Enabled)

    DrawSprite(spriteDict, spriteName, spriteX, spriteY, spriteWidth, spriteHeight, 0.0, spriteColor[1], spriteColor[2],
        spriteColor[3], 255)

    ResetScriptGfxAlign()

    return textXOffset
end

function MenuItem:DrawRightIcon(rightTextIconOffset, y, iconOverride)
    local iconToDraw = iconOverride or self.RightIcon
    if iconToDraw == Icon.NONE then
        return rightTextIconOffset
    end

    rightTextIconOffset = 25.0

    SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
    SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

    local spriteName = Icon.GetSpriteName(iconToDraw, self:UsesDarkGlyphs())
    local spriteDict = Icon.GetDictionary(iconToDraw)
    local spriteX = self:GetSpriteX(iconToDraw, self.ParentMenu.LeftAligned, false)
    local spriteY = y
    local spriteSize = Icon.GetSize(iconToDraw, MenuController.ScreenWidth, MenuController.ScreenHeight)
    local spriteWidth = spriteSize[1]
    local spriteHeight = spriteSize[2]
    local spriteColor = Icon.GetColor(iconToDraw, self:UsesDarkGlyphs(), self.Enabled)

    DrawSprite(spriteDict, spriteName, spriteX, spriteY, spriteWidth, spriteHeight, 0.0, spriteColor[1], spriteColor[2],
        spriteColor[3], 255)

    ResetScriptGfxAlign()

    return rightTextIconOffset
end

function MenuItem:DrawLabelText(textXOffset, rightTextIconOffset, y, font, textSize, textColor, textY)
    if not self.Label or self.Label == "" then
        return
    end

    SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
    SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

    local label, labelFont, scaleMul = Locale.Display(self.Label, font)
    BeginTextCommandDisplayText("STRING")
    SetTextFont(labelFont)
    SetTextScale(textSize * scaleMul, textSize * scaleMul)
    SetTextJustification(2)
    AddTextComponentSubstringPlayerName(label)

    SetTextColour(textColor, textColor, textColor, 255)

    local labelOffset = self.ParentMenu.LeftAligned and MenuItem.LABEL_X_OFFSET or MenuItem.RIGHT_LABEL_X_OFFSET

    if self.ParentMenu.LeftAligned then
        local labelX = (MenuItem.WIDTH - 10.0 - rightTextIconOffset + labelOffset) / MenuController.ScreenWidth
        SetTextWrap(0.0, labelX)
        EndTextCommandDisplayText(labelX, textY)
    else
        local labelX = (10.0 + rightTextIconOffset - labelOffset) / MenuController.ScreenWidth
        local wrapMin = labelX
        local wrapMax = (MenuItem.WIDTH - 10.0) / MenuController.ScreenWidth
        SetTextWrap(wrapMin, wrapMax)
        EndTextCommandDisplayText(labelX, textY)
    end

    ResetScriptGfxAlign()
end

function MenuItem:DrawItemText(font, textSize, textColor, textMinX, textMaxX, textY, textXOffset, y)
    SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
    SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)
    local text, textFont, scaleMul = Locale.Display(self.Text or "N/A", font)
    SetTextFont(textFont)
    SetTextScale(textSize * scaleMul, textSize * scaleMul)
    SetTextJustification(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)

    SetTextColour(textColor, textColor, textColor, 255)

    local itemTextOffset = self.ParentMenu.LeftAligned and MenuItem.ITEM_TEXT_X_OFFSET or
    MenuItem.RIGHT_ITEM_TEXT_X_OFFSET

    local adjustedTextMinX = textMinX + (itemTextOffset / MenuController.ScreenWidth)
    SetTextWrap(adjustedTextMinX, textMaxX)
    EndTextCommandDisplayText(adjustedTextMinX, textY)

    ResetScriptGfxAlign()
end

function MenuItem:Draw(indexOffset)
    if not self.ParentMenu then
        return
    end

    local font = 0
    local textSize = (14.0 * 27.0) / MenuController.ScreenHeight
    local colors = Theme.Colors()
    local textColor
    if self:IsSelected() then
        textColor = self.Enabled and colors.selectedText or colors.selectedDisabledText
    else
        textColor = self.Enabled and colors.text or colors.disabledText
    end

    local yOffset = self.ParentMenu.MenuItemsYOffset -
        (MenuItem.ROW_HEIGHT * MathUtil.Clamp(self.ParentMenu:Size(), 0, self.ParentMenu.MaxItemsOnScreen))
    local textXOffset = 0.0
    local rightTextIconOffset = 0.0

    local x, y = self:DrawBackground(indexOffset, yOffset)

    local textMinX = (textXOffset / MenuController.ScreenWidth) + (10.0 / MenuController.ScreenWidth)
    local textMaxX = (MenuItem.WIDTH - 10.0) / MenuController.ScreenWidth
    local textY = y - ((30.0 / 2.0) / MenuController.ScreenHeight)

    textXOffset = self:DrawLeftIcon(textXOffset, y)
    rightTextIconOffset = self:DrawRightIcon(rightTextIconOffset, y)

    self:DrawLabelText(textXOffset, rightTextIconOffset, y, font, textSize, textColor, textY)
    self:DrawItemText(font, textSize, textColor, textMinX, textMaxX, textY, textXOffset, y)
end

function MenuItem:GoRight()
    if self.Enabled then
        self.ParentMenu:SelectItem(self)
    end
end

function MenuItem:GoLeft()
    if MenuController.NavigateMenuUsingArrows and not MenuController.DisableBackButton and
        not (MenuController.PreventExitingMenu and self.ParentMenu.ParentMenu == nil) then
        self.ParentMenu:GoBack()
    end
end

function MenuItem:Select()
    self.ParentMenu:ItemSelectedEvent(self, self:GetIndex())
end

return MenuItem
end)()
