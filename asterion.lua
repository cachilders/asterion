-- Asterion
-- Wander the labyrinth. Dream something into being.

local Labyrinth = include('lib/labyrinth')
local Minstrel = include('lib/minstrel')
local Pouch = include('lib/pouch')
local constants = include('lib/constants')
local minstrel, labyrinth, pouch

local function affect(action)
  if action.verb == constants.ACTIONS.MOVE then
    minstrel:observe(action.value)
  elseif action.verb == constants.ACTIONS.DROP then
    pouch:remove(action.value)
    minstrel:observe({shine = 0.1})
  elseif action.verb == constants.ACTIONS.TAKE then
    pouch:add(action.value)
    minstrel:observe({shine = 0.6})
  elseif action.verb == constants.ACTIONS.ASCEND then
    minstrel:observe({shine = 1})
    labyrinth:ascend()
  elseif action.verb == constants.ACTIONS.DESCEND then
    minstrel:observe({gloom = 1})
    labyrinth:descend()
  end
end

local function test_match(match)
  return pouch:inspect(match)
end

function init()
  math.randomseed(os.time())
  labyrinth = Labyrinth:new()
  minstrel = Minstrel:new()
  pouch = Pouch:new()
  labyrinth:init()
  minstrel:init()
  redraw()
end

function enc(e, d)
end

function key(k, z)
end

function keyboard.code(k, z)
  if z == 0 then
    if k == 'I' then
      pouch:inspect()
    else
      labyrinth:act(k.name or k, affect, test_match)
      redraw()
    end
  end
end

function redraw()
  screen.clear()
  screen.level(16)
  labyrinth:refresh()
  screen.update()
end

function refresh()
  redraw()
end