--[[--------------------------------------------------------------------

    Simple visual container for organization.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreateGroup
do
    ---@param title string
    ---@param parent Frame
    ---@param width number
    ---@param height number
    ---@return TherapyGroup
    CreateGroup = function(title, parent, width, height)
        ---@class TherapyGroup: TherapyFrame
        local Group = C.CreateFrame("Frame", nil, parent)
        Group:SetSize(width, height)
        Group:SetFrameLevel(parent:GetFrameLevel() + 1)
        Group:CreateBackdrop()
        Group:SetBackdropColor(0.11, 0.11, 0.11, 0.5)

        Group.Label = Group:CreateFontString(nil, "BACKGROUND")
        Group.Label:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
        Group.Label:SetVertexColor(Media.Colors.Background:GetRGB())
        Group.Label:SetText(title)
        Group.Label:SetPoint("TOPLEFT", Group, "TOPLEFT", 10, -10)

        return Group
    end

    C.CreateGroup = CreateGroup
end