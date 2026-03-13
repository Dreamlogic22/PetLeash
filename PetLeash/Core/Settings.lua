---@class PetLeash
local T = select(2, ...)

---@class Settings
T.db = {
    autoSwitch = false,
    customThrottle = false,
    enable = true,
    override = false,
    pets = {},
    switchTimer = 5,
    throttle = 5,
    version = 0
}