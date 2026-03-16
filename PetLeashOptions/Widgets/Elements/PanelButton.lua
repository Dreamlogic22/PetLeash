--[[--------------------------------------------------------------------

    UI button for dialogs.  Stylized with highlights and dynamic
    scaling.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreatePanelButton
do
    CreatePanelButton = function(parent)
        ---@class TherapyPanelButton: TherapyFrame
        local Button = C.CreateFrame("Button", nil, parent)
        Button:SetSize(144, 24)
        -- Button:SetupTextures(Media.Textures.Panels)

        -- local Normal, Highlight, Pushed = Button:GetNormalTexture(), Button:GetHighlightTexture(), Button:GetPushedTexture()

        -- Normal:SetTextureSliceMargins(32, 16, 32, 16)
        -- Normal:SetTextureSliceMode(1)
        -- Normal:SetTexCoord(0/512, 128/512, 68/512, 132/512)

        -- Highlight:SetTextureSliceMargins(32, 16, 32, 16)
        -- Highlight:SetTextureSliceMode(0)
        -- Highlight:SetBlendMode("ADD")
        -- Highlight:SetVertexColor(0.5, 0.5, 0.5)
        -- Highlight:SetTexCoord(396/512, 1, 68/512, 132/512)

        -- Pushed:SetTextureSliceMargins(32, 16, 32, 16)
        -- Pushed:SetTextureSliceMode(1)
        -- Pushed:SetTexCoord(0/512, 128/512, 68/512, 132/512)
        -- Pushed:SetTexCoord(132/512, 260/512, 68/512, 132/512)

        Button.Background = Button:CreateTexture(nil, "BACKGROUND")
        Button.Background:SetTexture(Media.Textures.Panels)
        Button.Background:SetTextureSliceMargins(32, 16, 32, 16)
        Button.Background:SetTextureSliceMode(1)
        Button.Background:SetAllPoints()
        Button.Background:SetTexCoord(0/512, 128/512, 68/512, 132/512)
        Button.Background:DisableSharpening()

        Button.Highlight = Button:CreateTexture(nil, "HIGHLIGHT")
        Button.Highlight:SetTexture(Media.Textures.Panels)
        Button.Highlight:SetTextureSliceMargins(32, 16, 32, 16)
        Button.Highlight:SetTextureSliceMode(0)
        Button.Highlight:SetAllPoints()
        Button.Highlight:SetBlendMode("ADD")
        Button.Highlight:SetVertexColor(0.5, 0.5, 0.5)
        Button.Highlight:SetTexCoord(396/512, 1, 68/512, 132/512)

        Button:SetNormalFontObject("GameFontHighlight")
        Button:SetHighlightFontObject("GameFontHighlight")
        Button:SetDisabledFontObject("GameFontDisable")
        Button:SetPushedTextOffset(0, -1)

        Button:SetScript("OnMouseDown", function(self)
            if self:IsEnabled() then
                PlaySound(856)

                self.Background:SetTexCoord(132/512, 260/512, 68/512, 132/512)
                self.Highlight:SetTexCoord(396/512, 1, 68/512, 132/512)
                self:UnlockHighlight()
                self.Highlight:SetVertexColor(0.5, 0.5, 0.5)
            end
        end)

        Button:SetScript("OnMouseUp", function(self)
            if self:IsEnabled() then
                self.Background:SetTexCoord(0/512, 128/512, 68/512, 132/512)
                self.Highlight:SetTexCoord(396/512, 1, 68/512, 132/512)
                self:UnlockHighlight()
                self.Highlight:SetVertexColor(0.5, 0.5, 0.5)
            end
        end)

        Button:SetScript("OnDisable", function(self)
            self.Background:SetTexCoord(132/512, 260/512, 0, 0.125)
        end)

        return Button
    end

    C.CreatePanelButton = CreatePanelButton
end