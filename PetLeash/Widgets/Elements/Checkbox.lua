---@class PetLeash
local T = select(2, ...)
local Media = T.Media

local DisablePixelSnap = T.DisablePixelSnap

local CreateCheckBox
do
    ---@param self PetLeashCheckbox
    local function OnClick(self)
        if self:GetChecked() then
            self.CheckedTexture:Show()
            PlaySound(857)
        else
            self.CheckedTexture:Hide()
            PlaySound(856)
        end
    end

    local function OnLeave()
        GameTooltip:Hide()
    end

    ---@param self PetLeashCheckbox
    ---@param predicate function?
    local function OnValueChanged(self, predicate)
        if predicate and type(predicate) == "function" then
            self.Value = predicate()
        end

        print("In OnValueChanged", self.Value)

        self:SetChecked(self.Value)

        if self:GetChecked() then
            self.CheckedTexture:Show()
        else
            self.CheckedTexture:Hide()
        end
    end

    ---@param parent Frame
    ---@param size number
    ---@param onValueChanged function
    ---@param onShow function?
    ---@return PetLeashCheckbox
    CreateCheckBox = function(parent, size, onValueChanged, onShow)
        ---@class PetLeashCheckbox: CheckButton
        local Button = CreateFrame("CheckButton", nil, parent)
        Button:SetSize(size, size)

        Button.Border = Button:CreateTexture(nil, "ARTWORK")
        Button.Border:SetTexture(Media.Textures.Checkbox)
        Button.Border:SetTexCoord(0, 0.5, 0, 0.5)
        Button.Border:SetPoint("CENTER", Button, "LEFT", 8, 0)
        Button.Border:SetSize(32, 32)
        DisablePixelSnap(Button.Border)

        Button.CheckedTexture = Button:CreateTexture(nil, "OVERLAY")
        Button.CheckedTexture:SetTexture(Media.Textures.Checkbox)
        Button.CheckedTexture:SetTexCoord(0.5, 0.75, 0.5, 0.75)
        Button.CheckedTexture:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.CheckedTexture:SetSize(16, 16)
        DisablePixelSnap(Button.CheckedTexture)

        Button.CheckedTexture:Hide()

        Button.Highlight = Button:CreateTexture(nil, "HIGHLIGHT")
        Button.Highlight:SetTexture(Media.Textures.Checkbox)
        Button.Highlight:SetTexCoord(0, 0.5, 0.5, 1)
        Button.Highlight:SetPoint("CENTER", Button.Border, "CENTER", 0, 0)
        Button.Highlight:SetSize(32, 32)
        Button.Highlight:SetBlendMode("ADD")
        Button.Highlight:SetVertexColor(0.5, 0.5, 0.5)
        DisablePixelSnap(Button.Highlight)

        Button.Value = false

        Button:SetScript("OnClick", OnClick)
        Button:SetScript("OnLeave", OnLeave)
        Button:SetScript("OnShow", function(self)
            if onShow and type(onShow) == "function" then
                Button.Value = onShow()
                OnValueChanged(self)
            end
        end)

        return Button
    end

    T.CreateCheckBox = CreateCheckBox
end