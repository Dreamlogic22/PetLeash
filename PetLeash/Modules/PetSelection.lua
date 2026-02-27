--[[--------------------------------------------------------------------

    Hooks into the Blizzard Collections frame that allow a user
    to select pets they want to add or remove from the pool.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local L, Media = T.Locale, T.Media

local GetPetSummonInfo = C_PetJournal.GetPetSummonInfo

---@param petId number
local function IsSelected(petId)
    if not petId or not T.db.pets then
        return false
    end

    for _, id in ipairs(T.db.pets) do
        if id == petId then return true end
    end

    return false
end

---@param petId number
local function AddPet(petId)
    if not petId then return end

    if not T.db.pets then
        T.db.pets = {}
    end

    if T.db.pets and tContains(T.db.pets, petId) then
        return
    end

    if #T.db.pets == 0 then
        -- If this is our first pet on a fresh install, enable
        T.Enable()
    end

    table.insert(T.db.pets, petId)
end

---@param petId number
local function RemovePet(petId)
    if not petId or not T.db.pets then return end

    for i, id in ipairs(T.db.pets) do
        if id == petId then
            table.remove(T.db.pets, i)
            return
        end
    end

    if not T.db.pets or #T.db.pet == 0 then
        T.Disable()
    end
end

local CreateButton
do
    local function LoadOptions()
        if C_AddOns.IsAddOnLoaded("PetLeashOptions") then return end

        if InCombatLockdown() then
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

    local function OnClick()
        PlaySound(856)
        LoadOptions()
    end

    ---@param parent Frame
    CreateButton = function(parent)
        local Button = CreateFrame("Button", "PetLeashOptionsToggle", parent, "UIPanelButtonTemplate")
        Button:SetSize(140, 22)
        Button:SetPoint("RIGHT", PetJournalFindBattle, "LEFT", -5, 0)
        Button:EnableMouse(true)
        Button:RegisterForClicks("AnyDown")

        Button:SetScript("OnClick", OnClick)

        Button.Label = Button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        Button.Label:SetPoint("CENTER")
        Button.Label:SetText("PetLeash")

        if ElvUI then
            ElvUI[1]:GetModule("Skins"):HandleButton(Button)
        end

        PetLeashOptionsToggle = Button
    end
end

local AddCheckbox, CreateCheckBox
do
    ---@class PetJournalButton: Button
    ---@field petID number
    ---@field owned boolean

    ---@param button PetJournalButton
    AddCheckbox = function(button)
        if not button.petID then return end

        if not button.PetLeashCheckbox then
            button.PetLeashCheckbox = CreateCheckBox(button)
            button:SetSize(24, 24)
            button:SetPoint("RIGHT", PetJournal, "RIGHT", -15, 0)

            button.PetLeashCheckbox:SetScript("OnClick", function(self)
                local id = button.petID
                if self:GetChecked() then
                    self.CheckedTexture:Show()
                    PlaySound(857)
                    AddPet(id)
                else
                    self.CheckedTexture:Hide()
                    PlaySound(856)
                    RemovePet(id)
                end
            end)

            button.PetLeashCheckbox:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine("|cff33ff99PetLeash|r")
                GameTooltip:AddLine(L.ADD_OR_REMOVE_PET, 1, 1, 1, true)
                GameTooltip:Show()
            end)

            button.PetLeashCheckbox:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end

        local IsChecked = IsSelected(button.petID)
        button.PetLeashCheckbox:SetChecked(IsChecked)
        if IsChecked then
            button.PetLeashCheckbox.CheckedTexture:Show()
        else
            button.PetLeashCheckbox.CheckedTexture:Hide()
        end
    end

    ---@param parent Frame
    CreateCheckBox = function(parent)
        local Button = CreateFrame("CheckButton", nil, parent)
        Button:SetSize(24, 24)
        Button:SetPoint("RIGHT", parent, "RIGHT", -15, 0)

        Button.Border = Button:CreateTexture(nil, "ARTWORK")
        Button.Border:SetTexture(Media.Textures.Checkbox)
        Button.Border:SetTexCoord(0, 0.5, 0, 0.5)
        Button.Border:SetPoint("CENTER", Button, "LEFT", 8, 0)
        Button.Border:SetSize(32, 32)
        Button.Border:SetSnapToPixelGrid(false)
        Button.Border:SetTexelSnappingBias(0)

        Button.CheckedTexture = Button:CreateTexture(nil, "OVERLAY")
        Button.CheckedTexture:SetTexture(Media.Textures.Checkbox)
        Button.CheckedTexture:SetTexCoord(0.5, 0.75, 0.5, 0.75)
        Button.CheckedTexture:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.CheckedTexture:SetSize(16, 16)
        Button.CheckedTexture:SetSnapToPixelGrid(false)
        Button.CheckedTexture:SetTexelSnappingBias(0)
        Button.CheckedTexture:Hide()

        Button.Highlight = Button:CreateTexture(nil, "HIGHLIGHT")
        Button.Highlight:SetTexture(Media.Textures.Checkbox)
        Button.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
        Button.Highlight:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.Highlight:SetSize(32, 32)
        Button.Highlight:SetBlendMode("ADD")
        Button.Highlight:SetVertexColor(0.5, 0.5, 0.5)
        Button.Highlight:SetSnapToPixelGrid(false)
        Button.Highlight:SetTexelSnappingBias(0)

        return Button
    end
end

local function OnPetJournalLoad()
    CreateButton(PetJournal)

    hooksecurefunc("PetJournal_InitPetButton", function(button)
        AddCheckbox(button)
    end)

    -- Hide checkbox for unowned & faction-locked pets
    hooksecurefunc(PetJournal.ScrollBox, "Update", function(frame)
        frame:ForEachFrame(function(button)
            button.PetLeashCheckbox:SetShown(button.owned)

            if button.petID then
                local _, error = GetPetSummonInfo(button.petID)
                local neverUsable = error == Enum.PetJournalError.InvalidFaction

                if neverUsable then
                    button.PetLeashCheckbox:Hide()
                else
                    button.PetLeashCheckbox:Show()
                end
            end
        end)
    end)
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", OnPetJournalLoad)