require 'entity'

function moving(gravity)
  local p = {}
  p.moving = true
  
  function p:load()
    self.xVelocity = self.xVelocity or 0
    self.yVelocity = self.xVelocity or 0
    self.gravity = gravity
  end
  function p:update()    
    local slowdown = self:slowdown()
    self.saturation = 255 * slowdown
    
    if self.gravity then
      self.yVelocity = self.yVelocity + .2 * slowdown
    end
    
    local other
    
    other = self:intersectsSolid(self.xVelocity, 0) or (self.holding and self.holding:intersectsSolid(self.xVelocity, 0))
    if other and (not other.oneWay or self.movingPlatform) then
      if self.xVelocity > 0 then
        self.x = other.x - self.width
      elseif self.xVelocity < 0 then
        self.x = other.x + other.width
      end
      if self.movingPlatform or self.enemy then
        self.xVelocity = -self.xVelocity
      else
        self.xVelocity = 0
      end
    elseif not self.disabled then
      self.x = self.x + (self.xVelocity * slowdown)
    end
    other = self:intersectsSolid(0, self.yVelocity)
    if other then
      if self.yVelocity > 0 then
        self.y = other.y - self.height
      elseif self.yVelocity < 0 then
        self.y = other.y + other.height
      end
      if self.movingPlatform then
        self.yVelocity = -self.yVelocity
        self.y = self.y + self.yVelocity
      else
        self.yVelocity = 0
      end
    elseif self.holding then
      other = self.holding:intersectsSolid(0, self.yVelocity)
      if other then
        if self.yVelocity < 0 then
          self.y = other.y + other.height + self.holding.height
          self.yVelocity = 0
        else
          self.y = self.y + (self.yVelocity * slowdown)
        end
      else
        self.y = self.y + (self.yVelocity * slowdown)
      end
    elseif not self.disabled then
      self.y = self.y + (self.yVelocity * slowdown)
    end
    
    local solid = self:intersectsSolid(0, 1)
    if solid and self.yVelocity >= 0 then
      self.gravity = false
    elseif gravity then
      self.gravity = true
    end
  end
  
  function p:intersectsWith(other, xOffset, yOffset)
    return self.x + xOffset < other.x + other.width and self.x + xOffset + self.width > other.x
       and self.y + yOffset < other.y + other.height and self.y + yOffset + self.height > other.y
  end
  function p:intersects(xOffset, yOffset, condition)
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    return self.map:intersects(self, xOffset, yOffset, condition)
  end
  
  function p:intersectsSolid(xOffset, yOffset)
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    local others = {self:intersects(xOffset, yOffset, "solid")}
    local results = {}
    for _,other in ipairs(others) do
      if not other.oneWay then
        table.insert(results, other)
      elseif other.oneWay and ((yOffset > 0 and self.y + yOffset + self.height > other.y and self.y + yOffset + self.height - other.y <= yOffset) and not (self.climbing and self:intersects(0, other.y - self.y, "ladder")) and not (self.guy and love.keyboard.isDown("down"))) then
        table.insert(results, other)
      end
    end
    return unpack(results)
  end
  
  function p:slowdown()
    return self.map:slowdown(self)
  end
  
  return p
end