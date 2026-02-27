---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Colors, L, Media = C.Colors, T.Locale, T.Media

local CreateCheckBox = C.CreateCheckBox
local CreateCloseButton = C.CreateCloseButton
local CreateSlider = C.CreateSlider
local GetNumPets = C_PetJournal.GetNumPets
local Scale = C.Scale

local CreateSection
do
    ---@param title string
    ---@param parent Frame
    ---@param width number
    ---@param height number
    CreateSection = function(title, parent, width, height)
        ---@class PetLeashSection: Frame, BackdropTemplate
        local Section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        Section:SetSize(width, height)

        Section:SetFrameLevel(parent:GetFrameLevel() + 1)
        Section:SetBackdrop({ bgFile = Media.Textures.Blank, edgeFile = Media.Textures.Blank, edgeSize = C.Scale(1) })
        Section:SetBackdropColor(0.11, 0.11, 0.11, 0.5)
        Section:SetBackdropBorderColor(0, 0, 0)

        Section.Label = Section:CreateFontString(nil, "BACKGROUND")
        Section.Label:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
        Section.Label:SetVertexColor(Colors.DarkBrown:GetRGB())
        Section.Label:SetText(title)
        Section.Label:SetPoint("TOPLEFT", Section, "TOPLEFT", 10, -10)

        return Section
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
    Title:SetText(WrapTextInColorCode("PetLeash", Colors.GoldenBrown:GenerateHexColor()) .. " " .. WrapTextInColorCode("Options", Colors.DarkBrown:GenerateHexColor()))
    Title:SetPoint("TOPLEFT", Dialog, "TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
    Version:SetTextColor(Colors.DarkBrown:GetRGB())
    Version:SetText(format(L.VERSION, 4.01))
    Version:SetPoint("BOTTOMRIGHT", Dialog, "BOTTOMRIGHT", -7, 7)

    Dialog.CloseButton = CreateCloseButton(Dialog)
    Dialog.CloseButton:SetPoint("CENTER", Dialog, "TOPRIGHT", -15, -12)

    local General = CreateSection(GENERAL, Dialog, 640, 500)
    General:SetPoint("LEFT", Dialog, "LEFT", 20, -10)

    local Enable = CreateCheckBox(General, ENABLE, T.db.enable, L.OPTIONS_ENABLE_AUTO_SUMMON)
    Enable:SetPoint("TOPLEFT", General, "TOPLEFT", 10, -30)
    Enable:HookScript("OnClick", function(self)
        C.db.enable = self:GetChecked() -- todo: disable petleash & all controls if not set
    end)

    local AutoSwitch = CreateCheckBox(General, L.OPTIONS_ENABLE_AUTO_SWITCH, T.db.autoSwitch)
    AutoSwitch:SetPoint("TOP", Enable, "BOTTOM", 0, 0)
    AutoSwitch:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        C.db.autoSwitch = value

        -- todo: make enable & disable
        if true then -- not value or select(2, GetNumPets()) < 2 then
            print(1)
            Dialog.AutoSwitchInterval:Disable()
        else
            Dialog.AutoSwitchInterval:Enable()
        end
    end)

    local AutoSwitchInterval = CreateSlider(General, L.OPTIONS_AUTO_SWITCH_INTERVAL, T.db.switchTimer, 60, 3600)
    AutoSwitchInterval:SetPoint("LEFT", AutoSwitch, "RIGHT", 230, 0)
    AutoSwitchInterval.RightText:SetText(AutoSwitchInterval.Slider:GetValue())

    if not AutoSwitch:GetChecked() or select(2, GetNumPets()) < 2 then
        AutoSwitchInterval:Disable()
    end

    Dialog.AutoSwitchInterval = AutoSwitchInterval

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

        self:SetShown(not self:IsVisible())
    end

    EventRegistry:RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", OnCombatStart)

    PetLeashOptionsPanel = Dialog
    tinsert(UISpecialFrames, "PetLeashOptionsPanel")
end