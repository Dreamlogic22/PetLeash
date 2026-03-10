--[[--------------------------------------------------------------------

    Translucent sections for dividing up sections on a panel logically
    in an aesthetically-pleasing way.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Media = T.Media

local CreateSection
do
    ---@param title string
    ---@param parent Frame
    ---@param width number
    ---@param height number
    ---@return PetLeashSection
    CreateSection = function(title, parent, width, height)
        ---@class PetLeashSection: TherapyFrameMixin
        local Section = T.CreateFrame("Frame", nil, parent)
        Section:SetSize(width, height)
        Section:SetFrameLevel(parent:GetFrameLevel() + 1)

        Section:CreateBackdrop()
        Section:SetBackdropColor(0.11, 0.11, 0.11, 0.5)

        Section.Label = Section:CreateFontString(nil, "BACKGROUND")
        Section.Label:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
        Section.Label:SetVertexColor(Media.Colors.Background:GetRGB())
        Section.Label:SetText(title)
        Section.Label:SetPoint("TOPLEFT", Section, "TOPLEFT", 10, -10)

        return Section
    end

    C.CreateSection = CreateSection
end