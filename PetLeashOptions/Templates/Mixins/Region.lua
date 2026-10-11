---@class Mixins
local Mixins = select(2, ...).Mixins

---@class PetLeashRegion: Region
local PetLeashRegion = {}
do
	---@param anchor? Region
	---@param xOffset? number
	---@param yOffset? number
	function PetLeashRegion:SetInside(anchor, xOffset, yOffset)
		if not anchor then
			anchor = self:GetParent()
		end

		xOffset = xOffset and xOffset or 1
		yOffset = yOffset and yOffset or 1

		self:ClearAllPoints()

		self:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
		self:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
	end

	Mixins.Region = PetLeashRegion
end
