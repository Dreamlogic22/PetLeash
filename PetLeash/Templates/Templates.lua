--[[--------------------------------------------------------------------

    Shared templates & mixins.

--------------------------------------------------------------------]]

---@type number
local Perfect = 786 / select(2, GetPhysicalScreenSize())
local UIScale = (ElvUI and ElvUI[1].global.general.UIScale) or GetCVar("uiScale")
local Mult = Perfect / UIScale

---@param size number
local function Scale(size)
    if Mult == 1 or size == 0 then
        return size
    else
        local y = Mult > 1 and Mult or -Mult
        return size - size % (size < 0 and y or -y)
    end
end

---@class PetLeashButtonMixin: Button
PetLeashButtonMixin = {}
do
    ---@param texture TextureAsset
    function PetLeashButtonMixin:SetupTextures(texture)
        self:SetNormalTexture(texture)
        self:SetHighlightTexture(texture)
        self:SetPushedTexture(texture)

        local Normal, Highlight, Pushed = self:GetNormalTexture(), self:GetHighlightTexture(), self:GetPushedTexture()

        if Normal then
            Normal = Mixin(Normal, PetLeashLayoutMixin, PetLeashTextureMixin)
            Normal:DisableSharpening()
            Normal:SetInside()
        end

        if Highlight then
            Highlight = Mixin(Highlight, PetLeashLayoutMixin)
            Highlight:SetBlendMode("ADD")
            Highlight:SetAlpha(0.25)
            Highlight:SetInside()
        end

        if Pushed then
            Pushed = Mixin(Pushed, PetLeashLayoutMixin)
            Pushed:SetBlendMode("BLEND")
            Pushed:SetVertexColor(0.9, 0.9, 0.9)
        end
    end
end

---@class PetLeashLayoutMixin: Frame, Texture
PetLeashLayoutMixin = {}
do
    ---@param anchor? Frame
    ---@param offsetX? number
    ---@param offsetY? number
    function PetLeashLayoutMixin:SetInside(anchor, offsetX, offsetY)
        offsetX = Scale(offsetX or 1)
        offsetY = Scale(offsetY or 1)

        anchor = anchor or self:GetParent()

        if self:GetNumPoints() > 0 then
            self:ClearAllPoints()
        end

        self:SetPoint("TOPLEFT", anchor, "TOPLEFT", offsetX, -offsetY)
        self:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -offsetX, offsetY)
    end

    ---@param anchor? Frame
    ---@param offsetX? number
    ---@param offsetY? number
    function PetLeashLayoutMixin:SetOutside(anchor, offsetX, offsetY)
        offsetX = Scale(offsetX or 1)
        offsetY = Scale(offsetY or 1)

        anchor = anchor or self:GetParent()

        if self:GetNumPoints() > 0 then
            self:ClearAllPoints()
        end

        self:SetPoint("TOPLEFT", anchor, "TOPLEFT", -offsetX, offsetY)
        self:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", offsetX, -offsetY)
    end
end

---@class PetLeashTextureMixin: Texture
PetLeashTextureMixin = {}
do
    function PetLeashTextureMixin:DisableSharpening()
        self:SetSnapToPixelGrid(false)
        self:SetTexelSnappingBias(0)
    end
end