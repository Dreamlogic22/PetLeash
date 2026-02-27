--[[--------------------------------------------------------------------

    PetLeash Options 4.01 (February 27, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeashOptions
local C = select(2, ...)

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

C.Title = GetAddOnMetadata(Name, "Title")
C.Version = GetAddOnMetadata(Name, "Version")
C.db = PetLeashDB or {}