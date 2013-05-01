--[[ 
	Operation Silver Fox
	v0.1
	4/30/2012
	
	Hole Object
--]]

local cItem = dofile("item.lua")
local actionHole = inheritsFrom(cItem)

function actionHole:centerCollisionWithItem(item)
  item.removalAnimation = item.shrink
  return item
end

function actionHole:new(itemJSONData)
  local a = actionHole:create()
  actionHole:init(a, itemJSONData)
  return a
end

function actionHole:init(a, itemData)
  itemData.color = {0, 0, 0}
  cItem:init(a, itemData)
end

return actionHole