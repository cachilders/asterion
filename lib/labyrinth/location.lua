local constants = include('lib/constants')

local Location = {
  depth = 0,
  destinations = nil,
  feature = nil,
  final = false,
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
  local destinations = {
    b = origin 
  }
  local lock_index = nil

  if origin then
    self.position = origin.position + 1
  end

  for i = 1, 3 do
    local dir = constants.PASSAGES[i]
    if math.random(0, self.position) >= self.position - 1 then
      destinations[dir] = Location:new()
      destinations[dir]:init(superpose, self)
      if destinations[dir]:get('depth') >= depth then
        depth = destinations[dir]:get('depth') + 1
        lock_index = i
      end
    else
      destinations[dir] = nil
    end
  end

  self.depth = depth
  self.locked_destination = constants.PASSAGES[lock_index]
  self.destinations = destinations
  superpose(self)
end

function Location:get(k)
  return self[k]
end

function Location:set(k, v)
  self[k] = v
end

function Location:act(k, test_match, update, level)
  -- TODO: this whole block can and should be improved in a
  -- code org and quality sense with better abstractions, etc.
  local destinations = self.destinations
  local action = constants.INPUTS[k]
  -- This bit is awful and needs serious rethinking
  local locked_destination = self.feature and self.feature.type == constants.FEATURES.LOCK and self.locked_destination
  if action == constants.INPUTS.SPACE then
    if self.feature then
      if self.feature.type == constants.FEATURES.KEY then
        update({verb = constants.ACTIONS.TAKE, value = self.feature})
        self.feature = nil
      elseif self.feature.type == constants.FEATURES.LOCK then
        if test_match(self.feature.match) then
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
  end
  
  if destinations[action] then
    if locked_destination ~= action then
      update({verb = constants.ACTIONS.MOVE, value = destinations[action]})
    else
      print('That passage is locked.')
    end
  elseif self.final and action == constants.INPUTS.UP then
    update({verb = constants.ACTIONS.DESCEND})
  elseif self.position == 1 and level > 1 and action == constants.INPUTS.DOWN then
    update({verb = constants.ACTIONS.ASCEND})
  end
end

return Location