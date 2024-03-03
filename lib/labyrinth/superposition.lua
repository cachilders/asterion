-- a SUPERPOSITION contains a SCENE image
-- it probably also has a TONE or CHARACTER or CHARACTERISTIC when we get into the drone sequencing
-- there may also be methods here for passing between members of SUPERPOSITION SET

local Superposition = {}

function Superposition:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

return Superposition