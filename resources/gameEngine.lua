--[[ 
	Operation Silver Fox
	v0.1
	4/22/2012
	
	Game Engine
--]]

local gameEngine = inheritsFrom(baseClass)

local cGrid = dofile("grid.lua")
local cActionDirection = dofile("actionDirection.lua")
local cActionNote = dofile("actionNote.lua")
local cActionHole = dofile("actionHole.lua")
local cActionRest = dofile("actionRest.lua")
local cActionPortal = dofile("actionPortal.lua")
local cActionSpawner = dofile("actionSpawner.lua")
local cActionSplitter = dofile("actionSplitter.lua")
local cActionTurret = dofile("actionTurret.lua")
local cBlock = dofile("block.lua")
local cDock = dofile("dock.lua") 
local cMutableSet = dofile("mutableSet.lua")
local cBlockMutableSet = dofile("blockMutableSet.lua")
local cMatchingEngine = dofile("matchingEngine.lua")
local cSongPlayer = dofile("songPlayer.lua")



function gameEngine:itemIsAloneOnGrid(item)
  for _, v in ipairs(self.items) do
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
 
function gameEngine:renderActions()
  for _, item in pairs(self.items) do  
    if item.xGrid ~= 0 and item.yGrid ~= 0 then -- Calculate starting coordinates if not in dock  
      item.x, item.y = self.grid:coordinatesForGridIndices(item.xGrid, item.yGrid)
    end
    self:layoutItem(item)
  end
  self.dock.tweening = true
end

function gameEngine:blockSpeed(spawner)
  return spawner.speed * (self.spriteSize / self.secondsPerBeat) 
end

function gameEngine:removeAllBlocks()
   for _, v in pairs(self.blocks.objects) do
    v.sprite = v.sprite:removeFromParent()
  end
  return cBlockMutableSet:new()
end

function gameEngine:tweenBlock(block)
  if block.direction == "up" then
    block.y = block.y + block.spriteSize
  elseif block.direction == "down" then
    block.y = block.y - block.spriteSize
  elseif block.direction == "left" then
    block.x = block.x - block.spriteSize
  elseif block.direction == "right" then
    block.x = block.x + block.spriteSize
  end
  block:updateSpriteLocationWithTween(self.secondsPerBeat)
end

function gameEngine:snapBlocksToGrid()
  for _, block in pairs(self.blocks.objects) do
    if block.tween then
      tween:cancel(block.tween)
    end
    self.grid:snapToGrid(block)
  end
end

function gameEngine:spawnBlockFromSpawner(spawner)
 spawner.blocksSpawned = spawner.blocksSpawned + 1 
 local blockData = {}
  blockData.itemType = "block"
  blockData.spriteSize = self.spriteSize
  blockData.x = spawner.x 
  blockData.y = spawner.y
  blockData.speed = self:blockSpeed(spawner)
  blockData.direction = spawner.direction
  local newBlock = cBlock:new(blockData)
  self.blocks:add(newBlock) 
end

function gameEngine:shouldSpawn(spawner)
  if (spawner.repeating == 0 or spawner.blocksSpawned < spawner.repeating) and (self.beatCount - 1) % spawner.frequency == 0 then 
    return true
  else
    return false
  end
end

function gameEngine:spawnBlocksThatShouldBeSpawned()
  for _, item in pairs(self.items) do
    if item.itemType == "spawner" and self:shouldSpawn(item) then
       self:spawnBlockFromSpawner(item)
    end    
  end
end

function gameEngine:moveBlocksThatShouldBeMoved()
  for _, block in pairs(self.blocks.objects) do
    if block.isMoving then
      self:tweenBlock(block)
    end
  end
end

function gameEngine:itemsDidCenterCollide(item1, item2)
  if item1.xGrid == item2.xGrid and item1.yGrid == item2.yGrid then
    return true
  else
    return false
  end
end

