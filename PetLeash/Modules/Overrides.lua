--[[------------------------------------------------------------------

    Special flags, pets or items that prevent automatic summoning and
    can dismiss summoned pets under certain circumstances (such as
    stealth).

    This is currently a stub except for stealth.  Neither Children's
    Week nor Brewfest are running at the moment, and I am not leveling an
    alt, so we cannot test the other conditions.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local CalendarUtil = T.CalendarUtil
local PetUtil = T.PetUtil

local GetItemCount = C_Item.GetItemCount
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local ShouldAurasBeSecret = C_Secrets.ShouldAurasBeSecret

local Auras = {
    1230155, -- Arathi Orphan
    1230185, -- Goblin Orphan
    1228497, -- Kobold Orphan
    1230183, -- Nerubian Orphan
    312993,  -- Forbidden Tomes (Revendreth)
    43880,   -- Ramstein's Swift Work Ram
    43883    -- Rental Racing Ram
}

local Items = {
    31880,  -- Blood Elf Orphan Whistle
    164965, -- Casteless Zandalari Orphan Whistle
    31881,  -- Draenei Orphan Whistle
    18598,  -- Human Orphan Whistle
    164772, -- Kul Tiran Orphan Whistle
    46397,  -- Oracle Orphan Whistle
    18597,  -- Orcish Orphan Whistle
    46396,  -- Wolvar Orphan Whistle
    30803,  -- Felhound Whistle,
    31815,  -- Zeppit's Crystal
    32834,  -- Nether Ray Cage
    34971,  -- Warsong Flare Gun
    36936,  -- Golem Control Unit
}

local Quests = {
    11878,  -- Orphaned Mammoth Calf
    26831,  -- Twilight Flight
    25371,  -- The Abyssal Ride
    35396,  -- The Dark Heart of Oshu'gun (Alliance)
    35317,  -- The Dark Heart of Oshu'gun (Horde)
    35331,  -- Called to the Throne (Alliance)
    34965,  -- Called to the Throne (Horde)
}


local function CheckAuras()
    if ShouldAurasBeSecret() then
        return
    end

    for _, id in pairs(Auras) do
        if GetPlayerAuraBySpellID(id) then
            if T.IsEnabled then
                T.Disable()
            end

            return
        end
    end

    if not T.IsEnabled then
        T.Enable()
    end
end

local function CheckInventory()
    for _, id in pairs(Items) do
        if GetItemCount(id) > 0 then
            if T.IsEnabled then
                T.Disable()
            end

            return
        end
    end

    if not T.IsEnabled then
        T.Enable()
    end
end

local function DismissSummonedPet()
    if PetUtil.HasPet() and IsStealthed() then
        PetUtil.Dismiss()
    end
end

---@param hasOverride boolean
local function HandleOverride(hasOverride)
    if hasOverride then
        if T.IsEnabled then
            T.Disable()
        end

        return
    end

    if not T.IsEnabled then
        T.Enable()
    end
end

local function SetupOverrides()
    if CalendarUtil.IsChildrensWeek() then
        CheckAuras()

        Toolkit.RegisterEventCallback("BAG_UPDATE_DELAYED", CheckInventory)
        Toolkit.RegisterEventCallback("QUEST_ACCEPTED", CheckAuras)
        Toolkit.RegisterEventCallback("QUEST_TURNED_IN", CheckAuras)
    end

    Toolkit.RegisterEventCallback("UPDATE_STEALTH", DismissSummonedPet)
end

EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_ENTERING_WORLD", SetupOverrides)

-- local IsEquippedItem = C_Item.IsEquippedItem
-- local IsOnQuest = C_QuestLog.IsOnQuest

-- local Zones = {
--     46362,  -- Venomhide Hatchling
--     68646,  -- Winterspring Cub
--     3247,   -- Pocopoc
-- }

-- ---@return boolean
-- local function CheckEquipped()
--     for _, id in pairs(Equipment) do
--         if IsEquippedItem(id) then
--             return true
--         end
--     end

--     return false
-- end

-- ---@return boolean
-- local function CheckInventory()
--     for _, id in pairs(Items) do
--         if GetItemCount(id) > 0 then
--             return true
--         end
--     end

--     return false
-- end

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