require 'entity'
require 'entities/guy'
require 'entities/solid'
require 'entities/ladder'
require 'entities/crate'
require 'entities/onewaysolid'
require 'entities/temporalcrate'
require 'entities/movingplatform'
require 'entities/spikesup'
require 'entities/spikesdown'
require 'entities/button'
require 'entities/forcefield'
require 'entities/boxspawner'
require 'entities/enemy'
require 'entities/door'
require 'entities/spikedmovingplatform'
require 'map'
require 'maps'

deltaTime = 1 / 120

currentMap = 0

function die()
  m = maps[currentMap]()
  m:load()
end

function nextMap()
  if maps[currentMap + 1] then
    currentMap = currentMap + 1
    die()
  else
    currentMap = 0
    m = nil
  end
end

function love.load()
  sound = love.audio.newSource("resources/timeshift.ogg")
  sound:setLooping(true)
  love.audio.play(sound)
  
  love.graphics.setMode(640, 480)
  love.graphics.setCaption("Tempus")
  
  splash = love.graphics.newImage("resources/splash.png")
  splash:setFilter("nearest", "nearest")
end

accumulator = 0
function love.update(dt)
  deltaTime = dt
  --accumulator = accumulator + dt
  --while accumulator > deltaTime do
  if currentMap == 0 then
    if love.keyboard.isDown("x") then
      nextMap()
    end
  else
    m:update()
  end
  --  accumulator = accumulator - deltaTime
  --end
  --dd = dt
end

function love.draw()
  if currentMap == 0 then
    love.graphics.push()
    love.graphics.scale(2, 2)
    love.graphics.draw(splash, 0, 0)
    love.graphics.pop()
  else
    m:draw()
    --love.graphics.print(tostring(love.timer.getFPS()), 0, 0)
  end
end

function love.keypressed(key)
  if currentMap > 0 then
    m:keypressed(key)
  end
end
function love.keyreleased(key)
  if currentMap > 0 then
    m:keyreleased(key)
  end
end