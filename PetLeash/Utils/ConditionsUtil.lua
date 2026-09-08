--[[--------------------------------------------------------------------

    Interface for checking for active holidays, world events, items and
    quests that affected pet summoning.

----------------------------------------------------------------------]]

local T = select(2, ...)

local GetDayEvent = C_Calendar.GetDayEvent

local CHILDRENS_WEEK_ID = 201

---@param eventId number
local function IsEventActive(eventId)
	local info = C_DateAndTime.GetCurrentCalendarTime()
	C_Calendar.SetAbsMonth(info.month, info.year)

	local day = info.monthDay
	for i = 1, C_Calendar.GetNumDayEvents(0, day) do
		local event = GetDayEvent(0, day, i)
		local eventID = event and event.eventID
		if eventID and not (issecretvalue(eventID)) then
			if eventID == eventId then
				return true
			end
		end
	end

	return false
end

local ChildrensWeek = {
	auras = {
		[1230155] = true, -- Arathi Orphan
		[1230185] = true, -- Goblin Orphan
		[1228497] = true, -- Kobold Orphan
		[1230183] = true, -- Nerubian Orphan
	},
	items = {
		[31880] = true, -- Blood Elf Orphan Whistle
		[164965] = true, -- Casteless Zandalari Orphan Whistle
		[31881] = true, -- Draenei Orphan Whistle
		[18598] = true, -- Human Orphan Whistle
		[164772] = true, -- Kul Tiran Orphan Whistle
		[46397] = true, -- Oracle Orphan Whistle
		[18597] = true, -- Orcish Orphan Whistle
		[46396] = true, -- Wolvar Orphan Whistle
	},
}

local ConditionsUtil = {}
do
	---@param activeConditions table
	function ConditionsUtil.UpdateChildrensWeek(activeConditions)
		for cat, set in pairs(ChildrensWeek) do
			for id in next, set do
				tinsert(activeConditions[cat], id)
			end
		end
	end

	function ConditionsUtil.IsChildrensWeek()
		return IsEventActive(CHILDRENS_WEEK_ID)
	end

	T.ConditionsUtil = ConditionsUtil
end
