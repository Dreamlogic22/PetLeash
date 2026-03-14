--[[--------------------------------------------------------------------

    Primary settings panel opened by right-clicking the icon attached
    to the PetJournal.

----------------------------------------------------------------------]]

---@type PetLeashOptions
local C, T = select(2, ...), PetLeash
local L, Media = T.Locale, T.Media

local ControlDefinitions = {
    AutoSwitch = {
        disable = function() return not C.db.enable end, -- or #C.db.pets < 2 end,
        get = function() return C.db.autoSwitch end,
        name = L.OPTIONS_ENABLE_AUTO_SWITCH,
        set = function(value)
            C.db.autoSwitch = value
            if value then T.Enable() else T.Disable() end
        end,
        type = "toggle"
    },
    AutoSwitchInterval = {
        disable = function() return (not C.db.autoSwitch or not C.db.enable) end, -- or #C.db.pets < 2 end,
        get = function() return C.db.switchTimer end,
        min = 1, max = 30, step = 1,
        name = L.OPTIONS_AUTO_SWITCH_INTERVAL,
        set = function(value) C.db.switchTimer = value end,
        type = "range"
    },
    Enable = {
        desc = L.OPTIONS_ENABLE_AUTO_SUMMON,
        get = function() return C.db.enable end,
        name = ENABLE,
        set = function(value) C.db.enable = value end,
        type = "toggle",
    },
    Throttle = {
        disable = function() return not C.db.enable end,
        desc = L.OPTIONS_CUSTOM_THROTTLE_TOOLTIP,
        get = function() return C.db.customThrottle end,
        name = L.OPTIONS_CUSTOM_THROTTLE,
        set = function(value) C.db.customThrottle = value end,
        type = "toggle"
    },
    ThrottleInterval = {
        disable = function() return (not C.db.customThrottle or not C.db.enable) end,
        get = function() return C.db.throttle end,
        min = 1, max = 120, step = 1,
        name = L.OPTIONS_CUSTOM_THROTTLE_INTERVAL,
        set = function(value) C.db.throttle = value end,
        type = "range"
    },
    OverrideSummonedPets = {
        desc = L.OPTIONS_ENABLE_OVERRIDE_TOOLTIP,
        disable = function() return not C.db.enable end,
        get = function() return C.db.override end,
        name = L.OPTIONS_ENABLE_OVERRIDE,
        set = function(value) C.db.override = value end,
        type = "toggle"
    }
}

do
    ---@class PetLeashOptionsDialog: TherapyFrame
    local Dialog = T.CreateFrame("Frame", "PetLeashOptionsDialog", UIParent)
    Dialog:SetSize(680, 580)
    Dialog:SetPoint("LEFT", CollectionsJournal, "RIGHT", 50, 0)
    Dialog:SetPoint("TOP", CollectionsJournal, "TOP")
    Dialog:SetClampedToScreen(true)
    Dialog:SetFrameLevel(500)
    Dialog:SetFrameStrata("DIALOG")
    Dialog:SetMovable(true)
    Dialog:EnableMouse(true)
    Dialog:RegisterForDrag("LeftButton")
    Dialog:Hide()

    Dialog:SetScript("OnDragStart", Dialog.StartMoving)
    Dialog:SetScript("OnDragStop", Dialog.StopMovingOrSizing)

    Dialog:CreateBackdrop()
    Dialog:SetBackdropTexture(Media.Textures.Background)

    local Title = Dialog:CreateFontString(nil, "OVERLAY")
    Title:SetFont(Media.Fonts.Bold, 20, "THICKOUTLINE")
    Title:SetText(C.Title)
    Title:SetPoint("TOPLEFT", 20, -15)

    local Version = Dialog:CreateFontString(nil, "OVERLAY")
    Version:SetFont(Media.Fonts.Bold, 12, "OUTLINE")
    Version:SetTextColor(Media.Colors.Background:GetRGB())
    Version:SetText(format(L.VERSION, C.Version))
    Version:SetPoint("BOTTOMRIGHT", -7, 7)

    Dialog.CloseButton = C.CreateCloseButton(Dialog)
    Dialog.CloseButton:SetPoint("CENTER", Dialog, "TOPRIGHT", -15, -12)

    Dialog.General = C.CreateOptionsGroup(GENERAL, Dialog, 640, 200)
    Dialog.General:SetPoint("TOPLEFT", 20, -50)

    Dialog.Enable = Dialog.General:RegisterControl(ControlDefinitions.Enable)
    Dialog.Enable:SetPoint("TOPLEFT", 10, -30)

    Dialog.AutoSwitch = Dialog.General:RegisterControl(ControlDefinitions.AutoSwitch)
    Dialog.AutoSwitch:SetPoint("TOP", Dialog.Enable, "BOTTOM", 0, 0)
    Dialog.AutoSwitchInterval = Dialog.General:RegisterControl(ControlDefinitions.AutoSwitchInterval)
    Dialog.AutoSwitchInterval:SetPoint("LEFT", Dialog.AutoSwitch, "RIGHT", 230, 0)

    Dialog.Throttle = Dialog.General:RegisterControl(ControlDefinitions.Throttle)
    Dialog.Throttle:SetPoint("TOP", Dialog.AutoSwitch, "BOTTOM", 0, 0)
    Dialog.ThrottleInterval = Dialog.General:RegisterControl(ControlDefinitions.ThrottleInterval)
    Dialog.ThrottleInterval:SetPoint("LEFT", Dialog.Throttle, "RIGHT", 230, 0)

    Dialog.Override = Dialog.General:RegisterControl(ControlDefinitions.OverrideSummonedPets)
    Dialog.Override:SetPoint("TOP", Dialog.Throttle, "BOTTOM", 0, 0)

    Dialog.General:NotifyChange()

    -- Dialog.PetCards = C.CreateSection(PETS, Dialog, 640, 290)
    -- Dialog.PetCards:SetPoint("BOTTOMLEFT", 20, 30)

    -- todo: disabling logic that is not manual

    -- todo: hide and restore (if opened) in combat

    PetLeashOptionsDialog = Dialog
    tinsert(UISpecialFrames, "PetLeashOptionsDialog")
end