--[[--------------------------------------------------------------------

    Utility functions & helpers

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo
local GetSummonedPetGUID = C_PetJournal.GetSummonedPetGUID
local SummonPetByGUID = C_PetJournal.SummonPetByGUID

-- General
do
    function T.Print(...)
        print(strjoin("", "|cffd6bfa3", Name .. "|r: ", ...))
    end
end

---@class PetUtil
local PetUtil = T.PetUtil
do
    ---@param petID string
    ---@return boolean, number, string
    function PetUtil.CanSummon(petID)
        return GetPetSummonInfo(petID)
    end

    ---@return string
    function PetUtil.GetCurrent()
        return GetSummonedPetGUID()
    end

    ---@param petID string
    ---@return number?
    function PetUtil.GetSpecies(petID)
        return select(1, GetPetInfoByPetID(petID))
    end

    ---@param petID string
    function PetUtil.Summon(petID)
        if not PlayerIsInCombat() then
            SummonPetByGUID(petID)
        end
    end
end