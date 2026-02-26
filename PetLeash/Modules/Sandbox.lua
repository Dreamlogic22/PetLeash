---@class PetLeash
local T = select(2, ...)
local L, Media = T.Locale, T.Media

local _, ScreenWidth = GetPhysicalScreenSize()
local Perfect = 786 / ScreenWidth

local UIScale = (ElvUI and ElvUI[1].global.general.UIScale) or GetCVar("uiScale")
local Mult = Perfect / UIScale

---@param size number
local function Scale(size)
    if Mult == 1 or size == 0 then
        return size
    else
        local y = Mult > 1 and Mult or -Mult
        return size - size % (size < 0 and y or -y)
    end
end

local LabelColor = { 0.58, 0.49, 0.4 }
local OptionColor = { 0.84, 0.75, 0.64 }

local CreateCheckBox
do
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
            GameTooltip:AddLine(self.Label:GetText(), LabelColor[1], LabelColor[2], LabelColor[3])
            GameTooltip:AddLine(self.TooltipText, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end

    local function OnLeave()
        GameTooltip:Hide()
    end

    ---@param parent Frame
    ---@param label string
    ---@param setting table
    ---@param tooltipText string?
    ---@return PetLeashCheckBox
    CreateCheckBox = function(parent, label, setting, tooltipText)
        ---@class PetLeashCheckBox: CheckButton
        local Button = CreateFrame("CheckButton", nil, parent)
        Button:SetSize(24, 24)

        Button.Border = Button:CreateTexture(nil, "ARTWORK")
        Button.Border:SetTexture(Media.Textures.Checkbox)
        Button.Border:SetTexCoord(0, 0.5, 0, 0.5)
        Button.Border:SetPoint("CENTER", Button, "LEFT", 8, 0)
        Button.Border:SetSize(32, 32)
        Button.Border:SetSnapToPixelGrid(false)
        Button.Border:SetTexelSnappingBias(0)

        Button.Label = Button:CreateFontString(nil,"OVERLAY")
        Button.Label:SetFont(Media.Fonts.Normal, 12, "MONOCHROMEOUTLINE")
        Button.Label:SetVertexColor(unpack(OptionColor))
        Button.Label:SetText(label)
        Button.Label:SetPoint("LEFT", Button, "RIGHT", 4, 0)

        Button.CheckedTexture = Button:CreateTexture(nil, "OVERLAY")
        Button.CheckedTexture:SetTexture(Media.Textures.Checkbox)
        Button.CheckedTexture:SetTexCoord(0.5, 0.75, 0.5, 0.75)
        Button.CheckedTexture:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.CheckedTexture:SetSize(16, 16)
        Button.CheckedTexture:SetSnapToPixelGrid(false)
        Button.CheckedTexture:SetTexelSnappingBias(0)
        Button.CheckedTexture:Hide()

        Button.Highlight = Button:CreateTexture(nil, "HIGHLIGHT")
        Button.Highlight:SetTexture(Media.Textures.Checkbox)
        Button.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
        Button.Highlight:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.Highlight:SetSize(32, 32)
        Button.Highlight:SetBlendMode("ADD")
        Button.Highlight:SetVertexColor(0.5, 0.5, 0.5)
        Button.Highlight:SetSnapToPixelGrid(false)
        Button.Highlight:SetTexelSnappingBias(0)

        Button:SetScript("OnClick", OnClick)
        Button:SetScript("OnEnter", OnEnter)
        Button:SetScript("OnLeave", OnLeave)

        if tooltipText then
            Button.TooltipText = tooltipText
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
        self.Texture:SetTexCoord(0, 0.5, 0, 0.5);
        self.Highlight:SetTexCoord(0, 0.5, 0.5, 1);
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
        CloseButton.Texture:SetSize(32, 32);
        CloseButton.Texture:SetSnapToPixelGrid(false)
        CloseButton.Texture:SetTexelSnappingBias(0)

        CloseButton.Highlight = CloseButton:CreateTexture(nil, "HIGHLIGHT")
        CloseButton.Highlight:SetTexture(Media.Textures.CloseButton)
        CloseButton.Highlight:SetPoint("CENTER", CloseButton, "CENTER", 0, 0)
        CloseButton.Highlight:SetSize(32, 32)
        CloseButton.Highlight:SetSnapToPixelGrid(false)
        CloseButton.Highlight:SetTexelSnappingBias(0)

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
    CreateSection = function(title, parent)
        ---@class PetLeashSection: Frame, BackdropTemplate
        local Section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        Section:SetSize(200, 500)

        Section:SetFrameLevel(parent:GetFrameLevel() + 1)
        Section:SetBackdrop({ bgFile = Media.Textures.Blank, edgeFile = Media.Textures.Blank, edgeSize = Scale(1) })
        Section:SetBackdropColor(0.11, 0.11, 0.11, 0.5)
        Section:SetBackdropBorderColor(0, 0, 0)

        Section.Label = Section:CreateFontString(nil, "BACKGROUND")
        Section.Label:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
        Section.Label:SetVertexColor(unpack(LabelColor))
        Section.Label:SetText(title)
        Section.Label:SetPoint("TOPLEFT", Section, "TOPLEFT", 10, -10)

        return Section
    end
end

do
    local Dialog = CreateFrame("Frame", "PetLeashOptionsPanel", UIParent)
    Dialog:SetSize(680, 680 * 0.85)
    Dialog:SetPoint("CENTER")
    Dialog:SetClampedToScreen(true)
    Dialog:SetFrameLevel(500)
    Dialog:SetFrameStrata("DIALOG")
    Dialog:SetMovable(true)
    Dialog:EnableMouse(true)
    Dialog:RegisterForDrag("LeftButton")

    -- Dialog:Hide()

    Dialog.Backdrop = CreateFrame("Frame", nil, Dialog, "BackdropTemplate")
    Dialog.Backdrop:SetAllPoints()
    Dialog.Backdrop:SetFrameLevel(Dialog:GetFrameLevel())
    Dialog.Backdrop:SetBackdrop({ bgFile = Media.Textures.Background, edgeFile = Media.Textures.Blank, edgeSize = Scale(1) })
    Dialog.Backdrop:SetBackdropBorderColor(0, 0, 0)

    Dialog:SetScript("OnDragStart", Dialog.StartMoving)
    Dialog:SetScript("OnDragStop", Dialog.StopMovingOrSizing)
    -- Dialog:SetScript("OnShow", OnShow)
    -- Dialog:SetScript("OnHide", OnHide)

    local Title = Dialog:CreateFontString(nil, "OVERLAY")
    Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
    Title:SetText("|cff33ff99PetLeash|r Options")
    Title:SetPoint("TOPLEFT", Dialog, "TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
    Version:SetTextColor(unpack(LabelColor))
    Version:SetText(format(L.VERSION, 4.01))
    Version:SetPoint("BOTTOMRIGHT", Dialog, "BOTTOMRIGHT", -7, 7)

    Dialog.CloseButton = CreateCloseButton(Dialog)
    Dialog.CloseButton:SetPoint("CENTER", Dialog, "TOPRIGHT", -15, -12)

    local General = CreateSection(GENERAL, Dialog)
    General:SetPoint("LEFT", Dialog, "LEFT", 20, -10)

    local Enable = CreateCheckBox(General, "Enable", {}, L.ENABLE_AUTO_SUMMON)
    Enable:SetPoint("TOPLEFT", General, "TOPLEFT", 10, -30)


    -- local function OnCombatEnd()
    --     if Dialog.RestoreAfterCombat then
    --         Dialog.RestoreAfterCombat = nil
    --         Dialog:Show()
    --     end
    -- end

    -- local function OnCombatStart()
    --     if Dialog:IsVisible() then
    --         Dialog:Hide()
    --     end

    --     Dialog.RestoreAfterCombat = true

    --     -- C.Print(L.OPTIONS_NOT_IN_COMBAT)

    --     EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnCombatEnd)
    -- end

    -- function Dialog:Toggle()
    --     if InCombatLockdown() then
    --         OnCombatStart()
    --         return
    --     end

    --     -- if C.IsEditModeActive() then
    --     --     C.Print(L.OPTIONS_NOT_IN_EDIT_MODE)
    --     --     return
    --     -- end

    --     Dialog:SetShown(not Dialog:IsVisible())
    -- end

    -- EventRegistry:RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", OnCombatStart)

    -- PetLeashOptionsPanel = Dialog
    -- tinsert(UISpecialFrames, "PetLeashOptionsPanel")
end