--[[ 
	Operation Silver Fox
	v0.1
	4/30/2012
	
	Rest Object
--]]

local cTouchItem = dofile("touchItem.lua")
local cMutableSet = dofile("mutableSet.lua")
local actionRest = inheritsFrom(cTouchItem)

function actionRest:beat()
  self.block.beatCount = self.block.beatCount + 1
  --if self.block.beatCount >= self.duration
end

function actionRest:update(event)
  self.elapsedBeatTime = self.elapsedBeatTime + system.deltaTime
  if self.elapsedBeatTime >= self.secondsPerBeat then
    self:beat()
    self.elapsedBeatTime = 0
  end
end

function actionRest:centerCollisionWithItem(item)
  item.isMoving = false
  self.block = item
  self.block.beatCount = 0
  system:addEventListener("update", self)
  return nil
end

function actionRest:new(itemJSONData)
  local a = actionRest:create()
  actionRest:init(a, itemJSONData)
  return a
end

function actionRest:init(a, itemData)
  itemData.color = {0, 150, 255}
  cTouchItem:init(a, itemData)
  a.duration = itemData.duration or 1
  a.block = {}
end

return actionRest