--[[--------------------------------------------------------------------

    Primary settings panel opened by right-clicking the icon attached
    to the PetJournal.

----------------------------------------------------------------------]]

---@type PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

do
    ---@class PetLeashOptionsDialog: TherapyFrameMixin
    local Dialog = T.CreateFrame("Frame", "PetLeashOptionsDialog", UIParent)
    Dialog:SetSize(680, 580)
    Dialog:SetPoint("LEFT", CollectionsJournal, "RIGHT", 50, 0)
    Dialog:SetClampedToScreen(true)
    Dialog:SetFrameLevel(500)
    Dialog:SetFrameStrata("DIALOG")
    Dialog:SetMovable(true)
    Dialog:EnableMouse(true)
    Dialog:RegisterForDrag("LeftButton")

    Dialog:Hide()

    Dialog:SetScript("OnDragStart", Dialog.StartMoving)
    Dialog:SetScript("OnDragStop", Dialog.StopMovingOrSizing)

    Dialog:CreateBackdrop()
    Dialog:SetBackdropTexture(Media.Textures.Background)

    local Title = Dialog:CreateFontString(nil, "OVERLAY")
    Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
    Title:SetText(C.Title)
    Title:SetPoint("TOPLEFT", Dialog, "TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
    Version:SetTextColor(Media.Colors.Background:GetRGB())
    Version:SetText(format(L.VERSION, 4.01))
    Version:SetPoint("BOTTOMRIGHT", Dialog, "BOTTOMRIGHT", -7, 7)

    -- Dialog.CloseButton = CreateCloseButton(Dialog)
    -- Dialog.CloseButton:SetPoint("CENTER", Dialog, "TOPRIGHT", -15, -12)

    PetLeashOptionsDialog = Dialog
end