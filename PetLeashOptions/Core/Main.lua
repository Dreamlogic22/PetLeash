---@class PetLeashOptions
local C = select(2, ...)

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetStats = C_PetJournal.GetPetStats

do
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

    ---@return boolean
    function C.IsEditModeActive()
        return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
    end

	function C.NotifyChange()
		AceConfigRegistry:NotifyChange(C.Name)
	end

    function C.Print(...)
        print(strjoin("", "|cffd6bfa3PetLeash|r |cff947d66Options|r: ", ...))
    end
end

C.Options = {
    childGroups = "tab",
    name = "",
    order = 0,
    type = "group",
    args = {}
}

local function OnInitialize()
	SlashCmdList.PETLEASH = function() PetLeashOptionsDialog:Toggle() end

    AceConfig:RegisterOptionsTable(C.Name, C.Options)
    C.AceRegistered = true

    if not C.IsEditModeActive() then
        -- Echo user's first slash command
        PetLeashOptionsDialog:Toggle()
	end
end

EventUtil.ContinueOnAddOnLoaded(C.Name, OnInitialize)