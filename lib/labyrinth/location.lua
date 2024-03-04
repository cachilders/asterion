-- a LOCATION has a deterministic quality used for mutating the aesthetic content of its SUPERPOSITION
local PASSAGES = {'l', 'f', 'b'}
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
  local destinations = self.destinations
  local action = constants.INPUTS[k]
  if action == constants.INPUTS[' '] then
    if self.feature then
      if self.feature.type == constants.FEATURES.KEY then
        update({verb = constants.ACTIONS.TAKE, value = self.feature})
        self.feature = nil
      elseif self.feature.type == constants.FEATURES.LOCK then
        if test(self.feature.match) then
          update({verb = constants.ACTIONS.DROP, value = self.feature.match})
          self.feature = nil
        else
          print('You lack something the lock wants')
        end
      end
    else
      print('There is nothing with which to interact')
    end
  elseif destinations[action] then
    update({verb = constants.ACTIONS.MOVE, value = destinations[action]})
  else
    print('nope')
  end
end

function Location:impart()
  local destinations = self.destinations
  local feature = self.feature and 'a '..self.feature.type or 'nothing'
  return {
    'You are at position '..self.position,
    'You are in position state '..self.position_state,
    'There is '..feature..' here',
    ''..(destinations.l ~= nil and constants.ARROWS['l'] or '')..
    (destinations.f ~= nil and constants.ARROWS['f'] or '')..
    (destinations.b ~= nil and constants.ARROWS['b'] or '')..
    (destinations.r ~= nil and constants.ARROWS['r'] or '')
  }
end


return Location