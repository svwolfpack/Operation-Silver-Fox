--[[ 
	Operation Silver Fox
	v0.1
	4/24/2012
	
	Spawner Object
--]]

local cItem = dofile("item.lua")
local actionSpawner = inheritsFrom(cItem)

function actionSpawner:centerCollisionWithItem(item)
  item.removalAnimation = item.explode
  return item
end

function actionSpawner:addDotsToSprite() -- Eventually we won't need this
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

function actionSpawner:new(itemData)
  local a = actionSpawner:create()
  actionSpawner:init(a, itemData)
  return a
end

function actionSpawner:init(a, itemData)
  itemData.color = {255, 0, 0}
  itemData.movable = false
      
  cItem:init(a, itemData)
  
  a.repeating = itemData.repeating or 0
  a.frequency = itemData.frequency or 0
  a.speed = itemData.speed or 0
  a.blocksSpawned = 0

  actionSpawner.addDotsToSprite(a)
 
end

return actionSpawner