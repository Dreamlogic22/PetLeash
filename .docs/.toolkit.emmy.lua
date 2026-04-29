---@meta _

---@class Toolkit
Toolkit = {}

----------------------------------------------------------------
-- Backdrop
----------------------------------------------------------------

---@class ToolkitBackdrop: Frame, BackdropTemplate
---@field Backdrop Frame
---@field Shadow Frame
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
-- Button
----------------------------------------------------------------

---@class ToolkitButtonTemplate: Button, ToolkitFrameTemplate
---@field Texture Texture
ToolkitButton = {}

---@generic Tp
---@param name? string
---@param drawLayer? DrawLayer
---@param templateName? `Tp` | Template
---@return ToolkitTexture|Tp
function ToolkitButton:CreateTexture(name, drawLayer, templateName) end

---@return ToolkitTexture?
function ToolkitButton:GetHighlightTexture() end

---@return ToolkitTexture?
function ToolkitButton:GetNormalTexture() end

---@return ToolkitTexture?
function ToolkitButton:GetPushedTexture() end

---@param texture TextureAsset
---@param highlight table?
---@param rotation number?
function ToolkitButton:SetTexture(texture, highlight, rotation) end

---@param texture TextureAsset
function ToolkitButton:SetupTextures(texture) end

----------------------------------------------------------------
-- Events
----------------------------------------------------------------

---@param event WowEvent
---@param callback function
function Toolkit.RegisterEventCallback(event, callback) end

---@param event WowEvent
---@param callback function
function Toolkit.UnregisterEventCallback(event, callback) end

---@param event WowEvent
---@param callback function
---@param unit UnitToken
function Toolkit.RegisterUnitEventCallback(event, callback, unit) end

----------------------------------------------------------------
-- Frame
----------------------------------------------------------------

---@class ToolkitFrameTemplate: Frame, ToolkitBackdrop, ToolkitLayout
local ToolkitFrame = {}

---@generic Tp
---@param name? string
---@param drawLayer? DrawLayer
---@param templateName? `Tp` | Template
---@return ToolkitTexture|Tp
function ToolkitFrame:CreateTexture(name, drawLayer, templateName) end

----------------------------------------------------------------
-- Layout
----------------------------------------------------------------

---@class ToolkitLayout: Frame | Texture
local ToolkitLayout = {}

---@param anchor Frame?
---@param xOffset number?
---@param yOffset number?
function ToolkitLayout:SetInside(anchor, xOffset, yOffset) end

---@param anchor Frame?
---@param xOffset number?
---@param yOffset number?
function ToolkitLayout:SetOutside(anchor, xOffset, yOffset) end

----------------------------------------------------------------
-- Media
----------------------------------------------------------------

Toolkit.Media = {
    Colors = {},
    Fonts = {
        Bold = [[Interface\AddOns\Toolkit\Media\Fonts\Expressway.ttf]],
        Normal = [[Interface\AddOns\Toolkit\Media\Fonts\PTSansNarrow.ttf]]
    },
    Sounds = {},
    Textures = {
        ArrowUp = [[Interface\AddOns\Toolkit\Media\Textures\Arrowup]],
        Close = [[Interface\AddOns\Toolkit\Media\Textures\Close]],
        Glow = [[Interface\AddOns\Toolkit\Media\Textures\Glow]],
        Normal = [[Interface\AddOns\Toolkit\Media\Textures\Blank]],
        Restore = [[Interface\AddOns\Toolkit\Media\Textures\Restore]]
    }
}

----------------------------------------------------------------
-- Texture
----------------------------------------------------------------

---@class ToolkitTexture: Texture, ToolkitLayout
local ToolkitTexture = {}

function ToolkitTexture:DisableSharpening() end