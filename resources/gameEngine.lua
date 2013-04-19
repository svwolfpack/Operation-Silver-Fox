--[[ 
	Operation Silver Fox
	v0.1
	4/19/2012
	
	Game Engine
--]]

local gameEngine = inheritsFrom(baseClass)

function gameEngine:new()
  local g = gameEngine:create()
  gameEngine:init(g)
  return g
end

function gameEngine:init(g)
  g.actions = {}
  g.blocks = {}
end

return gameEngine
