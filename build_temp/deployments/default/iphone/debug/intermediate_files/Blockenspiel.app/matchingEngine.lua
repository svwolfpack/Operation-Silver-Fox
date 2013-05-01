--[[ 
	Operation Silver Fox
	v0.1
	4/29/2012
	
	Matching Engine
--]]

local matchingEngine = inheritsFrom(baseClass)
local cMutableSet = dofile("mutableSet.lua")

function matchingEngine:verifyNote(actionNote, beat) 
  -- First we loop through all the notes, if we find a match, we flag it for removal 
  if self.beatOffset == -1 then -- beat offset not set yet
    self.beatOffset = beat - 1 -- We want the first beat to be 1, see next line...
    self.lastBeatNumber = self.lastBeatNumber + self.beatOffset
  end
  beat = beat - self.beatOffset
 
  local beatAndNoteToRemove = nil
  for _, beatAndNote in pairs(self.songWorkingCopy.objects) do
    if beatAndNote.beat == beat and beatAndNote.note == actionNote.note then
      beatAndNoteToRemove = beatAndNote
    end
  end
  
  -- If we have a note, then remove it, otherwise, there was no match, so we flag the song as not a match
  if beatAndNoteToRemove then
    self.songWorkingCopy:remove(beatAndNoteToRemove)
  else
    self.allNotesHaveMatched = false
  end
  
  -- If there are no more objects left in the song, then the song is complete
  if #self.songWorkingCopy.objects == 0 then
    self.songIsComplete = true
  end    
end

function matchingEngine:reset()
  self.songWorkingCopy = cMutableSet:new()
  self.lastBeatNumber = 1
  for _, noteAndBeat in pairs(self.song) do
      if noteAndBeat.beat > self.lastBeatNumber then
        self.lastBeatNumber = noteAndBeat.beat
      end
      self.songWorkingCopy:add(noteAndBeat)
  end
  self.allNotesHaveMatched = true
  self.songIsComplete = false
  self.beatOffset = -1 --This allows us to match the song regardless of what beat from the game engine the first note is on, i.e. if the gameEngine beat == 7, and that's the first note played, then we can match that with level beat 1
end

function matchingEngine:new(song)
  local m = matchingEngine:create()
  matchingEngine:init(m, song)
  return m
end

function matchingEngine:init(m, song)
  m.song = song or {}
  m:reset()
end

return matchingEngine