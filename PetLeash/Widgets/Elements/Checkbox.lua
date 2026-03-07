---@class PetLeash
local T = select(2, ...)
local Media = T.Media

local DisablePixelSnap = T.DisablePixelSnap

local CreateCheckBox
do
    ---@param parent Frame
    CreateCheckBox = function(parent)
        local Button = CreateFrame("CheckButton", nil, parent)
        Button:SetSize(24, 24)
        Button:SetPoint("RIGHT", parent, "RIGHT", -15, 0)

        Button.Border = Button:CreateTexture(nil, "ARTWORK")
        Button.Border:SetTexture(Media.Textures.Checkbox)
        Button.Border:SetTexCoord(0, 0.5, 0, 0.5)
        Button.Border:SetPoint("CENTER", Button, "LEFT", 8, 0)
        Button.Border:SetSize(32, 32)
        DisablePixelSnap(Button.Border)

        Button.CheckedTexture = Button:CreateTexture(nil, "OVERLAY")
        Button.CheckedTexture:SetTexture(Media.Textures.Checkbox)
        Button.CheckedTexture:SetTexCoord(0.5, 0.75, 0.5, 0.75)
        Button.CheckedTexture:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.CheckedTexture:SetSize(16, 16)
        DisablePixelSnap(Button.CheckedTexture)

        Button.CheckedTexture:Hide()

        Button.Highlight = Button:CreateTexture(nil, "HIGHLIGHT")
        Button.Highlight:SetTexture(Media.Textures.Checkbox)
        Button.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
        Button.Highlight:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.Highlight:SetSize(32, 32)
        Button.Highlight:SetBlendMode("ADD")
        Button.Highlight:SetVertexColor(0.5, 0.5, 0.5)
        DisablePixelSnap(Button.Highlight)

        return Button
    end

    T.CreateCheckBox = CreateCheckBox
end