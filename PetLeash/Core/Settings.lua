--[[--------------------------------------------------------------------

    Default settings:

    enable:

        Are we monitoring or paused?

    keepSummonedPets:

        Should we override pets summoned using the Pet Journal?

    pets:

        Array of pets placed in the pool PetLeash uses to pick companions.

    scanInterval:

        How many seconds we wait in between checks to determine if a pet
        is out.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

---@class Settings
T.db = {
    enable = true,
    keepSummonedPets = true,
    pets = {},
    scanInterval = 5,
}