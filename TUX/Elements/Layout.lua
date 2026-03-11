--[[------------------------------------------------------------------

    Therapy UX API methods for positioning and sizing screen elements
    created using the library.

--------------------------------------------------------------------]]

---@type addonTbl
local T = select(2, ...)

---@class TherapyUX
local UX = T.UX

---@class TherapyLayoutMixin: Frame | Texture
local TherapyLayoutMixin = {}
do
    ---@param anchor Frame?
    ---@param xOffset number?
    ---@param yOffset number?
    ---@param noScale boolean?
    function TherapyLayoutMixin:SetInside(anchor, xOffset, yOffset, noScale)
        if not anchor then
            anchor = self:GetParent()
        end

        if not xOffset then xOffset = 1 end
        if not yOffset then yOffset = 1 end

        local x = (noScale and xOffset) or xOffset
        local y = (noScale and yOffset) or yOffset

        if self:GetPoint() then
            self:ClearAllPoints()
        end

        self:SetPoint("TOPLEFT", anchor, "TOPLEFT", x, -y)
        self:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -x, y)
    end

    ---@param anchor Frame?
    ---@param xOffset number?
    ---@param yOffset number?
    ---@param noScale boolean?
    function TherapyLayoutMixin:SetOutside(anchor, xOffset, yOffset, noScale)
        if not anchor then
            anchor = self:GetParent()
        end

        if not xOffset then xOffset = 1 end
        if not yOffset then yOffset = 1 end

        local x = (noScale and xOffset) or xOffset
        local y = (noScale and yOffset) or yOffset

        if self:GetPoint() then
            self:ClearAllPoints()
        end

        self:SetPoint("TOPLEFT", anchor, "TOPLEFT", -x, y)
        self:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", x, -y)
    end
end

UX.TherapyLayoutMixin = TherapyLayoutMixin