--[[------------------------------------------------------------------

    Therapy UX API methods for working with textures, including
    pixel-perfect rendering and layout.

--------------------------------------------------------------------]]

---@type addonTbl
local T = select(2, ...)

---@class UX
local UX = T.UX

---@class TuxTexture: Texture, TuxLayout
local texture_api = CreateFromMixins(UX.layout_api)
do
    ---@param self Texture
    function texture_api:DisableSharpening()
        self:SetSnapToPixelGrid(false)
        self:SetTexelSnappingBias(0)
    end
end

UX.texture_api = texture_api
