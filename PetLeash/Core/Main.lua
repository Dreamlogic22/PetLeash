---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

local LoadModules
do
    ---@type table<number, function>
    local PendingModules = {}

    ---@param callback function
    ---@param delay number?
    function T.RegisterModule(callback, delay)
        tinsert(PendingModules, function()
            if delay then
                C_Timer.After(delay, callback)
            else
                callback()
            end
        end)
    end

    LoadModules = function()
        while #PendingModules > 0 do
            local module = tremove(PendingModules, 1)
            pcall(module)
        end

        if #PendingModules == 0 then
            T.RegisterModule = nil
        end
    end
end

local function OnInitialize()
    LoadModules()
end

EventUtil.ContinueOnAddOnLoaded(Name, OnInitialize)