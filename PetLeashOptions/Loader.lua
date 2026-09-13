--[[------------------------------------------------------------------

    Loads options using slash commands.  If the Blizzard Collections
    are loaded, options will automatically load due to a TOC
    directive.

--------------------------------------------------------------------]]

---@class PetLeash
local T = PetLeash
local L = T.Locale

local function LoadOptions()
	if PlayerIsInCombat() then
		T.Print(L.OPTIONS_NOT_IN_COMBAT)
		Toolkit.RegisterEventOnce("PLAYER_REGEN_ENABLED", LoadOptions)
		return
	end

	---@type boolean
	T.ShowDialog = true

	local loaded, reason = C_AddOns.LoadAddOn("PetLeashOptions")
	if not loaded then
		T.Print(L.OPTIONS_LOAD_ERROR, reason or UNKNOWN)
		return
	end
end

SLASH_PETLEASH1 = "/petleash"
SLASH_PETLEASH2 = "/pl"
SlashCmdList["PETLEASH"] = LoadOptions
