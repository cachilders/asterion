-- a LOCATION has a deterministic quality used for mutating the aesthetic content of its SUPERPOSITION
local PASSAGES = {'l', 'r', 'f'}
local constants = include('lib/constants')

local Location = {
  depth = 0,
  destinations = nil,
  feature = nil,
  locked_destination = nil,
  position = 1,
  position_state = nil
}

function Location:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Location:init(superpose, origin)
  local depth = 0
  local destinations = { nil, nil, nil }
  local lock_index = nil
  local start = origin == nil
  if not start then
    self.position = origin.position + 1
  end

  for i = 1, 3 do
    if math.random(0, self.position) >= self.position - 1 then
      if depth == 0 then depth = 1 end
      local destination = Location:new()
      destination:init(superpose, self)
      destinations[i] = destination
      if destination.depth >= depth then
        depth = destination.depth + 1
        lock_index = i
      end
    end
  end

  self.depth = depth
  self.locked_destination = PASSAGES[lock_index]
  local l, r, f = table.unpack(destinations)
  self.destinations = {
    l = l,
    r = r,
    f = f,
    b = start and nil or origin
  }

  superpose(self)
end

function Location:get(k)
  return self[k]
end

function Location:set(k, v)
  self[k] = v
end

function Location:act(k, update, test)
  -- TODO: this whole block can and should be improved in a
  -- code org and quality sense with better abstractions, etc.
  local destinations = self.destinations
  local action = constants.INPUTS[k]
  -- This bit is awful and needs serious rethinking
  local locked_destination = self.feature and self.feature.type == constants.FEATURES.LOCK and self.locked_destination
  if action == constants.INPUTS[' '] then
    if self.feature then
      if self.feature.type == constants.FEATURES.KEY then
        update({verb = constants.ACTIONS.TAKE, value = self.feature})
        self.feature = nil
      elseif self.feature.type == constants.FEATURES.LOCK then
        if test(self.feature.match) then
          update({verb = constants.ACTIONS.DROP, value = self.feature.match})
          self.feature = nil
          self.locked_destination = nil
        else
          print('You lack something the lock wants')
        end
      end
    else
      print('There is nothing with which to interact')
    end
  elseif destinations[action] then
    if locked_destination ~= action then
      update({verb = constants.ACTIONS.MOVE, value = destinations[action]})
    else
      print('That passage is locked.')
    end
  else
    print('nope')
  end
end

function Location:impart()
  -- TODO So profoundly temporary
  local destinations = self.destinations
  local feature = self.feature and 'a '..self.feature.type or 'nothing'
  local locked_destination = self.feature and self.feature.type == constants.FEATURES.LOCK and self.locked_destination
  return {
    'You are at position '..self.position,
    'You are in position state '..self.position_state,
    'There is '..feature..' here',
    ''..(locked_destination ~= 'l' and destinations.l ~= nil and constants.ARROWS['l'] or '')..
    (locked_destination ~= 'f' and destinations.f ~= nil and constants.ARROWS['f'] or '')..
    (destinations.b ~= nil and constants.ARROWS['b'] or '')..
    (locked_destination ~= 'r' and destinations.r ~= nil and constants.ARROWS['r'] or '')
  }
end


return Location