--[[------------------------------------------------------------------

    Loads options addon using a paw icon attached to the pet journal.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L = T.Locale

local function LoadOptions()
    if PlayerIsInCombat() then
        T.Print(L.OPTIONS_NOT_IN_COMBAT)
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", LoadOptions)
        return
    end

    local loaded, reason = C_AddOns.LoadAddOn("PetLeashOptions")
    if not loaded then
        T.Print(L.OPTIONS_LOAD_ERROR, reason or UNKNOWN)
        return
    end
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", LoadOptions)

SLASH_PETLEASH1 = "/petleash"
SLASH_PETLEASH2 = "/pl"
SlashCmdList["PETLEASH"] = LoadOptions