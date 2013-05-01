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
  self.levelData.scene = self
  self.levelData.spriteSize = spriteSize
  self.levelData.gridXOffset = centeringOffset(self.levelData.gridWidth * self.levelData.spriteSize + self.levelData.gridWidth, director.displayWidth)
  self.levelData.gridYOffset = centeringOffset(self.levelData.gridHeight * self.levelData.spriteSize + self.levelData.gridHeight, director.displayHeight) 
end

function scene:renderUIElements()
  self.titleLabel = director:createLabel(20, director.displayHeight - 50, "Level: ".. self.levelData.levelName)    
  self.notesInLevelLabel = director:createLabel(20, director.displayHeight - 70, "")
  for _, notesAndBeats in ipairs(self.levelData.song) do
      self.notesInLevelLabel.text = self.notesInLevelLabel.text .. notesAndBeats.note .. " "
  end
  self.backButton =  director:createLabel(10, 10, "zurück")
  function self.backButton:touch(event)
    if event.phase == "ended" then
      system:sendEvent("transition", {screen = "level select", transitionType = "slideInL"})
    end
    return true
  end
  self.backButton:addEventListener("touch", self.backButton)
  
  self.startStopButton =  director:createLabel(215, 10)
  self.startStopButton.startText = "starten"
  self.startStopButton.stopText = "stoppen"
  self.startStopButton.text = self.startStopButton.startText
  local scene = self
  function self.startStopButton:touch(event)
    if event.phase == "ended" then
      if self.text == self.startText then
        self.text = self.stopText
        scene.gameEngine:start()
      else
        self.text = self.startText
        scene.gameEngine:stop()
      end
    end
    return true
  end
  self.startStopButton:addEventListener("touch", self.startStopButton) 
end

function scene:resetUI()
    self.startStopButton.text = self.startStopButton.startText
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
  self.notesInLevelLabel = self.notesInLevelLabel:removeFromParent()
  self.backButton = self.backButton:removeFromParent()
  self.startStopButton = self.startStopButton:removeFromParent()
  self.gameEngine = self.gameEngine:unload()
end

scene:addEventListener({"setUp", "tearDown"}, scene)
return scene 