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
  if self.removalAnimation == "none" then
    self.sprite:removeFromParent()
  elseif self.removalAnimation == "explode" then
    self.sprite.zOrder = 10
    local direction = 1
    if math.random() > 0.5 then direction = -1 end
    tween:to(self.sprite, {xScale = 5.0, yScale = 5.0, rotation = 360 * direction, time = 1, alpha = 0.0, onComplete = self.finishedExploding})
  end
end

function block:updateSpriteLocationWithTween(time)
  tween:to(self.sprite, {x = self.x, y = self.y, easing = ease.expIn, easingValue = 2.5, time = time})
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
  b.removalAnimation = "none"
end

return block