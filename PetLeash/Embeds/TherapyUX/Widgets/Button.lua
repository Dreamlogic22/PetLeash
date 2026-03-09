--[[--------------------------------------------------------------------

    Therapy UX modifications for Blizzard button and check button
    widgets.

----------------------------------------------------------------------]]

---@class addonTbl
local T = select(2, ...)

---@class TherapyUX
local UX = T.UX

local baseButton = CreateFrame("Button")

local getHighlightTexture = baseButton.GetHighlightTexture
local getNormalTexture = baseButton.GetNormalTexture
local getPushedTexture = baseButton.GetPushedTexture

---@class TherapyButtonMixin: Button, TherapyLayoutMixin, TherapyTextureMixin
local TherapyButtonMixin = CreateFromMixins(UX.TherapyLayoutMixin, UX.TherapyTextureMixin)
do
    ---@return TherapyTextureMixin
    function TherapyButtonMixin:GetHighlightTexture()
        return Mixin(getHighlightTexture(self), UX.TherapyTextureMixin)
    end

    ---@return TherapyTextureMixin
    function TherapyButtonMixin:GetNormalTexture()
        return Mixin(getNormalTexture(self), UX.TherapyTextureMixin)
    end

    ---@return TherapyTextureMixin
    function TherapyButtonMixin:GetPushedTexture()
        return Mixin(getPushedTexture(self), UX.TherapyTextureMixin)
    end

    ---@param texture TextureAsset
    function TherapyButtonMixin:SetupTextures(texture)
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

---@generic T
---@param name? string
---@param parent? any
---@param template? `T` | Template
---@param id? number
---@return TherapyButton|T
function T.CreateButton(name, parent, template, id)
    ---@class TherapyButton
    return Mixin(CreateFrame("Button", name, parent, template, id), TherapyButtonMixin)
end