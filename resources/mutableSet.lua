--[[ 
	Operation Silver Fox
	v0.1
	4/22/2012
	
	Mutable Set
--]]

local mutableSet = inheritsFrom(baseClass)

function mutableSet:add(object)
  table.insert(self.objects, object)
end

function mutableSet:remove(object)
  local removeIndex = 0
  for i, v in ipairs(self.objects) do
    if v == object then removeIndex = i end
  end
  table.remove(self.objects, removeIndex)
end

function mutableSet:removeSet(set)
  for k, v in pairs(set.objects) do
    self:remove(v)
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