function door(x, y)
  local d = {}
  d.door = true
  
  function d:load()
    self.image = love.graphics.newImage("resources/materials/door.png")
    self.image:setFilter("nearest", "nearest")
    self.x = x
    self.y = y
    self.width = 24
    self.height = 32
  end
  
  function d:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 4, 0)
  end
  
  return entity(moving(false), d)
end