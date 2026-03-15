--[[--------------------------------------------------------------------

    Primary settings panel opened by right-clicking the icon attached
    to the PetJournal.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, C.Media

local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetModelSceneInfoBySpeciesID = C_PetJournal.GetPetModelSceneInfoBySpeciesID
local GetPetStats = C_PetJournal.GetPetStats

local ControlDefinitions = {
    AutoSwitch = {
        disable = function() if #C.db.pets < 2 then C.db.autoSwitch = false; return true else return not C.db.enable end end,
        get = function() return C.db.autoSwitch end,
        name = L.OPTIONS_AUTO_SWITCH,
        set = function(value)
            C.db.autoSwitch = value
            T.RefreshVariables()
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
            T.RefreshVariables()
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
            T.RefreshVariables()
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
    local health, _, _, _, rarity = GetPetStats(petID)
    local speciesID, customName, _, _, _, displayID, _, name = GetPetInfoByPetID(petID)

    local colorData = ColorManager.GetColorDataForItemQuality(rarity - 1)

    ---@class PetCard: TherapyFrame
    local Panel = C.CreateFrame("Frame", nil, parent, "BackdropTemplate")
    Panel:SetSize(180, 230)
    Panel:SetFrameLevel(parent:GetFrameLevel() + 1)
    Panel:CreateBackdrop()
    Panel:SetBackdropColor(0.58, 0.49, 0.4, 0.2)
    Panel:SetBorderColor(colorData.r, colorData.g, colorData.b)

    Panel.RemoveButton = C.CreateFrame("Button", nil, Panel)
    Panel.RemoveButton:SetSize(14, 14)
    Panel.RemoveButton:SetPoint("TOPRIGHT", -6, -6)

    Panel.RemoveButton.Texture = Panel.RemoveButton:CreateTexture(nil, "OVERLAY")
    Panel.RemoveButton.Texture:SetTexture(Media.Textures.Close)
    Panel.RemoveButton.Texture:SetInside()

    Panel.RemoveButton:SetScript("OnClick", function()
        PlaySoundFile(567481)

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

    Panel.RemoveButton:SetScript("OnEnter", function(self)
        self.Texture:SetVertexColor(colorData.r, colorData.g, colorData.b)
    end)

    Panel.RemoveButton:SetScript("OnLeave", function(self)
        self.Texture:SetVertexColor(1, 1, 1)
    end)

    -- Sourced from Interface/AddOns/Blizzard_Collections/Shared/Blizzard_PetCollection.lua
    local loadoutModelSceneID = select(2, GetPetModelSceneInfoBySpeciesID(speciesID))

    Panel.ModelScene = CreateFrame("ModelScene", nil, Panel, "ModelSceneMixinTemplate")
    Panel.ModelScene:SetUsingParentLevel(true)
    Panel.ModelScene:SetSize(160, 180)
    Panel.ModelScene:SetPoint("TOP", 0, -10)

    Panel.ModelScene:TransitionToModelSceneID(loadoutModelSceneID, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_DISCARD, true)

    local PetActor = Panel.ModelScene:GetActorByTag("pet")
    if PetActor then
        PetActor:SetModelByCreatureDisplayID(displayID, true)
        PetActor:SetAnimationBlendOperation(Enum.ModelBlendOperation.None)

        if health <= 0 then
            PetActor:SetAnimation(6, 1)
        else
            PetActor:SetAnimation(0, -1)
        end
    end

    local Name = Panel:CreateFontString(nil, "OVERLAY")
    Name:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
    Name:SetPoint("BOTTOM", Panel, "BOTTOM", 0, 10)
    Name:SetText(customName or name or UNKNOWN)
    Name:SetTextColor(Media.Colors.Foreground:GetRGB())

    return Panel
end

do
    local MaxDisplay = 3
    local Panels = {}

    function C.UpdatePetCards()
        for _, panel in ipairs(Panels) do
            panel:Hide()
            panel:SetParent(nil)
        end

        wipe(Panels)

        for i = 1, math.min(MaxDisplay, #C.db.pets) do
            local petID = C.db.pets[i]
            local panel = CreateCard(PetLeashOptionsDialog.PetCards, petID)

            if i == 1 then
                panel:SetPoint("LEFT", PetLeashOptionsDialog.PetCards, "LEFT", 20, 0)
            else
                panel:SetPoint("LEFT", Panels[i - 1], "RIGHT", 25, 0)
            end

            Panels[i] = panel
        end

        if #T.db.pets > MaxDisplay then
            local Remaining = #C.db.pets - MaxDisplay
            local MoreText = PetLeashOptionsDialog:CreateFontString(nil, "OVERLAY")

            MoreText:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
            MoreText:SetPoint("BOTTOMRIGHT", PetLeashOptionsDialog.PetCards, "BOTTOMRIGHT", -20, 5)
            MoreText:SetText(string.format(L.OPTIONS_MORE_PETS, Remaining))
            MoreText:SetTextColor(1, 1, 1)
        end
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
    Dialog:SetScript("OnEvent", function(self, event, inCombat)
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