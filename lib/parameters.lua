local asterion_engine = include('/lib/engine/asterion_engine')

local Parameters = {}

function Parameters:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Parameters.init()
  params:add_group('asterion', 'ASTERION', 2)
  params:add_number('loop_length', 'Loop Length', 8, 2048, 16)
  params:add_number('step_depth', 'Max Step Depth', 1, 256, 4)
  asterion_engine:add_params()
end

function Parameters.set_song_update(update_song_params)
  params:set_action('loop_length', update_song_params)
  params:set_action('step_depth', update_song_params)
end

return Parameters