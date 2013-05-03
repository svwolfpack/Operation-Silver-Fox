--[[ 
	Operation Silver Fox
	v0.1
	4/26/2012
	
	Block Mutable Set
--]]

local cMutableSet = dofile("mutableSet.lua")
local blockMutableSet = inheritsFrom(cMutableSet)

function blockMutableSet:remove(block)
  block:removeSprite()
  cMutableSet.remove(self, block)
end

function blockMutableSet:new()
  local b = blockMutableSet:create()
  blockMutableSet:init(b)
  return b
end

function blockMutableSet:init(b)
  cMutableSet:init(b)
end

return blockMutableSet