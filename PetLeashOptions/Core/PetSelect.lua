--[[------------------------------------------------------------------

    Hooks into the Blizzard Collections frame that allow a user
    to select pets they want to add or remove from the pool.

--------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo
local SetDefaultFilters = C_PetJournal.SetDefaultFilters

local OptionsButton = PetLeashOptionsButton
local OptionsDialog = PetLeashOptionsDialog

local SelectingPets = false

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
local function RemovePet(petId)
    if not petId or not T.db.pets then return end

    for i, id in ipairs(T.db.pets) do
        if id == petId then
            table.remove(T.db.pets, i)
            return
        end
    end

    if not T.db.pets or #T.db.pets == 0 then
        T.Disable()
    end
end

local function ToggleSelectionMode()
	local active = SelectingPets
	OptionsButton:DesaturateHierarchy(active and 1 or 0)

    if OptionsDialog:IsVisible() then
        OptionsDialog:Hide()
    end

    if GameTooltip:IsShown() then
        OptionsButton:GetScript("OnEnter")(OptionsButton)
    end

    -- Hack to avoid PetJournal_UpdatePetList
	SetDefaultFilters()
end

do
    OptionsButton:HookScript("OnClick", function(_, button)
		if button == "LeftButton" then
			SelectingPets = not SelectingPets
			ToggleSelectionMode()
		end

		if button == "RightButton" then
			if SelectingPets then
				SelectingPets = false
				ToggleSelectionMode()
			end

			OptionsDialog:SetShown(not OptionsDialog:IsVisible())
		end
	end)

    OptionsButton:SetScript("OnEnter", function(self)
        if not GameTooltip:IsForbidden() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
            GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
            GameTooltip:AddLine(SelectingPets and L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE or L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN, 1, 1, 1, true)

            if not SelectingPets then
                GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN, 1, 1, 1, true)
            end

            GameTooltip:Show()
        end
    end)

    OptionsButton:SetScript("OnHide", function()
        if SelectingPets then
            SelectingPets = false
			ToggleSelectionMode()
        end
    end)
end

do
    hooksecurefunc("PetJournal_InitPetButton", function(button)
        if not button.PetLeashCheckbox then
            ---@type TherapyCheckbox
            local Checkbox = C.CreateCheckbox(button, nil, L.ADD_OR_REMOVE_PET)
            Checkbox:SetPoint("RIGHT", button, "RIGHT", -15, 0)

            Checkbox:HookScript("OnClick", function(self)
                local id = button.petID
                if self:GetChecked() then
                    AddPet(id)
                else
                    RemovePet(id)
                end
            end)

            button.PetLeashCheckbox = Checkbox
        end

        local IsChecked = IsSelected(button.petID)
        button.PetLeashCheckbox:SetChecked(IsChecked)
        if IsChecked then
            button.PetLeashCheckbox.CheckedTexture:Show()
        else
            button.PetLeashCheckbox.CheckedTexture:Hide()
        end
    end)

    -- Hide checkbox for unowned & faction-locked pets
    hooksecurefunc(PetJournal.ScrollBox, "Update", function(frame)
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