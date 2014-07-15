require 'traits/graphical'
require 'traits/moving'

function movingPlatform(x, y, xVelocity, yVelocity, id)
  local p = {}
  p.solid = true
  p.oneWay = true
  p.movingPlatform = true
  p.id = id
  
  function p:load()
    self.enabledImage = love.graphics.newImage("resources/materials/dynamics/moving_plat_on.png")
    self.enabledImage:setFilter("nearest", "nearest")
    self.disabledImage = love.graphics.newImage("resources/materials/dynamics/moving_plat_off.png")
    self.disabledImage:setFilter("nearest", "nearest")
    
    self.disabled = false
    
    self.xVelocity = xVelocity or 0
    self.yVelocity = yVelocity or 0
    self.riders = {}
  end
  
  function p:update()
    if (not self.friend) or self.friend.depressed then
      self.disabled = false
      self.image = self.enabledImage
      local slowdown = self:slowdown()
      self.riders = {}
      function move(onTops, previousOnTop)
        for _,onTop in ipairs(onTops) do
          if onTop.yVelocity >= 0 and math.abs(onTop.y + onTop.height - previousOnTop.y) < math.abs(self.yVelocity) + math.abs(onTop.yVelocity) + 1 and not onTop.movingPlatform and not (onTop.guy and love.keyboard.isDown("down")) then
            self.riders[onTop] = true
            onTop.y = previousOnTop.y - onTop.height
            if onTop.solid then
              move({onTop:intersects(0, -1, "moving")}, onTop)
            end
          end
        end
      end
      move({self:intersects(0, -1, "moving")}, self)
    
      for onTop,_ in pairs(self.riders) do
        if onTop:intersectsSolid(self.xVelocity, 0) or (onTop.holding and onTop.holding:intersectsSolid(self.xVelocity, 0)) then
          self.xVelocity = -self.xVelocity
          break
        end
      end
      for onTop,_ in pairs(self.riders) do
        local s = onTop:intersectsSolid(0, self.yVelocity) or (onTop.holding and onTop.holding:intersectsSolid(self.yVelocity, 0))
        if s and s ~= self  then
          self.yVelocity = -self.yVelocity
          break
        end
      end
    
      for onTop,_ in pairs(self.riders) do
        onTop.x = onTop.x + self.xVelocity * slowdown
        if onTop.holding then
          onTop.holding.x = onTop.x + onTop.width / 2 - onTop.holding.width / 2
          onTop.holding.y = onTop.y - onTop.holding.height
        end
      end
    else
      self.image = self.disabledImage
      self.disabled = true
    end
  end
  
  function p:draw()
  end
  
  return entity(graphical("resources/materials/dynamics/moving_plat_on.png", x, y), moving(false), p)
end

function movingPlatformUpdate(self)
  local slowdown = self:slowdown()
  self.riders = {}
  function move(onTops, previousOnTop)
    for _,onTop in ipairs(onTops) do
      if onTop.yVelocity >= 0 and math.abs(onTop.y + onTop.height - previousOnTop.y) < math.abs(self.yVelocity) + math.abs(onTop.yVelocity) + 1 and not onTop.movingPlatform and not (onTop.guy and love.keyboard.isDown("down")) then
        self.riders[onTop] = true
        onTop.y = previousOnTop.y - onTop.height
        if onTop.solid then
          move({onTop:intersects(0, -1, "moving")}, onTop)
        end
      end
    end
  end
  move({self:intersects(0, -1, "moving")}, self)

  for onTop,_ in pairs(self.riders) do
    if onTop:intersectsSolid(self.xVelocity, 0) or (onTop.holding and onTop.holding:intersectsSolid(self.xVelocity, 0)) then
      self.xVelocity = -self.xVelocity
      break
    end
  end
  for onTop,_ in pairs(self.riders) do
    onTop.x = onTop.x + self.xVelocity * slowdown
    if onTop.holding then
      onTop.holding.x = onTop.x + onTop.width / 2 - onTop.holding.width / 2
      onTop.holding.y = onTop.y - onTop.holding.height
    end
  end
end