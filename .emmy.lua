---@meta _

----------------------------------------------------------------
-- Therapy
----------------------------------------------------------------

---@class TherapyDevTools
TherapyDevTools = {}

---@param addOnName string
function TherapyDevTools_Monitor(addOnName) end

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