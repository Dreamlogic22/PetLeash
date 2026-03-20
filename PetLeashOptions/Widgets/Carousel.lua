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
    ---@return TherapyArrowButton
    local function CreateArrowButton(parent)
        ---@class TherapyArrowButton: TherapyFrame
        local Arrow = CreateFrame("Button", nil, parent)
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

        Arrow:SetScript("OnEnter", function(self)
            self.Texture:SetVertexColor(Media.Colors.Foreground:GetRGB())
        end)

        Arrow:SetScript("OnLeave", function(self)
            self.Texture:SetVertexColor(1, 1, 1)
        end)

        return Arrow
    end

    ---@param parent Frame
    ---@return TherapyArrowButton
    CreateBackStepper = function(parent)
        local Arrow = CreateArrowButton(parent)
        Arrow.Texture:SetTexCoord(0, 0.25, 0.5, 0.625)
        Arrow.Highlight:SetTexCoord(0.5, 0.75, 0.5, 0.625)

        Arrow:SetScript("OnDisable", function(self)
            self.Texture:SetTexCoord(0.25, 0.5, 0.5, 0.625)
        end)

        Arrow:SetScript("OnEnable", function(self)
            self.Texture:SetTexCoord(0, 0.25, 0.5, 0.625)
        end)

        return Arrow
    end

    ---@param parent Frame
    ---@return TherapyArrowButton
    CreateForwardStepper = function(parent)
        local Arrow = CreateArrowButton(parent)
        Arrow.Texture:SetTexCoord(0, 0.25, 0.625, 0.75)
        Arrow.Highlight:SetTexCoord(0.5, 0.75, 0.625, 0.75)

        Arrow:SetScript("OnDisable", function(self)
            self.Texture:SetTexCoord(0.25, 0.5, 0.625, 0.75)
        end)

        Arrow:SetScript("OnEnable", function(self)
            self.Texture:SetTexCoord(0.5, 0.75, 0.625, 0.75)
        end)

        return Arrow
    end
end

local CreateCarousel
do
    local MaxDisplay = 3

    ---@param parent Frame
    ---@return Carousel
    CreateCarousel = function(parent)
        ---@class Carousel: TherapyFrame
        local Carousel = C.CreateFrame("Frame", nil, parent)
        Carousel.CurrentIndex = 1
        Carousel.CurrentShift = 0
        Carousel.Cards = {}

        Carousel.SlideAnimation = Carousel:CreateAnimationGroup()
        Carousel.SlideTranslation = Carousel.SlideAnimation:CreateAnimation("Translation")
        Carousel.SlideTranslation:SetDuration(0.2)
        Carousel.SlideTranslation:SetSmoothing("IN_OUT")

        Carousel.SlideAnimation:SetScript("OnFinished", function()
            Carousel:ClearAllPoints()
            Carousel:SetPoint("LEFT", Carousel.CurrentShift, 0)

            Carousel.StepBack:SetEnabled(Carousel.CurrentIndex > 1)
            Carousel.StepForward:SetEnabled(Carousel.CurrentIndex + MaxDisplay - 1 < #Carousel.Cards)
        end)

        ---@param direction  number
        function Carousel:StartAnimation(direction)
            local offset = -205 * direction

            self.CurrentIndex = self.CurrentIndex + direction
            self.CurrentShift = self.CurrentShift + offset  -- Track total shift

            self.SlideTranslation:SetOffset(offset, 0)
            self.SlideAnimation:Play()
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
        Carousel.StepBack:HookScript("OnClick", function(self)
            Carousel:StartAnimation(-1)
        end)

        Carousel.StepForward = CreateForwardStepper(parent)
        Carousel.StepForward:SetPoint("RIGHT")
        Carousel.StepForward:HookScript("OnClick", function(self)
            Carousel:StartAnimation(1)
        end)

        return Carousel
    end

    C.CreateCarousel = CreateCarousel
end