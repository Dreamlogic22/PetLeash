--[[--------------------------------------------------------------------

    Therapy UX method for merging saved variables with defaults and
    storing the resulting table in a database attached to the parent
    namespace as "db".

--------------------------------------------------------------------]]

---@type string
local Name = ...
---@class addonTbl
local T = select(2, ...)

local Version = C_AddOns.GetAddOnMetadata(Name, "Version")

---@param target table
---@param defaults table
---@return Settings
local function Merge(target, defaults)
    for k, v in next, defaults do
        if type(v) == "table" then
            if type(target[k]) ~= "table" then
                target[k] = {}
            end

            Merge(target[k], v)
        elseif target[k] == nil then
            target[k] = v
        end
    end

    return target
end

---@param dbName string
function T.InitializeDatabase(dbName)
    ---@class Settings
    local AddonDB = _G[dbName]

    if not AddonDB or type(AddonDB) ~= "table" then
        AddonDB = {}
    end

    AddonDB = Merge(AddonDB, T.db)

    if not AddonDB.version or AddonDB.version ~= Version then
        AddonDB.version = Version
    end

    T.db = AddonDB
end