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

function item:new()
  local i = item:create()
  item:init(i)
  return i
end

function item:init(i)
  i.x = 0
  i.y = 0
  i.xGrid = 0
  i.yGrid = 0
  i.rectSize = 0
  i.spriteFileName = "default"
  i.itemType = ""
  i.itemID = 0
  i.dockIndex = 0
  i.color = {0, 0, 0}
  i.movable = true
  i.wiggling = {}
  i.sprite = {}
end

return item
