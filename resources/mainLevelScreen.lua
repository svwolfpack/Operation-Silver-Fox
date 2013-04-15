--[[ 
	Operation Silver Fox
	v0.1
	4/9/2012
	
	Main Level Screen
--]]

local scene = director:createScene()
local cItem = dofile("item.lua") 
local cDock = dofile("dock.lua")

local rectSize = 35
local offGrid = -100

local function centeringOffset(objectSize, containerSize)
  return ((containerSize / 2) - (objectSize / 2))
end

function scene:loadLevelJSON()
  local path = system:getFilePath("resources", "levels/" .. self.levelFileName)
  file = io.open(path, "r")
  dbg.assert(file, "Failed to open file for reading")
  encoded = file:read("*a")
  file:close()
  self.levelData = json.decode(encoded)
end

function scene:renderUIElements()
  self.titleLabel = director:createLabel(20, director.displayHeight - 50, "Play Zis: ".. self.levelData.levelName)    
  self.backButton =  director:createLabel(10, 10, "zurück")
  function self.backButton:touch(event)
    if event.phase == "began" then
      system:sendEvent("transition", {screen = "level select", transitionType = "slideInL"})
    end
    return true
  end
  self.backButton:addEventListener("touch", self.backButton)
end

function scene:renderGrid()  
  local gridWidth = self.levelData.gridWidth -- These are just shorthand convenience vars for readability
  local gridHeight = self.levelData.gridHeight
  local xOffset = centeringOffset(gridWidth * rectSize + gridWidth, director.displayWidth)
  local yOffset = centeringOffset(gridHeight * rectSize + gridHeight, director.displayHeight) 
  self.gridNode = director:createNode()
  for x = 0, gridWidth - 1 do
    for y = 0, gridHeight -1 do
      local rectangle = director:createRectangle(x * (rectSize + 1) + xOffset, y * (rectSize + 1) + yOffset, rectSize, rectSize) -- slightly shrink things so they don't overlap
      if (x%2 == 0 and y%2 == 0) or (x%2 ~= 0 and y%2 ~=0) then -- setup a checkerboard pattern
        rectangle.color = {200, 200, 200}
      end
      self.gridNode:addChild(rectangle)
    end
  end
  self.gridRect = {x = xOffset, y = yOffset, width = gridWidth * rectSize + gridWidth, height = gridHeight * rectSize + gridHeight}
end

function scene:setupDock()
  self.dock = cDock:new({x = 10, y = 40, director.displayWidth - 20, rectSize}, rectSize)   
end

function scene:loadBlocksAndActions()
  self.items = {}
  for i, v in ipairs(self.levelData.blocksAndActions) do
    local tempItem = cItem:new()
    tempItem.itemType = v.itemType
    tempItem.xGrid = v.xGrid
    tempItem.yGrid = v.yGrid
    tempItem.rectSize = rectSize
    -- This may be replaced later on if we're not using hard-coded items...
    if tempItem.itemType == "spawner" then
      tempItem.color = {255, 0, 0}
      tempItem.movable = false
    elseif tempItem.itemType == "note" then
       tempItem.color = {0, 255, 0}
    elseif tempItem.itemType == "directionArrow" then
     tempItem.color = {0, 0, 255}
    end
    self.items[i] = tempItem
  end
end

function scene:coordinatesForGridIndices(xGrid, yGrid)
  xGrid = xGrid - 1
  yGrid = yGrid - 1
  local x = xGrid * (rectSize + 1) + self.gridRect.x + (rectSize / 2)
  local y = yGrid * (rectSize + 1) + self.gridRect.y + (rectSize / 2)
  return x, y
end

function scene:gridIndicesForCoordinates(x, y)
  x = x - self.gridRect.x
  y = y - self.gridRect.y
  local xGrid = math.floor(x / (rectSize + 1)) + 1
  local yGrid = math.floor(y / (rectSize + 1)) + 1
  return xGrid, yGrid
end
 
function scene:isOnGrid(item)
  if item.x >= self.gridRect.x and 
    item.y >= self.gridRect.y and 
    item.x <= self.gridRect.x + self.gridRect.width and 
    item.y <= self.gridRect.y + self.gridRect.height then
    return true
  else
    return false
  end 
end

function scene:snapToGrid(item)
  item.xGrid, item.yGrid = self:gridIndicesForCoordinates(item.x, item.y)
  item.x, item.y = self:coordinatesForGridIndices(item.xGrid, item.yGrid, self.gridXOrigin, self.gridYOrigin)
  item:updateSpriteLocation()
end
 
function scene:layoutItem(item)
 if self:isOnGrid(item) then
   self:snapToGrid(item)
   self.dock:removeFromDock(item)
 else
   self.dock:addToDock(item) 
 end
end
 
function scene:renderItems()
  for i, v in ipairs(self.items) do  
    if v.xGrid == 0 or v.yGrid == 0 then -- place item in dock   
      v.x, v.y = offGrid, offGrid -- item is not on grid
    else
      v.x, v.y = self:coordinatesForGridIndices(v.xGrid, v.yGrid, self.gridXOrigin, self.gridYOrigin)
    end
    v.sprite = director:createRectangle(offGrid, offGrid, rectSize, rectSize)
    v.sprite.color = v.color
    v.sprite.zOrder = 1
    v.sprite.xAnchor = .5
    v.sprite.yAnchor = .5
    
    function v:touch(event)
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
        scene:layoutItem(self)
        self.sprite.zOrder = 1
      end
      return true
    end
    v.sprite:addEventListener("touch", v) 
    scene:layoutItem(v)
  end
  self.dock.tweening = true
end

function scene:setUp(event)
  self:loadLevelJSON()
  self:renderUIElements()
  self:renderGrid()
  self:setupDock()
  self:loadBlocksAndActions() -- Turns JSON level description into full-on item objects (basically fleshing out the shit we didn't want to store in JSON)
  self:renderItems() 
end

function scene:tearDown(event)  
  self.titleLabel = self.titleLabel:removeFromParent() -- remove from the scene graph, and set self.label to nil
  self.backButton = self.backButton:removeFromParent()
  self.grid = self.grid:removeFromParent()
    
  for i, v in ipairs(self.items) do
    v.sprite = v.sprite:removeFromParent()
  end
  self.items = nil
end

scene:addEventListener({"setUp", "tearDown"}, scene)
return scene 