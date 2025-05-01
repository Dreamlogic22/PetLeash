
local _, addon = ...

local module = addon:NewModule("SpecialItems", "AceEvent-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PetLeash")
local AceConfig = LibStub("AceConfig-3.0")

local GetItemCount = C_Item.GetItemCount
local IsEquippedItem = C_Item.IsEquippedItem
local GetItemInfo = C_Item.GetItemInfo
local GetSpellInfo = C_Spell.GetSpellInfo
local GetQuestLogTitle = C_QuestLog.GetInfo

local _G = _G

local ORCISH_ORPHAN_WHISTLE = 18597
local HUMAN_ORPHAN_WHISTLE = 18598
local BLOOD_ELF_ORPHAN_WHISTLE = 31880
local DRAENEI_ORPHAN_WHISTLE = 31881
local WOLVAR_ORPHAN_WHISTLE = 46396
local ORACLE_ORPHAN_WHISTLE = 46397
local KUL_TIRAN_ORPHAN_WHISTLE = 164772
local CASTELESS_ZANDALARI_WHISTLE = 164965
-- local KOBOLD_ORPHAN_WHISTLE = 239689
-- local ARATHI_ORPHAN_WHISTLE = 240196
-- local NERUBIAN_ORPHAN_WHISTLE = 240197
-- local GOBLIN_ORPHAN_WHISTLE = 240198
local KOBOLD_ORPHAN_AURA = 1228497
local ARATHI_ORPHAN_AURA = 1230155
local NERUBIAN_ORPHAN_AURA = 1230183
local GOBLIN_ORPHAN_AURA = 1230185

--
-- Item Entries
--

local SpecialItems = {}

-- Children's Week Orphans

-- Khaz Algar Summon Orphan Auras
-- (because orphan can be out even if whistle is not in bag)
SpecialItems["Khaz Algar Orphans"] = function(item)
    item:RegisterEvent("UNIT_AURA")
    function item:Check()
        return C_UnitAuras.GetPlayerAuraBySpellID(KOBOLD_ORPHAN_AURA) ~= nil
            or C_UnitAuras.GetPlayerAuraBySpellID(ARATHI_ORPHAN_AURA) ~= nil
            or C_UnitAuras.GetPlayerAuraBySpellID(NERUBIAN_ORPHAN_AURA) ~= nil
            or C_UnitAuras.GetPlayerAuraBySpellID(GOBLIN_ORPHAN_AURA) ~= nil
    end
end

