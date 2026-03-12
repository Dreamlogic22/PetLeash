--[[--------------------------------------------------------------------

    Stylized slider control.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Media = T.Media

local CreateSlider
do

    ---@param parent Frame
    ---@param label string
    ---@return PetLeashSlider
    CreateSlider = function(parent, label)
        ---@class PetLeashSlider: Slider
        local Container = CreateFrame("Frame", nil, parent)
        Container:SetSize(386, 24)

        local Slider = T.CreateFrame("Slider", nil, parent)
        Slider:SetOrientation("HORIZONTAL")
        Slider:SetSize(200, 24)
        Slider:SetPoint("LEFT", Container, "LEFT", 172, 0)
        Slider:SetPoint("RIGHT", Container, "RIGHT", -60, 0)
        Slider:EnableMouse(true)

        Slider.LeftCap = Slider:CreateTexture(nil, "BORDER")
        Slider.LeftCap:SetTexture(Media.Textures.Slider)
        Slider.LeftCap:SetTexCoord(0, 0.125, 0.875, 1)
        Slider.LeftCap:DisableSharpening()
        Slider.LeftCap:SetSize(8, 16)
        Slider.LeftCap:SetPoint("CENTER", Slider, "LEFT", 0, 0)

        Slider.RightCap = Slider:CreateTexture(nil, "BORDER")
        Slider.RightCap:SetTexture(Media.Textures.Slider)
        Slider.RightCap:SetTexCoord(0.375, 0.5, 0.875, 1)
        Slider.RightCap:DisableSharpening()
        Slider.RightCap:SetSize(8, 16)
        Slider.RightCap:SetPoint("CENTER", Slider, "RIGHT", 0, 0)

        Slider.Track = Slider:CreateTexture(nil, "BORDER")
        Slider.Track:SetTexture(Media.Textures.Slider)
        Slider.Track:SetTexCoord(0.125, 0.375, 0.875, 1)
        Slider.Track:DisableSharpening()
        Slider.Track:SetPoint("TOPLEFT", Slider.LeftCap, "TOPRIGHT")
        Slider.Track:SetPoint("BOTTOMRIGHT", Slider.RightCap, "BOTTOMLEFT")

        Slider.Thumb = Slider:CreateTexture(nil, "OVERLAY")
        Slider.Thumb:SetTexture(Media.Textures.Blank)
        Slider.Thumb:SetAlpha(0)
        Slider.Thumb:SetSize(12, 12)
        Slider:SetThumbTexture(Slider.Thumb)

        Slider.ThumbNormal = Slider:CreateTexture(nil, "OVERLAY")
        Slider.ThumbNormal:SetTexture(Media.Textures.Slider)
        Slider.ThumbNormal:SetTexCoord(0, 0.5, 0, 0.25)
        Slider.ThumbNormal:SetSize(32, 32)
        Slider.ThumbNormal:SetPoint("CENTER", Slider.Thumb)

        Slider.ThumbHighlight = Slider:CreateTexture(nil, "HIGHLIGHT")
        Slider.ThumbHighlight:SetTexture(Media.Textures.Slider)
        Slider.ThumbHighlight:SetTexCoord(0, 0.5, 0.25, 0.5)
        Slider.ThumbHighlight:SetSize(32, 32)
        Slider.ThumbHighlight:SetPoint("CENTER", Slider.ThumbNormal, "CENTER")
        Slider.ThumbHighlight:SetBlendMode("ADD")
        Slider.ThumbHighlight:SetVertexColor(0.5, 0.5, 0.5)

        Slider:SetMinMaxValues(0, 100)
        Slider:SetValueStep(10)
        Slider:SetObeyStepOnDrag(true)
        Slider:SetValue(0)

        Container.Slider = Slider

        local Forward = CreateFrame("Button", nil, Container)
        Forward:SetSize(16, 24)
        Forward:SetPoint("LEFT", Container.Slider, "RIGHT", 4, 0)

        Forward.Texture = Forward:CreateTexture(nil, "ARTWORK")
        Forward.Texture:SetTexture(Media.Textures.Slider)
        Forward.Texture:SetTexCoord(0, 0.25, 0.625, 0.75)
        Forward.Texture:SetSize(16, 16)
        Forward.Texture:SetPoint("CENTER", Forward, "CENTER")

        Forward.Highlight = Forward:CreateTexture(nil, "HIGHLIGHT")
        Forward.Highlight:SetTexture(Media.Textures.Slider)
        Forward.Highlight:SetTexCoord(0.5, 0.75, 0.625, 0.75)
        Forward.Highlight:SetSize(16, 16)
        Forward.Highlight:SetPoint("CENTER", Forward, "CENTER")
        Forward.Highlight:SetBlendMode("ADD")
        Forward.Highlight:SetVertexColor(0.5, 0.5, 0.5)

        Container.Forward = Forward

        local Back = CreateFrame("Button", nil, Container)
        Back:SetSize(16, 24)
        Back:SetPoint("RIGHT", Container.Slider, "LEFT", -4, 0)

        Back.Texture = Back:CreateTexture(nil, "ARTWORK")
        Back.Texture:SetTexture(Media.Textures.Slider)
        Back.Texture:SetTexCoord(0, 0.25, 0.5, 0.625)
        Back.Texture:SetSize(16, 16)
        Back.Texture:SetPoint("CENTER", Back, "CENTER")

        Back.Highlight = Back:CreateTexture(nil, "HIGHLIGHT")
        Back.Highlight:SetTexture(Media.Textures.Slider)
        Back.Highlight:SetTexCoord(0.5, 0.75, 0.5, 0.625)
        Back.Highlight:SetSize(16, 16)
        Back.Highlight:SetPoint("CENTER", Back, "CENTER")
        Back.Highlight:SetBlendMode("ADD")
        Back.Highlight:SetVertexColor(0.5, 0.5, 0.5)

        Container.Back = Back

        local Label = Container:CreateFontString(nil, "ARTWORK")
        Label:SetFont(Media.Fonts.Normal, 12, "OUTLINE")
        Label:SetTextColor(1, 1, 1)
        Label:SetText(label)
        Label:SetSize(100, 32)
        Label:SetPoint("LEFT", Container, "LEFT")
        Label:SetWidth(144)

        Container.Label = Label

        local ValueText = Container:CreateFontString(nil, "ARTWORK")
        ValueText:SetFont(Media.Fonts.Normal, 12, "OUTLINE")
        ValueText:SetTextColor(1, 0.82, 0)
        ValueText:SetPoint("LEFT", Container.Forward, "RIGHT", 6, 0)
        ValueText:SetText(10)

        Container.ValueText = ValueText

        return Container
    end

    C.CreateSlider = CreateSlider
end

--[[ local CreateSlider
do
    local BackDisable = { 0.25, 0.5, 0.5, 0.625 }
    local ForwardDisable = { 0.25, 0.5, 0.625, 0.75 }
    local ThumbDisable = { 0.5, 1, 0, 0.25 }

    ---@param self PetLeashSliderBackButton | PetLeashSliderForwardButton
    local function OnClick(self)
        PlaySound(229883)

        if self.Delta then
            ---@type PetLeashSlider
            local parent = self:GetParent()
            parent:SetValueByDelta(self.Delta)
        end
    end

    ---@param self PetLeashSliderTemplate
    ---@param value number
    local function OnValueChanged(self, value)
        if value == self.PreviousValue then return end

        self.PreviousValue = value
        self.ThumbTexture:SetPoint("CENTER", self.Thumb, "CENTER", 0, 0)

        if self.ValueText then
            self.ValueText:SetText(value)

            if self.Callback then
                pcall(self.Callback, value)
            end
        end
    end

    ---@param parent Frame
    ---@param label string
    ---@param setting number
    ---@param callback function
    ---@param step number
    ---@param min number?
    ---@param max number?
    ---@return PetLeashSlider
    CreateSlider = function(parent, label, setting, callback, step, min, max)

        Slider:SetScript("OnValueChanged", OnValueChanged)

        Frame.Slider = Slider

        ---@class PetLeashSliderBackButton: Button
        local Back = CreateFrame("Button", nil, Frame)
        Back:SetSize(16, 24)
        Back:SetPoint("RIGHT", Frame.Slider, "LEFT", -4, 0)

        Back.Texture = Back:CreateTexture(nil, "ARTWORK")
        Back.Texture:SetTexture(Media.Textures.Slider)
        Back.Texture:SetTexCoord(unpack(BackNormal))
        Back.Texture:SetSize(16, 16)
        Back.Texture:SetPoint("CENTER", Back, "CENTER")

        Back.Highlight = Back:CreateTexture(nil, "HIGHLIGHT")
        Back.Highlight:SetTexture(Media.Textures.Slider)
        Back.Highlight:SetTexCoord(unpack(BackHighlight))
        Back.Highlight:SetSize(16, 16)
        Back.Highlight:SetPoint("CENTER", Back, "CENTER")
        Back.Highlight:SetBlendMode("ADD")
        Back.Highlight:SetVertexColor(0.5, 0.5, 0.5)

        Back.Delta = -step

        Back:SetScript("OnClick", OnClick)

        Frame.Back = Back

        ---@class PetLeashSliderForwardButton: Button
        local Forward = CreateFrame("Button", nil, Frame)
        Forward:SetSize(16, 24)
        Forward:SetPoint("LEFT", Frame.Slider, "RIGHT", 4, 0)

        Forward.Texture = Forward:CreateTexture(nil, "ARTWORK")
        Forward.Texture:SetTexture(Media.Textures.Slider)
        Forward.Texture:SetTexCoord(unpack(ForwardNomral))
        Forward.Texture:SetSize(16, 16)
        Forward.Texture:SetPoint("CENTER", Forward, "CENTER")

        Forward.Highlight = Forward:CreateTexture(nil, "HIGHLIGHT")
        Forward.Highlight:SetTexture(Media.Textures.Slider)
        Forward.Highlight:SetTexCoord(unpack(ForwardHighlight))
        Forward.Highlight:SetSize(16, 16)
        Forward.Highlight:SetPoint("CENTER", Forward, "CENTER")
        Forward.Highlight:SetBlendMode("ADD")
        Forward.Highlight:SetVertexColor(0.5, 0.5, 0.5)

        Forward.Delta = step

        Forward:SetScript("OnClick", OnClick)

        Frame.Forward = Forward

        local Label = Frame:CreateFontString(nil, "ARTWORK")
        Label:SetFont(Media.Fonts.Normal, 12, "OUTLINE")
        Label:SetTextColor(1, 1, 1)
        Label:SetText(label)
        Label:SetSize(100, 32)
        Label:SetPoint("LEFT", Frame, "LEFT")
        Label:SetWidth(144)

        Frame.Label = Label

        local RightText = Frame:CreateFontString(nil, "ARTWORK")
        RightText:SetFont(Media.Fonts.Normal, 10, "OUTLINE")
        RightText:SetTextColor(1, 0.82, 0)
        RightText:SetPoint("LEFT", Frame.Forward, "RIGHT", 6, 0)

        Frame.RightText = RightText

        Frame.Slider.Back = Frame.Back
        Frame.Slider.Forward = Frame.Forward
        Frame.Slider.ValueText = Frame.RightText

        Frame.Slider:SetMinMaxValues(min or 0, max or 100)
        Frame.Slider:SetValueStep(step)
        Frame.Slider:SetObeyStepOnDrag(true)
        Frame.Slider:SetValue(setting)

        function Frame:Enable()
            self.Slider:Enable()
            self.Slider.ThumbTexture:SetTexCoord(unpack(ThumbNormal))

            self.Back:Enable()
            self.Back.Texture:SetTexCoord(unpack(BackNormal))
            self.Forward:Enable()

            self.Label:SetTextColor(1, 1, 1)
            self.RightText:SetTextColor(1, 0.82, 0)
        end

        function Frame:Disable()
            self.Slider:Disable()
            self.Slider.ThumbTexture:SetTexCoord(unpack(ThumbDisable))

            self.Back:Disable()
            self.Back.Texture:SetTexCoord(unpack(BackDisable))

            self.Forward:Disable()
            self.Forward.Texture:SetTexCoord(unpack(ForwardDisable))

            self.Slider:UnlockHighlight()

            self.Label:SetTextColor(0.5, 0.5, 0.5)
            self.RightText:SetTextColor(0.5, 0.5, 0.5)
        end

        function Frame:SetValueByDelta(delta)
            local value = self.Slider:GetValue()
            self.Slider:SetValue(value + delta)
        end

        if callback and type(callback) == "function" then
            Slider.Callback = callback
        end

        return Frame
    end
end ]]