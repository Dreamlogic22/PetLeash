--[[--------------------------------------------------------------------

    Interface for checking for active holidays and world events
    that impact pet summoning.

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

---@class CalendarUtil
local CalendarUtil = {}
do
    ---@return boolean
    function CalendarUtil.IsChildrensWeek()
        return IsEventActive(CHILDRENS_WEEK_ID)
    end

    T.CalendarUtil = CalendarUtil
end