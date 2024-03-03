-- a SUPERPOSITION contains a SCENE image
-- it probably also has a TONE or CHARACTER or CHARACTERISTIC when we get into the drone sequencing
-- there may also be methods here for passing between members of SUPERPOSITION SET
local Position = include('lib/labyrinth/position')

local Positions = {
  collection = nil
}

function Positions:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  instance.collection = {}
  return instance
end

function Positions:superpose_at_position(location)
  local position = location.position
  if not self.collection[position] then
    self:_init_position(position)
  end

  self.collection[position]:superpose(location)
end

function Positions:_init_position(i)
  self.collection[i] = Position:new()
end

return Positions