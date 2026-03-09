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

local watchFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerShowHideTemplate")

local isExcludedSpecies
do
    local exclusions = {
        280,  -- Guild Page (Alliance)
        281,  -- Guild Page (Horde)
        282,  -- Guild Herald (Alliance)
        283,  -- Guild Herald (Horde)
    }

    isExcludedSpecies = function(petGuid)
        if not petGuid then return false end

        local speciesID = GetSpeciesFromPetID(petGuid)
        if not speciesID then return false end

        for _, id in ipairs(exclusions) do
            if speciesID == id then
                return true
            end
        end

        return false
    end
end

do
    local interval = T.db.switchTimer
    local throttle = T.db.throttle
    local timeSinceSwitch = 0

    ---@param reason string?
    function T.Disable(reason)
        UnregisterAttributeDriver(watchFrame, "state-visibility")
        watchFrame:SetScript("OnUpdate", nil)

        if reason then
            T.Print(reason)
        end
    end

    function T.Enable()
        ---@param elapsed number
        watchFrame:SetScript("OnUpdate", function(_, elapsed)
            throttle = throttle - elapsed
            timeSinceSwitch = timeSinceSwitch + elapsed

            if throttle < 0 then
                throttle = 3
                T.TrySummon()
            end
        end)

        RegisterAttributeDriver(watchFrame, "state-visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][channeling][flying][mounted][pvpcombat][stealth][dead][combat] hide; show")
    end

    ---@return boolean
    function T.HasAnyPets()
        return T.db.pets and #T.db.pets > 0
    end

    function T.GetRandomPet()
        if not T.HasAnyPets() then
            T.Disable(L.NO_PETS)
            return
        end

        local candidates = {}
        for _, guid in ipairs(T.db.pets) do
            if not isExcludedSpecies(guid) then
                table.insert(candidates, guid)
            end
        end

        if #candidates == 0 then
            return nil
        end

        return candidates[math.random(1, #candidates)]
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
        local currentPet = GetCurrentPet()

        if not T.db.enable or not HasControl() or IsMoving() then
            return
        end

        -- Always respect overrides
        if currentPet and T.HasOverride() then
            return
        end

        if T.db.autoSwitch then
            if timeSinceSwitch < interval then
                return
            end
        else
            if currentPet and T.KeepPet(currentPet) then
                return
            end
        end

        local newPet = T.GetRandomPet()
        if not newPet then
            return
        end

        if currentPet == newPet then
            return
        end

        if CanSummon(newPet) then
            SummonPet(newPet)
            timeSinceSwitch = 0
        end
    end

    ---@param value number
    function T.UpdateThrottle(value)
        T.db.throttle = value or 3
        throttle = value
    end

    ---@param value number
    function T.UpdateInterval(value)
        T.db.switchTimer = value or 300
        interval = value
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