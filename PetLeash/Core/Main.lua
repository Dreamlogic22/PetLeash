--[[--------------------------------------------------------------------

    We control summoning using Secure Templates.  The frame's
    update loop drives when summoning occurs based on visibility.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local PetUtil = T.PetUtil

local AutoSwitch = T.db.autoSwitch
local AutoSwitchInterval = T.db.autoSwitchInterval

local KeepSummonedPets = T.db.keepSummonedPets
local LastPetSummoned = T.db.mostRecentPet

local ScanInterval = T.db.scanInterval
local ScanCountdown = ScanInterval
local TimeSinceSummon = 0

do
    local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

    ---@param elapsed number
    local function CheckPets(_, elapsed)
        ScanCountdown = ScanCountdown - elapsed
        TimeSinceSummon = TimeSinceSummon + elapsed

        if ScanCountdown <= 0 then
            ScanCountdown = ScanInterval

            if (not AutoSwitch and KeepSummonedPets) and (PetUtil.GetCurrent() == LastPetSummoned) then
                return
            end

            if not PetUtil.GetCurrent() or (AutoSwitch and TimeSinceSummon >= AutoSwitchInterval) then
                local pending = PetUtil.GetRandom(T.db.pets, T.db.mostRecentPet)

                if pending and PetUtil.CanSummon(pending) then
                    PetUtil.Summon(pending)
                    T.db.mostRecentPet = pending
                    TimeSinceSummon = 0
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
        T.db.mostRecentPet = PetUtil.GetCurrent()

        WatchFrame:SetScript("OnUpdate", CheckPets)
        RegisterAttributeDriver(WatchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")
    end

    function T.UpdateSettings()
        AutoSwitch = T.db.autoSwitch
        AutoSwitchInterval = T.db.autoSwitchInterval

        KeepSummonedPets = T.db.keepSummonedPets

        ScanInterval = T.db.scanInterval
        ScanCountdown = ScanInterval
    end
end