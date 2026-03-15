--[[--------------------------------------------------------------------

    PetLeash Options 4.01 (March 15, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class PetLeashOptions: TherapyAPI
local C = select(2, ...)

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

C.Name = Name
C.Title = GetAddOnMetadata(Name, "Title")
C.Version = GetAddOnMetadata(Name, "Version")
C.db = PetLeashDB

TherapyUX.Embed(C)