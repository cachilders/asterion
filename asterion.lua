-- Asterion
-- Explore the ruins. Dream something into being.

local Labyrinth = include('lib/labyrinth')
local Minstrel = include('lib/minstrel')
local Pouch = include('lib/pouch')
local constants = include('lib/constants')
local minstrel, labyrinth, pouch

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
  local function affect(action)
    if action.verb == constants.ACTIONS.MOVE then
      minstrel:observe(action.value)
    elseif action.verb == constants.ACTIONS.DROP then
      pouch:remove(action.value)
      minstrel:observe({shine = 0.1})
    elseif action.verb == constants.ACTIONS.TAKE then
      pouch:add(action.value)
      minstrel:observe({shine = 0.6})
    end
  end
  local function test_match(match)
    return pouch:inspect(match)
  end
  if z == 0 then
    if k == 'I' then
      pouch:inspect()
    else
      labyrinth:act(k.name or k, affect, test_match)
      redraw()
    end
  end
end

function draw()
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