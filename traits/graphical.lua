require 'AnAL'

function graphical(path, x, y, animated, width, height, speed, frameCount)
  local g = {}
  
  function g:load()
    self.x = x
    self.y = y
    local image = love.graphics.newImage(path)
    image:setFilter("nearest", "nearest")
    if animated then
      self.image = newAnimation(image, width, height, speed, frameCount)
      self.width = width
      self.height = height
    else
      self.image = image
    end
    if not animated then
      self.width = self.image:getWidth()
      self.height = self.image:getHeight()
    end
    self.saturation = 255
    self.depth = 0
  end
  if animated then
    function g:update()
      self.image:update(deltaTime)
    end
    function g:draw()
      love.graphics.setColor(self.saturation, self.saturation, self.saturation)
      self.image:draw(math.ceil(self.x), math.ceil(self.y))
    end
  else
    function g:draw()
      love.graphics.setColor(self.saturation, self.saturation, self.saturation)
      love.graphics.draw(self.image, math.ceil(self.x), math.ceil(self.y))
      love.graphics.setColor(255, 255, 255)
    end
  end
  
  return g
end

function math.round(x)
  if x % 1 >= .5 then
    return math.ceil(x)
  else
    return math.floor(x)
  end
end