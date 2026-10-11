---@type PetLeashOptions
local C = select(2, ...)
local Media = C.Media

---@class Mixins
local Mixins = C.Mixins

local baseButton = CreateFrame("Button")

local backdropR, backdropG, backdropB = 0.11, 0.11, 0.11
local borderR, borderG, borderB = 0, 0, 0
local borderSize = 1
local transparency = 0.8

---@class PetLeashFrameTemplate: PetLeashRegion, Frame
local PetLeashFrame = CreateFromMixins(Mixins.Region)
do
	---@param transparent? boolean
	function PetLeashFrame:CreateBackdrop(transparent)
		if self.Backdrop then
			return
		end

		self.Backdrop = self:CreateTexture(nil, "BACKGROUND")
		self.Backdrop:SetAllPoints()
		self.Backdrop:SetTexture(Media.Textures.Blank)
		self.Backdrop:SetVertexColor(backdropR, backdropG, backdropB, transparent and transparency or 1)

		self.BorderTop = self:CreateTexture(nil, "BORDER")
		self.BorderTop:SetPoint("TOPLEFT")
		self.BorderTop:SetPoint("TOPRIGHT")
		self.BorderTop:SetHeight(borderSize)
		self.BorderTop:SetColorTexture(borderR, borderG, borderB)

		self.BorderBottom = self:CreateTexture(nil, "BORDER")
		self.BorderBottom:SetPoint("BOTTOMLEFT")
		self.BorderBottom:SetPoint("BOTTOMRIGHT")
		self.BorderBottom:SetHeight(borderSize)
		self.BorderBottom:SetColorTexture(borderR, borderG, borderB)

		self.BorderLeft = self:CreateTexture(nil, "BORDER")
		self.BorderLeft:SetPoint("TOPLEFT")
		self.BorderLeft:SetPoint("BOTTOMLEFT")
		self.BorderLeft:SetWidth(borderSize)
		self.BorderLeft:SetColorTexture(borderR, borderG, borderB)

		self.BorderRight = self:CreateTexture(nil, "BORDER")
		self.BorderRight:SetPoint("TOPRIGHT")
		self.BorderRight:SetPoint("BOTTOMRIGHT")
		self.BorderRight:SetWidth(borderSize)
		self.BorderRight:SetColorTexture(borderR, borderG, borderB)
	end

	---@param name? string
	---@param drawLayer? DrawLayer
	---@param templateName? Template
	---@param subLevel? number
	---@return PetLeashTexture
	function PetLeashFrame:CreateTexture(name, drawLayer, templateName, subLevel)
		return Mixin(baseButton.CreateTexture(self, name, drawLayer, templateName, subLevel), Mixins.Texture)
	end

	---@param r number
	---@param g number
	---@param b number
	---@param a? number
	function PetLeashFrame:SetBackdropColor(r, g, b, a)
		if self.Backdrop then
			self.Backdrop:SetVertexColor(r, g, b, a or 1)
		end
	end

	---@param texture TextureAsset
	function PetLeashFrame:SetBackdropTexture(texture)
		if self.Backdrop then
			self.Backdrop:SetTexture(texture)
			self.Backdrop:SetVertexColor(1, 1, 1, 1)
		end
	end

	---@param r number
	---@param g number
	---@param b number
	---@param a? number
	function PetLeashFrame:SetBorderColor(r, g, b, a)
		if self.Backdrop then
			self.BorderTop:SetColorTexture(r, g, b, a or 1)
			self.BorderBottom:SetColorTexture(r, g, b, a or 1)
			self.BorderLeft:SetColorTexture(r, g, b, a or 1)
			self.BorderRight:SetColorTexture(r, g, b, a or 1)
		end
	end

	Mixins.Frame = PetLeashFrame
end

---@class PetLeashButtonTemplate: PetLeashFrameTemplate, Button
local PetLeashButton = CreateFromMixins(Mixins.Frame)
do
	---@param texture TextureAsset
	---@param rotation? number
	function PetLeashButton:SetTexture(texture, rotation)
		if self.Texture then
			return
		end

		self.Texture = self:CreateTexture(nil, "ARTWORK")
		self.Texture:SetTexture(texture)
		self.Texture:SetInside()

		if rotation then
			self.Texture:SetRotation(rotation)
		end
	end

	---@param texture TextureAsset
	function PetLeashButton:SetupTextures(texture)
		self:SetNormalTexture(texture)
		self:SetHighlightTexture(texture)
		self:SetPushedTexture(texture)

		local Normal, Highlight, Pushed = self:GetNormalTexture(), self:GetHighlightTexture(), self:GetPushedTexture()

		if Normal then
			Normal = Mixin(Normal, Mixins.Texture)
			Normal:DisableSharpening()
			Normal:SetInside()
		end

		if Highlight then
			Highlight = Mixin(Highlight, Mixins.Texture)
			Highlight:SetBlendMode("ADD")
			Highlight:SetAlpha(0.25)
			Highlight:DisableSharpening()
			Highlight:SetInside()
		end

		if Pushed then
			Pushed = Mixin(Pushed, Mixins.Texture)
			Pushed:SetBlendMode("BLEND")
			Pushed:SetVertexColor(0.9, 0.9, 0.9)
			Pushed:DisableSharpening()
		end
	end

	Mixins.Button = PetLeashButton
end
