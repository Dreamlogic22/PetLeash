---@meta _

----------------------------------------------------------------
-- Therapy
----------------------------------------------------------------

---@class TherapyDevTools
TherapyDevTools = {}

---@param addOnName string
function TherapyDevTools_Monitor(addOnName) end

----------------------------------------------------------------
-- ElvUI
----------------------------------------------------------------
ElvUI = {}

----------------------------------------------------------------
-- Blizzard
----------------------------------------------------------------

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/76925da92f3be482d5bf83f11cc5f203fc78b9c6/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L56)
---@class EventUtil
EventUtil = {}

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/76925da92f3be482d5bf83f11cc5f203fc78b9c6/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L56)
---@param addOnName string
---@param callback function
function EventUtil.ContinueOnAddOnLoaded(addOnName, callback) end

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/1763f5cb047ed1d36d7feba85e2582445253ebf0/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L81)
---@param callback  function
function EventUtil.ContinueOnPlayerLogin(callback) end

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/02905451beb5cd7a8ef69a4c905e34af2c1e4d0e/Interface/AddOns/Blizzard_SharedXML/EventUtil.lua#L63)
---@param frameEvent FrameEvent
---@param callback function
function EventUtil.RegisterOnceFrameEventAndCallback(frameEvent, callback, ...) end

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/3fefc3a27250137e2554384b413b9060a4fefcfd/Interface/AddOns/Blizzard_SharedXMLBase/FunctionUtil.lua#L115)
---@param f function
function GenerateClosure(f, ...) end

PetJournal = CreateFrame("Frame")
PetJournalFindBattle = CreateFrame("Button")

---[Documentation](https://github.com/Gethe/wow-ui-source/blob/d6dffb48b2c0d7a7ab5d37dad2817ccee710e0ef/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua#L8)
---@param frame Frame
---@param state string
---@param values string
function RegisterAttributeDriver(frame, state, values) end

---[Documentation](https://warcraft.wiki.gg/wiki/API_UnregisterStateDriver)
---@param frame Frame
---@param state string
function UnregisterAttributeDriver(frame, state) end