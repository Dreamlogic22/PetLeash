---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

local Colors = {
    DarkBrownHex = "ff947d66",
    DarkBrownRgb = { 0.58, 0.49, 0.4 },
    GoldenBrownHex = "ffd6bfa3",
    GoldenBrownRgb = { 0.84, 0.75, 0.64 }
}

---@param texture Texture
local function DisablePixelSnap(texture)
    texture:SetSnapToPixelGrid(false)
    texture:SetTexelSnappingBias(0)
end

local function NotEnoughPets()
    return #C.db.pets < 2
end

local CreateCheckBox
do
    ---@param self PetLeashCheckbox
    local function OnEnable(self)
        self.CheckedTexture:SetDesaturated(false)
        self.CheckedTexture:SetVertexColor(1, 1, 1)
        self.Label:SetTextColor(unpack(Colors.GoldenBrownRgb))
    end

    ---@param self PetLeashCheckbox
    local function OnDisable(self)
        self.CheckedTexture:SetDesaturated(true)
        self.CheckedTexture:SetVertexColor(0.5, 0.5, 0.5)
        self.Label:SetTextColor(0.5, 0.5, 0.5)
    end

    ---@param self PetLeashCheckbox
    local function OnClick(self)
        if self:GetChecked() then
            self.CheckedTexture:Show()
            PlaySound(857)
        else
            self.CheckedTexture:Hide()
            PlaySound(856)
        end
    end

    ---@param self PetLeashCheckbox
    local function OnEnter(self)
        if self.TooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.Label:GetText(), unpack(Colors.DarkBrownRgb))
            GameTooltip:AddLine(self.TooltipText, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end

    local function OnLeave()
        GameTooltip:Hide()
    end

    ---@param parent Frame
    ---@param label string
    ---@param setting boolean
    ---@param tooltipText string?
    ---@return PetLeashCheckbox
    CreateCheckBox = function(parent, label, setting, tooltipText)
        ---@class PetLeashCheckbox: CheckButton
        local Button = CreateFrame("CheckButton", nil, parent)
        Button:SetSize(24, 24)

        Button.Border = Button:CreateTexture(nil, "ARTWORK")
        Button.Border:SetSize(32, 32)
        Button.Border:SetTexture(Media.Textures.Checkbox)
        Button.Border:SetTexCoord(0, 0.5, 0, 0.5)
        Button.Border:SetPoint("CENTER", Button, "LEFT", 8, 0)
        DisablePixelSnap(Button.Border)

        Button.Label = Button:CreateFontString(nil,"OVERLAY")
        Button.Label:SetFont(Media.Fonts.Normal, 12, "MONOCHROMEOUTLINE")
        Button.Label:SetVertexColor(unpack(Colors.GoldenBrownRgb))
        Button.Label:SetText(label)
        Button.Label:SetPoint("LEFT", Button, "RIGHT", 4, 0)

        Button.CheckedTexture = Button:CreateTexture(nil, "OVERLAY")
        Button.CheckedTexture:SetTexture(Media.Textures.Checkbox)
        Button.CheckedTexture:SetTexCoord(0.5, 0.75, 0.5, 0.75)
        Button.CheckedTexture:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.CheckedTexture:SetSize(16, 16)
        DisablePixelSnap(Button.CheckedTexture)

        Button.CheckedTexture:Hide()

        Button.Highlight = Button:CreateTexture(nil, "HIGHLIGHT")
        Button.Highlight:SetTexture(Media.Textures.Checkbox)
        Button.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
        Button.Highlight:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.Highlight:SetSize(32, 32)
        Button.Highlight:SetBlendMode("ADD")
        Button.Highlight:SetVertexColor(0.5, 0.5, 0.5)
        DisablePixelSnap(Button.Highlight)

        Button:SetScript("OnClick", OnClick)
        Button:SetScript("OnDisable", OnDisable)
        Button:SetScript("OnEnable", OnEnable)
        Button:SetScript("OnEnter", OnEnter)
        Button:SetScript("OnLeave", OnLeave)

        if tooltipText then
            Button.TooltipText = tooltipText
        end

        Button:SetChecked(setting)
        if Button:GetChecked() then
            Button.CheckedTexture:Show()
        else
            Button.CheckedTexture:Hide()
        end

        return Button
    end
end

local CreateCloseButton
do
    ---@param self PetLeashCloseButton
    local function OnClick(self)
        PlaySoundFile(567481)
        self:GetParent():Hide()
    end

    ---@param self PetLeashCloseButton
    local function ShowNormalTexture(self)
        self.Texture:SetTexCoord(0, 0.5, 0, 0.5)
        self.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
    end

    ---@param self PetLeashCloseButton
    local function ShowPushedTexture(self)
        self.Texture:SetTexCoord(0.5, 1, 0, 0.5)
        self.Highlight:SetTexCoord(0.5, 1, 0.5, 1)
    end

    ---@param parent Frame
    ---@return PetLeashCloseButton
    CreateCloseButton = function(parent)
        ---@class PetLeashCloseButton: Button
        local CloseButton = CreateFrame("Button", nil, parent)
        CloseButton:SetSize(24, 24)

        CloseButton.Texture = CloseButton:CreateTexture(nil, "ARTWORK")
        CloseButton.Texture:SetTexture(Media.Textures.CloseButton)
        CloseButton.Texture:SetPoint("CENTER", CloseButton, "CENTER", 0, 0)
        CloseButton.Texture:SetSize(32, 32)
        DisablePixelSnap(CloseButton.Texture)

        CloseButton.Highlight = CloseButton:CreateTexture(nil, "HIGHLIGHT")
        CloseButton.Highlight:SetTexture(Media.Textures.CloseButton)
        CloseButton.Highlight:SetPoint("CENTER", CloseButton, "CENTER", 0, 0)
        CloseButton.Highlight:SetSize(32, 32)
        DisablePixelSnap(CloseButton.Highlight)

        ShowNormalTexture(CloseButton)

        CloseButton:SetScript("OnClick", OnClick)
        CloseButton:SetScript("OnMouseUp", ShowNormalTexture)
        CloseButton:SetScript("OnMouseDown", ShowPushedTexture)
        CloseButton:SetScript("OnShow", ShowNormalTexture)

        return CloseButton
    end
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

local CreateSlider
do
    ---@param self PetLeashSliderBackButton | PetLeashSliderForwardButton
    local function OnClick(self)
        PlaySound(229883)

        if self.Delta then
            ---@type PetLeashSlider
            local parent = self:GetParent()
            parent:SetValueByDelta(self.Delta)
        end
    end

    ---@param self PetLeashSliderTemplate
    ---@param value number
    local function OnValueChanged(self, value)
        if value == self.PreviousValue then return end

        self.PreviousValue = value
        self.ThumbTexture:SetPoint("CENTER", self.Thumb, "CENTER", 0, 0)

        if self.ValueText then
            self.ValueText:SetText(value)

            if self.Callback then
                pcall(self.Callback, value)
            end
        end
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