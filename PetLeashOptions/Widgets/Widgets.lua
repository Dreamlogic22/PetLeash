---@class PetLeashOptions
local C = select(2, ...)

C.Colors = {
    DarkBrown = CreateColor(0.58, 0.49, 0.4),
    GoldenBrown = CreateColor(0.84, 0.75, 0.64)
}

do
    local _, ScreenWidth = GetPhysicalScreenSize()
    local Perfect = 786 / ScreenWidth

    local UIScale = (ElvUI and ElvUI[1].global.general.UIScale) or GetCVar("uiScale")
    local Mult = Perfect / UIScale

    ---@param size number
    function C.Scale(size)
        if Mult == 1 or size == 0 then
            return size
        else
            local y = Mult > 1 and Mult or -Mult
            return size - size % (size < 0 and y or -y)
        end
    end
end