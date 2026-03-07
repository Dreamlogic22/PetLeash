--[[--------------------------------------------------------------------

    Namespaced widget helper functions.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local DisablePixelSnap, SetInside
do
    ---@param texture Texture
    DisablePixelSnap = function(texture)
        texture:SetSnapToPixelGrid(false)
        texture:SetTexelSnappingBias(0)
    end

    ---@param texture Texture
    SetInside = function(texture)
        texture:ClearAllPoints()

        local parent = texture:GetParent()
        texture:SetPoint("TOPLEFT", texture:GetParent(), "TOPLEFT", 1, -1)
        texture:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -1, 1)
    end

    T.DisablePixelSnap = DisablePixelSnap
    T.SetInside = SetInside
end