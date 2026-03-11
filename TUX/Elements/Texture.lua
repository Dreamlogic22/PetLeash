--[[------------------------------------------------------------------

    Therapy UX API methods for working with textures, including
    pixel-perfect rendering and layout.

--------------------------------------------------------------------]]

---@type addonTbl
local T = select(2, ...)

---@class TherapyUX
local UX = T.UX

---@class TherapyTextureMixin: Texture, TherapyLayoutMixin
local TherapyTextureMixin = CreateFromMixins(UX.TherapyLayoutMixin)
do
    ---@param self Texture
    function TherapyTextureMixin:DisableSharpening()
        self:SetSnapToPixelGrid(false)
        self:SetTexelSnappingBias(0)
    end
end

UX.TherapyTextureMixin = TherapyTextureMixin