require 'traits/graphical'
require 'traits/moving'

function spikedMovingPlatform(x, y, xVelocity, yVelocity)
  local p = {}
  p.movingPlatform = true
  
  function p:load()
    self.image = love.graphics.newImage("resources/materials/dynamics/moving_plat_spikes.png")
    self.image:setFilter("nearest", "nearest")
    self.death = true
    
    self.xVelocity = xVelocity or 0
    self.yVelocity = yVelocity or 0
  end
  
  function p:update()
  end
  
  function p:draw()
  end
  
  return entity(graphical("resources/materials/dynamics/moving_plat_on.png", x, y), moving(false), p)
end