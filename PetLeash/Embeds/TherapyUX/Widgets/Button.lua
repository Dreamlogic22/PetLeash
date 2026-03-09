--[[--------------------------------------------------------------------

    Therapy UX modifications for Blizzard button and check button
    widgets.

----------------------------------------------------------------------]]

---@class addonTbl
local T = select(2, ...)

---@class TherapyUX
local lib = T.lib

local baseButton = CreateFrame("Button")

local getHighlightTexture = baseButton.GetHighlightTexture
local getNormalTexture = baseButton.GetNormalTexture
local getPushedTexture = baseButton.GetPushedTexture

---@class TuxButton: Button, TuxLayout, TuxTexture
local button_api = CreateFromMixins(lib.layout_api, lib.texture_api)
do
    ---@return TuxTexture
    function button_api:GetHighlightTexture()
        local texture = getHighlightTexture(self)
        return Mixin(texture, lib.texture_api)
    end

    ---@return TuxTexture
    function button_api:GetNormalTexture()
        local texture = getNormalTexture(self)
        return Mixin(texture, lib.texture_api)
    end

    ---@return TuxTexture
    function button_api:GetPushedTexture()
        local texture = getPushedTexture(self)
        return Mixin(texture, lib.texture_api)
    end

    ---@param texture TextureAsset
    function button_api:SetupTextures(texture)
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
---@return TuxButton|T
function T.ConstructButton(name, parent, template, id)
    local button = CreateFrame("Button", name, parent, template, id)
    button = Mixin(button, button_api)

    return button
end