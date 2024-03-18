local constants = include('lib/constants')

local Artificer = {}

function Artificer:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Artificer:render_setting(current_location, start_location)
  local destinations = current_location:get('destinations')
  local feature = current_location:get('feature')
  local feature_type = feature and feature:get('type')
  local locked_destination = feature_type == constants.FEATURES.LOCK and current_location:get('locked_destination')
  local options = ''..(locked_destination ~= 'l' and destinations.l ~= nil and constants.ARROWS['l'] or '')..
    (locked_destination ~= 'f' and destinations.f ~= nil and constants.ARROWS['f'] or '')..
    (destinations.b ~= nil and constants.ARROWS['b'] or '')..
    (locked_destination ~= 'r' and destinations.r ~= nil and constants.ARROWS['r'] or '')
  local aspects = {
    lock = locked_destination,
    key = feature_type == constants.FEATURES.KEY,
    l = destinations.l ~= nil,
    r = destinations.r ~= nil,
    f = destinations.f ~= nil
  }

  local room = math.floor((20 / start_location:get('depth')) * current_location:get('position'))
  local room_path = 'rooms/'..room
  local l_path = (aspects.l and aspects.lock == 'l' and 'doors/locked_l') or (aspects.l and 'doors/open_l') or nil
  local c_path = (aspects.f and aspects.lock == 'f' and 'doors/locked_c') or (aspects.f and 'doors/open_c') or nil -- Need final door logic
  local r_path = (aspects.r and aspects.lock == 'r' and 'doors/locked_r') or (aspects.r and 'doors/open_r') or nil
  local key_path = 'key'

  screen.display_png(constants.ASSET_PATH..room_path..'.png', 0, 0)

  if l_path then
    screen.display_png(constants.ASSET_PATH..l_path..'.png', 0, 0)
  end
  if c_path then
    screen.display_png(constants.ASSET_PATH..c_path..'.png', 48, 0)
  end
  if r_path then
    screen.display_png(constants.ASSET_PATH..r_path..'.png', 80, 0)
  end

  if aspects.key then
    screen.display_png(constants.ASSET_PATH..key_path..'.png', 48, 0)
  end

  local x, y = 64, 56
  screen.move(x, y)
  screen.text_center(options)
end

return Artificer
