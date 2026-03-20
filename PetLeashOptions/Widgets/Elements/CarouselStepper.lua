--[[--------------------------------------------------------------------

    Arrow buttons for the carousel stepper.  Based on the slider
    steppers, specialized for the carousel.

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

    C.CreateBackStepper = CreateBackStepper
    C.CreateForwardStepper = CreateForwardStepper
end