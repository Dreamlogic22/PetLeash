--[[--------------------------------------------------------------------

    We create a "watch frame" using Secure Templates.  The frame's
    visibility and update loop are controlled using macro
    conditionals to basic summoning logic.

----------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

local ScanCountdown = 5
do
    ---@param elapsed number
    local function CheckPets(_, elapsed)
        ScanCountdown = ScanCountdown - elapsed
        -- TimeSinceSwitch = TimeSinceSwitch + elapsed

        if ScanCountdown <= 0 then
            ScanCountdown = 5 -- temp

            T.TrySummon()

            -- if AutoSwitch and TimeSinceSwitch >= AutoSwitchInterval then
                -- if T.TrySummon() then
                    -- TimeSinceSwitch = 0
                -- end
            -- end
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
end