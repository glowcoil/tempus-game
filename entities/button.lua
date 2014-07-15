function button(x, y, id)
  local b = {}
  b.solid = true
  b.button = true
  b.id = id
  
  function b:load()
    self.normalImage = love.graphics.newImage("resources/materials/solids/button.png")
    self.normalImage:setFilter("nearest", "nearest")
    self.depressedImage = love.graphics.newImage("resources/materials/solids/buttondepressed.png")
    self.depressedImage:setFilter("nearest", "nearest")
    self.depressed = false
  end
  
  function b:update()
    local m = self:intersects(0, -1, "moving")
    if m then
      self.y = y + 10
      m.y = self.y - m.height
      self.image = self.depressedImage
      self.depressed = true
    else
      self.y = y + 8
      self.image = self.normalImage
      self.depressed = false
    end
  end
  
  return entity(graphical("resources/materials/solids/button.png", x, y + 8), moving(false), b)
end