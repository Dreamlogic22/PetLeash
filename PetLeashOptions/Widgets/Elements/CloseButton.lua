--[[--------------------------------------------------------------------

    Custom close button for dialogs and popups.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreateCloseButton
do
    ---@param parent Frame
    ---@return TherapyCloseButton
    CreateCloseButton = function(parent)
        ---@class TherapyCloseButton: TherapyFrame
        local CloseButton = C.CreateFrame("Button", nil, parent)
        CloseButton:SetSize(14, 14)
        CloseButton:SetPoint("TOPRIGHT", -6, -6)

        CloseButton.Texture = CloseButton:CreateTexture(nil, "OVERLAY", "TherapyTextureTemplate")
        CloseButton.Texture:SetTexture(Media.Textures.Close)
        CloseButton.Texture:SetInside()

        CloseButton:SetScript("OnClick", function(self)
            PlaySoundFile(567481)
            self:GetParent():Hide()
        end)

        CloseButton:SetScript("OnEnter", function(self)
            self.Texture:SetVertexColor(Media.Colors.Foreground:GetRGB())
        end)

        CloseButton:SetScript("OnLeave", function(self)
            self.Texture:SetVertexColor(1, 1, 1)
        end)

        return CloseButton
    end

    C.CreateCloseButton = CreateCloseButton
end