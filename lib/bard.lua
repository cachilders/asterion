-- Record each step and action
-- allow playback with cursor
-- allow export
-- allow import
-- this is the sequence

engine.name = 'Asterion'

local Bard = {}

function Bard.intone()
  -- TODO Set note from param
  engine.note(48)
end

function Bard:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Bard:modulate(mods)
  for k, v in pairs(mods) do
    engine[k](v)
  end
end

return Bard