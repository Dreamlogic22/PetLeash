---@meta _

----------------------------------------------------------------
-- DevTool
----------------------------------------------------------------

---[Source](https://github.com/brittyazel/DevTool)
---@class DevTool
DevTool = {}

---[Source](https://github.com/brittyazel/DevTool/blob/55fe559db5986b7ed75578d444351370db030f6f/DevTool.lua#L243)
---@param dataName string?
function DevTool:AddData(data, dataName) end

----------------------------------------------------------------
-- ElvUI
----------------------------------------------------------------

---@class ElvUI
ElvUI = {}

---@class ElvUF_Player
---@field RaisedElementParent Frame
---@field DisableElement fun(self, string)
ElvUF_Player = CreateFrame("Frame")

ElvUI_ReputationBarHolder = {}

----------------------------------------------------------------
-- Masque
----------------------------------------------------------------

---@alias MasqueButtonType
---| "Action"
---| "Aura"
---| "Backpack"
---| "BagSlot"
---| "Buff"
---| "Debuff"
---| "Enchant"
---| "Item"
---| "Pet"
---| "Possess"
---| "ReagentBag"
---| "Stance"

---[Documentation](https://github.com/SFX-WoW/Masque/wiki)
---@class Masque
Masque = {}

---@class MasqueGroup
MasqueGroup = {}

---@param name string
---@param list table?
---@param baseType MasqueButtonType?
function Masque:AddType(name, list, baseType) end

---@param addOnName string
---@param groupName string?
---@return MasqueGroup
function Masque:Group(addOnName, groupName) end

---@param button Button | Frame
---@param regions table?
---@param buttonType MasqueButtonType?
---@param strict boolean?
function MasqueGroup:AddButton(button, regions, buttonType, strict) end