function gameEngine:indexForItem(item)
  if item.xGrid < 1 or 
    item.yGrid < 1 or 
    item.xGrid > self.gridWidth or 
    item.yGrid > self.gridHeight then 
      return self.offGridIndex
    else  
      return item.xGrid + ((item.yGrid - 1) * self.gridWidth)
    end
end

function gameEngine:updateActionsByLocationTable()
  -- index in the table is calculated from xgrid and ygrid: xGrid + (yGrid * gridWidth)
  self.actionsByLocation = {}
  for _, v in pairs(self.items) do
    if self.grid:centerIsOnGrid(v) then
      self.actionsByLocation[self:indexForItem(v)] = v
    end
  end
end

function gameEngine:updateBlocksByLocationTable()
  self.blocksByLocation = {}
  for _, v in pairs(self.blocks.objects) do
    local index = self:indexForItem(v)
    if not self.blocksByLocation[index] then
      self.blocksByLocation[index] = cMutableSet:new()
    end
    self.blocksByLocation[index]:add(v)
  end
end

function gameEngine:resolveBlockCollisions()
  self:updateBlocksByLocationTable()
  local blocksToRemove = cMutableSet:new()
  for index, blocksInLocation in pairs(self.blocksByLocation) do
    if #blocksInLocation.objects > 1 or index == self.offGridIndex then
      for _, block in pairs(blocksInLocation.objects) do
        if index ~= self.offGridIndex then
          block.removalAnimation = block.explode
        else
          block.removalAnimation = block.shrink
        end
        blocksToRemove:add(block)
      end
    end
  end  
  self.blocks:removeSet(blocksToRemove)
end

function gameEngine:resolveActionCollisions()
  local blocksToRemoveSet = cMutableSet:new()
  local blocksToSpawnSet = cMutableSet:new()
  for _, block in pairs(self.blocks.objects) do
    local action = self.actionsByLocation[self:indexForItem(block)] or nil
    if action and self:itemsDidCenterCollide(action, block) then
      local blockToRemove, blocksToSpawn = action:centerCollisionWithItem(block) -- We don't want to be removing blocks as we're looping through them, so we need to just flag 'em and remove them at the end
      if blockToRemove then blocksToRemoveSet:add(blockToRemove) end
      if blocksToSpawn then 
        for _, block in pairs(blocksToSpawn) do
          blocksToSpawnSet:add(block) 
         end
      end
    end
  end
  self.blocks:removeSet(blocksToRemoveSet)
  self.blocks:addSet(blocksToSpawnSet)
end

function gameEngine:displayEnding()
 self:stop()
    
    self.scene:resetUI()
 
 if self.victory then 
    print "you win!"
  else
    print "you lose!"
  end
end


function gameEngine:checkForSongMatch()
  local shouldContinue = true
  if self.matchingEngine.allNotesHaveMatched then
    if self.matchingEngine.songIsComplete then
      shouldContinue = false
      self.victory = true
    end
  else
    shouldContinue = false
  end
  return shouldContinue
end

function gameEngine:songLengthNotExceeded()
  return self.beatCount <= self.matchingEngine.lastBeatNumber
end

function gameEngine:resolveCollisions()
  self:resolveBlockCollisions()
  self:resolveActionCollisions()
end

function gameEngine:beat()
  self:snapBlocksToGrid()
  self:resolveCollisions()
  if self:checkForSongMatch() and self:songLengthNotExceeded() then
    self:spawnBlocksThatShouldBeSpawned()
    self:moveBlocksThatShouldBeMoved()
    self.beatCount = self.beatCount + 1
  else
    self:displayEnding()
  end  
end

function gameEngine:resetItems()
  for _, item in pairs(self.items) do
    if item.itemType == "spawner" then 
      item.blocksSpawned = 0 
    elseif item.itemType == "turret" then
      item:reset()
    end
  end
end

function gameEngine:update(event)
  if self.engineRunning == true then
    self.elapsedBeatTime = self.elapsedBeatTime + system.deltaTime
    if self.elapsedBeatTime >= self.secondsPerBeat then
      self:beat()
      self.elapsedBeatTime = self.elapsedBeatTime - self.secondsPerBeat 
   end
  end
