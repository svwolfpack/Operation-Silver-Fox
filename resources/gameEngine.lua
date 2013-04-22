--[[ 
	Operation Silver Fox
	v0.1
	4/22/2012
	
	Game Engine
--]]

local gameEngine = inheritsFrom(baseClass)

local cGrid = dofile("grid.lua")
local cItem = dofile("item.lua") 
local cDock = dofile("dock.lua") 

function gameEngine:loadBlocksAndActions()
  self.items = {}
  for i, v in ipairs(self.blocksAndActions) do
    local item = cItem:new()
    item.itemType = v.itemType
    item.xGrid = v.xGrid
    item.yGrid = v.yGrid
    item.spriteSize = self.spriteSize
    -- This may be replaced later on if we're not using hard-coded items...
    if item.itemType == "spawner" then
      item.color = {255, 0, 0}
      item.movable = false
      item.direction = v.direction
    elseif item.itemType == "note" then
      item.color = {0, 255, 0}
    elseif item.itemType == "directionArrow" then
      item.color = {0, 0, 255}
      item.direction = v.direction
    end
    self.items[i] = item
  end
end

function gameEngine:setupGrid()  
  self.grid = cGrid:new(self.gridWidth, self.gridHeight, self.gridXOffset, self.gridYOffset, self.spriteSize)
end

function gameEngine:setupDock()
  self.dock = cDock:new({x = 10, y = 40, director.displayWidth - 20, self.spriteSize}, self.spriteSize)   
end

function gameEngine:layoutItem(item)
 if self.grid:isOnGrid(item) then
   self.grid:snapToGrid(item)
   self.dock:removeFromDock(item)
 else
   self.dock:addToDock(item) 
 end
end
 
 function gameEngine:layoutItemEvent(event)
  self:layoutItem(event.item)
 end

function gameEngine:renderItems()
  for i, v in ipairs(self.items) do  
    if v.xGrid ~= 0 and v.yGrid ~= 0 then -- Calculate starting coordinates if not in dock  
      v.x, v.y = self.grid:coordinatesForGridIndices(v.xGrid, v.yGrid)
    end
    v:initSprite()
    self:layoutItem(v)
  end
  self.dock.tweening = true
  system:addEventListener("layoutItemEvent", self)
end

function gameEngine:new(levelData)
  local g = gameEngine:create()
  gameEngine:init(g, levelData)
  return g
end

function gameEngine:init(g, levelData)
  g.gridWidth = levelData.gridWidth
  g.gridHeight = levelData.gridHeight
  g.gridXOffset = levelData.gridXOffset
  g.gridYOffset = levelData.gridYOffset
  g.spriteSize = levelData.spriteSize
  g.blocksAndActions = levelData.blocksAndActions
  
  g:setupGrid()
  g:setupDock()
  g:loadBlocksAndActions()
  g:renderItems()
end

function gameEngine:unload()
  self.grid.gridNode = self.grid.gridNode:removeFromParent()
  self.grid = nil
  
  system:removeEventListener("layoutItemEvent")  
  for i, v in ipairs(self.items) do
    v.sprite = v.sprite:removeFromParent()
  end
  self.items = nil
end

return gameEngine