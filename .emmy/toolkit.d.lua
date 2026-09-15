---@meta _

---@class Toolkit
Toolkit = {}

--[[--------------------------------------------------------------------

    Events

----------------------------------------------------------------------]]

---@class ToolkitEvents
local ToolkitEvents = {}

---@param event string
function ToolkitEvents:Fire(event, ...) end

---@param event string
---@param callback function
function ToolkitEvents:RegisterCallback(event, callback) end

---@param event string
---@param callback function
function ToolkitEvents:RegisterCallbackOnce(event, callback) end

---@param event string
---@param callback function
function ToolkitEvents:UnregisterCallback(event, callback) end

---@param event FrameEvent
---@param callback function
function ToolkitEvents:RegisterEvent(event, callback) end

---@param event FrameEvent
---@param callback function
function ToolkitEvents:RegisterEventOnce(event, callback) end

---@param event FrameEvent
---@param callback function
function ToolkitEvents:UnregisterEvent(event, callback) end

---@param event FrameEvent
---@param callback function
---@param unit UnitToken
function ToolkitEvents:RegisterUnitEvent(event, callback, unit) end

Toolkit.Events = ToolkitEvents

--[[--------------------------------------------------------------------

    Mixins

----------------------------------------------------------------------]]

----------------------------------------------------------------
-- Backdrop
----------------------------------------------------------------

---@class ToolkitBackdrop: Frame
local ToolkitBackdrop = {}

---@param transparent boolean?
function ToolkitBackdrop:CreateBackdrop(transparent) end

---@param shadowScale number?
function ToolkitBackdrop:CreateShadow(shadowScale) end

---@param r number
---@param g number
---@param b number
---@param a number?
function ToolkitBackdrop:SetBackdropColor(r, g, b, a) end

---@param texture TextureAsset
function ToolkitBackdrop:SetBackdropTexture(texture) end

---@param r number
---@param g number
---@param b number
---@param a number?
function ToolkitBackdrop:SetBorderColor(r, g, b, a) end

---@param size number
function ToolkitBackdrop:SetBorderSize(size) end

---@param r number
---@param g number
---@param b number
---@param a number?
function ToolkitBackdrop:SetShadowColor(r, g, b, a) end

----------------------------------------------------------------
-- Region
----------------------------------------------------------------

---@class ToolkitRegion: Region
local ToolkitRegion = {}

---@param anchor Frame?
---@param xOffset number?
---@param yOffset number?
function ToolkitRegion:SetInside(anchor, xOffset, yOffset) end

---@param anchor Frame?
---@param xOffset number?
---@param yOffset number?
function ToolkitRegion:SetOutside(anchor, xOffset, yOffset) end

----------------------------------------------------------------
-- Texture
----------------------------------------------------------------

---@class ToolkitTexture: ToolkitRegion, Texture
local ToolkitTexture = {}

function ToolkitTexture:DisableSharpening() end

--[[--------------------------------------------------------------------

    Templates

----------------------------------------------------------------------]]

---@class ToolkitFrameTemplate: ToolkitBackdrop, ToolkitRegion, Frame
ToolkitFrameTemplate = {}

---@param name? string
---@param drawLayer? DrawLayer
---@param templateName? Template
---@param subLevel? number
---@return ToolkitTexture
function ToolkitFrameTemplate:CreateTexture(name, drawLayer, templateName, subLevel) end

---@class ToolkitButtonTemplate: ToolkitFrameTemplate, Button
ToolkitButtonTemplate = {}

---@param r number
---@param g number
---@param b number
---@param a? number
function ToolkitButtonTemplate:SetHoverColor(r, g, b, a) end

---@param texture TextureAssetDisk
---@param rotation number?
function ToolkitButtonTemplate:SetTexture(texture, rotation) end

---@param texture TextureAsset
function ToolkitButtonTemplate:SetupTextures(texture) end
