---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local CanSummon = C_PetJournal.GetPetSummonInfo
local GetCurrentPet = C_PetJournal.GetSummonedPetGUID
local HasControl = HasFullControl
local IsMoving = IsPlayerMoving
local SummonPet = C_PetJournal.SummonPetByGUID

local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

do
    T.CurrentPet = nil

    function T.Print(...)
        print(strjoin("", "|cff33ff99", Name .. "|r: ", ...))
    end
end

local function TrySummon()
    T.CurrentPet = GetCurrentPet()

    if not T.db.enable or not HasControl() or IsMoving() then
        return
    end

    if T.CurrentPet and T.KeepPet(T.CurrentPet) then
        return
    end

    -- hardcoded on purpose for now
    if not T.CurrentPet or T.CurrentPet ~= "BattlePet-0-000008927F14" then
        local canSummon = CanSummon("BattlePet-0-000008927F14")
        if canSummon then
            SummonPet("BattlePet-0-000008927F14")
            -- check if it worked? sitting is a big nope and SummonPet has not success return... pcall?
        end
    end
end

local function OnInitialize()
    if InCombatLockdown() then
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnInitialize)
    end

    if not T.db.pets or #T.db.pets == 0 then
        T.Print("You do not have any pets selected!  Open the Pet Journal and use the checkboxes set them up!")
        WatchFrame:Hide()

        return
    else
        local throttle = 3
        WatchFrame:SetScript("OnUpdate", function(_, elapsed)
            throttle = throttle - elapsed

            if throttle < 0 then
                throttle = 3
                TrySummon()
            end
        end)

        RegisterAttributeDriver(WatchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")
    end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)