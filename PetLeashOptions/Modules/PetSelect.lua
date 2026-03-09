--[[------------------------------------------------------------------

    Hooks into the Blizzard Collections frame that allow a user
    to select pets they want to add or remove from the pool.

--------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)

local L, Media = PetLeash.Locale, PetLeash.Media

local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo
local SetDefaultFilters = C_PetJournal.SetDefaultFilters

local OptionsButton = PetLeashOptionsButton
local SelectingPets = false

-- List refreshed by setting default filter
local function ToggleSelectionMode()
	local active = SelectingPets
	OptionsButton:DesaturateHierarchy(active and 1 or 0)
end

local function AddHooks()
    hooksecurefunc("PetJournal_InitPetButton", function(button)
		if button.PetLeashCheckbox then return end

		local Checkbox = C.CreateCheckbox(button, nil, L.ADD_OR_REMOVE_PET)

		button.PetLeashCheckBox = Checkbox
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

local function OnInitialize()
	-- Respond to the action that brought us here
	if OptionsButton.LastClicked == "LeftButton" then
		SelectingPets = true
		ToggleSelectionMode()

		return
	end

	if OptionsButton.LastClicked == "RightButton" then
		SelectingPets = false
		ToggleSelectionMode()

		-- open options

		return
	end

	OptionsButton.LastClicked = nil

	OptionsButton:SetScript("OnClick", function(_, button)
		PlaySound(856)

		if button == "LeftButton" then
			SelectingPets = not SelectingPets
			ToggleSelectionMode()

			-- Hack to avoid PetJournal_UpdatePetList
			SetDefaultFilters()
		end

		if button == "RightButton" then
			if SelectingPets then
				SelectingPets = false
				ToggleSelectionMode()
			end

			-- open options
		end
	end)

	OptionsButton:SetScript("OnEnter", function(self)
        if not GameTooltip:IsForbidden() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
            GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
            GameTooltip:AddLine(SelectingPets and L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE or L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN, 1, 1, 1, true)
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

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)