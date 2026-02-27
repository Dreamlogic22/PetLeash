---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

local GetNumPets = C_PetJournal.GetNumPets

local Colors = {
    DarkBrownHex = "ff947d66",
    DarkBrownRgb = { 0.58, 0.49, 0.4 },
    GoldenBrownHex = "ffd6bfa3",
    GoldenBrownRgb = { 0.84, 0.75, 0.64 }
}

local _, ScreenWidth = GetPhysicalScreenSize()
local Perfect = 786 / ScreenWidth

local UIScale = (ElvUI and ElvUI[1].global.general.UIScale) or GetCVar("uiScale")
local Mult = Perfect / UIScale

---@param texture Texture
local function DisablePixelSnap(texture)
    texture:SetSnapToPixelGrid(false)
    texture:SetTexelSnappingBias(0)
end

local function NotEnoughPets()
    return select(2, GetNumPets()) < 2
end

---@param size number
local function Scale(size)
    if Mult == 1 or size == 0 then
        return size
    else
        local y = Mult > 1 and Mult or -Mult
        return size - size % (size < 0 and y or -y)
    end
end

local CreateCheckBox
do
    ---@param self PetLeashCheckBox
    local function OnEnable(self)
        self.CheckedTexture:SetDesaturated(false)
        self.CheckedTexture:SetVertexColor(1, 1, 1)
        self.Label:SetTextColor(unpack(unpack(Colors.GoldenBrownRgb)))
    end

    ---@param self PetLeashCheckBox
    local function OnDisable(self)
        self.CheckedTexture:SetDesaturated(true)
        self.CheckedTexture:SetVertexColor(0.5, 0.5, 0.5)
        self.Label:SetTextColor(0.5, 0.5, 0.5)
    end

    ---@param self PetLeashCheckBox
    local function OnClick(self)
        if self:GetChecked() then
            self.CheckedTexture:Show()
            PlaySound(857)
        else
            self.CheckedTexture:Hide()
            PlaySound(856)
        end
    end

    ---@param self PetLeashCheckBox
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
    ---@return PetLeashCheckBox
    CreateCheckBox = function(parent, label, setting, tooltipText)
        ---@class PetLeashCheckBox: CheckButton
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
        Section:SetBackdrop({ bgFile = Media.Textures.Blank, edgeFile = Media.Textures.Blank, edgeSize = Scale(1) })
        Section:SetBackdropColor(0.11, 0.11, 0.11, 0.5)
        Section:SetBackdropBorderColor(0, 0, 0)

        Section.Label = Section:CreateFontString(nil, "BACKGROUND")
        Section.Label:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
        Section.Label:SetVertexColor(unpack(Colors.DarkBrownRgb))
        Section.Label:SetText(title)
        Section.Label:SetPoint("TOPLEFT", Section, "TOPLEFT", 10, -10)

        return Section
    end
end

