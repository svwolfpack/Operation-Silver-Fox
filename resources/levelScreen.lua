--[[ 
	Operation Silver Fox
	v0.1
	4/9/2012
	
	Main Level Screen
--]]

local scene = director:createScene()
local cGameEngine = dofile("gameEngine.lua")

local spriteSize = 35

local function centeringOffset(objectSize, containerSize)
  return ((containerSize / 2) - (objectSize / 2))
end

function scene:loadLevelJSON()
  local path = system:getFilePath("resources", "levels/" .. self.levelFileName)
  file = io.open(path, "r")
  dbg.assert(file, "Failed to open file for reading")
  encoded = file:read("*a")
  file:close()
  self.levelData = json.decode(encoded)
  self.levelData.spriteSize = spriteSize
  self.levelData.gridXOffset = centeringOffset(self.levelData.gridWidth * self.levelData.spriteSize + self.levelData.gridWidth, director.displayWidth)
  self.levelData.gridYOffset = centeringOffset(self.levelData.gridHeight * self.levelData.spriteSize + self.levelData.gridHeight, director.displayHeight) 
end

function scene:renderUIElements()
  self.titleLabel = director:createLabel(20, director.displayHeight - 50, "Play Zis: ".. self.levelData.levelName)    
  self.backButton =  director:createLabel(10, 10, "zurück")
  function self.backButton:touch(event)
    if event.phase == "began" then
      system:sendEvent("transition", {screen = "level select", transitionType = "slideInL"})
    end
    return true
  end
  self.backButton:addEventListener("touch", self.backButton)
end

function scene:setupGameEngine()
  self.gameEngine = cGameEngine:new(self.levelData)
end

function scene:setUp(event)
  self:loadLevelJSON()
  self:renderUIElements()
  self:setupGameEngine()
end

function scene:tearDown(event)  
  self.titleLabel = self.titleLabel:removeFromParent() -- remove from the scene graph, and set self.label to nil
  self.backButton = self.backButton:removeFromParent()
  self.gameEngine:unload()
end

scene:addEventListener({"setUp", "tearDown"}, scene)
return scene 