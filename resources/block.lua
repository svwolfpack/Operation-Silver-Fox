--[[ 
	Operation Silver Fox
	v0.1
	4/21/2012
	
	Block Object
--]]

local cItem = dofile("item.lua")
local block = inheritsFrom(cItem)

function block:initSprite()
  self:loadSprite()
  self.sprite.zOrder = 2
  self.sprite.xAnchor = .5
  self.sprite.yAnchor = .5
 
  self.sprite.alpha = self.alpha
end

function block:new(spriteSize)
  local b = block:create()
  block:init(b, spriteSize)
  return b
end

function block:init(b, spriteSize)
  cItem:init(b)
  b.spriteSize = spriteSize
  b.color = {255, 255, 0}
  b.alpha = 0.6
  b:initSprite()
  b.speed = 0
  
end

return block