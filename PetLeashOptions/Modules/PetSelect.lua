--[[------------------------------------------------------------------

    Hooks into the Blizzard Collections frame that allow a user
    to select pets they want to add or remove from the pool.

--------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media, PetUtil = T.Locale, C.Media, T.PetUtil

local SetDefaultFilters = C_PetJournal.SetDefaultFilters

local OptionsButton = PetLeashOptionsButton
local OptionsDialog = PetLeashOptionsDialog

local SelectingPets = false

---@param petID number
local function AddPet(petID)
    if not petID then return end

    if not C.db.pets then
        C.db.pets = {}
    end

    if C.db.pets and tContains(C.db.pets, petID) then
        return
    end

    table.insert(C.db.pets, petID)

    -- If this is our first pet on a fresh install, enable
    if not T.IsEnabled then
        T.Enable()
    end

    if #C.db.pets >= 2 then
        -- TODO: change this to notifyupdate
        C.db.autoSwitch = true
    end

    if PetLeashOptionsDialog:IsVisible() then
        PetLeashOptionsDialog.General:NotifyChange()
        C.UpdatePetCards()
    end
end

---@param petID number
local function IsSelected(petID)
    if not petID or not C.db.pets then
        return false
    end

    for _, id in ipairs(C.db.pets) do
        if id == petID then return true end
    end

    return false
end

---@param petID number
local function RemovePet(petID)
    if not petID or not C.db.pets then return end

    for i, id in ipairs(C.db.pets) do
        if id == petID then
            table.remove(C.db.pets, i)
            break
        end
    end

    if not C.db.pets or #C.db.pets == 0 then
        if T.IsEnabled then
            T.Disable()
        end
    end

    if PetLeashOptionsDialog:IsVisible() then
        PetLeashOptionsDialog.General:NotifyChange()
        C.UpdatePetCards()
    end
end

local function ToggleSelectionMode()
	local active = SelectingPets
	OptionsButton:DesaturateHierarchy(active and 1 or 0)

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
    local Exclusions = {
        [117] = true,   -- Tiny Snowman
        [119] = true,   -- Father Winter's Helper
        [120] = true,   -- Winter's Little Helper
        [1349] = true   -- Rotten Little Helper
    }

    -- Pets that have bugged GetPetSummonInfo
    if UnitFactionGroup("player") == "Alliance" then
        Exclusions[2777] = true -- Gillvanas
        Exclusions[342] = true  -- Festival Lantern
        Exclusions[332] = true  -- Horde Balloon
    else
        Exclusions[2778] = true -- Finduin
        Exclusions[341] = true  -- Lunar Lantern
        Exclusions[331] = true  -- Alliance Balloon
    end

    ---@param petID number
    ---@return boolean
    local function IsPetIneligible(petID)
        local speciesID = PetUtil.GetSpecies(petID)
        if Exclusions[speciesID] then
            return true
        end

        return false
    end

    local function OnPetJournalLoad()
        PetLeashOptionsButton:SetParent(PetJournal)
        PetLeashOptionsButton:SetPoint("CENTER", PetJournal, "RIGHT", 0, 0)

        PetLeashOptionsDialog:ClearAllPoints()
        PetLeashOptionsDialog:SetPoint("LEFT", CollectionsJournal, "RIGHT", 50, 0)
        PetLeashOptionsDialog:SetPoint("TOP", CollectionsJournal, "TOP")

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
                    local _, error = PetUtil.CanSummon(button.petID)
                    local neverUsable = IsPetIneligible(button.petID) or (error == Enum.PetJournalError.InvalidFaction)

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
end