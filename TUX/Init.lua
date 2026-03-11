--[[--------------------------------------------------------------------

    Therapy UX 1.01 (March 11, 2026)

----------------------------------------------------------------------]]

---@type string
local Name = ...
---@class addonTbl
local T = select(2, ...)
T.UX = {}

T.Title = C_AddOns.GetAddOnMetadata(Name, "Title")