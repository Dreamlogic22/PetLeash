--[[--------------------------------------------------------------------

    Custom close button for dialogs and popups.

----------------------------------------------------------------------]]

local C = select(2, ...)
local Media = C.Media

local CreateCloseButton
do
	---@param parent Frame
	---@return CloseButton
	CreateCloseButton = function(parent)
		---@class CloseButton: ToolkitButtonTemplate & CheckButton
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

		---@param self CloseButton
		CloseButton:SetScript("OnClick", function(self)
			PlaySoundFile(567481)
			---@diagnostic disable-next-line: need-check-nil
			self:GetParent():Hide()
		end)

		---@param self CloseButton
		CloseButton:SetScript("OnEnter", function(self)
			self.Texture:SetVertexColor(unpack(self.HoverColor))
		end)

		---@param self CloseButton
		CloseButton:SetScript("OnLeave", function(self)
			self.Texture:SetVertexColor(1, 1, 1)
		end)

		return CloseButton
	end

	C.CreateCloseButton = CreateCloseButton
end
