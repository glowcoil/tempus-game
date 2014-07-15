function platformSpawner(x, y, id, upsideDown)
  local b = {}
  b.solid = true
  
  function b:load()
    self.id = id
    self.upsideDown = upsideDown
    self.image:setMode("once")
    self.image:setSpeed(.25)
  end
  
  function b:update()
    if self:intersects(0, -1, "crate") or (self.friend and not self.friend.depressed) then
      self.image:seek(1)
      self.image:setSpeed(0)
    elseif self.image.speed == 0 then
      self.image:setSpeed(.25)
      self.image:seek(1)
    elseif self.image:getCurrentFrame() == 7 then
      local c = crate(self.x, self.y - 16)
      c:load()
      self.map:add(c)
    end
  end
  
  return entity(graphical("resources/materials/solids/boxspawner.png", x, y, true, 16, 16, .1, 7), moving(false), b)
end