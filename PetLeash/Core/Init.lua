--[[--------------------------------------------------------------------

    PetLeash 4.01 (March 14, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeash
local T = select(2, ...)

---@class Locale
T.Locale = {}

-- Load database
do
    ---@param target table
    ---@param defaults table
    ---@return table
    local function merge(target, defaults)
        for k, v in next, defaults do
            if type(v) == "table" then
                if type(target[k]) ~= "table" then
                    target[k] = {}
                end

                merge(target[k], v)
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

    PetLeashDB = merge(PetLeashDB, T.db)

    T.db = PetLeashDB
end

PetLeash = T