---@meta _

----------------------------------------------------------------
-- Camera
----------------------------------------------------------------

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_SharedXML/Shared/ModelSceneCameras/CameraBaseMixin.lua#L22)
CAMERA_TRANSITION_TYPE_IMMEDIATE = 1
CAMERA_MODIFICATION_TYPE_MAINTAIN = 2

----------------------------------------------------------------
-- Chat
----------------------------------------------------------------

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_ChatFrameBase/Shared/SlashCommandsRegistry.lua#L16)
SlashCmdList = {}

----------------------------------------------------------------
-- Collections
----------------------------------------------------------------

DressUpFrame = CreateFrame("Frame")

DressUpFrameResetButton = CreateFrame("Button")

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_Collections/Mainline/Blizzard_Collections.xml#L14)
CollectionsJournal = CreateFrame("Frame")

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_Collections/Shared/Blizzard_PetCollection.xml#L794)
PetJournal = CreateFrame("Frame")

----------------------------------------------------------------
-- Colors
----------------------------------------------------------------

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_Colors/Mainline/ColorManager.lua#L1)
ColorManager = {}

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_Colors/Mainline/ColorManager.lua#L52)
---@param quality number
---@return ColorRGBData?
function ColorManager.GetColorDataForItemQuality(quality) end

----------------------------------------------------------------
-- EditMode
----------------------------------------------------------------

---@class EditModeManagerFrame: Frame
EditModeManagerFrame = CreateFrame("Frame")

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/a98ae71cdacbc6d87325995c76ff3fc18677e45f/Interface/AddOns/Blizzard_EditMode/Shared/EditModeManager.lua#L694)
function EditModeManagerFrame:ClearSelectedSystem() end

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/92746ed8486727ca4974f9f830fdfbf48d6bcce2/Interface/AddOns/Blizzard_EditMode/Mainline/EditModeManager.lua#L132)
---@return boolean
function EditModeManagerFrame:IsEditModeActive() end

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/428c09816801e8d71cc987924203539f51deaf52/Interface/AddOns/Blizzard_EditMode/Mainline/EditModeManager.lua#L309)
---@param systemFrame EditModeSystemSelection
function EditModeManagerFrame:OnSystemPositionChange(systemFrame) end

---@class EditModeSystemSelection: Frame
local EditModeSystemSelection = CreateFrame("Frame")

---@return string?
function EditModeSystemSelection:GetSystemName() end

---@param hasActiveChanges boolean
function EditModeSystemSelection:SetHasActiveChanges(hasActiveChanges) end

EditModeSystemSettingsDialog = CreateFrame("Frame")

----------------------------------------------------------------
-- EventUtil
----------------------------------------------------------------

---[Source](https://github.com/Gethe/wow-ui-source/blob/76925da92f3be482d5bf83f11cc5f203fc78b9c6/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L56)
---@class EventUtil
EventUtil = {}

---[Source](https://github.com/Gethe/wow-ui-source/blob/76925da92f3be482d5bf83f11cc5f203fc78b9c6/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L56)
---@param addOnName string
---@param callback function
function EventUtil.ContinueOnAddOnLoaded(addOnName, callback) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/1763f5cb047ed1d36d7feba85e2582445253ebf0/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L81)
---@param callback  function
function EventUtil.ContinueOnPlayerLogin(callback) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/02905451beb5cd7a8ef69a4c905e34af2c1e4d0e/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L63)
---@param frameEvent FrameEvent
---@param callback function
function EventUtil.RegisterOnceFrameEventAndCallback(frameEvent, callback, ...) end

----------------------------------------------------------------
-- GlobalStrings
----------------------------------------------------------------

ACCEPT = "Accept"
BINDING_NAME_VEHICLEEXIT = "Exit Vehicle"
CANCEL = "Cancel"
COUNTDOWN = "Countdown"
CRF_COUNTDOWN = "Countdown"
CRF_READY_CHECK = "Ready Check"
ENABLE = "Enable"
GENERAL = "General"
NONE = "None"
PETS = "Pets"
NOT_BOUND = "Not bound"
REMOVE_WORLD_MARKERS = "Clear All"
TAXI_CANCEL = "Request Stop"
TAXI_CANCEL_DESCRIPTION = "Land at the next available Flight Master."
UNKNOWN = "Unknown"

----------------------------------------------------------------
-- Interface
----------------------------------------------------------------

---@class AchievementStatTemplateMixin
AchievementStatTemplateMixin = {}

---@class AchievementFrameStats
---@field ScrollBox ScrollFrame|ScrollBoxViewMixin
AchievementFrameStats = {}

BagItemAutoSortButton = CreateFrame("Button")

BagItemSearchBox = CreateFrame("EditBox")

BankFrame = CreateFrame("Frame")

---@class BankPanel: Frame
---@field AutoSortButton Button
BankPanel = CreateFrame("Frame")

BankItemSearchBox = CreateFrame("EditBox")

MainMenuBarVehicleLeaveButton = CreateFrame("Button")

---@class PlayerFrame: Frame
PlayerFrame = CreateFrame("Frame")

---@class TargetFrame: Frame
TargetFrame = CreateFrame("Frame")

---@class ScrollBoxViewMixin
ScrollBoxViewMixin = {}

---@class ScrollBoxElement
---@field Value FontString

