--[[---------------------------------------------------------------------

    Backup media using LibSharedMedia-3.0.  Parent addon should override
    this and replace any of the defaults in LSM with local assets.

-----------------------------------------------------------------------]]

---@type string, addonTbl
local Name, T = ...
local LSM = T.UX.LSM

---@param type LibSharedMediaTypes
---@param name string
---@param file string
local function addMedia(type, name, file)
    LSM:Register(type, name, format([[Interface\AddOns\%s\Media\%s]], Name, file))
end

addMedia("font", "Expressway", [[Fonts\Expressway.ttf]])
addMedia("font", "PT Sans Narrow", [[Fonts\PTSansNarrow.ttf]])
addMedia("background", "Therapy Blank", [[Textures\Blank]])
addMedia("background", "Therapy Glow", [[Textures\Glow]])