local util = require('util')
local constants = include('lib/constants')
local MAX_FRAME = 30
local MAX_KEYFRAME = 3
local MAX_ROOM = 25

local Artificer = {
  frame = 1,
  keyframe = 1
}

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
  local final_location = current_location:get('final')
  local key = feature_type == constants.FEATURES.KEY
  local locked_destination = (feature_type == constants.FEATURES.LOCK) and current_location:get('locked_destination')
  local options = ''..(locked_destination ~= 'l' and destinations.l ~= nil and constants.ARROWS['l'] or '')..
    (((locked_destination ~= 'f' and destinations.f ~= nil) or final_location) and constants.ARROWS['f'] or '')..
    (destinations.b ~= nil and constants.ARROWS['b'] or '')..
    (locked_destination ~= 'r' and destinations.r ~= nil and constants.ARROWS['r'] or '')
  local l = destinations.l ~= nil
  local r = destinations.r ~= nil
  local f = destinations.f ~= nil
  local key_path = constants.ASSET_PATH..'key'
  local room = math.floor((MAX_ROOM / (start_location:get('depth') + 1)) * current_location:get('position'))
  local room_path = constants.ASSET_PATH..'rooms/'..room
  local doors_path = constants.ASSET_PATH..'doors/'
  local l_path = (l and locked_destination == 'l' and 'locked_l')
    or (l and 'open_l')
    or nil
  local c_path = (final_location and 'final'..self.keyframe)
    or (f and locked_destination == 'f' and 'locked_c')
    or (f and 'open_c')
    or (final_location and 'final')
    or nil
  local r_path = (r and locked_destination == 'r' and 'locked_r')
    or (r and 'open_r')
    or nil

  screen.display_png(room_path..'.png', 0, 0)

  if l_path then
    screen.display_png(doors_path..l_path..'.png', 0, 0)
  end
  if c_path then
    screen.display_png(doors_path..c_path..'.png', 48, 0)
  end
  if r_path then
    screen.display_png(doors_path..r_path..'.png', 80, 0)
  end

  if key then
    screen.display_png(key_path..'.png', 48, 0)
  end

  local x, y = 64, 56
  screen.move(x, y)
  screen.text_center(options)
  self:_frame_advance()
end

function Artificer:_frame_advance()
  local KEYFRAME_MODULO = MAX_FRAME / MAX_KEYFRAME
  self.frame = util.wrap(self.frame + 1, 1, MAX_FRAME)

  if self.frame % KEYFRAME_MODULO == 0 then
    self.keyframe = util.wrap(self.keyframe + 1, 1, MAX_KEYFRAME)
  end
end

return Artificer
