--[[------------------------------------------------------------------

    Inspired by AceConfig-3.0.  Factories for creating
    options-aware objects.  Info tables are annotated below.

--------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)

---@class ConfigInfo: table
---@field desc string?
---@field disable function
---@field get function
---@field max number
---@field min number
---@field name string
---@field parent ConfigGroup
---@field set function
---@field step number
---@field type string

---@param info ConfigInfo
local function CreateControl(info)
	---@class Control: Frame, Button
	local widget

	if info.type == "range" then
		---@class Range: PetLeashSlider, Control
		widget = C.CreateSlider(info.parent, info.name, info.min, info.max, info.step)
		widget:SetValue(info.get())

		widget.Slider:HookScript("OnValueChanged", function(self)
			local value = self:GetValue()
			widget.set(value)

			info.parent:NotifyChange()
		end)
	end

	if info.type == "toggle" then
		---@class Toggle: PetLeashCheckbox, Control
		widget = C.CreateCheckbox(info.parent, info.name, info.desc)

		widget:SetChecked(info.get())

		widget:HookScript("OnClick", function()
			local value = widget:GetChecked()
			widget.set(value)

			info.parent:NotifyChange()
		end)
	end

	widget.disable = info.disable
	widget.get = info.get
	widget.set = info.set

	return widget
end

local CreateConfigGroup
do
	---@param parent Frame
	CreateConfigGroup = function(parent)
		---@class ConfigGroup: PetLeashContainer
		local ConfigGroup = C.CreateContainer(parent)

		---@type table<Control, boolean>
		ConfigGroup.Controls = {}

		function ConfigGroup:NotifyChange()
			for control in next, self.Controls do
				if control.disable and type(control.disable) == "function" then
					local shouldDisable = control.disable()
					if shouldDisable then
						control:Disable()
					else
						control:Enable()
					end
				end
			end
		end

		function ConfigGroup:RegisterControl(info)
			info.parent = self
			local widget = CreateControl(info)

			if not self.Controls[widget] then
				self.Controls[widget] = true
			end

			return widget
		end

		return ConfigGroup
	end

	C.CreateConfigGroup = CreateConfigGroup
end
