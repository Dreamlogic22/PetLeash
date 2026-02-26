--[[--------------------------------------------------------------------

    PetLeash Options 4.01 (February 25, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeashOptions
local C = select(2, ...)

C.Version = C_AddOns.GetAddOnMetadata(Name, "Version")
C.db = PetLeashDB or {}
