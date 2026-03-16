--[[--------------------------------------------------------------------

    Primary settings panel opened by right-clicking the icon attached
    to the PetJournal.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, C.Media

local GetPetModelSceneInfoBySpeciesID = C_PetJournal.GetPetModelSceneInfoBySpeciesID

local ControlDefinitions = {
    AutoSwitch = {
        disable = function() if #C.db.pets < 2 then C.db.autoSwitch = false; return true else return not C.db.enable end end,
        get = function() return C.db.autoSwitch end,
        name = L.OPTIONS_AUTO_SWITCH,
        set = function(value)
            C.db.autoSwitch = value
            T.LoadVariables()
        end,
        type = "toggle"
    },
    AutoSwitchInterval = {
        disable = function() return (not C.db.autoSwitch or not C.db.enable) end,
        get = function() return C.db.autoSwitchInterval / 60 end,
        min = 1, max = 30, step = 1,
        name = L.OPTIONS_AUTO_SWITCH_INTERVAL,
        set = function(value)
            C.db.autoSwitchInterval = value * 60
            T.LoadVariables()
        end,
        type = "range"
    },
    Enable = {
        desc = L.OPTIONS_SCAN_TOOLTIP,
        get = function() return C.db.enable end,
        name = ENABLE,
        set = function(value) C.db.enable = value end,
        type = "toggle",
    },
    ScanInterval = {
        disable = function() return not C.db.enable end,
        get = function() return C.db.scanInterval end,
        min = 1, max = 120, step = 1,
        name = L.OPTIONS_SCAN_INTERVAL,
        set = function(value)
            C.db.scanInterval = value
            T.LoadVariables()
        end,
        type = "range"
    },
    KeepSummonedPets = {
        desc = L.OPTIONS_KEEP_SUMMONED_TOOLTIP,
        disable = function() return not C.db.enable end,
        get = function() return C.db.keepSummonedPets end,
        name = L.OPTIONS_KEEP_SUMMONED,
        set = function(value) C.db.keepSummonedPets = value end,
        type = "toggle"
    }
}

---@param parent TherapyGroup
---@param petID string
---@return PetCard
local function CreateCard(parent, petID)
    local cardInfo = C.GetPetCardInfo(petID)

    ---@class PetCard: TherapyFrame
    local Card = C.CreateFrame("Frame", nil, parent, "BackdropTemplate")
    Card:SetSize(180, 230)
    Card:SetFrameLevel(parent:GetFrameLevel() + 1)
    Card:CreateBackdrop()
    Card:SetBackdropColor(0.58, 0.49, 0.4, 0.2)
    Card:SetBorderColor(cardInfo:GetRGB())

    Card.RemoveButton = C.CreateRemoveButton(Card)
    Card.RemoveButton:SetPoint("TOPRIGHT", -2, -1)

    Card.RemoveButton:HookScript("OnClick", function()
        for i, id in ipairs(C.db.pets) do
            if id == petID then
                tremove(C.db.pets, i)
                break
            end
        end

        if not C.db.pets or #C.db.pets == 0 then
            T.Disable()
        end

        if #C.db.pets < 2 then
            C.db.autoSwitch = false
            PetLeashOptionsDialog.General:NotifyChange()
        end

        if PetJournal:IsVisible() then
            C_PetJournal.SetDefaultFilters()
        end

        C.UpdatePetCards()
    end)

    -- Sourced from Interface/AddOns/Blizzard_Collections/Shared/Blizzard_PetCollection.lua
    local loadoutModelSceneID = select(2, GetPetModelSceneInfoBySpeciesID(cardInfo.SpeciesID))

    Card.ModelScene = CreateFrame("ModelScene", nil, Card, "ModelSceneMixinTemplate")
    Card.ModelScene:SetUsingParentLevel(true)
    Card.ModelScene:SetSize(160, 180)
    Card.ModelScene:SetPoint("TOP", 0, -10)

    Card.ModelScene:TransitionToModelSceneID(loadoutModelSceneID, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_DISCARD, true)

    local PetActor = Card.ModelScene:GetActorByTag("pet")
    if PetActor then
        PetActor:SetModelByCreatureDisplayID(cardInfo.DisplayID, true)
        PetActor:SetAnimationBlendOperation(Enum.ModelBlendOperation.None)

        if cardInfo.IsDead then
            PetActor:SetAnimation(6, 1)
        else
            PetActor:SetAnimation(0, -1)
        end
    end

    local Name = Card:CreateFontString(nil, "OVERLAY")
    Name:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
    Name:SetPoint("BOTTOM", Card, "BOTTOM", 0, 10)
    Name:SetText(cardInfo.CustomName or cardInfo.Name or UNKNOWN)
    Name:SetTextColor(Media.Colors.Foreground:GetRGB())

    Card.SlideAnimation = Card:CreateAnimationGroup()
    Card.SlideTranslation = Card.SlideAnimation:CreateAnimation("Translation")
    Card.SlideTranslation:SetDuration(0.4)
    Card.SlideTranslation:SetSmoothing("IN_OUT")

    return Card
end

-- Animation block
do
    local MaxDisplay = 3
    local Panels = {}
    local CurrentIndex = 1
    local CardsCurrentlyAnimating = 0

    local function UpdateVisibleCards()
        for _, panel in ipairs(Panels) do
            panel:Hide()
        end

        -- Show and position the 3-card window starting at CurrentIndex
        for i = 1, MaxDisplay do
            local panelIndex = CurrentIndex + i - 1
            if Panels[panelIndex] then
                Panels[panelIndex]:ClearAllPoints()
                Panels[panelIndex]:Show()

                if i == 1 then
                    Panels[panelIndex]:SetPoint("LEFT", PetLeashOptionsDialog.PetCards, "LEFT", 25, 0)
                else
                    Panels[panelIndex]:SetPoint("LEFT", Panels[CurrentIndex + i - 2], "RIGHT", 25, 0)
                end
            end
        end

        -- Update arrow states
        PetLeashOptionsDialog.LeftArrow:SetEnabled(CurrentIndex > 1)
        PetLeashOptionsDialog.RightArrow:SetEnabled(CurrentIndex + MaxDisplay - 1 < #Panels)
    end

    function C.UpdatePetCards()
        for _, panel in ipairs(Panels) do
            panel:Hide()
            panel:SetParent(nil)
        end

        wipe(Panels)

        for i = 1, #C.db.pets do  -- Create ALL cards
            local petID = C.db.pets[i]
            local panel = CreateCard(PetLeashOptionsDialog.PetCards, petID)
            Panels[i] = panel
        end

        CurrentIndex = 1  -- Reset to first card
        UpdateVisibleCards()  -- Show and position first 3
    end

    function C.SetupArrowHandlers()
        PetLeashOptionsDialog.LeftArrow:SetScript("OnClick", function(self)
            if CurrentIndex > 1 and CardsCurrentlyAnimating == 0 then
                StartAnimation(-1)
                PlaySound(856)
            end
        end)

        PetLeashOptionsDialog.RightArrow:SetScript("OnClick", function()
            if CurrentIndex + MaxDisplay - 1 < #Panels and CardsCurrentlyAnimating == 0 then
                StartAnimation(1)
                PlaySound(856)
            end
        end)
    end
end

do
    ---@class PetLeashOptionsDialog: TherapyFrame
    local Dialog = C.CreateFrame("Frame", "PetLeashOptionsDialog", UIParent)
    Dialog:SetSize(680, 580)
    Dialog:SetPoint("CENTER")
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
    Title:SetPoint("TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
    Version:SetTextColor(Media.Colors.Background:GetRGB())
    Version:SetText(format(L.VERSION, C.Version))
    Version:SetPoint("BOTTOMRIGHT", -7, 7)

    Dialog.CloseButton = C.CreateCloseButton(Dialog)
    Dialog.CloseButton:SetPoint("CENTER", Dialog, "TOPRIGHT", -15, -12)

    Dialog.General = C.CreateOptionsGroup(GENERAL, Dialog, 640, 200)
    Dialog.General:SetPoint("TOPLEFT", 20, -50)

    Dialog.Enable = Dialog.General:RegisterControl(ControlDefinitions.Enable)
    Dialog.Enable:SetPoint("TOPLEFT", 10, -30)
    Dialog.ScanInterval = Dialog.General:RegisterControl(ControlDefinitions.ScanInterval)
    Dialog.ScanInterval:SetPoint("LEFT", Dialog.Enable, "RIGHT", 230, 0)

    Dialog.AutoSwitch = Dialog.General:RegisterControl(ControlDefinitions.AutoSwitch)
    Dialog.AutoSwitch:SetPoint("TOP", Dialog.Enable, "BOTTOM", 0, 0)
    Dialog.AutoSwitchInterval = Dialog.General:RegisterControl(ControlDefinitions.AutoSwitchInterval)
    Dialog.AutoSwitchInterval:SetPoint("LEFT", Dialog.AutoSwitch, "RIGHT", 230, 0)

    Dialog.KeepSummonedPets = Dialog.General:RegisterControl(ControlDefinitions.KeepSummonedPets)
    Dialog.KeepSummonedPets:SetPoint("TOP", Dialog.AutoSwitch, "BOTTOM", 0, 0)

    Dialog.General:NotifyChange()

    Dialog.PetCards = C.CreateGroup(PETS, Dialog, 640, 290)
    Dialog.PetCards:SetPoint("BOTTOMLEFT", 20, 30)

    Dialog.LeftArrow = C.CreateBackArrowButton(Dialog.PetCards)
    Dialog.LeftArrow:SetPoint("LEFT", Dialog.PetCards, "LEFT", 0, 0)

    Dialog.RightArrow = C.CreateForwardArrowButton(Dialog.PetCards)
    Dialog.RightArrow:SetPoint("RIGHT", Dialog.PetCards, "RIGHT", 0, 0)

    C.UpdatePetCards()

    function Dialog:Toggle()
        if PlayerIsInCombat() then
            if self:IsVisible() then
                self:Hide()
            end

            self.RestoreAfterCombat = true
            C.Print(L.OPTIONS_NOT_IN_COMBAT)
            return
        end

        if C.IsEditModeActive() then
            C.Print(L.OPTIONS_NOT_IN_EDIT_MODE)
            return
        end

        self:SetShown(not self:IsVisible())
    end

    Dialog:RegisterEvent("PLAYER_IN_COMBAT_CHANGED")
    Dialog:SetScript("OnEvent", function(self, _, inCombat)
        if inCombat then
            if self:IsVisible() then
                self.RestoreAfterCombat = true
                self:Hide()
            end
        else
            if self.RestoreAfterCombat then
                self.RestoreAfterCombat = nil
                self:Show()
            end
        end
    end)

    PetLeashOptionsDialog = Dialog
    tinsert(UISpecialFrames, "PetLeashOptionsDialog")
end