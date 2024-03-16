local Pouch = {
  contents = nil,
  size = 0
}

function Pouch:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  instance.contents = {}
  return instance
end

function Pouch:get(k)
  return self[k]
end

function Pouch:inspect(match)
  -- TODO inventory stuff
  if match then
    return self.contents[match] ~= nil
  elseif self.size == 0 then
    print('There is nothing in your pouch')
  else
    print('In your pouch you have:')
    for k, v in pairs(self.contents) do
      print('a '..v:get('type')..' labelled '..k)
    end
  end
end

function Pouch:add(item)
  self.contents[item:get('match')] = item
  self.size = self.size + 1
end

function Pouch:remove(match)
  local contents = {}
  for k, v in pairs(self.contents) do
    if k ~= match then
      contents[k] = v
    end
  end
  self.contents = contents
  self.size = self.size - 1
end

return Pouch