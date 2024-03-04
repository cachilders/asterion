local Feature = {
  description = nil,
  name = nil,
  type = 'feature'
}

function Feature:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Feature:init()
  -- NOOP
end

function Feature:interact(update)
  -- update: callback to affect relevant externalities
end

function Feature:get(k)
  return self[k]
end

function Feature:set(k, v)
  self[k] = v
end

return Feature