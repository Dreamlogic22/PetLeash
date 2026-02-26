--[[--------------------------------------------------------------------

    Summon or switch pets.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local CanSummon = C_PetJournal.GetPetSummonInfo
local HasControl = HasFullControl
local IsMoving = IsPlayerMoving
local SummonPet = C_PetJournal.SummonPetByGUID
local GetCurrentPet = C_PetJournal.GetSummonedPetGUID

function T.TrySummon()
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