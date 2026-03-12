--[[--------------------------------------------------------------------

    Implementation of the base settings mixin for toggle-style (on/off,
    not tristate) checkboxes.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)

---@class PetLeashToggleMixin: PetLeashSettingsMixin
local PetLeashToggleMixin = CreateFromMixins(C.PetLeashSettingsMixin)
do
    function PetLeashToggleMixin:SetScriptHandler()
        self:HookScript("OnClick", function()
            self:CommitChange(self:GetChecked())
        end)
    end

    ---@param value boolean
    function PetLeashToggleMixin:SetValue(value)
        self:SetChecked(value)
        self:HandleCheckedTexture()
    end
end

C.PetLeastToggleMixin = PetLeashToggleMixin