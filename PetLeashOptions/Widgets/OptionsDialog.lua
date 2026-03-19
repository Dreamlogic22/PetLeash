--[[--------------------------------------------------------------------

    Primary settings panel opened by right-clicking the icon attached
    to the PetJournal or using slash commands (/petleash, /pl).

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, C.Media

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

-- -- Animation block
-- do
--     local MaxDisplay = 3
--     local Panels = {}
--     local CurrentIndex = 1
--     local CardsCurrentlyAnimating = 0

--     local function UpdateVisibleCards()
--         for _, panel in ipairs(Panels) do
--             panel:Hide()
--         end

--         -- Show and position the 3-card window starting at CurrentIndex
--         for i = 1, MaxDisplay do
--             local panelIndex = CurrentIndex + i - 1
--             if Panels[panelIndex] then
--                 Panels[panelIndex]:ClearAllPoints()
--                 Panels[panelIndex]:Show()

--                 if i == 1 then
--                     Panels[panelIndex]:SetPoint("LEFT", PetLeashOptionsDialog.PetCards, "LEFT", 25, 0)
--                 else
--                     Panels[panelIndex]:SetPoint("LEFT", Panels[CurrentIndex + i - 2], "RIGHT", 25, 0)
--                 end
--             end
--         end

--         -- Update arrow states
--         PetLeashOptionsDialog.LeftArrow:SetEnabled(CurrentIndex > 1)
--         PetLeashOptionsDialog.RightArrow:SetEnabled(CurrentIndex + MaxDisplay - 1 < #Panels)
--     end

--     function C.UpdatePetCards()
--         for _, panel in ipairs(Panels) do
--             panel:Hide()
--             panel:SetParent(nil)
--         end

--         wipe(Panels)

--         for i = 1, #C.db.pets do  -- Create ALL cards
--             local petID = C.db.pets[i]
--             local panel = C.CreatePetCard(PetLeashOptionsDialog.PetCards, petID)
--             Panels[i] = panel
--         end

--         CurrentIndex = 1  -- Reset to first card
--         UpdateVisibleCards()  -- Show and position first 3
--     end

--     function C.SetupArrowHandlers()
--         PetLeashOptionsDialog.LeftArrow:SetScript("OnClick", function(self)
--             if CurrentIndex > 1 and CardsCurrentlyAnimating == 0 then
--                 StartAnimation(-1)
--                 PlaySound(856)
--             end
--         end)

--         PetLeashOptionsDialog.RightArrow:SetScript("OnClick", function()
--             if CurrentIndex + MaxDisplay - 1 < #Panels and CardsCurrentlyAnimating == 0 then
--                 StartAnimation(1)
--                 PlaySound(856)
--             end
--         end)
--     end
-- end

        -- Card.SlideAnimation = Card:CreateAnimationGroup()
        -- Card.SlideTranslation = Card.SlideAnimation:CreateAnimation("Translation")
        -- Card.SlideTranslation:SetDuration(1)
        -- Card.SlideTranslation:SetSmoothing("IN_OUT")
do
    ---@class PetLeashOptionsDialog: TherapyFrame
    local Dialog = C.CreateFrame("Frame", "PetLeashOptionsDialog", UIParent)
    Dialog:SetSize(680, 580)
    Dialog:SetPoint("CENTER")
    Dialog:SetClampedToScreen(true)
    Dialog:SetFrameLevel(500)
    Dialog:SetFrameStrata("DIALOG")

    Dialog:CreateBackdrop()
    Dialog:SetBackdropTexture(Media.Textures.Background)
    Dialog:Hide()

    Dialog:SetMovable(true)
    Dialog:EnableMouse(true)
    Dialog:RegisterForDrag("LeftButton")
    Dialog:SetScript("OnDragStart", Dialog.StartMoving)
    Dialog:SetScript("OnDragStop", Dialog.StopMovingOrSizing)

    local Title = Dialog:CreateFontString(nil, "OVERLAY")
    Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
    Title:SetText(C.Title)
    Title:SetPoint("TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 14, "OUTLINE")
    Version:SetTextColor(Media.Colors.Background:GetRGB())
    Version:SetText(format(L.VERSION, C.Version))
    Version:SetPoint("BOTTOMRIGHT", -7, 7)

    Dialog.CloseButton = C.CreateCloseButton(Dialog)

	Dialog.AceContainer = CreateFrame("Frame", nil, Dialog)
	Dialog.AceContainer:SetSize(640, 230)
    Dialog.AceContainer:SetPoint("TOPLEFT", 20, -30)

	---@class AceGUIContainer
	---@field frame Frame
	local Group = AceGUI:Create("InlineGroup")
	Group:SetLayout("Fill")
	Group.frame:SetParent(Dialog.AceContainer)
	Group.frame:SetAllPoints()
	Group.frame:Show()
	Dialog.AceContainer.AcePanel = Group

	Dialog.CardContainer = C.CreateContainer(Dialog)
    Dialog.CardContainer:SetSize(640, 290)
    Dialog.CardContainer:SetPoint("BOTTOMLEFT", 20, 30)
    Dialog.CardContainer.Title:SetText(PETS)

    ---@class Carousel: TherapyFrame
    Dialog.Carousel = C.CreateCarousel(Dialog.CardContainer)
    Dialog.Carousel:Update()

    -- Dialog.LeftArrow = C.CreateBackArrowButton(Dialog.PetCards)
    -- Dialog.LeftArrow:SetPoint("LEFT", Dialog.PetCards, "LEFT", 0, 0)

    -- Dialog.RightArrow = C.CreateForwardArrowButton(Dialog.PetCards)
    -- Dialog.RightArrow:SetPoint("RIGHT", Dialog.PetCards, "RIGHT", 0, 0)

    function Dialog:Toggle()
        if PlayerIsInCombat() then
            if self:IsVisible() then
                self:Hide()
            end

            self.RestoreAfterCombat = true
            C.Print(L.OPTIONS_NOT_IN_COMBAT)
            return
        end

        if C.IsEditModeActive() then
            C.Print(L.OPTIONS_NOT_IN_EDIT_MODE)
            return
        end

        self:SetShown(not self:IsVisible())
    end

    function Dialog:Update()
        self.Carousel:Update()
    end

    Dialog:SetScript("OnHide", function()
        AceConfigDialog:Close("PetLeash")
    end)

    Dialog:SetScript("OnShow", function()
        AceConfigDialog:Open("PetLeash", Dialog.AceContainer.AcePanel)
    end)

    ---@param inCombat boolean
    local function HandleCombat(_, inCombat)
        if inCombat then
            if Dialog:IsVisible() then
                Dialog.RestoreAfterCombat = true
                Dialog:Hide()
            end
        else
            if Dialog.RestoreAfterCombat then
                Dialog.RestoreAfterCombat = nil
                Dialog:Show()
            end
        end
    end

    EventRegistry:RegisterFrameEventAndCallback("PLAYER_IN_COMBAT_CHANGED", HandleCombat)

    PetLeashOptionsDialog = Dialog
    tinsert(UISpecialFrames, "PetLeashOptionsDialog")
end