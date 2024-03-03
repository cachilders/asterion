-- A LOCATION without a B (back) is the ORIGIN
-- all LOCATIONS can have up to 3 DESTINATIONS (L, R, F) in addition to an origin (B) == DESTINATIONS = {L, R, F, B}
-- a LOCATION has a depth == length of longest brach
-- a LOCATION has a value == LOCK || KEY || NIL
-- a LOCATION has a method for mutating the aesthetic content of its SUPERPOSITION
-- this method is deterministic

local Location = {
  depth = 0,
  destinations = nil,
  position = 1
}

function Location:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Location:init(superpose, origin)
  local depth = 0
  local destinations = { nil, nil, nil }
  local start = origin == nil
  if not start then
    self.position = origin.position + 1
  end

  for i = 1, 3 do
    if math.random(0, self.position) >= self.position - 1 then
      if depth == 0 then depth = 1 end
      local destination = Location:new()
      destination:init(superpose, self)
      destinations[i] = destination
      if destination.depth >= depth then
        depth = destination.depth + 1
      end
    end
  end

  self.depth = depth

  self.destinations = {
    l = destinations[1],
    r = destinations[2],
    f = destinations[3],
    b = start and nil or origin
  }

  superpose(self)
end

return Location