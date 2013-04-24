--[[ 
	Operation Silver Fox
	v0.1
	4/21/2012
	
	Block Object
--]]

local cItem = dofile("item.lua")
local block = inheritsFrom(cItem)

function block:new(blockData)
  local b = block:create()
  block:init(b, blockData)
  return b
end

function block:init(b, blockData)
  cItem:init(b, blockData)
  b.speed = blockData.speed or 0
end

return block