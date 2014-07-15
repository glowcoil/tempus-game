local quads = {}
for i = 1, 41 do
  quads[i] = love.graphics.newQuad(
    (i - 1) % 21 * 16,
    math.floor((i - 1) / 21) * 16,
    16, 16,
    336, 32
  )
end

return "tiles/Tiles1.png", quads