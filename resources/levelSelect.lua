--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	Level Select Screen

--]]


local scene = director:createScene()

local loadLevelList = function()
  print "fake loading levels..."  
  return {{name = "Eins", fileName = "level1.json"}, {name = "Zwei", fileName = "level1.json"}, {name = "Drei", fileName = "level1.json"}, {name = "Vier", fileName = "level1.json"}} 
end

function scene:setUp(event)
  self.titleLabel = director:createLabel(50, director.displayHeight - 50, "Select Ein Level!")
  self.backButton =  director:createLabel(10, 10, "zurück")
  
  function self.backButton:touch(event)
    if event.phase == "ended" then
      system:sendEvent("transition", { screen = "home", transitionType = "slideInL"})
    end
  end
     
  self.backButton:addEventListener("touch", self.backButton)
  self.levelButtons = {}
      
  for index,level in ipairs(loadLevelList()) do --indexed pair iterator, so it returns the values in the table/array in order
    local tempButton = director:createLabel(100, director.displayHeight - 100 - (index * 30), level.name)
    function tempButton:touch(event)
      if event.phase == "ended" then
        system:sendEvent("transition", { screen = "main level screen", transitionType = "slideInR", levelFileName = level.fileName})
      end
    end  
    tempButton:addEventListener("touch", tempButton)
     
    self.levelButtons[index] = tempButton 
  end      
end


function scene:tearDown(event)
    self.titleLabel = self.titleLabel:removeFromParent()
    self.backButton = self.backButton:removeFromParent()
    self.levelButtons = nil
end


scene:addEventListener({"setUp", "tearDown"}, scene)

return scene