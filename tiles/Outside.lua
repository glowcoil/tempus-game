local quads = {}
for i = 1, 71 do
  quads[i] = love.graphics.newQuad(
    (i - 1) % 24 * 16,
    math.floor((i - 1) / 24) * 16,
    16, 16,
    384, 48
  )
end

return "tiles/Outside.png", quads