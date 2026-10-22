(function()
MenuSliderItem = setmetatable({}, {__index = MenuItem})
MenuSliderItem.__index = MenuSliderItem

function MenuSliderItem:New(text, description, min, max, startPosition, showDivider)
    local self = setmetatable(MenuItem:New(text, description), MenuSliderItem)

    self.Min = min or 0
    self.Max = max or 10
    self.Position = startPosition or 0
    self.ShowDivider = showDivider or false
    self.SliderLeftIcon = Icon.NONE
    self.SliderRightIcon = Icon.NONE

    self.BackgroundColor = {24, 93, 151, 255}
    self.BarColor = {53, 165, 223, 255}

    return self
end

function MenuSliderItem:Draw(indexOffset)
    self.LeftIcon = Icon.NONE
    self.RightIcon = self.SliderRightIcon
    self.Label = nil

    MenuItem.Draw(self, indexOffset)

    if self.Position > self.Max or self.Position < self.Min then
        self.Position = math.floor((self.Max - self.Min) / 2)
    end

    local yOffset = self.ParentMenu.MenuItemsYOffset - (MenuItem.ROW_HEIGHT * MathUtil.Clamp(self.ParentMenu:Size(), 0, self.ParentMenu.MaxItemsOnScreen))

    local width = 150.0 / MenuController.ScreenWidth
    local height = 10.0 / MenuController.ScreenHeight
    local y = (self.ParentMenu.Position.y + ((self:GetIndex() - indexOffset - 1) * MenuItem.ROW_HEIGHT) + (MenuItem.ROW_HEIGHT / 2.0) + yOffset) / MenuController.ScreenHeight
    local x = (self.ParentMenu.Position.x + MenuItem.WIDTH) / MenuController.ScreenWidth - (width / 2.0) - (8.0 / MenuController.ScreenWidth)

    if not self.ParentMenu.LeftAligned then
        x = (width / 2.0) - (8.0 / MenuController.ScreenWidth)
    end

    if self.SliderLeftIcon ~= Icon.NONE and self.SliderRightIcon ~= Icon.NONE then
        x = x - (40.0 / MenuController.ScreenWidth)

        local leftColor = Icon.GetColor(self.SliderLeftIcon, self:UsesDarkGlyphs(), self.Enabled)

        SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
        SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

        local spriteDict = Icon.GetDictionary(self.SliderLeftIcon)
        local spriteName = Icon.GetSpriteName(self.SliderLeftIcon, self:UsesDarkGlyphs())
        local spriteSize = Icon.GetSize(self.SliderLeftIcon, MenuController.ScreenWidth, MenuController.ScreenHeight)

        if self.ParentMenu.LeftAligned then
            DrawSprite(spriteDict, spriteName,
                x - (width / 2.0 + (4.0 / MenuController.ScreenWidth)) - (spriteSize[1] / 2.0),
                y, spriteSize[1], spriteSize[2], 0.0, leftColor[1], leftColor[2], leftColor[3], 255)
        else
            DrawSprite(spriteDict, spriteName,
                x - (width + (4.0 / MenuController.ScreenWidth)) - spriteSize[1] - (20.0 / MenuController.ScreenWidth),
                y, spriteSize[1], spriteSize[2], 0.0, leftColor[1], leftColor[2], leftColor[3], 255)
        end

        ResetScriptGfxAlign()
    end

    SetScriptGfxAlign(self.ParentMenu.LeftAligned and 76 or 82, 84)
    SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

    DrawRect(x, y, width, height, self.BackgroundColor[1], self.BackgroundColor[2], self.BackgroundColor[3], self.BackgroundColor[4])

    local xOffset = MathUtil.Map(
        self.Position,
        self.Min,
        self.Max,
        -((width / 4.0) * MenuController.ScreenWidth),
        (width / 4.0) * MenuController.ScreenWidth
    )
    xOffset = xOffset / MenuController.ScreenWidth

    if not self.ParentMenu.LeftAligned then
        DrawRect(x - (width / 2.0) + xOffset, y, width / 2.0, height, self.BarColor[1], self.BarColor[2], self.BarColor[3], self.BarColor[4])
    else
        DrawRect(x + xOffset, y, width / 2.0, height, self.BarColor[1], self.BarColor[2], self.BarColor[3], self.BarColor[4])
    end

    if self.ShowDivider then
        if not self.ParentMenu.LeftAligned then
            DrawRect(x - width + (4.0 / MenuController.ScreenWidth), y, 4.0 / MenuController.ScreenWidth, MenuItem.ROW_HEIGHT / MenuController.ScreenHeight / 2.0, 255, 255, 255, 255)
        else
            DrawRect(x + (2.0 / MenuController.ScreenWidth), y, 4.0 / MenuController.ScreenWidth, MenuItem.ROW_HEIGHT / MenuController.ScreenHeight / 2.0, 255, 255, 255, 255)
        end
    end

    ResetScriptGfxAlign()
end

function MenuSliderItem:GoRight()
    if self.Position < self.Max then
        local oldPosition = self.Position
        self.Position = self.Position + 1
        self.ParentMenu:SliderItemChangedEvent(self.ParentMenu, self, oldPosition, self.Position, self:GetIndex())
        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    else
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end
end

function MenuSliderItem:GoLeft()
    if self.Position > self.Min then
        local oldPosition = self.Position
        self.Position = self.Position - 1
        self.ParentMenu:SliderItemChangedEvent(self.ParentMenu, self, oldPosition, self.Position, self:GetIndex())
        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    else
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end
end

function MenuSliderItem:Select()
    self.ParentMenu:SliderSelectedEvent(self.ParentMenu, self, self.Position, self:GetIndex())
end

return MenuSliderItem
end)()
