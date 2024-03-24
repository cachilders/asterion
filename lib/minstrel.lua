local Song = include('lib/minstrel/song')

local Minstrel = {
  clock = nil,
  song = nil,
  tempo = nil
}

function Minstrel.intone(note)
  params:set('amp', 0.5)
end

function Minstrel:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Minstrel:init()
  self.song = Song:new()
  self.song:init()
  self.tempo = params:get('clock_tempo')
  self.clock = metro.init(function() self:modulate(self.song:recall()) end, self:_get_time())
  self.intone()
  self.clock:start()
end

function Minstrel:adjust_song()
  self.song:adjust()
end

function Minstrel:modulate(mods)
  self:_check_time()
  if mods then
    for k, v in pairs(mods) do
      params:set(k, v)
    end
  end
end

function Minstrel:observe(mods)
  self:modulate(mods)
  self.song:record(mods)
end

function Minstrel:_check_time()
  if self.tempo ~= params:get('clock_tempo') then
    self.tempo = params:get('clock_tempo')
    self.clock.time = self:_get_time()
  end
end

function Minstrel:_get_time()
  return 60 / self.tempo
end

return Minstrel