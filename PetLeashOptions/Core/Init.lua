--[[--------------------------------------------------------------------

    PetLeash Options 4.01 (March 18, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetStats = C_PetJournal.GetPetStats

---@class PetLeashOptions: TherapyAPI
local C = select(2, ...)
do
    C.Name = Name
    C.Title = GetAddOnMetadata(Name, "Title")
    C.Version = GetAddOnMetadata(Name, "Version")
    C.db = PetLeashDB

    TherapyUX.Embed(C)

    ---@return boolean
    function C.IsEditModeActive()
        return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
    end

    ---@param petID string
    ---@return PetCardInfo
    function C.GetPetCardInfo(petID)
        local speciesID, customName, _, _, _, displayID, _, name = GetPetInfoByPetID(petID)
        local health, _, _, _, rarity = GetPetStats(petID)
        local colorData = ColorManager.GetColorDataForItemQuality(rarity - 1)

        ---@class PetCardInfo
        local petCardInfo = {
            CustomName = customName,
            DisplayID = displayID,
            IsDead = health <= 0,
            Name = name,
            SpeciesID = speciesID,
            GetRGB = function() return colorData.r, colorData.g, colorData.b end
        }

        return petCardInfo
    end

	function C.NotifyChange()
		AceConfigRegistry:NotifyChange(C.Name)
	end

    function C.Print(...)
        print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
    end
end

local function OnInitialize()
    AceConfigRegistry:RegisterOptionsTable("PetLeash", C.Options)

    SlashCmdList.PETLEASH = function() PetLeashOptionsDialog:Toggle() end

    if not C.IsEditModeActive() and PetLeash.ShowDialog then
        -- Echo user's first slash command
        PetLeashOptionsDialog:Toggle()
	end

    -- Always clear the dialog flag
    PetLeash.ShowDialog = nil
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)