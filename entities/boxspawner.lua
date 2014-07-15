function spawner(x, y, id, flipped, product, productString)
  local b = {}
  b.solid = true
  b.id = id
  
  function b:load()
    self.image:setMode("once")
    self.image:setSpeed(.1)
  end
  
  function b:update()
    local collOffset, createOffset
    if flipped then collOffset = self.height else collOffset = -1 end
    if flipped then createOffset = 17 else createOffset = -16 end
    --[[if self.friend then
      if self.friend.depressed then
        if self:intersects(0, collOffset, productString) then
          self.image:seek(1)
          self.image:setSpeed(0)
        elseif self.image:getCurrentFrame() == 7 then
          local c = product(self.x, self.y + createOffset)
          c:load()
          self.map:add(c)
          self.image:seek(1)
          self.image:setSpeed(.1)
        else
          self.image:setSpeed(.1)
        end
      else
        if self:intersects(0, collOffset, productString) then
          self.image:seek(1)
          self.image:setSpeed(0)
        else
          self.image:setSpeed(.1)
        end
      end
    else--]]
    if self:intersects(0, collOffset, productString) then
      self.image:seek(1)
      self.image:setSpeed(0)
    else
      self.image:setSpeed(.1)
      if self.image:getCurrentFrame() == 7 then
        if not self.friend or (self.friend and self.friend.depressed) then
          local c = product(self.x, self.y + createOffset)
          c:load()
          self.map:add(c)
          self.image:seek(1)
          self.image:setSpeed(.1)
          self.image:play()
        end
      end
    end
    --end
  end
  
  function b:draw()
  end
  
  if flipped then 
    return entity(graphical("resources/materials/solids/upsidedownboxspawner.png", x, y, true, 16, 16, .1, 7), moving(false), b)
  else
    return entity(graphical("resources/materials/solids/boxspawner.png", x, y, true, 16, 16, .1, 7), moving(false), b)
  end
end