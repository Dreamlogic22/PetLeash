--[[--------------------------------------------------------------------

    Hooks into the Blizzard Collections frame that allow a user
    to select pets they want to add or remove from the pool.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L, Media = T.Locale, T.Media

local OptionsLoaded = false
local SelectingPets = false

local CreateCheckBox = T.CreateCheckBox
local DisablePixelSnap = T.DisablePixelSnap
local SetInside = T.SetInside

local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo

---@param petId number
local function IsSelected(petId)
    if not petId or not T.db.pets then
        return false
    end

    for _, id in ipairs(T.db.pets) do
        if id == petId then return true end
    end

    return false
end

---@param petId number
local function AddPet(petId)
    if not petId then return end

    if not T.db.pets then
        T.db.pets = {}
    end

    if T.db.pets and tContains(T.db.pets, petId) then
        return
    end

    if #T.db.pets == 0 then
        -- If this is our first pet on a fresh install, enable
        T.Enable()
    end

    table.insert(T.db.pets, petId)
end

---@param petId number
local function RemovePet(petId)
    if not petId or not T.db.pets then return end

    for i, id in ipairs(T.db.pets) do
        if id == petId then
            table.remove(T.db.pets, i)
            return
        end
    end

    if not T.db.pets or #T.db.pet == 0 then
        T.Disable()
    end
end

local CreateOptionsButton
do
    local function LoadOptions()
        if OptionsLoaded then return end

        if InCombatLockdown() then
            T.Print(L.OPTIONS_NOT_IN_COMBAT)
            EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", LoadOptions)
            return
        end

        local loaded, reason = C_AddOns.LoadAddOn("PetLeashOptions")
        if not loaded then
            T.Print(L.OPTIONS_LOAD_ERROR, reason or UNKNOWN)
            return
        else
            OptionsLoaded = true
        end
    end

    ---@param button MouseButton
    local function OnClick(self, button)
        PlaySound(856)

        if button == "LeftButton" then
            SelectingPets = not SelectingPets

            self.Notification:SetShown(SelectingPets)

            -- extremely expensive call
            PetJournal_UpdatePetList()
        end

        if button == "RightButton" and not SelectingPets then
            LoadOptions()
        end
    end

    ---@param self PetLeashOptionsButton
    local function ShowTooltip(self)
        if not GameTooltip:IsForbidden() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
            GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
            GameTooltip:AddLine(SelectingPets and L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE or L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:AddLine(OptionsLoaded and L.PET_SELECTION_INSTRUCTIONS_OPTIONS_OPEN or L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end

    ---@param parent Frame
    ---@return PetLeashOptionsButton
    CreateOptionsButton = function(parent)
        ---@class PetLeashOptionsButton: Button
        local OptionsButton = CreateFrame("Button", "PetLeashOptionsToggle", parent)
        OptionsButton:SetSize(48, 48)
        OptionsButton:SetFrameStrata("HIGH")
        OptionsButton:SetFrameLevel(10)
        OptionsButton:SetPoint("CENTER", parent, "RIGHT", 0, 0)

        local Texture = Media.Textures.Paw
        OptionsButton:SetNormalTexture(Texture)
        OptionsButton:SetHighlightTexture(Texture)
        OptionsButton:SetPushedTexture(Texture)

        local Normal, Highlight, Pushed = OptionsButton:GetNormalTexture(), OptionsButton:GetHighlightTexture(), OptionsButton:GetPushedTexture()

        if Normal then
            DisablePixelSnap(Normal)
            SetInside(Normal)
        end

        if Highlight then
            Highlight:SetBlendMode("ADD")
            Highlight:SetAlpha(0.25)
            DisablePixelSnap(Highlight)
            SetInside(Highlight)
        end

        if Pushed then
            Pushed:SetBlendMode("BLEND")
            Pushed:SetVertexColor(0.9, 0.9, 0.9)
            DisablePixelSnap(Pushed)
        end

        OptionsButton.Notification = OptionsButton:CreateTexture(nil, "OVERLAY")
        OptionsButton.Notification:SetAtlas("UI-HUD-MicroMenu-Communities-Icon-Notification")
        OptionsButton.Notification:SetSize(21, 21)
        OptionsButton.Notification:SetPoint("CENTER", OptionsButton, "CENTER", 0, 0)
        OptionsButton.Notification:Hide()

        OptionsButton:RegisterForClicks("AnyDown")

        OptionsButton:SetScript("OnClick", OnClick)
        OptionsButton:SetScript("OnEnter", ShowTooltip)
        OptionsButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        return OptionsButton
    end
end

local AddCheckbox
do
    ---@class PetJournalButton: Button
    ---@field petID number
    ---@field owned boolean

    ---@param button PetJournalButton
    AddCheckbox = function(button)
        if not button.petID then return end

        if not button.PetLeashCheckbox then
            button.PetLeashCheckbox = CreateCheckBox(button)
            button:SetSize(24, 24)
            button:SetPoint("RIGHT", PetJournal, "RIGHT", -15, 0)

            button.PetLeashCheckbox:SetScript("OnClick", function(self)
                local id = button.petID
                if self:GetChecked() then
                    self.CheckedTexture:Show()
                    PlaySound(857)
                    AddPet(id)
                else
                    self.CheckedTexture:Hide()
                    PlaySound(856)
                    RemovePet(id)
                end
            end)

            button.PetLeashCheckbox:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash|r"))
                GameTooltip:AddLine(L.ADD_OR_REMOVE_PET, 1, 1, 1, true)
                GameTooltip:Show()
            end)

            button.PetLeashCheckbox:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end

        local IsChecked = IsSelected(button.petID)
        button.PetLeashCheckbox:SetChecked(IsChecked)
        if IsChecked then
            button.PetLeashCheckbox.CheckedTexture:Show()
        else
            button.PetLeashCheckbox.CheckedTexture:Hide()
        end
    end
end

local function OnPetJournalLoad()
    PetLeashOptionsToggle = CreateOptionsButton(PetJournal)

    hooksecurefunc("PetJournal_InitPetButton", function(button)
        AddCheckbox(button)
    end)

    -- Hide checkbox for unowned & faction-locked pets
    hooksecurefunc(PetJournal.ScrollBox, "Update", function(frame)
        if PlayerIsInCombat() then return end

        frame:ForEachFrame(function(button)
            if not SelectingPets then
                if button.PetLeashCheckbox:IsVisible() then
                    button.PetLeashCheckbox:Hide()
                end

                return
            end

            button.PetLeashCheckbox:SetShown(button.owned)

            if button.petID then
                local _, error = GetPetSummonInfo(button.petID)
                local neverUsable = error == Enum.PetJournalError.InvalidFaction

                if neverUsable then
                    button.PetLeashCheckbox:Hide()
                else
                    button.PetLeashCheckbox:Show()
                end
            end
        end)
    end)
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", OnPetJournalLoad)