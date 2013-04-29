--[[ 
	Operation Silver Fox
	v0.1
	4/24/2012
	
	Note Object
--]]

local cTouchItem = dofile("touchItem.lua")
local actionNote = inheritsFrom(cTouchItem)

function actionNote:centerCollisionWithItem(item)
  audio:playSound(self.fileName)
  self.gameEngine.matchingEngine:verifyNote(self, self.gameEngine.beatCount)
end

function actionNote:new(itemJSONData)
  local a = actionNote:create()
  actionNote:init(a, itemJSONData)
  return a
end

function actionNote:init(a, itemData)
  itemData.color = {0, 255, 0}
  cTouchItem:init(a, itemData)
  a.note = itemData.note
  local noteLabel = director:createLabel(0, 0, a.note)
  noteLabel.color = {0, 0, 0}
  a.sprite:addChild(noteLabel)
  a.fileName = "sounds/" .. a.note .. ".snd"
  audio:loadSound(a.fileName)
end

return actionNote