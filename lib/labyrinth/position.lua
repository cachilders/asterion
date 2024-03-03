local Key = include('lib/labyrinth/key')
local Lock = include('lib/labyrinth/lock')

local Position = {
  id = nil,
  greatest = nil,
  least = nil,
  states = nil
}

function Position:new(options)
  local instance = options or {}
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

function Position:decorate()
  if #self.states > 1 then
    print('Decorating position '..self.id..' (width:'..#self.states..')')
    local match = string.gsub(tostring(self), 'table: ', '')
    local key = Key:new()
    local lock = Lock:new()
    key:init(match)
    lock:init(match)
    self.greatest:set('feature', lock)
    self.least:set('feature', key)
  end
end

return Position