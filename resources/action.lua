--[[ 
	Operation Silver Fox
	v0.1
	4/22/2012
	
	Action Object
--]]

local cItem = dofile("item.lua")
local action = inheritsFrom(cItem)

function action:new()
  local a = action:create()
  action:init(a)
  return a
end

function action:init(a)
  cItem:init(a)
  dbg.printTable(a)
 
end

return action