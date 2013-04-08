--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	main.lua
--]]

local scene1 = dofile("home.lua")
local scene2 = dofile("levelSelect.lua")

local touch = function(event)
    if event.phase == "began" then
        if director:getCurrentScene() == scene1 then
            director:moveToScene(scene2, {transitionType="slideInL", transitionTime=0.5})
        else
            director:moveToScene(scene1, {transitionType="slideInL", transitionTime=0.5})
        end
    end
end
system:addEventListener("touch", touch)
director:moveToScene(scene1) -- start with instantaneous change to scene1
