--[[--------------------------------------------------------------------

    Semi-transparent container widget for the settings dialog.
    Includes title.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreateContainer
do
    ---@param parent Frame
    ---@return TherapyContainer
    CreateContainer = function(parent)
        ---@class TherapyContainer: ToolkitFrameTemplate
        local Container = CreateFrame("Frame", nil, parent, "ToolkitFrameTemplate")
        Container:SetFrameLevel(parent:GetFrameLevel() + 1)
        Container:CreateBackdrop()
        Container:SetBackdropColor(0.11, 0.11, 0.11, 0.4)
        Container:SetClipsChildren(true)

        Container.Title = Container:CreateFontString(nil, "ARTWORK")
        Container.Title:SetFont(Media.Fonts.Normal, 14, "")
        Container.Title:SetTextColor(Media.Colors.Foreground:GetRGB())
        Container.Title:SetPoint("TOPLEFT", 6, -6)

        return Container
    end

    C.CreateContainer = CreateContainer
end