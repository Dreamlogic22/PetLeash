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
		print(strjoin("", "|cff33ff99PetLeash|r Options: ", ...))
	end
end

-- C.Options = {
--     childGroups = "tab",
--     name = WrapTextInColorCode("Version: ", "fffcfcfc") .. C.Version,
--     order = 0,
--     type = "group",
--     args = {}
-- }

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