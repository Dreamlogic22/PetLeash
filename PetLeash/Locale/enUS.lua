---@class PetLeash
local T = select(2, ...)

---@class Locale
local L = T.Locale

L.ADD_OR_REMOVE_PET = "Add or remove this pet from PetLeash."
L.NO_PETS = "You do not have any pets selected.  Open the Pet Journal and pick some companions using the checkboxes!"
L.OPTIONS_AUTO_SWITCH_INTERVAL = "Switch Timer (Seconds)"
L.OPTIONS_CUSTOM_THROTTLE = "Enable Custom Timer"
L.OPTIONS_CUSTOM_THROTTLE_TOOLTIP = "You can set a custom value for when we scan for pets.  The higher the value, the less often checks happen.  Can help performance."
L.OPTIONS_ENABLE_AUTO_SUMMON = "Enable Auto-Summon"
L.OPTIONS_ENABLE_AUTO_SWITCH = "Enable Timed Auto Switch"
L.OPTIONS_LOAD_ERROR = "Could not load options. Please make sure you have |cff33ff99Pet Leash|r Options installed and enabled. |cffff7f7fError|r: "
L.OPTIONS_NOT_IN_COMBAT = "Options will load after combat ends."
L.OPTIONS_NOT_IN_EDIT_MODE = "Options cannot be opened while Edit Mode is active."
L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN = "Left click to toggle pet selection."
L.PET_SELECTION_INSTRUCTIONS_OPTIONS_OPEN = "Click to toggle the options window."
L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE = "Currently selecting pets! Left click again to close pet selection."
L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN = "Right click to open options."
L.VERSION = "Version %.2f"