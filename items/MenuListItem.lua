(function()
MenuListItem = setmetatable({}, {__index = MenuItem})
MenuListItem.__index = MenuListItem

MenuListItem.ColorPanelType = {
    Hair = 0,
    Makeup = 1
}

function MenuListItem:New(text, items, index, description)
    local self = setmetatable(MenuItem:New(text, description), MenuListItem)

    self.ListItems = items or {}
    self.ListIndex = index or 1
    self.HideArrowsWhenNotSelected = false
    self.ShowOpacityPanel = false
    self.ShowColorPanel = false
    self.ColorPanelColorType = MenuListItem.ColorPanelType.Hair

    return self
end

function MenuListItem:ItemsCount()
    return #self.ListItems
end

function MenuListItem:GetCurrentSelection()
    if self:ItemsCount() > 0 and self.ListIndex >= 1 and self.ListIndex <= self:ItemsCount() then
        return self.ListItems[self.ListIndex]
    end
    return nil
end

function MenuListItem:Draw(indexOffset)
    if self:ItemsCount() < 1 then
        table.insert(self.ListItems, "N/A")
    end

    while self.ListIndex < 1 do
        self.ListIndex = self.ListIndex + self:ItemsCount()
    end

    while self.ListIndex > self:ItemsCount() do
        self.ListIndex = self.ListIndex - self:ItemsCount()
    end

    if self.HideArrowsWhenNotSelected and not self:IsSelected() then
        self.Label = self:GetCurrentSelection() or "~r~N/A"
    else
        local current = Locale.Translate(self:GetCurrentSelection() or "~r~N/A~s~")
        self.Label = "~s~← " .. current .. " ~s~→"
    end

    MenuItem.Draw(self, indexOffset)
end

function MenuListItem:GoRight()
    if self:ItemsCount() > 0 then
        local oldIndex = self.ListIndex
        local newIndex = oldIndex

        if self.ListIndex >= self:ItemsCount() then
            newIndex = 1
        else
            newIndex = newIndex + 1
        end

        self.ListIndex = newIndex
        self.ParentMenu:ListItemIndexChangeEvent(self.ParentMenu, self, oldIndex, newIndex, self:GetIndex())

        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end
end

function MenuListItem:GoLeft()
    if self:ItemsCount() > 0 then
        local oldIndex = self.ListIndex
        local newIndex = oldIndex

        if self.ListIndex <= 1 then
            newIndex = self:ItemsCount()
        else
            newIndex = newIndex - 1
        end

        self.ListIndex = newIndex
        self.ParentMenu:ListItemIndexChangeEvent(self.ParentMenu, self, oldIndex, newIndex, self:GetIndex())

        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end
end

function MenuListItem:Select()
    self.ParentMenu:ListItemSelectEvent(self.ParentMenu, self, self.ListIndex, self:GetIndex())
end

return MenuListItem
end)()
