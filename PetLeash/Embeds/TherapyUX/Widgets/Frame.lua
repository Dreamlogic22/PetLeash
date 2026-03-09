--[[--------------------------------------------------------------------

    Therapy UX modifications for various frame types.

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

---@generic T, Tp
---@param frameType `T` | FrameType
---@param name string?
---@param parent Frame?
---@param template? `Tp` | Template
---@param id number?
---@return TherapyFrameMixin|T|Tp
function T.CreateFrame(frameType, name, parent, template, id)
    return Mixin(CreateFrame(frameType, name, parent, template, id), TherapyFrameMixin)
end