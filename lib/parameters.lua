local music_util = require('musicutil')
local asterion_engine = include('/lib/engine/asterion_engine')

local Parameters = {}

function Parameters:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Parameters.init()
  params:add_group('asterion', 'ASTERION', 3)
  params:add_number('base', 'Drone Base', 0, 127, 36, function(param) return music_util.note_num_to_name(param:get(), true) end)
  params:set_action('base', function(n) params:set('hz', music_util.note_num_to_freq(n)) end)
  params:add_number('loop_length', 'Loop Length', 8, 2048, 16)
  params:add_number('step_depth', 'Max Step Depth', 1, 256, 4)
  asterion_engine:add_params()
end

function Parameters.set_song_update(update_song_params)
  params:set_action('loop_length', update_song_params)
  params:set_action('step_depth', update_song_params)
end

return Parameters