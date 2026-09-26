--[[------------------------------------------------------------------

    Special flags, pets or items that prevent automatic summoning and
    can dismiss summoned pets under certain circumstances (such as
    stealth).

    This module is not complete.

	Children's Week, Brewfest, and stealth have been tested.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local ConditionsUtil = T.ConditionsUtil
local PetUtil = T.PetUtil

local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local ShouldAurasBeSecret = C_Secrets.ShouldAurasBeSecret

local ActiveConditions = {
	auras = {},
	items = {},
	quests = {},
	zones = {},
}

local function CheckStealth()
	if PetUtil.HasPet() and IsStealthed() then
		PetUtil.Dismiss()
	end
end

---@param shouldDisable boolean
local function HandleConditions(shouldDisable)
	if shouldDisable then
		if T.IsEnabled then
			T.Disable()
		end
	else
		if not T.IsEnabled then
			T.Enable()
		end
	end
end

local function EvaluateConditions()
	local shouldDisable = false

	if #ActiveConditions.auras > 0 and not ShouldAurasBeSecret() then
		for _, id in ipairs(ActiveConditions.auras) do
			if GetPlayerAuraBySpellID(id) then
				shouldDisable = true
				break
			end
		end
	end

	HandleConditions(shouldDisable)
end

local function LoadConditions()
	if ConditionsUtil.IsChildrensWeek() then
		ConditionsUtil.UpdateChildrensWeek(ActiveConditions)

		EvaluateConditions()

		for _, event in pairs({ "QUEST_ACCEPTED", "QUEST_TURNED_IN" }) do
			Toolkit.RegisterEventCallback(event, EvaluateConditions)
		end
	end

	Toolkit.RegisterEventCallback("UPDATE_STEALTH", CheckStealth)
end

Toolkit.RegisterEventCallbackOnce("PLAYER_ENTERING_WORLD", LoadConditions)
