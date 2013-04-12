--[[ 
	Operation Silver Fox
	v0.1
	4/11/2012
	
	Scene Touch Handler

--]]


local cSceneTouchHandler = inheritsFrom(baseClass)

function cSceneTouchHandler:touch(event)
  
  -- We don't care if touches begin, because touchdown is handled by the items themselves
  if event.phase == "moved" and self.itemToTrack ~= nil then -- we need to insure that something registered itself as touched, and the user isn't just swiping random shit
    self.touchID = event.id
    self.currentlyTouched = true
    self.itemToTrack.sprite.x = event.x + self.itemToTrack.sprite.xOffset
    self.itemToTrack.sprite.y = event.y + self.itemToTrack.sprite.yOffset 
  elseif event.phase == "ended" and event.id == self.touchID then -- we only care if the touch ended on the item we were tracking
    self.currentlyTouched = false
   self.itemsToTrack = nil
   self.touchID = 0
  end
 
  return true --We should be the lowest level of touch, but just in case we're not, we'll let biznatches know that we've got this shit handled
end

function cSceneTouchHandler:itemTouched(item)
  if self.currentlyTouched == false then
    self.itemToTrack = item
  end
end


function cSceneTouchHandler:new()
  local o = cSceneTouchHandler:create()
  cSceneTouchHandler:init(o)
  return o
end

function cSceneTouchHandler:init(o)
  o.currentlyTouched = false
  o.itemToTrack = nil
  o.touchID = 0
end

return cSceneTouchHandler
