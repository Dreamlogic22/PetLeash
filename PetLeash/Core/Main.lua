---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local LoadDevelopmentTools
do
    -- Do this here because EventUtil calls cannot be nested
    LoadDevelopmentTools = function()
        if T.IsDebugBuild then
            EventUtil.ContinueOnAddOnLoaded("TherapyDevTools", function()
                TherapyDevTools_Monitor(Name)
            end)
        end
    end
end

local function OnInitialize()
    T.IsDebugBuild = T.db.isDebugBuild

    LoadDevelopmentTools()
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)