---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

do
    local Dialog = CreateFrame("Frame", "PetLeashOptionsPanel", UIParent, "TherapyPanelTemplate")
    Dialog:SetSize(680, 680 * 0.85)
    Dialog:SetPoint("CENTER")
    Dialog:SetMovable(true)
    Dialog:SetResizable(true)
    Dialog:Hide()

    Dialog:CreateBackdrop()
    Dialog:SetClampedToScreen(true)
    Dialog:SetFrameLevel(500)
    Dialog:SetFrameStrata("DIALOG")
    Dialog:CreateShadow(2)

    Dialog:SetMovable(true)
    Dialog:SetResizable(true)
    Dialog:EnableMouse(true)
    Dialog:RegisterForDrag("LeftButton")

    Dialog:SetScript("OnDragStart", Dialog.StartMoving)
    Dialog:SetScript("OnDragStop", Dialog.StopMovingOrSizing)
    -- Dialog:SetScript("OnShow", OnShow)
    -- Dialog:SetScript("OnHide", OnHide)

    local Title = Dialog:CreateFontString(nil, "OVERLAY")
    Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
    Title:SetText("|cff33ff99PetLeash|r Options")
    Title:SetPoint("TOPLEFT", Dialog, "TOPLEFT", 20, -15)

    Dialog:CreateCloseButton()

    local function OnCombatEnd()
        if Dialog.RestoreAfterCombat then
            Dialog.RestoreAfterCombat = nil
            Dialog:Show()
        end
    end

    local function OnCombatStart()
        if Dialog:IsVisible() then
            Dialog:Hide()
        end

        Dialog.RestoreAfterCombat = true

        C.Print(L.OPTIONS_NOT_IN_COMBAT)

        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnCombatEnd)
    end

    function Dialog:Toggle()
        if InCombatLockdown() then
            OnCombatStart()
            return
        end

        if C.IsEditModeActive() then
            C.Print(L.OPTIONS_NOT_IN_EDIT_MODE)
            return
        end

        print(self:IsVisible())

        self:SetShown(not self:IsVisible())
    end

    EventRegistry:RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", OnCombatStart)

    PetLeashOptionsPanel = Dialog
    tinsert(UISpecialFrames, "PetLeashOptionsPanel")
end