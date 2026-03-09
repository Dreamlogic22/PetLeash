--[[------------------------------------------------------------------

    Loads options addon using a paw icon attached to the pet journal.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L, Media = T.Locale, T.Media

local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo

local CreateCheckBox = T.CreateCheckBox

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

local AddCheckbox
do
    ---@class PetJournalButton: Button
    ---@field petID number
    ---@field owned boolean

    ---@param button PetJournalButton
    AddCheckbox = function(button)
        if not button.petID then return end

        if not button.PetLeashCheckbox then
            button.PetLeashCheckbox = CreateCheckBox(button, nil, L.ADD_OR_REMOVE_PET)
            button.PetLeashCheckbox:SetPoint("RIGHT", button, "RIGHT", -15, 0)

            button.PetLeashCheckbox:HookScript("OnClick", function(self)
                local id = button.petID
                if self:GetChecked() then
                    AddPet(id)
                else
                    RemovePet(id)
                end
            end)

            local IsChecked = IsSelected(button.petID)
            button.PetLeashCheckbox:SetChecked(IsChecked)
            if IsChecked then
                button.PetLeashCheckbox.CheckedTexture:Show()
            else
                button.PetLeashCheckbox.CheckedTexture:Hide()
            end
        end
    end
end

local SetDefaultFilters = C_PetJournal.SetDefaultFilters

local function LoadOptions()
    if PlayerIsInCombat() then
        T.Print(L.OPTIONS_NOT_IN_COMBAT)
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", LoadOptions)
        return
    end

    local loaded, reason = C_AddOns.LoadAddOn("PetLeashOptions")
    if not loaded then
        T.Print(L.OPTIONS_LOAD_ERROR, reason or UNKNOWN)
        return
    end
end

do
    ---@param self PetLeashOptionsButton
    ---@param button MouseButton
    local function OnClick(self, button)
        PlaySound(856)

        if button == "LeftButton" then
            self.SelectingPets = not self.SelectingPets

            self:ToggleSelectionMode()

            -- hack to avoid PetJournal_UpdatePetList
            SetDefaultFilters()
        end

        if button == "RightButton" and not self.SelectingPets then
            LoadOptions()
        end
    end

    ---@class PetLeashOptionsButton: Button
    local Button = CreateFrame("Button", "PetLeashOptionsButton", PetJournal)
    Button:SetSize(48, 48)
    Button:SetFrameStrata("HIGH")
    Button:SetFrameLevel(10)
    Button:SetPoint("CENTER", PetJournal, "RIGHT", 0, 0)

    T.SetupButtonTextures(Button, Media.Textures.Paw)

    Button:RegisterForClicks("AnyDown")

    Button:SetScript("OnClick", OnClick)

    Button:SetScript("OnEnter", function(self)
        if not GameTooltip:IsForbidden() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
            GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
            GameTooltip:AddLine(self.SelectingPets and L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE or L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)

    Button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    Button:SetScript("OnHide", function(self)
        if self.SelectingPets then
            self.SelectingPets = false
            self:ToggleSelectionMode()
        end
    end)

    PetLeashOptionsButton = Button
end

local function OnPetJournalLoad()
    
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", OnPetJournalLoad)