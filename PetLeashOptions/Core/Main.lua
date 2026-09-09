--[[--------------------------------------------------------------------

    AceConfig options table definitions.

----------------------------------------------------------------------]]

local C, T = select(2, ...), PetLeash
local L = T.Locale

C.Options = {
	Enable = {
		desc = L.OPTIONS_SCAN_TOOLTIP,
		get = function()
			return C.db.enable
		end,
		name = ENABLE,
		---@param value boolean
		set = function(value)
			C.db.enable = value
		end,
		type = "toggle",
	},
	KeepSummonedPets = {
		desc = L.OPTIONS_KEEP_SUMMONED_TOOLTIP,
		disable = function()
			return not C.db.enable
		end,
		get = function()
			return C.db.keepSummonedPets
		end,
		name = L.OPTIONS_KEEP_SUMMONED,
		---@param value boolean
		set = function(value)
			C.db.keepSummonedPets = value
		end,
		type = "toggle",
	},
	ScanInterval = {
		disable = function()
			return not C.db.enable
		end,
		get = function()
			return C.db.scanInterval
		end,
		min = 1,
		max = 120,
		step = 1,
		name = L.OPTIONS_SCAN_INTERVAL,
		---@param value number
		set = function(value)
			C.db.scanInterval = value
			T.UpdateSettings()
		end,
		type = "range",
	},
}
