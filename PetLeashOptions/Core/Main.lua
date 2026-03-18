--[[--------------------------------------------------------------------

    AceConfig options table definitions.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L = T.Locale

C.Options = {
    name = "",
    order = 0,
    type = "group",
    args = {
        general = {
            inline = true,
            name = "General",
            type = "group",
            get = function(info) return C.db[info[#info]] end,
            args = {
                enable = {
                    name = ENABLE,
                    order = 0,
                    type = "toggle",
                    set = function(info, value)
                        C.db[info[#info]] = value
                        if value then
                            T.Enable()
                        else
                            T.Disable()
                        end
                    end,
                },
                spacer = {
                    name = "",
                    order = 2,
                    type = "description",
                    width = 1
                },
                scanInterval = {
                    desc = L.OPTIONS_SCAN_TOOLTIP,
                    min = 1,
                    max = 30,
                    name = L.OPTIONS_SCAN_INTERVAL,
                    step = 1,
                    order = 3,
                    type = "range",
                    set = function(info, value) C.db[info[#info]] = value * 60; T.UpdateSettings() end,
                    disabled = function() return not C.db.enable end
                },
                autoSwitch = {
                    name = L.OPTIONS_AUTO_SWITCH,
                    order = 4,
                    type = "toggle",
                    set = function(info, value)
                        C.db[info[#info]] = value
                        T.UpdateSettings()
                    end,
                    disabled = function()
                        if #C.db.pets < 2 then
                            C.db.autoSwitch = false
                            return true
                        else
                            return not C.db.enable
                        end
                    end,
                },
                autoSwitchSpacer = {
                    name = "",
                    order = 5,
                    type = "description",
                    width = 1
                },
                autoSwitchInterval = {
                    name = L.OPTIONS_AUTO_SWITCH_INTERVAL,
                    min = 1,
                    max = 30,
                    step = 1,
                    order = 6,
                    type = "range",
                    get = function(info) return C.db[info[#info]] / 60 end,
                    set = function(info, value)
                        C.db[info[#info]] = value * 60
                        T.UpdateSettings()
                    end,
                    disabled = function() return (not C.db.autoSwitch or not C.db.enable) end
                },
                keepSummonedPets = {
                    desc = L.OPTIONS_KEEP_SUMMONED_TOOLTIP,
                    name = L.OPTIONS_KEEP_SUMMONED,
                    type = "toggle",
                    set = function(info, value) C.db[info[#info]] = value; T.UpdateSettings() end,
                    disabled = function() return not C.db.enable end,
                }
            }
        }
    }
}