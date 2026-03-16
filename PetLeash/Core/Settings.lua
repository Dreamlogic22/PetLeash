--[[--------------------------------------------------------------------

    Default settings.

    autoSwitch:

        Do we automatically summon a new pet every so often?

    autoSwitchInterval:

        If we're rotating pets, how long does a given pet stay summoned?
        This value is expressed in seconds for compatibility with frame
        updates, but is presented to the user in minutes.

    enable:

        Are we monitoring or paused?

    keepSummonedPets:

        Should we override pets summoned using the Pet Journal?

    mostRecentPet:

        GUID of the last pet summoned manually or automatically.

    pets:

        Array of pets placed in the pool PetLeash uses to pick companions.

    scanInterval:

        Seconds between summoning checks.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

---@class Settings
T.db = {
    autoSwitch  = false,
    autoSwitchInterval = 5 * 60,
    enable = true,
    keepSummonedPets = true,
    mostRecentPet = {},
    pets = {},
    scanInterval = 5,
}