--[[--------------------------------------------------------------------

    Groups for organizing and managing options widgets & their
    dependencies.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)

---@param info table
---@return Range|Toggle
local function CreateControl(info)
    ---@class Control
    local widget

    if info.type == "range" then
        ---@class Range: TherapySlider, Control
        widget = C.CreateSlider(info.parent, info.name, info.min, info.max, info.step)
        widget.disable = info.disable
        widget.get = info.get
        widget.set = info.set

        widget:SetValue(info.get())

        widget.Slider:HookScript("OnValueChanged", function(self)
            local value = self:GetValue()
            widget.set(value)

            info.parent:NotifyChange()
        end)
    end

    if info.type == "toggle" then
        ---@class Toggle: TherapyCheckbox, Control
        widget = C.CreateCheckbox(info.parent, info.name, info.desc)
        widget.disable = info.disable
        widget.get = info.get
        widget.set = info.set

        widget:SetChecked(info.get())

        widget:HookScript("OnClick", function()
            local value = widget:GetChecked()
            widget.set(value)

            info.parent:NotifyChange()
        end)
    end

    return widget
end

local CreateControlGroup
do
    ---@param title string
    ---@param parent Frame
    ---@param width number
    ---@param height number
    ---@return ControlGroup
    CreateControlGroup = function(title, parent, width, height)
        ---@class ControlGroup: TherapyGroup
        local ControlGroup = C.CreateGroup(title, parent, width, height)

        ---@type table<Toggle, boolean>
        ControlGroup.Controls = {}

        function ControlGroup:NotifyChange()
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

        ---@param info table
        function ControlGroup:RegisterControl(info)
            info.parent = self
            local widget = CreateControl(info)

            if not self.Controls[widget] then
                self.Controls[widget] = true
            end

            return widget
        end

        return ControlGroup
    end
end

C.CreateOptionsGroup = CreateControlGroup