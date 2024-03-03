-- A LOCATION without a B (back) is the ORIGIN
-- all LOCATIONS can have up to 3 DESTINATIONS (L, R, F) in addition to an origin (B) == DESTINATIONS = {L, R, F, B}
-- a LOCATION has a depth == SUPERPOSITION
-- a LOCATION has a value == LOCK || KEY || NIL
-- a LOCATION has a method for mutating the aesthetic content of its SUPERPOSITION
-- this method is deterministic

local Location = {}

function Location:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

return Location