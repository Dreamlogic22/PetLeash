--[[--------------------------------------------------------------------

    Creates a pool of options widgets with a dependency graph parented
    to a section.  Widgets are not automatically positioned.

----------------------------------------------------------------------]]

---@class PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

local Widgets = {}

local function UpdateGroup()
    for _, widget in pairs(Widgets) do
        if widget._aceOption.disabled then
            local shouldDisable = widget._aceOption.disabled()
            if shouldDisable then
                widget:Disable()
            else
                widget:Enable()
            end
        end
    end
end

---@param option table AceConfig toggle option
---@param parent Frame Parent frame
---@param yOffset number Vertical offset from parent
---@return Frame widget The created checkbox widget
local function CreateToggle(option, parent, yOffset)
    -- Create the visual widget
    local widget = C.CreateCheckbox(parent, option.name, option.desc)
    widget:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)

    -- Store metadata on the widget
    widget._aceOption = option
    widget._key = option._key

    -- Load initial state
    local initialValue = option.get()
    widget:SetChecked(initialValue)
    widget:HandleCheckedTexture()

    -- Wire up the change handler
    widget:HookScript("OnClick", function(self)
        local value = self:GetChecked()
        option.set(value)
        UpdateGroup()
    end)

    UpdateGroup()

    return widget
end

---@param optionsTbl table
---@param section PetLeashSection
local function BuildOptions(optionsTbl, section)
    -- Sort controls by order field
    local sorted = {}
    for key, option in pairs(optionsTbl.args) do
        option._key = key  -- Stash the key for later
        table.insert(sorted, option)
    end
    table.sort(sorted, function(a, b)
        return (a.order or 999) < (b.order or 999)
    end)

    -- Create widgets in order
    for _, option in ipairs(sorted) do
        local widget = nil

        if option.type == "toggle" then
            widget = CreateToggle(option, group)
        elseif option.type == "range" then
            -- TODO: slider support
        end
    end
end

-- In your options setup
local options = {
    type = "group",
    args = {
        enable = {
            type = "toggle",
            name = ENABLE,
            desc = L.OPTIONS_ENABLE_AUTO_SUMMON,
            get = function() return C.db.enable end,
            set = function(value)
                C.db.enable = value
                if value then T.Enable() else T.Disable() end
            end
        },
        autoSwitch = {
            type = "toggle",
            name = "Enable Auto-Switch",
            desc = "Automatically switch pets on a timer",
            disabled = function() return not C.db.enable end,
            get = function() return C.db.autoSwitch end,
            set = function(value) C.db.autoSwitch = value end,
        }
    }
}

local TestFrame = T.CreateFrame("Frame", "TestFrame", UIParent)
TestFrame:CreateBackdrop()
TestFrame:SetBackdropTexture(Media.Textures.Background)
TestFrame:SetSize(200, 100)
TestFrame:SetPoint("CENTER", -200, 0)

BuildOptions(options, TestFrame)

-- return the widgets position them manually - or just pluck references from the widget pool
-- remove all positioning logic OR pass in points [arrays]

-- C.BuildFromAceConfig = BuildFromAceConfig