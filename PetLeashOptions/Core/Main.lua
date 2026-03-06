---@type string
local Name = ...
---@class PetLeashOptions
local C = select(2, ...)

local L, Media = PetLeash.Locale, PetLeash.Media

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

		---@param self PetLeashOptionsButton
		PetLeashOptionsToggle:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
			GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
			GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_OPTIONS_OPEN, 1, 1, 1, true)
			GameTooltip:Show()
		end)
	end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)