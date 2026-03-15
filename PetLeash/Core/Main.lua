--[[--------------------------------------------------------------------

    Main scan loop & application control.

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local L = T.Locale

local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

do
    local AutoSwitch = T.db.autoSwitch
    local AutoSwitchInterval = T.db.autoSwitchInterval
    local ScanInterval = T.db.scanInterval
    local ScanCountdown = ScanInterval
    local TimeSinceSwitch = 0

    ---@param elapsed number
    local function CheckPets(_, elapsed)
        ScanCountdown = ScanCountdown - elapsed
        TimeSinceSwitch = TimeSinceSwitch + elapsed

        if ScanCountdown <= 0 then
            ScanCountdown = ScanInterval

            if AutoSwitch and TimeSinceSwitch >= AutoSwitchInterval then
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
        WatchFrame:SetScript("OnUpdate", CheckPets)
        RegisterAttributeDriver(WatchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")
    end

    function T.LoadVariables()
        AutoSwitch = T.db.autoSwitch
        AutoSwitchInterval = T.db.autoSwitchInterval
        ScanCountdown = ScanInterval
        ScanInterval = T.db.scanInterval
        TimeSinceSwitch = 0
    end
end

local function LoadDevTools()
    EventUtil.ContinueOnAddOnLoaded("TherapyDevTools", function()
        TherapyDevTools_Monitor(Name)
    end)
end

local function OnInitialize()
    T.IsDebugBuild = T.db.isDebugBuild
    if T.IsDebugBuild then
        LoadDevTools()
    end

    if T.db.enable and (T.db.pets and #T.db.pets > 0) then
        T.Enable()
    else
        T.Disable(L.NO_PETS)
    end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)