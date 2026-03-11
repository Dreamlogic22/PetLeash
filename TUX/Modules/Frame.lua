--[[--------------------------------------------------------------------

    Therapy UX modifications for various frame types.

----------------------------------------------------------------------]]

---@class addonTbl
local T = select(2, ...)

---@class TherapyUX
local UX = T.UX

local baseButton = CreateFrame("Button")
local baseFrame = CreateFrame("Frame")

local createTexture = baseFrame.CreateTexture
local getHighlightTexture = baseButton.GetHighlightTexture
local getNormalTexture = baseButton.GetNormalTexture
local getPushedTexture = baseButton.GetPushedTexture

---@class TherapyFrameMixin: Frame, Button, TherapyBackdropMixin, TherapyLayoutMixin
local TherapyFrameMixin = CreateFromMixins(UX.TherapyBackdropMixin, UX.TherapyLayoutMixin)
do
    ---@param name? string
    ---@param drawLayer? DrawLayer
    ---@param templateName Template?
    ---@return TherapyTextureMixin
    function TherapyFrameMixin:CreateTexture(name, drawLayer, templateName)
        return Mixin(createTexture(self, name, drawLayer, templateName), UX.TherapyTextureMixin)
    end

    ---@return TherapyTextureMixin
    function TherapyFrameMixin:GetHighlightTexture()
        return Mixin(getHighlightTexture(self), UX.TherapyTextureMixin)
    end

    ---@return TherapyTextureMixin
    function TherapyFrameMixin:GetNormalTexture()
        return Mixin(getNormalTexture(self), UX.TherapyTextureMixin)
    end

    ---@return TherapyTextureMixin
    function TherapyFrameMixin:GetPushedTexture()
        return Mixin(getPushedTexture(self), UX.TherapyTextureMixin)
    end

    ---@param texture TextureAsset
    function TherapyFrameMixin:SetupTextures(texture)
        self:SetNormalTexture(texture)
        self:SetHighlightTexture(texture)
        self:SetPushedTexture(texture)

        local Normal, Highlight, Pushed = self:GetNormalTexture(), self:GetHighlightTexture(), self:GetPushedTexture()

        if Normal then
            Normal:DisableSharpening()
            Normal:SetInside()
        end

        if Highlight then
            Highlight:SetBlendMode("ADD")
            Highlight:SetAlpha(0.25)
            Highlight:DisableSharpening()
            Highlight:SetInside()
        end

        if Pushed then
            Pushed:SetBlendMode("BLEND")
            Pushed:SetVertexColor(0.9, 0.9, 0.9)
            Pushed:DisableSharpening()
        end
    end
end

---@generic T, Tp
---@param frameType `T`
---@param name string?
---@param parent Frame?
---@param template? `Tp`
---@param id number?
---@return TherapyFrameMixin|T|Tp
function T.CreateFrame(frameType, name, parent, template, id)
    return Mixin(CreateFrame(frameType, name, parent, template, id), TherapyFrameMixin)
end