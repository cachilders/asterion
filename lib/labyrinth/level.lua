local Location = include('lib/labyrinth/location')
local Positions = include('lib/labyrinth/positions')
local constants = include('lib/constants')

local Level = {
  observer_location = nil,
  positions = nil,
  start = nil
}

function Level:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Level:init()
  self.positions = Positions:new()
  
  local function superpose(location)
    self.positions:superpose_at_position(location)
  end

  self.start = Location:new()
  self.start:init(superpose)
  self.positions:decorate()
  self.observer_location = self.start
end

function Level:get(k)
  return self[k]
end

function Level:move(k, affect, test_match, level_num)
  local function update(action)
    if action.verb == constants.ACTIONS.MOVE then
      self.observer_location = action.value
      -- TODO replace this POC tone stuff
      local location = action.value
      local states = self.positions:get('collection')[location:get('position')]:get('states')
      action.value = {
        breadth = (1 / #states) * location:get('position_state'),
        depth = (1 / self.start:get('depth')) * location:get('depth'),
        gloom = (1 / self.start:get('depth')) * location:get('position')
      }
    end
    affect(action)
  end
  self.observer_location:act(k, test_match, update, level_num)
end

function Level:render(artificer)
  artificer:render_setting(self.observer_location, self.start)
end

return Level  