---@meta _

---@class Toolkit
Toolkit = {}

----------------------------------------------------------------
-- Events
----------------------------------------------------------------

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
function Toolkit.RegisterEvent(event, callback) end

---@param event FrameEvent
---@param callback function
function Toolkit.RegisterEventOnce(event, callback) end

---@param event FrameEvent
---@param callback function
function Toolkit.UnregisterEvent(event, callback) end

---@param event FrameEvent
---@param callback function
---@param unit UnitToken
function Toolkit.RegisterUnitEvent(event, callback, unit) end

----------------------------------------------------------------
-- Mixins
----------------------------------------------------------------

---@class ToolkitBackdrop: Frame, BackdropTemplate
local ToolkitBackdrop = {}

---@param transparent? boolean
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

---@class ToolkitTexture: ToolkitRegion, Texture
local ToolkitTexture = {}

function ToolkitTexture:DisableSharpening() end

---@class ToolkitFrameTemplate: ToolkitBackdrop, ToolkitRegion, Frame
local ToolkitFrame = {}

---@param name? string
---@param drawLayer? DrawLayer
---@param templateName? Template
---@param subLevel? number
---@return ToolkitTexture
function ToolkitFrame:CreateTexture(name, drawLayer, templateName, subLevel) end

---@class ToolkitButtonTemplate: ToolkitFrameTemplate, Button
---@field Texture texture
local ToolkitButton = {}

---@param r number
---@param g number
---@param b number
---@param a? number
function ToolkitButton:SetHoverColor(r, g, b, a) end

---@param texture TextureAssetDisk
---@param rotation number?
function ToolkitButton:SetTexture(texture, rotation) end

---@param texture TextureAsset
function ToolkitButton:SetupTextures(texture) end
