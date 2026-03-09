--[[--------------------------------------------------------------------

    Therapy UX API methods for creating and modifying frame backdrops
    with greater flexibility than the standard Blizzard methods.

--------------------------------------------------------------------]]

---@type addonTbl
local T = select(2, ...)
local LSM = T.lib.LSM

---@class TherapyUX
local lib = T.lib

---@class TuxBackdrop: Frame
local backdrop_api = {}
do
    ---@param transparent boolean?
    function backdrop_api:CreateBackdrop(transparent)
        if self.Backdrop then return end

        ---@class TuxBackdrop: Frame, BackdropTemplate
        local backdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
        backdrop:SetAllPoints()
        backdrop:SetFrameLevel(self:GetFrameLevel())

        local borderSize = 1
        local borderR, borderG, borderB = 1, 1, 1
        local backdropR, backdropG, backdropB = 0.11, 0.11, 0.11

        backdrop:SetBackdrop({ bgFile = LSM:Fetch("background", "Therapy Blank") })
        backdrop:SetBackdropColor(backdropR, backdropG, backdropB, transparent and 0.75 or 1)

        backdrop.BorderTop = backdrop:CreateTexture(nil, "BORDER", nil, 1)
        backdrop.BorderTop:SetSize(borderSize, borderSize)
        backdrop.BorderTop:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 0, 0)
        backdrop.BorderTop:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", 0, 0)
        backdrop.BorderTop:SetSnapToPixelGrid(false)
        backdrop.BorderTop:SetTexelSnappingBias(0)

        backdrop.BorderBottom = backdrop:CreateTexture(nil, "BORDER", nil, 1)
        backdrop.BorderBottom:SetSize(borderSize, borderSize)
        backdrop.BorderBottom:SetPoint("BOTTOMLEFT", backdrop, "BOTTOMLEFT", 0, 0)
        backdrop.BorderBottom:SetPoint("BOTTOMRIGHT", backdrop, "BOTTOMRIGHT", 0, 0)
        backdrop.BorderBottom:SetSnapToPixelGrid(false)
        backdrop.BorderBottom:SetTexelSnappingBias(0)

        backdrop.BorderLeft = backdrop:CreateTexture(nil, "BORDER", nil, 1)
        backdrop.BorderLeft:SetSize(borderSize, borderSize)
        backdrop.BorderLeft:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 0, 0)
        backdrop.BorderLeft:SetPoint("BOTTOMLEFT", backdrop, "BOTTOMLEFT", 0, 0)
        backdrop.BorderLeft:SetSnapToPixelGrid(false)
        backdrop.BorderLeft:SetTexelSnappingBias(0)

        backdrop.BorderRight = backdrop:CreateTexture(nil, "BORDER", nil, 1)
        backdrop.BorderRight:SetSize(borderSize, borderSize)
        backdrop.BorderRight:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", 0, 0)
        backdrop.BorderRight:SetPoint("BOTTOMRIGHT", backdrop, "BOTTOMRIGHT", 0, 0)
        backdrop.BorderRight:SetSnapToPixelGrid(false)
        backdrop.BorderRight:SetTexelSnappingBias(0)

        self:SetBorderColor(borderR, borderG, borderB)

        self.Backdrop = backdrop
    end

    ---@param shadowScale number?
    function backdrop_api:CreateShadow(shadowScale)
        if self.Shadow then return end

        ---@class TuxShadow: Frame, BackdropTemplate
        local shadow = CreateFrame("Frame", nil, self, "BackdropTemplate")
        shadow:SetBackdrop({ edgeFile = LSM:Fetch("background", "Therapy Glow"), edgeSize = 4 })
        shadow:SetFrameLevel((self:GetFrameLevel() - 1 >= 0 and self:GetFrameLevel() - 1) or 0)
        shadow:SetPoint("TOPLEFT", self, "TOPLEFT", -3, 3)
        shadow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
        shadow:SetBackdropColor(0, 0, 0, 0.8)
        shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
        shadow:SetScale(shadowScale or 1)

        self.Shadow = shadow
    end

    ---@param r number
    ---@param g number
    ---@param b number
    ---@param a number?
    function backdrop_api:SetBackdropColor(r, g, b, a)
        if self.Backdrop then
            self.Backdrop:SetBackdropColor(r, g, b, a or 1)
        end
    end

    ---@param texture TextureAsset
    function backdrop_api:SetBackdropTexture(texture)
        if self.Backdrop then
            self.Backdrop:SetBackdrop({ bgFile = texture })
        end
    end

    ---@param r number
    ---@param g number
    ---@param b number
    ---@param a number?
    function backdrop_api:SetBorderColor(r, g, b, a)
        if self.Backdrop then
            self.Backdrop.BorderTop:SetColorTexture(r, g, b, a or 1)
            self.Backdrop.BorderBottom:SetColorTexture(r, g, b, a or 1)
            self.Backdrop.BorderRight:SetColorTexture(r, g, b, a or 1)
            self.Backdrop.BorderLeft:SetColorTexture(r, g, b, a or 1)
        end
    end

    ---@param size number
    function backdrop_api:SetBorderSize(size)
        if self.Backdrop then
            self.Backdrop.BorderTop:SetSize(size, size)
            self.Backdrop.BorderBottom:SetSize(size, size)
            self.Backdrop.BorderRight:SetSize(size, size)
            self.Backdrop.BorderLeft:SetSize(size, size)
        end
    end

    ---@param r number
    ---@param g number
    ---@param b number
    ---@param a number?
    function backdrop_api:SetShadowColor(r, g, b, a)
        if self.Shadow then
            self.Shadow:SetBackdropBorderColor(r, g, b, a or 0.8)
        end
    end
end

lib.backdrop_api = backdrop_api