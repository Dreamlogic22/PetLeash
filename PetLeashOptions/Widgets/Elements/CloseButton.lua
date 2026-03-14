--[[--------------------------------------------------------------------

    Custom close button for dialogs and popups.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Media = T.Media

local CreateCloseButton
do
    ---@param self TherapyCloseButton
    local function OnClick(self)
        PlaySoundFile(567481)
        self:GetParent():Hide()
    end

    ---@param self TherapyCloseButton
    local function ShowNormalTexture(self)
        self.Texture:SetTexCoord(0, 0.5, 0, 0.5)
        self.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
    end

    ---@param self TherapyCloseButton
    local function ShowPushedTexture(self)
        self.Texture:SetTexCoord(0.5, 1, 0, 0.5)
        self.Highlight:SetTexCoord(0.5, 1, 0.5, 1)
    end

    ---@param parent Frame
    ---@return TherapyCloseButton
    CreateCloseButton = function(parent)
        ---@class TherapyCloseButton: TherapyFrame
        local CloseButton = T.CreateFrame("Button", nil, parent)
        CloseButton:SetSize(24, 24)

        CloseButton.Texture = CloseButton:CreateTexture(nil, "ARTWORK")
        CloseButton.Texture:SetTexture(Media.Textures.CloseButton)
        CloseButton.Texture:SetPoint("CENTER", CloseButton, "CENTER", 0, 0)
        CloseButton.Texture:SetSize(32, 32)
        CloseButton.Texture:DisableSharpening()

        CloseButton.Highlight = CloseButton:CreateTexture(nil, "HIGHLIGHT")
        CloseButton.Highlight:SetTexture(Media.Textures.CloseButton)
        CloseButton.Highlight:SetPoint("CENTER", CloseButton, "CENTER", 0, 0)
        CloseButton.Highlight:SetSize(32, 32)
        CloseButton.Highlight:DisableSharpening()

        ShowNormalTexture(CloseButton)

        CloseButton:SetScript("OnClick", OnClick)
        CloseButton:SetScript("OnMouseUp", ShowNormalTexture)
        CloseButton:SetScript("OnMouseDown", ShowPushedTexture)
        CloseButton:SetScript("OnShow", ShowNormalTexture)

        return CloseButton
    end

    C.CreateCloseButton = CreateCloseButton
end