-- The Circular Ruins
-- Explore the ruins. Dream something into being.

local Bard = include('lib/bard')
local Labyrinth = include('lib/labyrinth')
local Pouch = include('lib/pouch')

function init()
  math.randomseed(os.time())
  screen.set_size(128, 64) -- TBD
  labyrinth = Labyrinth:new()
  labyrinth:init()
  redraw()
end

function enc(e, d)
end

function key(k, z)
end

function screen.key(k, mods, rep, z)
  if z == 0 then
    labyrinth:act(k.name or k)
    redraw()
  end
end

function screen.click(x, y)
  screen.move(x, y)
  screen.text('*')
  screen.refresh()
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