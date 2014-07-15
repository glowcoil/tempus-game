require 'traits/graphical'

function solid(x, y)
  return entity({ x = x, y = y, width = 16, height = 16, solid = true })
end