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
        local Backdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
        Backdrop:SetAllPoints()
        Backdrop:SetFrameLevel(self:GetFrameLevel())

        local borderSize = 1
        local borderR, borderG, borderB = 1, 1, 1
        local backdropR, backdropG, backdropB = 0.11, 0.11, 0.11

        Backdrop:SetBackdrop({ bgFile = LSM:Fetch("background", "Therapy Blank") })
        Backdrop:SetBackdropColor(backdropR, backdropG, backdropB, transparent and 0.75 or 1)

        Backdrop.BorderTop = Backdrop:CreateTexture(nil, "BORDER", nil, 1)
        Backdrop.BorderTop:SetSize(borderSize, borderSize)
        Backdrop.BorderTop:SetPoint("TOPLEFT", Backdrop, "TOPLEFT", 0, 0)
        Backdrop.BorderTop:SetPoint("TOPRIGHT", Backdrop, "TOPRIGHT", 0, 0)
        Backdrop.BorderTop:SetSnapToPixelGrid(false)
        Backdrop.BorderTop:SetTexelSnappingBias(0)

        Backdrop.BorderBottom = Backdrop:CreateTexture(nil, "BORDER", nil, 1)
        Backdrop.BorderBottom:SetSize(borderSize, borderSize)
        Backdrop.BorderBottom:SetPoint("BOTTOMLEFT", Backdrop, "BOTTOMLEFT", 0, 0)
        Backdrop.BorderBottom:SetPoint("BOTTOMRIGHT", Backdrop, "BOTTOMRIGHT", 0, 0)
        Backdrop.BorderBottom:SetSnapToPixelGrid(false)
        Backdrop.BorderBottom:SetTexelSnappingBias(0)

        Backdrop.BorderLeft = Backdrop:CreateTexture(nil, "BORDER", nil, 1)
        Backdrop.BorderLeft:SetSize(borderSize, borderSize)
        Backdrop.BorderLeft:SetPoint("TOPLEFT", Backdrop, "TOPLEFT", 0, 0)
        Backdrop.BorderLeft:SetPoint("BOTTOMLEFT", Backdrop, "BOTTOMLEFT", 0, 0)
        Backdrop.BorderLeft:SetSnapToPixelGrid(false)
        Backdrop.BorderLeft:SetTexelSnappingBias(0)

        Backdrop.BorderRight = Backdrop:CreateTexture(nil, "BORDER", nil, 1)
        Backdrop.BorderRight:SetSize(borderSize, borderSize)
        Backdrop.BorderRight:SetPoint("TOPRIGHT", Backdrop, "TOPRIGHT", 0, 0)
        Backdrop.BorderRight:SetPoint("BOTTOMRIGHT", Backdrop, "BOTTOMRIGHT", 0, 0)
        Backdrop.BorderRight:SetSnapToPixelGrid(false)
        Backdrop.BorderRight:SetTexelSnappingBias(0)

        self:SetBorderColor(borderR, borderG, borderB)

        self.Backdrop = Backdrop
    end

    ---@param shadowScale number?
    function backdrop_api:CreateShadow(shadowScale)
        if self.Shadow then return end

        ---@class TuxShadow: Frame, BackdropTemplate
        local Shadow = CreateFrame("Frame", nil, self, "BackdropTemplate")
        Shadow:SetBackdrop({ edgeFile = LSM:Fetch("background", "Therapy Glow"), edgeSize = 4 })
        Shadow:SetFrameLevel((self:GetFrameLevel() - 1 >= 0 and self:GetFrameLevel() - 1) or 0)
        Shadow:SetPoint("TOPLEFT", self, "TOPLEFT", -3, 3)
        Shadow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
        Shadow:SetBackdropColor(0, 0, 0, 0.8)
        Shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
        Shadow:SetScale(shadowScale or 1)

        self.Shadow = Shadow
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