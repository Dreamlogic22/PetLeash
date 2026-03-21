--[[--------------------------------------------------------------------

    Interface for C_PetJournal methods.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo
local GetSummonedPetGUID = C_PetJournal.GetSummonedPetGUID
local SummonPetByGUID = C_PetJournal.SummonPetByGUID

local HasFullControl = HasFullControl
local IsPlayerMoving = IsPlayerMoving

---@class PetUtil
local PetUtil = {}
do
    ---@param petID string
    ---@return boolean, number, string
    function PetUtil.CanSummon(petID)
        return GetPetSummonInfo(petID)
    end

    function PetUtil.Dismiss()
        local current = PetUtil.GetCurrent()
        if current then
            C_PetJournal.SummonPetByGUID(current)
        end
    end

    ---@return string
    function PetUtil.GetCurrent()
        return GetSummonedPetGUID()
    end

    ---@param pool table
    ---@param exclude string?
    ---@return string?
    function PetUtil.GetRandom(pool, exclude)
        if not pool or #pool == 0 then
            return nil
        end

        if #pool == 1 then
            return pool[1]
        end

        local candidates = {}
        for _, guid in ipairs(pool) do
            if guid ~= exclude then
                table.insert(candidates, guid)
            end
        end

        if #candidates == 0 then
            return nil
        end

        return candidates[math.random(1, #candidates)]
    end

    ---@param petID string
    ---@return number?
    function PetUtil.GetSpecies(petID)
        return select(1, GetPetInfoByPetID(petID))
    end

    ---@return boolean
    function PetUtil.HasPet()
        return PetUtil.GetCurrent() ~= nil
    end

    ---@param petID string
    function PetUtil.Summon(petID)
        if not PlayerIsInCombat() and (HasFullControl() and not IsPlayerMoving()) then
            SummonPetByGUID(petID)
        end
    end

    T.PetUtil = PetUtil
end