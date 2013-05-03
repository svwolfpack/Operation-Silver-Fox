--[[ 
	Operation Silver Fox
	v0.1
	5/3/2012
	
	Turret Object
--]]

local cTouchItem = dofile("touchItem.lua")
local actionTurret = inheritsFrom(cTouchItem)

function actionTurret:rotationComplete(target)
  if self.rotation >= 360 then self.rotation = 360 - self.rotation end -- This is called on self.sprite, so self == sprite instead of self == actionTurret
end

function actionTurret:setDirection(withTween)
  local patternStep = self.pattern[self.patternIndex]
  self.direction = patternStep.direction
  local rotation = 360
  if self.direction == "up" then
    rotation = 0
  elseif self.direction == "down" then
    rotation = 180
  elseif self.direction == "left" then
    rotation = 270
  elseif self.direction == "right" then
    rotation = 90
  end
  if withTween then
    if rotation < self.sprite.rotation then rotation = rotation + 360 end
    tween:to(self.sprite, {rotation = rotation, time = 0.3, onComplete = self.rotationComplete})
  else
    self.sprite.rotation = rotation
  end

end

function actionTurret:centerCollisionWithItem(item)
  item.direction = self.direction
  self.patternIndex = self.patternIndex + 1
  if self.patternIndex > self.patternSize then self.patternIndex = 1 end
  self:setDirection(true)
  return nil
end

function actionTurret:addDotsToSprite() -- Eventually we won't need this
  local circle = director:createCircle(0, 0, 4)
  circle.x = self.spriteSize / 2 - 4
  circle.y = self.spriteSize - 8    
  self.sprite:addChild(circle) 
end

function actionTurret:reset()
  self.patternIndex = 1
  self:setDirection(false)
end

function actionTurret:new(itemData)
  local a = actionTurret:create()
  actionTurret:init(a, itemData)
  return a
end

function actionTurret:init(a, itemData)
  itemData.color = {255, 0, 100}
  cTouchItem:init(a, itemData)
  a.pattern = itemData.pattern
  a.patternSize = #a.pattern
  a.patternIndex = 1
  actionTurret.addDotsToSprite(a)
  actionTurret.setDirection(a, false)
end

return actionTurret