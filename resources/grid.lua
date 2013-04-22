--[[ 
	Operation Silver Fox
	v0.1
	4/22/2012
	
	Grid
--]]

local grid = inheritsFrom(baseClass)

function grid:coordinatesForGridIndices(xGrid, yGrid)
  xGrid = xGrid - 1
  yGrid = yGrid - 1
  local x = xGrid * (self.spriteSize + 1) + self.gridRect.x + (self.spriteSize / 2)
  local y = yGrid * (self.spriteSize + 1) + self.gridRect.y + (self.spriteSize / 2)
  return x, y
end

function grid:gridIndicesForCoordinates(x, y)
  x = x - self.gridRect.x
  y = y - self.gridRect.y
  local xGrid = math.floor(x / (self.spriteSize + 1)) + 1
  local yGrid = math.floor(y / (self.spriteSize + 1)) + 1
  return xGrid, yGrid
end

function grid:isOnGrid(item)
  if item.x >= self.gridRect.x and 
    item.y >= self.gridRect.y and 
    item.x <= self.gridRect.x + self.gridRect.width and 
    item.y <= self.gridRect.y + self.gridRect.height then
    return true
  else
    return false
  end 
end

function grid:snapToGrid(item)
  item.xGrid, item.yGrid = self:gridIndicesForCoordinates(item.x, item.y)
  item.x, item.y = self:coordinatesForGridIndices(item.xGrid, item.yGrid, self.gridXOrigin, self.gridYOrigin)
  item:updateSpriteLocation()
end

function grid:new(gridWidth, gridHeight, xOffset, yOffset, spriteSize)
  local g = grid:create()
  grid:init(g, gridWidth, gridHeight, xOffset, yOffset, spriteSize)
  return g
end

function grid:init(g, gridWidth, gridHeight, xOffset, yOffset, spriteSize)
 g.spriteSize = spriteSize
 g.gridNode = director:createNode()
  for x = 0, gridWidth - 1 do
    for y = 0, gridHeight -1 do
      local rectangle = director:createRectangle(x * (spriteSize + 1) + xOffset, y * (spriteSize + 1) + yOffset, spriteSize, spriteSize) -- slightly shrink things so they don't overlap
      if (x%2 == 0 and y%2 == 0) or (x%2 ~= 0 and y%2 ~=0) then -- setup a checkerboard pattern
        rectangle.color = {200, 200, 200}
      end
      g.gridNode:addChild(rectangle)
    end
  end
  g.gridRect = {x = xOffset, y = yOffset, width = gridWidth * spriteSize + gridWidth, height = gridHeight * spriteSize + gridHeight}
end

return grid