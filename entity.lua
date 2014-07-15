function entity(...)
  local e = {}
  e.loads = {}
  e.updates = {}
  e.draws = {}
  e.keypresseds = {}
  e.keyreleaseds = {}
  
  e.depth = 0
  
  for _,trait in ipairs({...}) do
    for k,v in pairs(trait) do
      if k == "load" then
        table.insert(e.loads, v)
      elseif k == "update" then
        table.insert(e.updates, v)
      elseif k == "draw" then
        table.insert(e.draws, v)
      elseif k == "keypressed" then
        table.insert(e.keypresseds, v)
      elseif k == "keyreleased" then
        table.insert(e.keyreleaseds, v)
      else
        e[k] = v
      end
    end
  end
  
  function e:load()
    for _,load in ipairs(self.loads) do
      load(self)
    end
  end
  function e:update()
    for _,update in ipairs(self.updates) do
      update(self)
    end
  end
  function e:draw()
    for _,draw in ipairs(self.draws) do
      draw(self)
    end
  end
  function e:keypressed(key)
    for _,keypressed in ipairs(self.keypresseds) do
      keypressed(self, key)
    end
  end
  function e:keyreleased(key)
    for _,keyreleased in ipairs(self.keyreleaseds) do
      keyreleased(self, key)
    end
  end
  
  return e
end

--[[
loads = {}
function registerLoad(fun)
  table.insert(loads, fun)
end
function load()
  for _,load in ipairs(loads) do
    load()
  end
end

updates = {}
function registerUpdate(fun)
  table.insert(updates, fun)
end
function update()
  for _,update in ipairs(updates) do
    update()
  end
end

draws = {}
function registerDraws(fun)
  table.insert(draws, fun)
end
function draw()
  for _,draw in ipairs(draws) do
    draw()
  end
end
--]]