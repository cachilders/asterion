local Location = include('lib/labyrinth/location')
local Positions = include('lib/labyrinth/positions')
local constants = include('lib/constants')

local Labyrinth = {
  observer_location = nil,
  positions = nil,
  start = nil
}

function Labyrinth:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Labyrinth:init()
  self.positions = Positions:new()
  local function superpose(l)
    self.positions:superpose_at_position(l)
  end
  self.start = Location:new()
  self.start:init(superpose)
  self.positions:decorate()
  self.observer_location = self.start
  self:describe_observer_location()
end

function Labyrinth:act(k, affect, test)
  local function update(action)
    if action.verb == constants.ACTIONS.MOVE then
      self.observer_location = action.value
    end
    affect(action)
  end
  self.observer_location:act(k, update, test)
end

function Labyrinth:describe_observer_location()
  local description = self.observer_location:impart()
  local texture = screen.new_texture_from_file('/Users/user/Projects/the-circular-ruins/assets/images/test.png')
  texture:render(0, 0)
  local x, y = 64, 22
  for i = 1, #description do
    screen.move(x, y)
    if i == #description then
      screen.text_center(description[i])
    end
    y = y + 10
  end
end

return Labyrinth