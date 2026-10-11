---@class Mixins
local Mixins = select(2, ...).Mixins

---@class PetLeashTexture: PetLeashRegion, Texture
local PetLeashTexture = CreateFromMixins(Mixins.Region)
do
	function PetLeashTexture:DisableSharpening()
		self:SetSnapToPixelGrid(false)
		self:SetTexelSnappingBias(0)
	end

	Mixins.Texture = PetLeashTexture
end
