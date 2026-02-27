---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Colors, Media = C.Colors, T.Media

        -- b:SetScript("OnEnable", CheckboxMixin.OnEnable);
        -- b:SetScript("OnDisable", CheckboxMixin.OnDisable);

    -- function CheckboxMixin:OnEnable()
    --     self.CheckedTexture:SetDesaturated(false);
    --     self.CheckedTexture:SetVertexColor(1, 1, 1);
    --     if self.useWhiteLabel then
    --         self.Label:SetTextColor(1, 1, 1);
    --     else
    --         self.Label:SetTextColor(1, 0.82, 0);
    --     end
    -- end

    -- function CheckboxMixin:OnDisable()
    --     self.CheckedTexture:SetDesaturated(true);
    --     self.CheckedTexture:SetVertexColor(0.5, 0.5, 0.5);
    --     self.Label:SetTextColor(0.5, 0.5, 0.5);
    -- end

do
    ---@param self PetLeashCheckBox
    local function OnClick(self)
        if self:GetChecked() then
            self.CheckedTexture:Show()
            PlaySound(857)
        else
            self.CheckedTexture:Hide()
            PlaySound(856)
        end
    end

    ---@param self PetLeashCheckBox
    local function OnEnter(self)
        if self.TooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.Label:GetText(), Colors.DarkBrown:GetRGB())
            GameTooltip:AddLine(self.TooltipText, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end

    local function OnLeave()
        GameTooltip:Hide()
    end

    ---@param parent Frame
    ---@param label string
    ---@param setting boolean
    ---@param tooltipText string?
    ---@return PetLeashCheckBox
    function C.CreateCheckBox(parent, label, setting, tooltipText)
        ---@class PetLeashCheckBox: CheckButton
        local Button = CreateFrame("CheckButton", nil, parent)
        Button:SetSize(24, 24)

        Button.Border = Button:CreateTexture(nil, "ARTWORK")
        Button.Border:SetTexture(Media.Textures.Checkbox)
        Button.Border:SetTexCoord(0, 0.5, 0, 0.5)
        Button.Border:SetPoint("CENTER", Button, "LEFT", 8, 0)
        Button.Border:SetSize(32, 32)
        Button.Border:SetSnapToPixelGrid(false)
        Button.Border:SetTexelSnappingBias(0)

        Button.Label = Button:CreateFontString(nil,"OVERLAY")
        Button.Label:SetFont(Media.Fonts.Normal, 12, "MONOCHROMEOUTLINE")
        Button.Label:SetVertexColor(Colors.GoldenBrown:GetRGB())
        Button.Label:SetText(label)
        Button.Label:SetPoint("LEFT", Button, "RIGHT", 4, 0)

        Button.CheckedTexture = Button:CreateTexture(nil, "OVERLAY")
        Button.CheckedTexture:SetTexture(Media.Textures.Checkbox)
        Button.CheckedTexture:SetTexCoord(0.5, 0.75, 0.5, 0.75)
        Button.CheckedTexture:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.CheckedTexture:SetSize(16, 16)
        Button.CheckedTexture:SetSnapToPixelGrid(false)
        Button.CheckedTexture:SetTexelSnappingBias(0)
        Button.CheckedTexture:Hide()

        Button.Highlight = Button:CreateTexture(nil, "HIGHLIGHT")
        Button.Highlight:SetTexture(Media.Textures.Checkbox)
        Button.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
        Button.Highlight:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.Highlight:SetSize(32, 32)
        Button.Highlight:SetBlendMode("ADD")
        Button.Highlight:SetVertexColor(0.5, 0.5, 0.5)
        Button.Highlight:SetSnapToPixelGrid(false)
        Button.Highlight:SetTexelSnappingBias(0)

        Button:SetScript("OnClick", OnClick)
        Button:SetScript("OnEnter", OnEnter)
        Button:SetScript("OnLeave", OnLeave)

        if tooltipText then
            Button.TooltipText = tooltipText
        end

        Button:SetChecked(setting)
        if Button:GetChecked() then
            Button.CheckedTexture:Show()
        else
            Button.CheckedTexture:Hide()
        end

        return Button
    end
end