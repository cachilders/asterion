-- value of node
-- removed from node when matched key is applied
-- passage down longest line is blocked

local Lock = {}

function Lock:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

return Lock