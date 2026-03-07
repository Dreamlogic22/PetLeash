---@class PetLeash
local T = select(2, ...)
local L, Media = T.Locale, T.Media

local SelectingPets = false

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

do
    ---@class PetLeashOptionsButton
    local OptionsButton = CreateFrame("Button", "PetLeashOptionsButton", UIParent)
    OptionsButton = Mixin(OptionsButton, PetLeashButtonMixin)
    OptionsButton:SetSize(48, 48)
    OptionsButton:SetFrameStrata("HIGH")
    OptionsButton:SetFrameLevel(10)
    OptionsButton:SetupTextures(Media.Textures.Paw)
    OptionsButton:Hide()

    OptionsButton.Notification = OptionsButton:CreateTexture(nil, "OVERLAY")
    OptionsButton.Notification:SetAtlas("UI-HUD-MicroMenu-Communities-Icon-Notification")
    OptionsButton.Notification:SetSize(21, 21)
    OptionsButton.Notification:SetPoint("CENTER", OptionsButton, "CENTER", 0, 0)
    OptionsButton.Notification:Hide()

    OptionsButton:RegisterForClicks("AnyDown")

    OptionsButton:SetScript("OnClick", function(self, button)
        PlaySound(856)

        if button == "LeftButton" then
            SelectingPets = not SelectingPets

            self.Notification:SetShown(SelectingPets)
            self:SetDesaturated(SelectingPets)

            -- extremely expensive call
            PetJournal_UpdatePetList()
        end

        if button == "RightButton" and not SelectingPets then
            LoadOptions()
        end
    end)

    OptionsButton:SetScript("OnEnter", function(self)
        if not GameTooltip:IsForbidden() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
            GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
            GameTooltip:AddLine(SelectingPets and L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE or L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)

    OptionsButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    OptionsButton:SetScript("OnHide", function(self)
        if SelectingPets then
            SelectingPets = false
            self.Notification:Hide()
        end
    end)

    PetLeashOptionsButton = OptionsButton
end