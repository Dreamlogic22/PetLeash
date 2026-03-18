--[[--------------------------------------------------------------------

    PetLeash Options 4.01 (March 18, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
local T = PetLeash

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

    function C.Print(...)
        print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
    end
end

local function OnInitialize()
    print("In options, :OnInitialize")

    local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

    C.Options = {
        childGroups = "tab",
        name = "",
        order = 0,
        type = "group",
        args = {}
    }

    AceConfigRegistry:RegisterOptionsTable("PetLeash", C.Options)

    SlashCmdList.PETLEASH = function() PetLeashOptionsDialog:Toggle() end

    if not C.IsEditModeActive() and T.ShowDialog then
        -- Echo user's first slash command
        PetLeashOptionsDialog:Toggle()
	end

    -- Always clear the slash-command flag
    T.ShowDialog = nil
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)