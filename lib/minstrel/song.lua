-- Loop: Chanson de gesta
local util = require('util')

local Song = {
  -- TODO move to params
  deeds = nil,
  line = 1,
  composition_stanza = 1,
  performance_stanza = 1,
  stanzas = 16
}

function Song:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Song:init()
  self:_enumerate_deeds()
end

function Song:record(mods)
  table.insert(self.deeds[self.composition_stanza], mods)
  self:_advance_composition()
end

function Song:recall()
  local mods = self.deeds[self.performance_stanza][self.line]
  self:_advance_performance()
  return mods
end

function Song:_advance_composition()
  self.composition_stanza = util.wrap(self.composition_stanza + 1, 1, self.stanzas)
end

function Song:_advance_performance()
  if self.line == #self.deeds[self.performance_stanza] then
    self.line = 1
    self.performance_stanza = util.wrap(self.performance_stanza + 1, 1, self.stanzas)
  else
    self.line = self.line + 1
  end
end

function Song:_enumerate_deeds()
  local deeds = {}
  for i = 1, self.stanzas do
    deeds[i] = {{}}
  end
  self.deeds = deeds
end

return Song