--[[ 
	Operation Silver Fox
	v0.1
	4/12/2012
	
	Dock Handling/Layout
--]]

local dock = inheritsFrom(baseClass)

function dock:layoutDock()
  for i, v in ipairs(self.items) do
    v.x = (i - 1) * (self.spriteSize + self.spacingOffset) + self.dockRect.x + self.spriteOffset
    v.y = self.dockRect.y + self.spriteOffset
    if self.tweening then
      v:updateSpriteLocationWithTween()
    else
      v:updateSpriteLocation()
    end
  end
end

function dock:addToDock(item)
  if item.dockIndex == 0 then -- check to make sure we're not adding items twice 
    item.xGrid = 0
    item.yGrid = 0
    self.currentIndex = self.currentIndex + 1
    item.dockIndex = self.currentIndex
    self.items[self.currentIndex] = item
  end
  self:layoutDock() -- Even if no item was added, we may need to reposition things (i.e. dragged around on the dock without dropping on the grid)
end

function dock:removeFromDock(item)
  if item.dockIndex ~= 0 then -- check to make sure the item actually was in the dock
    local newDock = {}
    local newDockIndex = 0
    item.dockIndex = 0 -- This flags the item for removal
    for i, v in ipairs(self.items) do
      if v.dockIndex ~= 0 then
        newDockIndex = newDockIndex + 1
        v.dockIndex = newDockIndex
        newDock[newDockIndex] = v
      end
    end
    self.items = newDock 
    self.currentIndex = newDockIndex
  end
  self:layoutDock()
end

function dock:new(dockRect, spriteSize)
  local d = dock:create()
  dock:init(d, dockRect, spriteSize)
  return d
end

function dock:init(d, dockRect, spriteSize)
  d.items = {}
  d.dockRect = dockRect
  d.spriteSize = spriteSize
  d.spriteOffset = spriteSize / 2
  d.spacingOffset = 7
  d.currentIndex = 0
  d.tweening = false
end

return dock