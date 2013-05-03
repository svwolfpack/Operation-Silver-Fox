--[[ 
	Operation Silver Fox
	v0.1
	4/30/2012
	
	Rest Object
--]]

local cTouchItem = dofile("touchItem.lua")
local actionRest = inheritsFrom(cTouchItem)

function actionRest:releaseBlock()
    self.block.isMoving = true
    self.block = nil
end

function actionRest:centerCollisionWithItem(item)
  if item ~= self.block then
    self.block = item
    self.block.isMoving = false
  else
    self:releaseBlock()
  end
  return nil
end

function actionRest:new(itemData)
  local a = actionRest:create()
  actionRest:init(a, itemData)
  return a
end

function actionRest:init(a, itemData)
  itemData.color = {0, 150, 255}
  cTouchItem:init(a, itemData)
  a.secondsPerBeat = itemData.secondsPerBeat or 1
  a.beatCount = 0
  a.block = nil
end

return actionRest