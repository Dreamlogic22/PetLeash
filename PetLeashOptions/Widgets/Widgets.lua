---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

local Colors = {
    DarkBrownHex = "ff947d66",
    DarkBrownRgb = { 0.58, 0.49, 0.4 },
    GoldenBrownHex = "ffd6bfa3",
    GoldenBrownRgb = { 0.84, 0.75, 0.64 }
}

local function NotEnoughPets()
    return #C.db.pets < 2
end

local CreatePetPanel
do
    ---@param parent Frame
    ---@param petId string
    ---@return PetLeashPetPanel
    CreatePetPanel = function(parent, petId)
        ---@class PetLeashPetPanel: Frame, BackdropTemplate
        local Panel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        Panel:SetSize(180, 230)

        Panel:SetFrameLevel(parent:GetFrameLevel() + 1)
        Panel:SetBackdrop({ bgFile = Media.Textures.Blank, edgeFile = Media.Textures.Blank, edgeSize = Scale(1) })
        Panel:SetBackdropColor(0.58, 0.49, 0.4, 0.2)
        Panel:SetBackdropBorderColor(unpack(Colors.GoldenBrownRgb))

        local Model = CreateFrame("PlayerModel", nil, Panel)
        Model:SetSize(160, 180)
        Model:SetPoint("TOP", Panel, "TOP", 0, -10)
        Model:SetKeepModelOnHide(true)
        Model:SetCamera(1)
        Model:SetCamDistanceScale(0.6)
        Model:SetFacing(-math.pi / 4)

        local _, customName, _, _, _, displayID, _, name = C_PetJournal.GetPetInfoByPetID(petId)

        if displayID and displayID > 0 then
            Model:UseModelCenterToTransform(true)
            Model:SetDisplayInfo(displayID)
            Model:SetAnimation(0, 1)
        end

        local Name = Panel:CreateFontString(nil, "OVERLAY")
        Name:SetFont(Media.Fonts.Normal, 12, "OUTLINE")
        Name:SetPoint("BOTTOM", Panel, "BOTTOM", 0, 10)
        Name:SetText(customName or name or UNKNOWN)
        Name:SetTextColor(unpack(Colors.GoldenBrownRgb))

        return Panel
    end
end

