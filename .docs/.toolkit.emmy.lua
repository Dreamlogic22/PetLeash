---@meta _

----------------------------------------------------------------
-- Backdrop
----------------------------------------------------------------

---@class ToolkitBackdropTemplate: Frame, BackdropTemplate
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
ToolkitButton = {}

---@param texture TextureAsset
---@param highlight table?
---@param rotation number?
function ToolkitButton:AddTexture(texture, highlight, rotation) end

---@generic Tp
---@param name? string
---@param drawLayer? DrawLayer
---@param templateName? `Tp` | Template
---@return ToolkitTextureTemplate|Tp
function ToolkitButton:CreateTexture(name, drawLayer, templateName) end

---@return ToolkitTextureTemplate?
function ToolkitButton:GetHighlightTexture() end

---@return ToolkitTextureTemplate?
function ToolkitButton:GetNormalTexture() end

---@return ToolkitTextureTemplate?
function ToolkitButton:GetPushedTexture() end

---@param texture TextureAsset
function ToolkitButton:SetupTextures(texture) end

----------------------------------------------------------------
-- Frame
----------------------------------------------------------------

---@class ToolkitFrameTemplate: Frame, ToolkitBackdropTemplate, ToolkitLayoutTemplate
---@field CloseButton Button
local ToolkitFrame = {}

---@param highlight table?
function ToolkitFrame:CreateCloseButton(highlight) end

---@generic Tp
---@param name? string
---@param drawLayer? DrawLayer
---@param templateName? `Tp` | Template
---@return ToolkitTextureTemplate|Tp
function ToolkitFrame:CreateTexture(name, drawLayer, templateName) end

----------------------------------------------------------------
-- Layout
----------------------------------------------------------------

---@class ToolkitLayoutTemplate: Frame | Texture
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
-- Texture
----------------------------------------------------------------

---@class ToolkitTextureTemplate: Texture, ToolkitLayoutTemplate
local ToolkitTexture = {}

function ToolkitTexture:DisableSharpening() end