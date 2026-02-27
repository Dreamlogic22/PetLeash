---@type string
local Name = ...
---@class PetLeashOptions
local C = select(2, ...)

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
	-- debug
	C_Timer.After(1, function()
		PetLeashOptionsPanel:Show()
	end)

	if PetLeashOptionsToggle then
		PetLeashOptionsToggle:SetScript("OnClick", function()
			PlaySound(856)
			PetLeashOptionsPanel:Toggle()
		end)
	end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)