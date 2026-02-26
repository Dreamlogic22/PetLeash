---@type string
local Name = ...
---@class PetLeashOptions
local C = select(2, ...)

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

do
	function C.NotifyChange()
		AceConfigRegistry:NotifyChange(Name)
	end

	function C.Print(...)
		print(strjoin("", "|cff00b3ff", "Pet Leash|r Options: ", ...))
	end
end

C.Options = {
    childGroups = "tab",
    name = WrapTextInColorCode("Version: ", "fffcfcfc") .. C.Version,
    order = 0,
    type = "group",
    args = {}
}

local function OnInitialize()
	AceConfig:RegisterOptionsTable(Name, C.Options)
    LibStub("AceConfigDialog-3.0"):Open(Name)
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)