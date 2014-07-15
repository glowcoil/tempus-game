require 'entity'

registerLoad(function()
end)
registerUpdate(function()
end)

function moving(x, y, gravity)
  local p = {}
  
  function p:load()
    self.x = x
    self.y = y
    self.width  = self.image:getWidth()
    self.height = self.image:getHeight()
    self.xVelocity = 0
    self.yVelocity = 0
  end
  function p:update()
    if gravity then
      self.yVelocity = self.yVelocity + .01
    end
    
    local i, x, y = self:intersects(self.s)
    if not i then
      self.x = self.x + self.xVelocity
      self.y = self.y + self.yVelocity
    else
      self.x = x
      self.y = y
    end
  end
  
  -- intersects, x, y
  function p:intersects(other)
    if  self.xVelocity == 0 and  self.yVelocity == 0 and -- the objects are not moving
       other.xVelocity == 0 and other.yVelocity == 0 then
      if self.x + self.width  > other.x and self.x < other.x + other.width and
         self.y + self.height > other.y and self.y < other.y + other.height then
        return true, self.x, self.y
      else
        return false
      end
    else -- the objects are moving
      local xt1 = ((other.x + other.width) - self.x) / (self.xVelocity - other.xVelocity)
      local xt2 =  (other.x - (self.x + self.width)) / (self.xVelocity - other.xVelocity)
      if xt1 > xt2 then xt1, xt2 = xt2, xt1 end
      
      local yt1 = ((other.y + other.height) - self.y) / (self.yVelocity - other.yVelocity)
      local yt2 =  (other.y - (self.y + self.height)) / (self.yVelocity - other.yVelocity)
      if yt1 > yt2 then yt1, yt2 = yt2, yt1 end
      
      if xt2 > yt1 and xt1 < yt2 then -- the objects are intersecting
        if xt1 < deltaTime and yt1 < deltaTime then -- the paths intersect within the timeframe
          if xt1 < 0 and yt1 < 0 then -- the objects were already intersecting
            return true, self.x, self.y
          else -- a normal collision
            return true, self.x + (xVelocity * xt1) - 1, self.y + (yVelocity * yt1) - 1
          end
        end
      else -- the objects are not intersecting
        return false
      end
    end
  end
  
  return p
end