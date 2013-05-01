--[[ 
	Operation Silver Fox
	v0.1
	4/30/2012
	
	Portal Object
--]]

local cItem = dofile("item.lua")
local actionPortal = inheritsFrom(cItem)

function actionPortal:centerCollisionWithItem(item)
  item.x = self.sibling.x
  item.y = self.sibling.y
  item:updateSpriteLocation()
  return nil
end

function actionPortal:addCircleToSprite() -- will be deprecated eventually
  self.sprite:addChild(director:createCircle(self.spriteSize / 2 - 10, self.spriteSize / 2 - 10, 10))
end

function actionPortal:new(itemJSONData)
  local a = actionPortal:create()
  actionPortal:init(a, itemJSONData)
  return a
end

function actionPortal:init(a, itemData)
  itemData.color = {200, 0, 200}
  cItem:init(a, itemData)
  a.portalID = itemData.portalID
  a.siblingID = itemData.siblingID
  a.sibling = {}
  a:addCircleToSprite()
end

return actionPortal