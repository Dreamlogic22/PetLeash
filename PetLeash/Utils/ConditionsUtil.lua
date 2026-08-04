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

---@type Conditions
local ChildrensWeek = {
    auras = {
        [1230155] = true, -- Arathi Orphan
        [1230185] = true, -- Goblin Orphan
        [1228497] = true, -- Kobold Orphan
        [1230183] = true, -- Nerubian Orphan
    },
    items = {
        [31880] = true,  -- Blood Elf Orphan Whistle
        [164965] = true, -- Casteless Zandalari Orphan Whistle
        [31881] = true,  -- Draenei Orphan Whistle
        [18598] = true,  -- Human Orphan Whistle
        [164772] = true, -- Kul Tiran Orphan Whistle
        [46397] = true,  -- Oracle Orphan Whistle
        [18597] = true,  -- Orcish Orphan Whistle
        [46396] = true,  -- Wolvar Orphan Whistle
    }
}

--[[

    use spell id and check for UNIT_SPELLCAST_SUCCEEDED:player

    [23012] = true, -- Orc Orphan Grunth (BC, Orgrimmar)
    [23013] = true, -- Human Orphan Randis (BC, Stormwind)
    [39478] = true, -- Blood Elf Orphan Salandria (BC, Shattrath)
    [39479] = true, -- Draenei Orphan Dornaa (BC, Shattrath)
    [65352] = true, -- Oracle Orphan Roo (Wrath, Dalaran)
    [65353] = true, -- Wolvar Orphan Kekek (Wrath, Dalaran)
    [282839] = true, -- Kul Tiran Orphan Liam (BfA, Boralus)
    [283612] = true, -- Zandalari Orphan Azala (BfA, Dazar'alor)
    [1228496] = true, -- Kobold Orphan Skibbles (TWW, Dornogal)
    [1230149] = true, -- Arathi Orphan Destien (TWW, quest line)
    [1230182] = true, -- Nerubian Orphan Theadis (TWW, quest line)
    [1230184] = true, -- Goblin Orphan Kitzy (TWW, quest line)

    these may be covered by the attribute driver

    [43883] = true -- Rental Racing Ram
    [43880] = true -- Ramstein's Swift Work Ram

    figure out when to restore based on quest completed

    Pause until ZONE_CHANGED_NEW_AREA and/or QUEST_TURNED_IN

]]

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