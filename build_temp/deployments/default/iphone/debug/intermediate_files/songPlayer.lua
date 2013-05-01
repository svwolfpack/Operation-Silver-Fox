--[[ 
	Operation Silver Fox
	v0.1
	4/29/2012
	
	Song Player
--]]

local songPlayer = {}--= inheritsFrom(baseClass)
local songInstance = inheritsFrom(baseClass)

function songInstance:beat()
  for _, notesAndBeats in pairs(self.song) do
    if notesAndBeats.beat == self.beatCount then
      audio:playSound("sounds/" .. notesAndBeats.note .. ".snd")
    end
  end
  self.beatCount = self.beatCount + 1
end

function songInstance:update(event)
  self.elapsedBeatTime = self.elapsedBeatTime + system.deltaTime
  if self.elapsedBeatTime >= self.secondsPerBeat then
    self:beat()
    self.elapsedBeatTime = 0
  end
  if self.beatCount > self.lastBeat then
    system:removeEventListener("update", self)
    if type(self.onComplete) == "function" then
			self.onComplete(self.target)
    elseif type(self.onComplete) == "table" then
			self.onComplete[onComplete](self.target)
		end
  end
end

function songInstance:new(song, onComplete)
  local s = songInstance:create()
  songInstance:init(s, song, onComplete)
  return s
end

function songInstance:init(s, song, tempo, onComplete)
  s.song = song
  s.onComplete = onComplete
  s.elapsedBeatTime = 0
  s.secondsPerBeat = 60 / tempo
  s.beatCount = 1
  s.lastBeat = 1
  for _, notesAndBeats in pairs(song) do
    if s.lastBeat < notesAndBeats.beat then
      s.lastBeat = notesAndBeats.beat
    end
  end
  system:addEventListener("update", s)
end

function songPlayer:playSong(song, tempo, onComplete)
  return songInstance:new(song, tempo, onComplete)
end

return songPlayer