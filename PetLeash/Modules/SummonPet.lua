--[[------------------------------------------------------------------

    Support for automatic summoning of companion pets.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L = T.Locale

local CanSummon = C_PetJournal.GetPetSummonInfo
local GetCurrentPet = C_PetJournal.GetSummonedPetGUID
local GetSpeciesFromPetID = C_PetJournal.GetPetInfoByPetID
local HasControl = HasFullControl
local IsMoving = IsPlayerMoving
local PlayerIsInCombat = PlayerIsInCombat
local SummonPet = C_PetJournal.SummonPetByGUID

local Interval = T.db.switchTimer

local Exclusions = {
    280,  -- Guild Page (Alliance)
    281,  -- Guild Page (Horde)
    282,  -- Guild Herald (Alliance)
    283,  -- Guild Herald (Horde)
}

---@param petGuid string
local function IsExcludedSpecies(petGuid)
    if not petGuid then return false end

    local speciesID = GetSpeciesFromPetID(petGuid)
    if not speciesID then return false end

    for _, id in ipairs(Exclusions) do
        if speciesID == id then
            return true
        end
    end

    return false
end

---@return string?
function T.GetRandomPet()
    if not T.db.pets and #T.db.pets > 0 then
        T.Disable(L.NO_PETS)
        return
    end

    local Candidates = {}
    for _, guid in ipairs(T.db.pets) do
        if not IsExcludedSpecies(guid) then
            table.insert(Candidates, guid)
        end
    end

    if #Candidates == 0 then
        return nil
    end

    return Candidates[math.random(1, #Candidates)]
end

---@param petGuid string?
---@return boolean
function T.KeepPet(petGuid)
    if not petGuid then return false end

    if T.HasOverride() then
        return true
    end

    -- Keep manually-summoned pets
    if T.db.override == false then
        return true
    end

    for _, guid in ipairs(T.db.pets) do
        if guid == petGuid then
            return true
        end
    end

    return false
end

---@return boolean
function T.TrySummon()
    if PlayerIsInCombat() then
        return false
    end

    if not T.db.enable or not HasControl() or IsMoving() then
        return false
    end

    local CurrentPet = GetCurrentPet()

    -- Always respect overrides
    if CurrentPet and T.HasOverride() then
        return false
    end

    if T.db.autoSwitch then
        if CurrentPet and T.KeepPet(CurrentPet) then
            return false
        end
    end

    local NewPet = T.GetRandomPet()
    if not NewPet then
        return false
    end

    if CurrentPet == NewPet then
        return false
    end

    if CanSummon(NewPet) then
        SummonPet(NewPet)
        return true
    end

    return false
end