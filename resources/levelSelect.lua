--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	Level Select Screen

--]]


local scene = director:createScene()



function scene:setUp(event)
   local levelPressed = function(event)
		print (event)
		if event.phase == "began" then
			--system:sendEvent("transition", { screen = "home"})
		end
end  

local backPressed = function(event)
		print (event)
		if event.phase == "began" then
			system:sendEvent("transition", { screen = "home", type = "slideInL"})
		end
end 
   
   dbg.print("levelSelect:setUp")
     self.titleLabel = director:createLabel(50, director.displayHeight - 50, "Select Ein Level!")
     self.levelButton = director:createLabel(100, director.displayHeight - 200, "Eins")
     self.backButton =  director:createLabel(10, 100, "zurück")
      
      
      
    self.levelButton:addEventListener("touch", levelPressed)
    self.backButton:addEventListener("touch", backPressed)
        
end


function scene:tearDown(event)
    dbg.print("levelSelect:tearDown")
    self.titleLabel = self.titleLabel:removeFromParent() -- remove from the scene graph, and set self.label to nil
    self.levelButton = self.levelButton:removeFromParent()
    self.backButton = self.backButton:removeFromParent()
end


scene:addEventListener({"setUp", "tearDown"}, scene)

return scene -- We must return the scene object!