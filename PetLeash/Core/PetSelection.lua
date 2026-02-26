--[[--------------------------------------------------------------------

    Hooks into the Blizzard Collections frame that allow a user
    to select pets they want to add or remove from the pool.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local Media = T.Media

---@param petID number
local function IsSelected(petID)
    if not petID or not T.db.pets then
        return false
    end

    for _, id in ipairs(T.db.pets) do
        if id == petID then return true end
    end

    return false
end

---@param petID number
local function AddPet(petID)
    if not petID then return end

    if not T.db.pets then
        T.db.pets = {}
    end

    if T.db.pets and tContains(T.db.pets, petID) then
        return
    end

    table.insert(T.db.pets, petID)
end

---@param petID number
local function RemovePet(petID)
    if not petID or not T.db.pets then return end

    for i, id in ipairs(T.db.pets) do
        if id == petID then
            table.remove(T.db.pets, i)
            return
        end
    end
end

local function CreateCheckBox(parent)
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

---@class PetJournalButton: Button
---@field petID number

---@param button PetJournalButton
local function AddCheckbox(button)
    if not button.petID then return end

    if not button.PetLeashChecbox then
        button.PetLeashChecbox = CreateCheckBox(button)
        button.PetLeashChecbox:SetScript("OnClick", function(self)
            local id = button.petID
            if self:GetChecked() then
                self.CheckedTexture:Show()
                AddPet(id)
            else
                self.CheckedTexture:Hide()
                RemovePet(id)
            end
        end)

        button.PetLeashChecbox:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("|cff33ff99PetLeash|r")
            GameTooltip:AddLine("Add or remove this pet from PetLeash.", 1, 1, 1, true)
            GameTooltip:Show()
        end)

        button.PetLeashChecbox:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    local IsChecked = IsSelected(button.petID)
    button.PetLeashChecbox:SetChecked(IsChecked)
    if IsChecked then
        button.PetLeashChecbox.CheckedTexture:Show()
    else
        button.PetLeashChecbox.CheckedTexture:Hide()
    end
end

local function OnPetJournalLoad()
    hooksecurefunc("PetJournal_InitPetButton", function(button)
        AddCheckbox(button)
    end)
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", OnPetJournalLoad)