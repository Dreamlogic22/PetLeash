--[[--------------------------------------------------------------------

    PetLeash Options 4.01 (March 15, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeashOptions: TherapyAPI
local C = select(2, ...)

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

C.Title = GetAddOnMetadata(Name, "Title")
C.Version = GetAddOnMetadata(Name, "Version")
C.db = PetLeashDB

TherapyUX.Embed(C)

do
	---@return boolean
	function C.IsEditModeActive()
		return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
	end

	function C.Print(...)
		print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
	end
end

local function OnInitialize()
	SlashCmdList.PETLEASH = function() PetLeashOptionsDialog:Toggle() end

    if not C.IsEditModeActive() then
        -- Echo user's first slash command
        PetLeashOptionsDialog:Toggle()
	end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)