-- The Circular Ruins
-- Explore the ruins. Dream something into being.

local Bard = include('lib/bard')
local Labyrinth = include('lib/labyrinth')
local Pouch = include('lib/pouch')
local constants = include('lib/constants')
local bard, labyrinth, pouch

function init()
  math.randomseed(os.time())
  bard = Bard:new()
  labyrinth = Labyrinth:new()
  pouch = Pouch:new()
  bard:intone()
  labyrinth:init()
  redraw()
end

function enc(e, d)
end

function key(k, z)
end

function keyboard.code(k, z)
  local function affect(action)
    if action.verb == constants.ACTIONS.MOVE then
      bard:modulate(action.value)
    elseif action.verb == constants.ACTIONS.DROP then
      pouch:remove(action.value)
      bard:modulate({shine = 0.1})
    elseif action.verb == constants.ACTIONS.TAKE then
      pouch:add(action.value)
      bard:modulate({shine = 0.6})
    end
  end
  local function test(match)
    return pouch:inspect(match)
  end
  if z == 0 then
    if k == 'I' then
      pouch:inspect()
    else
      labyrinth:act(k.name or k, affect, test)
      redraw()
    end
  end
end

function draw()
end

function redraw()
  screen.clear()
  screen.level(16)
  labyrinth:describe_observer_location()
  screen.update()
end

function refresh()
  redraw()
end