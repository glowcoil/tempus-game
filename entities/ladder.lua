require 'traits/graphical'
require 'traits/moving'

function ladder(x, y)
  return entity(graphical("resources/materials/solids/ladder.png", x, y), { ladder = true })
end