--[[ 
	Operation Silver Fox
	v0.1
	4/24/2012
	
	Touch Item Object
--]]

local cItem = dofile("item.lua")
local touchItem = inheritsFrom(cItem)

function touchItem:startWiggling()
  tween:to(self.sprite, {rotation = -10, time = .1})
  self.wiggling = tween:to(self.sprite, {rotation = 10, easing = ease.sineInOut, time = .2, mode = "mirror", delay = .1})
end

function touchItem:stopWiggling()
  tween:cancel(self.wiggling)
  tween:to(self.sprite, {rotation = 0, time = .1})
end

function touchItem:setupTouchForItem()
  function self:touch(event)
     if self.movable == true and self.engineRunning == false then
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
        self.gameEngine:layoutItem(self)
        self.sprite.zOrder = 1
      end
      return true
    end
    return false
  end
  self.sprite:addEventListener("touch", self) 
end

function touchItem:new(itemData)
  local i = item:create()
  item:init(i, itemData)
  return i
end

function touchItem:init(i, itemData)
  cItem:init(i, itemData)
  i.gameEngine = itemData.gameEngine or {}
  touchItem.setupTouchForItem(i)
  i.movable = itemData.movable ~= "no"
  i.wiggling = {}
end

return touchItem