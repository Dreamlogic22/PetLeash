---@class PetLeash
local T = select(2, ...)

---@class Locale
local L = {}
do
    L.ADD_OR_REMOVE_PET = "Add or remove this pet from PetLeash."
    L.NO_PETS = "You do not have any pets selected.  Open the Pet Journal and pick some companions using the checkboxes!"
    L.OPTIONS_KEEP_SUMMONED = "Keep Pets You Summon"
    L.OPTIONS_KEEP_SUMMONED_TOOLTIP = "If checked, pets you summon manually will be kept. Otherwise, they will be replaced with pets from your PetLeash selections."
    L.OPTIONS_LOAD_ERROR = "Could not load options. Please make sure you have |cffd6bfa3PetLeash|r |cff947d66Options|r installed and enabled. |cffff7f7fError|r: "
    L.OPTIONS_NOT_IN_COMBAT = "Options will load after combat ends."
    L.OPTIONS_NOT_IN_EDIT_MODE = "Options cannot be opened while Edit Mode is active."
    L.OPTIONS_SCAN_INTERVAL = "Check After (Seconds)"
    L.OPTIONS_SCAN_TOOLTIP = "You can set how often we scan for pets. Higher intervals can help performance."
    L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN = "Left click to toggle pet selection."
    L.PET_SELECTION_INSTRUCTIONS_OPTIONS_OPEN = "Click to toggle the options window."
    L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE = "Currently selecting pets! Left click again to close pet selection."
    L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN = "Right click to toggle options."
    L.VERSION = "Version %.2f"

    T.Locale = L
end