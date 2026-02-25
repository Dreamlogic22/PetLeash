---@class PetLeash
local T = select(2, ...)

local function CreatePoolCheckbox()
    -- Create checkbox on Pet Journal scroll buttons
    -- Toggle pet in/out of T.profile.customPool
end

local function OnPetJournalShow()
    -- Hook Pet Journal buttons when it opens
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", OnPetJournalShow)