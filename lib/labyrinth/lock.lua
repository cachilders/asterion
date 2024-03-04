local Feature = include('lib/labyrinth/feature')
local constants = include('lib/constants')

local Lock = {
  match = nil,
  type = constants.FEATURES.LOCK
}

function Lock:new(options)
  local instance = options or {}
  setmetatable(self, {__index = Feature})
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Lock:init(match)
  self.match = match
  print('Lock:', self.match)
end

function Lock:interact(update)
  -- if key matches destroy key and lock
  -- key possesses own destruct method
  -- tell update callback if good, bad, or neutral outcome
  -- {'success', 'fail', 'noop'}
end

return Lock