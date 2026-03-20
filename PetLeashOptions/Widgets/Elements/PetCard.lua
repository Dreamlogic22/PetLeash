--[[--------------------------------------------------------------------

    Panels that display in the Options Dialog.  Shows animated models
    of selected pets along with a remove button.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Media = C.Media

local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetModelSceneInfoBySpeciesID = C_PetJournal.GetPetModelSceneInfoBySpeciesID
local GetPetStats = C_PetJournal.GetPetStats

---@param petID string
---@return PetCardInfo
local function GetCardInfo(petID)
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

local CreatePetCard
do
    ---@param parent Frame
    ---@param petID string
    ---@return PetCard
    CreatePetCard = function(parent, petID)
        local cardInfo = GetCardInfo(petID)

        ---@class PetCard: TherapyFrame
        local Card = C.CreateFrame("Frame", nil, parent, "BackdropTemplate")
        Card:SetSize(180, 230)
        Card:SetFrameLevel(parent:GetFrameLevel() + 1)
        Card:CreateBackdrop()
        Card:SetBackdropColor(0.58, 0.49, 0.4, 0.2)
        Card:SetBorderColor(cardInfo:GetRGB())

        Card.RemoveButton = C.CreateCloseButton(Card)
        Card.RemoveButton:SetPoint("TOPRIGHT", -6, -6)
        Card.RemoveButton:SetHoverColor(cardInfo:GetRGB())

        Card.RemoveButton:HookScript("OnClick", function()
            for i, id in ipairs(C.db.pets) do
                if id == petID then
                    tremove(C.db.pets, i)
                    break
                end
            end

            if PetJournal:IsVisible() then
                C.RefreshPetJournal()
            end

            C.NotifyChange()
        end)

        -- Sourced from Interface/AddOns/Blizzard_Collections/Shared/Blizzard_PetCollection.lua
        local loadoutModelSceneID = select(2, GetPetModelSceneInfoBySpeciesID(cardInfo.SpeciesID))

        Card.ModelScene = CreateFrame("ModelScene", nil, Card, "ModelSceneMixinTemplate")
        Card.ModelScene:SetUsingParentLevel(true)
        Card.ModelScene:SetSize(160, 180)
        Card.ModelScene:SetPoint("TOP", 0, -10)

        Card.ModelScene:TransitionToModelSceneID(loadoutModelSceneID, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_MAINTAIN, true)

        local PetActor = Card.ModelScene:GetActorByTag("pet")
        if PetActor then
            PetActor:SetModelByCreatureDisplayID(cardInfo.DisplayID, true)
            PetActor:SetAnimationBlendOperation(Enum.ModelBlendOperation.None)

            if cardInfo.IsDead then
                PetActor:SetAnimation(6, 1)
            else
                PetActor:SetAnimation(0, -1)
            end
        end

        local Name = Card:CreateFontString(nil, "OVERLAY")
        Name:SetFont(Media.Fonts.Normal, 14, "OUTLINE")
        Name:SetPoint("BOTTOM", Card, "BOTTOM", 0, 10)
        Name:SetText(cardInfo.CustomName or cardInfo.Name or UNKNOWN)
        Name:SetTextColor(Media.Colors.Foreground:GetRGB())

        return Card
    end

    C.CreatePetCard = CreatePetCard
end