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

function Positions:get(k)
  return self[k]
end

function Positions:size()
  return #self.collection
end

function Positions:superpose_at_position(location)
  local position = location.position
  if not self.collection[position] then
    self:_init_position(position)
  end

  self.collection[position]:superpose(location)
end

function Positions:decorate()
  local positions = self.collection
  local final_position = positions[#positions]
  local final_locations = final_position:get('states')
  for i = 1, #positions do
    positions[i]:decorate()
  end
  if #final_locations > 1 then
    local final_location = final_position:get('greatest')
    final_location:set('final', true)
  else
    local final_location = final_locations[1]
    final_location:set('final', true)
  end
end

function Positions:_init_position(i)
  self.collection[i] = Position:new({ id = i })
end

return Positions