---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local L = T.Locale

local CanSummon = C_PetJournal.GetPetSummonInfo
local GetCurrentPet = C_PetJournal.GetSummonedPetGUID
local GetSpeciesFromPetID = C_PetJournal.GetPetInfoByPetID
local HasControl = HasFullControl
local IsMoving = IsPlayerMoving
local SummonPet = C_PetJournal.SummonPetByGUID

local WatchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

local IsExcludedSpecies
do
    local Exclusions = {
        280,  -- Guild Page (Alliance)
        281,  -- Guild Page (Horde)
        282,  -- Guild Herald (Alliance)
        283,  -- Guild Herald (Horde)
    }

    IsExcludedSpecies = function(petGuid)
        if not petGuid then return false end

        local SpeciesID = GetSpeciesFromPetID(petGuid)
        if not SpeciesID then return false end

        for _, id in ipairs(Exclusions) do
            if SpeciesID == id then
                return true
            end
        end

        return false
    end
end

do
    local Interval = T.db.switchTimer
    local Throttle = T.db.throttle
    local TimeSinceSwitch = 0

    ---@return boolean
    function T.HasAnyPets()
        return T.db.pets and #T.db.pets > 0
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

    ---@param reason string?
    function T.Disable(reason)
        UnregisterAttributeDriver(WatchFrame, "state-visibility")
        WatchFrame:SetScript("OnUpdate", nil)

        if reason then
            T.Print(reason)
        end
    end

    function T.GetRandomPet()
        if not T.HasAnyPets() then
            T.Disable(L.NO_PETS)
            return
        end

        local Candidates = {}
        for _, guid in ipairs(T.db.pets) do
            if not IsExcludedSpecies(guid) then
                table.insert(Candidates, guid)
            end
        end

        if #Candidates == 0 then
            return nil
        end

        return Candidates[math.random(1, #Candidates)]
    end

    ---@param petGuid string?
    ---@return boolean
    function T.KeepPet(petGuid)
        if not petGuid then return false end

        if T.HasOverride() then
            return true
        end

        -- keep manually-summoned pets
        if T.db.override == false then
            return true
        end

        for _, guid in ipairs(T.db.pets) do
            if guid == petGuid then
                return true
            end
        end

        return false
    end

    function T.Print(...)
        print(strjoin("", "|cffd6bfa3", Name .. "|r: ", ...))
    end

    function T.TrySummon()
        local CurrentPet = GetCurrentPet()

        if not T.db.enable or not HasControl() or IsMoving() then
            return
        end

        -- Always respect overrides
        if CurrentPet and T.HasOverride() then
            return
        end

        if T.db.autoSwitch then
            if TimeSinceSwitch < Interval then
                return
            end
        else
            if CurrentPet and T.KeepPet(CurrentPet) then
                return
            end
        end

        local NewPet = T.GetRandomPet()
        if not NewPet then
            return
        end

        if CurrentPet == NewPet then
            return
        end

        if CanSummon(NewPet) then
            SummonPet(NewPet)
            TimeSinceSwitch = 0
        end
    end

    ---@param value number
    function T.UpdateThrottle(value)
        T.db.throttle = value or 3
        Throttle = value
    end

    ---@param value number
    function T.UpdateInterval(value)
        T.db.switchTimer = value or 300
        Interval = value
    end
end

local function OnInitialize()
    -- reloading or logging during combat
    if InCombatLockdown() then
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnInitialize)
    end

    if T.HasAnyPets() then
        T.Enable()
    else
        T.Disable(L.NO_PETS)
    end
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)