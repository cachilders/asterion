local Pouch = {
  contents = nil
}

function Pouch:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  instance.contents = {}
  return instance
end

function Pouch:inspect()
  -- TODO inventory stuff
  if #self.contents == 0 then
    print('There is nothing in your pouch')
  else
    print('In your pouch you have:')
    for i = 1, #self.contents do
      print(self.contents[i]:get('type'), self.contents[i]:get('match'), self.contents[i]:get('name'))
    end
  end
end

function Pouch:add(item)
  self.contents[item:get('match')] = item
end

function Pouch:remove(match)
  local contents = {}
  for i = 1, #self.contents do
    local this_match = self.contents[i]:get('match')
    if this_match ~= match then
      contents[this_match] = self.contents[i]
    end
  end
  self.contents = contents
end

return Pouch