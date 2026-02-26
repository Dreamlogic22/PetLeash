--[[--------------------------------------------------------------------

    Special flags, pets or items that should prevent automatic
    summoning.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetSpeciesFromPetID = C_PetJournal.GetPetInfoByPetID
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID

---@type table<string, boolean>
local Exceptions = {}

local ExcludedPets = {
    280,  -- Guild Page (Alliance)
    281,  -- Guild Page (Horde)
    282,  -- Guild Herald (Alliance)
    283,  -- Guild Herald (Horde)
    1349, -- Rotten Little Helper
    117,  -- Tiny Snowman
    119,  -- Father Winter's Helper
    120,  -- Winter's Little Helper
    3247, -- Pocopoc
}

for _, id in ipairs(ExcludedPets) do
    Exceptions[id] = true
end

local function IsExcludedPet(speciesID)
    if not speciesID then return false end

    -- Pocopoc
    if speciesID == 3247 then
        local mapID = GetBestMapForUnit("player")
        return mapID == 1970
    end

    return Exceptions[speciesID] or false
end

---@param petID number?
function T.KeepPet(petID)
    if not petID then return false end

    return IsExcludedPet(GetSpeciesFromPetID(petID))
end

function T.HasBlockingAura()
    -- if C_Secrets.ShouldAurasBeSecret() then return end

    if GetPlayerAuraBySpellID(1228497)      -- Kobold Orphan
        or GetPlayerAuraBySpellID(1230155)  -- Arathi Orphan
        or GetPlayerAuraBySpellID(1230183)  -- Nerubian Orphan
        or GetPlayerAuraBySpellID(1230185)  -- Goblin Orphan
    then
        return true
    end

    -- Daisy backpack
    if GetPlayerAuraBySpellID(311796) then
        return true
    end

    -- Shoulder pets
    if GetPlayerAuraBySpellID(302954)       -- Feathers
        or GetPlayerAuraBySpellID(232871)   -- Crackers
        or GetPlayerAuraBySpellID(286268)   -- Cap'n Crackers
    then
        return true
    end

    -- Game events
    if GetPlayerAuraBySpellID(312993)       -- Forbidden Tomes (Revendreth)
        or GetPlayerAuraBySpellID(43880)    -- Ramstein's Swift Work Ram
        or GetPlayerAuraBySpellID(43883)    -- Rental Racing Ram
    then
        return true
    end

    return false
end