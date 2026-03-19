--[[--------------------------------------------------------------------

    PetLeash Options 4.01 (March 19, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

---@class PetLeashOptions: TherapyAPI
local C = select(2, ...)
do
    C.Name = Name
    C.Title = GetAddOnMetadata(Name, "Title")
    C.Version = GetAddOnMetadata(Name, "Version")
    C.db = PetLeashDB

    TherapyUX.Embed(C)

    ---@return boolean
    function C.IsEditModeActive()
        return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
    end

	function C.NotifyChange()
		AceConfigRegistry:NotifyChange(C.Name)
	end

    function C.Print(...)
        print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
    end
end

local function OnInitialize()
    AceConfigRegistry:RegisterOptionsTable("PetLeash", C.Options)

    SlashCmdList.PETLEASH = function() PetLeashOptionsDialog:Toggle() end

    if not C.IsEditModeActive() and PetLeash.ShowDialog then
        -- Echo user's first slash command
        PetLeashOptionsDialog:Toggle()
	end

    PetLeash.ShowDialog = nil
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)