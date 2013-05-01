--[[ 
	Operation Silver Fox
	v0.1
	4/21/2012
	
	Block Object
--]]

local cItem = dofile("item.lua")
local block = inheritsFrom(cItem)

function block:finishedExploding(tween)
  self:removeFromParent()
end

function block:removeSprite()
  if self.removalAnimation == self.none then
    self.sprite:removeFromParent()
  elseif self.removalAnimation == self.explode then
    self.sprite.zOrder = 10
    local direction = (math.random() - 0.5) * 4
    tween:to(self.sprite, {xScale = 5.0, yScale = 5.0, rotation = 360 * direction, time = 1, alpha = 0.0, onComplete = self.finishedExploding})
  elseif self.removalAnimation == self.shrink then
    self.sprite.zOrder = 10
    local direction = (math.random() - 0.5) * 4
    tween:to(self.sprite, {xScale = 0, yScale = 0, rotation = 360 * direction, time = 1, alpha = 0.0, onComplete = self.finishedExploding})
  end
end

function block:updateSpriteLocationWithTween(time)
  self.tween = tween:to(self.sprite, {x = self.x, y = self.y, easing = ease.powIn, easingValue = 3, time = time})
end

function block:new(blockData)
  local b = block:create()
  block:init(b, blockData)
  return b
end

function block:init(b, blockData)
  blockData.color = {255, 255, 0}
  blockData.alpha = 0.6
  cItem:init(b, blockData)
  b.sprite.strokeWidth = 0
  b.speed = blockData.speed or 0 
  b.isMoving = true
  b.explode = "explode"
  b.shrink = "shrink"
  b.none = "none"
  b.removalAnimation = b.none
end

return block