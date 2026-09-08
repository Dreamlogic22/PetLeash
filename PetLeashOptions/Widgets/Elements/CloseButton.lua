--[[--------------------------------------------------------------------

    Custom close button for dialogs and popups.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)
local Media = C.Media

local CreateCloseButton
do
	---@param parent Frame
	---@return PetLeashCloseButton
	CreateCloseButton = function(parent)
		---@class PetLeashCloseButton: ToolkitButtonTemplate
		local CloseButton = CreateFrame("Button", nil, parent, "ToolkitButtonTemplate")
		CloseButton:SetSize(14, 14)
		CloseButton:SetPoint("TOPRIGHT", -6, -6)

		CloseButton.Texture = CloseButton:CreateTexture(nil, "OVERLAY")
		CloseButton.Texture:SetTexture(Media.Textures.Close)
		CloseButton.Texture:SetInside()

		CloseButton.HoverColor = { Media.Colors.Foreground:GetRGB() }

		---@param r number
		---@param g number
		---@param b number
		function CloseButton:SetHoverColor(r, g, b)
			self.HoverColor = { r, g, b }
		end

		CloseButton:SetScript("OnClick", function(self)
			PlaySoundFile(567481)
			self:GetParent():Hide()
		end)

		CloseButton:SetScript("OnEnter", function(self)
			self.Texture:SetVertexColor(unpack(self.HoverColor))
		end)

		CloseButton:SetScript("OnLeave", function(self)
			self.Texture:SetVertexColor(1, 1, 1)
		end)

		return CloseButton
	end

	C.CreateCloseButton = CreateCloseButton
end
