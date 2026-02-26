---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

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
    function T.GetRandomPet()
        if not T.db.pets or #T.db.pets == 0 then
            return nil
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
    function T.KeepPet(petGuid)
        if not petGuid then return false end

        if T.HasOverride() then
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
        print(strjoin("", "|cff33ff99", Name .. "|r: ", ...))
    end

    function T.TrySummon()
        local CurrentPet = GetCurrentPet()

        if not T.db.enable or not HasControl() or IsMoving() then
            return
        end

        if CurrentPet and T.KeepPet(CurrentPet) then
            return
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
        end
    end
end

local function OnInitialize()
    if InCombatLockdown() then
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", OnInitialize)
    end

    if not T.db.pets or #T.db.pets == 0 then
        T.Print("You do not have any pets selected.  Open the Pet Journal and pick some companions using the checkboxes!")
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