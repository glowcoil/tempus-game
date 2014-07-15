function enemy(x, y)
  local g = {}
  g.enemy = true
  g.death = true
  
  function g:load()
    self.image:setSpeed(.5)
    self.xVelocity = 2.1
  end
  function g:update()
    if self:intersects(0, 0, "death") then
      self.map:remove(self)
    end
  end
  
  return entity(graphical("resources/materials/dynamics/goomba_strip.png", x, y, true, 16, 16, .1, 2), moving(true), g)
end