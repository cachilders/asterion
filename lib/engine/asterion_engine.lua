local Asterion = {}
local ControlSpec = require 'controlspec'
local Formatters = require 'formatters'

local function quantize_and_format(value, step, unit)
  return util.round(value, step)..unit
end

local parameters = {
  {id = 'amp', name = 'amplitude', type = 'control', min = 0, max = 1, warp = 'lin', default = 0.0, formatter = function(param) return quantize_and_format(param:get()*100, 1, '%') end},
  {id = 'noise_amp', name = 'noise amplitude', type = 'control', min = 0, max = 1, warp = 'lin', default = 0.5, formatter = function(param) return quantize_and_format(param:get()*100, 1, '%') end},
  {id = 'hz', name = 'frequency', type = 'number', min = 20.0, max = 20000.0, default = 65.41, formatter = function(param) return quantize_and_format(param:get(), 0.01, ' hz') end},
  {id = 'breadth', name = 'breadth', type = 'control', min = 0.01, max = 1, default = 0.1, formatter = function(param) return quantize_and_format(param:get()*100, 0.1, '%') end},
  {id = 'depth', name = 'depth', type = 'control', min = 0.01, max = 1, default = 0.1, formatter = function(param) return quantize_and_format(param:get()*100, 0.1, '%') end},
  {id = 'gloom', name = 'gloom', type = 'control', min = 0.01, max = 1, default = 0.1, formatter = function(param) return quantize_and_format(param:get()*100, 0.1, '%') end},
  {id = 'shine', name = 'shine', type = 'control', min = 0.01, max = 1, default = 0.5, formatter = function(param) return quantize_and_format(param:get()*100, 0.1, '%') end},
  {id = 'attack', name = 'attack', type = 'control', min = 0.001, max = 17, warp = 'exp', default = 0.01, formatter = function(param) return quantize_and_format(param:get(), 0.01, ' s') end},
  {id = 'decay', name = 'decay', type = 'control', min = 0.001, max = 17, warp = 'exp', default = 0.1, formatter = function(param) return quantize_and_format(param:get(), 0.01, ' s') end},
  {id = 'release', name = 'release', type = 'control', min = 0.001, max = 17, warp = 'exp', default = 0.3, formatter = function(param) return quantize_and_format(param:get(), 0.01, ' s') end}
}

function Asterion:add_params()
  params:add_group('asterion_engine', 'ASTERION (ENGINE)', 10)
  for i = 1, #parameters do
    local parameter = parameters[i]
    if parameter.type == 'control' then
      params:add_control(
        parameter.id,
        parameter.name,
        ControlSpec.new(parameter.min, parameter.max, parameter.warp, 0, parameter.default),
        parameter.formatter
      )
    elseif parameter.type == 'number' then
      params:add_number(
        parameter.id,
        parameter.name,
        parameter.min,
        parameter.max,
        parameter.default,
        parameter.formatter
      )
    end

    params:set_action(parameter.id, function(val)
      engine[parameter.id](val)
    end)
  end

  params:bang()
end

return Asterion