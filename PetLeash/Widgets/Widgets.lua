--[[--------------------------------------------------------------------

    Widget & settings helper functions.

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

local _, ScreenWidth = GetPhysicalScreenSize()
local Perfect = 786 / ScreenWidth
local UIScale = (ElvUI and ElvUI[1].global.general.UIScale) or GetCVar("uiScale")
local Mult = Perfect / UIScale

---@param size number
local function Scale(size)
    if Mult == 1 or size == 0 then
        return size
    else
        local y = Mult > 1 and Mult or -Mult
        return size - size % (size < 0 and y or -y)
    end
end

do
    ---@param texture Texture
    function T.DisablePixelSnap(texture)
        texture:SetTexelSnappingBias(0)
        texture:SetSnapToPixelGrid(false)
    end

    ---@param region ScriptRegionResizing
    ---@param anchor? Frame
    ---@param offsetX? number
    ---@param offsetY? number
    function T.SetInside(region, anchor, offsetX, offsetY)
        offsetX = Scale(offsetX or 1)
        offsetY = Scale(offsetY or 1)

        anchor = anchor or region:GetParent()

        if region:GetNumPoints() > 0 then
            region:ClearAllPoints()
        end

        region:SetPoint("TOPLEFT", anchor, "TOPLEFT", offsetX, -offsetY)
        region:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -offsetX, offsetY)
    end
end