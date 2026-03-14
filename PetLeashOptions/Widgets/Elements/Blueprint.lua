--[[--------------------------------------------------------------------

    Creates options widgets with a dependency graph parented to a group.
    Widgets are not automatically positioned.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

local TestFrame = T.CreateFrame("Frame", nil, UIParent)
TestFrame:SetSize(680, 580)
TestFrame:SetPoint("LEFT", CollectionsJournal, "RIGHT", 50, 0)
TestFrame:SetPoint("TOP", CollectionsJournal, "TOP")
TestFrame:SetClampedToScreen(true)
TestFrame:SetFrameLevel(500)
TestFrame:SetFrameStrata("DIALOG")

TestFrame:SetMovable(true)
TestFrame:EnableMouse(true)
TestFrame:RegisterForDrag("LeftButton")
TestFrame:SetScript("OnDragStart", TestFrame.StartMoving)
TestFrame:SetScript("OnDragStop", TestFrame.StopMovingOrSizing)

TestFrame:CreateBackdrop()
TestFrame:SetBackdropTexture(Media.Textures.Background)

local Title = TestFrame:CreateFontString(nil, "OVERLAY")
Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
Title:SetText("Test Frame")
Title:SetTextColor(Media.Colors.Foreground:GetRGB())
Title:SetPoint("TOPLEFT", 20, -15)

local Version = TestFrame:CreateFontString(nil, "OVERLAY")
Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
Version:SetTextColor(Media.Colors.Background:GetRGB())
Version:SetText(format(L.VERSION, C.Version))
Version:SetPoint("BOTTOMRIGHT", -7, 7)

TestFrame.CloseButton = C.CreateCloseButton(TestFrame)
TestFrame.CloseButton:SetPoint("CENTER", TestFrame, "TOPRIGHT", -15, -12)

local Options = {
    group = {
        name = GENERAL,
        height = 200,
        width = 640,
        position = { "TOPLEFT", 20, -50 },
        controls = {
            enable = {
                type = "toggle",
                name = ENABLE,
                desc = L.OPTIONS_ENABLE_AUTO_SUMMON,
                position = { "TOPLEFT", 10, -30 },
                get = function() return C.db.enable end,
                set = function(value)
                    C.db.enable = value
                    if value then T.Enable() else T.Disable() end
                end,
                order = 0
            },
            autoSwitch = {
                type = "toggle",
                name = L.OPTIONS_ENABLE_AUTO_SWITCH,
                position = { "TOP", "enable", "BOTTOM", x = 0, y = 0 },
                disable = function() return not C.db.enable or #C.db.pets < 2 end,
                get = function() return C.db.autoSwitch end,
                set = function(value) C.db.autoSwitch = value end,
                order = 1
            },
            autoSwitchInterval = {
                type = "range",
                name = L.OPTIONS_AUTO_SWITCH_INTERVAL,
                min = 1, max = 30, step = 1,
                position = { "LEFT", "autoSwitch", "RIGHT", 230, 0 },
                disable = function() return not C.db.autoSwitch or #C.db.pets < 2 end,
                get = function() return C.db.switchTimer end,
                set = function(value) C.db.switchTimer = value end,
                order = 2
            }
        }
    }
}

-- todo: move to group
local widgets = {}

local function NotifyChange()
    for widget in next, widgets do
        if widget.disable and type(widget.disable) == "function" then
            local shouldDisable = widget.disable()
            if shouldDisable then
                widget:Disable()
            else
                widget:Enable()
            end
        end
    end
end

---@param group Frame|PetLeashOptionsGroup
---@param obj Frame
---@param points table
local function HandlePosition(group, obj, points)
    if points and type(points) == "table" then
        local point, relativeTo, relativePoint, x, y = points.point, points.relativeTo, points.relativePoint, points.x, points.y
        if relativeTo and type(relativeTo) == "string" then
            if group.controls and type(group.controls) == "table" then
                for control in pairs(group.controls) do
                    if string.lower(control.name) == relativeTo then
                        relativeTo = control
                    end
                end
            end
        end

        obj:SetPoint(point, relativeTo, relativePoint, x, y)
    end
end

---@param obj table
---@param group PetLeashOptionsGroup
---@return PetLeashSlider
local function CreateRange(obj, group)
    local widget = C.CreateSlider(group, obj.name, obj.min, obj.max, obj.step)
    widget.key = obj.key
    widget.get = obj.get
    widget.set = obj.set
    widget.disable = obj.disable

    widget.Slider:SetValue(obj.get(), true)

    widget.Slider:HookScript("OnValueChanged", function(self)
        local value = self.Slider:GetValue()
        widget.set(value)
        NotifyChange()
    end)

    return widget
end

---@param obj table
---@param group PetLeashOptionsGroup
---@return PetLeashCheckbox
local function CreateToggle(obj, group)
    local widget = C.CreateCheckbox(group, obj.name, obj.desc or obj.name)
    widget.key = obj.key
    widget.get = obj.get
    widget.set = obj.set
    widget.disable = obj.disable

    widget:SetChecked(obj.get())
    widget:HandleCheckedTexture()

    widget:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        widget.set(value)
        NotifyChange()
    end)

    return widget
end

---@param container Frame
---@param options table
local function RegisterOptions(container, options)
    if type(options) == "table" then
        local cfg = options.group

        -- Create group
        local group
        if cfg then
            ---@class PetLeashOptionsGroup
            group = C.CreateGroup(cfg.name, container, cfg.width, cfg.height)

            -- temp
            if cfg.position and type(cfg.position) == "table" then
                group:SetPoint(unpack(cfg.position))
            end

            group.controls = {}
        end

        local sorted = {}
        for key, data in pairs(cfg.controls) do
            data.key = key
            table.insert(sorted, data)
        end

        table.sort(sorted, function(a, b)
            return (a.order or -1) < (b.order or -1)
        end)

        DevTool:AddData(sorted)

        -- Create controls
        for _, control in ipairs(sorted) do
            local widget = nil
            if control.type == "toggle" then
                widget = CreateToggle(control, group)

                if not group.controls[widget] then
                    group.controls[widget] = true
                    -- temp
                    widgets[widget] = true
                end
            end

            if control.type == "range" then
                widget = CreateRange(control, group)

                if not group.controls[widget] then
                    group.controls[widget] = true
                    -- temp
                    widgets[widget] = true
                end
            end

            if control.position and type(control.position) == "table" then
                if control.position[2] and type(control.position[2]) == "string" then
                    -- :SetPoint will do a _G lookup so we don't need to
                    for c in next, group.controls do
                        if c.key == control.position[2] then
                            control.position[2] = c
                        end
                    end
                end

                if widget then
                   widget:SetPoint(unpack(control.position))
                end
            end
        end

        NotifyChange()
    end
end

RegisterOptions(TestFrame, Options)

-- C.BuildFromAceConfig = BuildFromAceConfig