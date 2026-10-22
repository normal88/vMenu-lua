(function()
MenuCheckboxItem = setmetatable({}, { __index = MenuItem })
MenuCheckboxItem.__index = MenuCheckboxItem

MenuCheckboxItem.CheckboxStyle = {
    Cross = 0,
    Tick = 1
}

function MenuCheckboxItem:New(text, description, checked)
    local self = setmetatable(MenuItem:New(text, description), MenuCheckboxItem)

    self.Checked = checked or false
    self.Style = MenuCheckboxItem.CheckboxStyle.Tick

    return self
end

function MenuCheckboxItem:GetSpriteColour()
    return self.Enabled and 255 or 109
end

function MenuCheckboxItem:GetSpriteName()
    if self.Checked then
        if self.Style == MenuCheckboxItem.CheckboxStyle.Tick then
            return self:UsesDarkGlyphs() and "shop_box_tickb" or "shop_box_tick"
        else
            return self:UsesDarkGlyphs() and "shop_box_crossb" or "shop_box_cross"
        end
    else
        return self:UsesDarkGlyphs() and "shop_box_blankb" or "shop_box_blank"
    end
end

function MenuCheckboxItem:GetSpriteX()
    local leftSide = false
    local leftAligned = self.ParentMenu.LeftAligned

    if leftSide then
        if leftAligned then
            return 20.0 / MenuController.ScreenWidth
        else
            return (MenuItem.WIDTH - 20.0) / MenuController.ScreenWidth
        end
    else
        if leftAligned then
            return (MenuItem.WIDTH - 20.0) / MenuController.ScreenWidth
        else
            return 20.0 / MenuController.ScreenWidth
        end
    end
end

function MenuCheckboxItem:Draw(indexOffset)
    self.RightIcon = Icon.NONE
    self.Label = nil

    MenuItem.Draw(self, indexOffset)

    SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
    SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

    local yOffset = self.ParentMenu.MenuItemsYOffset -
        (MenuItem.ROW_HEIGHT * MathUtil.Clamp(self.ParentMenu:Size(), 0, self.ParentMenu.MaxItemsOnScreen))
    local spriteName = self:GetSpriteName()
    local spriteY = (self.ParentMenu.Position.y + ((self:GetIndex() - indexOffset - 1) * MenuItem.ROW_HEIGHT) + (MenuItem.ROW_HEIGHT / 2.0) + yOffset) /
        MenuController.ScreenHeight
    local spriteX = self:GetSpriteX()
    local spriteHeight = 45.0 / MenuController.ScreenHeight
    local spriteWidth = 45.0 / MenuController.ScreenWidth
    local color = self:GetSpriteColour()

    DrawSprite("commonmenu", spriteName, spriteX, spriteY, spriteWidth, spriteHeight, 0.0, color, color, color, 255)

    ResetScriptGfxAlign()
end

function MenuCheckboxItem:GoRight()
    self.ParentMenu:SelectItem(self)
end

function MenuCheckboxItem:Select()
    self.Checked = not self.Checked
    self.ParentMenu:CheckboxChangedEvent(self, self:GetIndex(), self.Checked)
end

return MenuCheckboxItem
end)()
