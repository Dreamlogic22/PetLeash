--[[--------------------------------------------------------------------

    Base mixin for all widgets that controls options & interact with
    settings specialize and use.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C = select(2, ...)

---@class ControlWidgetMixin: Button
local ControlWidgetMixin = {}
do
    ControlWidgetMixin.data = {}
    ControlWidgetMixin.events = {}

    ---@param name string
    function ControlWidgetMixin:Fire(name, ...)
        if self.events[name] and type(self.events[name]) == "function" then
			pcall(self.events[name], self, name, ...)
		end
    end

    ---@param key string
	function ControlWidgetMixin:GetData(key)
		return self.data[key]
	end

    ---@param key string
	function ControlWidgetMixin:SetData(key, value)
		self.data[key] = value
	end

    ---@param name string
    ---@param func function
    function ControlWidgetMixin:SetCallback(name, func)
        if func and type(func) == "function" then
			self.events[name] = func
		end
    end

    ---@param func function
    function ControlWidgetMixin:GetValue(func, ...)
        if func and type(func) == "function" then
            func(...)
        end
    end

    ---@param func function
    function ControlWidgetMixin:SetValue(func, ...)
        if func and type(func) == "function" then
            func(...)
        end

        self:Fire("OnValueChanged", self:GetName())
    end

    ---@param func function
    function ControlWidgetMixin:CheckDisabled(func, ...)
        if func and type(func) == "function" then
            func(...)
        end

        ---@type Frame
        if self:IsEnabled() then
            self:Fire("OnEnabled", self)
        else
            self:Fire("OnDisabled", self)
        end
    end
end

---@class ControlContainerMixin: PetLeashSection
local ControlContainerMixin = CreateFromMixins(ControlWidgetMixin)
do
    ControlContainerMixin.widgets = {}

    function ControlContainerMixin:AddControl(widget)
        if not self.widgets[widget] then
            Mixin(widget, ControlWidgetMixin)
            self.widgets[widget] = true
        end
    end

    C.ControlContainerMixin = ControlContainerMixin
end

---@class PetLeashSettingsMixin
local PetLeashSettingsMixin = {}
do
    ---@param path PetLeashDB
    ---@param onValueChanged function?
    function PetLeashSettingsMixin:Bind(path, onValueChanged)
        self.path = path
        self.onValueChanged = onValueChanged
        self:SetValue(path)
        self:SetScriptHandler()
    end

    function PetLeashSettingsMixin:CommitChange(value)
        if self.path then
            C.db[self.path] = value
        end

        if self.onValueChanged then
            self.onValueChanged(value)
        end
    end

    function PetLeashSettingsMixin:SetScriptHandler()
        error("Control must implement :SetScriptHandler")
    end

    function PetLeashSettingsMixin:SetValue(value)
        error("Control must implement :SetValue")
    end
end

C.PetLeashSettingsMixin = PetLeashSettingsMixin