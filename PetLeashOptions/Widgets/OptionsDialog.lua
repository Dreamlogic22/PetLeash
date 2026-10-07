--[[--------------------------------------------------------------------

    Primary settings panel opened by right-clicking the icon attached
    to the PetJournal or using slash commands (/petleash, /pl).

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media, Options = T.Locale, C.Media, C.Options

do
	---@class PetLeashOptionsDialog: ToolkitFrameTemplate
	local Dialog = CreateFrame("Frame", "PetLeashOptionsDialog", UIParent, "ToolkitFrameTemplate")
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
	Version:SetTextColor(unpack(Media.Colors.Background))
	Version:SetText(format(L.VERSION, C.Version))
	Version:SetPoint("BOTTOMRIGHT", -7, 7)

	Dialog.CloseButton = C.CreateCloseButton(Dialog)

	Dialog.General = C.CreateConfigGroup(Dialog)
	Dialog.General:SetSize(640, 200)
	Dialog.General:SetPoint("TOPLEFT", 20, -50)
	Dialog.General.Title:SetText(GENERAL)

	-- Controls
	local Enable = Dialog.General:RegisterControl(Options.Enable)
	Enable:SetPoint("TOPLEFT", 10, -30)

	local ScanInterval = Dialog.General:RegisterControl(Options.ScanInterval)
	ScanInterval:SetPoint("LEFT", Enable, "RIGHT", 230, 0)

	local KeepSummonedPets = Dialog.General:RegisterControl(Options.KeepSummonedPets)
	KeepSummonedPets:SetPoint("TOP", Enable, "BOTTOM", 0, 0)

	Dialog.General:NotifyChange()

	-- Carousel
	Dialog.CardContainer = C.CreateContainer(Dialog)
	Dialog.CardContainer:SetSize(640, 290)
	Dialog.CardContainer:SetPoint("BOTTOMLEFT", 20, 30)
	Dialog.CardContainer.Title:SetText(PETS)

	Dialog.Carousel = C.CreateCarousel(Dialog.CardContainer)
	Dialog.Carousel:Update()

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

	---@param inCombat boolean
	local function HandleCombat(inCombat)
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

	Toolkit.RegisterEventCallback("PLAYER_IN_COMBAT_CHANGED", HandleCombat)

	PetLeashOptionsDialog = Dialog
	tinsert(UISpecialFrames, "PetLeashOptionsDialog")
end
