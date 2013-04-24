--[[ 
	Operation Silver Fox
	v0.1
	4/24/2012
	
	Note Object
--]]

local cTouchItem = dofile("touchItem.lua")
local actionNote = inheritsFrom(cTouchItem)

function actionNote:new(itemJSONData)
  local a = actionNote:create()
  actionNote:init(a, itemJSONData)
  return a
end

function actionNote:init(a, itemJSONData)
  cTouchItem:init(a, itemJSONData)
  dbg.printTable(a)
 
end

return actionNote