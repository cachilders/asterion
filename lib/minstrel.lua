local Song = include('lib/minstrel/song')

engine.name = 'Asterion'

local Minstrel = {
  song = nil,
  time = nil
}

function Minstrel.intone(note)
  -- TODO Set note from param
  engine.amp(0.5)
  engine.note(note or 36)
end

function Minstrel:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Minstrel:init()
  local bpm = 60 / params:get('clock_tempo')
  self.song = Song:new()
  self.song:init()
  self.time = metro.init(function() self:modulate(self.song:recall()) end, bpm)
  self.intone()
  self.time:start()
end

function Minstrel:modulate(mods)
  for k, v in pairs(mods) do
    engine[k](v)
  end
end

function Minstrel:observe(mods)
  self:modulate(mods)
  self.song:record(mods)
end

return Minstrel