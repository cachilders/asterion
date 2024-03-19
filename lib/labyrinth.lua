local Artificer = include('lib/labyrinth/artificer')
local Location = include('lib/labyrinth/location')
local Positions = include('lib/labyrinth/positions')
local constants = include('lib/constants')

local Labyrinth = {
  level = nil,
  levels = nil,
  observer_location = nil,
  positions = nil,
  start = nil
}

function Labyrinth:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  instance.levels = {}
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
  table.insert(self.levels, self.start)
  self.level = #self.levels
  self.observer_location = self.start
  self:refresh()
end

function Labyrinth:act(k, affect, test_match)
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
    elseif action.verb == constants.ACTIONS.DESCEND then
      action.value = {
        gloom = 1
      }
      if #self.levels == self.level then
        self:init()
      else
        self.observer_location = self.levels[self.level + 1]
      end
    elseif action.verb == constants.ACTIONS.ASCEND then
      -- TODO Ascent is going to be more difficult because
      -- we'll have to to preserve more data than
      -- the tree itself. Need to think.
      action.value = {
        shine = 1
      }
      if #self.levels == self.level then
        local prior_level = self.levels[self.level - 1]
        -- TODO resolve level state. Probably need another
        -- abstraction level.
      end
    end
    affect(action)
  end
  self.observer_location:act(k, test_match, update, self.level)
end

function Labyrinth:refresh()
  self.artificer:render_setting(self.observer_location, self.start)
end

return Labyrinth