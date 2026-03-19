--[[--------------------------------------------------------------------

    Frame that acts as a "strip" that hosts Pet Cards. Using attached
    arrow buttons to create a smooth slide when the buttons are pressed
    if more than three pets are currently selected.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreateCarousel
do
    local CurrentIndex = 1
    local MaxDisplay = 3

    ---@param parent Frame
    ---@return Carousel
    CreateCarousel = function(parent)
        ---@class Carousel: TherapyFrame
        local Carousel = C.CreateFrame("Frame", nil, parent)
        Carousel.Cards = {}

        function Carousel:Update()
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

            -- Adjust width & card positions
            local baseHeight, baseWidth = 250, 250

            self:ClearAllPoints()
            self:SetSize(baseWidth * #C.db.pets, baseHeight)

            if #self.Cards >= MaxDisplay then
                self:SetPoint("LEFT")
            else
                self:SetPoint("CENTER")
            end

            for i = 1, #self.Cards do
                local cardIndex = CurrentIndex + i - 1

                if #self.Cards == 1 then
                    self.Cards[cardIndex]:SetPoint("CENTER")
                    break
                end

                if i == 1 then
                    self.Cards[cardIndex]:SetPoint("LEFT", self, "LEFT", 25, 0)
                else
                    self.Cards[cardIndex]:SetPoint("LEFT", self.Cards[CurrentIndex + i - 2], "RIGHT", 25, 0)
                end
            end

        end

        return Carousel
    end

    C.CreateCarousel = CreateCarousel
end