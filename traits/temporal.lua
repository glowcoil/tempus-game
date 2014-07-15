function temporal()
  local t = {}
  t.temporal = true
  
  function t:load()
    
  end
  
  function t:draw()   
    --[[ 
    for y = self.y - 32, self.y + 32 do
      for x = self.x - 32, self.x + 32 do
        love.graphics.setColor(0, 0, 255, self.map:slowdownField(x, y))
        love.graphics.point(x, y)
      end
    end
    love.graphics.setColor(255, 255, 255)
    --]]
  end
  
  return t
end