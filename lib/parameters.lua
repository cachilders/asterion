local music_util = require('musicutil')
local asterion_engine = include('/lib/engine/asterion_engine')

local SCALE_LENGTH = 10

local Parameters = {
  scale = nil,
  scale_type = nil,
  scale_types = nil
}

function Parameters:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Parameters:init()
  self:_set_musicutil_scale_types()
  params:add_group('asterion', 'ASTERION', 6)
  params:add_number('base', 'Drone Base', 0, 127, 36, function(param) return music_util.note_num_to_name(param:get(), true) end)
  params:set_action('base', function(n) params:set('hz', music_util.note_num_to_freq(n)); self:_generate_scale() end)
  params:add_number('loop_length', 'Loop Length', 8, 2048, 16)
  params:add_number('step_depth', 'Max Step Depth', 1, 256, 4)
  params:add_separator('accent', 'ACCENTS')
  params:add_option('scale_type', 'Scale', self.scale_types, 1)
  params:set_action('scale_type', function(i) self.scale_type = self.scale_types[i]; self:_generate_scale() end)
  params:add_number('velocity', 'Velocity', 0, 127, 100)
  asterion_engine:add_params()
end

function Parameters:get(k)
  return self[k]
end

function Parameters.set_song_update(update_song_params)
  params:set_action('loop_length', update_song_params)
  params:set_action('step_depth', update_song_params)
end

function Parameters:_generate_scale()
  local note = music_util.freq_to_note_num(params:get('hz'))
  self.scale = music_util.generate_scale_of_length(note, self.scale_type, SCALE_LENGTH)
end

function Parameters:_set_musicutil_scale_types()
  local scales = {}
  for i = 1, #music_util.SCALES do
    scales[i] = music_util.SCALES[i].name
  end

  self.scale_types = scales
end


return Parameters