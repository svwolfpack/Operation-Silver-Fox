--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	main.lua
--]]

local homeScreen = dofile("home.lua")
local levelSelect = dofile("levelSelect.lua")

--[[
local touch = function(event)
    if event.phase == "began" then
        if director:getCurrentScene() == scene1 then
            director:moveToScene(scene2, {transitionType="slideInL", transitionTime=0.5})
        else
            director:moveToScene(scene1, {transitionType="slideInL", transitionTime=0.5})
        end
    end
end

--]]

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. v)
    end
  end
end

local transitionHandler = function(event)
	
	event.transitionType = event.transitionType or "slideInL"
	
	print "event:"
	tprint(event, 0)
	print "------"
	
	if event.screen == "level select" then
		director:moveToScene(levelSelect, {transitionType=event.transitionType, transitionTime=0.5})
	elseif event.screen == "home" then
		director:moveToScene(homeScreen, {transitionType=event.transitionType, transitionTime=0.5})
	
	end
	
end

system:addEventListener("transition", transitionHandler)

--system:addEventListener("touch", touch)
director:moveToScene(homeScreen) -- start with instantaneous change to scene1
