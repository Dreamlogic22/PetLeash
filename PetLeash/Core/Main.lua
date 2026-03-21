--[[--------------------------------------------------------------------

    We control summoning using Secure Templates.  The frame's
    update loop drives when summoning occurs based on visibility.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local PetUtil = T.PetUtil

local KeepSummonedPets = T.db.keepSummonedPets
local MostRecentPet = T.db.mostRecentPet

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

            if KeepSummonedPets and PetUtil.GetCurrent() then
                return
            end

            if not PetUtil.GetCurrent() then
                local pending = PetUtil.GetRandom(T.db.pets, MostRecentPet)

                if pending and PetUtil.CanSummon(pending) then
                    PetUtil.Summon(pending)

                    MostRecentPet = pending
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

        T.IsEnabled = false
    end

    function T.Enable()
        MostRecentPet = PetUtil.GetCurrent()

        WatchFrame:SetScript("OnUpdate", CheckPets)
        RegisterAttributeDriver(WatchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")

        T.IsEnabled = true
    end

    function T.UpdateSettings()
        KeepSummonedPets = T.db.keepSummonedPets

        ScanInterval = T.db.scanInterval
        ScanCountdown = ScanInterval
    end
end