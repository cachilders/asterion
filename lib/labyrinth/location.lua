-- a LOCATION has a deterministic quality used for mutating the aesthetic content of its SUPERPOSITION

local PASSAGES = {'l', 'r', 'f'}

local Location = {
  depth = 0,
  destinations = nil,
  feature = nil,
  locked_destination = nil,
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
  local lock_index = nil
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
        lock_index = i
      end
    end
  end

  self.depth = depth
  self.locked_destination = PASSAGES[lock_index]
  local l, r, f = table.unpack(destinations)
  self.destinations = {
    l = l,
    r = r,
    f = f,
    b = start and nil or origin
  }

  superpose(self)
end

function Location:get(k)
  return self[k]
end

function Location:set(k, v)
  self[k] = v
end

return Location