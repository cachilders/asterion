local Artificer = include('lib/labyrinth/artificer')
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
  self.artificer = Artificer:new()
  self.positions = Positions:new()
  local function superpose(l)
    self.positions:superpose_at_position(l)
  end
  self.start = Location:new()
  self.start:init(superpose)
  self.positions:decorate()
  self.observer_location = self.start
  self:refresh()
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

function Labyrinth:refresh()
  self.artificer:render_setting(self.observer_location, self.start)
end

return Labyrinth