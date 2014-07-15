require 'traits/graphical'
require 'traits/moving'

function crate(x, y)
  local c = {}
  
  function c:load()
  end
  function c:update()
    movingPlatformUpdate(self)
    if math.abs(self.xVelocity) < .01 then
      self.xVelocity = 0
    elseif self:intersectsSolid(0, 1) then
      self.xVelocity = self.xVelocity * .9
    else
      self.xVelocity = self.xVelocity * .999
    end
    
    if self:intersects(0, 0, "death") then
      self.map:remove(self)
    end
  end
  
  return entity(graphical("resources/materials/dynamics/crate.png", x, y), moving(true), { crate = true, solid = true, oneWay = true }, c)
end