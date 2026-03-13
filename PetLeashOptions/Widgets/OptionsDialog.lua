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
    Dialog:SetPoint("TOP", CollectionsJournal, "TOP")
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

    ---@param name string
    ---@param width number
    ---@param height number
    ---@return ControlContainerMixin: Section
    function Dialog:CreateGroup(name, width, height)
        local group = C.CreateSection(name, self, width, height)
        return Mixin(group, C.ControlContainerMixin)
    end

    local Title = Dialog:CreateFontString(nil, "OVERLAY")
    Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
    Title:SetText(C.Title)
    Title:SetPoint("TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
    Version:SetTextColor(Media.Colors.Background:GetRGB())
    Version:SetText(format(L.VERSION, C.Version))
    Version:SetPoint("BOTTOMRIGHT", -7, 7)

    Dialog.CloseButton = C.CreateCloseButton(Dialog)
    Dialog.CloseButton:SetPoint("CENTER", Dialog, "TOPRIGHT", -15, -12)

    -- General

    -- Dialog.General = Dialog:CreateGroup(GENERAL, 640, 200)
    -- Dialog.General:SetPoint("TOPLEFT", 20, -50)

    -- local Enable = C.CreateCheckbox(PetLeashOptionsDialog.General, ENABLE, L.OPTIONS_ENABLE_AUTO_SUMMON)
    -- Enable:SetPoint("TOPLEFT", PetLeashOptionsDialog.General, "TOPLEFT", 10, -30)
    -- Dialog.General:AddControl(Enable)

    Dialog.General = C.CreateSection(GENERAL, Dialog, 640, 200)
    Dialog.General:SetPoint("TOPLEFT", 20, -50)

    -- -- create a function in the mixins for CreateSettingsChecbox and attach it to the group

    local Enable = C.CreateCheckbox(PetLeashOptionsDialog.General, ENABLE, L.OPTIONS_ENABLE_AUTO_SUMMON)
    -- Enable = Mixin(Enable, PetLeashToggleMixin)
    Enable:SetPoint("TOPLEFT", PetLeashOptionsDialog.General, "TOPLEFT", 10, -30)
    -- Enable:Bind(C.db.enable, function(value)
    --     print(value)
    -- end)

    Dialog.Enable = Enable

    local AutoSwitch = C.CreateCheckbox(PetLeashOptionsDialog.General, L.OPTIONS_ENABLE_AUTO_SWITCH)
    -- AutoSwitch = Mixin(AutoSwitch, PetLeashToggleMixin)
    AutoSwitch:SetPoint("TOP", Enable, "BOTTOM", 0, 0)
    -- AutoSwitch:Bind(C.db.autoSwitch, function(value)
    --     print(value)
    -- end)

    local AutoSwitchInterval = C.CreateSlider(PetLeashOptionsDialog.General, L.OPTIONS_AUTO_SWITCH_INTERVAL, 1, 30, 1)
    AutoSwitchInterval:SetPoint("LEFT", AutoSwitch, "RIGHT", 230, 0)

    AutoSwitch:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        C.db.autoSwitch = value

        if not value or #C.db.pets > 1 then
            Dialog.AutoSwitchInterval:Disable()
        else
            Dialog.AutoSwitchInterval:Enable()
        end
    end)

    Dialog.AutoSwitch = AutoSwitch
    Dialog.AutoSwitchInterval = AutoSwitch

    -- Dialog.PetCards = C.CreateSection(PETS, Dialog, 640, 290)
    -- Dialog.PetCards:SetPoint("BOTTOMLEFT", 20, 30)

    -- todo: disabling logic that is not manual

    -- todo: hide and restore (if opened) in combat

    PetLeashOptionsDialog = Dialog
    tinsert(UISpecialFrames, "PetLeashOptionsDialog")
end