---@type string
local Name = ...
---@class PetLeashOptions
local C = select(2, ...)

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

C.Title = GetAddOnMetadata(Name, "Title")
C.Version = GetAddOnMetadata(Name, "Version")

---@return boolean
function C.IsEditModeActive()
	return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
end

function C.Print(...)
	print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
end

local function OnInitialize()
	-- do very important shit
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)