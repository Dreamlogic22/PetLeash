--[[--------------------------------------------------------------------

    Common utilities provided to the parent addon.

--------------------------------------------------------------------]]

---@class addonTbl
local T = select(2, ...)

---@return boolean
function T.IsEditModeActive()
	return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
end

function T.Print(...)
    print(strjoin("", T.Title, ": ", ...))
end