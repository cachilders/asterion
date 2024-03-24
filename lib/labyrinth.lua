local Artificer = include('lib/labyrinth/artificer')
local Level = include('lib/labyrinth/level')

local Labyrinth = {
  artificer = nil,
  level = 1,
  levels = nil
}

function Labyrinth:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Labyrinth:init()
  self.artificer = Artificer:new()
  self.levels = {}
  self:_add_level(nil)
  self:refresh()
end

function Labyrinth:get(k)
  return self[k]
end

function Labyrinth:act(k, affect, test_match)
  self.levels[self.level]:move(k, affect, test_match, self.level)
end

function Labyrinth:ascend()
  self.level = self.level - 1
end

function Labyrinth:descend()
  if #self.levels == self.level then
    self:_add_level(self.levels[self.level])
  end

  self.level = self.level + 1
end

function Labyrinth:refresh()
  self.levels[self.level]:render(self.artificer)
end

function Labyrinth:_add_level()
  local level = Level:new()
  level:init()
  table.insert(self.levels, level)
end

return Labyrinth