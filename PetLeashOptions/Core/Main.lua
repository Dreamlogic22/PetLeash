---@type string
local Name = ...
---@class PetLeashOptions
local C = select(2, ...)

local L, Media = PetLeash.Locale, PetLeash.Media

local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo
local SetDefaultFilters = C_PetJournal.SetDefaultFilters

local OptionsButton = PetLeashOptionsButton
local SelectingPets = false

do
	---@return boolean
	function C.IsEditModeActive()
		return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
	end

	function C.Print(...)
		print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
	end
end

-- List refreshed by setting default filter
local function ToggleSelectionMode()
	local active = SelectingPets
	OptionsButton:DesaturateHierarchy(active and 1 or 0)

	local r, g, b
	if active then
		r, g, b = Media.Colors.Foreground:GetRGB()
	else
		r, g, b = 1, 1, 1
	end

	OptionsButton:GetNormalTexture():SetVertexColor(r, g, b)
end

local function AddHooks()
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

local function OnInitialize()
	-- AddHooks()

	if OptionsButton.LastClicked == "LeftButton" then
		SelectingPets = true
		ToggleSelectionMode()
	elseif OptionsButton.LastClicked == "RightButton" then
		SelectingPets = false
		ToggleSelectionMode()

		-- open options
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