do
    local Dialog = CreateFrame("Frame", "PetLeashOptionsPanel", UIParent)
    Dialog:SetSize(680, 580)
    Dialog:SetPoint("CENTER")
    Dialog:SetClampedToScreen(true)
    Dialog:SetFrameLevel(500)
    Dialog:SetFrameStrata("DIALOG")
    Dialog:SetMovable(true)
    Dialog:EnableMouse(true)
    Dialog:RegisterForDrag("LeftButton")

    Dialog:SetScript("OnDragStart", Dialog.StartMoving)
    Dialog:SetScript("OnDragStop", Dialog.StopMovingOrSizing)

    Dialog.Backdrop = CreateFrame("Frame", nil, Dialog, "BackdropTemplate")
    Dialog.Backdrop:SetAllPoints()
    Dialog.Backdrop:SetFrameLevel(Dialog:GetFrameLevel())
    Dialog.Backdrop:SetBackdrop({ bgFile = Media.Textures.Background, edgeFile = Media.Textures.Blank, edgeSize = Scale(1) })
    Dialog.Backdrop:SetBackdropBorderColor(0, 0, 0)

    local Title = Dialog:CreateFontString(nil, "OVERLAY")
    Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
    Title:SetText(C.Title)
    Title:SetPoint("TOPLEFT", Dialog, "TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
    Version:SetTextColor(unpack(Colors.DarkBrownRgb))
    Version:SetText(format(L.VERSION, 4.01))
    Version:SetPoint("BOTTOMRIGHT", Dialog, "BOTTOMRIGHT", -7, 7)

    Dialog.CloseButton = CreateCloseButton(Dialog)
    Dialog.CloseButton:SetPoint("CENTER", Dialog, "TOPRIGHT", -15, -12)

    local General = CreateSection(GENERAL, Dialog, 640, 200)
    General:SetPoint("TOPLEFT", Dialog, "TOPLEFT", 20, -50)

    local Enable = CreateCheckBox(General, ENABLE, C.db.enable, L.OPTIONS_ENABLE_AUTO_SUMMON)
    Enable:SetPoint("TOPLEFT", General, "TOPLEFT", 10, -30)
    Enable:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        C.db.enable = value

        if value and not NotEnoughPets() then
            Dialog.AutoSwitch:Enable()
            Dialog.AutoSwitchInterval:Enable()
            Dialog.CustomThrottle:Enable()
            Dialog.CustomThrottleInterval:Disable()
        else
            Dialog.AutoSwitch:Disable()
            Dialog.AutoSwitchInterval:Disable()
            Dialog.CustomThrottle:Disable()
            Dialog.CustomThrottleInterval:Disable()
        end
    end)

    local AutoSwitch = CreateCheckBox(General, L.OPTIONS_ENABLE_AUTO_SWITCH, C.db.autoSwitch)
    AutoSwitch:SetPoint("TOP", Enable, "BOTTOM", 0, 0)
    AutoSwitch:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        C.db.autoSwitch = value

        if not value or NotEnoughPets() then
            Dialog.AutoSwitchInterval:Disable()
        else
            Dialog.AutoSwitchInterval:Enable()
        end
    end)

    Dialog.AutoSwitch = AutoSwitch

    local AutoSwitchInterval = CreateSlider(General, L.OPTIONS_AUTO_SWITCH_INTERVAL, C.db.switchTimer, T.UpdateInterval, 10, 60, 3600)
    AutoSwitchInterval:SetPoint("LEFT", AutoSwitch, "RIGHT", 230, 0)
    AutoSwitchInterval.RightText:SetText(AutoSwitchInterval.Slider:GetValue())

    if not AutoSwitch:GetChecked() or NotEnoughPets() then
        AutoSwitchInterval:Disable()
    end

    Dialog.AutoSwitchInterval = AutoSwitchInterval

    local CustomThrottle = CreateCheckBox(General, L.OPTIONS_CUSTOM_THROTTLE, C.db.customThrottle, L.OPTIONS_CUSTOM_THROTTLE_TOOLTIP)
    CustomThrottle:SetPoint("TOP", AutoSwitch, "BOTTOM", 0, 0)
    CustomThrottle:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        C.db.customThrottle = value

        if not value then
            Dialog.CustomThrottleInterval:Disable()
        else
            Dialog.CustomThrottleInterval:Enable()
        end
    end)

    Dialog.CustomThrottle = CustomThrottle

    local CustomThrottleInterval = CreateSlider(General, L.OPTIONS_CUSTOM_THROTTLE, C.db.throttle, T.UpdateThrottle, 1, 3, 60)
    CustomThrottleInterval:SetPoint("LEFT", CustomThrottle, "RIGHT", 230, 0)
    CustomThrottleInterval.RightText:SetText(CustomThrottleInterval.Slider:GetValue())

    if not CustomThrottle:GetChecked() then
        CustomThrottleInterval:Disable()
    end

    Dialog.CustomThrottleInterval = CustomThrottleInterval

    local Pets = CreateSection(PETS, Dialog, 640, 290)
    Pets:SetPoint("BOTTOMLEFT", Dialog, "BOTTOMLEFT", 20, 30)

    local maxDisplay = 3
    local panels = {}

    for i = 1, math.min(maxDisplay, #T.db.pets) do
        local petID = T.db.pets[i]
        local panel = CreatePetPanel(Pets, petID)

        if i == 1 then
            panel:SetPoint("LEFT", Pets, "LEFT", 20, 0)
        else
            panel:SetPoint("LEFT", panels[i - 1], "RIGHT", 25, 0)
        end

        panels[i] = panel
    end

    if #T.db.pets > maxDisplay then
        local remaining = #T.db.pets - maxDisplay
        local moreText = Pets:CreateFontString(nil, "OVERLAY")

        moreText:SetFont(Media.Fonts.Normal, 12, "OUTLINE")
        moreText:SetPoint("BOTTOMRIGHT", Pets, "BOTTOMRIGHT", -20, 5)
        moreText:SetText(string.format("Plus %d More!", remaining))
        moreText:SetTextColor(unpack(Colors.GoldenBrownRgb))
    end

    local function OnCombatEnd()
        if Dialog.RestoreAfterCombat then
            Dialog.RestoreAfterCombat = nil
            Dialog:Show()
        end
    end

    ---@param userOpened boolean?
    local function OnCombatStart(userOpened)
        if Dialog:IsVisible() or userOpened then
            Dialog:Hide()
            Dialog.RestoreAfterCombat = true

            C.Print(L.OPTIONS_NOT_IN_COMBAT)

            EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnCombatEnd)
        end
    end

    function Dialog:Toggle()
        if InCombatLockdown() then
            OnCombatStart(true)
            return
        end

        if C.IsEditModeActive() then
            C.Print(L.OPTIONS_NOT_IN_EDIT_MODE)
            return
        end

        self:SetShown(not self:IsVisible())
    end

    EventRegistry:RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", OnCombatStart)

    PetLeashOptionsPanel = Dialog
    tinsert(UISpecialFrames, "PetLeashOptionsPanel")
end