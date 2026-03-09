--[[------------------------------------------------------------------

    Special flags, pets or items that should prevent automatic
    summoning.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local GetItemCount = C_Item.GetItemCount
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID -- secret unless whitelisted
local GetSpeciesFromPetID = C_PetJournal.GetPetInfoByPetID -- never secret
local GetSummonedPetGUID = C_PetJournal.GetSummonedPetGUID
local IsEquippedItem = C_Item.IsEquippedItem
local IsOnQuest = C_QuestLog.IsOnQuest

local Auras = {
    1230155, -- Arathi Orphan
    1230185, -- Goblin Orphan
    1228497, -- Kobold Orphan
    1230183, -- Nerubian Orphan
    311796,  -- Daisy
    302954,  -- Feathers
    232871,  -- Crackers
    286268,  -- Cap'n Crackers
    312993,  -- Forbidden Tomes (Revendreth)
    43880,   -- Ramstein's Swift Work Ram
    43883    -- Rental Racing Ram
}

local Equipment = {
    12185   -- Bloodsail Hat
}

local Holidays = {
    1349, -- Rotten Little Helper
    117,  -- Tiny Snowman
    119,  -- Father Winter's Helper
    120,  -- Winter's Little Helper
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

local Zones = {
    46362,  -- Venomhide Hatchling
    68646,  -- Winterspring Cub
    3247,   -- Pocopoc
}

local NeedsCheck = true
local IsCached = false

---@param unitTarget UnitToken
---@return boolean?
local function CheckAuras(_, unitTarget)
    if unitTarget == "player" then
        for _, id in pairs(Auras) do
            if not issecrettable(GetPlayerAuraBySpellID(id)) then
                return true
            end
        end

        return false
    end
end

---@return boolean
local function IsWinterVeil()
    local month, day = tonumber(date("%m")), tonumber(date("%d"))
    return (month == 12 and day >= 16) or (month == 1 and day <= 2)
end

---@return boolean
local function CheckHoliday()
    if IsWinterVeil() then return false end

    local currentPet = GetSummonedPetGUID()
    if not currentPet then return false end

    local speciesID = GetSpeciesFromPetID(currentPet)
    for _, holidayID in ipairs(Holidays) do
        if speciesID == holidayID then
            return true
        end
    end

    return false
end

---@return boolean
local function CheckEquipped()
    for _, id in pairs(Equipment) do
        if IsEquippedItem(id) then
            return true
        end
    end

    return false
end

---@return boolean
local function CheckInventory()
    for _, id in pairs(Items) do
        if GetItemCount(id) > 0 then
            return true
        end
    end

    return false
end

---@return boolean
local function CheckZone()
    for _, id in pairs(Zones) do
        local mapname = GetZoneText()
        if id == 46362 and GetItemCount(id) > 0 and mapname == "Un'Goro Crater" or mapname == "Tanaris" then
            return true
        end

        if id == 68646 and GetItemCount(id) > 0 and mapname == "Winterspring" then
            return true
        end

        if id == 3247 and mapname == "Zereth Mortis" then
            return true
        end
    end

    return false
end

---@return boolean
local function CheckQuests()
    for _, id in pairs(Quests) do
        if IsOnQuest(id) then
            return true
        end
    end

    return false
end

---@type table<number, function>
local Functions = {
    CheckAuras,
    CheckEquipped,
    CheckHoliday,
    CheckInventory,
    CheckQuests,
    CheckZone
}

---@return boolean
function T.HasOverride()
    if not NeedsCheck then
        return IsCached
    end

    NeedsCheck = false
    IsCached = false

    for _, f in pairs(Functions) do
        if f() then
            IsCached = true
            break
        end
    end

    return IsCached
end

local function MarkDirty()
    NeedsCheck = true
    IsCached = false
end

do
    local Events = {
        "BAG_UPDATE",
        "EQUIPMENT_SWAP_FINISHED",
        "PLAYER_EQUIPMENT_CHANGED",
        "QUEST_ACCEPTED",
        "QUEST_FINISHED",
        "UNIT_AURA",
        "ZONE_CHANGED_NEW_AREA",
    }

    for _, event in pairs(Events) do
        EventRegistry:RegisterFrameEventAndCallback(event, MarkDirty)
    end
end