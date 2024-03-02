-- inventory

local Pouch = {}

function Pouch:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  instance.__index = self
  return instance
end

return Pouch