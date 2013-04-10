--[[ 
	Operation Silver Fox
	v0.1
	4/9/2012
	
	Main Level Screen

--]]

local scene = director:createScene()
local cItem = dofile("item.lua") -- c prefix for class


 local rectSize = 35 -- we may not need this once we're doing sprites...

local function loadLevelJSON(levelFileName)
  
  local path = system:getFilePath("resources", "levels/")
    
    file = io.open(path .. levelFileName, "r")
    dbg.assert(file, "Failed to open file for reading")
    encoded = file:read("*a")
    file:close()

    return json.decode(encoded)
  
end

local function centeringOffset(objectSize, containerSize)
  return ((containerSize / 2) - (objectSize / 2))
end


local function drawGrid(gridWidth, gridHeight) 
  
  local xOffset = centeringOffset(gridWidth * rectSize + gridWidth, director.displayWidth)
  local yOffset = centeringOffset(gridHeight * rectSize + gridHeight, director.displayHeight) 
  local gridNode = director:createNode()
  
  
  for x = 0, gridWidth - 1 do
    for y = 0, gridHeight -1 do
      local rectangle = director:createRectangle(x * (rectSize + 1) + xOffset, y * (rectSize + 1) + yOffset, rectSize, rectSize) -- slightly shrink things so they don't overlap
      
      if (x%2 == 0 and y%2 == 0) or (x%2 ~= 0 and y%2 ~=0) then -- setup a checkerboard pattern
        rectangle.color = {200, 200, 200}
      end
      
      
      --[[
      function rectangle:touch(event)
        if event.phase == "began" then
            self.isVisible = not self.isVisible
        end  
      end
      rectangle:addEventListener("touch", rectangle)
      --]]
      
      gridNode:addChild(rectangle)
    end
  end
 
 return gridNode, xOffset, yOffset
end

local function loadBlocksAndActions(items)
  
  local itemsTable = {}
  
  for i, v in ipairs(items) do
  
    local tempItem = cItem:new()
    tempItem.itemType = v.itemType
    tempItem.xGrid = v.xGrid
    tempItem.yGrid = v.yGrid
    
    
    -- This may be replaced later on if we're not using hard-coded items...
    if tempItem.itemType == "spawner" then
      tempItem.color = {255, 0, 0}
      tempItem.movable = false
    elseif tempItem.itemType == "note" then
       tempItem.color = {0, 255, 0}
    elseif tempItem.itemType == "directionArrow" then
     tempItem.color = {0, 0, 255}
    end
    
    itemsTable[i] = tempItem
  
  end
  
  
  return itemsTable
  
end

local function coordinateLocationsForGrid(xGrid, yGrid, gridXOrigin, gridYOrigin)
  
  xGrid = xGrid - 1
  yGrid = yGrid - 1
  
  local xLocation  = xGrid * (rectSize + 1) + gridXOrigin
  local yLocation  = yGrid * (rectSize + 1) + gridYOrigin
  
  print ("coordinates: " .. xLocation .. " " .. yLocation)
  
  return xLocation, yLocation
end

local function coordinateLocationForDockIndex(dockIndex)
  
  return dockIndex * (rectSize + 7) + 10, 40
  
end




local function renderItems(items, gridXOrigin, gridYOrigin)
 print "rendering items"
 local dockIndex = 0
 
 for i, v in ipairs(items) do
  
  
  if v.xGrid == 0 or v.yGrid == 0 then -- place item in dock
     
     v.xLocation, v.yLocation = coordinateLocationForDockIndex(dockIndex)
     dockIndex = dockIndex + 1
     
     v.sprite = director:createRectangle(v.xLocation, v.yLocation, rectSize, rectSize)
  else
    
    v.xLocation, v.yLocation = coordinateLocationsForGrid(v.xGrid, v.yGrid, gridXOrigin, gridYOrigin)
    
      v.sprite = director:createRectangle(v.xLocation, v.yLocation, rectSize, rectSize)
  end
    
  v.sprite.color = v.color
  v.sprite.zOrder = 1
  end
end

function scene:setUp(event)
    --self.levelFileName = self.levelFileName or "" -- let's just pretend we get good data, we're fucked otherwise
    
    print ("level file name: " .. self.levelFileName)
    
    self.levelData = loadLevelJSON(self.levelFileName)
    
    self.titleLabel = director:createLabel(20, director.displayHeight - 50, "Play Zis: ".. self.levelData.levelName)
      
      self.backButton =  director:createLabel(10, 10, "zurück")
      function self.backButton:touch(event)
        if event.phase == "began" then
          system:sendEvent("transition", { screen = "level select", transitionType = "slideInL"})
       end
     end
      self.backButton:addEventListener("touch", self.backButton)
    
    self.grid, self.gridXOrigin, self.gridYOrigin = drawGrid(self.levelData.gridWidth, self.levelData.gridHeight)
    
    --self.grid.isVisible = false
    
    self.items = loadBlocksAndActions(self.levelData.blocksAndActions) -- Turns JSON spec for level into a list of full-on item objects (basically fleshing out the shit we didn't want to store in JSON)
        
    renderItems(self.items, self.gridXOrigin, self.gridYOrigin) -- draws items to the screen

end


function scene:tearDown(event)
    
    self.titleLabel = self.titleLabel:removeFromParent() -- remove from the scene graph, and set self.label to nil
    self.backButton = self.backButton:removeFromParent()
    
    self.grid = self.grid:removeFromParent()
    
  end

scene:addEventListener({"setUp", "tearDown"}, scene)




return scene -- We must return the scene object!