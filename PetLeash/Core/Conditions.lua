--[[------------------------------------------------------------------

    Special flags, pets or items that prevent automatic summoning and
    can dismiss summoned pets under certain circumstances (such as
    stealth).

    This is currently supports: stealth, Children's Week.

    Brewfest is not active at this time, and I am not leveling an
    alt, so I have not tested the other conditions.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local GetItemCount = C_Item.GetItemCount

local ConditionsUtil = T.ConditionsUtil
local PetUtil = T.PetUtil

local ForceDisable = false

---@class Conditions
local ActiveConditions = {
	items = {},
	quests = {},
	spells = {},
	zones = {},
}

local Auras = {
	312993, -- Forbidden Tomes (Revendreth)
	43880, -- Ramstein's Swift Work Ram
	43883, -- Rental Racing Ram
}

local Items = {
	30803, -- Felhound Whistle,
	31815, -- Zeppit's Crystal
	32834, -- Nether Ray Cage
	34971, -- Warsong Flare Gun
	36936, -- Golem Control Unit
}

local Quests = {
	11878, -- Orphaned Mammoth Calf
	26831, -- Twilight Flight
	25371, -- The Abyssal Ride
	35396, -- The Dark Heart of Oshu'gun (Alliance)
	35317, -- The Dark Heart of Oshu'gun (Horde)
	35331, -- Called to the Throne (Alliance)
	34965, -- Called to the Throne (Horde)
}

---@param shouldDisable boolean
local function HandleConditions(shouldDisable)
	if shouldDisable then
		if T.IsEnabled then
			T.Disable()
		end
	else
		if not T.IsEnabled and not ForceDisable then
			T.Enable()
		end
	end
end

---@param spellId number
local function CheckSpellcast(_, _, spellId)
	if not ActiveConditions.spells[spellId] then
		return
	end

	ForceDisable = true
	HandleConditions(true)
end

local function EvaluateConditions()
	local shouldDisable = false

	if #ActiveConditions.items > 0 then
		for _, id in ipairs(ActiveConditions.items) do
			if GetItemCount(id) > 0 then
				shouldDisable = true
				break
			end
		end
	end

	HandleConditions(shouldDisable)
end

local function CheckStealth()
	if PetUtil.HasPet() and IsStealthed() then
		PetUtil.Dismiss()
	end
end

local function LoadConditions()
	if ConditionsUtil.IsChildrensWeek() then
		ConditionsUtil.UpdateChildrensWeek(ActiveConditions)
		Toolkit.RegisterUnitCallback("UNIT_SPELLCAST_SUCCEEDED", CheckSpellcast, "player")
	end

	Toolkit.RegisterEventCallback("BAG_UPDATE_DELAYED", EvaluateConditions)
	Toolkit.RegisterEventCallback("UPDATE_STEALTH", CheckStealth)
end

Toolkit.RegisterEventOnce("PLAYER_ENTERING_WORLD", LoadConditions)

-- local IsOnQuest = C_QuestLog.IsOnQuest

-- local Zones = {
--     46362,  -- Venomhide Hatchling
--     68646,  -- Winterspring Cub
--     3247,   -- Pocopoc
-- }

-- ---@return boolean
-- local function CheckZone()
--     local mapname = GetZoneText()

--     -- Venomhide Hatchling: Un'Goro or Tanaris, must have item
--     if GetItemCount(46362) > 0 and (mapname == "Un'Goro Crater" or mapname == "Tanaris") then
--         return true
--     end

--     -- Winterspring Cub: Winterspring, must have item
--     if GetItemCount(68646) > 0 and mapname == "Winterspring" then
--         return true
--     end

--     -- Pocopoc: Zereth Mortis, no item check
--     if mapname == "Zereth Mortis" then
--         return true
--     end

--     return false
-- end

-- ---@return boolean
-- local function CheckQuests()
--     for _, id in pairs(Quests) do
--         if IsOnQuest(id) then
--             return true
--         end
--     end

--     return false
-- end

-- do
--     local Events = {
--         "EQUIPMENT_SWAP_FINISHED",
--         "PLAYER_EQUIPMENT_CHANGED",
--         "ZONE_CHANGED_NEW_AREA",
--     }

--     for _, event in pairs(Events) do
--         EventRegistry:RegisterFrameEventAndCallback(event, MarkDirty)
--     end
-- end
