--[[--------------------------------------------------------------------

    Namespace variables, controls & utilities.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L = T.Locale

T.AutoSwitch = false
T.AutoSwitchInterval = 300
T.MostRecentPet = ""
T.ScanCountdown = 5
T.ScanInterval = 5
T.TimeSinceSummon = 0

function T.Print(...)
    print(strjoin("", "|cffd6bfa3", T.Name .. "|r: ", ...))
end

local function OnInitialize()
    if T.db.enable and (T.db.pets and #T.db.pets > 0) then
        T.Enable()
    else
        T.Disable(L.NO_PETS)
    end
end

EventUtil.ContinueOnAddOnLoaded(T.Name, OnInitialize)

-- TODO: remove
EventUtil.ContinueOnAddOnLoaded("TherapyDevTools", function()
    TherapyDevTools_Monitor(T.Name)
end)