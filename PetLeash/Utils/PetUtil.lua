--[[--------------------------------------------------------------------

    Interface for C_PetJournal methods.

----------------------------------------------------------------------]]

local T = select(2, ...)

local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo
local GetSummonedPetGUID = C_PetJournal.GetSummonedPetGUID
local SummonPetByGUID = C_PetJournal.SummonPetByGUID

local HasFullControl = HasFullControl
local IsPlayerMoving = IsPlayerMoving

local PetUtil = {}
do
	---@param petID string
	function PetUtil.CanSummon(petID)
		return GetPetSummonInfo(petID)
	end

	function PetUtil.Dismiss()
		local current = PetUtil.GetCurrent()
		if current then
			C_PetJournal.SummonPetByGUID(current)
		end
	end

	function PetUtil.GetCurrent()
		return GetSummonedPetGUID()
	end

	---@return string?
	function PetUtil.GetRandom()
		local pool = T.db.pets
		if not pool or #pool == 0 then
			return
		end

		if #pool == 1 then
			return pool[1]
		end

		local candidates = {}
		for _, guid in ipairs(pool) do
			if guid ~= T.db.mostRecentPet then
				table.insert(candidates, guid)
			end
		end

		if #candidates == 0 then
			return
		end

		return candidates[math.random(1, #candidates)]
	end

	---@param petID string
	function PetUtil.GetSpecies(petID)
		return select(1, GetPetInfoByPetID(petID))
	end

	function PetUtil.HasPet()
		return PetUtil.GetCurrent() ~= nil
	end

	---@param petID string
	function PetUtil.Summon(petID)
		if not PlayerIsInCombat() and (HasFullControl() and not IsPlayerMoving()) then
			SummonPetByGUID(petID)
			T.db.mostRecentPet = petID
		end
	end

	T.PetUtil = PetUtil
end
