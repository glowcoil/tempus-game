require 'traits/graphical'
require 'traits/moving'
require 'AnAL'

function guy(x, y)
  local g = {}
  g.guy = true
  g.depth = -1
  
  function g:load()
    local standingImage = love.graphics.newImage("brostand.png")
    standingImage:setFilter("nearest", "nearest")
    self.standingImage = newAnimation(standingImage, 18, 25, 0, 0)
    local walkingImage = love.graphics.newImage("browalk.png")
    walkingImage:setFilter("nearest", "nearest")
    self.walkingImage = newAnimation(walkingImage, 19, 25, .1, 4)
    local holdingImage = love.graphics.newImage("brocarry.png")
    holdingImage:setFilter("nearest", "nearest")
    self.holdingImage = newAnimation(holdingImage, 18, 25, 0, 0)
    local holdingWalkingImage = love.graphics.newImage("browalkcarry.png")
    holdingWalkingImage:setFilter("nearest", "nearest")
    self.holdingWalkingImage = newAnimation(holdingWalkingImage, 19, 25, .1, 0)
    local climbingImage = love.graphics.newImage("resources/materials/broclimb.png")
    climbingImage:setFilter("nearest", "nearest")
    self.climbingImage = newAnimation(climbingImage, 18, 25, .1, 2)
    
    self.image = self.walkingImage
    
    self.direction = 1
    
    self.x = x
    self.y = y
    self.width = 16
    self.height = standingImage:getHeight()
    self.saturation = 255
    self.depth = 0
    
    self.climbing = false
    self.holding = false
    self.walkingVelocity = 2
    self.climbingVelocity = 1
  end
  
  function g:update()
    local slowdown = self:slowdown()
    self.guy = false
    local sl = self:slowdown()
    self.guy = true
    sound:setPitch(.5 + sl / 2)
    
    -- holding something
    if self.holding then
      self.holding.x = self.x + self.width / 2 - self.holding.width / 2
      self.holding.y = self.y - self.holding.height
      self.holding.gravity = false
      self.holding.xVelocity = 0
      self.holding.yVelocity = 0
    end
    
    -- dying
    if self:intersects(0, 0, "death") then
      die()
    end
    
    -- walking
    if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
      if not (self.climbing and (love.keyboard.isDown("up") or love.keyboard.isDown("down"))) and not self:intersectsSolid(self.walkingVelocity, 0) and not (self.holding and self.holding:intersectsSolid(self.walkingVelocity, 0)) then
        self.xVelocity = self.xVelocity + .1 * slowdown
      end
    elseif love.keyboard.isDown("left") and not love.keyboard.isDown("right") and not self:intersectsSolid(-self.walkingVelocity, 0) and not (self.holding and self.holding:intersectsSolid(-self.walkingVelocity, 0)) then
      if not (self.climbing and (love.keyboard.isDown("up") or love.keyboard.isDown("down"))) then
        self.xVelocity = self.xVelocity - .1 * slowdown
      end
    else
      if math.abs(self.xVelocity) < .01 then
        self.xVelocity = 0
      elseif self:intersectsSolid(0, 1) or self:intersects(0, 0, "ladder") then
        self.xVelocity = self.xVelocity * .75
      else
        self.xVelocity = self.xVelocity * .975
      end
    end
    
    -- falling off a ladder
    if self.climbing then
      local ladder = true
      local l = self:intersects(0, 1, "ladder")
      if l then
        local xDistance = (l.x + (l.width / 2)) - (self.x + (self.width / 2))
        if math.abs(xDistance) > self.width * 2 / 3 then
          ladder = false
        end
        if self:intersectsSolid(0, 1) and not love.keyboard.isDown("up") then
          ladder = false
        end
      else
        ladder = false
      end
      if not ladder then
        self.yVelocity = 0
        self.climbing = false
      end
    end
    
    -- climbing
    if love.keyboard.isDown("up") or love.keyboard.isDown("down") then
      local l = self:intersects(0, 0, "ladder")
      if l and self:intersects(0, -self.height + 1, "ladder") then
        local xDistance = (l.x + (l.width / 2)) - (self.x + (self.width / 2))
        if math.abs(xDistance) < self.width * 2 / 3 then
          self.climbing = true
          if math.abs(xDistance) < self.walkingVelocity then
            self.x = self.x + xDistance
            self.xVelocity = 0
            if love.keyboard.isDown("up") then
              if self:intersects(0, -self.height - self.climbingVelocity, "ladder") then
                self.yVelocity = -self.climbingVelocity
              else
                self.yVelocity = 0
                self.y = l.y
              end
            elseif love.keyboard.isDown("down") and not self:intersectsSolid(0, self.climbingVelocity) then
              self.yVelocity = self.climbingVelocity
            end
          else
            self.yVelocity = 0
            if xDistance > 0 then self.xVelocity = self.walkingVelocity * 3 / 4
            elseif xDistance < 0 then self.xVelocity = -self.walkingVelocity * 3 / 4 end
          end
        end
      end
    elseif self.climbing then
      self.yVelocity = 0
    end
    
    if self.climbing then
      self.gravity = false
    end
    
    if self.xVelocity > self.walkingVelocity then
      self.xVelocity = self.walkingVelocity
    elseif self.xVelocity < -self.walkingVelocity then
      self.xVelocity = -self.walkingVelocity
    end
    
    -- images
    if self.climbing then
      self.image = self.climbingImage
      if yVelocity ~= 0 then
        self.image:setSpeed(.25)
      else
        self.image:setSpeed(0)
      end
      self.image:update(deltaTime)
    elseif self:intersectsSolid(0, 1) and self.yVelocity >= 0 then
      if self.xVelocity == 0 then
        if self.holding then
          self.image = self.holdingImage
        else
          self.image = self.standingImage
        end
      else
        if self.holding then
          self.image = self.holdingWalkingImage
        else
          self.image = self.walkingImage
        end
        self.image:update(deltaTime)
      end
      self.image:setSpeed((math.abs(self.xVelocity) / self.walkingVelocity) * slowdown)
    else
      self.image = self.holdingImage
    end
    if self.xVelocity > 0 then
      self.direction = 1
    elseif self.xVelocity < 0 then
      self.direction = -1
    end
  end
  
  function g:draw()
    local offset = 0
    if self.direction == -1 then offset = self.width end
    love.graphics.setColor(self.saturation, self.saturation, self.saturation)
    self.image:draw(math.ceil(self.x) + offset, math.ceil(self.y), 0, self.direction, 1, 1, 0)
    love.graphics.setColor(255, 255, 255)
  end
  
  function g:keypressed(key)
    local solid = self:intersectsSolid(0, 1)
    if key == "z" and (solid or (self.climbing and not love.keyboard.isDown("down"))) then
      if solid and solid.movingPlatform then self.xVelocity = self.xVelocity + solid.xVelocity end
      self.yVelocity = -4
      self.climbing = false
    end
    if key == "x" then
      if self.holding then
        self:stopHolding()
      elseif self:intersectsSolid(0, 1) then
        c = self:intersects(0, 0, "crate")
        if c and math.abs((self.x + (self.width / 2)) - (c.x + (c.width / 2))) < self.width * 2 / 3 and not c:intersectsSolid(self.x - c.x, self.y - c.y - c.height) then
          self.climbing = false
          self.holding = c
          self.holding.xVelocity = 0
          self.holding.yVelocity = 0
        end
      end
    end
    if key == "up" then
      local d = self:intersects(0, 0, "door")
      if d and math.abs((d.x + d.width / 2) - (self.x + self.width / 2)) < self.width * 2 / 3 then
        nextMap()
      end
    end
  end
  function g:keyreleased(key)
  end
  
  function g:stopHolding()
    self.holding.xVelocity = self.xVelocity * 3
    if self:intersectsSolid(0, 1) then
      self.holding.yVelocity = 0
    else
      self.holding.yVelocity = -4
    end
    self.holding = false
  end
  
  return entity(moving(true), g)
end