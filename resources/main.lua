--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	main.lua
--]]

local homeScreen = dofile("home.lua")
local levelSelect = dofile("levelSelect.lua")
local mainLevelScreen = dofile("mainLevelScreen.lua")

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


local transitionHandler = function(event)
	
	event.transitionType = event.transitionType or "slideInL"
	
	print "event:"
	dbg.printTable(event)
	print "------"
	
	if event.screen == "level select" then
		director:moveToScene(levelSelect, {transitionType=event.transitionType, transitionTime=0.5})
  
	elseif event.screen == "home" then
		director:moveToScene(homeScreen, {transitionType=event.transitionType, transitionTime=0.5})
	
  elseif event.screen == "main level screen" then
    
      mainLevelScreen.levelFileName = event.levelFileName
      director:moveToScene(mainLevelScreen, {transitionType=event.transitionType, transitionTime=0.5})
    
  
	end
	
end

system:addEventListener("transition", transitionHandler)

--system:addEventListener("touch", touch)
director:moveToScene(homeScreen) -- start with instantaneous change to scene1
