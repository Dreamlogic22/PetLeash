--[[--------------------------------------------------------------------

    Interfaces for checking for active holidays, quests, and world events
    that impact pet summoning.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local GetDayEvent = C_Calendar.GetDayEvent
local GetMonthInfo = C_Calendar.GetMonthInfo
local GetNumDayEvents = C_Calendar.GetNumDayEvents

local CHILDRENS_WEEK_ID = 201

---@param eventID number
---@return boolean
local function IsEventActive(eventID)
    local calendarTime = GetCurrentCalendarTime()
    local monthInfo = GetMonthInfo()

    local monthOffset = -12 * (monthInfo.year - calendarTime.year) + calendarTime.month - monthInfo.month
    for i = 1, GetNumDayEvents(monthOffset, calendarTime.monthDay) do
        local eventInfo = GetDayEvent(0, calendarTime.monthDay, i)

        if eventInfo.eventID == eventID then
            if eventInfo.sequenceType == "ONGOING" then
                return true
            end

            if eventInfo.sequenceType == "START" then
                return calendarTime.hour >= eventInfo.startTime.hour and (calendarTime.hour > eventInfo.startTime.hour or calendarTime.minute >= eventInfo.startTime.minute)
            end

            if eventInfo.sequenceType == "END" then
                return calendarTime.hour <= eventInfo.startTime.hour and (calendarTime.hour < eventInfo.startTime.hour or calendarTime.minute <= eventInfo.startTime.minute)
            end

            break
        end
    end

    return false
end

---@class OverrideUtil
local OverrideUtil = {}
do
    ---@return boolean
    function OverrideUtil.IsChildrensWeek()
        return IsEventActive(CHILDRENS_WEEK_ID)
    end

    T.OverrideUtil = OverrideUtil
end