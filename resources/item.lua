--[[ 
	Operation Silver Fox
	v0.1
	4/10/2012
	
	Item Object

--]]

local item = inheritsFrom(baseClass)

function item:updateSpriteLocation()
  self.sprite.x = self.x
  self.sprite.y = self.y
end

function item:new()
  local i = item:create()
  item:init(i)
  return i
end

function item:init(i)
  i.x = 0
  i.y = 0
  i.xGrid = 0
  i.yGrid = 0
  i.spriteFileName = "default"
  i.itemType = ""
  i.itemID = 0
  i.dockIndex = 0
  i.color = {0, 0, 0}
  i.movable = true
  i.sprite = {}
end

return item
