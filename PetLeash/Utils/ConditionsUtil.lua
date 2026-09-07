--[[--------------------------------------------------------------------

    Interface for checking for active holidays, world events, items and
    quests that affected pet summoning.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local GetDayEvent = C_Calendar.GetDayEvent

local CHILDRENS_WEEK_ID = 201

---@param eventId number
---@return boolean
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
	spells = {
		[1228496] = true, -- Kobold Orphan Skibbles
		[1230149] = true, -- Arathi Orphan Destien
		[1230182] = true, -- Nerubian Orphan Theadis
		[1230184] = true, -- Goblin Orphan Kitzy
		[23012] = true, -- Orc Orphan Grunth
		[23013] = true, -- Human Orphan Randis
		[282839] = true, -- Kul Tiran Orphan Liam
		[283612] = true, -- Zandalari Orphan Azala
		[39478] = true, -- Blood Elf Orphan Salandria
		[39479] = true, -- Draenei Orphan Dornaa
		[65352] = true, -- Oracle Orphan Roo
		[65353] = true, -- Wolvar Orphan Kekek
	},
}

---@class ConditionsUtil
local ConditionsUtil = {}
do
	---@param activeConditions Conditions
	function ConditionsUtil.UpdateChildrensWeek(activeConditions)
		for cat, set in pairs(ChildrensWeek) do
			for id in next, set do
				tinsert(activeConditions[cat], id)
			end
		end
	end

	---@return boolean
	function ConditionsUtil.IsChildrensWeek()
		return IsEventActive(CHILDRENS_WEEK_ID)
	end

	T.ConditionsUtil = ConditionsUtil
end
