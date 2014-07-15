function forceField(x, y, id, flipped)
  local f = {}
  f.solid = true
  f.id = id
  
  function f:load()
    self.normalImage = love.graphics.newImage("resources/materials/solids/force_field.png")
    self.normalImage:setFilter("nearest", "nearest")
    self.offImage = love.graphics.newImage("resources/materials/solids/force_field_off.png")
    self.offImage:setFilter("nearest", "nearest")
  end
  
  if flipped then
    function f:update()
      if self.friend and self.friend.depressed then
        self.y = y
        self.image = self.normalImage
      else
        self.y = y + 60
        self.image = self.offImage
      end
    end
  else
    function f:update()
      if self.friend and self.friend.depressed then
        self.y = y + 60
        self.image = self.offImage
      else
        self.y = y
        self.image = self.normalImage
      end
    end
  end
  
  return entity(graphical("resources/materials/solids/force_field.png", x, y), f)
end