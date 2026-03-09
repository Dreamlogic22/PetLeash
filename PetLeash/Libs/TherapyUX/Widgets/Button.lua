--[[--------------------------------------------------------------------

    Therapy UX modifications for Blizzard button and check button
    widgets.

----------------------------------------------------------------------]]

---@type addonTbl
local T = select(2, ...)

---@class TherapyUX
local UX = T.UX

local baseButton = CreateFrame("Button")

local getHighlightTexture = baseButton.GetHighlightTexture
local getNormalTexture = baseButton.GetNormalTexture
local getPushedTexture = baseButton.GetPushedTexture

---@class TuxButton: Button, TuxLayout, TuxTexture
local button_api = CreateFromMixins(UX.layout_api, UX.texture_api)
do
    ---@return TuxTexture
    function button_api:GetHighlightTexture()
        local texture = getHighlightTexture(self)
        return Mixin(texture, UX.texture_api)
    end

    ---@return TuxTexture
    function button_api:GetNormalTexture()
        local texture = getNormalTexture(self)
        return Mixin(texture, UX.texture_api)
    end

    ---@return TuxTexture
    function button_api:GetPushedTexture()
        local texture = getPushedTexture(self)
        return Mixin(texture, UX.texture_api)
    end

    ---@param button TuxButton
    ---@param texture TextureAsset
    function button_api:SetupTextures(button, texture)
        button:SetNormalTexture(texture)
        button:SetHighlightTexture(texture)
        button:SetPushedTexture(texture)

        local Normal, Highlight, Pushed = button:GetNormalTexture(), button:GetHighlightTexture(), button:GetPushedTexture()

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

UX.button_api = button_api