--[[--------------------------------------------------------------------

    Panels that display in the Options Dialog.  Shows animated models
    of selected pets along with a remove button.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Media = C.Media

local GetPetModelSceneInfoBySpeciesID = C_PetJournal.GetPetModelSceneInfoBySpeciesID

local CreatePetCard
do
    ---@param parent TherapyGroup
    ---@param petID string
    ---@return PetCard
    CreatePetCard = function(parent, petID)
        local cardInfo = C.GetPetCardInfo(petID)

        ---@class PetCard: TherapyFrame
        local Card = C.CreateFrame("Frame", nil, parent, "BackdropTemplate")
        Card:SetSize(180, 230)
        Card:SetFrameLevel(parent:GetFrameLevel() + 1)
        Card:CreateBackdrop()
        Card:SetBackdropColor(0.58, 0.49, 0.4, 0.2)
        Card:SetBorderColor(cardInfo:GetRGB())

        Card.RemoveButton = C.CreateRemoveButton(Card)
        Card.RemoveButton:SetPoint("TOPRIGHT", -2, -1)

        Card.RemoveButton:HookScript("OnClick", function()
            for i, id in ipairs(C.db.pets) do
                if id == petID then
                    tremove(C.db.pets, i)
                    break
                end
            end

            if not C.db.pets or #C.db.pets == 0 then
                T.Disable()
            end

            if #C.db.pets < 2 then
                C.db.autoSwitch = false
                PetLeashOptionsDialog.General:NotifyChange()
            end

            if PetJournal:IsVisible() then
                C_PetJournal.SetDefaultFilters()
            end

            C.UpdatePetCards()
        end)

        -- Sourced from Interface/AddOns/Blizzard_Collections/Shared/Blizzard_PetCollection.lua
        local loadoutModelSceneID = select(2, GetPetModelSceneInfoBySpeciesID(cardInfo.SpeciesID))

        Card.ModelScene = CreateFrame("ModelScene", nil, Card, "ModelSceneMixinTemplate")
        Card.ModelScene:SetUsingParentLevel(true)
        Card.ModelScene:SetSize(160, 180)
        Card.ModelScene:SetPoint("TOP", 0, -10)

        Card.ModelScene:TransitionToModelSceneID(loadoutModelSceneID, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_DISCARD, true)

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

        Card.SlideAnimation = Card:CreateAnimationGroup()
        Card.SlideTranslation = Card.SlideAnimation:CreateAnimation("Translation")
        Card.SlideTranslation:SetDuration(0.4)
        Card.SlideTranslation:SetSmoothing("IN_OUT")

        return Card
    end

    C.CreatePetCard = CreatePetCard
end