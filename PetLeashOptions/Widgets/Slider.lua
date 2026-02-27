---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local Media = T.Media

local BackDisable = { 0.25, 0.5, 0.5, 0.625 }
local BackHighlight = { 0.5, 0.75, 0.5, 0.625 }
local BackNormal = { 0, 0.25, 0.5, 0.625 }
local ForwardDisable = { 0.25, 0.5, 0.625, 0.75 }
local ForwardHighlight = { 0.5, 0.75, 0.625, 0.75 }
local ForwardNomral = { 0, 0.25, 0.625, 0.75 }
local SliderLeft = { 0, 0.125, 0.875, 1 }
local SliderMiddle = { 0.125, 0.375, 0.875, 1 }
local SliderRight = { 0.375, 0.5, 0.875, 1 }
local ThumbDisable = { 0.5, 1, 0, 0.25 }
local ThumbHighlight = { 0, 0.5, 0.25, 0.5 }
local ThumbNormal = { 0, 0.5, 0, 0.25 }

do
    local function OnClick()
        PlaySound(229883)
    end

    ---@param self PetLeashSliderTemplate
    ---@param value number
    local function OnValueChanged(self, value)
        if value == self.PreviousValue then return end

        self.PreviousValue = value
        self.ThumbTexture:SetPoint("CENTER", self.Thumb, "CENTER", 0, 0)

        if self.ValueText then
            self.ValueText:SetText(value)
        end
    end

    ---@param parent Frame
    ---@param label string
    ---@param setting number
    ---@param min number?
    ---@param max number?
    ---@return PetLeashSlider
    function C.CreateSlider(parent, label, setting, min, max)
        ---@class PetLeashSlider: Frame
        local Frame = CreateFrame("Frame", nil, parent)
        Frame:SetSize(386, 24)

        ---@class PetLeashSliderTemplate: Slider
        ---@field Thumb Button
        ---@field ValueText FontString
        local Slider = CreateFrame("Slider", nil, parent, "PetLeashSliderTemplate")
        Slider:SetOrientation("HORIZONTAL")
        Slider:SetSize(200, 24)
        Slider:SetPoint("LEFT", Frame, "LEFT", 172, 0)
        Slider:SetPoint("RIGHT", Frame, "RIGHT", -60, 0)
        Slider:EnableMouse(true)
        Slider.PreviousValue = setting

        Slider.Left = Slider:CreateTexture(nil, "BORDER")
        Slider.Left:SetTexture(Media.Textures.Slider)
        Slider.Left:SetTexCoord(unpack(SliderLeft))
        Slider.Left:SetSnapToPixelGrid(false)
        Slider.Left:SetTexelSnappingBias(0)
        Slider.Left:SetSize(8, 16)
        Slider.Left:SetPoint("CENTER", Slider, "LEFT", 0, 0)

        Slider.Right = Slider:CreateTexture(nil, "BORDER")
        Slider.Right:SetTexture(Media.Textures.Slider)
        Slider.Right:SetTexCoord(unpack(SliderRight))
        Slider.Right:SetSnapToPixelGrid(false)
        Slider.Right:SetTexelSnappingBias(0)
        Slider.Right:SetSize(8, 16)
        Slider.Right:SetPoint("CENTER", Slider, "RIGHT", 0, 0)

        Slider.Middle = Slider:CreateTexture(nil, "BORDER")
        Slider.Middle:SetTexture(Media.Textures.Slider)
        Slider.Middle:SetTexCoord(unpack(SliderMiddle))
        Slider.Middle:SetSnapToPixelGrid(false)
        Slider.Middle:SetTexelSnappingBias(0)
        Slider.Middle:SetPoint("TOPLEFT", Slider.Left, "TOPRIGHT")
        Slider.Middle:SetPoint("BOTTOMRIGHT", Slider.Right, "BOTTOMLEFT")

        Slider.ThumbTexture = Slider:CreateTexture(nil, "OVERLAY")
        Slider.ThumbTexture:SetTexture(Media.Textures.Slider)
        Slider.ThumbTexture:SetTexCoord(unpack(ThumbNormal))
        Slider.ThumbTexture:SetSize(32, 32)
        Slider.ThumbTexture:SetPoint("CENTER", Slider.Thumb, "CENTER")

        Slider.ThumbHighlight = Slider:CreateTexture(nil, "HIGHLIGHT")
        Slider.ThumbHighlight:SetTexture(Media.Textures.Slider)
        Slider.ThumbHighlight:SetTexCoord(unpack(ThumbHighlight))
        Slider.ThumbHighlight:SetSize(32, 32)
        Slider.ThumbHighlight:SetPoint("CENTER", Slider.ThumbTexture, "CENTER")
        Slider.ThumbHighlight:SetBlendMode("ADD")
        Slider.ThumbHighlight:SetVertexColor(0.5, 0.5, 0.5)

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
        Frame.Slider:SetValueStep(10)
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

        return Frame
    end
end