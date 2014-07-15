require 'traits/temporal'

function temporalCrate(x, y)
  local c = {}
  c.crate = true
  c.width = 16
  c.height = 16
  c.angle = 0
  
  function c:load()
    self.aura = love.graphics.newImage("alphamask.png")
    self.aura:setFilter("nearest", "nearest")
    self.gravity = false
  end
  
  function c:draw()
    love.graphics.setBlendMode("multiplicative")
    love.graphics.setColorMode("modulate")
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.aura, self.x + self.width / 2, self.y + self.height / 2, self.angle, 1, 1, 128, 128)
    love.graphics.setColorMode("replace")
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBlendMode("alpha")
    self.image:draw(self.x, self.y)
  end
  
  function c:update()
    --self.angle = self.angle - .05
    if math.abs(self.xVelocity) < .01 then
      self.xVelocity = 0
    elseif self:intersectsSolid(0, 1) then
      self.xVelocity = self.xVelocity * .9
    else
      self.xVelocity = self.xVelocity * .999
    end
  end
  
  return entity(graphical("resources/materials/dynamics/TimeMachineStrip.png", x, y, true, 16, 16, .1, 11), moving(true), temporal(), c)
end