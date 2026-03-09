--[[------------------------------------------------------------------

    Shared widget utilities

--------------------------------------------------------------------]]

---@class PetLeash
local T = select(2, ...)

---@param texture Texture
function T.DisableSharpening(texture)
    texture:SetTexelSnappingBias(0)
    texture:SetSnapToPixelGrid(false)
end

---@param object FrameScriptObject | TextureBase
---@param anchor? Frame?
---@param offsetX number?
---@param offsetY number?
function T.SetInside(object, anchor, offsetX, offsetY)
    offsetX = offsetX or 1
    offsetY = offsetY or 1

    anchor = anchor or object:GetParent()

    if object:GetNumPoints() > 0 then
        object:ClearAllPoints()
    end

    object:SetPoint("TOPLEFT", anchor, "TOPLEFT", offsetX, -offsetY)
    object:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -offsetX, offsetY)
end

---@param object FrameScriptObject | TextureBase
---@param anchor? Frame
---@param offsetX? number
---@param offsetY? number
function T.SetOutside(object, anchor, offsetX, offsetY)
    offsetX = offsetX or 1
    offsetY = offsetY or 1

    anchor = anchor or object:GetParent()

    if object:GetNumPoints() > 0 then
        object:ClearAllPoints()
    end

    object:SetPoint("TOPLEFT", anchor, "TOPLEFT", -offsetX, offsetY)
    object:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", offsetX, -offsetY)
end

---@param button Button
---@param texture TextureAsset
function T.SetupButtonTextures(button, texture)
    button:SetNormalTexture(texture)
    button:SetHighlightTexture(texture)
    button:SetPushedTexture(texture)

    local Normal, Highlight, Pushed = button:GetNormalTexture(), button:GetHighlightTexture(), button:GetPushedTexture()

    if Normal then
        T.DisableSharpening(Normal)
        T.SetInside(Normal)
    end

    if Highlight then
        Highlight:SetBlendMode("ADD")
        Highlight:SetAlpha(0.25)
        T.DisableSharpening(Highlight)
        T.SetInside(Highlight)
    end

    if Pushed then
        Pushed:SetBlendMode("BLEND")
        Pushed:SetVertexColor(0.9, 0.9, 0.9)
        T.DisableSharpening(Pushed)
    end
end