--[[ 
	Operation Silver Fox
	v0.1
	4/30/2012
	
	Rest Object
--]]

local cTouchItem = dofile("touchItem.lua")
local actionRest = inheritsFrom(cTouchItem)

function actionRest:beat()
  if self.beatCount == 1 then
    self.block.isMoving = true
    self.block = nil
    self.beatCount = 0
 else
    self.beatCount = self.beatCount + 1
  end
 
  --self.block = nil
  --if self.block.beatCount >= self.duration
end

function actionRest:update(event)
  self.elapsedBeatTime = self.elapsedBeatTime + system.deltaTime
  if self.elapsedBeatTime >= self.secondsPerBeat then
    --self:releaseBlock()
    system:removeEventListener("update", self)
  end
end

function actionRest:centerCollisionWithItem(item)
  self.block = item
  self.block.isMoving = false
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
  a.secondsPerBeat = itemData.secondsPerBeat or 1
  a.beatCount = 0
  a.elapsedBeatTime = 0
  a.block = nil

end

return actionRest