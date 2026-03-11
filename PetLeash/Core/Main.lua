---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local L = T.Locale

local TimeSinceSwitch = 0
local Throttle = T.db.throttle
local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

---@param reason string?
function T.Disable(reason)
    UnregisterAttributeDriver(WatchFrame, "state-visibility")
    WatchFrame:SetScript("OnUpdate", nil)

    if reason then
        T.Print(reason)
    end
end

function T.Enable()
    ---@param elapsed number
    WatchFrame:SetScript("OnUpdate", function(_, elapsed)
        Throttle = Throttle - elapsed
        TimeSinceSwitch = TimeSinceSwitch + elapsed

        if Throttle < 0 then
            Throttle = 3
            T.TrySummon()
        end
    end)

    RegisterAttributeDriver(WatchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")
end

---@param value number
function T.UpdateThrottle(value)
    T.db.throttle = value or 3
    Throttle = value
end

local function OnInitialize()
    ---@class Settings
    PetLeashDB = {}

    T.InitializeDatabase("PetLeashDB")

    if T.db.pets and #T.db.pets > 0 then
        T.Enable()
    else
        T.Disable(L.NO_PETS)
    end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)