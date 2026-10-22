(function()
    Menu = {}
    Menu.__index = Menu

    Menu.WIDTH = 500.0
    Menu.HEADER_HEIGHT = 110.0

    Menu.TITLE_X_OFFSET = 0.0
    Menu.TITLE_Y_OFFSET = 0.0
    Menu.SUBTITLE_X_OFFSET = 0.0
    Menu.SUBTITLE_Y_OFFSET = 0.0

    Menu.RIGHT_TITLE_X_OFFSET = 30.0
    Menu.RIGHT_TITLE_Y_OFFSET = 0.0
    Menu.RIGHT_SUBTITLE_X_OFFSET = 30.0
    Menu.RIGHT_SUBTITLE_Y_OFFSET = 0.0

    Menu.COUNTER_X_OFFSET = 0.0
    Menu.COUNTER_Y_OFFSET = 0.0
    Menu.RIGHT_COUNTER_X_OFFSET = 0.0
    Menu.RIGHT_COUNTER_Y_OFFSET = 0.0

    function Menu:New(title, subtitle)
        local self = setmetatable({}, Menu)

        self.MenuTitle = title or "Menu"
        self.MenuSubtitle = subtitle or ""
        self.HeaderTexture = { dict = nil, name = nil }
        self.ParentMenu = nil
        self.IgnoreDontOpenMenus = false
        self.MaxItemsOnScreen = 10
        self.EnableInstructionalButtons = true
        self.CounterPreText = nil

        self.Position = { x = 0.0, y = 0.0 }
        self.MenuItemsYOffset = 0.0

        self.ShowWeaponStatsPanel = false
        self.ShowVehicleStatsPanel = false
        self.WeaponStats = { 0.0, 0.0, 0.0, 0.0 }
        self.WeaponComponentStats = { 0.0, 0.0, 0.0, 0.0 }
        self.VehicleStats = { 0.0, 0.0, 0.0, 0.0 }
        self.VehicleUpgradeStats = { 0.0, 0.0, 0.0, 0.0 }

        self._menuItems = {}
        self._filterItems = {}
        self._filterActive = false
        self._currentIndex = 1
        self._viewIndexOffset = 0
        self._visible = false

        self._colorPanelScaleform = RequestScaleformMovie("COLOUR_SWITCHER_02")
        self._descriptionYEnd = 0.0

        self.LeftAligned = true

        self.CurrentIndex = 1

        self.OnItemSelect = nil
        self.OnCheckboxChange = nil
        self.OnListItemSelect = nil
        self.OnListIndexChange = nil
        self.OnMenuClose = nil
        self.OnMenuOpen = nil
        self.OnIndexChange = nil
        self.OnSliderPositionChange = nil
        self.OnSliderItemSelect = nil
        self.OnDynamicListItemCurrentItemChange = nil
        self.OnDynamicListItemSelect = nil

        return self
    end

    function Menu:GetSafeZoneSize()
        local safeZone = GetSafeZoneSize()
        local aspectRatio = GetAspectRatio(false)
        local resolution = 1080.0 * aspectRatio
        return 1.0 / resolution / safeZone
    end

    function Menu:GetTextScaleHeight(size, font)
        return size
    end

    function Menu:Size()
        return self._filterActive and #self._filterItems or #self._menuItems
    end

    function Menu:GetMenuItems()
        return self._filterActive and self._filterItems or self._menuItems
    end

    function Menu:AddMenuItem(item)
        item.ParentMenu = self
        table.insert(self._menuItems, item)
    end

    function Menu:RemoveMenuItem(item)
        for i, menuItem in ipairs(self._menuItems) do
            if menuItem == item then
                table.remove(self._menuItems, i)
                break
            end
        end
    end

    function Menu:RemoveMenuItemAt(index)
        table.remove(self._menuItems, index)
    end

    function Menu:ClearMenuItems()
        self._menuItems = {}
        self._filterItems = {}
        self._currentIndex = 1
        self._viewIndexOffset = 0
        self.CurrentIndex = 1
    end

    function Menu:GetCurrentIndex()
        return self._currentIndex
    end

    function Menu:SetCurrentIndex(index)
        local oldIndex = self._currentIndex
        local newIndex = MathUtil.Clamp(index, 1, math.max(1, self:Size()))

        if oldIndex ~= newIndex then
            local oldItem = self:GetMenuItems()[oldIndex]
            local newItem = self:GetMenuItems()[newIndex]

            self._currentIndex = newIndex
            self.CurrentIndex = newIndex
            self:UpdateViewIndexOffset()
            self:IndexChangeEvent(self, oldItem, newItem, oldIndex, newIndex)
        end
    end

    function Menu:UpdateViewIndexOffset()
        if self:Size() <= self.MaxItemsOnScreen then
            self._viewIndexOffset = 0
        else
            if self._currentIndex < self._viewIndexOffset + 1 then
                self._viewIndexOffset = self._currentIndex - 1
            elseif self._currentIndex > self._viewIndexOffset + self.MaxItemsOnScreen then
                self._viewIndexOffset = self._currentIndex - self.MaxItemsOnScreen
            end
        end
    end

    function Menu:OpenMenu()
        if self._visible and not MenuController.VisibleMenus[self] then
            self._visible = false
        end
        if not self._visible then
            self._visible = true
            MenuController:AddVisibleMenu(self)
            self.LeftAligned = MenuController:GetMenuAlignment() == "left"
            self:MenuOpenEvent(self)
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end

    function Menu:CloseMenu()
        if self._visible then
            self._visible = false
            MenuController:RemoveVisibleMenu(self)
            self:MenuCloseEvent(self)
            PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end

    function Menu:IsVisible()
        return self._visible
    end

    function Menu:GoBack()
        self:CloseMenu()
        if self.ParentMenu then
            self.ParentMenu:OpenMenu()
        end
    end

    function Menu:GoUp()
        local size = self:Size()
        if size == 0 then return end
        local newIndex = self._currentIndex - 1
        if newIndex < 1 then newIndex = size end
        local items = self:GetMenuItems()
        local checked = 0
        while items[newIndex] and not items[newIndex].Enabled and checked < size do
            newIndex = newIndex - 1
            if newIndex < 1 then newIndex = size end
            checked = checked + 1
        end
        self:SetCurrentIndex(newIndex)
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end

    function Menu:GoDown()
        local size = self:Size()
        if size == 0 then return end
        local newIndex = self._currentIndex + 1
        if newIndex > size then newIndex = 1 end
        local items = self:GetMenuItems()
        local checked = 0
        while items[newIndex] and not items[newIndex].Enabled and checked < size do
            newIndex = newIndex + 1
            if newIndex > size then newIndex = 1 end
            checked = checked + 1
        end
        self:SetCurrentIndex(newIndex)
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end

    function Menu:SelectItem(index)
        local item = nil

        if type(index) == "number" then
            self:SetCurrentIndex(index)
            item = self:GetMenuItems()[self._currentIndex]
        elseif type(index) == "table" then
            item = index
        else
            item = self:GetMenuItems()[self._currentIndex]
        end

        if item and item.Enabled then
            item:Select()

            if MenuController.MenuButtons[item] then
                local submenu = MenuController.MenuButtons[item]
                self:CloseMenu()
                submenu:OpenMenu()
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
            end
        else
            PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end

    function Menu:GoLeft()
        local item = self:GetMenuItems()[self._currentIndex]
        if item then
            item:GoLeft()
        end
    end

    function Menu:GoRight()
        local item = self:GetMenuItems()[self._currentIndex]
        if item then
            item:GoRight()
        end
    end

    function Menu:Draw()
        if not self._visible then
            return
        end

        if MenuController.SetDrawOrder then
            SetScriptGfxDrawOrder(1)
        end

        self.MenuItemsYOffset = 0.0
        self:UpdatePosition()
        self:DrawHeader()
        self:DrawBackground()
        self:DrawItems()
        self:DrawDescription()
        self:DrawPanels()

        if MenuController.SetDrawOrder then
            SetScriptGfxDrawOrder(0)
        end
    end

    function Menu:UpdatePosition()
        self.LeftAligned = MenuController:GetMenuAlignment() == "left"

        if self.LeftAligned then
            self.Position.x = 0.0
        else
            local safeZone = GetSafeZoneSize()
            local aspectRatio = GetAspectRatio(false)
            local screenWidth = 1080.0 * aspectRatio
            self.Position.x = (1.0 / screenWidth / safeZone) - (Menu.WIDTH / screenWidth)
        end
    end

    Menu.SUBTITLE_BAR_HEIGHT = 37.0

    function Menu:ItemTextX()
        local offset = self.LeftAligned and MenuItem.ITEM_TEXT_X_OFFSET or MenuItem.RIGHT_ITEM_TEXT_X_OFFSET
        return (10.0 + offset) / MenuController.ScreenWidth
    end

    function Menu:DrawLeftText(text, font, scale, x, y, maxX)
        SetScriptGfxAlign(self.LeftAligned and 76 or 82, 84)
        SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)
        SetTextFont(font)
        SetTextScale(scale, scale)
        SetTextJustification(1)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        SetTextColour(255, 255, 255, 255)
        SetTextWrap(x, maxX)
        EndTextCommandDisplayText(x, y)
        ResetScriptGfxAlign()
    end

    function Menu:DrawHeader()
        local x = (self.Position.x + (Menu.WIDTH / 2.0)) / MenuController.ScreenWidth
        local y = (self.Position.y + (Menu.HEADER_HEIGHT / 2.0)) / MenuController.ScreenHeight
        local width = Menu.WIDTH / MenuController.ScreenWidth
        local height = Menu.HEADER_HEIGHT / MenuController.ScreenHeight

        SetScriptGfxAlign(self.LeftAligned and 76 or 82, 84)
        SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

        local customBanner = false
        if self.HeaderTexture.dict and self.HeaderTexture.name then
            DrawSprite(self.HeaderTexture.dict, self.HeaderTexture.name, x, y, width, height, 0.0, 255, 255, 255, 255)
        elseif Banner and Banner.IsReady() then
            DrawSprite(Banner.TXD, Banner.TEXTURE, x, y, width, height, 0.0, 255, 255, 255, 255)
            customBanner = true
        else
            DrawSprite(MenuController._texture_dict, MenuController._header_texture, x, y, width, height, 0.0, 255, 255,
                255,
                255)
        end

        local textX = x
        local menuLeftX = self.Position.x / MenuController.ScreenWidth
        if not self.LeftAligned then
            local safeZone = GetSafeZoneSize()
            local marginRight = (1.0 - safeZone) / 2.0
            local rightBound = 1.0 - marginRight
            local menuWidthNorm = Menu.WIDTH / MenuController.ScreenWidth
            textX = rightBound - (menuWidthNorm / 2.0)
            menuLeftX = rightBound - menuWidthNorm
        end

        local titleXOffset = self.LeftAligned and Menu.TITLE_X_OFFSET or Menu.RIGHT_TITLE_X_OFFSET
        local titleYOffset = self.LeftAligned and Menu.TITLE_Y_OFFSET or Menu.RIGHT_TITLE_Y_OFFSET
        local counterXOffset = self.LeftAligned and Menu.COUNTER_X_OFFSET or Menu.RIGHT_COUNTER_X_OFFSET
        local counterYOffset = self.LeftAligned and Menu.COUNTER_Y_OFFSET or Menu.RIGHT_COUNTER_Y_OFFSET

        local titleX = textX + (titleXOffset / MenuController.ScreenWidth)
        local titleY = (y - (Menu.HEADER_HEIGHT / 8.0) / MenuController.ScreenHeight) +
            (titleYOffset / MenuController.ScreenHeight) - 0.01

        if not customBanner or Banner.SHOW_TITLE then
            SetTextFont(1)
            SetTextScale(1.0, 1.0)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(true)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName("vMenu")
            EndTextCommandDisplayText(titleX, titleY)
        end

        local subtitleBarY = self.Position.y + Menu.HEADER_HEIGHT
        local hasSubtitle = self.MenuSubtitle and self.MenuSubtitle ~= ""

        if hasSubtitle then
            local barX = x
            local barY = (subtitleBarY + (Menu.SUBTITLE_BAR_HEIGHT / 2.0)) / MenuController.ScreenHeight
            local barWidth = width
            local barHeight = Menu.SUBTITLE_BAR_HEIGHT / MenuController.ScreenHeight

            local bar = Theme.Colors().subtitleBar
            DrawRect(barX, barY, barWidth, barHeight, bar[1], bar[2], bar[3], bar[4])

            local subtitleTextX = self:ItemTextX()
            local subtitleTextY = (subtitleBarY + 4.0) / MenuController.ScreenHeight

            local subtitle, subtitleFont, subtitleScale, subtitleArabic = Locale.Display(self.MenuSubtitle, 0)
            self:DrawLeftText(subtitleArabic and subtitle or Locale.Upper(subtitle), subtitleFont, 0.34 * subtitleScale,
                subtitleTextX, subtitleTextY, (self.Position.x + Menu.WIDTH - 10.0) / MenuController.ScreenWidth)
            SetScriptGfxAlign(self.LeftAligned and 76 or 82, 84)
            SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

            if self:Size() > 0 and (self.CounterPreText or self.MaxItemsOnScreen < self:Size()) then
                local counterText = (self.CounterPreText or "") .. self._currentIndex .. " / " .. self:Size()
                local counterX = (self.Position.x + Menu.WIDTH - 10.0 + counterXOffset) / MenuController.ScreenWidth
                local counterY = (subtitleBarY + 4.0) / MenuController.ScreenHeight +
                    (counterYOffset / MenuController.ScreenHeight)

                local counter, counterFont, counterScale, counterArabic = Locale.Display(counterText, 0)
                SetTextFont(counterFont)
                SetTextScale(0.34 * counterScale, 0.34 * counterScale)
                SetTextColour(255, 255, 255, 255)
                SetTextJustification(2)
                SetTextWrap(0.0, counterX)
                BeginTextCommandDisplayText("STRING")
                AddTextComponentSubstringPlayerName(counterArabic and counter or Locale.Upper(counter))
                EndTextCommandDisplayText(counterX, counterY)
            end
        end

        ResetScriptGfxAlign()

        self.MenuItemsYOffset = Menu.HEADER_HEIGHT + (hasSubtitle and Menu.SUBTITLE_BAR_HEIGHT or 0.0)
    end

    function Menu:DrawBackground()
        local visibleCount = math.min(self.MaxItemsOnScreen, self:Size())
        if visibleCount <= 0 then
            return
        end

        local bgHeight = (MenuItem.ROW_HEIGHT * visibleCount)
        local x = (self.Position.x + (Menu.WIDTH / 2.0)) / MenuController.ScreenWidth
        local y = (self.Position.y + self.MenuItemsYOffset + (bgHeight / 2.0)) / MenuController.ScreenHeight
        local width = Menu.WIDTH / MenuController.ScreenWidth
        local height = bgHeight / MenuController.ScreenHeight

        SetScriptGfxAlign(self.LeftAligned and 76 or 82, 84)
        SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)
        local bg = Theme.Colors().itemsBackground
        DrawRect(x, y, width, height, bg[1], bg[2], bg[3], bg[4])
        ResetScriptGfxAlign()

        self.MenuItemsYOffset = self.MenuItemsYOffset + (MenuItem.ROW_HEIGHT * visibleCount)
    end

    function Menu:DrawItems()
        local visibleCount = math.min(self.MaxItemsOnScreen, self:Size() - self._viewIndexOffset)

        for i = 1, visibleCount do
            local itemIndex = self._viewIndexOffset + i
            local item = self:GetMenuItems()[itemIndex]

            if item then
                item:Draw(self._viewIndexOffset)
            end
        end
    end

    function Menu:DrawDescription()
        local visibleCount = math.min(self.MaxItemsOnScreen, self:Size())
        local hasSubtitle = self.MenuSubtitle and self.MenuSubtitle ~= ""
        local topOffset = Menu.HEADER_HEIGHT + (hasSubtitle and Menu.SUBTITLE_BAR_HEIGHT or 0.0)
        local descYStart = self.Position.y + topOffset + (MenuItem.ROW_HEIGHT * visibleCount)
        local gap = 4.0
        descYStart = descYStart + gap

        self._descriptionYEnd = descYStart / MenuController.ScreenHeight

        local item = self:GetMenuItems()[self._currentIndex]
        if not item or not item.Description or item.Description == "" then
            return
        end

        local padding = 10.0
        local textPaddingTop = 8.0
        local textPaddingBottom = 10.0

        local textX = (self.Position.x + padding) / MenuController.ScreenWidth
        local textMaxX = (self.Position.x + Menu.WIDTH - padding) / MenuController.ScreenWidth

        local descText = Locale.Translate(item.Description)
        local descFont, descScale = 0, 0.30
        local descArabic = Locale.HasArabic(descText)
        if descArabic then
            descFont = Locale.GetArabicFont()
            descScale = 0.30 * Locale.FONT_SCALE
            descText = Locale.WrapShaped(descText, descFont, descScale, textMaxX - textX)
        end

        SetScriptGfxAlign(self.LeftAligned and 76 or 82, 84)
        SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)

        SetTextFont(descFont)
        SetTextScale(descScale, descScale)
        SetTextWrap(textX, textMaxX)
        BeginTextCommandLineCount("STRING")
        AddTextComponentSubstringPlayerName(descText)
        local wrappedLineCount = EndTextCommandGetLineCount(textX, (descYStart + textPaddingTop) / MenuController.ScreenHeight)

        local lineHeight = GetTextScaleHeight(descScale, descFont)
        local descHeight = textPaddingTop + (wrappedLineCount * lineHeight * MenuController.ScreenHeight) + textPaddingBottom

        local x = (self.Position.x + (Menu.WIDTH / 2.0)) / MenuController.ScreenWidth
        local bgY = (descYStart + (descHeight / 2.0)) / MenuController.ScreenHeight
        local width = Menu.WIDTH / MenuController.ScreenWidth
        local height = descHeight / MenuController.ScreenHeight

        local descBg = Theme.Colors().description
        DrawRect(x, bgY, width, height, descBg[1], descBg[2], descBg[3], descBg[4])

        local descTextY = (descYStart + textPaddingTop) / MenuController.ScreenHeight
        if descArabic then
            SetTextFont(descFont)
            SetTextScale(descScale, descScale)
            SetTextColour(255, 255, 255, 255)
            SetTextJustification(2)
            SetTextWrap(textX, textMaxX)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(descText)
            EndTextCommandDisplayText(textX, descTextY)
            ResetScriptGfxAlign()
        else
            ResetScriptGfxAlign()
            self:DrawLeftText(descText, descFont, descScale, self:ItemTextX(), descTextY, textMaxX)
        end

        self._descriptionYEnd = (descYStart + descHeight) / MenuController.ScreenHeight
    end

    function Menu:DrawPanels()
        if self:Size() < 1 then
            return
        end

        local item = self:GetMenuItems()[self._currentIndex]
        if not item or not item.ShowColorPanel then
            return
        end

        if not HasScaleformMovieLoaded(self._colorPanelScaleform) then
            self._colorPanelScaleform = RequestScaleformMovie("COLOUR_SWITCHER_02")
            return
        end

        local listIndex = item.ListIndex or 1
        local itemCount = item:ItemsCount()
        local colorType = item.ColorPanelColorType or 0

        BeginScaleformMovieMethod(self._colorPanelScaleform, "SET_TITLE")
        PushScaleformMovieMethodParameterString("Opacity")
        BeginTextCommandScaleformString("FACE_COLOUR")
        AddTextComponentInteger(listIndex)
        AddTextComponentInteger(itemCount)
        EndTextCommandScaleformString()
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamBool(true)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(self._colorPanelScaleform, "SET_DATA_SLOT_EMPTY")
        EndScaleformMovieMethod()

        for i = 0, 63 do
            local r, g, b = 0, 0, 0
            if colorType == MenuListItem.ColorPanelType.Hair then
                r, g, b = GetPedHairRgbColor(i)
            else
                r, g, b = GetPedMakeupRgbColor(i)
            end

            BeginScaleformMovieMethod(self._colorPanelScaleform, "SET_DATA_SLOT")
            ScaleformMovieMethodAddParamInt(i)
            ScaleformMovieMethodAddParamInt(r)
            ScaleformMovieMethodAddParamInt(g)
            ScaleformMovieMethodAddParamInt(b)
            EndScaleformMovieMethod()
        end

        BeginScaleformMovieMethod(self._colorPanelScaleform, "DISPLAY_VIEW")
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(self._colorPanelScaleform, "SET_HIGHLIGHT")
        ScaleformMovieMethodAddParamInt(listIndex - 1)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(self._colorPanelScaleform, "SHOW_OPACITY")
        ScaleformMovieMethodAddParamBool(false)
        ScaleformMovieMethodAddParamBool(true)
        EndScaleformMovieMethod()

        local width = Menu.WIDTH / MenuController.ScreenWidth
        local height = ((700.0 / 500.0) * Menu.WIDTH) / MenuController.ScreenHeight
        local x = (Menu.WIDTH / 2.0) / MenuController.ScreenWidth
        local y = self._descriptionYEnd + (height / 2.0) + (4.0 / MenuController.ScreenHeight)

        SetScriptGfxAlign(self.LeftAligned and 76 or 82, 84)
        SetScriptGfxAlignParams(MenuController.OffsetX, MenuController.OffsetY, 0.0, 0.0)
        DrawScaleformMovie(self._colorPanelScaleform, x, y, width, height, 255, 255, 255, 255, 0)
        ResetScriptGfxAlign()
    end

    function Menu:ItemSelectedEvent(menuItem, itemIndex)
        if self.OnItemSelect then
            self.OnItemSelect(self, menuItem, itemIndex)
        end
    end

    function Menu:CheckboxChangedEvent(menuItem, itemIndex, checked)
        if self.OnCheckboxChange then
            self.OnCheckboxChange(self, menuItem, itemIndex, checked)
        end
    end

    function Menu:ListItemSelectEvent(menu, listItem, selectedIndex, itemIndex)
        if self.OnListItemSelect then
            self.OnListItemSelect(menu, listItem, selectedIndex, itemIndex)
        end
    end

    function Menu:ListItemIndexChangeEvent(menu, listItem, oldIndex, newIndex, itemIndex)
        if self.OnListIndexChange then
            self.OnListIndexChange(menu, listItem, oldIndex, newIndex, itemIndex)
        end
    end

    function Menu:MenuCloseEvent(menu)
        if self.OnMenuClose then
            self.OnMenuClose(menu)
        end
    end

    function Menu:MenuOpenEvent(menu)
        if self.OnMenuOpen then
            self.OnMenuOpen(menu)
        end
    end

    function Menu:IndexChangeEvent(menu, oldItem, newItem, oldIndex, newIndex)
        if self.OnIndexChange then
            self.OnIndexChange(menu, oldItem, newItem, oldIndex, newIndex)
        end
    end

    function Menu:SliderItemChangedEvent(menu, sliderItem, oldPosition, newPosition, itemIndex)
        if self.OnSliderPositionChange then
            self.OnSliderPositionChange(menu, sliderItem, oldPosition, newPosition, itemIndex)
        end
    end

    function Menu:SliderSelectedEvent(menu, sliderItem, position, itemIndex)
        if self.OnSliderItemSelect then
            self.OnSliderItemSelect(menu, sliderItem, position, itemIndex)
        end
    end

    function Menu:DynamicListItemCurrentItemChanged(menu, dynamicListItem, oldValue, newValue)
        if self.OnDynamicListItemCurrentItemChange then
            self.OnDynamicListItemCurrentItemChange(menu, dynamicListItem, oldValue, newValue)
        end
    end

    function Menu:DynamicListItemSelectEvent(menu, dynamicListItem, currentItem)
        if self.OnDynamicListItemSelect then
            self.OnDynamicListItemSelect(menu, dynamicListItem, currentItem)
        end
    end

    return Menu
end)()