---@param elementData table
---@return Frame | ScrollBoxElement
function ScrollBoxViewMixin:FindFrame(elementData) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/a29cc452e9c3d86b40ff7cc1024eb36ed8306cdd/Interface/AddOns/Blizzard_UnitFrame/Mainline/TargetFrame.lua#L963)
---@param unit UnitToken
---@param index number
function SetRaidTargetIcon(unit, index) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/a29cc452e9c3d86b40ff7cc1024eb36ed8306cdd/Interface/AddOns/Blizzard_UnitFrame/Mainline/TargetFrame.lua#L959)
---@param texture Texture
---@param raidTargetIconIndex number
function SetRaidTargetIconTexture(texture, raidTargetIconIndex) end

----------------------------------------------------------------
-- Maps
----------------------------------------------------------------

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_SharedMapDataProviders/QuestOfferDataProvider.lua#L402)
---@class QuestOfferPinMixin
---@field Texture Texture
---@field pinAlpha number
QuestOfferPinMixin = {}

----------------------------------------------------------------
-- RestrictedEnvironment
----------------------------------------------------------------

---[Source](https://github.com/Gethe/wow-ui-source/blob/d6dffb48b2c0d7a7ab5d37dad2817ccee710e0ef/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua#L8)
---@param frame Frame
---@param state string
---@param values string
function RegisterAttributeDriver(frame, state, values) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureHandlers.lua#L602)
---@param frame Frame
---@param script string
---@param header Frame
---@param preBody string
---@param postBody string?
function SecureHandlerWrapScript(frame, script, header, preBody, postBody) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/d6dffb48b2c0d7a7ab5d37dad2817ccee710e0ef/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua#L16)
---@param frame Frame
---@param attribute string
function UnregisterAttributeDriver(frame, attribute) end

----------------------------------------------------------------
-- UIParent
----------------------------------------------------------------

StaticPopupDialogs = {}

---[Source](https://github.com/Gethe/wow-ui-source/blob/0944c3ad44986a9d61cc766caafc7a71f8e35296/Interface/AddOns/Blizzard_StaticPopup/StaticPopup.lua#L126C1-L126C46)
---@param which string
---@param data table?
function StaticPopup_FindVisible(which, data) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/0944c3ad44986a9d61cc766caafc7a71f8e35296/Interface/AddOns/Blizzard_StaticPopup/StaticPopup.lua#L278)
---@param which string
---@param text_arg1 string?
---@param text_arg2 string?
---@param data table?
---@param insertedFrame Frame?
---@param customOnHideScript function?
function StaticPopup_Show(which, text_arg1, text_arg2, data, insertedFrame, customOnHideScript) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/3efa68def3508af73f2b695e7251648573849038/Interface/AddOns/Blizzard_UIParent/Mainline/UIParent.lua#L63)
UISpecialFrames = {}

---[Source](https://github.com/Gethe/wow-ui-source/blob/4e3cbb8c5609e4bfc332c0aebbfa4d79731fab59/Interface/AddOns/Blizzard_UIParentPanelManager/Shared/UIParentPanelManager.lua#L1108)
---@param currentFrame Frame
function UpdateUIPanelPositions(currentFrame) end

----------------------------------------------------------------
-- Utils
----------------------------------------------------------------

---[Source](https://github.com/Gethe/wow-ui-source/blob/d6dffb48b2c0d7a7ab5d37dad2817ccee710e0ef/Interface/AddOns/Blizzard_SharedXMLBase/FrameUtil.lua#L9)
FrameUtil = {}

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/d6dffb48b2c0d7a7ab5d37dad2817ccee710e0ef/Interface/AddOns/Blizzard_SharedXMLBase/FrameUtil.lua#L33)
---@param frame Frame
---@param events table
function FrameUtil.RegisterFrameForEvents(frame, events) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/d6dffb48b2c0d7a7ab5d37dad2817ccee710e0ef/Interface/AddOns/Blizzard_SharedXMLBase/FrameUtil.lua#L45)
---@param frame Frame
---@param events table
function FrameUtil.RegisterFrameForUnitEvents(frame, events, ...) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/16566ff83c6b9ac1746e4bf22ba9767216a8b832/Interface/AddOns/Blizzard_SharedXML/PixelUtil.lua#L1)
---@class PixelUtil
PixelUtil = {}

---[Source](https://github.com/Gethe/wow-ui-source/blob/c94ce535a4fffc02d91b915af207941068b93eb4/Interface/AddOns/Blizzard_SharedXML/PixelUtil.lua#L8)
---@param uiUnitSize number
---@param layoutScale number
---@param minPixels? number
---@return number
function PixelUtil.GetNearestPixelSize(uiUnitSize, layoutScale, minPixels) end

---[Source](https://github.com/Gethe/wow-ui-source/blob/c94ce535a4fffc02d91b915af207941068b93eb4/Interface/AddOns/Blizzard_SharedXML/PixelUtil.lua#L8)
---@return number
function PixelUtil.GetPixelToUIUnitFactor() end

---[Source](https://github.com/Gethe/wow-ui-source/blob/c94ce535a4fffc02d91b915af207941068b93eb4/Interface/AddOns/Blizzard_SharedXMLBase/MathUtil.lua#L79)
---@param value number
---@return number
function Round(value) end
