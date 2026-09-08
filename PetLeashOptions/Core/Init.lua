--[[--------------------------------------------------------------------

    PetLeash Options 4.02 (April 30, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local RefreshPetJournal = C_PetJournal.SetDefaultFilters

---@class PetLeashOptions
local C = select(2, ...)
do
	C.Name = Name
	C.Title = GetAddOnMetadata(Name, "Title")
	C.Version = GetAddOnMetadata(Name, "Version")
	C.db = PetLeashDB

	---@return boolean
	function C.IsEditModeActive()
		return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
	end

	function C.NotifyChange()
		if PetLeashOptionsDialog then
			PetLeashOptionsDialog.General:NotifyChange()
			PetLeashOptionsDialog.Carousel:Update()
		end
	end

	function C.Print(...)
		print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
	end

	function C.RefreshPetJournal()
		-- Hack to avoid PetJournal_UpdatePetList
		RefreshPetJournal()
	end
end

local function OnInitialize()
	SlashCmdList.PETLEASH = function()
		PetLeashOptionsDialog:Toggle()
	end

	if not C.IsEditModeActive() and PetLeash.ShowDialog then
		-- Echo user's first slash command
		PetLeashOptionsDialog:Toggle()
	end

	PetLeash.ShowDialog = nil
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)
