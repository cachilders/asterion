local Location = include('lib/labyrinth/location')
local Positions = include('lib/labyrinth/positions')
local constants = include('lib/constants')

local ASSET_PATH = '/home/we/dust/code/asterion/assets/images/'

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
      -- TODO replace this POC tone stuff
      local loc = action.value
      local states = self.positions:get('collection')[loc:get('position')]:get('states')
      action.value = {
        breadth = (1 / #states) * loc:get('position_state'),
        depth = (1 / self.start:get('depth')) * loc:get('depth'),
        gloom = (1 / self.start:get('depth')) * loc:get('position')
      }
    end
    affect(action)
  end
  self.observer_location:act(k, update, test)
end

function Labyrinth:describe_observer_location()
  local description, aspects  = self.observer_location:impart()
  local room = math.floor((20 / self.start:get('depth')) * self.observer_location:get('position'))
  local room_path = 'rooms/'..room
  local l_path = (aspects.l and aspects.lock == 'l' and 'doors/locked_l') or (aspects.l and 'doors/open_l') or nil
  local c_path = (aspects.f and aspects.lock == 'f' and 'doors/locked_c') or (aspects.f and 'doors/open_c') or nil -- Need final door logic
  local r_path = (aspects.r and aspects.lock == 'r' and 'doors/locked_r') or (aspects.r and 'doors/open_r') or nil
  local key_path = 'key'

  screen.display_png(ASSET_PATH..room_path..'.png', 0, 0)

  if l_path then
    screen.display_png(ASSET_PATH..l_path..'.png', 0, 0)
  end
  if c_path then
    screen.display_png(ASSET_PATH..c_path..'.png', 48, 0)
  end
  if r_path then
    screen.display_png(ASSET_PATH..r_path..'.png', 80, 0)
  end

  if aspects.key then
    screen.display_png(ASSET_PATH..key_path..'.png', 48, 0)
  end

  local x, y = 64, 22
  for i = 1, #description do
    if i == #description then
      screen.move(x, y)
      screen.text_center(description[i])
    end
    y = y + 10
  end
end

return Labyrinth