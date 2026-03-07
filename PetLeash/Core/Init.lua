--[[--------------------------------------------------------------------

    PetLeash 4.01 (March 7, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

---@class Locale
T.Locale = {}

-- Load database
do
    local Version = C_AddOns.GetAddOnMetadata(Name, "Version")

    ---@param target table
    ---@param defaults table
    ---@return table
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

    if not PetLeashDB or type(PetLeashDB) ~= "table" then
        ---@class PetLeashDB: Settings
        PetLeashDB = {}
    end

    PetLeashDB = Merge(PetLeashDB, T.db)

    if not PetLeashDB.version or PetLeashDB.version ~= Version then
        PetLeashDB.version = Version
    end

    T.db = PetLeashDB
end

PetLeash = T