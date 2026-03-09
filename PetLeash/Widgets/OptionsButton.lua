---@class PetLeash
local T = select(2, ...)
local L, Media = T.Locale, T.Media

local SetDefaultFilters = C_PetJournal.SetDefaultFilters

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
    ---@param self PetLeashOptionsButton
    ---@param button MouseButton
    local function OnClick(self, button)
        PlaySound(856)

        if button == "LeftButton" then
            self.SelectingPets = not self.SelectingPets

            self:ToggleSelectionMode()

            -- hack to avoid PetJournal_UpdatePetList
            SetDefaultFilters()
        end

        if button == "RightButton" and not self.SelectingPets then
            LoadOptions()
        end
    end

    ---@class PetLeashOptionsButton: Button
    local Button = T.ConstructButton() -- CreateFrame("Button", "PetLeashOptionsButton", UIParent)
    Button.SelectingPets = false

    Button:SetSize(48, 48)
    Button:SetFrameStrata("HIGH")
    Button:SetFrameLevel(10)
    Button:Hide()

    T.SetupButtonTextures(Button, Media.Textures.Paw)

    Button:RegisterForClicks("AnyDown")

    Button:SetScript("OnClick", OnClick)

    Button:SetScript("OnEnter", function(self)
        if not GameTooltip:IsForbidden() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10)
            GameTooltip:AddLine(Media.Colors.Foreground:WrapTextInColorCode("PetLeash"))
            GameTooltip:AddLine(self.SelectingPets and L.PET_SELECTION_INSTRUCTIONS_PET_SELECTION_ACTIVE or L.PET_SELECTION_INSTRUCTIONS_LEFT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:AddLine(L.PET_SELECTION_INSTRUCTIONS_RIGHT_CLICK_DOWN, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)

    Button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    Button:SetScript("OnHide", function(self)
        if self.SelectingPets then
            self.SelectingPets = false
            self:ToggleSelectionMode()
        end
    end)

    function Button:ToggleSelectionMode()
        local active = self.SelectingPets

        self:DesaturateHierarchy(active and 1 or 0)

        local r, g, b
        if active then
            r, g, b = Media.Colors.Foreground:GetRGB()
        else
            r, g, b = 1, 1, 1
        end

        self:GetNormalTexture():SetVertexColor(r, g, b)
    end

    PetLeashOptionsButton = Button
end