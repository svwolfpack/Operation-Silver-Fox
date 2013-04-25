--[[ 
	Operation Silver Fox
	v0.1
	4/21/2012
	
	Block Object
--]]

local cItem = dofile("item.lua")
local block = inheritsFrom(cItem)

function block:updateSpriteLocationWithTween(time)
  tween:to(self.sprite, {x = self.x, y = self.y, easing = ease.expOut, easingValue = 2.5, time = time})
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
  b.speed = blockData.speed or 0  
end

return block