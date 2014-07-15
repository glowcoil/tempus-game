require 'codes'

function map(tileset, tileWidth, tileHeight, mapWidth, mapHeight, tiles, bounds, codes, quads)
  local m = {}
  m.entities = {}
  
  for _,v in pairs(m.entities) do
    v.map = m
  end
  
  function m:add(...)
    for _,v in ipairs({...}) do
      table.insert(self.entities, v)
      v.map = m
    end
  end
  function m:remove(...)
    for _,a in ipairs({...}) do
      for i,b in ipairs(self.entities) do
        if a == b then
          table.remove(self.entities, i)
        end
      end
    end
  end
  
  function m:setFollow(e)
    self.follow = e
  end
  
  function m:load()
    self.background = love.graphics.newImage("resources/materials/Skyline.png")
    self.background:setFilter("nearest", "nearest")
    --self.backgroundQuad = love.graphics.newQuad(0, 0, mapWidth * tileWidth, mapHeight * tileWidth, self.background:getWidth(), self.background:getHeight())
    
    for _,e in ipairs(self.entities) do
      e.depth = e.depth or 0
    end
    
    if tileset and tiles and bounds and codes then
      self.image = love.graphics.newImage(tileset)
      self.image:setFilter("nearest", "nearest")
      self.tileBatch = love.graphics.newSpriteBatch(self.image, mapWidth * mapHeight)
      for y = 0, mapHeight - 1 do
        for x = 0, mapWidth - 1 do
          local tileX, tileY = x * tileWidth, y * tileHeight
        
          if tiles[y][x] then self.tileBatch:addq(tiles[y][x], tileX, tileY) end
        
          if bounds[y][x] == 1 then
            self:add(oneWaySolid(tileX, tileY))
          elseif bounds[y][x] ~= 0 then
            self:add(solid(tileX, tileY))
          end
          
          if codes[y][x] then
            if codesAndKeys[codes[y][x]] then
              local e = codesAndKeys[codes[y][x]](tileX, tileY)
              self:add(e)
              if e.guy then
                self:setFollow(e)
              end
            elseif string.sub(codes[y][x], 1, 1) == "A" then
              self:add(button(tileX, tileY, string.sub(codes[y][x], 2, 2)))
            elseif string.sub(codes[y][x], 1, 1) == "B" then
              self:add(forceField(tileX, tileY, string.sub(codes[y][x], 2, 2), false))
            elseif string.sub(codes[y][x], 1, 1) == "9" then
              self:add(forceField(tileX, tileY, string.sub(codes[y][x], 2, 2), true))
            elseif string.sub(codes[y][x], 1, 1) == "C" then
              self:add(movingPlatform(tileX, tileY, .5, 0, string.sub(codes[y][x], 2, 2)))
            elseif string.sub(codes[y][x], 1, 1) == "D" then
              self:add(movingPlatform(tileX, tileY, 0, .5, string.sub(codes[y][x], 2, 2)))
            elseif string.sub(codes[y][x], 1, 1) == "E" then
              self:add(spawner(tileX, tileY, string.sub(codes[y][x], 2, 2), false, crate, "crate"))
            elseif string.sub(codes[y][x], 1, 1) == "F" then
              self:add(spawner(tileX, tileY, string.sub(codes[y][x], 2, 2), true, crate, "crate"))
            elseif string.sub(codes[y][x], 1, 1) == "8" then
              self:add(spawner(tileX, tileY, string.sub(codes[y][x], 2, 2), false, enemy, "enemy"))
            elseif string.sub(codes[y][x], 1, 1) == "7" then
              self:add(spawner(tileX, tileY, string.sub(codes[y][x], 2, 2), true, enemy, "enemy"))
            end
            for _,a in ipairs(self.entities) do
              if a.id then
                for _,b in ipairs(self.entities) do
                  if b.id then
                    if a.id == b.id and a ~= b then
                      if b.button then
                        a.friend = b
                      elseif a.button then
                        b.friend = a
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      table.sort(self.entities, function(a, b) return a.depth > b.depth end)
    end
    
    for _,v in ipairs(self.entities) do
      v:load()
    end
  end
  function m:update()
    for _,v in ipairs(self.entities) do
      v:update()
    end
  end
  function m:draw()
    love.graphics.push()
    love.graphics.scale(2, 2)
    
    if self.follow then
      love.graphics.translate(clamp(160 - (math.ceil(self.follow.x) + (self.follow.width / 2)), -(mapWidth * 16) + 320, 0), clamp(120 - (math.ceil(self.follow.y) + (self.follow.height / 2)), -(mapHeight * 16) + 240, 0))
    end
    
    for x = 0, (mapWidth * 16) - self.background:getWidth(), self.background:getWidth() do
      love.graphics.draw(self.background, x, -mapHeight * 16, 0, 1, 2 * (mapHeight * 16) / self.background:getHeight())
    end
    
    love.graphics.draw(self.tileBatch, 0, 0)
    for _,v in ipairs(self.entities) do
      v:draw()
    end
    
    love.graphics.pop()
  end
  function m:keypressed(key)
    if key == "r" then
      die()
    end
    for _,v in ipairs(self.entities) do
      v:keypressed(key)
    end
  end
  function m:keyreleased(key)
    for _,v in ipairs(self.entities) do
      v:keyreleased(key)
    end
  end
  
  function m:intersects(a, xOffset, yOffset, condition)
    local others = {}
    for _,b in ipairs(self.entities) do
      if a ~= b and a:intersectsWith(b, xOffset, yOffset) and (not condition or (condition and b[condition])) then
        table.insert(others, b)
      end
    end
    ---[[
    local distances = {}
    for _,v in ipairs(others) do
      distances[v] = math.sqrt(((v.x + (v.width / 2)) - (a.x + (a.width / 2)))^2 + ((v.y + (v.height / 2)) - (a.y + (a.height / 2)))^2)
    end
    table.sort(others, function(b, c) return distances[b] < distances[c] end)--]]
    return unpack(others)
  end
  
  function m:slowdown(a)
    if a.guy then
      return 1
    else
      local s = 1
      for _,b in ipairs(self.entities) do
        if b.temporal and a ~= b then
          local distance = math.sqrt(((b.x + (b.width / 2)) - (a.x + (a.width / 2)))^2 + ((b.y + (b.height / 2)) - (a.y + (a.height / 2)))^2)
          if distance > 127 then
            factor = 1
          else
            factor = 1 - (1 / (1.0001 + .001 * distance))
          end
          s = s * factor
        end
      end
      
      return s
    end
  end
  
  return m
end

function clamp(x, min, max)
  if x < min then
    return min
  elseif x > max then
    return max
  else
    return x
  end
end