--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	Home Screen

--]]

local scene = director:createScene()



function scene:setUp(event)
       local playButtonTouched = function(event)
		if event.phase == "began" then
			system:sendEvent("transition", { screen = "level select", transitionType = "slideInR"})
		end
end  
   
    dbg.print("scene1:setUp")
    	
     self.titleLabel = director:createLabel(20, director.displayHeight - 50, "Velcome To Blockënspiel!")
     self.playButton = director:createLabel(100, director.displayHeight - 200, "Spiel!")
      
  
      
    self.playButton:addEventListener("touch", playButtonTouched)
        
end


function scene:tearDown(event)
    dbg.print("scene1:tearDown")
    self.titleLabel = self.titleLabel:removeFromParent() -- remove from the scene graph, and set self.label to nil
    self.playButton = self.playButton:removeFromParent()
end




scene:addEventListener({"setUp", "tearDown"}, scene)
return scene -- We must return the scene object!