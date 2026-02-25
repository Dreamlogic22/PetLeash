--[[--------------------------------------------------------------------

    Enables performance monitoring using Therapy's development tools.

--------------------------------------------------------------------]]

---@type string, PetLeash
local Name, T = ...

local function Enable()
    T.IsDebugBuild = T.db.isDebugBuild

    if T.IsDebugBuild then
        EventUtil.ContinueOnAddOnLoaded("TherapyDevTools", function()
            TherapyDevTools_Monitor(Name)
        end)
    end
end

T.RegisterModule(Enable)