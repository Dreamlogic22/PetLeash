---@type string
local Name = ...
---@class PetLeash: TherapyAPI
local T = select(2, ...)

local L = T.Locale

local Interval = T.db.switchTimer
local TimeSinceSwitch = 0
local Throttle = T.db.throttle

local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

--[[

    TODO:

    do not lookup db values here, do as much processing as possible outside of onupdate.
    for settings, just use a single function to update Interval, Throttle, and Auto-Switch
    Throttle is one thing, TimeSinceLastCheck is another

]]

---@param elapsed number
local function ScanPets(_, elapsed)
    Throttle = Throttle - elapsed
    TimeSinceSwitch = TimeSinceSwitch + elapsed

    if Throttle < 0 then
        Throttle = 5

        if not T.db.autoSwitch or TimeSinceSwitch >= Interval then
            if T.TrySummon() then
                TimeSinceSwitch = 0
            end
        end
    end
end

---@param reason string?
function T.Disable(reason)
    UnregisterAttributeDriver(WatchFrame, "state-visibility")
    WatchFrame:SetScript("OnUpdate", nil)

    if reason then
        T.Print(reason)
    end
end

function T.Enable()
    WatchFrame:SetScript("OnUpdate", ScanPets)
    RegisterAttributeDriver(WatchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")
end

function T.Print(...)
    print(strjoin("", "|cffd6bfa3", Name .. "|r: ", ...))
end

---@param value number
function T.UpdateInterval(value)
    T.db.switchTimer = value or 300
    Interval = value
end

---@param value number
function T.UpdateThrottle(value)
    T.db.throttle = value or 5
    Throttle = value
end

local function OnInitialize()
    TherapyUX.Embed(T)

    if T.db.pets and #T.db.pets > 0 then
        T.Enable()
    else
        T.Disable(L.NO_PETS)
    end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)