--[[--------------------------------------------------------------------

    Similar to the close button, but smaller and intended to act as an
    overlay over another element.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreateRemoveButton
do
    ---@param parent Frame
    CreateRemoveButton = function(parent)
        ---@class TherapyRemoveButton: TherapyFrame
        local Button = C.CreateFrame("Button", nil, parent)
        Button:SetSize(28, 28)
        Button:SetHitRectInsets(-2, -2, -2, -2)

        Button.Texture = Button:CreateTexture(nil, "OVERLAY")
        Button.Texture:SetSize(20, 20)
        Button.Texture:SetTexture(Media.Textures.Settings)
        Button.Texture:SetTexCoord(0.84375, 0.88281, 0, 0.03906)
        Button.Texture:SetPoint("CENTER")

        Button:SetScript("OnEnter", function(self)
            self.Texture:SetTexCoord(0.88281, 0.92187, 0, 0.03906)
        end)

        Button:SetScript("OnLeave", function(self)
            self.Texture:SetTexCoord(0.84375, 0.88281, 0, 0.03906)
        end)

        Button:SetScript("OnClick", function()
            PlaySoundFile(567481)
        end)

        return Button
    end

    C.CreateRemoveButton = CreateRemoveButton
end