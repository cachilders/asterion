local Position = {
  greatest = nil,
  least = nil,
  states = nil
}

function Position:new()
  local instance = {}
  setmetatable(instance, self)
  self.__index = self
  instance.states = {}
  return instance
end

function Position:get(k)
  return self[k]
end

function Position:superpose(location)
  table.insert(self.states, location)
  if self.greatest == nil or self.greatest.depth < location.depth then
    self.greatest = location
  end

  if self.least == nil or self.least.depth > location.depth then
    self.least = location
  end
end

return Position