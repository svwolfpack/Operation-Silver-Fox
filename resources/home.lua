--[[ 
	Operation Silver Fox
	v0.1
	4/8/2012
	
	Home Screen

--]]

local scene = director:createScene()
function scene:setUp(event)
    dbg.print("scene1:setUp")
        self.label = director:createLabel(0, 0, "Scene 1")
end
function scene:tearDown(event)
    dbg.print("scene1:tearDown")
    self.label = self.label:removeFromParent() -- remove from the scene graph, and set self.label to nil
end
scene:addEventListener({"setUp", "tearDown"}, scene)
return scene -- We must return the scene object!