--[[ 
	Operation Silver Fox
	v0.1
	4/24/2012
	
	Direction Arrow Object
--]]

local cTouchItem = dofile("touchItem.lua")
local actionDirection = inheritsFrom(cTouchItem)

function actionDirection:addDotsToSprite() -- Eventually we won't need this
  if self.direction then
    local circle = director:createCircle(0, 0, 4)
    circle.strokeWidth = 0
    if self.direction == "up" then
      circle.x = self.spriteSize / 2 - 4
      circle.y = self.spriteSize - 8
    elseif self.direction == "down" then
      circle.x = self.spriteSize / 2 - 4
      circle.y = 0
    elseif self.direction == "left" then
       circle.x = 0
       circle.y = self.spriteSize / 2 - 4
    elseif self.direction == "right" then
      circle.x = self.spriteSize - 8
      circle.y = self.spriteSize / 2 - 4
    end
    self.sprite:addChild(circle) 
  end
end

function actionDirection:new(itemData)
  local a = actionDirection:create()
  actionDirection:init(a, itemData)
  return a
end

function actionDirection:init(a, itemData)
  cTouchItem:init(a, itemData)
  actionDirection.addDotsToSprite(a)
 
end

return actionDirection