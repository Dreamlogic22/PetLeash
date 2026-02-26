---@class PetLeash
local T = select(2, ...)

---@class Settings
T.db = {
    enable = true,
    autoSwitch = false,
    switchTimer = 300,
    pets = {},
    version = 0
}