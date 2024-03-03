-- value of node
-- added to inventory when interacted with and removed from node
-- has lock pair
-- destroyed when used on lock

local Key = {
  match = nil,
  type = 'key'
}

function Key:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Key:init(match)
  self.match = match
  print('Key:', self.match)
end

return Key