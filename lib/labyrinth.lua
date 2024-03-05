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
  local description, passages = self.observer_location:impart()
  local l_path = (passages.l and passages.lock == 'l' and 'lock/1-l') or (passages.l and 'open/1-l') or 'blank/1-l'
  local c_path = (passages.f and passages.lock == 'f' and 'lock/1-f') or (passages.f and 'open/1-f') or 'blank/1-f'
  local r_path = (passages.r and passages.lock == 'r' and 'lock/1-r') or (passages.r and 'open/1-r') or 'blank/1-r'
  local l = screen.new_texture_from_file('/Users/user/Projects/the-circular-ruins/assets/images/'..l_path..'.png')
  local c = screen.new_texture_from_file('/Users/user/Projects/the-circular-ruins/assets/images/'..c_path..'.png')
  local r = screen.new_texture_from_file('/Users/user/Projects/the-circular-ruins/assets/images/'..r_path..'.png')
  l:render(0, 0)
  c:render(48, 0)
  r:render(79, 0)
  local x, y = 64, 22
  for i = 1, #description do
    screen.move(x, y)
    screen.text_center(description[i])
    y = y + 10
  end
end

return Labyrinth