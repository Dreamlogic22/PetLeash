--[[--------------------------------------------------------------------

    Bootleg data broker that handles pet selection and showing the
    configuration dialog.

----------------------------------------------------------------------]]

local T = PetLeash
local Media = T.Media

do
    ---@class PetLeashOptionsButton: TherapyButtonMixin
    local Button = T.CreateButton("PetLeashOptionsButton", PetJournal)
    Button:SetSize(48, 48)
    Button:SetFrameStrata("HIGH")
    Button:SetFrameLevel(10)
    Button:SetPoint("CENTER", PetJournal, "RIGHT", 0, 0)
    Button:SetupTextures(Media.Textures.PetJournalWidget)
    Button:RegisterForClicks("AnyDown")

    Button:SetScript("OnClick", function()
        PlaySound(856)
    end)

    Button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    PetLeashOptionsButton = Button
end