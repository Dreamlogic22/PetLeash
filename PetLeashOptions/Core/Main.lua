--[[--------------------------------------------------------------------

    AceConfig options table definitions.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L = T.Locale

C.Options = {
    AutoSwitch = {
        disable = function() if #C.db.pets < 2 then C.db.autoSwitch = false; return true else return not C.db.enable end end,
        get = function() return C.db.autoSwitch end,
        name = L.OPTIONS_AUTO_SWITCH,
        set = function(value)
            C.db.autoSwitch = value
            T.UpdateSettings()
        end,
        type = "toggle"
    },
    AutoSwitchInterval = {
        disable = function() return (not C.db.autoSwitch or not C.db.enable) end,
        get = function() return C.db.autoSwitchInterval / 60 end,
        min = 1, max = 30, step = 1,
        name = L.OPTIONS_AUTO_SWITCH_INTERVAL,
        set = function(value)
            C.db.autoSwitchInterval = value * 60
            T.UpdateSettings()
        end,
        type = "range"
    },
    Enable = {
        desc = L.OPTIONS_SCAN_TOOLTIP,
        get = function() return C.db.enable end,
        name = ENABLE,
        set = function(value) C.db.enable = value end,
        type = "toggle"
    },
    KeepSummonedPets = {
        desc = L.OPTIONS_KEEP_SUMMONED_TOOLTIP,
        disable = function() return not C.db.enable end,
        get = function() return C.db.keepSummonedPets end,
        name = L.OPTIONS_KEEP_SUMMONED,
        set = function(value) C.db.keepSummonedPets = value end,
        type = "toggle"
    },
    ScanInterval = {
        disable = function() return not C.db.enable end,
        get = function() return C.db.scanInterval end,
        min = 1, max = 120, step = 1,
        name = L.OPTIONS_SCAN_INTERVAL,
        set = function(value)
            C.db.scanInterval = value
            T.UpdateSettings()
        end,
        type = "range"
    },
}


--                 autoSwitch = {
--                     name = L.OPTIONS_AUTO_SWITCH,
--                     order = 4,
--                     type = "toggle",
--                     set = function(info, value)
--                         C.db[info[#info]] = value
--                         T.UpdateSettings()
--                     end,
--                     disabled = function()
--                         if #C.db.pets < 2 then
--                             C.db.autoSwitch = false
--                             return true
--                         else
--                             return not C.db.enable
--                         end
--                     end,
--                 },
--                 autoSwitchSpacer = {
--                     name = "",
--                     order = 5,
--                     type = "description",
--                     width = 1
--                 },
--                 autoSwitchInterval = {
--                     name = L.OPTIONS_AUTO_SWITCH_INTERVAL,
--                     min = 1,
--                     max = 30,
--                     step = 1,
--                     order = 6,
--                     type = "range",
--                     get = function(info) return C.db[info[#info]] / 60 end,
--                     set = function(info, value)
--                         C.db[info[#info]] = value * 60
--                         T.UpdateSettings()
--                     end,
--                     disabled = function() return (not C.db.autoSwitch or not C.db.enable) end
--                 },
--                 keepSummonedPets = {
--                     desc = L.OPTIONS_KEEP_SUMMONED_TOOLTIP,
--                     name = L.OPTIONS_KEEP_SUMMONED,
--                     type = "toggle",
--                     set = function(info, value) C.db[info[#info]] = value; T.UpdateSettings() end,
--                     disabled = function() return not C.db.enable end,
--                 }
--             }
--         }
--     }