end
   
function gameEngine:setRunning(state)
  for _, v in pairs(self.items) do
    v.engineRunning = state  
  end
  self.engineRunning = state
end

function gameEngine:start()
  self.matchingEngine:reset()
  self.victory = false
  self.beatCount = 1
  self.elapsedBeatTime = 0
  self:updateActionsByLocationTable()
  self:beat() -- Initial beat, otherwise update won't catch it until the 2nd beat
  self:setRunning(true)
end

function gameEngine:stop()
  self:setRunning(false)
  self.blocks = self:removeAllBlocks()
  self:resetItems()  
end

function gameEngine:setupPortals()
  local portals = {}
  for _, item in pairs(self.items) do
    if item.itemType == "portal" then
      portals[item.portalID] = item
    end 
  end
  for _, portal in pairs(portals) do
    portal.sibling = portals[portal.siblingID]
  end
end

function gameEngine:loadActions()
  self.items = {}
  for i, itemJSONData in ipairs(self.rawActions) do
    itemJSONData.spriteSize = self.spriteSize
    itemJSONData.gameEngine = self
    itemJSONData.id = i
    local item 
    if itemJSONData.itemType == "spawner" then
      item = cActionSpawner:new(itemJSONData)
    elseif itemJSONData.itemType == "note" then
      item = cActionNote:new(itemJSONData)
    elseif itemJSONData.itemType == "directionArrow" then
      item = cActionDirection:new(itemJSONData)
    elseif itemJSONData.itemType == "hole" then
      item = cActionHole:new(itemJSONData)
    elseif itemJSONData.itemType == "turret" then
      item = cActionTurret:new(itemJSONData)
    elseif itemJSONData.itemType == "portal" then
      item = cActionPortal:new(itemJSONData)
    elseif itemJSONData.itemType == "splitter" then
      item = cActionSplitter:new(itemJSONData)
    elseif itemJSONData.itemType == "rest" then
      item = cActionRest:new(itemJSONData)
    end
    table.insert(self.items, item)
  end
  self:setupPortals()
end

function gameEngine:setupGrid()  
  self.grid = cGrid:new(self.gridWidth, self.gridHeight, self.gridXOffset, self.gridYOffset, self.spriteSize)
end

function gameEngine:setupDock()
  self.dock = cDock:new({x = 10, y = 40, director.displayWidth - 20, self.spriteSize}, self.spriteSize)   
end

function gameEngine:new(levelData)
  local g = gameEngine:create()
  gameEngine:init(g, levelData)
  return g
end

function gameEngine:init(g, levelData)
  g.scene = levelData.scene
  g.gridWidth = levelData.gridWidth
  g.gridHeight = levelData.gridHeight
  g.gridXOffset = levelData.gridXOffset
  g.gridYOffset = levelData.gridYOffset
  g.spriteSize = levelData.spriteSize
  g.rawActions = levelData.actions
  g.offGridIndex = g.gridWidth * g.gridHeight + 1
  g.matchingEngine = cMatchingEngine:new(levelData.song)
  g.items = {}
  g.actionsByLocation = {}
  g.blocks = cBlockMutableSet:new()
  g.blocksToSpawn = cMutableSet:new()
  g.blocksByLocation = {}
  g.tempo = levelData.tempo
  g.secondsPerBeat = 60 / g.tempo
  g.elapsedBeatTime = 0
  g.beatCount = 1
  g.engineRunning = false
  g.victory = false
  system:addEventListener("update", g)
  
  g:setupGrid()
  g:setupDock()
  g:loadActions()
  g:renderActions()
  cSongPlayer:playSong(levelData.song, g.tempo, {})
end

function gameEngine:unload()
  self.grid.gridNode = self.grid.gridNode:removeFromParent()
  self.grid = nil
        
  for _, v in ipairs(self.items) do
    v.sprite = v.sprite:removeFromParent()
  end
  self.items = nil
 
  self:removeAllBlocks()
  self.blocks = nil
  
  return nil
end

return gameEngine