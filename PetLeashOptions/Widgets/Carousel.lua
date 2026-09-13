--[[--------------------------------------------------------------------

    Frame that acts as a "conveyor belt" for Pet Cards. Using attached
    arrow buttons to create a smooth slide when the buttons are pressed
    if more than three pets are currently selected.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreateBackStepper, CreateForwardStepper
do
	---@param parent Frame
	---@return PetLeashArrowButton
	local function CreateStepper(parent)
		---@class PetLeashArrowButton: ToolkitButtonTemplate
		local Arrow = CreateFrame("Button", nil, parent, "ToolkitButtonTemplate")
		Arrow:SetSize(16, 24)

		Arrow.Texture = Arrow:CreateTexture(nil, "ARTWORK")
		Arrow.Texture:SetTexture(Media.Textures.Slider)
		Arrow.Texture:SetSize(24, 24)
		Arrow.Texture:SetPoint("CENTER", Arrow, "CENTER")

		Arrow.Highlight = Arrow:CreateTexture(nil, "HIGHLIGHT")
		Arrow.Highlight:SetTexture(Media.Textures.Slider)
		Arrow.Highlight:SetSize(24, 24)
		Arrow.Highlight:SetPoint("CENTER", Arrow, "CENTER")
		Arrow.Highlight:SetBlendMode("ADD")
		Arrow.Highlight:SetVertexColor(0.5, 0.5, 0.5)

		Arrow:SetScript("OnClick", function()
			PlaySound(229883)
		end)

		Arrow:SetHoverColor(unpack(Media.Colors.Foreground))

		return Arrow
	end

	---@param parent Frame
	---@return PetLeashArrowButton
	CreateBackStepper = function(parent)
		local Arrow = CreateStepper(parent)
		Arrow.Texture:SetTexCoord(0, 0.25, 0.5, 0.625)
		Arrow.Highlight:SetTexCoord(0.5, 0.75, 0.5, 0.625)

		Arrow:SetScript(
			"OnDisable",
			---@param self PetLeashArrowButton
			function(self)
				self.Texture:SetTexCoord(0.25, 0.5, 0.5, 0.625)
			end
		)

		Arrow:SetScript(
			"OnEnable",
			---@param self PetLeashArrowButton
			function(self)
				self.Texture:SetTexCoord(0, 0.25, 0.5, 0.625)
			end
		)

		return Arrow
	end

	---@param parent Frame
	---@return PetLeashArrowButton
	CreateForwardStepper = function(parent)
		local Arrow = CreateStepper(parent)
		Arrow.Texture:SetTexCoord(0, 0.25, 0.625, 0.75)
		Arrow.Highlight:SetTexCoord(0.5, 0.75, 0.625, 0.75)

		Arrow:SetScript(
			"OnDisable",
			---@param self PetLeashArrowButton
			function(self)
				self.Texture:SetTexCoord(0.25, 0.5, 0.625, 0.75)
			end
		)

		Arrow:SetScript(
			"OnEnable",
			---@param self PetLeashArrowButton
			function(self)
				self.Texture:SetTexCoord(0.5, 0.75, 0.625, 0.75)
			end
		)

		return Arrow
	end
end

local CreateCarousel
do
	local MaxDisplay = 3

	---@param parent Frame
	---@return PetLeashCarousel
	CreateCarousel = function(parent)
		---@class PetLeashCarousel: ToolkitFrameTemplate
		local Carousel = CreateFrame("Frame", nil, parent, "ToolkitFrameTemplate")
		Carousel.AnimationDuration = 0.4
		Carousel.AnimationStart = 0
		Carousel.AnimationStartShift = 0
		Carousel.AnimationTargetShift = 0
		Carousel.CurrentIndex = 1
		Carousel.CurrentShift = 0
		Carousel.IsAnimating = false
		Carousel.Cards = {}

		Carousel:SetScript(
			"OnUpdate",
			---@param self PetLeashCarousel
			function(self)
				if #C.db.pets < 4 or not self.IsAnimating then
					return
				end

				local now = GetTime()
				local elapsedTime = now - self.AnimationStart
				local progress = elapsedTime / self.AnimationDuration

				if progress >= 1 then
					progress = 1
					self.IsAnimating = false
				end

				local currentShift = self.AnimationStartShift + (self.AnimationTargetShift - self.AnimationStartShift) * progress

				self:ClearAllPoints()
				self:SetPoint("LEFT", currentShift, 0)

				self.CurrentShift = self.AnimationTargetShift
				self.StepBack:SetEnabled(self.CurrentIndex > 1)
				self.StepForward:SetEnabled(self.CurrentIndex + MaxDisplay - 1 < #self.Cards)
			end
		)

		function Carousel:StartAnimation(direction)
			if self.IsAnimating then
				return
			end

			local offset = -205 * direction

			self.CurrentIndex = self.CurrentIndex + direction

			self.IsAnimating = true
			self.AnimationStart = GetTime()
			self.AnimationStartShift = self.CurrentShift
			self.AnimationTargetShift = self.CurrentShift + offset
		end

		function Carousel:Update()
			self.CurrentIndex = 1
			self.CurrentShift = 0

			for _, card in ipairs(self.Cards) do
				card:Hide()
				card:SetParent(nil)
			end

			wipe(self.Cards)

			for i = 1, #C.db.pets do
				local petID = C.db.pets[i]
				local card = C.CreatePetCard(Carousel, petID)
				card.PetID = petID

				self.Cards[i] = card
			end

			-- Adjust carousel width & card positions
			local baseWidth = 250

			self:ClearAllPoints()
			self:SetSize(baseWidth * #C.db.pets, 250)

			if #self.Cards >= MaxDisplay then
				self:SetPoint("LEFT")
			else
				self:SetPoint("CENTER")
			end

			for i = 1, #self.Cards do
				local cardIndex = self.CurrentIndex + i - 1

				if #self.Cards == 1 then
					self.Cards[cardIndex]:SetPoint("CENTER")
					break
				end

				if i == 1 then
					self.Cards[cardIndex]:SetPoint("LEFT", self, "LEFT", 25, 0)
				else
					self.Cards[cardIndex]:SetPoint("LEFT", self.Cards[self.CurrentIndex + i - 2], "RIGHT", 25, 0)
				end
			end

			self.StepBack:SetEnabled(self.CurrentIndex > 1)
			self.StepForward:SetEnabled(self.CurrentIndex + MaxDisplay - 1 < #self.Cards)
		end

		Carousel.StepBack = CreateBackStepper(parent)
		Carousel.StepBack:SetPoint("LEFT")
		Carousel.StepBack:HookScript("OnClick", function()
			Carousel:StartAnimation(-1)
		end)

		Carousel.StepForward = CreateForwardStepper(parent)
		Carousel.StepForward:SetPoint("RIGHT")
		Carousel.StepForward:HookScript("OnClick", function()
			Carousel:StartAnimation(1)
		end)

		return Carousel
	end

	C.CreateCarousel = CreateCarousel
end
