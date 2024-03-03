-- an abstraction of the level itself
-- the means of its traversal
-- start or head or trunk == ORIGIN
-- nodes or rooms == LOCATIONS
-- LOCATIONS at the same level are the same LOCATION in different states == SUPERPOSITION
-- the only values LOCATIONS possess: lock or key or nil
-- aesthetic values belong to the SUPERPOSITION
-- so that an image is shared between each LOCATION in the SET of the SUPERPOSITION
-- with the LOCK and KEY being poroperties of a SUBSET of the SUPERPOSITION SET
-- the subset should consist of the shortest and longest branches represented at the SUPERPOSITION
-- where the DESTINATION (L, R, F) of the locked LOCATION with the longest path is blocked
-- When only one LOCATION remains at a SUPERPOSITION with no additional branches it is DESTINATION
-- if multiple LOCATIONS exist in a SUPERPOSITION set, each with no new branches
-- one is DESTINATION with a LOCK
-- one contains the KEY
-- remaining are death or CONCLUSIONS
-- LOCATIONS not represented in the SUPERPOSITION SUBSET can be CONCLUSIONs and force retries
-- additionally LOCKS interacted with without their keys can be fatal

-- LABYRINTH instantiates the maze itself, causing creation of ORIGIN and its child positions and so on
-- LABYRINTH then instantiates SUPERPOSITIONS which mint LOCKS and KEYS and assign them to their SETS
-- at every SUPERPOSITION with more than one LOCATION

-- {{ORIGIN}, {SET}, {SET}, {SET}, {SET}}

-- Everything needs a clone method which is create without randomness

local Location = include('lib/labyrinth/location')
local Positions = include('lib/labyrinth/positions')

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

function Labyrinth:act(k)
  local destinations = self.observer_location.destinations
  if k == 'left' and destinations.l then
    self.observer_location = destinations.l
  elseif k == 'right' and destinations.r then
    self.observer_location = destinations.r
  elseif k == 'up' and destinations.f then
    self.observer_location = destinations.f
  elseif k == 'down' and destinations.b then
    self.observer_location = destinations.b
  else
    print('nope')
  end
end

function Labyrinth:describe_observer_location()
  local location = self.observer_location
  local destinations = location.destinations
  local options = ' '..(destinations.l ~= nil and 'l ' or '')..(destinations.r ~= nil and 'r ' or '')..(destinations.f ~= nil and 'f ' or '')..(destinations.b ~= nil and 'b ' or '')
  screen.move(64, 22)
  screen.text_center('You are at position '..location:get('position'))
  screen.move(64, 32)
  screen.text_center('You are in position state '..location:get('position_state'))
  screen.move(64, 42)
  screen.text_center('You can move '..options)
end

return Labyrinth