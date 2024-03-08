-- The Circular Ruins
-- Explore the ruins. Dream something into being.

local Bard = include('lib/bard')
local Labyrinth = include('lib/labyrinth')
local Pouch = include('lib/pouch')
local constants = include('lib/constants')
local bard, labyrinth, pouch

engine.name = 'Asterion'

function init()
  math.randomseed(os.time())
  screen.set_size(128, 64) -- TBD
  labyrinth = Labyrinth:new()
  labyrinth:init()
  pouch = Pouch:new()
  redraw()
end

function enc(e, d)
end

function key(k, z)
end

function screen.key(k, mods, rep, z)
  local function affect(action)
    if action.verb == constants.ACTIONS.DROP then
      pouch:remove(action.value)
    elseif action.verb == constants.ACTIONS.TAKE then
      pouch:add(action.value)
    end
  end
  local function test(match)
    return pouch:inspect(match)
  end
  if z == 0 then
    if k == 'i' then
      pouch:inspect()
    else
      labyrinth:act(k.name or k, affect, test)
      redraw()
    end
  end
end

function screen.click(x, y)
  -- TODO remove when certain we won't use
  -- screen.move(x, y)
  -- screen.text('*')
  -- screen.refresh()
end

function draw()
end

function redraw()
  screen.clear()
  screen.level(16)
  labyrinth:describe_observer_location()
  screen.refresh()
end

function refresh()
  redraw() -- hrm
end