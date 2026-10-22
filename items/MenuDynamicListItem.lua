(function()

MenuDynamicListItem = setmetatable({}, {__index = MenuItem})
MenuDynamicListItem.__index = MenuDynamicListItem

function MenuDynamicListItem:New(text, initialValue, callback, description)
    local self = setmetatable(MenuItem:New(text, description), MenuDynamicListItem)

    self.CurrentItem = initialValue or "N/A"
    self.Callback = callback
    self.HideArrowsWhenNotSelected = false

    return self
end

function MenuDynamicListItem:Draw(indexOffset)
    if self.HideArrowsWhenNotSelected and not self:IsSelected() then
        self.Label = self.CurrentItem or "~r~N/A"
    else
        local current = Locale.Translate(self.CurrentItem or "~r~N/A~s~")
        self.Label = "~s~← " .. current .. " ~s~→"
    end

    self.LeftIcon = Icon.NONE

    MenuItem.Draw(self, indexOffset)
end

function MenuDynamicListItem:GoRight()
    if self.Callback then
        local oldValue = self.CurrentItem
        local newValue = self.Callback(self, false)
        self.CurrentItem = newValue
        self.ParentMenu:DynamicListItemCurrentItemChanged(self.ParentMenu, self, oldValue, newValue)

        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end
end

function MenuDynamicListItem:GoLeft()
    if self.Callback then
        local oldValue = self.CurrentItem
        local newValue = self.Callback(self, true)
        self.CurrentItem = newValue
        self.ParentMenu:DynamicListItemCurrentItemChanged(self.ParentMenu, self, oldValue, newValue)

        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    end
end

function MenuDynamicListItem:Select()
    self.ParentMenu:DynamicListItemSelectEvent(self.ParentMenu, self, self.CurrentItem)
end

return MenuDynamicListItem
end)()
