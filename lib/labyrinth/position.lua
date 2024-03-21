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
  location:set('position_state', #self.states)
  local location_depth = location:get('depth')
  local greatest = self.greatest
  local least = self.least
  if greatest == nil or greatest:get('depth') < location_depth then
    self.greatest = location

    if (greatest ~= nil and least ~= nil and greatest:get('depth') < least:get('depth')) or least == nil then
      self.least = greatest
    end
  end

  if least == nil or least:get('depth') > location_depth then
    self.least = location

    if (greatest ~= nil and least ~= nil and least:get('depth') > greatest:get('depth')) or greatest == nil then
      self.greatest = least
    end
  end
end

function Position:decorate()
  print('Decorating position '..self.id..' (width:'..#self.states..')')
  if #self.states > 1 and self.greatest:get('depth') > 0 then
    local match = string.gsub(tostring(self), 'table: ', '')
    local key = Key:new()
    local lock = Lock:new()
    print('Placing at state '..self.greatest:get('position_state'))
    key:init(match)
    print('Placing at state '..self.least:get('position_state'))
    lock:init(match)
    self.greatest:set('feature', lock)
    self.least:set('feature', key)
  end
end

return Position