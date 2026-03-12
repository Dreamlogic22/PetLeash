--[[--------------------------------------------------------------------

    Base mixin for all widgets that controls options & interact with
    settings specialize and use.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)

---@class PetLeashSettingsMixin: PetLeashCheckbox
local PetLeashSettingsMixin = {}
do
    ---@param path PetLeashDB
    ---@param onValueChanged function?
    function PetLeashSettingsMixin:Bind(path, onValueChanged)
        self.path = path
        self.onValueChanged = onValueChanged
        self:SetValue(path)
        self:SetScriptHandler()
    end

    function PetLeashSettingsMixin:CommitChange(value)
        if self.path then
            C.db[self.path] = value
        end

        if self.onValueChanged then
            self.onValueChanged(value)
        end
    end

    function PetLeashSettingsMixin:SetScriptHandler()
        error("Control must implement :SetScriptHandler")
    end

    function PetLeashSettingsMixin:SetValue(value)
        error("Control must implement :SetValue")
    end
end

C.PetLeashSettingsMixin = PetLeashSettingsMixin