local Feature = include('lib/labyrinth/feature')

local Key = {
  match = nil,
  type = 'key'
}

function Key:new(options)
  local instance = options or {}
  setmetatable(self, {__index = Feature})
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Key:init(match)
  self.match = match
  print('Key:', self.match)
end

function Key:interact(update)
  -- update removes key from room and adds to pouch
end

return Key