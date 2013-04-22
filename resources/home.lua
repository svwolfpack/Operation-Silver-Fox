--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	Home Screen

--]]

local scene = director:createScene()

function scene:setUp(event)
  self.titleLabel = director:createLabel(20, director.displayHeight - 50, "Velcome To Blockënspiel!")
  self.playButton = director:createLabel(100, director.displayHeight - 200, "Spiel!")
      
  function self.playButton:touch(event)
    if event.phase == "ended" then
      system:sendEvent("transition", { screen = "level select", transitionType = "slideInR"})
    end
  end  
  self.playButton:addEventListener("touch", self.playButton) -- So, as long as the name of the function entry in the table matches the event name, this will work       
end


function scene:tearDown(event)
  self.titleLabel = self.titleLabel:removeFromParent() -- remove from the scene graph, and set self.label to nil
  self.playButton = self.playButton:removeFromParent()
end

scene:addEventListener({"setUp", "tearDown"}, scene)

return scene -- We must return the scene object!