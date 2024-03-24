-- Loop: Chanson de gesta
local util = require('util')

local Song = {
  -- TODO move to params
  deeds = nil,
  line = 1,
  lines_per_stanza = 4,
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

function Song:adjust()
  if self.stanzas ~= params:get('loop_length') then
    self.stanzas = params:get('loop_length')
    self:_enumerate_deeds()
    if self.performance_stanza > self.stanzas then
      self.performance_stanza = 1
    end
    if self.composition_stanza > self.stanzas then
      self.composition_stanza = 1
    end
  end

  if self.lines_per_stanza ~= params:get('step_depth') then
    self.lines_per_stanza = params:get('step_depth')
    self:_adjust_stanzas()
  end
end

function Song:record(mods)
  local line = util.wrap(#self.deeds[self.composition_stanza] + 1, 1,self.lines_per_stanza)
  self.deeds[self.composition_stanza][line] = mods
  self:_advance_composition()
end

function Song:recall()
  local line = util.wrap(self.line, 1, self.lines_per_stanza)
  local mods = self.deeds[self.performance_stanza][self.line]
  self:_advance_performance()
  return mods
end

function Song:_advance_composition()
  self.composition_stanza = util.wrap(self.composition_stanza + 1, 1, self.stanzas)
end

function Song:_advance_performance()
  if self.line >= #self.deeds[self.performance_stanza] then
    self.line = 1
    self.performance_stanza = util.wrap(self.performance_stanza + 1, 1, self.stanzas)
  else
    self.line = self.line + 1
  end
end

function Song:_adjust_stanzas()
  for i = 1, self.stanzas do
    local lines = {}
    for j = 1, self.lines_per_stanza do
      if self.deeds[i][j] then
        lines[j] = self.deeds[i][j]
      end
    end
    self.deeds[i] = lines
  end
end

function Song:_enumerate_deeds()
  local deeds = {}
  for i = 1, self.stanzas do
    deeds[i] = self.deeds and self.deeds[i] or {{}}
  end
  self.deeds = deeds
end

return Song