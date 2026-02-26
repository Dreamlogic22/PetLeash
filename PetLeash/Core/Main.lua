---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

do
    function T.Print(...)
        print(strjoin("", "|cff33ff99", Name .. "|r: ", ...))
    end
end

local function OnInitialize()
    if InCombatLockdown() then
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnInitialize)
    end

    if not T.db.pets or #T.db.pets == 0 then
        T.Print("You do not have any pets selected.  Open the Pet Journal and to set them up!")
        WatchFrame:Hide()

        return
    else
        local throttle = 3
        WatchFrame:SetScript("OnUpdate", function(_, elapsed)
            throttle = throttle - elapsed

            if throttle < 0 then
                throttle = 3
                T.TrySummon()
            end
        end)

        RegisterAttributeDriver(WatchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")
    end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)