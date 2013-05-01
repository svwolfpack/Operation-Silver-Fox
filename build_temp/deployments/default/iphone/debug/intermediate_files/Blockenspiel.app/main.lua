--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	main.lua
--]]

local homeScreen = dofile("home.lua")
local levelSelect = dofile("levelSelect.lua")
local levelScreen = dofile("levelScreen.lua")

local transitionHandler = function(event)
	event.transitionType = event.transitionType or "slideInL"
	
	if event.screen == "level select" then
		director:moveToScene(levelSelect, {transitionType=event.transitionType, transitionTime=0.5})
	elseif event.screen == "home" then
		director:moveToScene(homeScreen, {transitionType=event.transitionType, transitionTime=0.5})
  elseif event.screen == "main level screen" then
    levelScreen.levelFileName = event.levelFileName
    director:moveToScene(levelScreen, {transitionType=event.transitionType, transitionTime=0.5})
	end
end

system:addEventListener("transition", transitionHandler)

director:moveToScene(homeScreen) 