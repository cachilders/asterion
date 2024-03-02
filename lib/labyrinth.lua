-- an abstraction of the level itself
-- the means of its traversal
-- start or head or trunk == ORIGIN
-- nodes or rooms == LOCATIONS
-- LOCATIONS at the same level are the same LOCATION in different states == SUPERPOSITION
-- the only values LOCATIONS possess: lock or key or nil
-- aesthetic values belong to the SUPERPOSITION
-- so that an image is shared between each LOCATION in the SET of the SUPERPOSITION
-- with the LOCK and KEY being poroperties of a SUBSET of the SUPERPOSITION SET
-- the subset should consist of the shortest and longest branches represented at the SUPERPOSITION
-- where the DESTINATION (L, R, F) of the locked LOCATION with the longest path is blocked
-- When only one LOCATION remains at a SUPERPOSITION with no additional branches it is DESTINATION
-- if multiple LOCATIONS exist in a SUPERPOSITION set, each with no new branches
-- one is DESTINATION with a LOCK
-- one contains the KEY
-- remaining are death or CONCLUSIONS
-- LOCATIONS not represented in the SUPERPOSITION SUBSET can be CONCLUSIONs and force retries
-- additionally LOCKS interacted with without their keys can be fatal

-- LABYRINTH instantiates the maze itself, causing creation of ORIGIN and its child positions and so on
-- LABYRINTH then instantiates SUPERPOSITIONS which mint LOCKS and KEYS and assign them to their SETS
-- at every SUPERPOSITION with more than one LOCATION

-- {{ORIGIN}, {SET}, {SET}, {SET}, {SET}}

local key = include('lib/labyrinth/key')
local location = include('lib/labyrinth/location')
local lock = include('lib/labyrinth/lock')
local superposition = include('lib/labyrinth/superposition')

local Labyrinth = {}

function Labyrinth:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  instance.__index = self
  return instance
end

return Labyrinth