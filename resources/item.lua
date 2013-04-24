--[[ 
	Operation Silver Fox
	v0.1
	4/10/2012
	
	Item Object
--]]

local item = inheritsFrom(baseClass)

function item:startWiggling()
  tween:to(self.sprite, {rotation = -10, time = .1})
  self.wiggling = tween:to(self.sprite, {rotation = 10, easing = ease.sineInOut, time = .2, mode = "mirror", delay = .1})
end

function item:stopWiggling()
  tween:cancel(self.wiggling)
  tween:to(self.sprite, {rotation = 0, time = .1})
end

function item:updateSpriteLocation()
  self.sprite.x = self.x
  self.sprite.y = self.y
end

function item:updateSpriteLocationWithTween()
  tween:to(self.sprite, {x = self.x, y = self.y, easing = ease.powOut, easingValue = 2.5, time = 0.5})
end

function item:loadSprite() -- This will eventually load the sprite image
  self.sprite = director:createRectangle(self.x, self.y, self.spriteSize, self.spriteSize)
  self.sprite.color = self.color
  self.sprite.alpha = self.alpha
  self.sprite.zOrder = 1
  self.sprite.xAnchor = .5
  self.sprite.yAnchor = .5
end

function item:new(itemData)
  local i = item:create()
  item:init(i, itemData)
  return i
end

function item:init(i, itemData)
  i.x = itemData.x or -100 -- off grid default coordinates
  i.y = itemData.y or -100
  i.xGrid = itemData.xGrid or 0
  i.yGrid = itemData.yGrid or 0
  i.spriteSize = itemData.spriteSize or 0
  i.spriteFileName = itemData.spriteFileName or "default"
  i.itemType =itemData.itemType or ""
  i.id = itemData.id or 0
  i.dockIndex = itemData.dockIndex or 0
  i.color = itemData.color or {0, 0, 0}
  i.alpha = itemData.alpha or 1.0
  i.moving = itemData.moving or false
  i.movable = itemData.movable or false
  i.direction = itemData.direction or ""
  i.sprite = itemData.sprite or {}
  i.engineRunning = itemData.engineRunning or false
  item.loadSprite(i)
end

return item
