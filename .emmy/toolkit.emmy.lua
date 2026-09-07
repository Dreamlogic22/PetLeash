---@meta _

---@class Toolkit
Toolkit = {}

--[[--------------------------------------------------------------------

    Events

----------------------------------------------------------------------]]

---@param event string
function Toolkit.Fire(event, ...) end

---@param event string
---@param callback function
function Toolkit.RegisterCallback(event, callback) end

---@param event string
---@param callback function
function Toolkit.RegisterCallbackOnce(event, callback) end

---@param event string
---@param callback function
function Toolkit.UnregisterCallback(event, callback) end

---@param event FrameEvent
---@param callback function
function Toolkit.RegisterEventCallback(event, callback) end

---@param event FrameEvent
---@param callback function
function Toolkit.RegisterEventOnce(event, callback) end

---@param event FrameEvent
---@param callback function
---@param unit UnitToken
function Toolkit.RegisterUnitCallback(event, callback, unit) end

---@param event FrameEvent
---@param callback function
function Toolkit.UnregisterEventCallback(event, callback) end

---@param event FrameEvent
---@param callback function
---@param unit UnitToken
function Toolkit.UnregisterUnitCallback(event, callback, unit) end

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

---@param r number
---@param g number
---@param b number
---@param a number?
function ToolkitBackdrop:SetBorderColor(r, g, b, a) end

---@param texture TextureAsset
function ToolkitBackdrop:SetBackdropTexture(texture) end

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

---@class ToolkitTexture: ToolkitRegion & Texture
local ToolkitTexture = {}

function ToolkitTexture:DisableSharpening() end

--[[--------------------------------------------------------------------

    Templates

----------------------------------------------------------------------]]

---@class ToolkitFrameTemplate: ToolkitBackdrop & ToolkitRegion & Frame
ToolkitFrameTemplate = {}

---@param name? string
---@param drawLayer? DrawLayer
---@param templateName? Template
---@param subLevel? number
---@return ToolkitTexture
function ToolkitFrameTemplate:CreateTexture(name, drawLayer, templateName, subLevel) end

---@class ToolkitButtonTemplate: ToolkitFrameTemplate & Button
ToolkitButtonTemplate = {}

---@param texture TextureAssetDisk
---@param rotation number?
function ToolkitButton:SetTexture(texture, rotation) end

---@param texture TextureAsset
function ToolkitButton:SetupTextures(texture) end
