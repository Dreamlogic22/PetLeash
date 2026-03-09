--[[--------------------------------------------------------------------

    Therapy UX modifications for basic frame widgets.

----------------------------------------------------------------------]]

---@class addonTbl
local T = select(2, ...)

---@class TherapyUX
local UX = T.TherapyUX

local baseFrame = CreateFrame("Frame")

local createTexture = baseFrame.CreateTexture

---@class TherapyFrameMixin: Frame, TherapyBackdropMixin, TherapyLayoutMixin
local TherapyFrameMixin = CreateFromMixins(UX.TherapyBackdropMixin, UX.TherapyLayoutMixin)
do
    ---@generic Tp
    ---@param name? string
    ---@param drawLayer? DrawLayer
    ---@param templateName? `Tp` | Template
    ---@return TherapyTextureMixin|Tp
    function TherapyFrameMixin:CreateTexture(name, drawLayer, templateName)
        return Mixin(createTexture(self, name, drawLayer, templateName), UX.TherapyTextureMixin)
    end
end

---@generic T
---@param name? string
---@param parent? any
---@param template? `T` | Template
---@param id? number
---@return TherapyFrame|T
function T.CreateFrame(name, parent, template, id)
    ---@class TherapyFrame
    return Mixin(CreateFrame("Frame", name, parent, template, id), TherapyFrameMixin)
end