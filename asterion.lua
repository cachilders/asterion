-- The House of Asterion
-- Wander the labyrinth.
-- Dream something into being.
--
-- Keyboard (typing) Required
-- w, ↑, a, ←, s, ↓, d, →
-- [space], [enter] to interact

local Labyrinth = include('lib/labyrinth')
local Minstrel = include('lib/minstrel')
local Parameters = include('lib/parameters')
local Pouch = include('lib/pouch')
local constants = include('lib/constants')

engine.name = 'Asterion'

local minstrel, labyrinth, pouch
local splash = true
local splash_variant = 1

local function affect(action)
  if action.verb == constants.ACTIONS.MOVE then
    minstrel:observe(action.value)
  elseif action.verb == constants.ACTIONS.DROP then
    pouch:remove(action.value)
    minstrel:observe({shine = (pouch:get('size') * 0.1) + (0.1 * labyrinth:get('level'))})
  elseif action.verb == constants.ACTIONS.TAKE then
    pouch:add(action.value)
    minstrel:observe({shine = (pouch:get('size') * 0.1) + (0.1 * labyrinth:get('level'))})
  elseif action.verb == constants.ACTIONS.ASCEND then
    minstrel:observe({shine = params:get('shine') * 2, gloom = 0.1 * labyrinth:get('level')})
    labyrinth:ascend()
  elseif action.verb == constants.ACTIONS.DESCEND then
    minstrel:observe({shine = params:get('shine') / 2, gloom = 0.1 * labyrinth:get('level')})
    labyrinth:descend()
  end
end

local function commence()
  splash = false
  minstrel:init()
  parameters.set_song_update(function() minstrel:adjust_song() end)
end

local function render()
  if splash then
    screen.display_png(constants.ASSET_PATH..'splash'..splash_variant..'.png', 0, 0)
    screen.move(64, 18)
    screen.text_center('The House of')
    screen.move(64, 58)
    screen.text_center('Press Any Key')
  else
    labyrinth:refresh()
  end
end

local function test_match(match)
  return pouch:inspect(match)
end

function init()
  math.randomseed(os.time())
  splash_variant = math.random(1, 2)
  labyrinth = Labyrinth:new()
  minstrel = Minstrel:new()
  parameters = Parameters:new()
  pouch = Pouch:new()
  labyrinth:init()
  parameters.init()
  redraw()
end

function enc(e, d)
end

function key(k, z)
end

function keyboard.code(k, z)
  if z == 0 then
    if not splash then
      if k == 'I' then
        pouch:inspect()
      else
        labyrinth:act(k.name or k, affect, test_match)
        redraw()
      end
    else
      commence()
    end
  end
end

function redraw()
  screen.clear()
  screen.level(16)
  render()
  screen.update()
end

function refresh()
  redraw()
end