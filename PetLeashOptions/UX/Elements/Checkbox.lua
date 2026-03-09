--[[--------------------------------------------------------------------

    Toggle element for options.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)
local Media = T.Media

local CreateCheckBox
do

    ---@param self PetLeashCheckbox
    local function HandleCheckedTexture(self)
        self.CheckedTexture:SetShown(self:IsVisible() and self:GetChecked())
    end

    ---@param parent Frame
    ---@param label string
    ---@param tooltipText string?
    ---@return PetLeashCheckbox
    CreateCheckBox = function(parent, label, tooltipText)
        ---@class PetLeashCheckbox: CheckButton
        local Checkbox = CreateFrame("CheckButton", nil, parent)
        Checkbox:SetSize(24, 24)
        Checkbox.TooltipText = tooltipText

        Checkbox.Border = Checkbox:CreateTexture(nil, "ARTWORK")
        Checkbox.Border:SetTexture(Media.Textures.Checkbox)
        Checkbox.Border:SetTexCoord(0, 0.5, 0, 0.5)
        Checkbox.Border:SetPoint("CENTER", Checkbox, "LEFT", 8, 0)
        Checkbox.Border:SetSize(32, 32)

        T.DisableSharpening(Checkbox.Border)

        Checkbox.CheckedTexture = Checkbox:CreateTexture(nil, "OVERLAY")
        Checkbox.CheckedTexture:SetTexture(Media.Textures.Checkbox)
        Checkbox.CheckedTexture:SetTexCoord(0.5, 0.75, 0.5, 0.75)
        Checkbox.CheckedTexture:SetPoint("CENTER", Checkbox.Border, "CENTER", 0, 0)
        Checkbox.CheckedTexture:SetSize(16, 16)

        T.DisableSharpening(Checkbox.CheckedTexture)

        Checkbox.CheckedTexture:Hide()

        Checkbox.Highlight = Checkbox:CreateTexture(nil, "HIGHLIGHT")
        Checkbox.Highlight:SetTexture(Media.Textures.Checkbox)
        Checkbox.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
        Checkbox.Highlight:SetPoint("CENTER", Checkbox.Border, "CENTER", 0, 0)
        Checkbox.Highlight:SetSize(32, 32)
        Checkbox.Highlight:SetBlendMode("ADD")
        Checkbox.Highlight:SetVertexColor(0.5, 0.5, 0.5)

        T.DisableSharpening(Checkbox.Highlight)

        Checkbox.Label = Checkbox:CreateFontString(nil, "OVERLAY")
        Checkbox.Label:SetFont(Media.Fonts.Normal, 12, "MONOCHROMEOUTLINE")
        Checkbox.Label:SetVertexColor(Media.Colors.Foreground:GetRGB())
        Checkbox.Label:SetText(label)
        Checkbox.Label:SetPoint("LEFT", Checkbox, "RIGHT", 4, 0)

        Checkbox:SetScript("OnClick", function(self)
            if self:GetChecked() then
                self.CheckedTexture:Show()
                PlaySound(857)
            else
                self.CheckedTexture:Hide()
                PlaySound(856)
            end
        end)

        Checkbox:SetScript("OnDisable", function(self)
            self.CheckedTexture:SetDesaturated(true)
            self.CheckedTexture:SetVertexColor(0.5, 0.5, 0.5)
            self.Label:SetTextColor(0.5, 0.5, 0.5)
        end)

        Checkbox:SetScript("OnEnable", function(self)
            self.CheckedTexture:SetDesaturated(false)
            self.CheckedTexture:SetVertexColor(1, 1, 1)
            self.Label:SetTextColor(Media.Colors.Foreground:GetRGB())
        end)

        Checkbox:SetScript("OnEnter", function(self)
            if self.TooltipText then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine(label and self.Label:GetText() or "PetLeash", Media.Colors.Foreground:GetRGB())
                GameTooltip:AddLine(self.TooltipText, 1, 1, 1, true)
                GameTooltip:Show()
            end
        end)

        Checkbox:SetScript("OnHide", HandleCheckedTexture)

        Checkbox:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        Checkbox:SetScript("OnShow", HandleCheckedTexture)

        return Checkbox
    end

    T.CreateCheckBox = CreateCheckBox
end