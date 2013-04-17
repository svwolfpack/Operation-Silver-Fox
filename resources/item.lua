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

function item:initSprite()
  self.sprite = director:createRectangle(self.x, self.y, self.spriteSize, self.spriteSize)
  
  self.sprite.color = self.color
  self.sprite.zOrder = 1
  self.sprite.xAnchor = .5
  self.sprite.yAnchor = .5
  
  function self:touch(event)
     if event.phase == "began" and system:getFocus() == nil then
        system:setFocus(self.sprite)
        self:startWiggling()
        self.sprite.xOffset = self.sprite.x - event.x
        self.sprite.yOffset = self.sprite.y - event.y
        self.sprite.zOrder = 2
      elseif event.phase == "moved" then
        if system:getFocus() == self.sprite then
          self.sprite.x = event.x + self.sprite.xOffset
          self.sprite.y = event.y + self.sprite.yOffset 
        end
      elseif event.phase == "ended" then
        self:stopWiggling()
        system:setFocus(nil)
        self.x = self.sprite.x
        self.y = self.sprite.y
        system:sendEvent("layoutItemEvent", {item = self})
        self.sprite.zOrder = 1
      end
      return true
    end
    self.sprite:addEventListener("touch", self) 
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
  i.spriteSize = 0
  i.spriteFileName = "default"
  i.itemType = ""
  i.itemID = 0
  i.dockIndex = 0
  i.color = {0, 0, 0}
  i.direction = ""
  i.movable = true
  i.wiggling = {}
  i.sprite = {}
end

return item
