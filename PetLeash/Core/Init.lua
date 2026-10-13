--[[--------------------------------------------------------------------

    PetLeash 4.0.8 (October 12, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...

---@class PetLeash
local T = select(2, ...)
do
	T.IsEnabled = false

	---@class Locale
	T.Locale = {}

	function T.Print(...)
		print(strjoin("", "|cffd6bfa3", Name .. "|r: ", ...))
	end
end

-- Load database
do
	---@param target table
	---@param defaults table
	local function merge(target, defaults)
		for k, v in next, defaults do
			if type(v) == "table" then
				if type(target[k]) ~= "table" then
					target[k] = {}
				end

				merge(target[k], v)
			elseif target[k] == nil then
				target[k] = v
			end
		end

		return target
	end

	if not PetLeashDB or type(PetLeashDB) ~= "table" then
		PetLeashDB = {}
	end

	PetLeashDB = merge(PetLeashDB, T.db)

	T.db = PetLeashDB
end

local function OnInitialize()
	if T.db.enable and (T.db.pets and #T.db.pets > 0) then
		T.Enable()
	else
		T.Disable(T.Locale.NO_PETS)
	end

	PetLeash = T
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)
