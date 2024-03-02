-- Record each step and action
-- allow playback with cursor
-- allow export
-- allow import
-- this is the sequence

local Bard = {}

function Bard:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  instance.__index = self
  return instance
end

return Bard