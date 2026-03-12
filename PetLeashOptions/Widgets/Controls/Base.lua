--[[--------------------------------------------------------------------

    Base mixin for all widgets that controls options & interact with
    settings specialize and use.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash

---@class PetLeashSettingsMixin: PetLeashCheckbox
local PetLeashSettingsMixin = {}
do
    ---@param dbKey string
    ---@param onValueChanged function?
    function PetLeashSettingsMixin:Bind(dbKey, onValueChanged)
        self.dbKey = dbKey
        self.onValueChanged = onValueChanged
        self:SetValue(C.db[dbKey])
        self:SetScriptHandler()
    end

    function PetLeashSettingsMixin:CommitChange(value)
        if self.dbKey then
            C.db[self.dbKey] = value
        end

        if self.onValueChanged then
            self.onValueChanged(value)
        end
    end

    function PetLeashSettingsMixin:SetScriptHandler()
        error("Widget must implement :SetScriptHandler")
    end

    function PetLeashSettingsMixin:SetValue(value)
        error("Control must implement :SetValue")
    end
end

C.PetLeashSettingsMixin = PetLeashSettingsMixin