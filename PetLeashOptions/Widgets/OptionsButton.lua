--[[--------------------------------------------------------------------

    Button that handles pet selection and showing the configuration
    dialog.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

do
    ---@class PetLeashOptionsButton: ToolkitButtonTemplate
    local Button = CreateFrame("Button", "PetLeashOptionsButton", UIParent, "ToolkitButtonTemplate")
    Button:SetSize(48, 48)
    Button:SetFrameStrata("HIGH")
    Button:SetFrameLevel(10)
    Button:SetupTextures(Media.Textures.PetJournalWidget)
    Button:RegisterForClicks("AnyDown")

    Button:SetScript("OnClick", function()
        PlaySound(856)
    end)

    Button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    Button:SetScript("OnHide", function()
        GameTooltip:Hide()
    end)

    PetLeashOptionsButton = Button
end