--[[--------------------------------------------------------------------

    Factory for Therapy UX basic elements using the API.

----------------------------------------------------------------------]]

---@type PetLeash
local T = select(2, ...)
local Media = T.Media

---@class UX
local UX = T.UX

local baseFrame = CreateFrame("Frame")

local createTexture = baseFrame.CreateTexture

---@class TuxFrame: Frame, TuxBackdrop, TuxLayout
local frame_api = CreateFromMixins(UX.backdrop_api, UX.layout_api)
do
    ---@generic Tp
    ---@param name? string
    ---@param drawLayer? DrawLayer
    ---@param templateName? `Tp` | Template
    ---@return TuxTexture|Tp
    function frame_api:CreateTexture(name, drawLayer, templateName)
        local texture = createTexture(self, name, drawLayer, templateName)
        return Mixin(texture, UX.texture_api)
    end
end

---@generic T, Tp
---@param frameType `T` | FrameType
---@param name? string
---@param parent? any
---@param template? `Tp` | Template
---@param id? number
---@return TuxFrame|T|Tp
function UX.ConstructFrame(frameType, name, parent, template, id)
    local frame = CreateFrame(frameType, name, parent, template, id)
    frame = Mixin(frame, frame_api)

    return frame
end

local test = UX.ConstructFrame("Frame")
test:SetSize(200, 100)
test:SetPoint("CENTER")
test:CreateBackdrop(true)
test:SetBackdropTexture(Media.Textures.Background)