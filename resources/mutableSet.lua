--[[ 
	Operation Silver Fox
	v0.1
	4/22/2012
	
	Mutable Set
--]]

local mutableSet = inheritsFrom(baseClass)

function mutableSet:add(objectToAdd)
  table.insert(self.objects, objectToAdd)
end

function mutableSet:remove(objectToRemove)
  local removeIndex = 0
  for i, object in ipairs(self.objects) do
    if object == objectToRemove then removeIndex = i end
  end
  table.remove(self.objects, removeIndex)
end

function mutableSet:addSet(set)
  for _, object in pairs(set.objects) do
    self:add(object)
  end
end

function mutableSet:removeSet(set)
  for _, object in pairs(set.objects) do
    self:remove(object)
  end
end

function mutableSet:new()
  local s = mutableSet:create()
  mutableSet:init(s)
  return s
end

function mutableSet:init(s)
  s.objects = {}
end

return mutableSet