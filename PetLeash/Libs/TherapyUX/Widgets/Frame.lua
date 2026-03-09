--[[--------------------------------------------------------------------

    Therapy UX modifications for basic frame widgets.

----------------------------------------------------------------------]]

---@type addonTbl
local T = select(2, ...)

---@class TherapyUX
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

---@generic T
---@param name? string
---@param parent? any
---@param template? `T` | Template
---@param id? number
---@return TuxFrame|T
function T.ConstructFrame(name, parent, template, id)
    local frame = CreateFrame("Frame", name, parent, template, id)
    frame = Mixin(frame, frame_api)

    return frame
end

UX.frame_api = frame_api