--[[--------------------------------------------------------------------

    Hooks into the Blizzard Collections frame that allow a user
    to select pets they want to add or remove from the pool.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L = T.Locale

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

local function OnPetJournalLoad()
    if PlayerIsInCombat() then
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnPetJournalLoad)
        return
    end

    local OptionsButton = PetLeashOptionsButton
    OptionsButton:SetParent(PetJournal)
    OptionsButton:SetPoint("CENTER", PetJournal, "RIGHT", 0, 0)
    OptionsButton:Show()

    hooksecurefunc("PetJournal_InitPetButton", function(button)
        AddCheckbox(button)
    end)

    -- Hide checkboxes for unowned & faction-locked pets
    hooksecurefunc(PetJournal.ScrollBox, "Update", function(frame)
        frame:ForEachFrame(function(button)
            if not OptionsButton.SelectingPets then
                if button.PetLeashCheckbox:IsVisible() then
                    button.PetLeashCheckbox:Hide()
                end

                return
            end

            -- unowned
            button.PetLeashCheckbox:SetShown(button.owned)

            -- faction-locked
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