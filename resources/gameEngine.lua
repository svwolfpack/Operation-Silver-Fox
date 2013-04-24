--[[ 
	Operation Silver Fox
	v0.1
	4/22/2012
	
	Game Engine
--]]

local gameEngine = inheritsFrom(baseClass)

local cGrid = dofile("grid.lua")
local cItem = dofile("item.lua") 
local cBlock = dofile("block.lua")
local cDock = dofile("dock.lua") 
local cMutableSet = dofile("mutableSet.lua")

function gameEngine:loadActions()
  self.items = {}
  for i, v in ipairs(self.rawActions) do
    local item = cItem:new()
    item.gameEngine = self
    item.itemType = v.itemType
    item.xGrid = v.xGrid
    item.yGrid = v.yGrid
    item.spriteSize = self.spriteSize
    item.id = i
    -- This may be replaced later on if we're not using hard-coded items...
    if item.itemType == "spawner" then
      item.color = {255, 0, 0}
      item.movable = false
      item.direction = v.direction
      item.repeating = v.repeating
      item.frequency = v.frequency
      item.speed = v.speed
      item.blocksSpawned = 0
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

function gameEngine:itemIsAloneOnGrid(item)
  for i, v in ipairs(self.items) do
    if v ~= item and v.xGrid == item.xGrid and v.yGrid == item.yGrid then
      return false
    end
  end
  return true
end

function gameEngine:layoutItem(item)
  if self.grid:centerIsOnGrid(item) then
    self.grid:snapToGrid(item)
    if self:itemIsAloneOnGrid(item) then
      self.dock:removeFromDock(item)
    else
      self.dock:addToDock(item)
    end
 else
   self.dock:addToDock(item) 
 end
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
end

function gameEngine:blockSpeed(spawner)
  return spawner.speed * (self.spriteSize / self.secondsPerBeat) 
end

function gameEngine:shouldSpawn(spawner, beat)
  if (spawner.repeating == 0 or spawner.blocksSpawned < spawner.repeating) and (beat - 1) % spawner.frequency == 0 then 
    return true
  else
    return false
  end
end

function gameEngine:shouldRemoveBlock(block)
  return not self.grid:anyPartIsOnGrid(block)
end

function gameEngine:destroyAllBlocks()
   for i, v in ipairs(self.blocks.objects) do
    v.sprite = v.sprite:removeFromParent()
  end
  return cMutableSet:new()
end

function gameEngine:moveBlock(block, elapsedTime)
  
  if block.speed ~= 0 then
    if block.direction == "up" then
      block.y = block.y + (block.speed * elapsedTime)
    elseif block.direction == "down" then
      block.y = block.y - (block.speed * elapsedTime)
    elseif block.direction == "left" then
      block.x = block.x - (block.speed * elapsedTime)
    elseif block.direction == "right" then
      block.x = block.x + (block.speed * elapsedTime)
    end
    block:updateSpriteLocation()
  end
end

function gameEngine:update(event)
  if self.engineRunning == true then

    local blocksToRemove = cMutableSet:new()
    for k, v in pairs(self.blocks.objects) do
      self:moveBlock(v, system.deltaTime)
      if self:shouldRemoveBlock(v) == true then
        v.sprite = v.sprite:removeFromParent()
        blocksToRemove:add(v)
      end
    end  
    self.blocks:removeSet(blocksToRemove)
  end
end

function gameEngine:spawnBlock(spawner)
  local newBlock = cBlock:new(self.spriteSize)
       newBlock.x = spawner.x 
       newBlock.y = spawner.y
       newBlock.direction = spawner.direction
       newBlock.speed = self:blockSpeed(spawner)
       newBlock:updateSpriteLocation()
       spawner.blocksSpawned = spawner.blocksSpawned + 1
       self.blocks:add(newBlock)  
end


function gameEngine:snapBlocksToGrid()
  for k, v in pairs(self.blocks.objects) do
    self.grid:snapToGrid(v)
  end
end


function gameEngine:timer(event)
 for k, v in pairs(self.items) do
    if v.itemType == "spawner" and self:shouldSpawn(v, event.doneIterations) then
       self:spawnBlock(v)
    end    
  end
 
  
  self:snapBlocksToGrid()
  
  --for k, v in pairs(self.blocks.objects) do
  --v:updateSpriteLocation()
  --end
  
  
  
  
end
  
  


function gameEngine:setRunning(state)
  for k, v in pairs(self.items) do
    v.engineRunning = state  
  end
  self.engineRunning = state
end

function gameEngine:start()
  
  self:setRunning(true)
  self.beatTimer = system:addTimer(self, self.secondsPerBeat)
  
  
  
  
  
end

function gameEngine:stop()
  --system:removeEventListener("update", self)
  self.beatTimer:cancel()
  self.beatTimer = {}
  self.blocks = self:destroyAllBlocks()
  self:setRunning(false)
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
  g.rawActions = levelData.actions
  g.items = {}
  g.blocks = cMutableSet:new()
  g.tempo = levelData.tempo
  g.secondsPerBeat = 60 / g.tempo
  g.beatTimer = {}
  g.engineRunning = false
  system:addEventListener("update", g)
  
  g:setupGrid()
  g:setupDock()
  g:loadActions()
  g:renderItems()
end

function gameEngine:unload()
  self.grid.gridNode = self.grid.gridNode:removeFromParent()
  self.grid = nil
  if next(self.beatTimer) ~= nil then
    self.beatTimer:cancel()
  end
      
  for i, v in ipairs(self.items) do
    v.sprite = v.sprite:removeFromParent()
  end
  self.items = nil
 
  self:destroyAllBlocks()
  self.blocks = nil
  
  return nil
end

return gameEngine