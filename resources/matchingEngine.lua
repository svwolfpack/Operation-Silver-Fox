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
end

function matchingEngine:new(song)
  local m = matchingEngine:create()
  matchingEngine:init(m, song)
  return m
end

function matchingEngine:init(m, song)
  m.song = song or {}
  m:reset()
  m.beatOffset = 1 -- This is because the first beat will create a block from a spawner, and that block can't trigger anything until beat #2 in the gameEngine's beatCount... However, when we design a song, we want to start at count 1
end

return matchingEngine