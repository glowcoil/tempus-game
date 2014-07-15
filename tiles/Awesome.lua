local quads = {}
for i = 1, 14 do
  quads[i] = love.graphics.newQuad(
    (i - 1) % 14 * 16,
    math.floor((i - 1) / 14) * 16,
    16, 16,
    224, 16
  )
end

return "tiles/Awesome.png", quads