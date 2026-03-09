--[[------------------------------------------------------------------

    Loads options addon using a paw icon attached to the pet journal.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L, Media = T.Locale, T.Media

local function LoadOptions()
    if PlayerIsInCombat() then
        T.Print(L.OPTIONS_NOT_IN_COMBAT)
        EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", LoadOptions)
        return
    end

    local loaded, reason = C_AddOns.LoadAddOn("PetLeashOptions")
    if not loaded then
        T.Print(L.OPTIONS_LOAD_ERROR, reason or UNKNOWN)
        return
    end
end

local function OnPetJournalLoad()
    ---@class PetLeashOptionsButton: TuxButton
    local Button = T.ConstructButton("PetLeashOptionsButton", PetJournal)
    Button:SetSize(48, 48)
    Button:SetFrameStrata("HIGH")
    Button:SetFrameLevel(10)
    Button:SetPoint("CENTER", PetJournal, "RIGHT", 0, 0)
    Button:SetupTextures(Media.Textures.PetJournalWidget)
    Button:RegisterForClicks("AnyDown")

    ---@param button MouseButton
    Button:SetScript("OnClick", function(_, button)
        PlaySound(856)
        Button.LastClicked = button

        LoadOptions()
    end)

    Button:SetScript("OnEnter", function(self)
        if not GameTooltip:IsForbidden() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
            GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
            GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)

    Button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    PetLeashOptionsButton = Button
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", OnPetJournalLoad)