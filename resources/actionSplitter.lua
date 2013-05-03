--[[ 
	Operation Silver Fox
	v0.1
	4/30/2012
	
	Splitter Object
--]]

local cTouchItem = dofile("touchItem.lua")
local cBlock = dofile("block.lua")
local actionSplitter = inheritsFrom(cTouchItem)



function actionSplitter:centerCollisionWithItem(item)
 
 dbg.printTable(item)
 
  local splitDirection
  if item.direction == "up" or item.direction == "down" then
    item.direction = "left"
    splitDirection = "right"
  else
    item.direction = "up"
    splitDirection  = "down"
  end
  
  
  local blockData = {}
  blockData.itemType = "block"
  blockData.spriteSize = self.spriteSize
  blockData.x = self.x 
  blockData.y = self.y
  blockData.direction = splitDirection
  print ("split: " .. splitDirection)
  local newBlock = cBlock:new(blockData)
  return nil, newBlock
end

function actionSplitter:new(itemData)
  local a = actionSplitter:create()
  actionSplitter:init(a, itemData)
  return a
end

function actionSplitter:init(a, itemData)
  itemData.color = {0, 255, 150}
  cTouchItem:init(a, itemData)
  a.secondsPerBeat = itemData.secondsPerBeat or 1
  a.beatCount = 0
  a.blocksSpawned = 0
  a.block = nil
end

return actionSplitter