-- Legacy Children's Week Orphan whistles
SpecialItems["Children's Week Orphans"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    function item:Check()
        return GetItemCount(ORCISH_ORPHAN_WHISTLE) > 0
        or GetItemCount(HUMAN_ORPHAN_WHISTLE) > 0
        or GetItemCount(BLOOD_ELF_ORPHAN_WHISTLE) > 0
        or GetItemCount(DRAENEI_ORPHAN_WHISTLE) > 0
        or GetItemCount(WOLVAR_ORPHAN_WHISTLE) > 0
        or GetItemCount(ORACLE_ORPHAN_WHISTLE) > 0
        or GetItemCount(KUL_TIRAN_ORPHAN_WHISTLE) > 0
        or GetItemCount(CASTELESS_ZANDALARI_WHISTLE) > 0
        -- or GetItemCount(KOBOLD_ORPHAN_WHISTLE) > 0
        -- or GetItemCount(ARATHI_ORPHAN_WHISTLE) > 0
        -- or GetItemCount(NERUBIAN_ORPHAN_WHISTLE) > 0
        -- or GetItemCount(GOBLIN_ORPHAN_WHISTLE) > 0
    end
end

-- Miscellaneous items

-- Bloodsail Hat (summons Blood Parrot)
SpecialItems["item:12185"] = function(item)
    item:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    item:RegisterEvent("EQUIPMENT_SWAP_FINISHED")
    function item:Check()
        return IsEquippedItem(12185)
    end
end

-- Felhound Whistle (TODO TEST ME)
SpecialItems["item:30803"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    function item:Check()
        return GetItemCount(30803) > 0
    end
end

-- Zeppit's Crystal (Bloody Imp-ossible!)
SpecialItems["item:31815"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    function item:Check()
        return GetItemCount(31815) > 0
    end
end

-- Nether Ray Cage (TODO CHECK ME)
SpecialItems["item:32834"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    function item:Check()
        return GetItemCount(32834) > 0
    end
end

-- Warsong Flare Gun (Alliance Deserter) (TODO TEST ME)
SpecialItems["item:34971"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    function item:Check()
        return GetItemCount(34971) > 0
    end
end

-- Golem Control Unit (TODO TEST ME)
SpecialItems["item:36936"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    function item:Check()
        return GetItemCount(36936) > 0
    end
end

-- Venomhide Hatchling (20day Raptor Mount quest)
SpecialItems["item:46362"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    item:RegisterEvent("ZONE_CHANGED")
    item:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    function item:Check()
        local mapname = GetZoneText()
        return GetItemCount(46362) > 0 and mapname == "Un'Goro Crater" or mapname == "Tanaris"
    end
end

-- Macabre Marionette is now a normal battle pet
-- SpecialItems["item:46831"] = function(item)
--     item:RegisterEvent("BAG_UPDATE")
--     function item:Check()
--         return GetItemCount(46831) > 0
--     end
-- end

-- Winterspring Cub (20day Winterspring Frostsaber quest) 
SpecialItems["item:68646"] = function(item)
    item:RegisterEvent("BAG_UPDATE")
    item:RegisterEvent("ZONE_CHANGED")
    item:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    function item:Check()
        local mapname = GetZoneText()
        return GetItemCount(68646) > 0 and mapname == "Winterspring"
    end
end

-- Brewfest Keg Pony
SpecialItems["item:71137"] = function(item)
    item:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    function item:TimerFinished()
        self.timer = nil
        self:Update(false)
    end

    function item:Check(event, ...)
        if event == "UNIT_SPELLCAST_SUCCEEDED" then
            local unit, name, _, _, spellid = ...
            if unit == "player" and spellid == 100959 then
                self.timer = self:ScheduleTimer("TimerFinished", 180)
                return true
            end
        end
        return self.timer ~= nil
    end
end

-- Orphaned Mammoth Calf delivery quest
SpecialItems["quest:11878"] = function(item)
    item:RegisterQuestEvent()
    function item:Check()
        return self:PlayerHasQuest(11878)
    end
end

-- TODO check me
-- Twilight Flight quest
SpecialItems["quest:26831"] = function(item)
    item:RegisterQuestEvent()
    function item:Check()
        return self:PlayerHasQuest(26831)
    end
end

-- TODO check me
-- Subdue Abyssal Seahorse
SpecialItems["quest:25371"] = function(item)
    item:RegisterQuestEvent()
    function item:Check()
        return self:PlayerHasQuest(25371)
    end
end

-- Various Nagrand Quests
SpecialItems["quest:35396"] = function(item)
    item:RegisterQuestEvent()
    function item:Check()
        return self:PlayerHasQuest(25371)
            or self:PlayerHasQuest(35317)
            or self:PlayerHasQuest(35331)
            or self:PlayerHasQuest(34965)
    end
end

--
--
--

local defaults = {
    profile = {
        enable = true,
        items = {
            ["*"] = true
        }
    },
    global = {
        localeCache = {
            ["*"] = {}
        }
    }
}

local options = {
    type = "group",
    name = L["Special Items"],
    order = 11,
    cmdHidden = true,
    args = {
        explain = {
            type = "description",
            name = L["EXPLAIN_SPECIAL_ITEMS"],
            order = 0,
        },
        enable = {
            type = "toggle",
            name = ENABLE,
            order = 1,
            get = function()
                return module.db.profile.enable
            end,
            set = function(_, val)
                module.db.profile.enable = val
                module:UpdateReadyEnabled()
            end,
        },
        itemsGroup = {
            type = "group",
            name = ITEMS,
            inline = true,
            order = 2,
            get = function(info)
                return module.db.profile.items[info[#info]]
            end,
            set = function(info, val)
                module.db.profile.items[info[#info]] = val
                module:UpdateReadyEnabled()
            end,
            args = {},
        },
    }
}


--
--
--

function module:OnInitialize()
    self.items = {}
    self.event_item_map = {}
    self.event_handler = CreateFrame("FRAME")
    self.event_handler:SetScript("OnEvent", function(f, ev, ...)
        self:HandleEvent(ev, ...)
    end)

    self.ready = addon:GetModule("Ready")
    self.db = addon.db:RegisterNamespace("SpecialItems", defaults)

    self.currentQuests = {}
    self:RegisterEvent("QUEST_LOG_UPDATE", "UpdateQuestList")
    self:RegisterEvent("QUEST_ACCEPTED", "UpdateQuestList")
    self:RegisterEvent("QUEST_FINISHED", "UpdateQuestList")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateQuestList")
    self:UpdateQuestList()

    self:InitWatchers()
    self:UpdateReadyEnabled()
end

function module:SetupOptions(setup)
    AceConfig:RegisterOptionsTable(self.name, options)
    setup(self.name, L["Special Items"])
end

function module:UpdateReadyEnabled()
    for item in pairs(SpecialItems) do
        self.ready:EnableCheck(item, module.db.profile.enable and module.db.profile.items[item])
    end
end

local function config_localize_string(info)
    return module:LocalizeString(info[#info])
end

function module:InitWatchers()
    local args = options.args.itemsGroup.args

    for itemName, func in pairs(SpecialItems) do
        if not args[itemName] then
            args[itemName] = {
                type = "toggle",
                name = config_localize_string,
            }
        end

        local item = self.items[itemName] or self:InitItem(itemName, func)
        item:Update(item:Check("Init"))
    end
end

function module:SI_RegisterEvent(item, event)
    if not self.event_item_map[event] then
        self.event_item_map[event] = {}
        if event ~= "UpdateQuestList" then
            self.event_handler:RegisterEvent(event)
        end
    end

    tinsert(self.event_item_map[event], item)
end

function module:HandleEvent(event, ...)
    if self.event_item_map[event] then
        for _,item in ipairs(self.event_item_map[event]) do
            item:Update(item:Check(event, ...))
        end
    end
end

function module:UpdateQuestList()
    _G.wipe(self.currentQuests)
    for i = 1, (C_QuestLog:GetNumQuestLogEntries() or 0) do
        local quest = C_QuestLog.GetInfo(i)
        if quest then
            self.currentQuests[tonumber(quest.questID)] = true
        end
    end

    self:HandleEvent("UpdateQuestList")
end

function module:LocalizeString(s)
    local cache = self.db.global.localeCache[GetLocale()]
    if cache[s] then
        return cache[s]
    end

    local name = self:AskClientForName(s)
    if name then
        cache[s] = name
        return name
    end

    return s
end

function module:AskClientForName(item)
    if strsub(item, 1,5) == "item:" then
        return (GetItemInfo(item))
    elseif strsub(item, 1,6) == "spell:" then
        return (GetSpellInfo(strsub(item,7)))
    elseif strsub(item, 1,6) == "quest:" then
        local questid = strsub(item,7)
        for i = 1, (C_QuestLog:GetNumQuestLogEntries() or 0) do
            local quest = C_QuestLog.GetInfo(i)
            if quest and quest.questID == questid then
                return quest.title
            end
        end
    end
end

--
-- SpecialItem construction
--

local SpecialItemMeta = {}
SpecialItemMeta.__index = SpecialItemMeta

LibStub("AceTimer-3.0"):Embed(SpecialItemMeta)

function SpecialItemMeta:RegisterEvent(event)
    module:SI_RegisterEvent(self, event)
end

function SpecialItemMeta:RegisterQuestEvent()
    self:RegisterEvent("UpdateQuestList")
end

function SpecialItemMeta:PlayerHasQuest(questID)
    return module.currentQuests[questID]
end

function SpecialItemMeta:Check(...)
    print("WARNING: Check not implemented for "..tostring(self.name))
end

function SpecialItemMeta:Update(value)
    module.ready:SetReady(self.name, not value)
end

function module:InitItem(name, func)
    local item = setmetatable({}, SpecialItemMeta)
    item.name = name
    item:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.items[name] = item
    func(item)
    return item
end