local CreateSlider
do
    local BackDisable = { 0.25, 0.5, 0.5, 0.625 }
    local BackHighlight = { 0.5, 0.75, 0.5, 0.625 }
    local BackNormal = { 0, 0.25, 0.5, 0.625 }
    local ForwardDisable = { 0.25, 0.5, 0.625, 0.75 }
    local ForwardHighlight = { 0.5, 0.75, 0.625, 0.75 }
    local ForwardNomral = { 0, 0.25, 0.625, 0.75 }
    local SliderLeft = { 0, 0.125, 0.875, 1 }
    local SliderMiddle = { 0.125, 0.375, 0.875, 1 }
    local SliderRight = { 0.375, 0.5, 0.875, 1 }
    local ThumbDisable = { 0.5, 1, 0, 0.25 }
    local ThumbHighlight = { 0, 0.5, 0.25, 0.5 }
    local ThumbNormal = { 0, 0.5, 0, 0.25 }

    local function OnClick()
        PlaySound(229883)
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

    ---@param parent Frame
    ---@param label string
    ---@param setting number
    ---@param callback function
    ---@param min number?
    ---@param max number?
    ---@return PetLeashSlider
    CreateSlider = function(parent, label, setting, callback, min, max)
        ---@class PetLeashSlider: Frame
        local Frame = CreateFrame("Frame", nil, parent)
        Frame:SetSize(386, 24)

        ---@class PetLeashSliderTemplate: Slider
        ---@field Thumb Button
        ---@field ValueText FontString
        local Slider = CreateFrame("Slider", nil, parent, "PetLeashSliderTemplate")
        Slider:SetOrientation("HORIZONTAL")
        Slider:SetSize(200, 24)
        Slider:SetPoint("LEFT", Frame, "LEFT", 172, 0)
        Slider:SetPoint("RIGHT", Frame, "RIGHT", -60, 0)
        Slider:EnableMouse(true)
        Slider.PreviousValue = setting

        Slider.Left = Slider:CreateTexture(nil, "BORDER")
        Slider.Left:SetTexture(Media.Textures.Slider)
        Slider.Left:SetTexCoord(unpack(SliderLeft))
        Slider.Left:SetSnapToPixelGrid(false)
        Slider.Left:SetTexelSnappingBias(0)
        Slider.Left:SetSize(8, 16)
        Slider.Left:SetPoint("CENTER", Slider, "LEFT", 0, 0)

        Slider.Right = Slider:CreateTexture(nil, "BORDER")
        Slider.Right:SetTexture(Media.Textures.Slider)
        Slider.Right:SetTexCoord(unpack(SliderRight))
        Slider.Right:SetSnapToPixelGrid(false)
        Slider.Right:SetTexelSnappingBias(0)
        Slider.Right:SetSize(8, 16)
        Slider.Right:SetPoint("CENTER", Slider, "RIGHT", 0, 0)

        Slider.Middle = Slider:CreateTexture(nil, "BORDER")
        Slider.Middle:SetTexture(Media.Textures.Slider)
        Slider.Middle:SetTexCoord(unpack(SliderMiddle))
        Slider.Middle:SetSnapToPixelGrid(false)
        Slider.Middle:SetTexelSnappingBias(0)
        Slider.Middle:SetPoint("TOPLEFT", Slider.Left, "TOPRIGHT")
        Slider.Middle:SetPoint("BOTTOMRIGHT", Slider.Right, "BOTTOMLEFT")

        Slider.ThumbTexture = Slider:CreateTexture(nil, "OVERLAY")
        Slider.ThumbTexture:SetTexture(Media.Textures.Slider)
        Slider.ThumbTexture:SetTexCoord(unpack(ThumbNormal))
        Slider.ThumbTexture:SetSize(32, 32)
        Slider.ThumbTexture:SetPoint("CENTER", Slider.Thumb, "CENTER")

        Slider.ThumbHighlight = Slider:CreateTexture(nil, "HIGHLIGHT")
        Slider.ThumbHighlight:SetTexture(Media.Textures.Slider)
        Slider.ThumbHighlight:SetTexCoord(unpack(ThumbHighlight))
        Slider.ThumbHighlight:SetSize(32, 32)
        Slider.ThumbHighlight:SetPoint("CENTER", Slider.ThumbTexture, "CENTER")
        Slider.ThumbHighlight:SetBlendMode("ADD")
        Slider.ThumbHighlight:SetVertexColor(0.5, 0.5, 0.5)

        Slider:SetScript("OnValueChanged", OnValueChanged)

        Frame.Slider = Slider

        ---@class PetLeashSliderBackButton: Button
        local Back = CreateFrame("Button", nil, Frame)
        Back:SetSize(16, 24)
        Back:SetPoint("RIGHT", Frame.Slider, "LEFT", -4, 0)

        Back.Texture = Back:CreateTexture(nil, "ARTWORK")
        Back.Texture:SetTexture(Media.Textures.Slider)
        Back.Texture:SetTexCoord(unpack(BackNormal))
        Back.Texture:SetSize(16, 16)
        Back.Texture:SetPoint("CENTER", Back, "CENTER")

        Back.Highlight = Back:CreateTexture(nil, "HIGHLIGHT")
        Back.Highlight:SetTexture(Media.Textures.Slider)
        Back.Highlight:SetTexCoord(unpack(BackHighlight))
        Back.Highlight:SetSize(16, 16)
        Back.Highlight:SetPoint("CENTER", Back, "CENTER")
        Back.Highlight:SetBlendMode("ADD")
        Back.Highlight:SetVertexColor(0.5, 0.5, 0.5)

        Back:SetScript("OnClick", OnClick)

        Frame.Back = Back

        ---@class PetLeashSliderForwardButton: Button
        local Forward = CreateFrame("Button", nil, Frame)
        Forward:SetSize(16, 24)
        Forward:SetPoint("LEFT", Frame.Slider, "RIGHT", 4, 0)

        Forward.Texture = Forward:CreateTexture(nil, "ARTWORK")
        Forward.Texture:SetTexture(Media.Textures.Slider)
        Forward.Texture:SetTexCoord(unpack(ForwardNomral))
        Forward.Texture:SetSize(16, 16)
        Forward.Texture:SetPoint("CENTER", Forward, "CENTER")

        Forward.Highlight = Forward:CreateTexture(nil, "HIGHLIGHT")
        Forward.Highlight:SetTexture(Media.Textures.Slider)
        Forward.Highlight:SetTexCoord(unpack(ForwardHighlight))
        Forward.Highlight:SetSize(16, 16)
        Forward.Highlight:SetPoint("CENTER", Forward, "CENTER")
        Forward.Highlight:SetBlendMode("ADD")
        Forward.Highlight:SetVertexColor(0.5, 0.5, 0.5)

        Forward:SetScript("OnClick", OnClick)

        Frame.Forward = Forward

        local Label = Frame:CreateFontString(nil, "ARTWORK")
        Label:SetFont(Media.Fonts.Normal, 12, "OUTLINE")
        Label:SetTextColor(1, 1, 1)
        Label:SetText(label)
        Label:SetSize(100, 32)
        Label:SetPoint("LEFT", Frame, "LEFT")
        Label:SetWidth(144)

        Frame.Label = Label

        local RightText = Frame:CreateFontString(nil, "ARTWORK")
        RightText:SetFont(Media.Fonts.Normal, 10, "OUTLINE")
        RightText:SetTextColor(1, 0.82, 0)
        RightText:SetPoint("LEFT", Frame.Forward, "RIGHT", 6, 0)

        Frame.RightText = RightText

        Frame.Slider.Back = Frame.Back
        Frame.Slider.Forward = Frame.Forward
        Frame.Slider.ValueText = Frame.RightText

        Frame.Slider:SetMinMaxValues(min or 0, max or 100)
        Frame.Slider:SetValueStep(10)
        Frame.Slider:SetObeyStepOnDrag(true)
        Frame.Slider:SetValue(setting)

        function Frame:Enable()
            self.Slider:Enable()
            self.Slider.ThumbTexture:SetTexCoord(unpack(ThumbNormal))

            self.Back:Enable()
            self.Back.Texture:SetTexCoord(unpack(BackNormal))
            self.Forward:Enable()

            self.Label:SetTextColor(1, 1, 1)
            self.RightText:SetTextColor(1, 0.82, 0)
        end

        function Frame:Disable()
            self.Slider:Disable()
            self.Slider.ThumbTexture:SetTexCoord(unpack(ThumbDisable))

            self.Back:Disable()
            self.Back.Texture:SetTexCoord(unpack(BackDisable))

            self.Forward:Disable()
            self.Forward.Texture:SetTexCoord(unpack(ForwardDisable))

            self.Slider:UnlockHighlight()

            self.Label:SetTextColor(0.5, 0.5, 0.5)
            self.RightText:SetTextColor(0.5, 0.5, 0.5)
        end

        if callback and type(callback) == "function" then
            Slider.Callback = callback
        end

        return Frame
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

    local General = CreateSection(GENERAL, Dialog, 640, 500)
    General:SetPoint("LEFT", Dialog, "LEFT", 20, -10)

    local Enable = CreateCheckBox(General, ENABLE, T.db.enable, L.OPTIONS_ENABLE_AUTO_SUMMON)
    Enable:SetPoint("TOPLEFT", General, "TOPLEFT", 10, -30)
    Enable:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        C.db.enable = value

        if value and not NotEnoughPets() then
            Dialog.AutoSwitch:Enable()
        else
            Dialog.AutoSwitch:Disable()
        end
    end)

    local AutoSwitch = CreateCheckBox(General, L.OPTIONS_ENABLE_AUTO_SWITCH, T.db.autoSwitch)
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

    local AutoSwitchInterval = CreateSlider(General, L.OPTIONS_AUTO_SWITCH_INTERVAL, T.db.switchTimer, T.UpdateInterval, 60, 3600)
    AutoSwitchInterval:SetPoint("LEFT", AutoSwitch, "RIGHT", 230, 0)
    AutoSwitchInterval.RightText:SetText(AutoSwitchInterval.Slider:GetValue())

    if not AutoSwitch:GetChecked() or NotEnoughPets() then
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