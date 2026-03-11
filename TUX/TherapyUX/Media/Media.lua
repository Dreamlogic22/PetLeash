--[[------------------------------------------------------------------

    Therapy UX Media structure added to the addon namespace. Can be
    populated using assets found in the library's Media folder as well as
    assets contained in the addon.

--------------------------------------------------------------------]]

---@class addonTbl
local T = select(2, ...)

---@class Media
T.Media = {
    Colors = {},
    Fonts = {},
    Sounds = {},
    Textures = {}
}